import boto3
import json
import psycopg2
import os
import re
import urllib.parse
import datetime
import io
import csv
import openpyxl
import codecs
import textwrap
import pgpy

# from de_aws_utils import CloudWatchSNSLogger
from cloudwatchsnslogger import CloudWatchSNSLogger


s3 = boto3.client("s3")
# aws_region = "us-west-2"
# secret_name = "etluser/dev/rds"
aws_region = os.environ.get("REGION", "us-west-2")
secret_name = os.environ.get("DO_SECRET_NAME", "etluser/dev/rds")
env = os.environ.get("ENV", "Dev")
job_name = os.environ.get("JOB_NAME", "Internal-Fetch-Process")
job_class = os.environ.get("JOB_CLASS", "Testing")

# sns_info_topic_arn = os.environ.get(
#     "SNS_TOPIC_ARN", "arn:aws:sns:us-west-2:511539536780:Dev-Testing-Info"
# )
# sns_warn_topic_arn = os.environ.get(
#     "SNS_WARN_TOPIC_ARN", "arn:aws:sns:us-west-2:511539536780:Dev-Testing-Warn"
# )
# sns_error_topic_arn = os.environ.get(
#     "SNS_ERROR_TOPIC_ARN", "arn:aws:sns:us-west-2:511539536780:Dev-Testing-Error"
# )

# logger = CloudWatchSNSLogger(name=job_name, region=aws_region)
logger = CloudWatchSNSLogger()
logger.process_name = job_name
logger.env = env
logger.job_class = job_class
logger.service = "lambda"


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
        # print(f"Error retrieving secrets for {secret_name}: {str(e)}")
        logger.exception(f"Error retrieving secrets for {secret_name}: {str(e)}")
        raise
        # Uncomment the following lines if you want to return an error response instead of raising an exception
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }


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
        # print(f"Error creating database connection: {str(e)}")
        logger.exception(f"Error creating database connection: {str(e)}")
        raise
        # Uncomment the following lines if you want to return an error response instead of raising an exception
        # logger.error(f"Error creating database connection: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }


