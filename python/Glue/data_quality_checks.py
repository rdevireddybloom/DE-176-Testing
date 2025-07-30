import sys
import boto3
import os
import io
import zipfile
from awsglue.utils import getResolvedOptions
import psycopg2
import pymssql
import sqlalchemy as sa
import json 
from decimal import Decimal
from CloudWatchSNSLogger import CloudWatchSNSLogger

#Get job parameters
args = getResolvedOptions(sys.argv, ['ENV', 'JOB_CLASS', 'JOB_NAME', 'SCHEDULE', 'REGION', 'DO_SECRET_NAME', 'RS_SECRET_NAME', 'AQE_SECRET_NAME', 'ASC_SECRET_NAME', 'CCS_SECRET_NAME'])
job_name = args['JOB_NAME'] 
env = args['ENV'] 
job_class = args['JOB_CLASS'] 
schedule = args['SCHEDULE']
region = args['REGION']
do_secret_name = args['DO_SECRET_NAME']
rs_secret_name = args['RS_SECRET_NAME']
aqe_secret_name = args['AQE_SECRET_NAME']
asc_secret_name = args['ASC_SECRET_NAME']
ccs_secret_name = args['CCS_SECRET_NAME']

# Create a global AWS client
sns_client = boto3.client('sns')
session = boto3.Session()
s3_client = session.client('s3')
secrets_client = session.client(service_name='secretsmanager', region_name=region)
account_id = boto3.client("sts").get_caller_identity()["Account"]

def retrieve_secrets(secret_name):
    """Retrieve secrets from AWS Secrets Manager."""
    try:
        get_secret_value_response = secrets_client.get_secret_value(SecretId=secret_name)
        secret_json = json.loads(get_secret_value_response['SecretString'])
        logger.debug(f"Successfully retrieved secrets for {secret_name}")
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
        logger.debug(f"Successfully created database connection to {secret_json['dbname']}")
        return conn
    except Exception as e:
        logger.error(f"Failed to create database connection: {e}")
        raise
    
def create_ss_db_connection(secret_json):
    """Create a sql server database connection using the provided secrets."""
    try:
        domain_name = 'RMGCOM'
        user_name = domain_name+'\\'+secret_json["username"]
    
        conn = pymssql.connect(
            host=secret_json["host"],
            user=user_name,
            password=secret_json["password"],
            tds_version="7.3"
            )
        logger.debug(f"Successfully created database connection to {secret_json['host']}")
        return conn
    except Exception as e:
        logger.error(f"Failed to create database connection: {e}")
        raise

