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
s3_data_bucket = 'sftp-01-prod-focusedhealth'
s3_data_path = 'data/to_bloom/BoB/'

s3_preprocess_data_bucket = 'bloom-dev-data-team'
s3_preprocess_data_path = 'Focused_BI_Dashboard_Datasets/BoB/'

s3_archive_data_bucket = 'bloom-dev-data-team'
s3_archive_data_path = 'Focused_BI_Dashboard_Datasets/Archive/'

region_name="us-west-2"
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
    
def copy_s3_file(bucket_name, source_key, destination_bucket, destination_key):
    """
    Copies a file within an S3 bucket to another location.

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

    except Exception as e:
        logger.error(f"Error moving file from {source_key} to {destination_key} in bucket {bucket_name}: {e}")
        
def get_files_desc_order(bucket_name, prefix=""):
    """
    Retrieves file names from an S3 bucket and returns them in descending alphabetical order.

    :param bucket_name: Name of the S3 bucket
    :param prefix: Prefix to filter files (optional)
    :return: List of file names in descending alphabetical order
    """
    try:
        # List objects in the bucket with the specified prefix
        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
        if 'Contents' in response:
            # Extract file names
            file_names = [obj['Key'] for obj in response['Contents']]
            # Sort file names in descending alphabetical order
            sorted_file_names = sorted(file_names, reverse=True)
            return sorted_file_names
        else:
            print("No files found in the bucket.")
            return ['no_file_found']
    except Exception as e:
        print(f"Error retrieving files from S3: {e}")
        return []
        
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
    
    # file name
    # original version with both files
    file_names = ['Focused_Health_APPS_BOB_']
    
    # loop over files/tables to load
    
    for i in range(len(file_names)):
        
        file_prefix = s3_data_path + file_names[i]
        
        file_list = get_files_desc_order(s3_data_bucket, file_prefix)

        file_path_to_process = file_list[0]
        
        specific_file_name = file_path_to_process.split("/")[-1]

        # S3 path to file to load
        process_s3_location = "s3://" + s3_data_bucket + "/" + file_path_to_process
        
        if check_file_exists(s3_data_bucket, file_path_to_process):
            
            # read file into dataframe df
            # =========================
            logger.info(f"Reading data: {file_path_to_process}")
            df = pd.read_csv(process_s3_location,delimiter=',', dtype=str)
        
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
            
            column_names = df.columns.tolist()
#            print(column_names)
            
            # create df with columns we need:
            selected_fields = ['ConfirmationID','MedicareID','contract_number','PBP','ResultType','ApplicationType', 
                'ApplicationDate','Agency_AOR_Start_Date','Agency_AOR_End_Date','termdate','TermReason','TermType', 
                'producerid','producername','Marketid','PlanName','CountyName','ProductType']
            df_final = df[selected_fields]
            
            # output data to S3 location for loading with copy command
            logger.info(f"Outputting df to S3")
            df_final.to_csv("s3://" + s3_preprocess_data_bucket + "/" + s3_preprocess_data_path + "preprocess_" + specific_file_name, \
                        index=False, na_rep='NULL', \
                        header=True, sep=',', quoting=csv.QUOTE_ALL, quotechar='"',  escapechar='"')
            
            #Copy files processed to an archive folder with a date added in name
            source_key = file_path_to_process
            
            destination_key = s3_archive_data_path + specific_file_name
        
            copy_s3_file(s3_data_bucket, source_key, s3_archive_data_bucket, destination_key)
        
        else:
            print("File does not exist!")

    logger.info(f"Process Complete")

except (Exception, psycopg2.Error) as error:
    # Send ERROR notification to SNS topic
    error_email_subject = "DW Source Copy data process error"
    error_message_to_send = "Exception occurred in: load_focused_bi_dashboard_data glue job"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")
