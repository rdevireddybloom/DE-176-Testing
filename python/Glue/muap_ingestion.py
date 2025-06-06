import sys
import boto3
import csv
import requests
import os
from datetime import datetime, timezone
from awsglue.utils import getResolvedOptions
import logging
import psycopg2
import json
import re
from collections import OrderedDict


# Set up logging
# Configure the logger to output to stdout
# Get the root logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)


def retrieve_secrets(secret_name):
    """Retrieve secrets from AWS Secrets Manager."""
    try:
        secrets_client = boto3.client("secretsmanager")
        get_secret_value_response = secrets_client.get_secret_value(
            SecretId=secret_name
        )
        secret_json = json.loads(get_secret_value_response["SecretString"])
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
            database=secret_json["dbname"],
        )
        logger.info(
            f"Successfully created database connection to {secret_json['dbname']}"
        )
        return conn

    except Exception as e:
        logger.error(f"Failed to create database connection: {e}")
        raise


def generate_sns_notification(error_context, params=None):
    """Generate an SNS notification based on the error context and publish to SNS."""
    try:
        params = params or {}

        # Adding default values to params
        params.setdefault(
            "timestamp", datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
        )
        params.setdefault("job_name", job_name)

        # templates for SNS messages
        templates = {
            "s3_upload_failed": {
                "subject": "{job_name} Job Error: S3 Upload Failed",
                "message": """The Glue job failed to upload the csv file to S3 bucket.
            Job Name: {job_name}
            Timestamp: {timestamp}
            Error: {error}
            Source URL: {url}
            Bucket: {bucket}
            Key: {prefix}/{filename}
            
            """,
            },
            "schema_validation_failed": {
                "subject": "{job_name} Job Error: CSV Schema Validation Failed",
                "message": """The csv file failed to pass the schema validation checks
            Job Name: {job_name}
            Timestamp: {timestamp}
            Error: {error}
            File: {s3_uri}
            Table: {table_name}
            """,
            },
            "redshift_load_failed": {
                "subject": "{job_name} Job Error: Redshift Load Failed",
                "message": """Redshift data load failed for {table_name} table.
            Job Name: {job_name}
            Timestamp: {timestamp}
            Error: {error}
            Table: {table_name}
            Source: {s3_uri}
            
            """,
            },
        }

        # get template or set generic default template
        template = templates.get(
            error_context,
            {
                "subject": "{job_name} Error : {error_context}",
                "message": """An error occurred in the Glue job.
            Job Name: {job_name}
            Timestamp: {timestamp}
            Error: {error}
            """,
            },
        )

        # format with params values
        subject = template["subject"].format(error_context=error_context, **params)
        message = template["message"].format(error_context=error_context, **params)

        # formatting JSON message
        first_keys = ["job_name", "timestamp", "error"]

        # Create an OrderedDict with the specified first keys
        ordered_params = OrderedDict()
        for key in first_keys:
            if key in params:
                ordered_params[key] = params[key]

        # Add the remaining keys to the OrderedDict
        for key in params:
            if key not in ordered_params and key != "sns_topic":
                ordered_params[key] = params[key]

        # json format message
        json_data = {"error_context": error_context, "params": ordered_params}

        # combine both
        final_message = f"{message}\n\nJSON Error:\n{json.dumps(json_data, indent=4)}"

        # publish to sns topic
        sns_topic = params.get("sns_topic")
        messageID = publish_message_to_sns(sns_topic, subject, final_message)
        logger.info(
            f"Successfully published SNS notification for {error_context}. Message ID: {messageID}"
        )

        # logging to cloudwatch as well
        logger.error(
            f"Error notification sent for {error_context}:\n{final_message} \nMessage ID: {messageID}"
        )

    except Exception as e:
        logger.error(f"Failed to generate SNS notification: {e}")
        raise


def publish_message_to_sns(topic, subject, message):
    """Publish a message to an SNS topic."""
    try:

        response = sns_client.publish(TopicArn=topic, Message=message, Subject=subject)
        return response

    except Exception as e:
        logger.error(f"Failed to publish message to SNS: {e}")
        raise


def upload_to_s3(url, bucket, prefix):
    """Download a CSV file from a URL and upload it to an S3 bucket."""
    logger.info(
        f"Starting download of CSV from {url} and upload to S3 bucket: {bucket}"
    )

    try:

        # Send HTTP request
        logger.info("Sending HTTP request to download file")
        response = requests.get(url)

        # Check if request was successful
        if response.status_code != 200:
            logger.error(f"Failed to download CSV. Status code: {response.status_code}")
            raise Exception(
                f"Failed to download CSV. Status code: {response.status_code}"
            )

        # Create a timestamped filename
        timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        filename = f"mua_p_data_{timestamp}.csv"

        s3_key = f"{prefix}/{filename}"
        logger.info(f"Uploading file to S3 key: {s3_key}")

        # Upload the file to S3
        s3.put_object(Bucket=bucket, Key=s3_key, Body=response.content)
        s3_uri = f"s3://{bucket}/{s3_key}"

        logger.info(f"File uploaded successfully to {s3_uri}")
        return s3_uri

    except Exception as e:
        logger.error(f"Error uploading to S3: {str(e)}")
        # Publish error message to SNS topic
        generate_sns_notification(
            "s3_upload_failed",
            {
                "sns_topic": sns_topic,
                "url": url,
                "bucket": bucket,
                "prefix": prefix,
                "filename": filename,
                "error": str(e),
            },
        )
        raise


