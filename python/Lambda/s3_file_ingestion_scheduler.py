import json
import psycopg2
import boto3
import os
from datetime import datetime
from CloudWatchSNSLogger import CloudWatchSNSLogger

#environment variable
ENV = os.environ.get('ENV')
REGION = os.environ.get('REGION')
JOB_CLASS = os.environ.get('JOB_CLASS')
DO_SECRET_NAME = os.environ.get('DO_SECRET_NAME')
RS_SECRET_NAME = os.environ.get('RS_SECRET_NAME')
JOB_NAME = os.environ.get('JOB_NAME')
logger = None


def lambda_handler(event, context):
    """
    Lambda function to process scheduled file ingestion jobs.
    :return: None
    """

    global logger

    if logger is None:
        account_id = boto3.client("sts").get_caller_identity()["Account"]
    

        #set sns topics  
        sns_info_topic2  = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Info'
        sns_warn_topic2  = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Warn'
        sns_error_topic2 = 'arn:aws:sns:' + REGION + ':' + str(account_id) + ':' + ENV + '-' + JOB_CLASS + '-' + 'Error'
            
        # Set up logging
        logger = CloudWatchSNSLogger(sns_info_topic = sns_info_topic2, sns_warn_topic = sns_warn_topic2, sns_error_topic = sns_error_topic2)

    

    do_conn = None

    try:
        logger.debug(f"Starting scheduler run at {datetime.now()}")

        # Initialize AWS clients
        glue_client = boto3.client('glue', region_name=REGION)

        # Data operations DB connection
        do_secret_json = retrieve_secret(DO_SECRET_NAME)
        do_conn = create_db_connection(do_secret_json)

        # Find configs that should run now based on schedule
        ready_configs = find_ready_configs(do_conn)

        if not ready_configs:
            print("No configs ready to run at this time")
            return {
                'statusCode': 200,
                'body': json.dumps('No configs ready to run')
            }
        logger.debug(f"Found {len(ready_configs)} configs ready to run")


        total_files_processed = 0
        glue_jobs = {}

        # Process each "ready" config
        for config in ready_configs:
            logger.debug(f"Processing config: {config['file_config_name']}")
            
            # Find pending files for this config
            pending_files = find_pending_files(do_conn, config['ingest_config_id'])
            
            if not pending_files:
                logger.debug(f"No pending files for config {config['file_config_name']}")
                continue
            
            logger.debug(f"Found {len(pending_files)} pending files for config {config['file_config_name']}")

            #get glue job name for this config
            glue_job_name = config['glue_job_name']

            # group files to ingest by job_name
            if glue_job_name not in glue_jobs:
                glue_jobs[glue_job_name] = []

            glue_jobs[glue_job_name].extend(pending_files)
            total_files_processed += len(pending_files)

        if glue_jobs: #trigger glue job for each config
            for glue_job_name, log_ids in glue_jobs.items():
                trigger_glue_job(do_conn, glue_client, glue_job_name, log_ids)
        else:
            logger.debug("No files to process.")


        

        logger.info(f"S3 Ingest Scheduler run completed. Processed {total_files_processed} files")
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Successfully processed {total_files_processed} files')
        }
        
    except Exception as e:
        logger.exception(f"Error in scheduler lambda: {str(e)}")
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
   



def find_ready_configs(connection):

    try:
    
        cursor = connection.cursor()

        #find configs that are scheduled to run now
        cursor.execute("""
        SELECT ingest_config_id, file_config_name, glue_job_name
        FROM data_operations.file_ingest_config
        WHERE schedule_type = 'scheduled'
            AND is_active = true
            AND CURRENT_TIMESTAMP BETWEEN effective_start_date AND effective_end_date
            AND (date_part('day', current_date)::varchar = any(string_to_array(schedule_days_of_month_list, ','))
                OR schedule_days_of_month_list = 'any')
            AND (to_char(current_date, 'Dy') = any(string_to_array(schedule_days_of_week_list, ','))
                OR schedule_days_of_week_list = 'any')
            AND (date_part('hour', current_timestamp)::varchar = any(string_to_array(schedule_hours_of_day_list, ','))
                OR schedule_hours_of_day_list = 'any') """)
        
        configs = []
    
    
        for row in cursor.fetchall():
            config = {
            'ingest_config_id': row[0],
            'file_config_name': row[1],
            'glue_job_name' : row[2]
        }
            configs.append(config)
        
        cursor.close()  
        if not configs:
            return None
        
        return configs
        
    except Exception as e:
        logger.exception(f"Error finding ready configs: {str(e)}")
        raise e


def find_pending_files(connection, ingest_config_id):
    
    try:
    
        cursor = connection.cursor()

        cursor.execute("""
            SELECT ingest_log_id
            FROM data_operations.file_ingest_log
            WHERE ingest_config_id = %s
                AND run_status = 'PENDING'
            ORDER BY created_at ASC
        """, (ingest_config_id,))
        
        files = []
        
        
        for row in cursor.fetchall():
            files.append(row[0])
        
        cursor.close()
        if not files:
            return None 
        return files

    except Exception as e:
        logger.exception(f"Error finding pending files: {str(e)}")
        raise e



def trigger_glue_job(connection, glue_client, glue_job_name, log_ids):
    
    try:
        
        cursor = connection.cursor()

        for ingest_log_id in log_ids:
        
            # Update status to RUNNING
            cursor.execute("""
                SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
            """, (ingest_log_id, 'SCHEDULER', 'RUNNING', None, None, None))
        
        connection.commit()
        
        
        # Prepare Glue job arguments
        glue_args = {
            '--JOB_NAME': glue_job_name,
            '--log_ids':','.join(map(str, log_ids)),
            '--DO_SECRET_NAME' : os.environ.get('DO_SECRET_NAME'),
            '--RS_SECRET_NAME' : os.environ.get('RS_SECRET_NAME'),
            '--JOB_CLASS' : os.environ.get('JOB_CLASS'),
            '--ENV' : os.environ.get('ENV'),
            '--REGION' : os.environ.get('REGION')
        }
        
       
        logger.debug(f"Triggering Glue job {glue_job_name} with args: {glue_args}")
        
        
        # Start Glue job
        response = glue_client.start_job_run(
            JobName=glue_job_name,
            Arguments=glue_args
        )
        
        job_run_id = response['JobRunId']
        logger.debug(f"Started 'Glue' job {glue_job_name} with job id: {job_run_id}")
        cursor.close()
    
    except Exception as e:
        logger.exception(f"Error processing ingestion batch process for ingest_log_ids : {log_ids}: {str(e)}")
        
        for ingest_log_id in log_ids:
            # Update status to failed
            cursor.execute("""
                SELECT data_operations.log_ingest_update(%s, %s, %s, %s, %s, %s)
            """, (ingest_log_id, 'SCHEDULER', 'FAILED', None, str(e), 'SCHEDULER'))
        
        connection.commit()
        cursor.close()
        
        raise e
