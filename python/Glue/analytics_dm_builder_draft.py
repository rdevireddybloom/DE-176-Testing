import sys
import re
import psycopg2
import json
import boto3
import sqlalchemy as sa
import csv
import logging

# Initialize logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Set the minimum logging level.
# Create a StreamHandler to output to stdout
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
# Create a formatter to customize the log message format
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(handler)

# Few variable initializations
region_name = "us-west-2"
rs_secret_name = "prod/dw/Redshift/etluser"
lookback_num_days = 3

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


logger.info(f"Sys.argv settings for this run: {sys.argv}")

try:
    # Retrieve secrets
    rs_secret_json = retrieve_secrets(rs_secret_name)

    # Create RS database connections
    rs_conn = create_db_connection(rs_secret_json)
    rs_cursor = rs_conn.cursor()

    new_count_sql_to_run = (
        "select count(*) from integrated_ccs.AgentStats where StatsDate = "
    )

    raw_sql_to_run = """select CASE WHEN a.UsersFK > 0 then a.UsersFK else 0 end                           as UsersFK,
                               CASE WHEN a.UsersFK > 0 THEN u.Name ELSE 'Amcat Engine' END                 as Name,
                               PauseTime,
                               case
                                   when NumberOfCampaigns > 0 then
                                       (DATEDIFF(milliseconds, date(PauseTime)::timestamp, PauseTime) / 1000.00) / NumberOfCampaigns
                                   else 0 end                                                              as PauseSeconds,
                               WaitTime,
                               case
                                   when NumberOfCampaigns > 0 then
                                       (DATEDIFF(milliseconds, date(WaitTime)::timestamp, WaitTime) / 1000.00) / NumberOfCampaigns
                                   else 0 end                                                              as WaitSeconds,
                               NotAvailableTime,
                               case
                                   when NumberOfCampaigns > 0 then
                                       (DATEDIFF(milliseconds, date(NotAvailableTime)::timestamp, NotAvailableTime) / 1000.00) /
                                       NumberOfCampaigns
                                   else 0 end                                                              as NotAvailableSeconds,
                               SystemTime,
                               (DATEDIFF(milliseconds, date(SystemTime)::timestamp, SystemTime) / 1000.00) as SystemSeconds,
                               StatsDate,
                               StatsTime,
                               EXTRACT(HOUR FROM StatsTime)                                                AS HourOfCall,
                               (CASE
                                    WHEN ((EXTRACT(MINUTE FROM StatsTime) >= 0) and (EXTRACT(MINUTE FROM StatsTime) < 30)) THEN 0
                                    ELSE 30 END)                                                           AS HalfHourOfCall,
                               a.CampaignFK,
                               NumberOfCampaigns,
                               case
                                   when (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0))
                                       and i.Name is not null then RTRIM(LTRIM(i.Name))
                                   when (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0))
                                       and p.Name is not null then RTRIM(LTRIM(p.Name))
                                   when a.ProjectType = 3
                                       and e.Name is not null then RTRIM(LTRIM(e.Name))
                                   end                                                                     as ProjectName,
                               PrevState,
                               NextState,
                               PauseReasonFK,
                               case when PauseReasonFK <> -1 then r.Text else PauseReasonText end          as PauseReason,
                               LogoutReasonFK,
                               case when LogoutReasonFK <> -1 then rr.Text else LogoutReasonText end       as LogoutReason,
                               current_timestamp                                                           as refresh_timestamp
                        from ((integrated_ccs.AgentStats a LEFT JOIN integrated_ccs.Users u on a.UsersFK = u.PKUsers)
                            LEFT JOIN integrated_ccs.Pools p
                              on (a.ProjectType = 2 or (a.ProjectType is null and a.CampaignFK > 0)) and a.CampaignFK = p.PKPool)
                                 LEFT JOIN integrated_ccs.InboundConfiguration i
                                           on (a.ProjectType = 1 or (a.ProjectType is null and a.CampaignFK < 0)) and
                                              a.CampaignFK = i.PKInboundConfiguration
                                 LEFT JOIN integrated_ccs.Reasons r on a.PauseReasonFK = r.PKReason
                                 LEFT JOIN integrated_ccs.Reasons rr on a.LogoutReasonFK = rr.PKReason
                                 LEFT JOIN integrated_ccs.EmailProjects e on a.ProjectType = 3 and a.CampaignFK = e.PKEmailProject
                        where a.statsdate::date = """

    summarized_sql_to_run = """Select A.UsersFK,
             A.Name,
             A.ProjectName,
             A.StatsDate,
             A.HourOfCall,
             Sum(A.WaitSeconds)         As TotalWait,
             Sum(A.PauseSeconds)        As TotalPause,
             Sum(A.NotAvailableSeconds) As TotalNotAvailableSeconds,
             Sum(A.SystemSeconds)       As TotalSyst,
             current_timestamp
        From dm_analytics.AgentLogTime_raw A
        where a.statsdate::date = ###REPLACE###
        Group By A.UsersFK
               , A.Name
               , A.ProjectName
               , A.StatsDate
               , A.HourOfCall"""

    for i in range(lookback_num_days, 0, -1):

        new_count = 0
        existing_raw_count = 0
        existing_summarized_count = 0

        lookback_clause = "current_date - " + str(i)

        # check counts for date being added.
        rs_cursor.execute(new_count_sql_to_run + lookback_clause)
        count_results = rs_cursor.fetchone()
        new_count = count_results[0]

        # check counts for existing data for that date
        rs_cursor.execute(
            "select count(*) from dm_analytics.agentlogtime_raw where statsdate::date = "
            + lookback_clause
        )
        count_results = rs_cursor.fetchone()
        existing_raw_count = count_results[0]

        rs_cursor.execute(
            "select count(*) from dm_analytics.agentlogtime_summarized where statsdate::date = "
            + lookback_clause
        )
        count_results = rs_cursor.fetchone()
        existing_summarized_count = count_results[0]

        # if existing count > new count:  send alert and leave existing as is for  now
        if existing_raw_count > new_count:
            # send alert to SNS topic.
            error_email_subject = "Analytics DM build Alert"
            error_message_to_send = (
                "Alert occurred in: analytics_dm_builder glue job.  \
                Existing rec count > Update rec count for lookback of "
                + str(i)
                + "days!!"
            )
            sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
            msg_id = publish_message(
                sns_topic, error_message_to_send, error_email_subject
            )

        else:
            if new_count == 0:
                # send alert to SNS topic about missing data
                # And do not update anything with existing
                error_email_subject = "Analytics DM build Alert"
                error_message_to_send = (
                    "Alert occurred in: analytics_dm_builder glue job.  \
                    New record count of 0 for lookback of "
                    + str(i)
                    + "days!!"
                )
                sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
                # msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

            else:
                if existing_raw_count > 0:
                    # remove raw data
                    logger.info(
                        "Existing raw records found for lookback "
                        + str(i)
                        + ":  deleting"
                    )
                    rs_cursor.execute(
                        "delete from dm_analytics.agentlogtime_raw where statsdate::date = "
                        + lookback_clause
                    )
                if existing_summarized_count > 0:
                    # remove summarized data
                    logger.info(
                        "Existing summarized records found for lookback "
                        + str(i)
                        + ":  deleting"
                    )
                    rs_cursor.execute(
                        "delete from dm_analytics.agentlogtime_summarized where statsdate::date = "
                        + lookback_clause
                    )

                # insert new raw data
                logger.info("Inserting new raw recs for lookback " + str(i))
                rs_cursor.execute(
                    "insert into dm_analytics.agentlogtime_raw \
                        "
                    + raw_sql_to_run
                    + lookback_clause
                )

                # insert new summarized
                logger.info("Inserting new summarized recs for lookback " + str(i))
                rs_cursor.execute(
                    "insert into dm_analytics.agentlogtime_summarized \
                        "
                    + summarized_sql_to_run.replace("###REPLACE###", lookback_clause)
                )

                rs_conn.commit()

    step1_sql_to_run = """delete from integrated_ccs.bloom_vwcallstats where date(callstarttime) >= current_date - 3;
        insert into integrated_ccs.Bloom_vwCallStats
        select PKCallResults,c.AgentExitCode as CallResultCode, m.CallResultDescription,
        m.Presentation,m.CountAsLead,m.Printable,
        m.SystemCode,m.NeverCall,  m.AddToMasterDoNotCall, m.Verification, c.AgentWrapEndTime,
        /* AGENTWRAPSECONDS */
        CASE WHEN CallType in (0,1,2,3,4,5,6) and AgentWrapEndTime > CallEndTime THEN
           (DATEDIFF(milliseconds, CallEndTime::timestamp, AgentWrapEndTime::timestamp)/1000.00)
        ELSE
        	0
        END AgentWrapSeconds,
        
        /* CALLDURATIONSECONDS */
        CASE WHEN CallType in (0,1,2,3,4,5,6) THEN
        	CASE WHEN AgentWrapEndTime >= CallEndTime THEN
        	    (DATEDIFF(milliseconds, CallStartTime::timestamp, AgentWrapEndTime::timestamp)/1000.00)
        	ELSE
        	    (DATEDIFF(milliseconds, CallStartTime::timestamp, CallEndTime::timestamp)/1000.00)
        	END
        ELSE
        	0
        END CallDurationSeconds,
        
        /* EDIT */
        CASE WHEN CallType = 11 and AgentWrapEndTime > CallEndTime THEN
            (DATEDIFF(milliseconds, CallEndTime::timestamp, AgentWrapEndTime::timestamp)/1000.00)
        ELSE
        	0
        END EditSeconds,
        
        /* HOLDSECONDS */
        CASE WHEN CallType in (0,1,2,3,4,5,6) and HoldTime IS NOT NULL THEN
           (DATEDIFF(milliseconds, date(HoldTime)::timestamp, HoldTime::timestamp)/1000.00)
        ELSE
        	0
        END HoldSeconds,
        HoldTime,
        
        /* PREVIEWSECONDS */
        CASE WHEN CallType <> 5 THEN
        	0
        ELSE
        	/* Outbound Preview */
        	CASE WHEN CallSentToAgentTime is not null THEN /* Call was taken */
        	    (DATEDIFF(milliseconds, CallStartTime::timestamp, PreviewTime::timestamp)/1000.00)
        	ELSE
        		(DATEDIFF(milliseconds, CallStartTime::timestamp, CallEndTime::timestamp)/1000.00)
        	END
        END PreviewSeconds,
        PreviewTime,
        
        /* QUEUESECONDS (voice)*/
        CASE WHEN CallType in (0,1,2,3,4,6) THEN
        	CASE WHEN c.CallSentToAgentTime is not null THEN
        		CASE WHEN c.CallStartTime <= c.CallSentToAgentTime THEN
        		    (DATEDIFF(milliseconds, c.CallStartTime::timestamp, c.CallSentToAgentTime::timestamp)/1000.00)
        		ELSE
        			0
        		END
        	ELSE
        		CASE WHEN c.CallStartTime < c.CallEndTime THEN
        		    (DATEDIFF(milliseconds, CallStartTime::timestamp, CallEndtime::timestamp)/1000.00)
        		ELSE
        			0
        		END
        	END
        ELSE
        	0
        END QueueSeconds,
        
        /* QUEUESECONDS_EMAIL */
        CASE WHEN CallType in (7,12,13) THEN
        	CASE WHEN c.CallSentToAgentTime is not null THEN
        		CASE WHEN em.Received <= c.CallSentToAgentTime THEN
                    (DATEDIFF(milliseconds, Received::timestamp, CallSentToAgentTime::timestamp)/1000.00)
        		ELSE
        			0
        		END
        	ELSE
        		CASE WHEN em.Received < c.CallEndTime THEN
        		    (DATEDIFF(milliseconds, Received::timestamp, CallEndtime::timestamp)/1000.00)
        		ELSE
        			0
        		END
        	END
        ELSE
        	0
        END QueueSeconds_Email,
        
        
        /* READINGSECONDS (EMAIL)*/
        CASE WHEN CallType in (7,12,13) THEN
            (DATEDIFF(milliseconds, CallSentToAgentTime::timestamp, CallEndTime::timestamp)/1000.00)
        ELSE
        	0
        END ReadingSeconds,
        
        /* TALKSECONDS */
        CASE WHEN CallType in (0,1,2,3,4,6) THEN
            (DATEDIFF(milliseconds, CallSentToAgentTime::timestamp, CallEndTime::timestamp)/1000.00)
        WHEN CallType = 5 THEN /* Outbound Preview */
        	CASE WHEN CallSentToAgentTime is not null THEN /* Call was taken */
            (DATEDIFF(milliseconds, PreviewTime::timestamp, CallEndTime::timestamp)/1000.00)
        	ELSE
        		0 /* Call was declined */
        	END
        ELSE
        	0
        END TalkSeconds,
        
        /* WRITINGSECONDS (EMAIL) */
        CASE WHEN CallType in (7,13) and AgentWrapEndTime > CallEndTime THEN
        (DATEDIFF(milliseconds, CallEndTime::timestamp, AgentWrapEndTime::timestamp)/1000.00)
            ELSE
        	0
        END WritingSeconds,
        EXTRACT(HOUR FROM CallStartTime) AS HourOfCall,
        (CASE WHEN ((EXTRACT(MINUTE FROM CallStartTime) >= 0) and (EXTRACT(MINUTE FROM CallStartTime) < 30)) THEN 0 ELSE 30 END) AS HalfHourOfCall,
        case when c.AgentFK > 0 then c.AgentFK else 0 end AgentFK,
        CASE WHEN c.AgentFK > 0 THEN u.Name ELSE 'Amcat Engine' END as Name,
        c.CallEndTime,
        c.CallStartTime,
        c.CallType,
        	case
        	WHEN c.calltype = 0 then 'Predictive'
        	WHEN c.calltype = 1 then 'Callback'
        	WHEN c.calltype = 2 then 'Verification'
        	WHEN c.calltype = 3 then 'Inbound'
        	WHEN c.calltype = 4 then 'Manual'
        	WHEN c.calltype = 5 then 'OutboundPreview'
        	WHEN c.calltype = 6 then 'VHQ'
        	WHEN c.calltype = 7 then 'InboundEmail'
        	WHEN c.calltype = 11 then 'Edit'
        	WHEN c.calltype = 12 then 'ManualEmail'
        	WHEN c.calltype = 13 then 'OutboundEmail'
        	end Call_Type,
        c.DNIS,
        c.DateOfCall, c.DNISCategoryFK, d.DNISCategoryName, d.DNISCategoryName MediaCategoryName,
        c.CallSentToAgentTime, c.PoolFK,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		then c.ContactNumberFK
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		then c.ContactNumberFK
        	when c.ProjectType = 3
        		then em.ContactEmailFK
        end as ContactNumberFK,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then RTRIM(LTRIM(i.Name))
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then RTRIM(LTRIM(p.Name))
        	when c.ProjectType = 3
        		and e.Name is not null then RTRIM(LTRIM(e.Name))
        end as ProjectName,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DatabaseName
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DatabaseName
        	when c.ProjectType = 3
        		and e.Name is not null then e.DatabaseName
        end as DatabaseName,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DBType
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DBType
        	when c.ProjectType = 3
        		and e.Name is not null then e.DatabaseType
        end as DBType,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DatabaseServer
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DatabaseServer
        	when c.ProjectType = 3
        		and e.Name is not null then e.DatabaseServer
        end as DatabaseServer,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DBUserID
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DBUserName
        	when c.ProjectType = 3
        		and e.Name is not null then e.DBUserID
        end as DBUserName,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DBPassword
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DBPassword
        	when c.ProjectType = 3
        		and e.Name is not null then e.DBPassword
        end as DBPassword,
        case
        	when (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0))
        		and i.Name is not null then i.DBUsesWindows
        	when (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0))
        		and p.Name is not null then p.DBUseWindowsSecurity
        	when c.ProjectType = 3
        		and e.Name is not null then e.DBUsesWindows
        end as DBUseWindowsSecurity,
        c.MorePhoneNumbers as More_Phone_Numbers,OutOfHours,
        c.CallLine,c.CallWasTransferred,c.OverflowGroupFK,c.RecordingFileName,
        q.name as CallList,c.query_id,c.ContactNumber,c.AutoAttendant,c.ExitState,
        m.CountAsContact,
        c.FinalDisposition,c.AppointmentID,c.AgentActionID,c.EmailFK,c.ProjectType,
        em.PKEmail,
        em.MailboxFK, eb.Name as MailBoxName,
        em.FromAddress,em.ReplyToAddress,em.ToAddress,
        em.CCAddress,em.Received,em.Header,em.Subject,em.Body,em.Mime,
        em.ParentEmailFK,em.ContactEmailFK,em.Incoming,em.Priority,
        em.Status,
        case em.Status
        	WHEN 0 THEN 'QUEUE'
        	WHEN 1 THEN 'RECEIVED_BY_AGENT'
        	WHEN 2 THEN 'HANDLED_BY_AGENT'
        	WHEN 3 THEN 'WAITING_TO_SEND'
        	WHEN 4 THEN 'SENT'
        end StatusText,
        /*versioninfo*/'2007.4.1.10' as Version/*versioninfoend*/,
        c.callaccount,
        cc.comment,
        cc.PKComment,
        cc.bloomenrollmentguid,
        cc.BloomNoSaleGUID,
        m.CountAsSale,
        cc.BloomCallID,
        c.CommentFK,
        current_timestamp as refresh_timestamp
        from prod.integrated_ccs.CallResults c
        LEFT JOIN prod.integrated_ccs.Pools p on (c.ProjectType = 2 or (c.ProjectType is null and c.PoolFK > 0)) and c.PoolFK = p.PKPool
        LEFT JOIN prod.integrated_ccs.InboundConfiguration i on (c.ProjectType = 1 or (c.ProjectType is null and c.PoolFK < 0)) and c.PoolFK = i.PKInboundConfiguration
        LEFT JOIN prod.integrated_ccs.EmailProjects e on c.ProjectType = 3 and c.PoolFK = e.PKEmailProject
        LEFT JOIN prod.integrated_ccs.CallResultCodes m on c.AgentExitCode = m.CallResultCode
        LEFT JOIN prod.integrated_ccs.Users u on c.AgentFK = u.PKUsers
        LEFT JOIN prod.integrated_ccs.DNISCategory d on c.DNISCategoryFK = d.PKDNISCategory
        LEFT JOIN prod.integrated_ccs.Queries q on c.query_id = q.PKQueries
        LEFT JOIN prod.integrated_ccs.Emails em on c.EmailFK is not null and c.ProjectType = 3 and c.EmailFK = em.PKEmail
        LEFT JOIN prod.integrated_ccs.EmailBoxes eb ON c.EmailFK is not null and c.ProjectType = 3 and em.MailBoxFK = eb.PKMailBox
        LEFT JOIN prod.integrated_ccs.CallComments cc ON c.commentfk = cc.pkcomment
        where date(c.callstarttime) >= current_date - 3;"""

    step2_sql_to_run = """delete from dm_analytics.ccs_enrollments_raw where date(dateofcall) >= current_date - 3;
        insert into dm_analytics.ccs_enrollments_raw
            SELECT distinct
               be.ContactInfoFK AS CallAccount,
               be.EnrollmentID,
               bp.PlanName,
               bcs.DateOfCall,
               bcs.ProjectName,
               bcs.Name AS AgentName,
               bcs.AgentFK,
               bcs.ContactNumber,
               bcs.DatabaseName,
               REPLACE(bcs.databasename, 'CS_', '') AS Client,
               bcs.callresultcode,
               bcs.CallResultDescription,
               COALESCE(be.ProposedEffectiveDate,
                   case when
                   CASE
                        WHEN planeffectivedate ~ '^\\d{4}-\\d{2}-\\d{2}$' THEN TO_DATE(planeffectivedate, 'YYYY-MM-DD') -- Format: yyyy-mm-dd
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}/\\d{4}$' THEN TO_DATE(planeffectivedate, 'MM/DD/YYYY') -- Format: m/d/yyyy or mm/dd/yyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}\\d{1,2}/\\d{4}$' THEN TO_DATE(planeffectivedate, 'MMDD/YYYY') -- Format: mmdd/yyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}\\d{4}$' THEN TO_DATE(planeffectivedate, 'MM/DDYYYY') -- Format: mm/ddyyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}/\\d{2}$' THEN TO_DATE(planeffectivedate, 'MM/DD/YY')  -- Format: mm/ddyyyy
                        WHEN planeffectivedate ~ '^\\d{8}$' THEN TO_DATE(planeffectivedate, 'MMDDYYYY')  -- Format: mm/ddyyyy
                        ELSE NULL -- If the format doesn't match, return NULL
                    END between '1997-01-01' and current_date + interval '1' year
                   then
                   CASE
                        WHEN planeffectivedate ~ '^\\d{4}-\\d{2}-\\d{2}$' THEN TO_DATE(planeffectivedate, 'YYYY-MM-DD') -- Format: yyyy-mm-dd
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}/\\d{4}$' THEN TO_DATE(planeffectivedate, 'MM/DD/YYYY') -- Format: m/d/yyyy or mm/dd/yyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}\\d{1,2}/\\d{4}$' THEN TO_DATE(planeffectivedate, 'MMDD/YYYY') -- Format: mmdd/yyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}\\d{4}$' THEN TO_DATE(planeffectivedate, 'MM/DDYYYY') -- Format: mm/ddyyyy
                        WHEN planeffectivedate ~ '^\\d{1,2}/\\d{1,2}/\\d{2}$' THEN TO_DATE(planeffectivedate, 'MM/DD/YY')  -- Format: MM/DD/YY
                        WHEN planeffectivedate ~ '^\\d{8}$' THEN TO_DATE(planeffectivedate, 'MMDDYYYY')  -- Format: MMDDYYYY
                        ELSE NULL -- If the format doesn't match, return NULL
                    END
                    else null end)::date AS ProposedEffectiveDate,
               be.EnrollmentType,
               be.NewEnrollPlanChange,
               current_timestamp,
               false as both_aqe_and_ccs_enrollment,
               bloomenrollmentid
        FROM integrated_ccs.bloom_vwcallstats bcs
            JOIN integrated_ccs.bloomenrollment be
                ON bcs.BloomEnrollmentGUID = be.BloomEnrollmentGUID
            LEFT JOIN integrated_ccs.BloomPlan bp
                ON be.PlanFK = bp.PKPlan
        WHERE bcs.AgentFK NOT IN ( 971, 1511, 1052, 2454 ) --- Conditions to exclude older data
        AND bcs.CallResultDescription NOT LIKE '%Test%' -- Exclude Test Calls;
        and date(bcs.dateofcall) >= current_date - 3;"""

    step3_sql_to_run = """delete from dm_analytics.aqe_enrollments_raw where planyear >= 2025;
        insert into dm_analytics.aqe_enrollments_raw
            SELECT distinct
               c.carrierid,
               c.name AS CarrierName,
               e.enrollmentid,
               e.confirmationid,
               e.startdate,
               e.enrollmentdate,
               e.startdate AT TIME ZONE 'UTC' AT TIME ZONE 'US/Eastern' AS eststartdate,
               e.planyear,
               e.applicationtype AS ApplicationTypeId,
               CASE e.applicationtype
                   WHEN 1 THEN
                       'Paper Enrollment'
                   WHEN 2 THEN
                       'Call Center Agent'
                   WHEN 3 THEN
               (CASE
                    WHEN SFS.partialapplicationid IS NOT NULL THEN
                        'Agent - SFS'
                    WHEN QQ.confirmationid IS NOT NULL
                         AND QQ.partialapplicationid IS NULL THEN
                        'Agent - QQ'
                    WHEN e.agenturl IS NOT NULL THEN
                        'Agent - PURL'
                    ELSE
                        'Consumer'
                END
               )
                   WHEN 5 THEN
                       'Field Agent'
                   WHEN 6 THEN
                       'Agent - Rate'
                   WHEN 7 THEN
                       'Offline Application'
                   WHEN 8 THEN
                       'Telesales Agent'
                   ELSE
                       'Consumer'
               END AS ApplicationType,
               e.agentnpn,
               e.userid AS AscendUserId,
               e.agentfirstname,
               e.agentlastname,
               e.agentemail,
               e.agenturl AS AgentPURL,
               e.beid AS BusinessEntityId,
               e.requestedeffectivedate,
               CI.city,
               CI.county,
               CI.state,
               CI.zipcode,
               pl.planid AS AQEPlanID,
               pl.contract,
               RIGHT('000' + pl.pbp_id, 3) AS PbP,
               RIGHT('000' + pl.segment_id, 3) AS Segment,
               pl.name AS PlanName,
               CASE
                   WHEN CHARINDEX('(', pl.name) > 0 THEN
                       SUBSTRING(pl.name, CHARINDEX('(', pl.name) + 1, CHARINDEX(')', pl.name) - CHARINDEX('(', pl.name) - 1)
                   ELSE
                       PT.plantypedescription
               END AS PlanType,
               PRT.name AS ProductType,
               pay.payerid,
               pay.payername,
               current_timestamp,
               false as both_aqe_and_ccs_enrollment
        FROM integrated_aqe.enrollment e
            JOIN integrated_aqe.enrollmentpersonmap epm
                ON e.enrollmentid = epm.enrollmentid
                   AND e.carrier_id = epm.carrier_id
            JOIN integrated_aqe.person p
                ON epm.personid = p.personid
                   AND epm.carrier_id = p.carrier_id
                   AND persontypeid = 1
            JOIN integrated_aqe.personcontactinfomap PCI
                ON PCI.personid = p.personid
                   AND PCI.carrier_id = p.carrier_id
                   AND contactinfotypeid = 1
            JOIN integrated_aqe.contactinfo CI
                ON CI.contactinfoid = PCI.contactinfoid
                   AND PCI.carrier_id = CI.carrier_id
            JOIN integrated_aqe.plans pl
                ON e.planid = pl.planid
                   AND e.carrier_id = pl.carrier_id
            JOIN integrated_aqe.carrier c
                ON e.carrier_id = c.carrierid
            JOIN integrated_aqe.product pr
                ON pl.productid = pr.productid
            JOIN integrated_aqe.producttype PRT
                ON PRT.producttypeid = pr.producttypeid
            JOIN integrated_aqe.plantype PT
                ON PT.plantypeid = pl.plantype
            JOIN integrated_aqe.payer pay
                ON pay.payerid = pr.payerid
            LEFT JOIN integrated_aqe.partialapplications PA
                ON PA.enrollmentid = e.enrollmentid
                   AND PA.carrier_id = e.carrier_id
            LEFT JOIN integrated_aqe.quickquote SFS
                ON SFS.partialapplicationid = PA.partialapplicationid
                   AND SFS.carrier_id = PA.carrier_id
            LEFT JOIN integrated_aqe.quickquote QQ
                ON QQ.confirmationid = e.confirmationid
                   AND QQ.carrier_id = e.carrier_id
        where e.planyear >= 2025;"""

    step4_sql_to_run = """update dm_analytics.aqe_enrollments_raw
            set both_aqe_and_ccs_enrollment = false
            where both_aqe_and_ccs_enrollment = true;
            update dm_analytics.ccs_enrollments_raw
            set both_aqe_and_ccs_enrollment = false
            where both_aqe_and_ccs_enrollment = true;
            with duplicates as (select aqe.enrollmentid,
                   aqe.confirmationid,
                   aqe.carriername,
                   aqe.enrollmentdate,
                   aqe.agentfirstname,
                   aqe.agentlastname
            from dm_analytics.aqe_enrollments_raw aqe
                join dm_analytics.ccs_enrollments_raw ccs on aqe.confirmationid = ccs.enrollmentid
                    and left(lower(replace(aqe.carriername, ' ', '')), 9) = left(lower(replace(case when ccs.client = 'Enhance' then 'Focused Health' else ccs.client end, ' ', '')), 9)
            where carriername in ('Paramount', 'ZingHealth', 'Focused Health', 'Peak Health'))
            update dm_analytics.aqe_enrollments_raw
            set both_aqe_and_ccs_enrollment = true
            from duplicates d
            where aqe_enrollments_raw.carriername = d.carriername
                and aqe_enrollments_raw.confirmationid = d.confirmationid
                and aqe_enrollments_raw.enrollmentdate = d.enrollmentdate;
                with duplicates as (select
                   ccs.enrollmentid,
                   ccs.dateofcall,
                   ccs.agentname,
                   ccs.client
            from dm_analytics.aqe_enrollments_raw aqe
                join dm_analytics.ccs_enrollments_raw ccs on aqe.confirmationid = ccs.enrollmentid
                    and left(lower(replace(aqe.carriername, ' ', '')), 9) = left(lower(replace(case when ccs.client = 'Enhance' then 'Focused Health' else ccs.client end, ' ', '')), 9)
            where carriername in ('Paramount', 'ZingHealth', 'Focused Health', 'Peak Health'))
            update dm_analytics.ccs_enrollments_raw
            set both_aqe_and_ccs_enrollment = true
            from duplicates d
            where ccs_enrollments_raw.client = d.client
                and ccs_enrollments_raw.enrollmentid = d.enrollmentid
                and ccs_enrollments_raw.dateofcall = d.dateofcall;"""

    step5_sql_to_run = """update dm_analytics.ccs_enrollments_raw
            set ccs_duplicate_flag = false
            where ccs_duplicate_flag = true;
            with keep_doc as (select enrollmentid, bloomenrollmentid, count(*), min(dateofcall) as keep_dateofcall
                from dm_analytics.ccs_enrollments_raw
                group by 1,2
                having count(*) > 1)
            update dm_analytics.ccs_enrollments_raw
                set ccs_duplicate_flag = true
            from keep_doc k
            where ccs_enrollments_raw.enrollmentid = k.enrollmentid and ccs_enrollments_raw.bloomenrollmentid = k.bloomenrollmentid
                and ccs_enrollments_raw.dateofcall != k.keep_dateofcall;"""

    logger.info(
        "Running step 1 of enrollment dm build:  integrated_ccs.bloom_vwcallstats"
    )
    rs_cursor.execute(step1_sql_to_run)
    rs_conn.commit()

    logger.info(
        "Running step 2 of enrollment dm build:  dm_analytics.ccs_enrollments_raw"
    )
    rs_cursor.execute(step2_sql_to_run)
    rs_conn.commit()

    logger.info(
        "Running step 3 of enrollment dm build:  dm_analytics.aqe_enrollments_raw"
    )
    rs_cursor.execute(step3_sql_to_run)
    rs_conn.commit()

    logger.info("Running step 4 of enrollment dm build:  set duplication flag")
    rs_cursor.execute(step4_sql_to_run)
    rs_conn.commit()

    logger.info("Running step 5 of enrollment dm build:  set ccs duplication flag")
    rs_cursor.execute(step5_sql_to_run)
    rs_conn.commit()

    rs_conn.close()

    logger.info("Job Complete")

except Exception as error:

    # If connections open, rollback and close
    if rs_conn:
        rs_conn.rollback()
        rs_cursor.close()
        rs_conn.close()
        logger.error("Redshift connection is closed")

    # Send ERROR notification to SNS topic
    error_email_subject = "DW Source Copy data process error"
    error_message_to_send = "Exception occurred in: analytics_dm_builder glue job"
    sns_topic = "arn:aws:sns:us-west-2:511539536780:Glue-Error-Messages"
    msg_id = publish_message(sns_topic, error_message_to_send, error_email_subject)

    logger.error(f"Error: {error}")