def validate_schema(s3_uri, conn):
    """Validate the schema of the CSV file."""
    try:
        # Create a cursor object
        cursor = conn.cursor()

        # Define the SQL query to get the expected table schema (excluding metadata columns)
        query = """
            Select column_name, data_type
            from information_schema.columns
            where table_name = 'mua_p_data'
            and column_name not in ('loaded_at')
            and table_schema = 'reference'
            order by ordinal_position
        """

        # Execute the query and fetch the results
        cursor.execute(query)
        table_schema = cursor.fetchall()

        # Close the cursor and connection
        cursor.close()

        # Parse the S3 URI
        bucket_name = s3_uri.split("/")[2]
        file_key = "/".join(s3_uri.split("/")[3:])

        # Get the actual header row from the CSV file
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        csv_content = response["Body"].read().decode("utf-8").splitlines()
        reader = csv.reader(csv_content)
        csv_schema = next(reader)

        # handle empty trailing column due to trailing comma in csv file
        csv_schema = [col for col in csv_schema if col]

        # Number of columns check
        if len(csv_schema) != len(table_schema):
            logger.error("Schema validation failed: Number of columns do not match")
            raise Exception("Schema validation failed: Number of columns do not match")

        logger.info("Schema validation successful")
        return False

    except Exception as e:
        logger.error(f"Failed to validate schema: {e}")

        # Publish error message to SNS topic
        generate_sns_notification(
            "schema_validation_failed",
            {
                "sns_topic": sns_topic,
                "s3_uri": s3_uri,
                "table_name": "mua_p_data",
                "error": str(e),
            },
        )
        return True


def load_to_redshift(conn, s3_uri):
    """Load data from S3 into Redshift."""
    try:
        cursor = conn.cursor()
        logger.info("Database connection established")

        logger.info("Starting data load into Redshift")
        # Check if the staging table exists
        cursor.execute(
            "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'staging_mua_p_data')"
        )
        stg_table_exists = cursor.fetchone()[0]

        # Check if the final table exist
        cursor.execute(
            "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'mua_p_data')"
        )
        table_exists = cursor.fetchone()[0]

        if not table_exists:
            logger.error("Table mua_p_data does not exist in Redshift")
            raise Exception("Table mua_p_data does not exist in Redshift")

        elif not stg_table_exists:
            logger.error("Table staging_mua_p_data does not exist in Redshift")
            raise Exception("Table staging_mua_p_data does not exist in Redshift")

        else:
            # Truncate tables before loading new data
            cursor.execute("TRUNCATE TABLE reference.staging_mua_p_data")
            cursor.execute("TRUNCATE TABLE reference.mua_p_data")
            conn.commit()
            logger.info("Tables truncated successfully")

        copy_command = f"""
            COPY reference.staging_mua_p_data 
            FROM '{s3_uri}'
            IAM_ROLE 'arn:aws:iam::511539536780:role/Redshift_for_copy'
            CSV
            IGNOREHEADER 1
            DELIMITER ','
            NULL AS 'NULL'
            DATEFORMAT 'auto'
            
            
        """

        logger.info(f"Executing COPY command: {copy_command}")
        cursor.execute(copy_command)

        conn.commit()
        logger.info("Data copied to staging table successfully")

        # inserting data from staging table to final table
        insert_command = """
        INSERT INTO reference.mua_p_data
        SELECT *, getdate() FROM reference.staging_mua_p_data 
        """

        cursor.execute(insert_command)
        conn.commit()
        logger.info("Data inserted into final table successfully")

        # truncate staging table
        cursor.execute("TRUNCATE TABLE reference.staging_mua_p_data")
        conn.commit()
        logger.info("Staging table truncated successfully")

        # Get row count
        cursor.execute("SELECT COUNT(*) FROM reference.mua_p_data")
        row_count = cursor.fetchone()[0]

        logger.info("Data loaded successfully into Redshift")
        logger.info(f"Row count: {row_count}")

    except Exception as e:
        logger.error(f"Failed to load data into Redshift: {e}")
        # Publish error message to SNS topic
        generate_sns_notification(
            "redshift_load_failed",
            {
                "sns_topic": sns_topic,
                "s3_uri": s3_uri,
                "table_name": "mua_p_data",
                "error": str(e),
            },
        )
        raise


# main function for the script

logger.info("Starting CSV download to S3 pipeline")
# Get job parameters
args = getResolvedOptions(
    sys.argv,
    ["JOB_NAME", "source_url", "s3_bucket", "s3_prefix", "rs_secret_name", "sns_topic"],
)


# Extract parameters
job_name = args["JOB_NAME"]
source_url = args[
    "source_url"
]  #'https://data.hrsa.gov//DataDownload/DD_Files/MUA_DET.csv'
s3_bucket = args["s3_bucket"]  #'bloom-dev-data-team'
s3_prefix = args["s3_prefix"]  #'muap_data'
rs_secret_name = args["rs_secret_name"]
sns_topic = args["sns_topic"]  #'arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages'


# global aws clients
s3 = boto3.client("s3")
sns_client = boto3.client("sns")


# Step 1: Download file to S3 bucket
logger.info("STEP 1: Uploading CSV to S3")
s3_uri = upload_to_s3(source_url, s3_bucket, s3_prefix)
logger.info(f"File available in S3 at: {s3_uri}")


secret_json = retrieve_secrets(rs_secret_name)
conn = create_db_connection(secret_json)

# Step 2: Check schema of the file
logger.info("STEP 2: Validating schema")
invalid_schema = validate_schema(s3_uri, conn)

if invalid_schema:
    logger.error("Schema validation failed")
    raise Exception("Schema validation failed")
else:
    # Step 3: Load data from S3 into Redshift
    logger.info("STEP 2: Loading data into Redshift")
    load_to_redshift(conn, s3_uri)
    logger.info("MUA/P data ingestion completed successfully")

    # close the database connection
    conn.close()
    logger.info("Database connection closed")
