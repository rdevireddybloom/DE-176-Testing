import json
import psycopg2
import boto3
from datetime import datetime
from awsglue.utils import getResolvedOptions
import sys
from CloudWatchSNSLogger import CloudWatchSNSLogger


def get_job_parameters():
    """Extract job parameters from sys.argv"""

    # Required arguments for the job
    required_args = ['JOB_NAME', 'DO_SECRET_NAME', 'RS_SECRET_NAME', 'ENV', 'JOB_CLASS', 'REGION', 'log_ids']
    

    # Get required args
    args = getResolvedOptions(sys.argv, required_args)
    
    return args
    
    

def get_batch_configs(connection, log_ids):
    """ Get configs anf file details for log_ids"""
    
    try:

        cursor = connection.cursor()
        placeholders = ', '.join(['%s'] * len(log_ids))
        results = []
        
        query = f"""
                SELECT
                        fil.ingest_log_id,
                        fil.ingest_config_id,
                        fil.s3_bucket,
                        fil.s3_key,
                        fil.created_at,
                        fic.file_config_name,
                        fic.glue_job_name,
                        fic.staging_schema,
                        fic.staging_table,
                        fic.target_schema,
                        fic.target_table,
                        fic.iam_role,
                        fic.file_format,
                        fic.delimiter,
                        fic.quote_character,
                        fic.escape_character,
                        fic.ignore_header,
                        fic.null_as,
                        fic.date_format,
                        fic.time_format,
                        fic.encoding,
                        fic.accept_nchars_replacement,                        
                        fic.archive_s3_bucket,
                        fic.archive_s3_prefix
                        
                        FROM data_operations.file_ingest_log fil
                        JOIN data_operations.file_ingest_config fic
                        ON fil.ingest_config_id = fic.ingest_config_id
                        WHERE fil.ingest_log_id IN ({placeholders})
                        AND fil.run_status = 'RUNNING'
                        ORDER BY fil.ingest_config_id, fil.created_at, fil.ingest_log_id
        """
        
        cursor.execute(query, log_ids)
        


        for row in cursor.fetchall():
            batch_data = {
                'ingest_log_id': row[0],
                'ingest_config_id': row[1],
                's3_bucket': row[2],
                's3_key': row[3],
                'created_at': row[4],
                'file_config_name': row[5],
                'glue_job_name': row[6],
                'staging_schema': row[7],
                'staging_table': row[8],
                'target_schema': row[9],
                'target_table': row[10],
                'iam_role': row[11],
                'file_format': row[12],
                'delimiter': row[13],
                'quote_character': row[14],
                'escape_character': row[15],
                'ignore_header': row[16],
                'null_as': row[17],
                'date_format': row[18] if row[18] else "auto",
                'time_format': row[19] if row[19] else "auto",
                'encoding': row[20] if row[20] else "UTF8",
                'accept_nchars_replacement': row[21] if row[21] else '?',
                'archive_s3_bucket': row[22] if row[22] else None,
                'archive_s3_prefix': row[23] if row[23] else None
            }

            results.append(batch_data)

            

        cursor.close()

        if not results:
            return None
        
        return results
        
    except Exception as e:
        logger.exception(f"Error getting batch configs: {str(e)}")
        raise e
        
def retrieve_secrets(secret_name):
    """Retrieve secrets from AWS Secrets Manager."""
    try:
        secrets_client = boto3.client('secretsmanager')
        get_secret_value_response = secrets_client.get_secret_value(SecretId=secret_name)
        secret_json = json.loads(get_secret_value_response['SecretString'])
        return secret_json
    
    except Exception as e:
        raise

def create_db_connection(secret_json):
    """Create a database connection using the provided secrets."""
    try:
        conn = psycopg2.connect(
            user=secret_json["username"],
            password=secret_json["password"],
            host=secret_json["host"],
            port=secret_json["port"],
            database=secret_json["dbname"]
        )
        return conn
    
    except Exception as e:
        raise

