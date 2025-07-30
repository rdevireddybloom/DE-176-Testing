import sys
import re
import psycopg2
import json
import boto3
import pandas as pd
import sqlalchemy as sa
import csv
import logging

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
region_name="us-west-2"
rs_secret_name = 'prod/dw/Redshift/etluser'
sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"

# Create a global AWS client
sns_client = boto3.client('sns')
session = boto3.Session()
s3_client = session.client('s3')
secrets_client = session.client(service_name='secretsmanager', region_name=region_name)

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

try:
    # See if we can access secrets from glue
    session = boto3.Session()

    s3_client = boto3.client('s3')
    s3 = session.resource('s3')

    # file type of csv or xlsx (allows either , or | delimiter currently)
    file_type = 'csv'

    # sheet name if xlsx
    sheet_name_if_xlsx = 'Sheet1'

    # delimiter if csv:  , or | (comma or pipe currently)
    delimiter_if_csv = '|'
    
    # file name for adding to data being written to table
    file_name = 'file_name.csv'

    # S3 path to file to load
    process_s3_location = "s3://bucket_name/adhoc/" + file_name
    
    write_to_db = 'redshift'

    schema_to_load = 'public'
    table_to_load = 'test_file'

    # read file into dataframe df
    # =========================
    print("Reading data")
    if file_type == 'xlsx':
        print("Reading excel file")
        df = pd.read_excel(process_s3_location, sheet_name=sheet_name_if_xlsx, dtype=str)

    if file_type == 'csv':
        print("Reading csv file")
        if delimiter_if_csv == ',':
            df = pd.read_csv(process_s3_location, sep=',', encoding_errors='replace', \
                             dtype=str)
        if delimiter_if_csv == '|':
            df = pd.read_csv(process_s3_location, sep='|', encoding_errors='replace', \
                             dtype=str)

    # cleanup dataframe data
    # ========================
    print("Cleaning up data")
    # Remove rows if all empty
    df.dropna(inplace=True, how='all')

    # Remove spaces from column names
    df.columns = df.columns.str.strip()

    # trim all string columns
    df = trim_all_columns_remove_nbsp(df)
    
    # remove all item markers from invalid chars
    df = all_columns_remove_item_marker(df)

    # Add file name to DF
    df['file_name'] = file_name

    # write dataframe to table
    # ========================
    print("Writing data")
    if write_to_db == 'redshift':
        print("Writing to redshift")

        # Retrieve secrets
        rs_secret_json = retrieve_secrets(rs_secret_name)
        escaped_password = rs_secret_json["password"].replace("@", "%40")
        
        url = "postgresql://" + rs_secret_json["username"] + ":%s@" + rs_secret_json["host"] + ":" + str(rs_secret_json["port"]) + "/" + rs_secret_json["dbname"]
        engine = sa.create_engine(url % escaped_password)

        # write data to loading table.
        df.to_sql(table_to_load, engine, schema=schema_to_load, if_exists='replace', chunksize=5000, index=False, method='multi')
        
except (Exception, psycopg2.Error) as error:
    print("Error: ", error)
