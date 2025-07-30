import boto3
import sys

# print(sys.path)
import pymssql
import json
import pandas as pd

# print(" pymssql import successful!")

from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from pyspark.sql.functions import current_timestamp

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session


def get_secret(secret_name, region="us-west-2"):
    client = boto3.client("secretsmanager", region_name=region)
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response["SecretString"])


# --- Load SQL Server secret ---
sql_secret = get_secret("prod-db-ccs-etluser")
rs_secret = get_secret("prod-db-redshift-dbadmin")
# --- Connect using pymssql ---
ss_conn = pymssql.connect(
    host=sql_secret["host"],
    user="RMGCOM\\" + sql_secret["username"],
    password=sql_secret["password"],
    # database=''
    port=int(sql_secret["port"]),
    tds_version="7.3",
)

redshift_jdbc_url = (
    f"jdbc:redshift://{rs_secret['host']}:{rs_secret['port']}/" f"{rs_secret['dbname']}"
)

# sqlserver_jdbc_url = (
#     f"jdbc:sqlserver://{sql_secret['host']}:{sql_secret['port']};"
#     "databaseName=CallCenter;"
#     "encrypt=true;"  # or true with trustServerCertificate
#     "trustServerCertificate=true;"
# )

# bloom_clients_df = spark.read \
#     .format("jdbc") \
#     .option("url", sqlserver_jdbc_url) \
#     .option("user", 'RMGCOM\\'+sql_secret["username"]) \
#     .option("password", sql_secret["password"]) \
#     .option("query", "SELECT * FROM Bloom_Clients") \
#     .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
#     .load()


# ss_cursor = ss_conn.cursor()
# ss_cursor.execute("SELECT COUNT(1) FROM CallCenter..Bloom_Clients")
# row = ss_cursor.fetchone()
# print("SQL Server connection is successful", bloom_clients_df)

# rs_cursor = rs_conn.cursor()
# rs_cursor.execute("SELECT COUNT(1) FROM sandbox_mmuvva.dimplan")
# row = rs_cursor.fetchone()


