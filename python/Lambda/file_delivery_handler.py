import os
import boto3
import json
import re
import psycopg2
from datetime import datetime

do_secret_name = os.environ.get("DO_SECRET_NAME", "etluser/dev/rds")
print(f"Using secret name: {do_secret_name}")
print(f"Environment: {os.environ.get('ENV', 'Dev')}")
print(f"Job Name: {os.environ.get('JOB_NAME', 'File-Delivery-Handler')}")
print(f"Job Class: {os.environ.get('JOB_CLASS', 'Testing')}")
env = os.environ.get("ENV", "Dev")
job_name = os.environ.get("JOB_NAME", "File-Delivery-Handler")
job_class = os.environ.get("JOB_CLASS", "Testing")

s3_client = boto3.client("s3")
print(f"Using S3 client in region: {s3_client.meta.region_name}")
print(f"Using environment: {env}, job name: {job_name}, job class: {job_class}")
aws_region = os.getenv("AWS_REGION", "us-west-2")
SECRETS_MANAGER = boto3.client("secretsmanager", region_name=aws_region)
print(f"Using Secrets Manager in region: {aws_region}")


def get_secret(secret_name):
    try:
        response = SECRETS_MANAGER.get_secret_value(SecretId=secret_name)
        return json.loads(response["SecretString"])
    except Exception as e:
        print(f"Unable to retrieve secret {secret_name}: {e}")
        return None


def get_db_connection(secret_name):
    secret = get_secret(secret_name)

    if not secret:
        # return None
        raise Exception(f"Secret {secret_name} not found or invalid")

    try:
        return psycopg2.connect(
            host=secret["host"],
            dbname=secret["dbname"],
            user=secret["username"],
            password=secret["password"],
            port=secret.get("port", 5432),
        )

    except Exception as e:
        print(f"DB connection error: {e}")
        raise
        # return None


def scheduled_delivery_handler():
    configs = get_matching_configs(schedule_based=True)
    for config in configs:
        files = list_files_from_config(config)
        for file_obj in files:
            file_delivery_handler(file_obj, config)


def file_delivery_handler(file_obj, config=None):
    bucket = file_obj["bucket"]
    key = file_obj["key"]
    file_name = os.path.basename(key)
    delivery_context = extract_metadata_from_key(file_name)

    if not config:
        config = get_matching_config_for_file(file_name)
        if not config:
            print(f"No matching config found for file {file_name}")
            return

    ready_for_delivery, log_id = is_ready_for_delivery(config, file_name)
    if not ready_for_delivery:
        print(
            f"File {file_name} is not ready for delivery in config {config['extract_config_id']}"
        )
        return

    if not should_deliver_now(config):
        print(f"Skipping delivery for now: {config['extract_config_id']}")
        return

    if config.get("include_header_flag"):
        if not validate_file_header(bucket, key, config):
            print(f"Header validation failed for {file_name}")
            log_delivery_result(
                config, file_name, "failed", reason="Header validation failed"
            )
            return

    print(f"Processing file {file_name} for delivery")
    delivery_context = extract_metadata_from_key(file_name)
    if config.get("include_header_flag"):
        key, row_count = remove_header_if_needed(bucket, key, config)
        print(f"File {file_name} processed. New key: {key}, Row count: {row_count}")
    else:
        row_count = None

    try:
        if config["deliver_type"] == "S3":
            deliver_to_s3(bucket, key, config)
        elif config["deliver_type"] == "SFTP":
            deliver_to_sftp(bucket, key, config)
        else:
            raise Exception(f"Unsupported delivery type: {config['deliver_type']}")

        log_delivery_result(config, file_name, "success")
        print(f"Delivered file {file_name} successfully")

    except Exception as e:
        print(f"Delivery failed for {file_name}: {str(e)}")
        log_delivery_result(config, file_name, "failed", reason=str(e))


# === HELPER FUNCTIONS (STUBS) ===