def get_external_fetch_log_id(
    connection, file_name, target_filename, external_fetch_config_id, start_time
):
    """
    Retrieves the external fetch log ID for a given file name.
    This is used to track the file in external systems or logs.
    """
    try:
        cur = connection.cursor()
        query = """
            SELECT external_fetch_log_id FROM data_operations.external_fetch_log
            WHERE target_file_name = %s 
            AND process_status = 'Success' 
            AND external_fetch_config_id = %s
            AND DATE(%s) - DATE(end_datetime) <= 2
            ORDER BY end_datetime DESC LIMIT 1;
        """
        cur.execute(query, (file_name, external_fetch_config_id, start_time))
        result = cur.fetchone()

        if result:
            print(f"Found external fetch log ID: {result[0]} for file {file_name}")
            return result[0]
        else:
            query = """
            SELECT external_fetch_log_id FROM data_operations.external_fetch_log
            WHERE target_file_name = %s 
            AND process_status = 'Success' 
            AND external_fetch_config_id = %s
            AND DATE(%s) - DATE(end_datetime) <= 2
            ORDER BY end_datetime DESC LIMIT 1;
            """
            cur.execute(query, (target_filename, external_fetch_config_id, start_time))
            result = cur.fetchone()
            return result[0] if result else -1  # Return -1 if no log found
        cur.close()
    except Exception as e:
        # print(f"Error fetching external fetch log ID: {str(e)}")
        logger.exception(f"Error fetching external fetch log ID: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }
        return -1  # Return -1 if an error occurs


def insert_fetch_log(
    connection,
    start_time,
    fetch_config_id,
    external_fetch_config_id,
    fetched_file_name,
    target_file_name,
    status,
    bucket,
    location,
    notes,
):
    """
    Inserts a record into the fetch_log table.
    """
    print("Attempting to log the file status")
    try:
        external_fetch_log_id = get_external_fetch_log_id(
            connection,
            fetched_file_name,
            target_file_name,
            external_fetch_config_id,
            start_time,
        )
        cur = connection.cursor()

        # Capture the current UTC time to use as the fetch_end_at timestamp
        now = datetime.datetime.now(datetime.UTC)

        query = """
            INSERT INTO data_operations.fetch_log (
                fetch_config_id, external_fetch_log_id, fetched_file_name, target_file_name, 
                process_status, start_datetime, end_datetime, file_s3_bucket, file_s3_location, notes
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """
        print("-------------------")
        print(query)
        print("-------------------")

        cur.execute(
            query,
            (
                fetch_config_id,  # ID from fetch_config table
                external_fetch_log_id,
                fetched_file_name,
                target_file_name,
                status,  # "Fetched", "Quarantined", etc.
                start_time,  # Time when Lambda began processing <fetch_start_at>
                now,  # Time when logging occurred <fetch_end_at>
                bucket,  # Final destination S3 bucket
                location,  # Final destination folder (Fetched/Quarantine)
                notes,  # Notes about validation outcome or errors
            ),
        )

        connection.commit()
        cur.close()
        print(f"Log inserted for file {fetched_file_name} with status {status}")
    except Exception as e:
        # print(f"Error logging fetch event: {str(e)}")
        logger.exception(f"Error logging fetch event: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }


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
    pattern = re.compile(
        r"^(.*?[._])(\d{14}|\d{12}|\d{8}|\d{4}-\d{2}-\d{2}(?:-\d{2})?|\d{4})(.*)$"
    )

    try:
        match = pattern.match(file_name)
        if match:
            # If matched, return the 3 captured groups:
            # Group 1: prefix, Group 2: date or versioned date part, Group 3: suffix (file extension or additional tag like "_Updated")
            prefix = match.group(1) or ""
            return prefix, match.group(2), match.group(3)
        else:
            # Fallback: no date in filename
            if "." in file_name:
                dot_split = file_name.split(".", 1)
                prefix = dot_split[0]
                suffix = "." + dot_split[1]
                return prefix, None, suffix
            else:
                # No dot found
                return file_name, None, ""
    except Exception as e:
        # print(f"Error splitting file name: {str(e)}")
        logger.exception(f"Error splitting file name: {str(e)}")
        raise
        # Uncomment the following lines if you want to return an error response instead of raising an exception
        # logger.error(f"Error splitting file name: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }
        # return None, None, None


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
                external_fetch_config_id,
                file_name_mask, 
                target_s3_bucket, 
                target_s3_location,
                quarantine_s3_bucket,
                quarantine_s3_location,
                expected_headers,
                file_delimiter,
                pgp_decrypt_secret,
                allow_duplicate
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
                    prefix + "%",
                    "%" + suffix,
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
                    "external_fetch_config_id": row[1],
                    "file_name_mask": row[2],
                    "target_s3_bucket": row[3],
                    "target_s3_location": row[4],
                    "quarantine_s3_bucket": row[5],
                    "quarantine_s3_location": row[6],
                    "expected_headers": row[7],
                    "file_delimiter": row[8],
                    "pgp_decrypt_secret": row[9],
                    "allow_duplicate": row[10],
                }
                for row in results
            ]
        else:
            print(f"No validation rules found for {file_name} at {bucket_name}")
            return None

    except Exception as e:
        # print(f"Error fetching validation rules: {str(e)}")
        logger.exception(f"Error fetching validation rules: {str(e)}")
        raise
        # Uncomment the following lines if you want to return an error response instead of raising an exception
        # logger.error(f"Error fetching validation rules: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }
        # return None


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
    elif "ddmmyyyy" in file_name_mask:
        return "ddmmyyyy", r"(\d{8})", "%d%m%Y"
    elif "yyyy" in file_name_mask:
        return "yyyy", r"(\d{4})", "%Y"
    elif "????????" in file_name_mask:
        return "????????", r"(.{8})", None
    elif "YYYYMMDDhhmmss" in file_name_mask:
        return "YYYYMMDDhhmmss", r"(\d{14})", "%Y%m%d%H%M%S"
    elif "MMDDYYhhmmss" in file_name_mask:
        return "MMDDYYhhmmss", r"(\d{12})", "%m%d%y%H%M%S"
    else:
        return None, None, None