def load_dimclients(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Fetch new clients from SQL Server and insert them into Redshift DimClient table,
    avoiding duplicates by left anti join on ClientID and ClientName.

    :param spark: SparkSession
    :param ss_conn: pymssql connection object (SQL Server)
    :param rs_secret: dict with Redshift credentials from Secrets Manager
    :param redshift_jdbc_url: JDBC URL to connect to Redshift
    :param target_table: Redshift target table (e.g., 'sandbox_mmuvva.DimClient')
    """

    # 1. Read from SQL Server using pymssql
    sql_query = """
    SELECT PKBloomClientID, Name, LogoPath, HostName, CSSPath, DatabaseName, IsActive
    FROM CallCenter..Bloom_Clients
    """
    bloom_clients_pd = pd.read_sql(sql_query, ss_conn)
    bloom_clients_df = spark.createDataFrame(bloom_clients_pd)

    # 2. Read existing Redshift DimClient data to avoid duplicates
    dim_client_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT clientid, clientname FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Left anti join: only new records
    join_condition = (
        bloom_clients_df["PKBloomClientID"] == dim_client_df["clientid"]
    ) & (bloom_clients_df["Name"] == dim_client_df["clientname"])
    new_clients_df = bloom_clients_df.join(
        dim_client_df, join_condition, how="left_anti"
    )

    if new_clients_df.count() == 0:
        print("No new clients to insert.")
        return

    # 4. Prepare final DataFrame with matching Redshift schema
    final_clients_df = (
        new_clients_df.withColumnRenamed("PKBloomClientID", "clientid")
        .withColumnRenamed("Name", "clientname")
        .withColumnRenamed("LogoPath", "urlpath")
        .withColumnRenamed("HostName", "hostname")
        .withColumnRenamed("CSSPath", "csspath")
        .withColumnRenamed("DatabaseName", "databasename")
        .withColumnRenamed("IsActive", "isactive")
        .withColumn("dateinserted", current_timestamp())
        .select(
            "clientid",
            "clientname",
            "urlpath",
            "hostname",
            "csspath",
            "databasename",
            "isactive",
            "dateinserted",
        )
    )

    # 5. Write to Redshift
    cnt = final_clients_df.count()
    final_clients_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f"{cnt} new client(s) inserted into {target_table}")


def load_dimprojects(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new project records from SQL Server into Redshift DimProject table,
    combining data from InboundConfiguration and Pools with associated clients.

    :param spark: SparkSession
    :param ss_conn: pymssql connection object
    :param rs_secret: dict with Redshift credentials
    :param redshift_jdbc_url: Redshift JDBC URL
    :param target_table: Target Redshift table (e.g., 'sandbox_mmuvva.DimProject')
    """

    # --- Read source data from SQL Server ---
    sql_inbound = """
    SELECT I.PKInboundConfiguration AS ProjectID,
           B.PKBloomClientID AS ClientID,
           I.Name AS ProjectName,
           'Inbound' AS Direction,
           I.IsRunning AS IsActive
    FROM CallCenter..InboundConfiguration I
    INNER JOIN CallCenter..Bloom_Clients B ON B.DatabaseName = I.DatabaseName
    WHERE B.IsActive = 1
    """
    sql_pools = """
    SELECT P.PKPool AS ProjectID,
           B.PKBloomClientID AS ClientID,
           P.Name AS ProjectName,
           'Outbound' AS Direction,
           P.IsRunning AS IsActive
    FROM CallCenter..Pools P
    INNER JOIN CallCenter..Bloom_Clients B ON B.DatabaseName = P.DatabaseName
    WHERE B.IsActive = 1
    """

    df_inbound = pd.read_sql(sql_inbound, ss_conn)
    df_pools = pd.read_sql(sql_pools, ss_conn)

    combined_pd = pd.concat([df_inbound, df_pools], ignore_index=True)
    combined_df = spark.createDataFrame(combined_pd)

    # --- Read Redshift DimClient to get dimClientID ---
    dim_client_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", "SELECT clientid, dimclientid FROM sandbox_mmuvva.DimClient")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # --- Join to get dimClientID for each record ---
    project_with_client_df = combined_df.join(
        dim_client_df, combined_df["ClientID"] == dim_client_df["clientid"], how="inner"
    )

    # --- Rename columns to match Redshift schema ---
    final_df = (
        project_with_client_df.withColumnRenamed("ProjectID", "projectid")
        .withColumnRenamed("ProjectName", "projectname")
        .withColumnRenamed("Direction", "direction")
        .withColumnRenamed("IsActive", "isactive")
        .withColumn("dateinserted", current_timestamp())
        .select(
            "projectid",
            "dimclientid",
            "projectname",
            "direction",
            "isactive",
            "dateinserted",
        )
    )

    # --- Read existing DimProject records from Redshift ---
    dim_project_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT projectid, dimclientid FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # --- Deduplicate (left anti join on projectid + dimclientid) ---
    join_condition = (final_df["projectid"] == dim_project_df["projectid"]) & (
        final_df["dimclientid"] == dim_project_df["dimclientid"]
    )

    new_projects_df = final_df.join(dim_project_df, join_condition, how="left_anti")

    if new_projects_df.count() == 0:
        print("No new projects to insert.")
        return

    # --- Write to Redshift ---
    cnt = new_projects_df.count()
    new_projects_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f"{cnt} new project(s) inserted into {target_table}")


