import sys
import boto3
import os
import ftplib
import io
import zipfile
from awsglue.utils import getResolvedOptions
import psycopg2
import json 
from CloudWatchSNSLogger import CloudWatchSNSLogger



def retrieve_secrets(secret_name : str)-> dict:
    """Retrieve secrets from AWS Secrets Manager.
    Returns a dictionary with the secret values."""
    try:

        secrets_client = boto3.client('secretsmanager')
        get_secret_value_response = secrets_client.get_secret_value(SecretId=secret_name)
        secret_json = json.loads(get_secret_value_response['SecretString'])
        logger.info(f"Successfully retrieved secrets for {secret_name}")
        return secret_json
    
    except Exception as e:
        logger.exception(f"Failed to retrieve secrets for {secret_name}: {e}")
        raise

def create_db_connection(secret_json : dict) -> psycopg2.extensions.connection:
    """Create a database connection using the provided secrets.
    Returns a psycopg2 connection object.
    """
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
        logger.exception(f"Failed to create database connection: {e}")
        raise

def delete_s3_files(s3_bucket : str, s3_prefix : str) -> None:
    """Delete files from S3 bucket."""
    try:
        # List objects in the S3 bucket with the specified prefix
        response = s3.list_objects_v2(Bucket=s3_bucket, Prefix=s3_prefix)
        
        if 'Contents' in response:
            for obj in response['Contents']:
                s3_key = obj['Key']
                logger.info(f"Deleting {s3_key} from S3 bucket {s3_bucket}")
                s3.delete_object(Bucket=s3_bucket, Key=s3_key)
        
        logger.info(f"Successfully deleted files from S3 bucket {s3_bucket} with prefix {s3_prefix}")
    
    except Exception as e:
        logger.exception(f"Failed to delete files from S3: {e}")
        raise

def download_zipcode_data(ftp_credentials : dict, ftp_path : str, zip_file_name : str, s3_bucket : str , s3_prefix : str, files_to_extract : list) -> dict:  
    """Downloads ZIP code data from FTP server.
       Returns a dictionary with the file names and their corresponding S3 URI.
    """
    try:
        
        extracted_files = {}

        # Connect to the FTP server
        ftp_host = ftp_credentials.get('host')
        ftp_user = ftp_credentials.get('username')
        ftp_pass = ftp_credentials.get('password')
        ftp = ftplib.FTP(ftp_host)
        ftp.login(ftp_user, ftp_pass)
        if ftp_path:
            ftp.cwd(ftp_path)

        logger.info(f"Connected to FTP server: {ftp_host}")

        logger.info(f"Downloading ZIP code data from {ftp_path}/{zip_file_name}")
        
        # Download the ZIP file
        zip_buffer = io.BytesIO()
        ftp.retrbinary(f"RETR {zip_file_name}", zip_buffer.write)
        zip_buffer.seek(0)
        logger.info(f"Scanned ZIP file: {zip_file_name} successfully")


        # Extract specific zip files and upload them to S3 bucket
        with zipfile.ZipFile(zip_buffer, 'r') as zip_ref:
            all_files = zip_ref.namelist()

            for file in files_to_extract:
                if file in all_files:
                    file_content = zip_ref.read(file)

                    s3_key = f"{s3_prefix}/{file}"
                    s3_path = f"s3://{s3_bucket}/{s3_key}"

                    logger.info(f"Uploading {file} to S3: {s3_path}")
                    s3.put_object(Bucket=s3_bucket, Key=s3_key, Body=file_content)

                    
                    extracted_files[file] = s3_path

                else:
                    logger.warning(f"File {file} not found in ZIP")



        #Close the zip buffer
        zip_buffer.close()
        del zip_buffer

        # Close the FTP connection
        ftp.quit()
        logger.info("Successfully uploaded ZIP code data to S3")
        
        
        return extracted_files

    except Exception as e:
        logger.exception(f"Failed to download ZIP code data: {e}")
        raise