def get_matching_configs(schedule_based=False):
    print("Stub: returning dummy config")
    if schedule_based:
        print("Returning configs for scheduled delivery")
    else:
        print("Returning configs for event-based delivery")
    return [
        {
            "extract_config_id": 1,
            "deliver_type": "S3",
            "include_header_flag": False,
            "deliver_s3_bucket": "bloom-dev-data-team",
            "deliver_s3_location": "test/delivery_testing_target/decrypted_sample.txt",
        }
    ]


def convert_mask_into_regex(mask: str) -> str:
    """Convert a file name mask with placeholders into a regex pattern."""
    regex = re.escape(mask)

    regex = regex.replace(r"\#\#\#YEAR\#\#\#", r"(?P<year>\d{4})")
    regex = regex.replace(r"\#\#\#MONTH\#\#\#", r"(?P<month>\d{2})")
    regex = regex.replace(r"\#\#\#DAY\#\#\#", r"(?P<day>\d{2})")
    regex = regex.replace(r"\#\#\#HOUR\#\#\#", r"(?P<hour>\d{2})")
    regex = regex.replace(r"\#\#\#MINUTE\#\#\#", r"(?P<minute>\d{2})")
    regex = regex.replace(r"\#\#\#MONTH_ABBR\#\#\#", r"(?P<month_abbr>[A-Za-z]{3})")
    # print(regex)

    return f"^{regex}$"


def get_matching_config_for_file(file_name):
    # print(f"Stub: found config for {file_name}")
    print(f"Searching for config matching file: {file_name}")
    if not file_name:
        print("No file name provided")
        return None
    conn = get_db_connection(do_secret_name)
    cur = conn.cursor()
    # if cur is None:
    #     print("Failed to create cursor")
    #     return None
    cur.execute(
        """
        SELECT * FROM data_operations.extract_config
        WHERE CURRENT_DATE BETWEEN effective_start_date AND effective_end_date
        ORDER BY effective_start_date DESC
    """
    )
    rows = cur.fetchall()
    columns = [desc[0] for desc in cur.description]

    for row in rows:
        config = dict(zip(columns, row))
        mask = config.get("extract_file_name_mask")
        if not mask:
            continue

        regex = convert_mask_into_regex(mask)
        if re.match(regex, file_name):
            print(f"Matched config {config['extract_config_id']} using mask: {mask}")
            return config
    print(f"No matching config found for file {file_name}")
    cur.close()
    # return None

    return {
        "extract_config_id": 1,
        "deliver_type": "S3",
        "include_header_flag": False,
        "deliver_s3_bucket": "bloom-dev-data-team",
        "deliver_s3_location": "test/delivery_testing_target/decrypted_sample.txt",
    }


def should_deliver_now(config):
    print("Stub: delivery window check passed")
    return True


def deliver_to_s3(bucket, key, config):
    print(
        f"Stub: delivered {key} from {bucket} to {config['deliver_s3_bucket']}/{config['deliver_s3_location']}"
    )


def deliver_to_sftp(bucket, key, config):
    print(f"Stub: uploaded {key} from {bucket} to external SFTP (not implemented yet)")


def log_delivery_result(config, file_name, status, reason=None):
    print(f"Stub: logged {status} for file {file_name}. Reason: {reason}")


def extract_metadata_from_key(file_name):
    return {"timestamp": datetime.utcnow().isoformat(), "other_info": "stubbed"}


def list_files_from_config(config):
    print("Stub: simulating one file in source location")
    return [
        {
            "bucket": "bloom-dev-data-team",
            "key": "test/delivery_testing/decrypted_sample.txt",
        }
    ]