def load_dimcalltypes(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new call type records from SQL Server into Redshift DimCallType table,
    ensuring deduplication by joining on CallTypeID and CallTypeDescription.

    :param spark: SparkSession
    :param ss_conn: pymssql connection object
    :param rs_secret: dict with Redshift credentials
    :param redshift_jdbc_url: Redshift JDBC URL
    :param target_table: Target Redshift table (e.g., 'sandbox_mmuvva.DimCallType')
    """

    # 1. Read CallTypeDescription from SQL Server
    query = """
    SELECT CallType_ID AS calltypeid, CallDirection AS calltypedescription
    FROM CallCenter..CallTypeDescription
    """
    calltype_pd = pd.read_sql(query, ss_conn)
    calltype_df = spark.createDataFrame(calltype_pd)

    # 2. Read existing DimCallType from Redshift
    dim_calltype_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT calltypeid, calltypedescription FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Deduplicate using Spark left_anti join
    join_condition = (calltype_df["calltypeid"] == dim_calltype_df["calltypeid"]) & (
        calltype_df["calltypedescription"] == dim_calltype_df["calltypedescription"]
    )
    new_calltypes_df = calltype_df.join(
        dim_calltype_df, join_condition, how="left_anti"
    )

    if new_calltypes_df.count() == 0:
        print("No new call types to insert.")
        return

    # 4. Add audit column
    final_df = new_calltypes_df.select("calltypeid", "calltypedescription")

    # 5. Write to Redshift
    cnt = final_df.count()
    final_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f"{cnt} new call type(s) inserted into {target_table}")


from pyspark.sql.functions import when, current_timestamp, lit, col


def load_dimdispositions(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new dispositions into Redshift with enriched columns and logic, and patches bcbs rows with dimClientID=82.

    :param spark: SparkSession
    :param ss_conn: pymssql connection
    :param rs_secret: dict with Redshift creds
    :param redshift_jdbc_url: Redshift JDBC URL
    :param target_table: Redshift table (e.g. sandbox_mmuvva.DimDisposition)
    """

    # 1. Pull from SQL Server: CallResultCodes
    sql_query = """
    SELECT CallResultCode AS dispositionid,
           CallResultDescription AS dispositionname,
           CountAsLead,
           NeverCall,
           Presentation,
           CountAsContact,
           SystemCode,
           Deleted
    FROM CallCenter..CallResultCodes
    """
    df_pd = pd.read_sql(sql_query, ss_conn)
    print(f"Trying to insert rows: {df_pd.count()}")
    source_df = spark.createDataFrame(df_pd)

    # 2. Load existing Dispositions from Redshift
    existing_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT dispositionid FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Deduplicate
    new_df = source_df.join(existing_df, on="dispositionid", how="left_anti")

    if new_df.count() == 0:
        print("No new dispositions to insert.")
        return

    # 4. Enrich fields
    print("Hereeeeee")
    enriched_df = (
        new_df.withColumn("dimclientid", lit(0))
        .withColumn("lead", col("CountAsLead"))
        .withColumn("eligible", lit(0))
        .withColumn("enrollment", lit(0))
        .withColumn("dnc", col("NeverCall"))
        .withColumn(
            "iscallback",
            when(col("dispositionname").like("%Callback%"), lit(1)).otherwise(lit(0)),
        )
        .withColumn("isactive", when(col("Deleted") == 0, lit(1)).otherwise(lit(0)))
        .withColumn("dateinserted", current_timestamp())
        .withColumnRenamed("Presentation", "presentation")
        .withColumnRenamed("CountAsContact", "contact")
        .withColumnRenamed("SystemCode", "systemcode")
        .select(
            "dispositionid",
            "dispositionname",
            "dimclientid",
            "lead",
            "eligible",
            "enrollment",
            "dnc",
            "iscallback",
            "presentation",
            "contact",
            "systemcode",
            "isactive",
            "dateinserted",
        )
    )
    enriched_df.printSchema()

    # 5. Insert into Redshift
    cnt = enriched_df.count()
    enriched_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f"{cnt} new disposition(s) inserted into {target_table}")


def load_dimlistsources(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new list source records from SQL Server into Redshift DimListSources table,
    deduplicating on Name.

    :param spark: SparkSession
    :param ss_conn: pymssql connection object
    :param rs_secret: dict from Secrets Manager
    :param redshift_jdbc_url: Redshift JDBC connection string
    :param target_table: Redshift target table (e.g. 'sandbox_mmuvva.DimListSources')
    """

    # 1. Query SQL Server
    query = """
    SELECT PKListSource AS listsourceid, Name
    FROM CallCenter..ListSources
    """
    listsource_pd = pd.read_sql(query, ss_conn)
    listsource_df = spark.createDataFrame(listsource_pd)

    # 2. Read existing Names from Redshift
    redshift_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT name FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Deduplicate using left_anti join
    new_df = listsource_df.join(redshift_df, on="Name", how="left_anti")

    if new_df.count() == 0:
        print(" No new list sources to insert.")
        return

    # 4. Insert only required fields
    final_df = new_df.select("listsourceid", "Name")

    # 5. Write to Redshift
    cnt = final_df.count()
    final_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f" {cnt} new list source(s) inserted into {target_table}")


def load_dimcalllistqueries(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new call list queries from SQL Server into Redshift, deduplicated by Name.

    :param spark: SparkSession
    :param ss_conn: pymssql connection
    :param rs_secret: dict from Secrets Manager
    :param redshift_jdbc_url: Redshift JDBC URL
    :param target_table: Target Redshift table (e.g., 'sandbox_mmuvva.DimCallListQueries')
    """

    # 1. Query SQL Server source table
    query = """
    SELECT PKQueries AS calllistqueryid,
           Name,
           SQLText,
           AvailableSqlText,
           TotalSqlText,
           DialingSqlText,
           PersistOnExhaust
    FROM CallCenter..Queries
    """
    calllistqueries_pd = pd.read_sql(query, ss_conn)
    source_df = spark.createDataFrame(calllistqueries_pd)

    # 2. Read existing Names from Redshift
    redshift_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT name FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Deduplicate on Name
    new_df = source_df.join(redshift_df, on="Name", how="left_anti")

    if new_df.count() == 0:
        print("No new call list queries to insert.")
        return

    # 4. Add timestamp column
    final_df = new_df.withColumn("dateinserted", current_timestamp()).select(
        "calllistqueryid",
        "Name",
        "SQLText",
        "AvailableSqlText",
        "TotalSqlText",
        "DialingSqlText",
        "PersistOnExhaust",
        "dateinserted",
    )

    # 5. Write to Redshift
    cnt = final_df.count()
    final_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f" {cnt} new call list query record(s) inserted into {target_table}")