def load_to_redshift(s3_uri : str, target_table_name : str, conn) -> None:
    """Load data for a given S3 URI to Redshift tables."""
    try:
        # Connect to Redshift
        cursor = conn.cursor()

        staging_table_name  = f"staging_{target_table_name}"
        

        # Check if the staging table exists
        cursor.execute(f"SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '{staging_table_name}')")
        stg_table_exists = cursor.fetchone()[0]
        
        # Check if the target table exist
        cursor.execute(f"SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '{target_table_name}')")
        table_exists = cursor.fetchone()[0]


        if not table_exists:
            logger.error(f"Table {target_table_name} does not exist in Redshift")
            raise Exception(f"Table {target_table_name} does not exist in Redshift")
        
        elif not stg_table_exists:
            logger.error(f"Table {staging_table_name} does not exist in Redshift")
            raise Exception(f"Table {staging_table_name} does not exist in Redshift")


        else:

            #truncate staging table
            truncate_command = f"TRUNCATE TABLE reference.{staging_table_name};"
            cursor.execute(truncate_command)
            conn.commit()
            

            #truncate target table
            truncate_command = f"TRUNCATE TABLE reference.{target_table_name};"
            cursor.execute(truncate_command)
            conn.commit()



            # Load data into Staging table
            copy_command = f"""
                COPY reference.{staging_table_name}
                FROM '{s3_uri}'
                IAM_ROLE 'arn:aws:iam::511539536780:role/Redshift_for_copy'
                CSV
                IGNOREHEADER 1
                DELIMITER ','
                TIMEFORMAT 'auto'
                DATEFORMAT 'auto'
                NULL AS 'NULL'
                ACCEPTINVCHARS '?'
            """
            cursor.execute(copy_command)
            conn.commit()


            #inserting data from staging table to target table
            insert_command = f"INSERT INTO reference.{target_table_name} SELECT *, getdate() FROM reference.{staging_table_name}"
            cursor.execute(insert_command)
            conn.commit()   
            logger.info(f"Data inserted into reference.{target_table_name} table successfully")


            #truncate staging table
            truncate_command = f"TRUNCATE TABLE reference.{staging_table_name};"
            cursor.execute(truncate_command)
            conn.commit()

        cursor.close()
        
            

    except Exception as e:
        logger.exception(f"Failed to load data to Redshift: {e}")
        raise

        



if __name__ == "__main__":

    # Set up logging
    logger = CloudWatchSNSLogger()

    #global aws clients
    s3 = boto3.client('s3')

    logger.info("Starting extraction and loading of ZIP code data")
    
    #Get job parameters
    args = getResolvedOptions(sys.argv,
                           ['JOB_NAME',
                           'ftp_secret_name',
                            'rs_secret_name',
                           's3_bucket',
                           's3_prefix'
                           ])

    
    # Extract parameters
    job_name = args['JOB_NAME'] 
    ftp_secret_name =  args['ftp_secret_name'] 
    rs_secret_name = args['rs_secret_name']
    s3_bucket =   args['s3_bucket'] 
    s3_prefix =   args['s3_prefix']  
    
    
    
    ftp_path = '/ZIP-BUSINESS'
    zip_file_name = 'zip-codes-database-DELUXE-BUSINESS-csv.zip'
    files_to_extract = ['zip-codes-database-DELUXE-BUSINESS.csv', 'zip-codes-database-MULTI-COUNTY.csv' , 'zip-codes-database-PLACE-FIPS.csv']
    
    #file-table mappings
    table_mapping = {
        'zip-codes-database-DELUXE-BUSINESS.csv': 'zip_codes',
        'zip-codes-database-MULTI-COUNTY.csv': 'multi_county_zip_codes',
        'zip-codes-database-PLACE-FIPS.csv': 'place_fips_zip_codes'
    }
    
    
    ftp_credentials = retrieve_secrets(ftp_secret_name)
    rs_credentials = retrieve_secrets(rs_secret_name)
    rs_conn = create_db_connection(rs_credentials)
    delete_s3_files(s3_bucket, s3_prefix)
    file_mapping = download_zipcode_data(ftp_credentials, ftp_path, zip_file_name, s3_bucket, s3_prefix, files_to_extract)
    
    
    for file_name, s3_key in file_mapping.items():
        
        logger.info(f"Processing file: {file_name} with S3 key: {s3_key}")
        redshift_table = table_mapping.get(file_name)
        
        if redshift_table:
            load_to_redshift(s3_key, redshift_table, rs_conn)
        else:
            logger.warning(f"No mapping found for {file_name}")
    
        logger.info(f"Loaded {file_name} into {redshift_table} table")
    
    #closing redshift connection
    rs_conn.close()
    logger.info("Completed extraction and loading of ZIP code data")