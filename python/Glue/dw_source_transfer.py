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
import time
from awsglue.utils import getResolvedOptions


logger = logging.getLogger()
logger.setLevel(logging.INFO)
# Create a StreamHandler to output to stdout
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
# Create a FileHandler to log to a file
file_handler = logging.FileHandler("/tmp/dw_source_transfer.log")
# Create a formatter to customize the log message format
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(handler)

# Few variable initializations
s3_data_bucket = "bloom-dev-data-team"
s3_data_path = "DW_Data_Loads/"
region_name = "us-west-2"
std_fields = ["refresh_timestamp", "data_transfer_log_id", "md5_hash"]
do_secret_name = "etluser/dev/rds"
ss_secret_name = "dev/aqe/etluser"
rs_secret_name = "prod/dw/Redshift/etluser"
domain_name = "RMGCOM"
schedule_value = "run_now"
schedule_param = False
data_prep_error_count = 0
finalizing_error_count = 0
quote_char = '"'
sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"

# Create a global AWS client
sns_client = boto3.client("sns")
session = boto3.Session()
s3_client = session.client("s3")
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


def delete_all_objects(bucket_name, prefix=""):
    """Deletes all objects in an S3 bucket under the specified prefix."""
    s3 = boto3.resource("s3")
    bucket = s3.Bucket(bucket_name)

    objects_to_delete = []
    for obj in bucket.objects.filter(Prefix=prefix):
        objects_to_delete.append({"Key": obj.key})
        # Batch delete in chunks of 1000 (S3 limit)
        if len(objects_to_delete) == 1000:
            try:
                bucket.delete_objects(Delete={"Objects": objects_to_delete})
                logger.info(
                    f"Deleted 1000 objects from {bucket_name} with prefix {prefix}"
                )
            except Exception as e:
                logger.error(f"Failed to delete objects: {e}")
            objects_to_delete = []

    # Delete any remaining objects
    if objects_to_delete:
        try:
            bucket.delete_objects(Delete={"Objects": objects_to_delete})
            logger.info(
                f"Deleted remaining {len(objects_to_delete)} objects from {bucket_name} with prefix {prefix}"
            )
        except Exception as e:
            logger.error(f"Failed to delete objects: {e}")


# Function to trim all string fields in a dataframe and also replace any
# Microsoft non-breaking space characters with a normal space.
def trim_all_columns_remove_nbsp(df):
    """
    Trim whitespace from ends of each value across all series in dataframe
    """
    try:
        # Vectorized operation to replace non-breaking spaces and trim whitespace
        df = df.applymap(
            lambda x: x.replace("\xa0", " ").strip() if isinstance(x, str) else x
        )
        logger.info("Successfully trimmed all columns and removed non-breaking spaces.")
        return df
    except Exception as e:
        logger.error(f"Failed to trim columns and remove non-breaking spaces: {e}")
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


def id_processing_schemas(target_identifier):
    if target_identifier == "redshift_prod_aqe":
        integrated_schema = "integrated_aqe"
        landing_schema = "landing_aqe"
        staging_schema = "staging_aqe"
        history_schema = "aqe_history"
    if target_identifier == "redshift_prod_asc":
        integrated_schema = "integrated_asc"
        landing_schema = "landing_asc"
        staging_schema = "staging_asc"
        history_schema = "asc_history"
    if target_identifier == "redshift_prod_ccs":
        integrated_schema = "integrated_ccs"
        landing_schema = "landing_ccs"
        staging_schema = "staging_ccs"
        history_schema = "ccs_history"

    return landing_schema, staging_schema, integrated_schema, history_schema


logger.info(f"Sys.argv settings for this run: {sys.argv}")

# Get job parameters
args = getResolvedOptions(sys.argv, ["schedule"])

# Extract parameters
schedule_value = args["schedule"]

if schedule_value == "run_now":
    schedule_clause = " and run_now is true"
elif schedule_value == "error_rerun":
    schedule_clause = " "
else:
    schedule_clause = (
        " and coalesce(c.override_schedule, t.schedule) = '" + schedule_value + "'"
    )

if schedule_value.startswith("hourly_"):
    sleep_time = 30
else:
    sleep_time = 60

logger.info(f"Schedule running: {schedule_value}")