def construct_copy_command(config, s3_key):
    """Construct the COPY command for loading data from S3 to Redshift staging table."""

    # Validate file format
    valid_formats = ['CSV', 'TSV', 'PIPE', 'JSON']
    if config.get('file_format').upper() not in valid_formats:
        raise ValueError(f"Invalid file format specified: {config.get('file_format')}. Valid formats are: {valid_formats}")


    # Basic components
    staging_table = f"{config['staging_schema']}.{config['staging_table']}"
    s3_path = f"s3://{config['s3_bucket']}/{s3_key}"

    # Base COPY command
    copy_command = f"""
            COPY {staging_table}
            FROM '{s3_path}'
            IAM_ROLE '{config['iam_role']}'
            """

    file_format = config.get('file_format', 'CSV').upper()
    

    delimiter = config.get('delimiter', ',')

    if file_format in ['CSV', 'TSV', 'PIPE']:
        copy_command += f"""
                    FORMAT AS CSV
                    DELIMITER '{delimiter}'"""

        # Add quote character if provided
        if config.get('quote_character'):
            copy_command += f"\n    QUOTE '{config['quote_character']}'"
    
        # Add escape character if provided  
        if config.get('escape_character'):
            copy_command += f"\n    ESCAPE '{config['escape_character']}'"
    
        # Header handling
        ignore_header = config.get('ignore_header', 0)
        if ignore_header and int(ignore_header) > 0:
            copy_command += f"\n    IGNOREHEADER {ignore_header}"

    elif file_format == 'JSON':
        copy_command += "\n    FORMAT AS JSON 'auto'"

    else:
        logger.debug(f"Unknown file format '{file_format}', defaulting to CSV")
    
        copy_command += f"""
            FORMAT AS CSV
            DELIMITER '{config.get('delimiter', ',')}'"""

    # Add common options

    copy_command += f"""
    NULL AS '{config.get('null_as', 'NULL')}'
    ENCODING {config.get('encoding', 'UTF8')}
    ACCEPTINVCHARS '?'
    TRUNCATECOLUMNS"""

    # Add date/time formats if provided
    if config.get('date_format'):
        copy_command += f"\n    DATEFORMAT '{config['date_format']}'"

    else:
        copy_command += "\n    DATEFORMAT 'auto'"

    if config.get('time_format'):
        copy_command += f"\n    TIMEFORMAT '{config['time_format']}'"

    logger.debug(f"Constructed COPY command: {copy_command}")
    
    return copy_command

def load_file_to_staging(config, s3_key, rs_connection, do_connection, log_id):
    """Load data from S3 to Redshift staging table."""
    
    logger.debug(f"Loading file {s3_key} to staging table {config['staging_schema']}.{config['staging_table']}")

    try:

        rs_cursor = rs_connection.cursor()
        do_cursor = do_connection.cursor()

        log_id = int(config['ingest_log_id'])


        # Construct COPY command

        copy_command = construct_copy_command(config, s3_key)
        full_staging_table = f"{config['staging_schema']}.{config['staging_table']}"

        logger.debug(f"Executing COPY command to {full_staging_table}")
        logger.debug(f"COPY command: {copy_command}")

        # Truncatwe staging table before load
        rs_cursor.execute(f"TRUNCATE TABLE {full_staging_table}")

        # Execute COPY command
        rs_cursor.execute(copy_command)

        # Get row count
        rs_cursor.execute(f"SELECT COUNT(*) FROM {full_staging_table}")
        row_count = rs_cursor.fetchone()[0]
        

        rs_connection.commit()
        rs_cursor.close()
        
        
        

        # Update log - staging load complete

        do_cursor.execute("""
                        SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                        """, (log_id, 'STAGING', 'STAGING_LOAD_COMPLETE', row_count, None, None))

        do_connection.commit()
        do_cursor.close()

        logger.debug(f"Successfully loaded {row_count} rows to staging table")

        return row_count

    except Exception as e:

        logger.exception(f"Error in staging load: {str(e)}")
        

        # Log staging load failure

        try:

            do_cursor = do_connection.cursor()
            do_cursor.execute("""
                              SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                              """, (log_id, 'STAGING', 'FAILED', None, error_msg, 'STAGING_LOAD'))

            do_connection.commit()
            do_cursor.close()

        except Exception as log_error:

            logger.exception(f"Error logging staging failure: {log_error}")

            
        
        raise