def get_dq_results(check_source, check_sql, log_id, result_write_type, data_quality_config_id, results_table):
    """Retrived DQ results based on configuration."""
    try:
        # run check sql on data_operations database
        if check_source == "data_operations":
            do_cursor.execute(check_sql)
            results = do_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in do_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
            
        # run check sql on redshift database
        if check_source == "redshift":
            
            rs_conn = create_db_connection(rs_secret_json)
            rs_cursor = rs_conn.cursor()
            
            rs_cursor.execute(check_sql)
            results = rs_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in rs_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
                
            rs_cursor.close()
            rs_conn.close()
        
        if check_source == "aqe":
    
            aqe_conn = create_ss_db_connection(aqe_secret_json)
            aqe_cursor = aqe_conn.cursor()
            
            aqe_cursor.execute(check_sql)
            results = aqe_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in aqe_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
                
            aqe_cursor.close()
            aqe_conn.close()
            
        if check_source == "asc":
    
            asc_conn = create_ss_db_connection(asc_secret_json)
            asc_cursor = asc_conn.cursor()
            
            asc_cursor.execute(check_sql)
            results = asc_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in asc_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
                
            asc_cursor.close()
            asc_conn.close()
            
        if check_source == "ccs":
    
            ccs_conn = create_ss_db_connection(ccs_secret_json)
            ccs_cursor = ccs_conn.cursor()
            
            ccs_cursor.execute(check_sql)
            results = ccs_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in ccs_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
                
            ccs_cursor.close()
            ccs_conn.close()
           
        # writing results to table so update the existing is_previous and is_latest flag for this config entry
        if result_write_type.lower() in ['standard_json', 'custom']:
            do_cursor.execute("update " + results_table + " r \
                        set is_previous = false \
                        from data_operations.data_quality_log l \
                        where l.data_quality_log_id = r.data_quality_log_id \
                            and l.data_quality_config_id = " + str(data_quality_config_id) + " \
                            and is_previous = true; \
                        update " + results_table + " r \
                        set is_previous = true, \
                            is_latest = false \
                        from data_operations.data_quality_log l \
                        where l.data_quality_log_id = r.data_quality_log_id \
                            and l.data_quality_config_id = " + str(data_quality_config_id) + " \
                            and is_latest = true;")
            do_conn.commit()

        logger.debug(f"Successfully retrieved dq results from {check_source}")
        return results, json_data
    except Exception as e:
        do_conn.commit()
        do_cursor.execute("update data_operations.data_quality_log set end_datetime = current_timestamp, run_status = 'Error' \
            where data_quality_log_id = " + str(log_id))
        do_conn.commit()
        logger.error(f"Failed to retrieve dq results from {check_source} DB. \n\nRunning: {check_sql} \n\nError: {e}")
        raise
    
def triggered_alert_preprocess(data_quality_config_id,log_id, results, alert_level, alert_message, num_recs, max_show_results,json_data,result_write_type):
    """Pre-Process DQ results when alert triggered"""
    try:
        message_to_send = alert_message + "\n\nNumber of records found: " + str(num_recs)
        logger.debug("DQ " + alert_level + ": " + alert_message + ". Number of records found: " + str(num_recs))
        send_message = "yes"
     
        if show_results or write_results_to_table:
            cnt = 0
            if show_results:
                logger.debug("RESULTS Info: "+results_text)
                message_to_send = message_to_send + "\n\nRESULTS Info: "+results_text
                
            if result_write_type.lower() == 'standard_json':
                for result in json.loads(json_data):
                    cnt = cnt+1
                    # if including results only add results up to the max_show_results number
                    if show_results and cnt <= max_show_results:
                        message_to_send = message_to_send + "\nDQ RESULT: " + str(cnt) + ": " + str(result).replace(',', ',\n')
                        logger.debug("DQ RESULT: " + str(cnt) + ": " + str(result))
    
                    # write json results to standard table
                    if write_results_to_table:
                        do_cursor.execute("insert into " + results_table + " (" + results_table_fields + ") values (" + str(log_id) + ",'" + str(result).replace('\'', '"') + "')")
                        do_conn.commit()
                        
            else:
                
                for result in results:
                    cnt = cnt+1
                    # if including results only add results up to the max_show_results number
                    if show_results and cnt <= max_show_results:
                        message_to_send = message_to_send + "\nDQ RESULT: " + str(cnt) + ": " + str(result)
                        logger.debug("DQ RESULT: " + str(cnt) + ": " + str(result))
    
                    # write results to custom table
                    if result_write_type.lower() == 'custom':
                        new_result = (log_id,) + result
                        do_cursor.execute("insert into " + results_table + " (" + results_table_fields + ") values " + str(new_result))
                        do_conn.commit()
                    
        logger.debug(f"Successfully pre-processed DQ results for log_id: {log_id}")
        return message_to_send
    except Exception as e:
        do_conn.commit()
        do_cursor.execute("update data_operations.data_quality_log set end_datetime = current_timestamp, run_status = 'Error' \
            where data_quality_log_id = " + str(log_id))
        do_conn.commit()
        logger.error(f"Failed to pre-process DQ results for log_id: {log_id} DB. \n\nError: {e}")
        raise

