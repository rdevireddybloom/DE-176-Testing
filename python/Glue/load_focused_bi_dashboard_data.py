import sys
import re
import psycopg2
import json
import boto3
from botocore.exceptions import ClientError
import pandas as pd
import sqlalchemy as sa
import csv
import logging
from datetime import datetime

# Initialize logging
# Get the root logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Set the minimum logging level

# Create a StreamHandler to output to stdout
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)

# Create a formatter to customize the log message format
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(handler)

# Few variable initializations
s3_data_bucket = 'bloom-dev-data-team'
s3_data_path = 'Focused_BI_Dashboard_Datasets/CTM Tracker/'

s3_archive_data_bucket = 'bloom-dev-data-team'
s3_archive_data_path = 'Focused_BI_Dashboard_Datasets/Archive/'
region_name="us-west-2"
rs_secret_name = 'prod/dw/Redshift/etluser'
sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
quote_char = '"'

# Create a global AWS client
sns_client = boto3.client('sns')
session = boto3.Session()
s3_client = session.client('s3')
secrets_client = session.client(service_name='secretsmanager', region_name=region_name)

now = datetime.now()
file_date = now.strftime("%Y%m%d")

# Function for publishing messages to the AWS SNS service.
def publish_message(topic, message, email_subject):
    """
    Publishes a message to a topic

    :param topic: The topic to publish to
    :param message: The message to publish
    :param email_subject: The subject of the email
    :return: The ID of the message
    """
    try:
        response = sns_client.publish(TopicArn=topic, Message=message, Subject=email_subject)
        message_id = response['MessageId']
        return message_id
    except Exception as e:
        logger.error(f"Failed to publish message to {topic}: {e}")
        raise
        
# Function to trim all string fields in a dataframe and also replace any 
# Microsoft non-breaking space characters with a normal space.
def trim_all_columns_remove_nbsp(df):
    """
    Trim whitespace from ends of each value across all series in dataframe
    """
    try:
        # Vectorized operation to replace non-breaking spaces and trim whitespace
        df = df.applymap(lambda x: x.replace('\xa0', ' ').strip() if isinstance(x, str) else x)
        logger.info("Successfully trimmed all columns and removed non-breaking spaces.")
        return df
    except Exception as e:
        logger.error(f"Failed to trim columns and remove non-breaking spaces: {e}")
        raise
    
def all_columns_remove_item_marker(df):
    """
    Replace invalid utf-8 replacement character from all values with space
    """
    trim_strings = lambda x: x.replace('�', ' ') if isinstance(x, str) else x
    return df.applymap(trim_strings)
    
def retrieve_secrets(secret_name):
    """Retrieve secrets from AWS Secrets Manager."""
    try:
        get_secret_value_response = secrets_client.get_secret_value(SecretId=secret_name)
        secret_json = json.loads(get_secret_value_response['SecretString'])
        logger.info(f"Successfully retrieved secrets for {secret_name}")
        return secret_json
    except Exception as e:
        logger.error(f"Failed to retrieve secrets for {secret_name}: {e}")
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
        logger.info(f"Successfully created database connection to {secret_json['dbname']}")
        return conn
    except Exception as e:
        logger.error(f"Failed to create database connection: {e}")
        raise
    
def move_s3_file(bucket_name, source_key, destination_bucket, destination_key):
    """
    Moves a file within an S3 bucket to another location.

    :param bucket_name: Name of the S3 bucket
    :param source_key: The current key (path) of the file in the bucket
    :param destination_key: The new key (path) for the file in the bucket
    """
    try:
        # Copy the file to the new location
        s3_client.copy_object(
            Bucket=destination_bucket,
            CopySource={'Bucket': bucket_name, 'Key': source_key},
            Key=destination_key
        )
        logger.info(f"File copied from {source_key} to {destination_key} in bucket {destination_bucket}")

        # Delete the original file
        s3_client.delete_object(Bucket=bucket_name, Key=source_key)
        logger.info(f"File deleted from {source_key} in bucket {bucket_name}")

    except Exception as e:
        logger.error(f"Error moving file from {source_key} to {destination_key} in bucket {bucket_name}: {e}")
        
def check_file_exists(bucket_name, file_key):
    """
    Check if a file exists in an S3 bucket.

    :param bucket_name: Name of the S3 bucket
    :param file_key: Key (path) of the file in the bucket
    :return: True if the file exists, False otherwise
    """
    s3_client = boto3.client('s3')
    try:
        s3_client.head_object(Bucket=bucket_name, Key=file_key)
        return True
    except ClientError as e:
        if e.response['Error']['Code'] == "404":
            return False
        else:
            raise