def parse_date(date_str):
    """
    Attempts to parse an 8-character date string using multiple formats.
    Returns the matched format label and parsed datetime object.
    """
    formats = {"ddmmyyyy": "%d%m%Y", "mmddyyyy": "%m%d%Y", "yyyymmdd": "%Y%m%d"}

    for label, fmt in formats.items():
        try:
            parsed = datetime.datetime.strptime(date_str, fmt)
            return label, parsed
        except ValueError:
            continue

    return None, None


def is_valid_file_name(file_name, validation_rules):
    """
    Validates whether the file name matches one of the rules and its embedded date string is valid.
    Returns the matching rule, all masks checked, and a status note.
    """

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
            print(f"No date format found in the mask: {file_name_mask}")
            print(f"File {file_name} matched pattern {file_name_mask}")
            return (
                rule,
                "File Name Validation Passed successfully",
            )  # we stop at first valid match

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
                elif date_token == "????????":
                    # Trying to parse a 8-digit date with multiple formats
                    date_format, parsed_date = parse_date(match.group(1))
                    if not parsed_date:  # if date is not validated
                        raise ValueError(
                            f"Date Validation Failed for the date {match.group(1)}"
                        )
                else:
                    # Only a date is expected
                    datetime.datetime.strptime(match.group(1), date_format)
            except Exception as e:
                # If date parsing fails, skip to the next rule
                print(
                    f"Date validation failed for {file_name} with expected format {date_format} with Exception: {str(e)}"
                )
                notes = "Date Validation Failed"
                continue

            # If all validations pass, return the matching rule and a success message
            print(f"File {file_name} matched pattern {file_name_mask}")
            return (
                rule,
                "File Name Validation Passed successfully",
            )  # we stop at first valid match
    logger.exception(f"Error fetching validation rules: {str(e)}")
    # return {
    #     "statusCode": 500,
    #     "body": json.dumps({"error": str(e)}),
    # }

    return None, notes


