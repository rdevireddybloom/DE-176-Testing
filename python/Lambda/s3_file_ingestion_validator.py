import json
import psycopg2
import boto3
import os 
from datetime import datetime
from CloudWatchSNSLogger import CloudWatchSNSLogger

#environment variables
ENV = os.environ.get('ENV')
REGION = os.environ.get('REGION')
JOB_CLASS = os.environ.get('JOB_CLASS')
DO_SECRET_NAME = os.environ.get('DO_SECRET_NAME')
RS_SECRET_NAME = os.environ.get('RS_SECRET_NAME')
JOB_NAME = os.environ.get('JOB_NAME')
logger = None


def lambda_handler(event, context):

    global logger

    if logger is None:
        account_id = boto3.client("sts").get_caller_identity()["Account"]
    

        #set sns topics  
        sns_info_topic2  = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Info'
        sns_warn_topic2  = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Warn'
        sns_error_topic2 = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Error'
            
        # Set up logging
        logger = CloudWatchSNSLogger(sns_info_topic = sns_info_topic2, sns_warn_topic = sns_warn_topic2, sns_error_topic = sns_error_topic2)



    # Initialize database connections
    do_conn = None
    

    try:

        #initialize aws clients
        s3_client = boto3.client('s3')
        glue_client = boto3.client('glue', region_name=REGION)

        #data operations db connection
        do_secret_json = retrieve_secret(DO_SECRET_NAME)
        do_conn = create_db_connection(do_secret_json)

        # process S3 event
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']


        logger.debug(f"Processing file {key} from bucket {bucket}")

        config = find_file_config(do_conn, key)

        if not config:
            logger.debug(f"No configuration found for file {key} in bucket {bucket}")
            process_unmatched_file(do_conn, s3_client, bucket, key)

        else:
            process_matched_file(do_conn, glue_client, config, bucket, key)

    except Exception as e:
        logger.exception(f"Error processing file {key} from bucket {bucket}: {str(e)}")
        raise e


    finally:
        if do_conn:
            do_conn.close()
        



def retrieve_secret(secret_name):
   """Retrieve secrets from AWS Secrets Manager."""
   session = boto3.session.Session()
   client = session.client(service_name='secretsmanager')
   get_secret_value_response = client.get_secret_value(SecretId=secret_name)
   
   return json.loads(get_secret_value_response['SecretString'])


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
    logger.exception(f"Error creating database connection: {str(e)}")
    raise e


def find_file_config(connection, key):
    """Retrieve file ingest configuration from the database."""
    try:
        cursor = connection.cursor()

        
        cursor.execute("""
                SELECT ingest_config_id, file_config_name, glue_job_name, schedule_type
                FROM data_operations.file_ingest_config
                WHERE %s LIKE CONCAT(s3_path_prefix, s3_filename_pattern)
                    AND is_active = true
                    AND CURRENT_TIMESTAMP BETWEEN effective_start_date AND effective_end_date
                """, (key,))

        config_row = cursor.fetchone()

        # Check if a configuration was found
        
        if config_row:
        # Return found config as dictionary
            config = {
                'ingest_config_id': config_row[0],
                'file_config_name': config_row[1],
                'glue_job_name': config_row[2],
                'schedule_type' : config_row[3]
            }
        
            cursor.close()
            
            return config
        else:
            cursor.close()
            return None


    except Exception as e:
        logger.exception(f"Error retrieving file configuration: {str(e)}")
        raise e 


def process_unmatched_file(connection, s3_client, bucket, key):
    """Handle unmatched files by logging and archiving them and deleting from ingest S3 location."""
    try:

        logger.debug(f"Logging unmatched file {key} in bucket {bucket}")

        # Archive the unmatched file
        archive_unmatched_file(s3_client,bucket, key)

        cursor = connection.cursor()

        cursor.execute("""
            INSERT INTO data_operations.file_ingest_log (
                ingest_config_id, s3_bucket, s3_key, run_status,
                error_message, error_step, triggered_by
            ) VALUES (
                -1, %s, %s, 'UNMATCHED FILE',
                'No configuration found for file', 'VALIDATION', 'S3_EVENT'
            )
            """, (bucket, key))
        
        connection.commit()
        cursor.close()

        #delete the unmatched file from s3 location
        s3_client.delete_object(Bucket=bucket, Key=key)
        logger.debug(f"Deleted unmatched file {key} from bucket {bucket}")


    except Exception as e:
        logger.exception(f"Error handling unmatched file {key} in bucket {bucket}: {str(e)}")
        raise e
    