try:
    # Retrieve secrets
    rs_secret_json = retrieve_secrets(rs_secret_name)
    
    # Create RS database connections
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()
    
    # file name
    # original version with both files
    file_names = ['PIP Tracker- Focused Health.xlsx', 'CTM Tracking.xlsx']

    # sheet name
    sheet_names = ['PIP Tracker', 'Complaints']
    
    tables_to_load = ['pip_tracker_focused_health', 'ctm_tracking']
    
    finalizing_sql = ["id::int, start_time::timestamp, completion_time::timestamp, email, name, date_of_delivery::date, \
        pip_stage, agent_name, agent_supervisor, sales_manager, pip_reason, pip_reason_notes, \
        current_timestamp as refresh_timestamp", 
        "id::int, inv_id::int, date_of_notice_from_carrier::date, recording_due_date::date, date_requested_from_bloom::date, \
        date_recording_received_by_bloom::date, date_recording_sent_to_carrier::date, remedial_action_notice::date, \
        remedial_action_due_date::date, date_remedial_action_requested::date, \
        case when date_remedial_action_sent_to_carrier = '' then null else date_remedial_action_sent_to_carrier::date end, \
        application_date::date, null as supervisor, agent_name, npn, complaint_type, allegation, \
        case when lower(agent_still_with_fh) in ('n', 'no') then false when lower(agent_still_with_fh) in ('y', 'yes') then true else null end, \
        term_date::date, app_id, state, beneficiary, phone_number, plan_id, plan, \
        case when lower(effectuated_member_yn) in ('n', 'no') then false when lower(effectuated_member_yn) in ('y', 'yes') then true else null end, \
        founded_unfounded, \
        case when lower(founded_for_other_yn) in ('n', 'no') then false when lower(founded_for_other_yn) in ('y', 'yes') then true else null end, \
        remedial_action, notes, current_timestamp as refresh_timestamp"]
    
    initial_schema_to_load = 'landing'
    final_schema_to_load = 'dm_analytics'
    
    # loop over files/tables to load
    
    for i in range(len(file_names)):

        # S3 path to file to load
        process_s3_location = "s3://" + s3_data_bucket + "/" + s3_data_path + file_names[i]
        
        if check_file_exists(s3_data_bucket, s3_data_path + file_names[i]):
    
            # read file into dataframe df
            # =========================
            logger.info(f"Reading data: {file_names[i]}")
            df = pd.read_excel(process_s3_location, sheet_name=sheet_names[i], dtype=str)
        
            # cleanup dataframe data
            # ========================
            logger.info(f"Cleaning up data")
            # Remove rows if all empty
            df.dropna(inplace=True, how='all')
        
            # Remove spaces from column names
            df.columns = df.columns.str.strip()
        
            # trim all string columns
            df = trim_all_columns_remove_nbsp(df)
            
            # remove all item markers from invalid chars
            df = all_columns_remove_item_marker(df)
            
            # output data to S3 location for loading with copy command
            logger.info(f"Outputting df to S3")
            df.to_csv("s3://" + s3_data_bucket + "/" + s3_data_path + tables_to_load[i] + "_focBI_1.txt", index=False, na_rep='NULL', \
                        header=False, sep='|', quoting=csv.QUOTE_ALL, quotechar='"',  escapechar='"')
            
            # truncate table in initial loading schema
            logger.info(f"Truncating loading table: {tables_to_load[i]}")
            rs_cursor.execute("truncate table " + initial_schema_to_load + "."+tables_to_load[i])
            rs_conn.commit()
            
            # load data to initial loading schema 
            logger.info(f"Doing initial data load")
            rs_cursor.execute("copy " + initial_schema_to_load + "." + tables_to_load[i] + " \
                                from 's3://" + s3_data_bucket + "/" + s3_data_path + tables_to_load[i] + "_focBI_' \
                                iam_role 'arn:aws:iam::511539536780:role/Redshift_for_copy' \
                                csv quote as '" + quote_char +"' delimiter '|' IGNOREHEADER 0 ROUNDEC NULL AS 'NULL'")
            rs_conn.commit()
            
            # do truncate reload to final loading schema
            # Some data transformations may be needed here:
                # date format cleanup??
                # handling boolean fields??
            
            # truncate table in final loading schema
            logger.info(f"Doing truncate reload of final data table.")
            rs_cursor.execute("truncate table " + final_schema_to_load + "." + tables_to_load[i])
            rs_cursor.execute("insert into " + final_schema_to_load + "." + tables_to_load[i] + " \
                select " + finalizing_sql[i] + " from " + initial_schema_to_load + "." + tables_to_load[i])
            
            rs_conn.commit()
            
            # delete loading file from s3
            file_key_to_delete = s3_data_path + tables_to_load[i] + "_focBI_1.txt"
            response = s3_client.delete_object(Bucket=s3_data_bucket, Key=file_key_to_delete)
            
            #Copy files processed to an archive folder with a date added in name
            source_key = s3_data_path + file_names[i]
            
            destination_key = s3_archive_data_path + "date_"+file_date + '_' + file_names[i]
        
            move_s3_file(s3_data_bucket, source_key, s3_archive_data_bucket, destination_key)
        
        else:
            print("File does not exist!")

    logger.info(f"Process Complete")

except (Exception, psycopg2.Error) as error:
    # Send ERROR notification to SNS topic
    error_email_subject = "DW Source Copy data process error"
    error_message_to_send = "Exception occurred in: load_focused_bi_dashboard_data glue job"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")