def move_file(source_bucket, source_key, target_bucket, target_key):
    """
    Moves a file from the source S3 bucket/Key to the target S3 bucket/Key.
    This function performs a two-step process:
        1. Copies the file to the new location (fetched or quarantine).
        2. Deletes the original file to complete the "move".
    """
    logger.debug(
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
        # print(
        #     f"File moved successfully from {source_bucket}/{source_key} to {target_bucket}/{target_key}"
        # )
        logger.debug(
            f"File moved successfully from {source_bucket}/{source_key} to {target_bucket}/{target_key}"
        )

    except Exception as e:
        # print(
        #     f"Error moving file from {source_bucket}/{source_key} to {target_bucket}/{target_key}: {str(e)}"
        # )
        logger.exception(f"Error moving file: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }


def already_fetched(conn, file_name):
    """
    Checks if the given file has already been successfully fetched before.
    Returns True if a non-quarantined fetch_log entry exists for this file name.
    """
    try:
        cur = conn.cursor()
        query = """
            SELECT COUNT(*) FROM data_operations.fetch_log
            WHERE fetched_file_name = %s AND process_status = 'Fetched'
        """
        cur.execute(query, (file_name,))
        count = cur.fetchone()[0]
        cur.close()
        return count > 0
    except Exception as e:
        # print(f"Error checking for duplicate file: {str(e)}")
        logger.exception(f"Error checking for duplicate file: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }


def total_attempts(conn, file_name):
    """
    Returns how many times this file name has been quarantined from the fetch_log.
    """
    try:
        query = """
            SELECT COUNT(*) FROM data_operations.fetch_log
            WHERE fetched_file_name = %s AND (process_status = 'Duplicate' OR process_status = 'Quarantined')
        """
        cur = conn.cursor()
        cur.execute(query, (file_name,))
        count = cur.fetchone()[0]
        cur.close()
        return count
    except Exception as e:
        logger.exception(f"Error checking for total file processing attempts: {str(e)}")
        raise
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }


def get_pgp_secret(secret_name, region_name="us-west-2"):
    """
    Fetch and properly format PGP private key from AWS Secrets Manager.
    """
    try:
        client = boto3.client("secretsmanager", region_name=region_name)
        response = client.get_secret_value(SecretId=secret_name)
        secret_data = json.loads(response["SecretString"])

        raw_key = secret_data["private_key"]
        passphrase = secret_data.get("passphrase", "")

        if (
            "-----BEGIN PGP PRIVATE KEY BLOCK-----" in raw_key
            and "\\n" not in raw_key
            and "\n" not in raw_key
        ):
            header = "-----BEGIN PGP PRIVATE KEY BLOCK-----"
            footer = "-----END PGP PRIVATE KEY BLOCK-----"
            key_body = (
                raw_key.replace(header, "").replace(footer, "").replace(" ", "").strip()
            )

            wrapped_body = "\n".join(textwrap.wrap(key_body, 64))

            formatted_key = (
                f"{header}\n\n{wrapped_body[:-4]}\n={wrapped_body[-4:]}\n{footer}"
            )
            return formatted_key, passphrase
    except Exception as e:
        # print(f"Error fetching PGP secret: {str(e)}")
        logger.exception(f"Error fetching PGP secret: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }
        raise


def decrypt_pgp_file(
    encrypted_data: bytes, private_key_str: str, passphrase: str = ""
) -> str:
    """
    Decrypt PGP-encrypted file content (bytes) using the provided private key string.
    """
    try:
        # print(private_key_str)
        private_key, _ = pgpy.PGPKey.from_blob(private_key_str)
        # print(private_key)
        with private_key.unlock(passphrase):
            pgp_message = pgpy.PGPMessage.from_blob(encrypted_data)
            decrypted = private_key.decrypt(pgp_message)
        # print("decrypted message:", decrypted.message)
        return str(decrypted.message)
    except Exception as e:
        # print(f"Error decrypting PGP file: {str(e)}")
        logger.exception(f"Error decrypting PGP file: {str(e)}")
        raise


def validate_file_headers(s3_bucket, s3_key, expected_headers, delimiter=","):
    """
    Reads the header line of a CSV file from S3 and compares with expected headers.
    Returns True if valid, False otherwise.
    """
    try:
        if not expected_headers:
            # No expected headers configured in the fetch_config
            # print(f"No expected headers found, Skipping file header validation")
            logger.error(f"No expected headers found, Skipping file header validation")
            return True
        delimiter = codecs.decode(delimiter, "unicode_escape")
        response = s3.get_object(Bucket=s3_bucket, Key=s3_key)
        file_bytes = response["Body"].read()
        if s3_key.endswith(".csv") or s3_key.endswith(".txt"):
            text = file_bytes.decode("utf-8")
            # print(text[:1000])  # Print first 1000 characters for debugging
            # print("Number of lines in decoded text:", len(text.splitlines()))
            # reader = csv.reader(io.StringIO(text), delimiter=delimiter)
            clean_text = text.replace("\r\n", "\n").replace("\r", "\n")
            first_line = clean_text.split("\n")[0]
            # print("First line of the file:", first_line)
            # print("Check 2................")
            file_headers = [col.strip() for col in first_line.split(delimiter)]
            # print("Check 3................")
        elif s3_key.endswith(".xlsx"):
            workbook = openpyxl.load_workbook(io.BytesIO(file_bytes), read_only=True)
            sheet = workbook.active
            file_headers = [
                str(cell.value).strip() if cell.value else ""
                for cell in next(sheet.iter_rows(min_row=1, max_row=1))
            ]
        else:
            # print(f"Unsupported file type for header validation: {s3_key}")
            logger.error(f"Unsupported file type for header validation: {s3_key}")
            return False

        expected = [h.strip().lower() for h in expected_headers.split(",")]
        headers = [i.strip().lower() for i in file_headers]
        # print(headers)
        if headers == expected:
            # print(f"Header matched:\nExpected: {expected}\nFound: {headers}")
            logger.debug(f"Header matched:\nExpected: {expected}\nFound: {headers}")
            return True
        else:
            # print(f"Header mismatch:\nExpected: {expected}\nFound: {headers}")
            logger.warning(f"Header mismatch:\nExpected: {expected}\nFound: {headers}")
            return False

    except Exception as e:
        logger.exception(f"Header validation failed: {str(e)}")
        raise
        # Uncomment the following lines if you want to return an error response instead of raising an exception
        # logger.error(f"Header validation failed: {str(e)}")
        # return {
        #     "statusCode": 500,
        #     "body": json.dumps({"error": str(e)}),
        # }


def is_temp_file(filename, content_length=0):
    # # Case 1: Must have a known extension
    # known_extensions = ['.csv', '.pgp', '.txt', '.xlsx']
    # if not any(s3_key.lower().endswith(ext) for ext in known_extensions):
    #     return False
    print(f"Validating file name: {filename} with content length: {content_length}")
    # Case 2: Should not match AppFlow metadata pattern (UUID + timestamp, no extension)
    # if re.match(
    #     r".*\b[0-9a-fA-F\-]{36}-\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$", filename
    # ):
    prefix, date_part, suffix = split_file_name(filename)
    # print("suffix is:", suffix, "\n date_part is:", date_part)
    logger.debug(
        f"Validating file name: {filename} with content length: {content_length}"
    )
    logger.debug(f"Prefix: {prefix}, Date Part: {date_part}, Suffix: {suffix}")
    if suffix == "":
        # print("Inside if")
        # This is likely a metadata file with no extension
        return True

    # Case 3: Small random files may be metadata
    # if content_length < 500:
    #     # Optionally add logging here
    #     return False

    # logger.error(f"File name validation failed for: {filename}")
    return False


def lambda_handler(event, context):
    """
    AWS Lambda function triggered when a file is uploaded to S3.
    Validates the file name, checks against DB rules, and moves to Fetched or Quarantine accordingly.
    """
    conn = None
    start_time = datetime.datetime.now(datetime.UTC)  # Capture start time for logging
    try:
        logger.info(
            f"Lambda function started at {start_time.isoformat()} for event: {json.dumps(event)}"
        )

        # Loop through all S3 records in the event
        for record in event["Records"]:
            source_bucket = record["s3"]["bucket"]["name"]

            # Decode the object key (handles URL-encoded characters like %3F)
            object_key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
            logger.debug(f"Raw key: {record['s3']['object']['key']}")
            logger.debug(f"Decoded key: {object_key}")

            # Extract the folder path and file name
            fetch_location = "/".join(object_key.split("/")[:-1]) + "/"
            match_fetch_location = object_key.split("/")[0] + "/"
            file_name = object_key.split("/")[-1]
            target_file_name = file_name
            # print(
            #     f"-- logs --- Processing file: {file_name} in bucket: {source_bucket}, location: {fetch_location}"
            # )
            logger.debug(
                f"-- logs --- Processing file: {file_name} in bucket: {source_bucket}, location: {fetch_location}"
            )
            response = s3.head_object(Bucket=source_bucket, Key=object_key)
            if is_temp_file(file_name, response["ContentLength"]):
                # print(
                #     f"Skipping processing for folders or empty temp objects: {file_name} in bucket: {source_bucket}"
                # )
                logger.debug(
                    f"Skipping processing for folders or empty temp objects: {file_name} in bucket: {source_bucket}"
                )
                continue

            # Get DB connection and fetch applicable validation rules
            conn = get_db_connection(get_db_secrets(secret_name, aws_region))

            validation_rules = get_validation_rules(
                conn,
                source_bucket,
                match_fetch_location,  # remove trailing slash for DB matching
                file_name,
            )

            if not validation_rules:
                # No rules matched, quarantine the file
                quarantine_bucket = "bloom-dev-data-team"
                quarantine_key = f"{'Quarantine'}/{file_name}"
                # Was it quarantined before ?
                attempts = total_attempts(conn, file_name)
                if attempts > 0:
                    name, ext = os.path.splitext(file_name)
                    versioned_file_name = f"{name}_{attempts}{ext}"
                    target_file_name = versioned_file_name
                    if not validation_rules:
                        quarantine_key = f"Quarantine/{versioned_file_name}"
                    else:
                        quarantine_key = (
                            validation_rules[-1]["quarantine_s3_location"]
                            + versioned_file_name
                        )
                move_file(
                    source_bucket,
                    fetch_location + file_name,
                    quarantine_bucket,
                    quarantine_key,
                )
                insert_fetch_log(
                    connection=conn,
                    start_time=start_time,
                    fetch_config_id=-1,  # -1 for untracked config
                    external_fetch_config_id=-1,
                    fetched_file_name=file_name,
                    target_file_name=target_file_name,
                    status="No Validation Rules",
                    bucket=quarantine_bucket,
                    location="/".join(quarantine_key.split("/")[:-1]) + "/",
                    notes=("No Matching Validation Rules Found for this File"),
                )
                logger.error(
                    f"No validation rules found for {file_name}. Quarantining the file."
                )
                return {
                    "statusCode": 300,
                    "body": json.dumps(
                        {
                            "message": f"No validation rules found for {file_name}. Quarantining the file.",
                            "event": event,
                        }
                    ),
                }
            matching_rule, notes = is_valid_file_name(file_name, validation_rules)

            # Checking if the same file is already fetched.
            if (
                matching_rule
                and matching_rule["allow_duplicate"] == False
                and already_fetched(conn, file_name)
            ):
                # print(f"Duplicate detected: {file_name} has already been fetched.")
                logger.error(
                    f"Duplicate detected: {file_name} has already been fetched."
                )
                notes = f"Duplicate detected: {file_name} has already been fetched."
                if not validation_rules:
                    fetch_config_id = -1
                    external_fetch_config_id = -1
                    quarantine_bucket = "bloom-dev-data-team"
                    quarantine_key = f"Quarantine/{file_name}"
                else:
                    fetch_config_id = validation_rules[-1]["fetch_config_id"]
                    external_fetch_config_id = validation_rules[-1][
                        "external_fetch_config_id"
                    ]
                    quarantine_bucket = validation_rules[-1]["quarantine_s3_bucket"]
                    quarantine_key = (
                        validation_rules[-1]["quarantine_s3_location"] + file_name
                    )

                # Was it quarantined before ?
                attempts = total_attempts(conn, file_name)
                if attempts > 0:
                    logger.debug(
                        f"File {file_name} has been seen in quarantine {attempts} time/s before."
                    )
                    # Rename the file to avoid overwriting
                    name, ext = os.path.splitext(file_name)
                    versioned_file_name = f"{name}_{attempts}{ext}"
                    target_file_name = versioned_file_name
                    if not validation_rules:
                        quarantine_key = f"Quarantine/{versioned_file_name}"
                    else:
                        quarantine_key = (
                            validation_rules[-1]["quarantine_s3_location"]
                            + versioned_file_name
                        )
                    notes = f"Duplicate file seen {attempts} time/s. Renamed and quarantined as {versioned_file_name}"
                move_file(
                    source_bucket,
                    fetch_location + file_name,
                    quarantine_bucket,
                    quarantine_key,
                )
                insert_fetch_log(
                    conn,
                    start_time,
                    fetch_config_id,
                    external_fetch_config_id,
                    file_name,
                    target_file_name,
                    "Duplicate",
                    quarantine_bucket,
                    "/".join(quarantine_key.split("/")[:-1]) + "/",
                    notes,
                )
                return {
                    "statusCode": 300,
                    "body": json.dumps(
                        {
                            "message": f"Duplicate file found for {file_name}. Quarantining the file.",
                            "event": event,
                        }
                    ),
                }

            # Validate the file name using the fetched rules
            # matching_rule, notes = is_valid_file_name(file_name, validation_rules)
            # extracted_masks = ", ".join([mask for mask in matching_masks])
            if matching_rule:
                # File is valid, move to the next steps
                fetched_file_name = file_name
                # Decrypt the file if it is encrypted
                if file_name.lower().endswith(".pgp"):
                    try:
                        # # print(
                        #     f"File {file_name} is encrypted (.pgp). Attempting decryption..."
                        # )
                        logger.debug(
                            f"File {file_name} is encrypted (.pgp). Attempting decryption..."
                        )
                        # Archive the encrypted file before decryption
                        today = datetime.datetime.now(datetime.UTC).strftime(
                            "%Y%m%d%H%M%S"
                        )
                        archive_key = (
                            f"Archived_Data/Encrypted/{file_name[:-4]}_{today}.pgp"
                        )
                        s3.copy_object(
                            Bucket="bloom-dev-data-team",
                            CopySource={
                                "Bucket": source_bucket,
                                "Key": fetch_location + file_name,
                            },
                            Key=archive_key,
                        )

                        # Read encrypted file content
                        response = s3.get_object(
                            Bucket=source_bucket, Key=fetch_location + file_name
                        )
                        encrypted_bytes = response["Body"].read()

                        pgp_secret_name = matching_rule.get("pgp_decrypt_secret")
                        # Get PGP private key and passphrase
                        private_key_str, passphrase = get_pgp_secret(
                            pgp_secret_name, region_name=aws_region
                        )

                        # Decrypt the file content
                        plaintext_data = decrypt_pgp_file(
                            encrypted_bytes, private_key_str, passphrase
                        )

                        # print(str(plaintext_data))
                        decrypted_key = (
                            f"temp/decrypted/{file_name.replace('.pgp', '')}"
                        )
                        s3.put_object(
                            Bucket="bloom-dev-data-team",
                            Key=decrypted_key,
                            Body=plaintext_data.encode("utf-8"),
                        )
                        s3.delete_object(
                            Bucket=source_bucket, Key=fetch_location + file_name
                        )
                        # Update the object key to the decrypted file name
                        object_key = decrypted_key
                        fetch_location = "/".join(object_key.split("/")[:-1]) + "/"
                        file_name = object_key.split("/")[-1]
                        # print(f"Decrypted and updated key: {object_key}")
                        logger.debug(f"Decrypted and updated key: {object_key}")

                    except Exception as e:
                        # print(
                        #     f"Decryption failed for {file_name}: {str(e)} \n {object_key}"
                        # )
                        logger.exception(
                            f"Decryption failed for {file_name}: {str(e)} \n {object_key}"
                        )
                        # Move to quarantine if decryption fails
                        quarantine_bucket = matching_rule["quarantine_s3_bucket"]
                        quarantine_key = (
                            matching_rule["quarantine_s3_location"] + file_name
                        )
                        attempts = total_attempts(conn, file_name)
                        if attempts > 0:
                            name, ext = os.path.splitext(file_name)
                            versioned_file_name = f"{name}_{attempts}{ext}"
                            target_file_name = versioned_file_name
                            quarantine_key = (
                                matching_rule["quarantine_s3_location"]
                                + versioned_file_name
                            )
                            notes = f"Duplicate file seen {attempts} time/s. Renamed and quarantined as {versioned_file_name}"
                        move_file(
                            source_bucket,
                            fetch_location + file_name,
                            quarantine_bucket,
                            quarantine_key,
                        )
                        insert_fetch_log(
                            conn,
                            start_time,
                            matching_rule["fetch_config_id"],
                            matching_rule["external_fetch_config_id"],
                            file_name,
                            target_file_name,
                            "Quarantined",
                            quarantine_bucket,
                            "/".join(quarantine_key.split("/")[:-1]) + "/",
                            "PGP Decryption Failed: " + str(e),
                        )
                        return {
                            "statusCode": 500,
                            "body": json.dumps({"error": str(e)}),
                        }

                    # write the decrypted content back to S3

                # print(f"File {file_name} is valid according to the rules.")
                # Validate the file headers if expected_headers are provided
                if validate_file_headers(
                    source_bucket,
                    object_key,
                    matching_rule["expected_headers"],
                    matching_rule["file_delimiter"],
                ):
                    # print(f"File {file_name} has valid headers.")
                    logger.debug(
                        f"File {file_name} has valid headers according to the rule."
                    )
                    target_bucket = matching_rule["target_s3_bucket"]
                    target_location = matching_rule["target_s3_location"]
                    if not target_location.endswith("/"):
                        target_location += "/"
                    fetched_key = target_location + file_name
                    logger.debug(
                        f"Moving file {file_name} to {target_bucket}/{fetched_key}"
                    )
                    move_file(
                        source_bucket,
                        fetch_location + file_name,
                        target_bucket,
                        fetched_key,
                    )
                    insert_fetch_log(
                        conn,
                        start_time,
                        matching_rule["fetch_config_id"],
                        matching_rule["external_fetch_config_id"],
                        fetched_file_name,
                        file_name,
                        "Fetched",
                        target_bucket,
                        target_location,
                        notes="File Validation Successful: File Name, Date and File Header Validated",
                    )
                    logger.info(
                        f"File {file_name} moved to {target_bucket}/{fetched_key}"
                    )
                    return {
                        "statusCode": 200,
                        "body": json.dumps(
                            {
                                "message": "File Validation Successful: File Name, Date and File Header Validated",
                                "event": event,
                            }
                        ),
                    }
                notes = "File Header Validation Failed"

            # Validation failed, move to quarantine
            # logger.error(
            #     f"File {file_name} did not match any validation rules or failed header validation."
            # )
            quarantine_bucket = validation_rules[-1]["quarantine_s3_bucket"]
            quarantine_location = validation_rules[-1]["quarantine_s3_location"]
            quarantine_key = quarantine_location + file_name
            # Was it quarantined before ?
            attempts = total_attempts(conn, file_name)
            if attempts > 0:
                name, ext = os.path.splitext(file_name)
                versioned_file_name = f"{name}_{attempts}{ext}"
                target_file_name = versioned_file_name
                quarantine_key = quarantine_location + versioned_file_name
                # notes = f"Duplicate file seen {attempts} time/s. Renamed and quarantined as {versioned_file_name}"
                logger.debug(
                    f"File {file_name} has been seen in quarantine {attempts} time/s before."
                )
            move_file(
                source_bucket,
                fetch_location + file_name,
                quarantine_bucket,
                quarantine_key,
            )
            insert_fetch_log(
                conn,
                start_time,
                validation_rules[-1]["fetch_config_id"],
                validation_rules[-1]["external_fetch_config_id"],
                file_name,
                target_file_name,
                "Quarantined",
                quarantine_bucket,
                "/".join(quarantine_key.split("/")[:-1]) + "/",
                notes,
            )
            logger.error(
                f"File {file_name} moved to quarantine due to validation failure: {notes}"
            )
            return

    except Exception as e:
        # print(f"Error processing file: {str(e)}")
        logger.exception(f"Error processing file: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
    finally:
        if conn:
            conn.close()


"""
Testing parameters

event = {
    "Records": [
        {
            "s3": {
                "bucket": {"name": "bloom-dev-data-team"},
                "object": {"key": "test/mua_det_file/MUA_DET_20250620212524.csv"},
            }
        }
    ]
}

lambda_handler(event, None)
"""
