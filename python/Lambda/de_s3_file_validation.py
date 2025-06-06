import boto3
import json
import psycopg2
import os
import re
import urllib.parse
import datetime

# This Lambda function validates file names uploaded to S3 against rules stored in a PostgreSQL database.
# It moves files to either a "Fetched" or "Quarantine" location based on validation results.
s3 = boto3.client("s3")
aws_region = "us-west-2"
secret_name = "etluser/dev/rds"


# Ensure the AWS Secrets Manager and RDS PostgreSQL libraries are available
def get_db_secrets(secret_name, aws_region):
    """
    Retrieves the credentials from the AWS Secrets Manager.
    Used to access the RDS database securely.
    """
    try:
        session = boto3.session.Session()
        client = session.client(service_name="secretsmanager", region_name=aws_region)

        response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(response["SecretString"])
        return secret
    except Exception as e:
        print(f"Error retrieving secrets for {secret_name}: {str(e)}")
        return None


def get_db_connection(secret_json):
    """
    Establishes and returns a PostgreSQL db connection using credentials from Secrets Manager.
    """
    try:
        # print("-- logs3 --- ", secret_json)
        conn = psycopg2.connect(
            host=secret_json["host"],
            port=secret_json["port"],
            user=secret_json["username"],
            password=secret_json["password"],
            dbname=secret_json["dbname"],
            connect_timeout=60,
        )
        print("-- logs --- db connection established --- logs --")
        return conn
    except Exception as e:
        print(f"Error creating database connection: {str(e)}")
        raise


def insert_fetch_log(
    connection,
    start_time,
    fetch_config_id,
    file_name,
    status,
    bucket,
    location,
    extracted_files,
    notes,
):
    """
    Inserts a record into the fetch_log table.
    """
    print("Attempting to log the file status")
    try:
        cur = connection.cursor()

        # Capture the current UTC time to use as the fetch_end_at timestamp
        now = datetime.datetime.now(datetime.UTC)

        query = """
            INSERT INTO data_operations.fetch_log (
                fetch_config_id, fetched_file_name, fetch_status,
                fetch_start_at, fetch_end_at, extracted_file_names,
                file_s3_bucket, file_s3_location, created_by, last_modified_by, notes
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'lambda_user', 'lambda_user', %s);
        """
        print("-------------------")
        print(query)
        print("-------------------")

        cur.execute(
            query,
            (
                fetch_config_id,  # ID from fetch_config table
                file_name,  # Actual name of the processed file
                status,  # "Fetched", "Quarantined", etc.
                start_time,  # Time when Lambda began processing <fetch_start_at>
                now,  # Time when logging occurred <fetch_end_at>
                extracted_files,  # All files extracted ( from a ZIP TBD.)
                bucket,  # Final destination S3 bucket
                location,  # Final destination folder (Fetched/Quarantine)
                notes,  # Notes about validation outcome or errors
            ),
        )

        connection.commit()
        cur.close()
        print(f"Log inserted for file {file_name} with status {status}")
    except Exception as e:
        print(f"Error logging fetch event: {str(e)}")


def split_file_name(file_name):
    """
    Splits the file name into prefix, date_part, and suffix.
    Expects the file name to follow the format: <prefix><date><suffix>
    Example: client2_testfile_2025-04-07_Updated.csv
        =>  prefix: client2_testfile_
            date_part: 2025-04-07
            suffix: _Updated.csv
    """

    # Define a regex pattern that captures:
    # Prefix ending in underscore (non-greedy), A date or version string (mmddyyyy, yyyy-mm-dd, or yyyy-mm-dd-qq), The remaining suffix (e.g., .csv or _Updated.csv)
    pattern = re.compile(r"^(.*?_)(\d{8}|\d{4}-\d{2}-\d{2}(?:-\d{2})?)(.*)$")

    try:
        match = pattern.match(file_name)
        if match:
            # If matched, return the 3 captured groups:
            # Group 1: prefix, Group 2: date or versioned date part, Group 3: suffix (file extension or additional tag like "_Updated")
            return match.group(1), match.group(2), match.group(3)
        else:
            return None, None, None
    except Exception as e:
        print(f"Error splitting file name: {str(e)}")


