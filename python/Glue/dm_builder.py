import sys
import re
import psycopg2
import json
import boto3
import pandas as pd
import sqlalchemy as sa
import csv
import logging
import time
import datetime
from awsglue.utils import getResolvedOptions
from CloudWatchSNSLogger import CloudWatchSNSLogger

#Get job parameters
args = getResolvedOptions(sys.argv, ['ENV', 'JOB_CLASS', 'JOB_NAME', 'SCHEDULE', 'REGION', 'DO_SECRET_NAME', 'RS_SECRET_NAME'])
job_name = args['JOB_NAME'] 
env = args['ENV'] 
job_class = args['JOB_CLASS'] 
schedule = args['SCHEDULE']
region = args['REGION']
do_secret_name = args['DO_SECRET_NAME']
rs_secret_name = args['RS_SECRET_NAME']

# Create a global AWS client
sns_client = boto3.client('sns')
session = boto3.Session()
s3_client = session.client('s3')
secrets_client = session.client(service_name='secretsmanager', region_name=region)
account_id = boto3.client("sts").get_caller_identity()["Account"]

# define sns topics to send to for th is run of the job    
sns_info_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Info'
sns_warn_topic2  = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Warn'
sns_error_topic2 = 'arn:aws:sns:' + region + ':' + str(account_id) + ':' + env + '-' + job_class + '-' + 'Error'
        
# Set up logging
logger = CloudWatchSNSLogger(sns_info_topic = sns_info_topic2, sns_warn_topic = sns_warn_topic2, sns_error_topic = sns_error_topic2)

job_start_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
logger.debug(f"job_start_time: {job_start_time}")

# Few variable initializations
std_fields = ['refresh_timestamp','md5_hash','data_action']
        
    
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
            rs_cursor.execute(check_sql)
            results = rs_cursor.fetchall()
            
            # when writing to standard_json table, need results in json format
            if result_write_type.lower() == 'standard_json':
                columns = [column[0] for column in rs_cursor.description]
                json_data_initial = [dict(zip(columns, row)) for row in results]
                json_data = json.dumps(json_data_initial, separators=(',', ':'), default=lambda x: str(x) if isinstance(x, Decimal) else x)
            else:
                json_data = ""
                
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
    
def triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type):
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
    
def dm_dq(dq_schedule_list):
    
    try:
        dq_status = 'dq_passed'
        
        logger.debug("Selecting rows from dq config table and loop through them in order")
        sql_to_run = f"select data_quality_config_id, \
                alert_message, results_text, check_sql, check_source, \
                custom_results_table, alert_level, abort_process, alert_condition_type, \
                alert_value_min, alert_value_max, show_results, max_show_results,  \
                custom_results_table_fields, include_src_in_message,  \
                include_sql_in_message, send_message_to_sns, result_write_type \
            from data_operations.data_quality_config \
            where schedule_to_run_on in ({dq_schedule_list}) \
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
                
            # Do sql replacements
            check_sql = check_sql.replace('###BUILD_SCHEMA###', build_schema_name)
            check_sql = check_sql.replace('###BUILD_TABLE###', build_table_name)
            check_sql = check_sql.replace('###DM_SCHEMA###', dm_schema_name)
            check_sql = check_sql.replace('###DM_TABLE###', dm_table_name)
                
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
                    if abort_process:
                        dq_status = 'dq_abort'
                    # pre-process the results that were found: writes results to table in indicated and sns message generated
                    message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type)
                    
            ###############
            # Run logic based on step alert_condition_type (num_recs_in_range)
            ###############
            if alert_condition_type == "num_recs_in_range":
                num_recs = len(results)
                if alert_value_min < num_recs < alert_value_max:
                    # alert indicated for this type of check
                    send_message = "yes"
                    if abort_process:
                        dq_status = 'dq_abort'
                    # pre-process the results that were found: writes results to table in indicated and sns message generated
                    message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type)
    
            ###############
            # Run logic based on step alert_condition_type (num_recs_out_range)
            ###############
            if alert_condition_type == "num_recs_out_range":
                num_recs = len(results)
                if num_recs < alert_value_min or num_recs > alert_value_max:
                    # alert indicated for this type of check
                    send_message = "yes"
                    if abort_process:
                        dq_status = 'dq_abort'
                    # pre-process the results that were found: writes results to table in indicated and sns message generated
                    message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type)
    
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
                        if abort_process:
                            dq_status = 'dq_abort'
                        # pre-process the results that were found: writes results to table in indicated and sns message generated
                        message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type)
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
                        if abort_process:
                            dq_status = 'dq_abort'
                        message_to_send = triggered_alert_preprocess(data_quality_config_id,log_id,results,results_text,alert_level,alert_message,num_recs,show_results,max_show_results,json_data,result_write_type)
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
            
        return dq_status
    except Exception as e:
        logger.error(f"Failure is dm_dq execution: {e}")
        raise
    
    