def transfer_staging_to_target(config, rs_connection, do_connection, log_id, expected_rows):
    """Transfer data from Redshift staging table to target table"""

    try:

        rs_cursor = rs_connection.cursor()
        do_cursor = do_connection.cursor()
        
        log_id = int(config['ingest_log_id'])


        staging_schema = config['staging_schema']
        staging_table = config['staging_table']
        target_schema = config['target_schema']
        target_table = config['target_table']
        full_staging_table = f"{staging_schema}.{staging_table}"
        full_target_table = f"{target_schema}.{target_table}"
        
        logger.debug(f"Starting transfer from {full_staging_table} to {full_target_table}")

        # Verify staging table has expected data

        rs_cursor.execute(f"SELECT COUNT(*) FROM {full_staging_table}")
        actual_staging_rows = rs_cursor.fetchone()[0]

        logger.debug(f"Staging table has {actual_staging_rows} rows, expected {expected_rows}")

        if actual_staging_rows != expected_rows:
            raise Exception(f"Row count mismatch: expected {expected_rows}, found {actual_staging_rows}")

        # Truncate target table before insert

        rs_cursor.execute(f"TRUNCATE TABLE {full_target_table}")

        # INSERT statement with loaded_at timestamp

        insert_query = f"""
        INSERT INTO {full_target_table}
        SELECT *,
        GETDATE() as last_refreshed_datetime,
        {log_id} as ingest_log_id
        FROM {full_staging_table}
"""

        # Execute the insert

        rs_cursor.execute(insert_query)

        # Get count of inserted rows
        rs_cursor.execute(f"SELECT COUNT(*) FROM {full_target_table}")

        inserted_rows = rs_cursor.fetchone()[0]

        rs_connection.commit()
        rs_cursor.close()

        # Update log - target load complete
        do_cursor.execute("""
                          SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                          """, (log_id, 'TARGET', 'COMPLETED', inserted_rows, None, None))

        do_connection.commit()
        do_cursor.close()

        logger.debug(f"Successfully transferred {inserted_rows} rows to target table")

        return inserted_rows

    except Exception as e:

        logger.exception(f"Error in target load: {str(e)}")
        

        # Log target load failure
        try:
            do_cursor = do_connection.cursor()
            do_cursor.execute("""
                                SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                                """, (log_id, 'TARGET', 'FAILED', None, error_msg, 'TARGET_LOAD'))
            do_connection.commit()
            do_cursor.close()
        
        except Exception as log_error:
            logger.exception(f"Error logging target failure: {log_error}")

        # Rollback Redshift transaction

        try:
            rs_connection.rollback()

        except Exception as rollback_error:

            logger.exception(f"Error rolling back Redshift transaction: {rollback_error}")
            # Log target load failure

        raise

def archive_file(config, do_connection, s3_key):
    """Archive the processed file to S3 if configured"""

    logger.debug(f"Archiving file {s3_key} to archive bucket {config['archive_s3_bucket']}")

    try:

        s3_client = boto3.client('s3')
        
        # Source
        source_bucket = config['s3_bucket']
        source_key = s3_key

        # Destination  
        archive_bucket = config['archive_s3_bucket']
        archive_prefix = config.get('archive_s3_prefix', 'file-ingest/processed/')

        # Ensure prefix ends with /
        if archive_prefix and not archive_prefix.endswith('/'):
            archive_prefix += '/'

        # Create archive key with timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = source_key.split('/')[-1]
        archive_key = f"{archive_prefix}{timestamp}_{filename}"

        # Copy file to archive

        copy_source = {
            'Bucket': source_bucket,
            'Key': source_key
            }

        s3_client.copy_object(
            CopySource=copy_source,
            Bucket=archive_bucket,
            Key=archive_key)

        logger.debug(f"Archived file from s3://{source_bucket}/{source_key} to s3://{archive_bucket}/{archive_key}")
        
        # Delete file from original s3 location
        
        s3_client.delete_object(
            Bucket = source_bucket,
            Key = source_key
            )
            
        logger.debug(f"Deleted original file from s3://{source_bucket}/{source_key}")

    except Exception as archive_error:

        logger.exception(f"Error archiving file: {str(e)}")
        # Log archival failure
        do_cursor = do_connection.cursor()
        do_cursor.execute("""
                            SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                            """, (file_log_id, 'ARCHIVE', 'FAILED', None, str(archive_error), 'ARCHIVE_FILE'))
        do_connection.commit()
        do_cursor.close()

    