try:
    # Retrieve secrets
    do_secret_json = retrieve_secrets(do_secret_name)
    rs_secret_json = retrieve_secrets(rs_secret_name)
    ss_secret_json = retrieve_secrets(ss_secret_name)

    user_name = domain_name + "\\" + ss_secret_json["username"]

    # Create DO database connections
    do_conn = create_db_connection(do_secret_json)

    do_cursor = do_conn.cursor()
    do_cursor1 = do_conn.cursor()

    # Create RS database connections
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()

    # Query config table to determine tables being written to so those landing and staging tables can be truncated
    # for subsequent steps.
    if schedule_value == "error_rerun":
        sql_to_run = "with configs_to_include as (select l1.data_transfer_config_id \
                    from data_operations.data_transfer_log l1 \
                        join data_operations.data_transfer_log l2 on l1.data_transfer_config_id = l2.data_transfer_config_id \
                    where l1.start_datetime > current_timestamp - interval '24' hour \
                        and l2.start_datetime > current_timestamp - interval '24' hour \
                        and l1.run_status like '%error%' \
                        and l2.run_status not like '%error%' \
                    group by 1 \
                    having max(l1.start_datetime) > max(l2.start_datetime)) \
                select distinct t.target_table, t.target_identifier, t.track_history, t.history_tracking_setup, t.unique_record_fields, \
                    t.incr_where_clause, t.full_where_clause, t.run_order, t.data_transfer_target_id \
                from data_operations.data_transfer_target t \
                    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                    join data_operations.data_transfer_log l on c.data_transfer_config_id = l.data_transfer_config_id \
                    join configs_to_include cti on c.data_transfer_config_id = cti.data_transfer_config_id \
                where current_date between t.effective_start_date and t.effective_end_date \
                    and current_date between c.effective_start_date and c.effective_end_date \
                    and l.run_status like '%error%' \
                    and l.start_datetime > current_timestamp - interval '24' hour \
                order by t.run_order \
                limit 10"
    else:
        sql_to_run = (
            "select distinct t.target_table, t.target_identifier, t.track_history, t.history_tracking_setup, \
            t.unique_record_fields, t.incr_where_clause, t.full_where_clause, t.run_order, t.data_transfer_target_id \
            from data_operations.data_transfer_target t \
                join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
            where current_date between t.effective_start_date and t.effective_end_date \
                and current_date between c.effective_start_date and c.effective_end_date "
            + schedule_clause
            + " \
            order by t.run_order"
        )

    do_cursor.execute(sql_to_run)
    sql_results0 = do_cursor.fetchall()

    for row in sql_results0:
        try:
            target_table = row[0]
            target_identifier = row[1]
            track_history = row[2]
            history_tracking_setup = row[3]
            unique_record_fields = row[4]
            incr_where_clause = row[5]
            full_where_clause = row[6]
            run_order = row[7]
            data_transfer_target_id = row[8]

            insert_count_sum = 0
            update_count_sum = 0
            delete_count_sum = 0
            max_pk_apply_list = []
            unique_record_join_cond = ""
            pk_cnt = 0
            unique_fields = []
            boolean_fields = []
            field_list = ""
            field_cnt = 0

            # check if any targets are currently running:
            do_cr_cursor = do_conn.cursor()
            do_cr_cursor.execute(
                "select max(currently_running::int)::boolean \
                    from data_operations.data_transfer_target \
                    where target_identifier = '"
                + target_identifier
                + "' \
                        and target_table = '"
                + target_table
                + "'"
            )
            sql_cr_results = do_cr_cursor.fetchone()
            currently_running = sql_cr_results[0]

            if currently_running == True:
                counter = 0
                while counter < 5:
                    logger.info(
                        f"Processing for: {target_table} running, letting finish. Interation: {counter}.  Sleeping: {sleep_time}."
                    )
                    time.sleep(sleep_time)
                    counter += 1
                    # check if still running
                    do_cr_cursor.execute(
                        "select max(currently_running::int)::boolean \
                                from data_operations.data_transfer_target \
                                where target_identifier = '"
                        + target_identifier
                        + "' \
                                    and target_table = '"
                        + target_table
                        + "'"
                    )
                    sql_cr_results = do_cr_cursor.fetchone()
                    currently_running = sql_cr_results[0]

                    if currently_running == False:
                        logger.info(
                            f"Prior processing for: {target_table} has finished. Continue."
                        )
                        break

            # if still running close cursor, send alert and continue to next table (skipping this one)
            if currently_running == True:
                logger.info(
                    f"Skipping table: {target_table}. ID: {data_transfer_target_id}.  Currently running."
                )
                do_cr_cursor.close()
                #  Send alert
                # Send notification to SNS topic that errors were encountered
                error_email_subject = "DW Source Transfer Skipped Table Encountered!"
                error_message_to_send = (
                    "During running of: dw_source_transfer glue job, Schedule: "
                    + schedule_value
                    + " table: "
                    + target_table
                    + " was skipped due to prior running process!!"
                )
                msg_id = publish_message(
                    sns_topic, error_message_to_send, error_email_subject
                )

                continue

            else:
                # Set current_running to True in target table and close cursor
                do_cr_cursor.execute(
                    "update data_operations.data_transfer_target set currently_running = true \
                                        where data_transfer_target_id = "
                    + str(data_transfer_target_id)
                )
                do_conn.commit()
                do_cr_cursor.close()

            logger.info(f"Starting process for: {target_table}")
            landing_schema, staging_schema, integrated_schema, history_schema = (
                id_processing_schemas(target_identifier)
            )

            # Use the unique_record_fields to generate the required unique_record_join_cond for later use.
            result = re.split(",", unique_record_fields)
            for row1 in result:
                if pk_cnt == 0:
                    unique_record_join_cond = (
                        "n." + row1.strip() + " = c." + row1.strip()
                    )
                else:
                    unique_record_join_cond = (
                        unique_record_join_cond
                        + " and n."
                        + row1.strip()
                        + " = c."
                        + row1.strip()
                    )
                pk_cnt = pk_cnt + 1
                unique_fields.append(row1.strip())

            # Pull list of fields for table processing.
            rs_cursor.execute(
                "select distinct column_name, data_type, ordinal_position \
                from information_schema.columns \
                where table_schema = '"
                + integrated_schema
                + "' \
                    and table_name = '"
                + target_table
                + "' \
                    and column_name != 'dw_table_pk' \
                order by ordinal_position"
            )
            field_result = rs_cursor.fetchall()

            # if no results found, Redshift tables do not exist yet, send notification and move on to next target table
            if field_result == []:
                # Send notification to SNS topic that the required redshift table does not exist
                error_email_subject = (
                    "DW Source Transfer Missing Redshift Table Encountered!"
                )
                error_message_to_send = (
                    "During running of: dw_source_transfer glue job, the following table was not found in Redshift: "
                    + integrated_schema
                    + "."
                    + target_table
                )
                msg_id = publish_message(
                    sns_topic, error_message_to_send, error_email_subject
                )

                continue

            for field in field_result:
                if field[1] == "boolean":
                    boolean_fields.append(field[0])
                if field_cnt == 0:
                    field_list = field[0]
                else:
                    field_list = field_list + "," + field[0]
                field_cnt = field_cnt + 1

            # Generate the md5_hash sql element.
            result2 = re.split(",", field_list)
            pk_cnt = 0
            md5_hash_sql = "md5(NVL2("

            for row2 in result2:
                if row2.strip() not in (unique_fields + std_fields):
                    if pk_cnt == 0:
                        if row2.strip() in boolean_fields:
                            md5_hash_sql = (
                                md5_hash_sql
                                + "n."
                                + row2.strip()
                                + ","
                                + "n."
                                + row2.strip()
                                + "::int::varchar,'null_val')"
                            )
                        else:
                            md5_hash_sql = (
                                md5_hash_sql
                                + "n."
                                + row2.strip()
                                + ","
                                + "n."
                                + row2.strip()
                                + "::varchar,'null_val')"
                            )
                    else:
                        if row2.strip() in boolean_fields:
                            md5_hash_sql = (
                                md5_hash_sql
                                + "||NVL2("
                                + "n."
                                + row2.strip()
                                + ","
                                + "n."
                                + row2.strip()
                                + "::int::varchar,'null_val')"
                            )
                        else:
                            md5_hash_sql = (
                                md5_hash_sql
                                + "||NVL2("
                                + "n."
                                + row2.strip()
                                + ","
                                + "n."
                                + row2.strip()
                                + "::varchar,'null_val')"
                            )

                    pk_cnt = pk_cnt + 1

            md5_hash_sql = md5_hash_sql + ")"

            # Truncate the staging table
            logger.info("Truncate staging table")
            rs_cursor.execute("truncate table " + staging_schema + "." + target_table)
            rs_conn.commit()

            #############################################################
            # Prep steps complete, move to looping through config records
            # and pull, land and stage the data
            #############################################################
            # Query the config table for all records to pull data for in this run.
            if schedule_value == "error_rerun":
                sql_to_run = (
                    "with configs_to_include as (select l1.data_transfer_config_id \
                    from data_operations.data_transfer_log l1 \
                        join data_operations.data_transfer_log l2 on l1.data_transfer_config_id = l2.data_transfer_config_id \
                    where l1.start_datetime > current_timestamp - interval '24' hour \
                        and l2.start_datetime > current_timestamp - interval '24' hour \
                        and l1.run_status like '%error%' \
                        and l2.run_status not like '%error%' \
                    group by 1 \
                    having max(l1.start_datetime) > max(l2.start_datetime)) \
                select distinct c.data_transfer_config_id, data_transfer_type, \
                    source_host, source_db, source_schema, source_table, \
                    reference_id, overlap_treatment,force_full_run_update, transfer_sql, \
                    coalesce(override_incr_where_clause, ''), c.max_pk_val, c.pk_val_lookback_cnt \
                from data_operations.data_transfer_target t \
                    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                    join data_operations.data_transfer_sql s on c.data_transfer_sql_id = s.data_transfer_sql_id \
                    join data_operations.data_transfer_log l on c.data_transfer_config_id = l.data_transfer_config_id \
                    join configs_to_include cti on c.data_transfer_config_id = cti.data_transfer_config_id \
                where current_date between t.effective_start_date and t.effective_end_date \
                    and current_date between c.effective_start_date and c.effective_end_date \
                    and l.run_status like '%error%' \
                    and l.start_datetime > current_timestamp - interval '24' hour \
                    and target_identifier = '"
                    + target_identifier
                    + "' \
                    and target_table = '"
                    + target_table
                    + "' "
                    + schedule_clause
                    + " \
                order by c.data_transfer_config_id asc"
                )
            else:
                sql_to_run = (
                    "select data_transfer_config_id, data_transfer_type, \
                    source_host, source_db, source_schema, source_table, \
                    reference_id, overlap_treatment,force_full_run_update, transfer_sql, \
                    coalesce(override_incr_where_clause, ''), c.max_pk_val, c.pk_val_lookback_cnt \
                from data_operations.data_transfer_target t \
                    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                    join data_operations.data_transfer_sql s on c.data_transfer_sql_id = s.data_transfer_sql_id \
                where current_date between c.effective_start_date and c.effective_end_date \
                    and target_identifier = '"
                    + target_identifier
                    + "' \
                    and target_table = '"
                    + target_table
                    + "' "
                    + schedule_clause
                    + " \
                order by c.data_transfer_config_id asc"
                )

            do_cursor1.execute(sql_to_run)
            sql_results1 = do_cursor1.fetchall()

            # Loop through records to land and stage data for
            # Write values into meaningful variable names.
            for row in sql_results1:
                try:
                    data_transfer_config_id = row[0]
                    data_transfer_type = row[1]
                    source_host = row[2]
                    source_db = row[3]
                    source_schema = row[4]
                    source_table = row[5]
                    reference_id = row[6]
                    overlap_treatment = row[7]
                    force_full_run_update = row[8]
                    transfer_sql = row[9]
                    override_incr_where_clause = row[10]
                    max_pk_val = row[11]
                    pk_val_lookback_cnt = row[12]

                    logger.info(
                        f"Processing config ID: {schedule_value} -> {source_host}: {source_db}.{source_schema}.{source_table}"
                    )

                    # Write initial record into the logging table
                    # Set process status = 'starting'
                    sql = (
                        "INSERT INTO data_operations.data_transfer_log(data_transfer_config_id, run_status, \
                                start_datetime) \
                         VALUES("
                        + str(data_transfer_config_id)
                        + ",'starting',current_timestamp) RETURNING data_transfer_log_id;"
                    )
                    data_transfer_log_id = None

                    # Execute the insert statement
                    do_cursor.execute(sql)

                    # Get the generated id back
                    rows = do_cursor.fetchone()
                    if rows:
                        data_transfer_log_id = rows[0]
                    # Commit the insert to the database
                    do_conn.commit()

                    # Truncate the landing table
                    logger.info("Truncate landing table")
                    rs_cursor.execute(
                        "truncate table " + landing_schema + "." + target_table
                    )
                    rs_conn.commit()

                    # Delete the S3 objects with the specified key
                    delete_all_objects(
                        s3_data_bucket, s3_data_path + schedule_value + "_dw_src_xfer_"
                    )

                    # If forcing a full run update (also set the overlap treatment to update)
                    if force_full_run_update:
                        overlap_treatment = "update"

                    # Open connection to source
                    url = (
                        "mssql+pymssql://"
                        + user_name
                        + ":"
                        + ss_secret_json["password"]
                        + "@"
                        + source_host
                        + "/"
                        + source_db
                    )
                    engine = sa.create_engine(url, connect_args={"tds_version": "7.3"})

                    # Define query based on configured transfer type
                    if data_transfer_type == "Incr":
                        # in type Incr and override is set, use that instead
                        if override_incr_where_clause != "":
                            incr_where_clause = override_incr_where_clause

                        query = transfer_sql + " " + incr_where_clause

                        if "###MAX_PK_VAL###" in query:
                            # if max pk value <= -777777, can not use the MAX_PK_VAL logic (from running of dw_transfer_config_reset_max_pks job)
                            if max_pk_val <= -777777:
                                ## send alert of config issue
                                logger.warn("MAX_PK_VAL invalid usage WARNING!!")
                                error_email_subject = "DW Source Transfer Invalid MAX_PK_VAL Usage Warning!"
                                error_message_to_send = "During running of: dw_source_transfer glue job, an invalid MAX_PK_VAL usage was encountered!!"
                                msg_id = publish_message(
                                    sns_topic,
                                    error_message_to_send,
                                    error_email_subject,
                                )

                                # Write updates to logging table
                                do_cursor.execute(
                                    "update data_operations.data_transfer_log \
                                    set run_status = 'max_pk_config_error', \
                                        data_prep_end_datetime = current_timestamp \
                                    where data_transfer_log_id = "
                                    + str(data_transfer_log_id)
                                )
                                do_conn.commit()

                                # Go to next config record for this target table
                                continue

                            use_max_pk_val = True
                            max_pk_val_to_use = max_pk_val - pk_val_lookback_cnt
                            query = query.replace(
                                "###MAX_PK_VAL###", str(max_pk_val_to_use)
                            )
                        else:
                            use_max_pk_val = False

                        if "###PK_FIELD###" in query:
                            # lookup pk field source DB
                            pk_query = (
                                "use "
                                + source_db
                                + "; \
                                SELECT COLUMN_NAME as pk_field \
                                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE \
                                WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1 \
                                AND TABLE_NAME = '"
                                + source_table
                                + "' AND TABLE_SCHEMA = '"
                                + source_schema
                                + "';"
                            )
                            pk_df = pd.read_sql(pk_query, engine)
                            pk_field = pk_df.pk_field[0]
                            query = query.replace("###PK_FIELD###", pk_field)
                    else:
                        use_max_pk_val = False

                    # If force_full_run_update, force the use of the configured full_where_clause
                    if data_transfer_type == "Full" or force_full_run_update is True:
                        query = transfer_sql + " " + full_where_clause

                    # Perform any indicated variable substitutions.
                    if "###SRC_DB###" in query:
                        query = query.replace("###SRC_DB###", source_db)
                    if "###SRC_SCHEMA###" in query:
                        query = query.replace("###SRC_SCHEMA###", source_schema)
                    if "###SRC_TABLE###" in query:
                        query = query.replace("###SRC_TABLE###", source_table)
                    if "###REFERENCE_ID###" in query:
                        query = query.replace("###REFERENCE_ID###", str(reference_id))

                    # Couple of initializations
                    file_num_cnt = 1
                    transfer_count = 0

                    # Pull data from source
                    logger.info("Pulling data from source")
                    for df in pd.read_sql(query, engine, chunksize=30000):

                        # Trim all string columns
                        df = trim_all_columns_remove_nbsp(df)

                        # Output files into S3
                        df.to_csv(
                            "s3://"
                            + s3_data_bucket
                            + "/"
                            + s3_data_path
                            + schedule_value
                            + "_dw_src_xfer_"
                            + target_table
                            + "_log_id"
                            + str(data_transfer_log_id)
                            + "_"
                            + str(file_num_cnt)
                            + ".txt",
                            index=False,
                            na_rep="NULL",
                            header=True,
                            sep="|",
                            quoting=csv.QUOTE_ALL,
                            quotechar='"',
                            escapechar='"',
                        )
                        # header=True, sep='|', quoting=csv.QUOTE_ALL, quotechar='"',  escapechar='\\', doublequote=False)

                        # Increment file num count
                        file_num_cnt = file_num_cnt + 1

                        # Increment the transfer_count
                        transfer_count = transfer_count + df.shape[0]

                        # Delete this interations dataframe
                        del df

                    # Done pulling data, close connection
                    engine.dispose()

                    # Write updates to logging table
                    do_cursor.execute(
                        "update data_operations.data_transfer_log \
                        set transfer_count = "
                        + str(transfer_count)
                        + ", \
                            run_status = 'transfer_complete', \
                            transfer_end_datetime = current_timestamp \
                        where data_transfer_log_id = "
                        + str(data_transfer_log_id)
                    )
                    do_conn.commit()

                    # if no records pulled no reason to do remaining steps in loop.
                    if transfer_count == 0:
                        do_cursor.execute(
                            "update data_operations.data_transfer_log \
                        set landed_count = 0, \
                            insert_count = 0, \
                            update_count = 0, \
                            delete_count = 0, \
                            run_status = 'no_records', \
                            data_prep_end_datetime = current_timestamp \
                        where data_transfer_log_id = "
                            + str(data_transfer_log_id)
                        )
                        do_conn.commit()

                        logger.info("Zero Records Transfered")
                        # Go to next config record for this target table
                        continue

                    # Write data to landing table
                    logger.info("Loading data to landing table")
                    rs_cursor.execute(
                        "copy "
                        + landing_schema
                        + "."
                        + target_table
                        + " \
                            from 's3://"
                        + s3_data_bucket
                        + "/"
                        + s3_data_path
                        + schedule_value
                        + "_dw_src_xfer_"
                        + target_table
                        + "_log_id"
                        + str(data_transfer_log_id)
                        + "_' \
                            iam_role 'arn:aws:iam::511539536780:role/Redshift_for_copy' \
                            csv quote as '"
                        + quote_char
                        + "' delimiter '|' IGNOREHEADER 1 ROUNDEC NULL AS 'NULL'"
                    )

                    # Pull count of records written to landing table
                    rs_cursor.execute(
                        "select count(*) from " + landing_schema + "." + target_table
                    )
                    land_count_results = rs_cursor.fetchone()
                    landed_count = land_count_results[0]

                    # if using max PK value in logic, keep track of values by config id for later update after finalized
                    if use_max_pk_val:
                        rs_cursor.execute(
                            "select "
                            + str(data_transfer_config_id)
                            + " as data_transfer_config_id, \
                            coalesce(max("
                            + pk_field
                            + "), -999) from "
                            + landing_schema
                            + "."
                            + target_table
                        )
                        max_pk_val_result = rs_cursor.fetchone()

                        new_max_pk_val = max_pk_val_result[1]
                        if new_max_pk_val != -999:
                            max_pk_apply_list.append(max_pk_val_result)

                    # Write updates to logging table
                    do_cursor.execute(
                        "update data_operations.data_transfer_log \
                        set landed_count = "
                        + str(landed_count)
                        + ", \
                            run_status = 'landing_complete', \
                            landing_end_datetime = current_timestamp \
                        where data_transfer_log_id = "
                        + str(data_transfer_log_id)
                    )
                    do_conn.commit()

                    # Write new records to staging table
                    logger.info("Write Insert records to staging")
                    query = (
                        "insert into "
                        + staging_schema
                        + "."
                        + target_table
                        + " ( \
                    "
                        + field_list
                        + ",data_action_indicator) \
                        select n.*,"
                        + str(data_transfer_log_id)
                        + ", "
                        + md5_hash_sql
                        + ", 'I'  \
                        from "
                        + landing_schema
                        + "."
                        + target_table
                        + " n \
                            left join "
                        + integrated_schema
                        + "."
                        + target_table
                        + " c on "
                        + unique_record_join_cond
                        + " \
                        where c.refresh_timestamp is null"
                    )

                    rs_cursor.execute(query)

                    # Write update records to staging table (treatment field dependent)
                    if overlap_treatment == "replace":
                        logger.info("Write Replace/Update records to staging")
                        query = (
                            "insert into "
                            + staging_schema
                            + "."
                            + target_table
                            + " ( \
                        "
                            + field_list
                            + ",data_action_indicator) \
                        select n.*,"
                            + str(data_transfer_log_id)
                            + ", "
                            + md5_hash_sql
                            + ", 'U'  \
                        from "
                            + landing_schema
                            + "."
                            + target_table
                            + " n \
                            inner join "
                            + integrated_schema
                            + "."
                            + target_table
                            + " c on "
                            + unique_record_join_cond
                        )

                        rs_cursor.execute(query)

                    if overlap_treatment == "update":
                        logger.info("Write Update records to staging")
                        query = (
                            "insert into "
                            + staging_schema
                            + "."
                            + target_table
                            + " ( \
                        "
                            + field_list
                            + ",data_action_indicator) \
                        select n.*,"
                            + str(data_transfer_log_id)
                            + ", "
                            + md5_hash_sql
                            + ", 'U'  \
                        from "
                            + landing_schema
                            + "."
                            + target_table
                            + " n \
                            inner join "
                            + integrated_schema
                            + "."
                            + target_table
                            + " c on "
                            + unique_record_join_cond
                            + " where coalesce(c.md5_hash, '') != "
                            + md5_hash_sql
                        )

                        rs_cursor.execute(query)

                    rs_conn.commit()

                    # Query to get insert/update/delete counts
                    rs_cursor.execute(
                        "select coalesce(sum(case when data_action_indicator = 'I' then 1 else 0 end), 0) as insert_count, \
                                coalesce(sum(case when data_action_indicator = 'U' then 1 else 0 end), 0) as update_count, \
                                coalesce(sum(case when data_action_indicator = 'D' then 1 else 0 end), 0) as delete_count \
                            from "
                        + staging_schema
                        + "."
                        + target_table
                        + " \
                            where data_transfer_log_id = "
                        + str(data_transfer_log_id)
                    )
                    count_results = rs_cursor.fetchone()
                    insert_count = count_results[0]
                    update_count = count_results[1]
                    delete_count = count_results[2]

                    insert_count_sum = insert_count_sum + insert_count
                    update_count_sum = update_count_sum + update_count
                    delete_count_sum = delete_count_sum + delete_count

                    # Write updates to logging table
                    do_cursor.execute(
                        "update data_operations.data_transfer_log \
                        set insert_count = "
                        + str(insert_count)
                        + ", \
                            update_count = "
                        + str(update_count)
                        + ", \
                            delete_count = "
                        + str(delete_count)
                        + ", \
                            run_status = 'staging_complete', \
                            data_prep_end_datetime = current_timestamp, \
                            staging_end_datetime = current_timestamp \
                        where data_transfer_log_id = "
                        + str(data_transfer_log_id)
                    )
                    do_conn.commit()

                except Exception as error:
                    # rollback redshift
                    rs_conn.rollback()

                    # Write updates to logging table
                    do_cursor.execute(
                        "update data_operations.data_transfer_log \
                        set run_status = 'data_prep_error', \
                            data_prep_end_datetime = current_timestamp \
                        where data_transfer_log_id = "
                        + str(data_transfer_log_id)
                    )
                    do_conn.commit()

                    data_prep_error_count = data_prep_error_count + 1

                    logger.info("Data prep error encountered")
                    logger.info(f"Error: {error}")

                    # Go to next config record for this target table
                    continue

            # Write updates to logging table for records without any insert or updates
            do_cursor.execute(
                "update data_operations.data_transfer_log l \
                    set run_status = 'no_updates' \
                    from data_operations.data_transfer_config c \
                    where l.data_transfer_config_id = c.data_transfer_config_id \
                        and run_status = 'staging_complete' \
                        and insert_count = 0 \
                        and update_count = 0 \
                        and current_date between effective_start_date and effective_end_date \
                        and start_datetime > current_date - interval '1' day"
            )
            do_conn.commit()

            #######################################################
            # Now Finalizing data into the integrated schema for this target table
            #######################################################

            logger.info(f"Finalizing Redshift table: {target_table}")

            # Only proceed with updates if there are updates
            if update_count_sum > 0 or insert_count_sum > 0:

                # Write updates to logging table
                do_cursor.execute(
                    "update data_operations.data_transfer_log l \
                    set run_status = 'finalizing', \
                        finalize_table_start_datetime = current_timestamp \
                    from data_operations.data_transfer_target t \
                        join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                    where l.data_transfer_config_id = c.data_transfer_config_id \
                        and run_status = 'staging_complete' \
                        and t.target_identifier = '"
                    + target_identifier
                    + "' \
                        and t.target_table = '"
                    + target_table
                    + "'"
                )
                do_conn.commit()

                # Write hisory records if feature is activated for this table
                if track_history and history_tracking_setup:

                    ### Generate the history_tracking_field_list sql element.
                    result2 = re.split(",", field_list)
                    history_tracking_field_list = ""

                    for row2 in result2:
                        history_tracking_field_list = (
                            history_tracking_field_list + "n." + row2.strip() + ","
                        )

                    history_tracking_field_list = history_tracking_field_list.strip(",")

                    query = (
                        "insert into "
                        + history_schema
                        + "."
                        + target_table
                        + "_history \
                                ("
                        + field_list
                        + ", record_version) \
                            with history_info as (select "
                        + unique_record_fields
                        + ", max(record_version) as max_version \
                                     from "
                        + history_schema
                        + "."
                        + target_table
                        + "_history \
                                     group by "
                        + unique_record_fields
                        + ") \
                            select "
                        + history_tracking_field_list
                        + ", \
                                coalesce(max_version,0) + 1 as record_version \
                            from "
                        + staging_schema
                        + "."
                        + target_table
                        + " n \
                                left join history_info c on "
                        + unique_record_join_cond
                        + " \
                            where n.data_action_indicator in ('I', 'U')"
                    )

                    rs_cursor.execute(query)

                # Remove update records (Will insert new ones in next step)
                logger.info("Removing any update records")
                if update_count_sum > 0:
                    query = (
                        "delete from "
                        + integrated_schema
                        + "."
                        + target_table
                        + " \
                        where dw_table_pk in ( \
                            select distinct c.dw_table_pk \
                                from "
                        + integrated_schema
                        + "."
                        + target_table
                        + " c \
                            join "
                        + staging_schema
                        + "."
                        + target_table
                        + " n on "
                        + unique_record_join_cond
                        + " \
                            where n.data_action_indicator = 'U')"
                    )

                    rs_cursor.execute(query)
                    logger.info("Removed update records")

                # Insert insert and update records
                logger.info("Inserting any insert or update records")
                query = (
                    "insert into "
                    + integrated_schema
                    + "."
                    + target_table
                    + " ( \
                        "
                    + field_list
                    + ") \
                        select "
                    + field_list
                    + " from "
                    + staging_schema
                    + "."
                    + target_table
                    + " \
                        where data_action_indicator in ('U', 'I')"
                )

                rs_cursor.execute(query)
                logger.info("Inserted any insert or update records")

                # Write updates to logging table
                do_cursor.execute(
                    "update data_operations.data_transfer_log l \
                        set run_status = 'integrated_complete', \
                            finalize_table_end_datetime = current_timestamp \
                        from data_operations.data_transfer_target t \
                        join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                        where l.data_transfer_config_id = c.data_transfer_config_id \
                            and run_status = 'finalizing' \
                            and t.target_identifier = '"
                    + target_identifier
                    + "' \
                            and t.target_table = '"
                    + target_table
                    + "'"
                )

                # Update any needed max_pk_val records.
                for result_line in max_pk_apply_list:
                    dt_config_id = result_line[0]
                    max_pk_val_to_upd = result_line[1]
                    do_cursor.execute(
                        "update data_operations.data_transfer_config \
                        set max_pk_val = "
                        + str(max_pk_val_to_upd)
                        + "  \
                        where  data_transfer_config_id = "
                        + str(dt_config_id)
                    )

                    # Keeping max_pk_val updates for all schedules
                    do_cursor.execute(
                        "update data_operations.data_transfer_config c \
                            set max_pk_val = c2.max_pk_val \
                        from data_operations.data_transfer_config c2 \
                        where c.source_host = c2.source_host \
                                    and c.source_db = c2.source_db \
                                    and c.source_schema = c2.source_schema \
                                    and c.source_table = c2.source_table \
                        and c2.data_transfer_config_id = "
                        + str(dt_config_id)
                        + "  \
                            and c.data_transfer_config_id != c2.data_transfer_config_id"
                    )

                do_conn.commit()

                # Commit ALL the finalizing statements
                rs_conn.commit()
            else:
                logger.info("No Finalizing Needed (no inserts or updates)")

            # Set current_running to False in target table
            do_cursor.execute(
                "update data_operations.data_transfer_target set currently_running = false \
                                where data_transfer_target_id = "
                + str(data_transfer_target_id)
            )
            do_conn.commit()

        except Exception as error:
            # rollback redshift
            rs_conn.rollback()

            # Write updates to logging table
            do_cursor.execute(
                "update data_operations.data_transfer_log l \
                set run_status = 'finalizing_error', \
                    finalize_table_end_datetime = current_timestamp \
                from data_operations.data_transfer_target t \
                    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id \
                where l.data_transfer_config_id = c.data_transfer_config_id \
                    and run_status = 'finalizing' \
                    and t.target_identifier = '"
                + target_identifier
                + "' \
                    and t.target_table = '"
                + target_table
                + "'"
            )
            do_conn.commit()

            finalizing_error_count = finalizing_error_count + 1

            logger.info("Data finalization error encountered")
            logger.info(f"Error: {error}")

            # Set current_running to False in target table
            do_cursor.execute(
                "update data_operations.data_transfer_target set currently_running = false \
                                where data_transfer_target_id = "
                + str(data_transfer_target_id)
            )
            do_conn.commit()

            # Go to next target table
            continue

    # If schedule_value is run_now, set all config records with run_now = true to run_now = false
    if schedule_value == "run_now":
        logger.info("Setting any true run_now records to false")
        do_cursor.execute(
            "update data_operations.data_transfer_config \
                set run_now = false \
                where run_now = true"
        )
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
    error_message_to_send = "Exception occurred in: dw_source_transfer glue job"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")

finally:
    # send SNS notification if any error records were hit during process
    if data_prep_error_count > 0:
        # Send notification to SNS topic that errors were encountered
        error_email_subject = "DW Source Transfer (Data Prep) Errors Encountered!"
        error_message_to_send = (
            "During running of: dw_source_transfer glue job, "
            + str(data_prep_error_count)
            + " data prep errors were encountered!!"
        )
        msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    if finalizing_error_count > 0:
        # Send notification to SNS topic that errors were encountered
        error_email_subject = "DW Source Transfer (Finalizing) Errors Encountered!"
        error_message_to_send = (
            "During running of: dw_source_transfer glue job, "
            + str(finalizing_error_count)
            + " data finalizing errors were encountered!!"
        )
        msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)