logger.debug(f"Sys.argv settings for this run: {sys.argv}")
    
logger.debug(f"Schedule running: {schedule}")
        
try:
    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)
    rs_secret_json = retrieve_secrets(rs_secret_name)
    
    # Create DO database connections
    do_conn = create_db_connection(do_secret_json)

    do_cursor = do_conn.cursor()
    do_cursor_log = do_conn.cursor()
    do_cursor_config = do_conn.cursor()
    do_cursor_table = do_conn.cursor()
    do_cursor_step = do_conn.cursor()
    
    # Create RS database connections
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()
    
    # Query config table 
    sql_to_run_config = "select distinct c.dm_config_id, c.dm_schema_name, c.build_schema_name, c.history_schema_name, \
            c.dm_prefix, current_timestamp as start_time, c.dm_run_order \
        from data_operations.data_mart_config c \
            join data_operations.data_mart_tables t on c.dm_config_id = t.dm_config_id \
        where (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
            and current_date between c.effective_start_date and c.effective_end_date \
        order by c.dm_run_order"
        
    do_cursor_config.execute(sql_to_run_config)
    sql_results_config = do_cursor_config.fetchall()
    count = 0

    # Loop throught config results for Build phase
    for config_row in sql_results_config:
        dm_config_id = config_row[0]
        dm_schema_name = config_row[1]
        build_schema_name = config_row[2]
        history_schema_name = config_row[3]
        dm_prefix = config_row[4]
        start_time = config_row[5]

        if count == 0:
            # store initial start time for later use
            job_start_time = str(start_time)
            logger.debug(f"job_start_time: {job_start_time}")

        count = count + 1
        
        logger.debug(f"Running schedule: {schedule} and dm_schema_name: {dm_schema_name}")

        # Query table table 
        sql_to_run_table = "select distinct t.dm_table_id, t.dm_table_name, t.table_field_list,t.dq_schedule_list, \
                t.finalize_type, t.pk_field_list, t.include_md5_flag, t.track_history_flag, t.run_now_flag, t.dm_table_run_order \
            from data_operations.data_mart_config c \
                join data_operations.data_mart_tables t on c.dm_config_id = t.dm_config_id\
            where (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
                and t.dm_config_id = " + str(dm_config_id) + " \
                and current_date between t.effective_start_date and t.effective_end_date \
            order by t.dm_table_run_order"

        do_cursor_table.execute(sql_to_run_table)
        sql_results_table = do_cursor_table.fetchall()

        for table_row in sql_results_table:
            dm_table_id = table_row[0]
            dm_table_name = table_row[1]
            table_field_list = table_row[2]
            dq_schedule_list = table_row[3]
            finalize_type = table_row[4]
            pk_field_list = table_row[5]
            include_md5_flag = table_row[6]
            track_history_flag= table_row[7]
            run_now_flag  = table_row[8]
            
            logger.debug(f"Running dm_table_name: {dm_table_name}")

            # define build_table_name (concat dm_prefix and dm_table_name)
            build_table_name = dm_prefix + dm_table_name
            
            # Use the unique_record_fields to generate the required unique_record_join_cond for later use.
            pk_cnt = 0
            pk_fields = ''
            unique_fields = []
            result = re.split(",", pk_field_list)
            for row1 in result:
                if pk_cnt == 0:
                    unique_record_join_cond = "n." + row1.strip() + " = c." + row1.strip()
                    pk_fields = "'" + row1.strip() + "'"
                    unique_record_single = "n."+row1.strip()
                    unique_record_join_cond2 = build_table_name + "." + row1.strip() + " = ir." + row1.strip()
                    unique_record_join_cond3 = dm_table_name + "." + row1.strip() + " = n." + row1.strip()
                else:
                    unique_record_join_cond = unique_record_join_cond + " and n."+row1.strip() + " = c." + row1.strip()
                    pk_fields = pk_fields + ", '" + row1.strip() + "'"
                    unique_record_single = unique_record_single + ", n." + row1.strip()
                    unique_record_join_cond2 = unique_record_join_cond2 + " and " + build_table_name + "." + row1.strip() + " = ir." + row1.strip()
                    unique_record_join_cond3 = unique_record_join_cond3 + " and " + dm_table_name + "." + row1.strip() + " = n." + row1.strip()
                pk_cnt = pk_cnt + 1
                unique_fields.append(row1.strip())

            # Query steps table 
            sql_to_run_step = "select s.dm_build_step_id, s.step_action_type, coalesce(s.step_sql, '') as step_sql \
                    from data_operations.data_mart_build_steps s \
                    where s.dm_table_id = " + str(dm_table_id) + " \
                        and current_date between s.effective_start_date and s.effective_end_date \
                        and s.step_action_type in ('create_build_table', 'insert', 'pre_sql_script', 'stage', 'dq') \
                    order by case when s.step_action_type = 'create_build_table' then 1 \
                        when s.step_action_type = 'insert' or s.step_action_type = 'pre_sql_script' then 2 \
                        when s.step_action_type = 'stage' then 3 \
                        when s.step_action_type = 'dq' then 4 \
                        when s.step_action_type = 'finalize' then 5 \
                        when s.step_action_type = 'post_sql_script' then 6 else null end, \
                    s.step_run_order;"

            do_cursor_step.execute(sql_to_run_step)
            sql_results_step = do_cursor_step.fetchall()

            for step_row in sql_results_step:
                dm_build_step_id = step_row[0]
                step_action_type = step_row[1]
                step_sql = step_row[2]
                
                logger.debug(f"Running step_action_type: {step_action_type}")
                
                insert_count = 0
                update_count = 0

                # Do sql replacements
                step_sql = step_sql.replace('###BUILD_SCHEMA###', build_schema_name)
                step_sql = step_sql.replace('###BUILD_TABLE###', build_table_name)
                step_sql = step_sql.replace('###DM_SCHEMA###', dm_schema_name)
                step_sql = step_sql.replace('###DM_TABLE###', dm_table_name)

                # Write initial record into the logging table
                # Set process status = 'starting'
                sql = "INSERT INTO data_operations.data_mart_build_log(dm_build_step_id, run_status, \
                            start_datetime) \
                     VALUES(" + str(dm_build_step_id) + ",'starting',current_timestamp) RETURNING dm_build_log_id;"
                dm_build_log_id = None
            
                # Execute the insert statement
                do_cursor_log.execute(sql)
                    
                # Get the generated id back
                rows = do_cursor_log.fetchone()
                if rows:
                    dm_build_log_id = rows[0]
                # Commit the insert to the database
                do_conn.commit()

                if step_action_type == 'create_build_table':
                    # drop build table if exists
                    rs_cursor.execute("drop table if exists " + build_schema_name + "." + build_table_name)

                    # create build table using provided sql
                    rs_cursor.execute(step_sql)
                    rs_conn.commit()

                elif step_action_type == 'insert':
                    # use provided sql to do insert
                    sql_to_run = "insert into " + build_schema_name + "." + build_table_name + " \
                        (" + table_field_list + ") " + step_sql
                    rs_cursor.execute(sql_to_run)
                    rs_conn.commit()
                    
                    rs_cursor.execute("select coalesce(count(*),0) from " + build_schema_name + "." + build_table_name)
                    sql_results_insert_cnt = rs_cursor.fetchone()
                    insert_count = sql_results_insert_cnt[0]

                elif step_action_type == 'pre_sql_script':
                    # run the provided sql_script
                    rs_cursor.execute(step_sql)
                    rs_conn.commit()

                elif step_action_type == 'stage':
                    if include_md5_flag:
                    # calculate the md5 hash field
                        field_cnt = 0
                        boolean_fields = []
                        pk_cnt = 0
                        
                        rs_cursor.execute("select distinct column_name, data_type, ordinal_position \
                            from information_schema.columns \
                            where table_schema = '" + build_schema_name +"' \
                                and table_name = '" + build_table_name +"' \
                                and column_name not in ( 'refresh_timestamp','md5_hash','data_action' ) \
                                and column_name not in (" + pk_fields + " ) \
                            order by ordinal_position")
                        field_result = rs_cursor.fetchall()
            
                        # if no results found, Redshift tables do not exist yet, send notification and move on to next target table
                        if field_result == []:
                            # Send notification to SNS topic that the required redshift table does not exist
                            logger.error(f"The following table was not found in Redshift: \
                                " + build_schema_name + "." + build_table_name)
                            do_cursor_log.execute("update data_operations.data_mart_build_log \
                                    set end_datetime = current_timestamp, \
                                    run_status = 'error' \
                                where dm_build_log_id = " + str(dm_build_log_id))
                            do_conn.commit()
                            exception
                        
                        for field in field_result:
                            if field[1] == 'boolean':
                                boolean_fields.append(field[0]) 
                            if field_cnt == 0:
                                md5_field_list = field[0]
                            else:
                                md5_field_list = md5_field_list + ',' + field[0] 
                            field_cnt = field_cnt + 1
                    
                        # Generate the md5_hash sql element.
                        result2 = re.split(",",  md5_field_list)
                        md5_hash_sql = 'md5(NVL2('
            
                        for row2 in result2:
                            if row2.strip() not in (unique_fields + std_fields):
                                if pk_cnt == 0:
                                    if row2.strip() in boolean_fields:
                                        md5_hash_sql = md5_hash_sql+'n.'+row2.strip() + ','+'n.'+row2.strip() +"::int::varchar,'null_val')"
                                    else:
                                        md5_hash_sql = md5_hash_sql+'n.'+row2.strip() + ','+'n.'+row2.strip() +"::varchar,'null_val')"
                                else:
                                    if row2.strip() in boolean_fields:
                                        md5_hash_sql = md5_hash_sql + '||NVL2(' +'n.'+row2.strip() + ','+'n.'+row2.strip() +"::int::varchar,'null_val')"
                                    else:
                                        md5_hash_sql = md5_hash_sql + '||NVL2(' +'n.'+row2.strip() + ','+'n.'+row2.strip() +"::varchar,'null_val')"
            
                                pk_cnt = pk_cnt + 1
            
                        md5_hash_sql = md5_hash_sql + ')'
                        
                        # use calculated md5_has_sql to populate the md5_hash field in the build table
                        rs_cursor.execute("update " + build_schema_name + "." + build_table_name + " n \
                            set md5_hash = " + md5_hash_sql + " where true")
                        rs_conn.commit()
            
                    # set the data_action field in the build schema table
                    if finalize_type == 'full_replace':
                        # mark all as insert (I)
                        rs_cursor.execute("update " + build_schema_name + "." + build_table_name + " \
                            set data_action = 'I' where true")
                        rs_conn.commit()

                    elif finalize_type == 'new_only':
                        # mark new recs as insert (I)
                        rs_cursor.execute("with insert_recs as (select " + unique_record_single + " \
                            from " + build_schema_name + "." + build_table_name + " n \
                                left join " + dm_schema_name + "." + dm_table_name + " c \
                                    on " + unique_record_join_cond + " \
                            where c.refresh_timestamp is null) \
                            update " + build_schema_name + "." + build_table_name + " \
                            set data_action = 'I' \
                            from insert_recs ir \
                            where " + unique_record_join_cond2)
                        rs_conn.commit()

                    elif finalize_type == 'new_and_replace':
                        # mark new recs as insert (I) and existing as update (U)
                        rs_cursor.execute("with insert_recs as (select " + unique_record_single + " \
                            from " + build_schema_name + "." + build_table_name + " n \
                                left join " + dm_schema_name + "." + dm_table_name + " c \
                                    on " + unique_record_join_cond + " \
                            where c.refresh_timestamp is null) \
                            update " + build_schema_name + "." + build_table_name + " \
                            set data_action = 'I' \
                            from insert_recs ir \
                            where " + unique_record_join_cond2)
                            
                        rs_cursor.execute("update " + build_schema_name + "." + build_table_name + " n \
                            set data_action = 'U' \
                            from " + dm_schema_name + "." + dm_table_name + " c \
                            where " + unique_record_join_cond)
                        rs_conn.commit()

                    elif finalize_type == 'new_and_updates':
                        # mark new recs as insert (I) and changes as update(U)
                        rs_cursor.execute("with insert_recs as (select " + unique_record_single + " \
                            from " + build_schema_name + "." + build_table_name + " n \
                                left join " + dm_schema_name + "." + dm_table_name + " c \
                                    on " + unique_record_join_cond + " \
                            where c.refresh_timestamp is null) \
                            update " + build_schema_name + "." + build_table_name + " \
                            set data_action = 'I' \
                            from insert_recs ir \
                            where " + unique_record_join_cond2)
                            
                        rs_cursor.execute("update " + build_schema_name + "." + build_table_name + " n \
                            set data_action = 'U' \
                            from " + dm_schema_name + "." + dm_table_name + " c \
                            where " + unique_record_join_cond + " \
                                and n.md5_hash != c.md5_hash")
                        rs_conn.commit()

                    else:
                        logger.error("Unknown finalize type.")
                        do_cursor_log.execute("update data_operations.data_mart_build_log \
                            set end_datetime = current_timestamp, \
                            run_status = 'error' \
                        where dm_build_log_id = " + str(dm_build_log_id))
                        do_conn.commit()
                        exception
                        
                    rs_cursor.execute("select coalesce(sum(case when data_action = 'I' then 1 else 0 end),0) as ins_count, \
                                    coalesce(sum(case when data_action = 'U' then 1 else 0 end),0) as upd_count \
                                from " + build_schema_name + "." + build_table_name)
                    sql_results_data_cnt = rs_cursor.fetchone()
                    insert_count = sql_results_data_cnt[0]
                    update_count = sql_results_data_cnt[1]

                elif step_action_type == 'dq':
                    # run DQ check for specified dq_schedule_list
                    dq_status = dm_dq(dq_schedule_list)
                    
                    logger.debug(f"DQ status: {dq_status}")

                    do_cursor_log.execute("update data_operations.data_mart_build_log \
                            set end_datetime = current_timestamp, \
                                insert_count = " + str(insert_count) + ", \
                                update_count = " + str(update_count) + ", \
                                run_status = '" + dq_status + "' \
                        where dm_build_log_id = " + str(dm_build_log_id))
                    do_conn.commit()

                else:
                    logger.error("Unknown step action type.")
                    do_cursor_log.execute("update data_operations.data_mart_build_log \
                            set end_datetime = current_timestamp, \
                            run_status = 'error' \
                        where dm_build_log_id = " + str(dm_build_log_id))
                    do_conn.commit()
                    exception

                if step_action_type != 'dq':
                    do_cursor_log.execute("update data_operations.data_mart_build_log \
                            set end_datetime = current_timestamp, \
                                insert_count = " + str(insert_count) + ", \
                                update_count = " + str(update_count) + ", \
                                run_status = 'success' \
                        where dm_build_log_id = " + str(dm_build_log_id))
                    do_conn.commit()

    logger.debug("Build complete, sql_to_run_dm_issue_check starting")
    # Check if any dq_abort log records or others that did not finish successfully
    sql_to_run_dm_issue_check = "select coalesce(count(*), 0) as abort_count \
        from data_operations.data_mart_config c \
            join data_operations.data_mart_tables t on c.dm_config_id = t.dm_config_id \
            join data_operations.data_mart_build_steps s on t.dm_table_id = s.dm_table_id \
            join data_operations.data_mart_build_log l on s.dm_build_step_id = l.dm_build_step_id \
        where (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
            and s.step_action_type in ('create_build_table', 'insert', 'pre_sql_script', 'stage', 'dq') \
            and l.run_status in ('dq_abort', 'starting', 'error') \
            and l.start_datetime >= '" + job_start_time + "' \
            and current_date between c.effective_start_date and c.effective_end_date \
            and current_date between t.effective_start_date and t.effective_end_date \
            and current_date between s.effective_start_date and s.effective_end_date;"

    do_cursor_log.execute(sql_to_run_dm_issue_check)
    sql_results_dm_issue_check = do_cursor_log.fetchone()
    dm_issue_count = sql_results_dm_issue_check[0]
    
    logger.debug("sql_to_run_dm_issue_check complete")
    
    # If none:  Do the finalize steps.
    if dm_issue_count == 0:
        
        logger.debug("No issues found, starting finalize steps.")
        
        # All in one transaction
        # Query config table 
        sql_to_run_config = "select distinct c.dm_config_id, c.dm_schema_name, c.build_schema_name, c.history_schema_name, \
                c.dm_prefix, c.dm_run_order \
            from data_operations.data_mart_config c \
                join data_operations.data_mart_tables t on c.dm_config_id = t.dm_config_id \
            where (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
                and current_date between c.effective_start_date and c.effective_end_date \
            order by c.dm_run_order"
        
        do_cursor_config.execute(sql_to_run_config)
        sql_results_config = do_cursor_config.fetchall()

        for config_row in sql_results_config:
            dm_config_id = config_row[0]
            dm_schema_name = config_row[1]
            build_schema_name = config_row[2]
            history_schema_name = config_row[3]
            dm_prefix = config_row[4]

            # Query table table 
            sql_to_run_table = "select distinct t.dm_table_id, t.dm_table_name, t.table_field_list,t.dq_schedule_list, \
                    t.finalize_type, t.pk_field_list, t.include_md5_flag, t.track_history_flag, t.run_now_flag, t.dm_table_run_order \
                from data_operations.data_mart_config c \
                    join data_operations.data_mart_tables t on c.dm_config_id = t.dm_config_id \
                where (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
                    and t.dm_config_id = " + str(dm_config_id) + " \
                    and current_date between t.effective_start_date and t.effective_end_date \
                order by t.dm_table_run_order"

            do_cursor_table.execute(sql_to_run_table)
            sql_results_table = do_cursor_table.fetchall()

            for table_row in sql_results_table:
                dm_table_id = table_row[0]
                dm_table_name = table_row[1]
                table_field_list = table_row[2]
                dq_schedule_list = table_row[3]
                finalize_type = table_row[4]
                pk_field_list = table_row[5]
                include_md5_flag = table_row[6]
                track_history_flag= table_row[7]
                run_now_flag  = table_row[8]
                
                logger.debug(f"Finalizing table: {dm_table_name}")
    
                # define build_table_name (concat dm_prefix and dm_table_name)
                build_table_name = dm_prefix + dm_table_name
                
                # Use the unique_record_fields to generate the required unique_record_join_cond for later use.
                pk_cnt = 0
                pk_fields = ''
                unique_fields = []
                result = re.split(",", pk_field_list)
                for row1 in result:
                    if pk_cnt == 0:
                        unique_record_join_cond = "n." + row1.strip() + " = c." + row1.strip()
                        pk_fields = "'" + row1.strip() + "'"
                        unique_record_single = "n."+row1.strip()
                        unique_record_join_cond2 = build_table_name + "." + row1.strip() + " = ir." + row1.strip()
                        unique_record_join_cond3 = dm_table_name + "." + row1.strip() + " = n." + row1.strip()
                    else:
                        unique_record_join_cond = unique_record_join_cond + " and n."+row1.strip() + " = c." + row1.strip()
                        pk_fields = pk_fields + ", '" + row1.strip() + "'"
                        unique_record_single = unique_record_single + ", n." + row1.strip()
                        unique_record_join_cond2 = unique_record_join_cond2 + " and " + build_table_name + "." + row1.strip() + " = ir." + row1.strip()
                        unique_record_join_cond3 = unique_record_join_cond3 + " and " + dm_table_name + "." + row1.strip() + " = n." + row1.strip()
                    pk_cnt = pk_cnt + 1
                    unique_fields.append(row1.strip())

                # Query steps table 
                sql_to_run_step = "select s.dm_build_step_id, s.step_action_type, coalesce(s.step_sql, '') as step_sql \
                        from data_operations.data_mart_build_steps s \
                        where s.dm_table_id = " + str(dm_table_id) + " \
                            and current_date between s.effective_start_date and s.effective_end_date \
                            and s.step_action_type in ('finalize', 'post_sql_script') \
                        order by case when s.step_action_type = 'create_build_table' then 1 \
                            when s.step_action_type = 'insert' or s.step_action_type = 'pre_sql_script' then 2 \
                            when s.step_action_type = 'stage' then 3 \
                            when s.step_action_type = 'dq' then 4 \
                            when s.step_action_type = 'finalize' then 5 \
                            when s.step_action_type = 'post_sql_script' then 6 else null end, \
                        s.step_run_order;"

                do_cursor_step.execute(sql_to_run_step)
                sql_results_step = do_cursor_step.fetchall()

                for step_row in sql_results_step:
                    dm_build_step_id = step_row[0]
                    step_action_type = step_row[1]
                    step_sql = step_row[2]
                    
                    insert_count = 0
                    update_count = 0
                    
                    # Do sql replacements
                    step_sql = step_sql.replace('###BUILD_SCHEMA###', build_schema_name)
                    step_sql = step_sql.replace('###BUILD_TABLE###', build_table_name)
                    step_sql = step_sql.replace('###DM_SCHEMA###', dm_schema_name)
                    step_sql = step_sql.replace('###DM_TABLE###', dm_table_name)
                    
                    # Write initial record into the logging table
                    # Set process status = 'starting'
                    sql = "INSERT INTO data_operations.data_mart_build_log(dm_build_step_id, run_status, \
                                start_datetime) \
                         VALUES(" + str(dm_build_step_id) + ",'starting',current_timestamp) RETURNING dm_build_log_id;"
                    dm_build_log_id = None
                
                    # Execute the insert statement
                    do_cursor_log.execute(sql)
                        
                    # Get the generated id back
                    rows = do_cursor_log.fetchone()
                    if rows:
                        dm_build_log_id = rows[0]
                    # Commit the insert to the database
                    do_conn.commit()
                    
                    if step_action_type == 'post_sql_script':
                        logger.debug(f"post_sql_script found for table: {dm_table_name}")
                        # run the provided sql_script
                        rs_cursor.execute(step_sql)
                        
                        # set run_status to pending for any post_sql_script steps.
                        do_cursor_log.execute("update data_operations.data_mart_build_log \
                                set end_datetime = current_timestamp, \
                                run_status = 'pending' \
                            where dm_build_log_id = " + str(dm_build_log_id))
                        do_conn.commit()
                        
                    if step_action_type == 'finalize':
                        # set the data_action field in the build schema table
                        if finalize_type == 'full_replace':
                            # truncate dm table and insert I records. 
                            rs_cursor.execute("truncate table " + dm_schema_name + "." + dm_table_name)
                            
                            rs_cursor.execute("insert into " + dm_schema_name + "." + dm_table_name + " (" + table_field_list + ") \
                                select " + table_field_list + " from " + build_schema_name + "." + build_table_name + \
                                    " where data_action = 'I'")
    
                        elif finalize_type == 'new_only':
                            # insert I records
                            rs_cursor.execute("insert into " + dm_schema_name+ "." + dm_table_name + " (" + table_field_list + ") \
                                select " + table_field_list + " from " + build_schema_name + "." + build_table_name + \
                                    " where data_action = 'I'")
    
                        elif finalize_type == 'new_and_replace' or finalize_type == 'new_and_updates':
                            # delete existing U reports and then insert I and U records
                            rs_cursor.execute("delete from " + dm_schema_name + "." + dm_table_name + " \
                                using " + build_schema_name + "." + build_table_name + " n \
                                where " + unique_record_join_cond3 + " \
                                    and n.data_action = 'U'")
                            
                            rs_cursor.execute("insert into " + dm_schema_name + "." + dm_table_name + " (" + table_field_list + ") \
                                select " + table_field_list + " from " + build_schema_name + "." + build_table_name + \
                                    " where data_action in ('I', 'U')")
    
                        else:
                            logger.error("Unknown finalize type.")
                            do_cursor_log.execute("update data_operations.data_mart_build_log \
                                set end_datetime = current_timestamp, \
                                run_status = 'error' \
                            where dm_build_log_id = " + str(dm_build_log_id))
                            do_conn.commit()
                            exception
                            
                        rs_cursor.execute("select coalesce(sum(case when data_action = 'I' then 1 else 0 end),0) as ins_count, \
                                        coalesce(sum(case when data_action = 'U' then 1 else 0 end),0) as upd_count \
                                    from " + build_schema_name + "." + build_table_name)
                        sql_results_data_cnt = rs_cursor.fetchone()
                        insert_count = sql_results_data_cnt[0]
                        update_count = sql_results_data_cnt[1]
                            
                        # set run_status to pending for finalize steps
                        do_cursor_log.execute("update data_operations.data_mart_build_log \
                                set end_datetime = current_timestamp, \
                                run_status = 'pending', \
                                insert_count = " + str(insert_count) + ", \
                                update_count = " + str(update_count) + " \
                            where dm_build_log_id = " + str(dm_build_log_id))
                        do_conn.commit()
                    
        # commit when all done
        rs_conn.commit()    
                
        # set finalize logs to success    
        do_cursor_log.execute("update data_operations.data_mart_build_log l \
                            set run_status = 'success' \
                    from data_operations.data_mart_build_steps s \
                        join data_operations.data_mart_tables t on s.dm_table_id = t.dm_table_id \
                        join data_operations.data_mart_config c on t.dm_config_id = c.dm_config_id \
                    where l.dm_build_step_id = s.dm_build_step_id \
                        and (c.schedule_to_run_on = '" + schedule + "' or case when '" + schedule + "' = 'run_now' then t.run_now_flag else false end) \
                        and s.step_action_type in  ('finalize', 'post_sql_script') \
                        and l.start_datetime > '" + job_start_time + "' \
                        and l.run_status = 'pending'")
        do_conn.commit()
        
        if schedule == 'run_now':
            # if schedule is run_now, set any run_now true records to false
            do_cursor_log.execute("update data_operations.data_mart_tables \
                            set run_now_flag = false \
                            where run_now_flag = true;")
            do_conn.commit()
        
    else:
        logger.error("DM issues were found!!")


except Exception as error:
    
    # If connections open, rollback and close
    if do_conn:
        do_conn.rollback()
        do_cursor_log.close()
        do_conn.close()
        logger.debug("DataOps PostgreSQL connection is closed")
        
    if rs_conn:
        rs_conn.rollback()
        rs_cursor.close()
        rs_conn.close()
        logger.debug("Redshift connection is closed")

    logger.error(f"Error: {error}")