if __name__ == "__main__":

    try:

        #get job parameters from sys.argv
        args = get_job_parameters()
        
        
        #setup logger 
        account_id = boto3.client("sts").get_caller_identity()["Account"]
        region = args['REGION']
        env = args['ENV']
        job_class = args['JOB_CLASS']

        # define sns topics   
        sns_info_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Info'
        sns_warn_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Warn'
        sns_error_topic2 = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Error'
                
        # Set up logging
        logger = CloudWatchSNSLogger(sns_info_topic = sns_info_topic2, sns_warn_topic = sns_warn_topic2, sns_error_topic = sns_error_topic2)

        #Get log_ids
        log_ids = [int(log_id.strip()) for log_id in args['log_ids'].split(',')]
        

        logger.debug(f"Starting job {args['JOB_NAME']} with {len(log_ids)} files for ingest_log_ids : {log_ids}")
            
        # Retrieve secrets for data operations and redshift

        do_secret_json = retrieve_secrets(args['DO_SECRET_NAME'])
        rs_secret_json = retrieve_secrets(args['RS_SECRET_NAME'])

        # Create database connections

        do_conn = create_db_connection(do_secret_json)
        rs_conn = create_db_connection(rs_secret_json)

        # Get batch configs for the provided log_ids
        batch_data = get_batch_configs(do_conn, log_ids)
        

        if not batch_data:
            logger.debug("No active ingest logs found for the provided log_ids.")
            sys.exit(0)

        # Group files by config and ingest (same config can process multiple files in ascending order of 'created_at' )
        
        configs_by_id = {}

        for row in batch_data:
            config_id = row['ingest_config_id']  
            if config_id not in configs_by_id:
                configs_by_id[config_id] = {
                'config_info': row,  
                'files': []
            }
            configs_by_id[config_id]['files'].append({
            'log_id': row['ingest_log_id'],
            'bucket': row['s3_bucket'],
            'key': row['s3_key'],
            'created_at': row['created_at']
                })   
                
        



        for config_id, data in configs_by_id.items():
            config_row = data['config_info']   #all config details for the config_id in this dictionary
            files = data['files']  #list of dictionaries with log_id, bucket, key, created_at for each file

            logger.debug(f"\nProcessing {len(files)} files for config ID {config_id} - {config_row['file_config_name']}")

            for file_data in files:
                file_log_id = file_data['log_id']
                s3_key = file_data['key']
                
                logger.debug(f"Processing file {s3_key} for log ID {file_log_id}")


                #Load file to staging
                try:
                    rows_loaded = load_file_to_staging(config_row, s3_key, rs_conn, do_conn, file_log_id)

                    logger.debug(f"Loaded {rows_loaded} rows to staging for file {s3_key}")
                
                except Exception as staging_error:
                    logger.exception(f"Staging load failed for {s3_key}: {staging_error}")
                    
                    continue
                
                
                


                #Transfer staging to target
                try:
                    rows_transferred = transfer_staging_to_target(config_row, rs_conn, do_conn, file_log_id, rows_loaded)

                    logger.debug(f"Transferred {rows_transferred} rows to target for file {s3_key}")
                
                except Exception as target_error:
                    logger.exception(f"Target table load failed for {s3_key}: {target_error}")
                    
                    continue
                
    
                #Archive file if configured
                if not config_row['archive_s3_bucket']:
                    logger.debug(f"No archive bucket configured, skipping archival")
                
                archive_file(config_row, do_conn, s3_key)
                
                if rows_loaded == rows_transferred:  
                    logger.info(f"S3 File {s3_key} has been processed successfully and loaded into Redshift {config_row['target_table']} table.")
        
        logger.debug(f"Job {args['JOB_NAME']} completed its execution.")

    except Exception as e:

        logger.exception(f"Job failed with error: {str(e)}")
       

        # Log job failure
        try:
            do_cursor = do_conn.cursor()
            do_cursor.execute("""
                                SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                                """, (None, 'JOB', 'FAILED', None, str(e), 'JOB_EXECUTION'))
            do_conn.commit()
            do_cursor.close()

        except Exception as log_error:
            logger.exception(f"Error logging job failure: {log_error}")

    finally:
        # Close connections
        if do_conn:
            do_conn.close()
        if rs_conn:
            rs_conn.close()