def get_validation_rules(connection, bucket_name, fetch_location, file_name):
    """
    Fetches all validation rules from the fetch_config table based on S3 location and filename structure.
    """
    try:
        if not connection:
            return None

        # Split the file name into prefix, date part, and suffix
        prefix, date_part, suffix = split_file_name(file_name)
        cur = connection.cursor()

        # SQL query to find all matching validation rules
        # Uses wildcards to match based on S3 bucket/folder location, The prefix and suffix of the file_name
        query = """
            SELECT 
                fetch_config_id,
                file_name_mask, 
                target_s3_bucket, 
                target_s3_location
            FROM 
                data_operations.fetch_config 
            WHERE 
                s3_fetch_bucket LIKE %s
                AND s3_fetch_location LIKE %s
                AND file_name_mask LIKE %s
                AND file_name_mask LIKE %s
                AND CURRENT_DATE BETWEEN effective_start_date AND effective_end_date;
        """
        print("-------------------")
        print(
            query,
            (
                (
                    "%" + bucket_name + "%",
                    "%" + fetch_location + "%",
                    "%" + prefix,
                    suffix + "%",
                )
            ),
        )
        print("-------------------")

        # Execute the query with wildcard parameters
        cur.execute(
            query,
            (
                "%" + bucket_name + "%",
                "%" + fetch_location + "%",
                prefix + "%",
                "%" + suffix,
            ),
        )

        results = cur.fetchall()
        cur.close()
        if results:

            # return the results as a list of dictionaries
            return [
                {
                    "fetch_config_id": row[0],
                    "file_name_mask": row[1],
                    "target_s3_bucket": row[2],
                    "target_s3_location": row[3],
                }
                for row in results
            ]
        else:
            print(f"No validation rules found for {file_name} at {bucket_name}")
            return None

    except Exception as e:
        print(f"Error fetching validation rules: {str(e)}")
        return None


def extract_date_format(file_name_mask):
    """
    Extracts the date format pattern from the file_name_mask to be used for regex matching.
    Returns:
        - A date token identifier (e.g., 'yyyy-mm-dd')
        - A regex pattern that captures the date
        - The Python datetime format string
    """
    if "yyyy-mm-dd-qq" in file_name_mask:
        return "yyyy-mm-dd-qq", r"(\d{4}-\d{2}-\d{2})-(\d{2})", "%Y-%m-%d"
    elif "yyyy-mm-dd" in file_name_mask:
        return "yyyy-mm-dd", r"(\d{4}-\d{2}-\d{2})", "%Y-%m-%d"
    elif "mmddyyyy" in file_name_mask:
        return "mmddyyyy", r"(\d{8})", "%m%d%Y"
    elif "????????" in file_name_mask:
        return "????????", r"(.{8})", None
    else:
        return None, None, None


def is_valid_file_name(file_name, validation_rules):
    """
    Validates whether the file name matches one of the rules and its embedded date string is valid.
    Returns the matching rule, all masks checked, and a status note.
    """

    matching_masks = [rule["file_name_mask"] for rule in validation_rules]
    notes = "File Name Validation Failed"

    # Iterate through each rule to check if any pattern matches the file_name
    for rule in validation_rules:
        file_name_mask = rule["file_name_mask"]
        print(
            f"Attempting to Validate the filename: {file_name} against the mask: {file_name_mask}"
        )

        # Extract the dynamic date portion and its regex/format from the mask
        date_token, date_regex, date_format = extract_date_format(file_name_mask)
        if not date_regex:
            continue

        # Construct pattern from the file_name_mask and replace token with actual regex
        # Build the regex pattern by replacing the token with a capturing regex
        pattern_raw = file_name_mask.replace(date_token, date_regex)
        pattern = re.escape(pattern_raw)

        pattern = pattern.replace(re.escape(date_regex), date_regex)
        match = re.match(pattern, file_name)

        if match:
            try:
                # Validate the extracted date string using datetime.strptime
                if date_token == "yyyy-mm-dd-qq":
                    # Group 1 = date, Group 2 = version
                    datetime.datetime.strptime(match.group(1), date_format)
                    int(match.group(2))  # Ensure version is numeric
                else:
                    # Only a date is expected
                    datetime.datetime.strptime(match.group(1), date_format)
            except Exception as e:
                # If date parsing fails, skip to the next rule
                print(
                    f"Date validation failed for {file_name} with expected format {date_format}"
                )
                notes = "Date Validation Failed"
                continue

            # If all validations pass, return the matching rule and a success message
            print(f"File {file_name} matched pattern {file_name_mask}")
            return (
                rule,
                matching_masks,
                "File Name Validation Passed successfully",
            )  # we stop at first valid match

    return None, matching_masks, notes


