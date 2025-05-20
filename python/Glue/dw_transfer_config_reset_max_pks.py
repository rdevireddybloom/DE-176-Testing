import sys
import re
import psycopg2
import json
import boto3
import pandas as pd
import pymssql
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
do_secret_name = "etluser/dev/rds"
ss_secret_name = "dev/aqe/etluser"
rs_secret_name = 'prod/dw/Redshift/etluser'
domain_name = 'RMGCOM'
sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"

# Create a global AWS client
sns_client = boto3.client('sns')
session = boto3.Session()
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
        landing_schema = 'landing_aqe'
        staging_schema = 'staging_aqe'
        history_schema = 'aqe_history'
    if target_identifier == 'redshift_prod_asc':
        integrated_schema = 'integrated_asc'
        landing_schema = 'landing_asc'
        staging_schema = 'staging_asc'
        history_schema = 'asc_history'
    if target_identifier == 'redshift_prod_ccs':
        integrated_schema = 'integrated_ccs'
        landing_schema = 'landing_ccs'
        staging_schema = 'staging_ccs'
        history_schema = 'ccs_history'
        
    return landing_schema, staging_schema, integrated_schema, history_schema
    
    
logger.info(f"Sys.argv settings for this run: {sys.argv}")

        
try:
    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)
    rs_secret_json = retrieve_secrets(rs_secret_name)
    ss_secret_json = retrieve_secrets(ss_secret_name)
    
    user_name = domain_name+'\\'+ss_secret_json["username"]

    # Create DO database connections
    do_conn = create_db_connection(do_secret_json)

    do_cursor = do_conn.cursor()
    do_cursor1 = do_conn.cursor()
    
    # Create RS database connections
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()
    
    # Query config table to determine tables being written to so those landing and staging tables can be truncated
    # for subsequent steps.
    sql_to_run = "select t.target_identifier, t.target_table, source_host, source_db, source_schema, source_table, \
                       coalesce(reference_id, -9), max_pk_val, c.data_transfer_config_id \
                from data_operations.data_transfer_target t \
                    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                    where max_pk_val = -99 \
order by c.data_transfer_config_id"
        
    do_cursor.execute(sql_to_run)
    sql_results0 = do_cursor.fetchall()

    for row in sql_results0:
        target_identifier = row[0]
        target_table = row[1]
        source_host = row[2]
        source_db = row[3]
        source_schema = row[4]
        source_table = row[5]
        reference_id = row[6]
        max_pk_val= row[7]
        data_transfer_config_id= row[8]
        
        source_table = source_table.replace('[','').replace(']', '')
            
        logger.info(f"Starting process for: {target_table}")
        landing_schema, staging_schema, integrated_schema, history_schema = id_processing_schemas(target_identifier)
            
        # Lookup pk field from SS 
        # if multiple set max_pk_val = -99 in config
        # then continue
        # Open connection to source
        url = 'mssql+pymssql://'+user_name+':'+ss_secret_json["password"]+'@'+source_host+'/'+source_db
        engine = sa.create_engine(url, connect_args={"tds_version": "7.3"})
        
        pk_query = "use " + source_db + "; \
                            SELECT COLUMN_NAME as pk_field \
                            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE \
                            WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1 \
                            AND TABLE_NAME = '" + source_table + "' AND TABLE_SCHEMA = '" + source_schema + "';" 
        pk_df = pd.read_sql(pk_query, engine)
        if len(pk_df) == 1:
            pk_field = pk_df.pk_field[0]
        
            if "," in pk_field:
                # set to -777777
                do_cursor.execute("update data_operations.data_transfer_config \
                                    set max_pk_val = -777777 \
                                    where data_transfer_config_id = " + str(data_transfer_config_id))
                do_conn.commit()
                
                engine.dispose()
                continue
            
            # query RS to get the max pk value in the integrated table.
            # write that value to the config table if > current value
            
            if reference_id != -9:
                if target_identifier == 'redshift_prod_aqe':
                    field_key = "carrier_id"
                if target_identifier == 'redshift_prod_asc':
                    field_key = "ascend_carrier_id"
                    
                rs_cursor.execute("select max(" + pk_field + ") from " + integrated_schema + "." + target_table + " \
                        where " + field_key + " = " + str(reference_id))
                max_pk_results = rs_cursor.fetchone()
                new_max_pk_val = max_pk_results[0]
                if new_max_pk_val == None:
                    new_max_pk_val = 0
                    
                if type(new_max_pk_val) == int:
                    do_cursor.execute("update data_operations.data_transfer_config \
                                        set max_pk_val = " + str(new_max_pk_val) + " \
                                        where data_transfer_config_id = " + str(data_transfer_config_id))
                    do_conn.commit()
                else:
                    do_cursor.execute("update data_operations.data_transfer_config \
                                        set max_pk_val = -999999 \
                                        where data_transfer_config_id = " + str(data_transfer_config_id))
                    do_conn.commit()
                
            else:
                rs_cursor.execute("select max(" + pk_field + ") from " + integrated_schema + "." + target_table)
                max_pk_results = rs_cursor.fetchone()
                new_max_pk_val = max_pk_results[0]
                if new_max_pk_val == None:
                    new_max_pk_val = 0
                
                if type(new_max_pk_val) == int:
                    do_cursor.execute("update data_operations.data_transfer_config \
                                        set max_pk_val = " + str(new_max_pk_val) + " \
                                        where data_transfer_config_id = " + str(data_transfer_config_id))
                    do_conn.commit()
                else:
                    do_cursor.execute("update data_operations.data_transfer_config \
                                        set max_pk_val = -999999 \
                                        where data_transfer_config_id = " + str(data_transfer_config_id))
                    do_conn.commit()
         
            engine.dispose()
        else:
            do_cursor.execute("update data_operations.data_transfer_config \
                                    set max_pk_val = -888888 \
                                    where data_transfer_config_id = " + str(data_transfer_config_id))
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
    error_message_to_send = "Exception occurred in: dw_transfer_config_reset_max_pks glue job"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")
    