try:
    
    # define sns topics to send to for th is run of the job    
    sns_info_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Info'
    sns_warn_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Warn'
    sns_error_topic2 = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Error'
        
    # Set up logging
    logger = CloudWatchSNSLogger(sns_info_topic = sns_info_topic2, sns_warn_topic = sns_warn_topic2, sns_error_topic = sns_error_topic2)

    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)
    rs_secret_json = retrieve_secrets(rs_secret_name)
    aqe_secret_json = retrieve_secrets(aqe_secret_name)
    asc_secret_json = retrieve_secrets(asc_secret_name)
    ccs_secret_json = retrieve_secrets(ccs_secret_name)

    # Create database connections
    do_conn = create_db_connection(do_secret_json)
    do_cursor = do_conn.cursor()
    
    logger.debug("Selecting rows from dq config table and loop through them in order")
    sql_to_run = f"select data_quality_config_id, \
            alert_message, results_text, check_sql, check_source, \
            custom_results_table, alert_level, abort_process, alert_condition_type, \
            alert_value_min, alert_value_max, show_results, max_show_results,  \
            custom_results_table_fields, include_src_in_message,  \
            include_sql_in_message, send_message_to_sns, result_write_type \
        from data_operations.data_quality_config \
        where schedule_to_run_on = '{schedule}' \
            and current_date between effective_start_date and effective_end_date \
        order by run_order asc"

    do_cursor.execute(sql_to_run)
    sql_results = do_cursor.fetchall()

    # loop through DQ checks to run
    for row in sql_results:
        data_quality_config_id = row[0]
        alert_message = row[1]
        results_text = row[2]
        check_sql = row[3]
        check_source = row[4]
        custom_results_table = row[5]
        alert_level = row[6]
        abort_process = row[7]
        alert_condition_type = row[8]
        alert_value_min = row[9]
        alert_value_max = row[10]
        show_results = row[11]
        max_show_results = row[12]
        custom_results_table_fields = row[13]
        include_src_in_message = row[14]
        include_sql_in_message = row[15]
        send_message_to_sns = row[16]
        result_write_type = row[17]

        # initialize for each iteration
        message_to_send = ""
        send_message = "no"
        if result_write_type.lower() in ['standard_json', 'custom']:
            write_results_to_table = True
        else:
            write_results_to_table = False
            
        # if custom write type use the custom table info
        if result_write_type.lower() == 'custom':
            results_table = custom_results_table
            results_table_fields = custom_results_table_fields
        else:
            results_table = 'data_operations.dq_results'
            results_table_fields = 'data_quality_log_id,result'
            
        if alert_level == 'PROFILE':
            send_message_to_sns = False

        # write log start
        sql = "insert into data_operations.data_quality_log (data_quality_config_id) \
            values("+str(data_quality_config_id)+") RETURNING data_quality_log_id;"
        data_quality_log_id = None
            
        # Execute the insert statement
        do_cursor.execute(sql)
                    
        # Get the generated id back
        rows = do_cursor.fetchone()
        if rows:
            log_id = rows[0]
            # Commit the insert to the database
        do_conn.commit()
                    
        logger.debug(f"Current running DQ step: {data_quality_config_id}.  log_id: {log_id}")
        
        # results for the config record being run
        results, json_data = get_dq_results(check_source,check_sql,log_id,result_write_type,data_quality_config_id,results_table)

        ###############
        # Run logic based on step alert_condition_type (any_result)
        ###############
        if alert_condition_type == "any_result":
            num_recs = len(results)
            if num_recs > 0:
                # alert indicated for this type of check
                send_message = "yes"
                # pre-process the results that were found: writes results to table in indicated and sns message generated
                message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,alert_level,alert_message,num_recs,max_show_results,json_data,result_write_type)
                
        ###############
        # Run logic based on step alert_condition_type (num_recs_in_range)
        ###############
        if alert_condition_type == "num_recs_in_range":
            num_recs = len(results)
            if alert_value_min < num_recs < alert_value_max:
                # alert indicated for this type of check
                send_message = "yes"
                # pre-process the results that were found: writes results to table in indicated and sns message generated
                message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,alert_level,alert_message,num_recs,max_show_results,json_data,result_write_type)

        ###############
        # Run logic based on step alert_condition_type (num_recs_out_range)
        ###############
        if alert_condition_type == "num_recs_out_range":
            num_recs = len(results)
            if num_recs < alert_value_min or num_recs > alert_value_max:
                # alert indicated for this type of check
                send_message = "yes"
                # pre-process the results that were found: writes results to table in indicated and sns message generated
                message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,alert_level,alert_message,num_recs,max_show_results,json_data,result_write_type)

        ###############
        # Run logic based on step alert_condition_type (value_in_range)
        ###############
        if alert_condition_type == "value_in_range":
            num_recs = len(results)
            # make sure query returns only one result
            if num_recs == 1:
                first_data = results[0]
                if alert_value_min < first_data[0] < alert_value_max:
                    # alert indicated for this type of check
                    send_message = "yes"
                    # pre-process the results that were found: writes results to table in indicated and sns message generated
                    message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,alert_level,alert_message,num_recs,max_show_results,json_data,result_write_type)
            # send alert if query does not return one result.
            else:
                message_to_send = "There is a configuration issue that needs to be resolved for DQ check: " + \
                    alert_message + " (config_id: " + str(data_quality_config_id) + ").\n\nSingular value expected, but not returned."
                send_message = "yes"

        ###############
        # Run logic based on step alert_condition_type (value_out_range)
        ###############
        if alert_condition_type == "value_out_range":
            num_recs = len(results)
            # make sure query returns only one result
            if num_recs == 1:
                first_data = results[0]
                if first_data[0] < alert_value_min or first_data[0] > alert_value_max:
                    # alert indicated for this type of check
                    send_message = "yes"
                    message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,alert_level,alert_message,num_recs,max_show_results,json_data,result_write_type)
            # send alert if query does not return one result.
            else:
                message_to_send = "There is a configuration issue that needs to be resolved for DQ check: " + \
                    alert_message + " (config_id: " + str(data_quality_config_id) + ").\n\nSingular value expected, but not returned."
                send_message = "yes"

        # add source to message if set
        if include_src_in_message:
            message_to_send = message_to_send + "\n\nDQ SOURCE: " + check_source

        # add sql statement to message if set
        if include_sql_in_message:
            message_to_send = message_to_send + "\n\nDQ TEST SQL:\n" + check_sql

        if send_message == "yes":
            if send_message_to_sns:
                if alert_level == 'INFO':
                    logger.info(message_to_send)
                if alert_level == 'WARN':
                    logger.warning(message_to_send)
                if alert_level == 'ERROR':
                    logger.error(message_to_send)
            do_cursor.execute("update data_operations.data_quality_log set alert_triggered = true, dq_record_count = " + str(num_recs) + " where data_quality_log_id = " + str(log_id))
            do_conn.commit()

        # write log end
        do_cursor.execute("update data_operations.data_quality_log set end_datetime = current_timestamp, run_status = 'Success' where data_quality_log_id = " + str(log_id) )
        do_conn.commit()
        
    logger.debug("Process Complete")

except (Exception, psycopg2.Error) as error:
    # write log error
    logger.error(f"Unexpected error encountered in job: {job_name}. Error: {error}")
    do_cursor.execute("update data_operations.data_quality_log set end_datetime = current_timestamp, run_status = 'Error' where data_quality_log_id = " + str(log_id))
    do_conn.commit()
    
    print("Error: ", error)

finally:
    # closing database connection.
    if do_conn:
        do_cursor.close()
        do_conn.close()

    if rs_conn:
        rs_cursor.close()
        rs_conn.close()
        print("DB connections are closed")