def move_file(source_bucket, source_key, target_bucket, target_key):
    """
    Moves a file from the source S3 bucket/Key to the target S3 bucket/Key.
    This function performs a two-step process:
        1. Copies the file to the new location (fetched or quarantine).
        2. Deletes the original file to complete the "move".
    """
    print(
        f"Attempting to move the file from {source_bucket}/{source_key} to {target_bucket}/{target_key}"
    )
    try:
        # Copy the file from the source bucket/key to the target bucket/key
        s3.copy_object(
            Bucket=target_bucket,
            CopySource={"Bucket": source_bucket, "Key": source_key},
            Key=target_key,
        )

        # Delete the file from the original location to simulate a move
        s3.delete_object(Bucket=source_bucket, Key=source_key)
        print(
            f"File moved successfully from {source_bucket}/{source_key} to {target_bucket}/{target_key}"
        )

    except Exception as e:
        print(
            f"Error moving file from {source_bucket}/{source_key} to {target_bucket}/{target_key}: {str(e)}"
        )


def lambda_handler(event, context):
    """
    AWS Lambda function triggered when a file is uploaded to S3.
    Validates the file name, checks against DB rules, and moves to Fetched or Quarantine accordingly.
    """
    conn = None
    start_time = datetime.datetime.now(datetime.UTC)  # Capture start time for logging
    try:
        # Loop through all S3 records in the event
        for record in event["Records"]:
            source_bucket = record["s3"]["bucket"]["name"]

            # Decode the object key (handles URL-encoded characters like %3F)
            object_key = urllib.parse.unquote(record["s3"]["object"]["key"])
            print("Raw key:", record["s3"]["object"]["key"])
            print("Decoded key:", object_key)

            # Extract the folder path and file name
            fetch_location = "/".join(object_key.split("/")[:-1]) + "/"
            file_name = object_key.split("/")[-1]
            print(
                f"-- logs --- Processing file: {file_name} in bucket: {source_bucket}, location: {fetch_location}"
            )

            # Get DB connection and fetch applicable validation rules
            conn = get_db_connection(get_db_secrets(secret_name, aws_region))
            validation_rules = get_validation_rules(
                conn,
                source_bucket,
                fetch_location[
                    : len(fetch_location) - 1
                ],  # remove trailing slash for DB matching
                file_name,
            )
            if not validation_rules:
                # No rules matched, quarantine the file
                quarantine_bucket = "bloom-dev-data-team"
                quarantine_key = f"{'Quarantine'}/{file_name}"
                move_file(
                    source_bucket,
                    fetch_location + file_name,
                    quarantine_bucket,
                    quarantine_key,
                )
                insert_fetch_log(
                    connection=conn,
                    start_time=start_time,
                    fetch_config_id="-1",  # -1 for untracked config
                    file_name=file_name,
                    status="No Validation Rules",
                    bucket=quarantine_bucket,
                    location="Quarantine",
                    extracted_files=None,
                    notes="No Matching Validation Rules Found for this File",
                )
                return

            # Validate the file name using the fetched rules
            matching_rule, matching_masks, notes = is_valid_file_name(
                file_name, validation_rules
            )
            extracted_masks = ", ".join([mask for mask in matching_masks])
            print(extracted_masks)
            if matching_rule:
                # File is valid, move to fetched
                target_bucket = matching_rule["target_s3_bucket"]
                target_location = matching_rule["target_s3_location"]
                fetched_key = f"{target_location}/{file_name}"
                move_file(
                    source_bucket,
                    fetch_location + file_name,
                    target_bucket,
                    fetched_key,
                )
                insert_fetch_log(
                    connection=conn,
                    start_time=start_time,
                    fetch_config_id=matching_rule["fetch_config_id"],
                    file_name=file_name,
                    status="Fetched",
                    bucket=target_bucket,
                    location=target_location,
                    extracted_files=None,  # TBD for Zip files
                    notes=notes,
                )
            else:
                # Validation failed, move to quarantine
                quarantine_bucket = "bloom-dev-data-team"
                quarantine_key = f"{'Quarantine'}/{file_name}"
                move_file(
                    source_bucket,
                    fetch_location + file_name,
                    quarantine_bucket,
                    quarantine_key,
                )
                insert_fetch_log(
                    connection=conn,
                    start_time=start_time,
                    fetch_config_id=validation_rules[-1]["fetch_config_id"],
                    file_name=file_name,
                    status="Quarantined",
                    bucket=quarantine_bucket,
                    location="Quarantine",
                    extracted_files=None,  # TBD for Zip files
                    notes=notes,
                )

    except Exception as e:
        print(f"Error processing file: {str(e)}")
    finally:
        if conn:
            conn.close()


"""
Testing parameters
event = {
    "Records": [
        {
            "s3": {
                "bucket": {
                    "name": "bloom-dev-data-team"
                },
                "object": {
                    "key": "fake-bloom-sftp01/zinghealth-sftp01/to_bloom/test_file_34072025.csv"
                }
            }
        }
    ]
}

lambda_handler(event, None)
"""