from pyspark.sql.functions import current_timestamp, lit
from pyspark.sql.types import StringType


def load_dimcustomers(spark, ss_conn, rs_secret, redshift_jdbc_url, target_table):
    """
    Loads new customer records from SQL Server into Redshift DimCustomer table.

    :param spark: SparkSession
    :param ss_conn: pymssql connection (SQL Server)
    :param rs_secret: dict with Redshift credentials
    :param redshift_jdbc_url: JDBC URL to connect to Redshift
    :param target_table: Redshift table (e.g., 'sandbox_mmuvva.DimCustomer')
    """

    # 1. Read data from SQL Server
    query = """
    SELECT PKCustomerRecord AS customerid,
           firstname, lastname, address1, address2,
           city, state, zip, EmailAddress,
           Call_List AS calllist,
           InsertedDate AS customerdateadded,
           IsCallable
    FROM CS_BCBS_MI_Medicare.dbo.ContactInfo
    """
    customer_pd = pd.read_sql(query, ss_conn)

    # Clean up strings (equivalent to RTRIM/LTRIM)
    for col in [
        "firstname",
        "lastname",
        "address1",
        "address2",
        "city",
        "state",
        "zip",
        "EmailAddress",
        "calllist",
    ]:
        customer_pd[col] = customer_pd[col].astype(str).str.strip()

    # Convert to Spark DataFrame
    customer_df = spark.createDataFrame(customer_pd)

    # 2. Read existing CustomerIDs from Redshift
    redshift_df = (
        spark.read.format("jdbc")
        .option("url", redshift_jdbc_url)
        .option("query", f"SELECT customerid FROM {target_table}")
        .option("user", rs_secret["username"])
        .option("password", rs_secret["password"])
        .option("driver", "com.amazon.redshift.jdbc.Driver")
        .load()
    )

    # 3. Deduplicate using left_anti
    new_df = customer_df.join(redshift_df, on="customerid", how="left_anti")

    if new_df.count() == 0:
        print("No new customers to insert.")
        return

    # 4. Add fixed dimClientID and DateInserted
    final_df = (
        new_df.withColumn("dimclientid", lit(82))
        .withColumn("dateinserted", current_timestamp())
        .select(
            "customerid",
            "dimclientid",
            "firstname",
            "lastname",
            "address1",
            "address2",
            "city",
            "state",
            "zip",
            "EmailAddress",
            "calllist",
            "customerdateadded",
            "isCallable",
            "dateinserted",
        )
        .withColumnRenamed("firstname", "firstname")
        .withColumnRenamed("lastname", "lastname")
        .withColumnRenamed("address1", "address1")
        .withColumnRenamed("address2", "address2")
        .withColumnRenamed("EmailAddress", "email")
        .withColumnRenamed("calllist", "calllist")
        .withColumnRenamed("customerdateadded", "customerdateadded")
        .withColumnRenamed("isCallable", "iscallable")
    )

    # 5. Write to Redshift
    cnt = final_df.count()
    final_df.write.format("jdbc").option("url", redshift_jdbc_url).option(
        "dbtable", target_table
    ).option("user", rs_secret["username"]).option(
        "password", rs_secret["password"]
    ).option(
        "driver", "com.amazon.redshift.jdbc.Driver"
    ).mode(
        "append"
    ).save()

    print(f"{cnt} new customer(s) inserted into {target_table}")


# load_dimclients(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimClient"
# )

# load_dimprojects(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimProject"
# )

# load_dimcalltypes(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimCallType"
# )

# load_dimdispositions(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimDisposition"
# )

# load_dimlistsources(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimListSources"
# )

# load_dimcalllistqueries(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimCallListQueries"
# )

# load_dimcustomers(
#     spark=spark,
#     ss_conn=ss_conn,
#     rs_secret=rs_secret,
#     redshift_jdbc_url=redshift_jdbc_url,
#     target_table="sandbox_mmuvva.DimCustomer"
# )


ss_conn.close()
# job.commit()