def archive_unmatched_file(s3_client, bucket, key):
    """Archive unmatched files to a specific S3 location."""
    try:
        archive_bucket = os.environ.get('S3_ARCHIVE_BUCKET', 'bloom-dev-data-team')
        archive_prefix = os.environ.get('S3_ARCHIVE_PREFIX', 'file-ingest/unmatched/')

        # Copy the file to the archive location
        archive_key = f"{archive_prefix}{key}"

        s3_client.copy_object(
            Bucket=archive_bucket,
            CopySource={'Bucket': bucket, 'Key': key},
            Key=archive_key
        )

        logger.error(f"Unmatched S3 File Detected and Archived. File: {key} was archived to {archive_bucket}/{archive_key} S3 location. Manually review the file and update the configuration if needed.")

    except Exception as e:
        logger.exception(f"Error archiving unmatched file {key}: {str(e)}")
        raise e


def process_matched_file(connection, glue_client, config, bucket, key):
    """Process matched file for ingestion by logging and triggering Glue job 
    or marking it as pending for later processing."""

    try:
        logger.debug(f"Processing matched file {key} with config {config['file_config_name']}")

        cursor = connection.cursor()
        log_id = None

        if config['schedule_type'] == 'immediate':
            # If immediate, insert log and trigger Glue job and log the ingestion attempt
        
            cursor.execute("""
                SELECT data_operations.log_ingest_start(%s, %s, %s, %s)
                """, (config['ingest_config_id'], bucket, key, 'S3_EVENT'))

            log_id = cursor.fetchone()[0]
            connection.commit()

            # Trigger Glue job
            glue_args = {
                    '--JOB_NAME': config['glue_job_name'],
                    '--DO_SECRET_NAME' : os.environ.get('DO_SECRET_NAME'),
                    '--RS_SECRET_NAME' : os.environ.get('RS_SECRET_NAME'),
                    '--log_ids': str(log_id),
                    '--ENV' : os.environ.get('ENV'),
                    '--REGION' : os.environ.get('REGION'),
                    '--JOB_CLASS' : os.environ.get('JOB_CLASS')

                    }
            

            logger.debug(f"Triggering Glue job {config['glue_job_name']} with args: {glue_args}")

            try:
                # Start Glue job
                response = glue_client.start_job_run(
                JobName=config['glue_job_name'],
                Arguments=glue_args
                    )
                
                job_run_id = response['JobRunId']
                logger.debug(f"Started 'Glue' job {config['glue_job_name']} with job id: {job_run_id}")

                #update logID to Running status
                cursor.execute("""
                    SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                """, (log_id, 'GLUE_TRIGGER', 'RUNNING', None , None, None))
                connection.commit()

            except Exception as e:
                logger.exception(f"Error starting Glue job {config['glue_job_name']}: {str(e)}")
                # Log the error in the file ingest log
                
                cursor.execute("""
                            SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
                        """, (log_id, 'GLUE_TRIGGER', 'FAILED', None, str(e), 'GLUE_TRIGGER'))
                connection.commit()
                raise e
            




        else:
            # If scheduled, just log the file and mark it as pending
            cursor.execute("""
                SELECT data_operations.log_ingest_start(%s, %s, %s, %s)
                """, (config['ingest_config_id'], bucket, key, 'S3_EVENT'))

            log_id = cursor.fetchone()[0]
            connection.commit()


        cursor.close()

    except Exception as e:
        logger.exception(f"Error processing matched file {key} with config {config['file_config_name']}: {str(e)}")
        raise e
    
    
