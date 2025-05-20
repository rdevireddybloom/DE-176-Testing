import sys
import re
import psycopg2
import json
import boto3
import pandas as pd
import sqlalchemy as sa
import csv
import logging

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
do_secret_name = "etluser/dev/rds"
rs_secret_name = 'prod/dw/Redshift/etluser'

# Create a global AWS client
try:
    sns_client = boto3.client('sns', region_name=region_name)
    session = boto3.Session(region_name=region_name)
    s3_client = session.client('s3')
    secrets_client = session.client(service_name='secretsmanager', region_name=region_name)
except Exception as e:
    logger.error(f"Error creating AWS clients: {e}")
    sys.exit(1)

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
        logger.info(f"Message published to {topic} with ID: {message_id}")
        return message_id
    except Exception as e:
        logger.error(f"Failed to publish message to {topic}: {e}")
        raise
        
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
    
def id_processing_schemas(target_identifier):
    if target_identifier == 'redshift_prod_aqe':
        integrated_schema = 'integrated_aqe'
        history_schema = 'aqe_history'
        staging_schema = 'staging_aqe'
    if target_identifier == 'redshift_prod_asc':
        integrated_schema = 'integrated_asc'
        history_schema = 'asc_history'
        staging_schema = 'staging_asc'
    if target_identifier == 'redshift_prod_ccs':
        integrated_schema = 'integrated_ccs'
        history_schema = 'ccs_history'
        staging_schema = 'staging_ccs'
        
    return history_schema, staging_schema, integrated_schema
    
logger.info(f"Sys.argv settings for this run: {sys.argv}")

try:
    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)
    rs_secret_json = retrieve_secrets(rs_secret_name)

    # Create DO database connections
    do_conn = create_db_connection(do_secret_json)
    do_cursor = do_conn.cursor()
    
    # Create Redshift Connection
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()

    #############################################################
    #############################################################
    
    # Query the config table for all records to pull data for in this run.
    sql_to_run = "select distinct target_identifier, \
            target_table \
        from data_operations.data_transfer_target t \
            join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
        where track_history is true \
            and history_tracking_setup is false \
            and current_date between t.effective_start_date and t.effective_end_date"
        
    do_cursor.execute(sql_to_run)
    sql_results = do_cursor.fetchall()
    
    # Loop through records to land and stage data for
    # Write values into meaningful variable names.
    for row in sql_results:
        target_identifier = row[0]
        target_table = row[1]
        
        history_schema, staging_schema, integrated_schema = id_processing_schemas(target_identifier)

        logger.info(f"Processing: {target_identifier}:{target_table}")
        
        rs_cursor.execute("select distinct column_name, data_type, ordinal_position \
            from information_schema.columns \
            where table_schema = '" + integrated_schema +"' \
                and table_name = '" + target_table +"' \
                and column_name != 'dw_table_pk' \
            order by ordinal_position")
        field_result = rs_cursor.fetchall()
            
        # if no results found, Redshift tables do not exist yet, send notification and move on to next target table
        if field_result == []:
            # Send notification to SNS topic that the required redshift table does not exist
            error_email_subject = "DW Source Transfer Missing Redshift Table Encountered!"
            error_message_to_send = "During running of: dw_source_transfer glue job, the following table was not found in Redshift: " + integrated_schema + "." + target_table
            sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
            msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

            continue
        
        field_list = ''
        field_cnt = 0
        for field in field_result:
            if field_cnt == 0:
                field_list = field[0]
            else:
                field_list = field_list + ',' + field[0] 
            field_cnt = field_cnt + 1
            
        # Query to check if the history table currently exists        
        rs_cursor.execute("select count(*) as counter \
                from admin.v_generate_tbl_ddl \
                where schemaname = '" + history_schema + "' \
                    and tablename = '" + target_table + "_history'")
        count_results = rs_cursor.fetchone()
        counter = count_results[0]
        
        # if counter = 0 then need to create the table and seed current data
        if counter == 0:
            
            create_table_query = "CREATE TABLE " + history_schema +"." + target_table + "_history \
                ( "
                
            # Get info to create the history table       
            rs_cursor.execute("select ddl \
                from admin.v_generate_tbl_ddl \
                where schemaname = '" + integrated_schema + "' \
                    and tablename = '" + target_table + "' \
                    and seq >= 100000001 and seq < 200000000 \
                order by seq asc")
                
            ddl_results = rs_cursor.fetchall()
            
            field_num = 1
            for line in ddl_results:
                if "dw_table_pk" in line[0]:
                    logger.info("Skipping identity field")
                else:
                    if field_num == 1:
                        create_table_query = create_table_query + line[0].lstrip("\t,") + "\n"
                    else:
                        create_table_query = create_table_query + line[0] + "\n"
                    field_num = field_num + 1
                    
            create_table_query = create_table_query + ", record_version  bigint )"
            
            logger.info(f"Creating history table: {history_schema}.{target_table}_history")
            
            rs_cursor.execute(create_table_query)
            
            # Grant select to RO group role
            grant_query = "GRANT SELECT on " + history_schema +"." + target_table + "_history TO group named_user_ro"
            
            rs_cursor.execute(grant_query)

            logger.info("Populating initial data if available")
            
            data_fill_query = "insert into " + history_schema +"." + target_table + "_history \
                (" + field_list + ", record_version) \
                select " + field_list + ", 1 as record_version \
                from " + integrated_schema + "." + target_table
                
            rs_cursor.execute(data_fill_query)
            
            rs_conn.commit()
            
            do_cursor.execute("update data_operations.data_transfer_target \
            set history_tracking_setup = true \
            where target_identifier = '" + target_identifier + "' \
                and target_table = '" + target_table + "'")
            do_conn.commit()
            
    logger.info("Job Complete")

except Exception as error:
    
    # If connections open, rollback and close
    if do_conn:
        do_conn.rollback()
        do_cursor.close()
        do_conn.close()
        logger.error("DataOps PostgreSQL connection is closed")
        
    if rs_conn:
        rs_conn.rollback()
        rs_cursor.close()
        rs_conn.close()
        logger.error("Redshift connection is closed")
    
    # Send ERROR notification to SNS topic
    error_email_subject = "DW Source Copy data process error"
    error_message_to_send = "Exception occurred in: dw_source_tranfer_setup_history_tracking glue job"
    sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")