def is_ready_for_delivery(config, file_name):
    print(
        f"Checking if {file_name} is ready for delivery in config {config['extract_config_id']}"
    )
    try:

        conn = get_db_connection(do_secret_name)
        if not conn:
            print("Failed to connect to the database")
            raise Exception("Database connection error")
        cur = conn.cursor()

        cur.execute(
            """
            SELECT extract_log_id, deliver_process_status
            FROM data_operations.extract_log
            WHERE extract_config_id = %s
            AND generate_file_name = %s
            AND generate_process_status = 'ready_for_delivery'
            ORDER BY generate_start_datetime DESC
            LIMIT 1
        """,
            (config["extract_config_id"], file_name),
        )

        result = cur.fetchone()
        cur.close()
        conn.close()

        if result:
            log_id, deliver_status = result
            print(
                f"Extract log found: ID={log_id}, deliver_status={deliver_status} \n proceeding with delivery"
            )
            return True, log_id
        else:
            print(f"No ready_for_delivery log found for {file_name}")
            return False, None
    except Exception as e:
        print(f"Error checking delivery readiness: {e}")
        raise Exception("Error checking delivery readiness")


def remove_header_if_needed(bucket, key, config):
    include_header = config.get("include_header_flag", True)

    obj = s3_client.get_object(Bucket=bucket, Key=key)
    content = obj["Body"].read().decode("utf-8").splitlines()

    if include_header:
        print(f"Header will be included for {key}")
        return key, len(content)  # no change

    print(f"Removing header from file: {key}")

    if len(content) <= 1:
        raise Exception("File has no data rows after header removal")

    # Remove header
    data_only = "\n".join(content[1:]).encode("utf-8")

    # Upload to temp location
    temp_key = f"temp/no_header/{os.path.basename(key)}"
    s3_client.put_object(Bucket=bucket, Key=temp_key, Body=data_only)

    return temp_key, len(content) - 1  # return new key and new row count


def validate_file_header(bucket, key, config):
    print(f"Validating header for file {key} in bucket {bucket}")
    expected_headers_str = config.get("expected_headers")
    delimiter = config.get("extract_delimiter", ",")
    quarantine_bucket = config.get("quarantine_s3_bucket")
    quarantine_prefix = config.get("quarantine_s3_location")

    try:
        obj = s3_client.get_object(Bucket=bucket, Key=key)
        body = obj["Body"].read().decode("utf-8").splitlines()

        if not body:
            raise Exception("File is empty")

        # Check header if expected
        if expected_headers_str:
            expected_headers = [
                h.strip() for h in expected_headers_str.split(delimiter)
            ]
            actual_headers = body[0].split(delimiter)

            if actual_headers != expected_headers:
                raise Exception(
                    f"Header mismatch\nExpected: {expected_headers}\nFound: {actual_headers}"
                )

        return True

    except Exception as e:
        print(f"[VALIDATION FAILED] {key}: {str(e)}")

        # Quarantine the file
        if quarantine_bucket and quarantine_prefix:
            quarantine_key = f"{quarantine_prefix.rstrip('/')}/{os.path.basename(key)}"
            print(f"Quarantining to {quarantine_bucket}/{quarantine_key}")
            s3_client.copy_object(
                Bucket=quarantine_bucket,
                CopySource={"Bucket": bucket, "Key": key},
                Key=quarantine_key,
            )
        else:
            print("Quarantine location not configured — skipping quarantine")

        return False


def lambda_handler(event, context):
    print("Event received:", json.dumps(event))

    if "Records" in event and "s3" in event["Records"][0]:
        # Event-based trigger
        bucket = event["Records"][0]["s3"]["bucket"]["name"]
        key = event["Records"][0]["s3"]["object"]["key"]
        triggered_file = {"bucket": bucket, "key": key}
        print(f"Triggered by S3: {bucket}/{key}")
        file_delivery_handler(triggered_file)
    else:
        # Scheduled run
        print("Running in scheduled mode")
        scheduled_delivery_handler()

    return {"statusCode": 200, "message": "File delivery process completed"}


lambda_handler(
    {
        "Records": [
            {
                "s3": {
                    "bucket": {"name": "bloom-dev-data-team"},
                    "object": {
                        "key": "test/delivery_testing/TESTING_Custom1_20250708_14_05.txt"
                    },
                }
            }
        ]
    },
    None,
)
