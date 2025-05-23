import sys
import re
import psycopg2
import json
import boto3
import sqlalchemy as sa
import csv
import logging

# Initialize logging
# Get the root logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Set the minimum logging level
print("Logger initialized")
# Create a StreamHandler to output to stdout
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)

# Create a formatter to customize the log message format
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(handler)

# Few variable initializations
region_name = "us-west-2"
do_secret_name = "etluser/dev/rds"

# Create a global AWS client
sns_client = boto3.client("sns")
session = boto3.Session()
secrets_client = session.client(service_name="secretsmanager", region_name=region_name)


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
        response = sns_client.publish(
            TopicArn=topic, Message=message, Subject=email_subject
        )
        message_id = response["MessageId"]
        return message_id
    except Exception as e:
        logger.error(f"Failed to publish message to {topic}: {e}")
        raise


def retrieve_secrets(secret_name):
    """Retrieve secrets from AWS Secrets Manager."""
    try:
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


logger.info(f"Sys.argv settings for this run: {sys.argv}")

try:
    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)

    # Create DO database connections
    do_conn = create_db_connection(do_secret_json)
    do_cursor = do_conn.cursor()

    sql_to_run = "select string_agg(distinct t.target_identifier||':'||t.target_table, ','), count(*) as num_tables \
        from data_operations.data_transfer_target t \
            join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
            join data_operations.data_transfer_log l on c.data_transfer_config_id = l.data_transfer_config_id \
        where coalesce(c.override_schedule, t.schedule) in ('weekly_zero_recs', 'weekly_lookup') \
            and l.start_datetime > current_timestamp - interval '24' hour \
            and (l.insert_count > 0 or l.update_count > 0)"

    do_cursor.execute(sql_to_run)
    sql_results = do_cursor.fetchone()

    table_list = sql_results[0]
    num_tables = sql_results[1]

    # if no results found, Redshift tables do not exist yet, send notification and move on to next target table
    if num_tables > 0:
        # Send notification to SNS topic that the required redshift table does not exist
        error_email_subject = "DW Source Transfer Static Table Change Encountered!"
        error_message_to_send = (
            "During running of: dw_source_transfer_no_change_check glue job, the following "
            + str(num_tables)
            + " static tables: ("
            + table_list
            + ") had changes detected.  Evaluate if they need to be moved to regular schedule."
        )
        sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
        msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.info("Job Complete")


except Exception as error:

    # If connections open, rollback and close
    if do_conn:
        do_conn.rollback()
        do_cursor.close()
        do_conn.close()
        logger.error("DataOps PostgreSQL connection is closed")

    # Send ERROR notification to SNS topic
    error_email_subject = "DW Source data no change check error"
    error_message_to_send = (
        "Exception occurred in: dw_source_transfer_no_change_check glue job"
    )
    sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")
