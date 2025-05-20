INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select dispositiontypeid, code, description, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###   with (nolock)', 'tsaxen', '2025-03-07 14:32:16.823234', 'tsaxen', '2025-03-07 14:32:16.823234', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select leadviewid, beid, name, [rule], xmlrule, description, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###   with (nolock)', 'tsaxen', '2025-03-07 14:54:34.144502', 'tsaxen', '2025-03-07 14:54:34.144502', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, clientname, reportname, toemailaddress, ccemailaddress, bccemailaddress, replytoemailaddress,
       includereport, renderformat, priority, subject, comment, includelink, isactive, dateintervalfk,
       datecreated, requestername, notes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 16:47:52.279238', 'tsaxen', '2025-02-14 16:47:52.279238', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select id, permissiondescription, isactive, audituserid, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 15:13:22.702498', 'tsaxen', '2025-03-07 15:13:22.702498', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select phonetypeid, phonetypename, beid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 15:15:38.922680', 'tsaxen', '2025-03-07 15:15:38.922680', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkratecallforwardingid, callforwardvalue, isdeleted,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 15:24:27.819998', 'tsaxen', '2025-03-07 15:24:27.819998', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select attributetypeid, name, description, platformtypeid, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 17:06:27.569493', 'tsaxen', '2025-03-07 17:06:27.569493', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkbloomclientid, name, hostname, logopath, csspath, databasename, isactive, auditusername, isvbe, sendgrid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 19:44:29.148805', 'tsaxen', '2025-03-04 19:44:29.148805', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkcarrier, carriername, isdeleted, carriershortname, auditusername, bloomclientid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 19:47:25.471924', 'tsaxen', '2025-03-04 19:47:25.471924', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkareacodestatemapping, areacode, region,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:18:25.540975', 'tsaxen', '2025-03-04 20:18:25.540975', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        hrainformationstatushistoryid, hrainformationid, hrastatusid, statusupdatedate, ascenduserid, buttonid, actionid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 21:39:05.808450', 'tsaxen', '2025-02-19 21:39:05.808450', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select elementtypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 17:24:10.688308', 'tsaxen', '2025-03-07 17:24:10.688308', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select errortypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 17:27:36.542124', 'tsaxen', '2025-03-07 17:27:36.542124', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select formtypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 17:29:09.337702', 'tsaxen', '2025-03-07 17:29:09.337702', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select featureid, feature, description, isactive, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:09:17.250549', 'tsaxen', '2025-03-06 16:09:17.250549', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select businessentityparameterid, beid, pwdage, tokenage, pwdrepeat, loginattempts, logindelayminutes, imagelocation,
               armimagelocation, maplogo, left(disclaimer, 8000) + \'...\' as disclaimer, documentcount, maxdevicerecordings, availabilitytimeout, maxradius,
               distributionpattern, apppath, winapppath, appbundleid, servicecontactid_fk, backupservicecontactid_fk, quoteurl,
               enrollmenturl, sendgridapikey, left(emaildisclaimer, 8000) + \'...\' as emaildisclaimer, sendgridemailaddress, emailname, emailaddress, left(emailbody, 8000) + \'...\' as emailbody, emailsubject,
               twiliosmsnumber, twiliotextbody, notes, audituserid, s3region, null as s3secret, null as s3accesskey, s3bucketname,
               isparticipatinginsalesforce, clientid, clientsecret, salesforceusername, salesforcepassword, fein, nipraccountid,
               niprpaymentcodeid, aqeimagepath, use2fa, registrationemailid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 18:22:18.448992', 'tsaxen', '2025-03-06 18:22:18.448992', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select poolsfk, queriesfk, loadfactor,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:34:59.124349', 'tsaxen', '2025-02-12 20:34:59.124349', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select applicationstatusid, applicationstatusdescription,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:16:44.469400', 'tsaxen', '2025-02-14 19:16:44.469400', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select applicationtypeid, name, description, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:31:40.113370', 'tsaxen', '2025-02-14 19:31:40.113370', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select awvstatuscodeid, name, description, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:34:59.512445', 'tsaxen', '2025-02-14 19:34:59.512445', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ascendisfid, beid, isfcarrierid, isfcarriername, notes, audituserid, isdeleted,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:42:25.371406', 'tsaxen', '2025-03-06 16:42:25.371406', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select loginattemptsid, loginattempts, userid, counter, dateentered, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:45:16.210284', 'tsaxen', '2025-03-06 16:45:16.210284', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, zipcode, county, countyfips, state, statefips, timezone, daylightsaving,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:50:32.453350', 'tsaxen', '2025-03-06 16:50:32.453350', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select roleid, code, name, notes, audituserid, permissions as role_permissions,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:57:03.494406', 'tsaxen', '2025-03-06 16:57:03.494406', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select groupsid, code, description, groupdescription, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 17:00:24.690456', 'tsaxen', '2025-03-06 17:00:24.690456', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select usersessionid, userid, clientid, sessionstartdatetime, sessionenddatetime, useragent, buildversion, osversion,
       ipaddress, iscellular, iswifi, devicetype, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 17:05:45.176726', 'tsaxen', '2025-03-06 17:05:45.176726', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        regionlocationid, regionid, state, statefipscode, county, countyfipscode, zipcode, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 14:22:50.931668', 'tsaxen', '2025-03-10 14:22:50.931668', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        dynamoaqeformmapid, dynamoformid, aqecarrierid, aqefromid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 14:34:39.259409', 'tsaxen', '2025-03-10 14:34:39.259409', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select contacttypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 17:11:05.887793', 'tsaxen', '2025-03-07 17:11:05.887793', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select businessentityusermapid, carrierid, businessentityid, userid, userstatus, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###   with (nolock)', 'tsaxen', '2025-03-07 14:29:00.376999', 'tsaxen', '2025-03-07 14:29:00.376999', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select languagesid, code, description, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###   with (nolock)', 'tsaxen', '2025-03-07 14:34:27.334396', 'tsaxen', '2025-03-07 14:34:27.334396', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        availableid, beid, userid, startdatetime, enddatetime, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 14:49:20.696552', 'tsaxen', '2025-03-10 14:49:20.696552', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        efr.meetingtoleadmapid, efr.beid, efr.meetingid, efr.leadid, efr.scopeofappointmentid, efr.bloomclientid, efr.datetimeofmeeting, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Meetings e with (nolock) on efr.meetingid = e.meetinghistoryid', 'tsaxen', '2025-03-10 14:56:04.858780', 'tsaxen', '2025-03-10 14:56:04.858780', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkroutebyoutboundivr, projectfk, fromnumber, twilioaccountsid, twilioauthtoken, delay, maxperrun, isactive,
               timeout, useamd, amdtimeout, amdspeechthreshold, amdspeechendthreshold, amdsilencetimeout, inserteddate,
               validfrom, validto, callstarttime, callendtime, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 14:48:16.207666', 'tsaxen', '2025-03-25 14:48:16.207666', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select vbeactionid, vbeactionname, vbeactiondescription, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:52:58.287214', 'tsaxen', '2025-02-14 19:52:58.287214', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select vbestatuscodeid, name, description, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:55:10.616406', 'tsaxen', '2025-02-14 19:55:10.616406', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select id, pookfk, reportname, begdate, enddate, dayofweek, beghour, endhour, isdeleted, auditusername, notes, isarchived,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 22:33:48.028245', 'tsaxen', '2025-02-12 22:33:48.028245', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select contactinfotypeid, type, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 20:15:19.296502', 'tsaxen', '2025-02-14 20:15:19.296502', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkprojectworkflow, projectfk, outreachlistfk, ordinal, isactive, outreachtypefk, timesincelastoutreach,
               inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 14:54:45.728122', 'tsaxen', '2025-03-25 14:54:45.728122', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkoutreachtype, outreachtype, isactive, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 14:56:46.586248', 'tsaxen', '2025-03-25 14:56:46.586248', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkemailbyoutreachattempt, routebyemailfk, twiliolanguagefk, left(emailbody, 10000) + \'...\' as emailbody, fromaddress, fromname, subject, 
               outreachattempt, isactive, contenttypefk, miscnotes, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 14:57:44.928251', 'tsaxen', '2025-03-25 14:57:44.928251', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select persontypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 19:27:05.893706', 'tsaxen', '2025-03-07 19:27:05.893706', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        regionid, beid, regionname, isdeleted, updateinaqe, aqesalesregionid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 18:45:46.449309', 'tsaxen', '2025-03-10 18:45:46.449309', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        dispositiontypemapid, businessentityid, typeid, dispositionid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 18:57:03.530499', 'tsaxen', '2025-03-10 18:57:03.530499', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        userdetailsid, userid, beid, primaryphone, officephone, homephone, mobilephone, fax, address, city,
               state, zipcode, extusername, extpassword, useenrollurl, leadgeneration, skilllevel, userurl, userate,
               enrollmentphone, contactnumbersid, natpronum, notes, audituserid, ratecallforwardingid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 19:13:55.648890', 'tsaxen', '2025-03-10 19:13:55.648890', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkcarriermapping, carriergroupfk, carrierfk, isdeleted, auditusername,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:53:53.711151', 'tsaxen', '2025-03-04 20:53:53.711151', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select callbackfk, contactnumber, callbackdatetime, stationid, contactnumberfk, contactinfofk, poolfk, comments,
       userfk, agentgroupfk, voicememopath, listsourcefk, queryfk, callbacktype,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:43:13.464838', 'tsaxen', '2025-02-12 21:43:13.464838', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select persontypeid, type, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 21:29:38.807837', 'tsaxen', '2025-02-14 21:29:38.807837', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select rtsplantypeid, rtsplantypename, producttypeid, isdeleted, miscnotes, systemuser_createdby, systemuser_updatedby, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 21:46:12.138774', 'tsaxen', '2025-02-14 21:46:12.138774', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
   carrierid, name, databaseserver, databasename, dbconnectionstring,
       emailaddress, emailname, bestigebaseurl, miscnotes, isdeleted,
       ismultitenant, isdeletedforreporting,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-28 21:47:53.306522', 'tsaxen', '2025-01-28 21:47:53.306522', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        wiproid, txndate, mbdloadeffdate, requesthicnbr, requestlastname, requestdob, foundhicnbr, foundnameordob, inquiryresponse,
                 hicnbr, lastname, firstname, middleinitial, gendercd, racecd, birthdate, prtaentitlementdate, prtaentitleenddate,
                 prtbentitlementdate, prtbentitleenddate, statecd, countycd, hospicestatus, hospicestartdate, hospiceenddate, inststatus,
                 inststartdate, instenddate, esrdstatus, esrdstartdate, esrdenddate, medicaidstatus, medicaidstartdate, medicaidenddate,
                 eghpind, livingstatus, deathdate, xrefhicnbr, potentialuncvrdmths, potentialuncvrdmthseffdate, prtdeligibledate, planyear,
                 miscnotes, wiprojson,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-03 15:51:08.393938', 'tsaxen', '2025-03-03 15:51:08.393938', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkinboundconfiguration, dnis, name, dniscategoryfk, dbtype, databasename, databaseserver, dbuserid, dbpassword, dbuseswindows,
       greetingmessage, holdmessage, intermittentmessage, intermittentinterval, notavailablemessage, noagentsloggedinmessage,
       overflowgroupfk, scriptsfk, starttime, stoptime, daysmap, isrunning, lookuppage, verificationscriptfk, manualdialscriptfk,
       callbackscriptfk, autocreaterecord, playstatsaftergreeting, playstatsperiodically, overflowivr, anitosend, companyname,
       ringsbeforeanswer, voicemailboxfk, busyonslabreach, deliverystrategy, beforeconnecttoagentmessage,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:42:03.432335', 'tsaxen', '2025-02-12 20:42:03.432335', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select platformtypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 19:28:32.536750', 'tsaxen', '2025-03-07 19:28:32.536750', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select statustypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 19:29:44.602098', 'tsaxen', '2025-03-07 19:29:44.602098', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select sessionpropertytypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-07 19:32:15.011905', 'tsaxen', '2025-03-07 19:32:15.011905', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkivrbyoutreachattempt, routebyoutboundivrfk, authtext, caregiverauthtext, authtext2, authtext3, authtext4, 
               caregiverauthtext2, caregiverauthtext3, caregiverauthtext4, introtext, wrongpartytext, notgoodtimetext, 
               authtext2failed, authtext3failed, authtext4failed, authcomplete, answeringmachinemessage, inboundintro1, 
               inboundintro2, inboundauth1, inboundauth2, inboundauth2failed, inboundauth3, inboundauth4, inboundcaregiverauth1,
               inboundcaregiverauth2, inboundcaregiverauth3, inboundcaregiverauth4, inboundauthcomplete, inboundcaregiverauthcomplete,
               inboundauthfailterminate, outreachattempt, isactive, twiliolanguagefk, contenttypefk, miscnotes, inserteddate,
               validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:01:28.928392', 'tsaxen', '2025-03-25 16:01:28.928392', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        userqueuemapid, userid, leadqueueid, beid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 19:36:13.089115', 'tsaxen', '2025-03-10 19:36:13.089115', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       hvv2appointmentmeetingmapid, hvv2appointmentid, meetinghistoryid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 19:42:39.728030', 'tsaxen', '2025-03-10 19:42:39.728030', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       roleid, carrierid, businessentityid, code, name, notes, audituserid, isactive, permissions as permission,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 19:48:14.208617', 'tsaxen', '2025-03-10 19:48:14.208617', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       hvv2appointmentscopemapid, hvv2appointmentid, scopeofappointmentid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 20:04:36.769508', 'tsaxen', '2025-03-10 20:04:36.769508', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      eventid, eventtypeid, beid, eventstartdatetime, eventdurationid, eventstatusid, eventcreatedate,
               isdeleted, ascendbaseeventid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 20:13:06.702760', 'tsaxen', '2025-03-10 20:13:06.702760', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pksmsbyoutreachattempt, routebysmsfk, twiliolanguagefk, smstext, outreachattempt, isactive, contenttypefk,
               miscnotes, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:13:03.878774', 'tsaxen', '2025-03-25 16:13:03.878774', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkoutreachlist, projectfk, outreachtypefk, outreachlistname, memberslistsqlquery, memberslistsqlstruct,
               lastrefreshdatetime, isactive, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:18:03.153831', 'tsaxen', '2025-03-25 16:18:03.153831', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkroute, projectfk, outreachtypefk, isactive, lastrundatetime, timebetweenruns, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:22:53.328123', 'tsaxen', '2025-03-25 16:22:53.328123', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select holidaycalenderid, poolfk, holidaydate, isdeleted, auditusername, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 22:50:55.358046', 'tsaxen', '2025-02-12 22:50:55.358046', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkpool, name, databasename, dbtype, databaseserver, dbusername, dbpassword, dbusewindowssecurity, isactive,
       isopen, isrunning, outboundscriptfk, verificationscriptfk, manualdialscriptfk, callbackscriptfk, anitosend,
       bypassmdnc, starttime, stoptime, daysmap, companyname, idleonexhaust, ispaused,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:28:16.191600', 'tsaxen', '2025-02-12 20:28:16.191600', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkcomment, comment, appt_id, verify, updated, origagentexitcode, enrollment_id, call_id, enrollmenturi,
               verification_id, plantypename, enrollment_id_2, plantypename_2, enrollmenturi_2, verificationid_2,
               twoproduct, confirmation_id, bloomenrollmentguid, bloomnosaleguid, vns_ezrefcode, soa_id, bloomcallid,
               issuestatus, clientreferenceid, ivr_id, issue_tracking_id, fkgenericnotesid, hmoid,
               hapmailfulfillmenthistoryid, pcpinfoid, hraresponseid, ascendhelpdeskguid,
               advisemailfulfillmenthistoryid, marketguid, permissiontocontact, advisefollowupguid,
               advisefollowupemailid, ptcfk, tcpafk, cmsguid, rsvp_eventfk, safesellsoaconfirmation,
               safesellattestconfirmation, safesellfk, gh_permissiontocontactfk, zinghealth_permissiontocontactfk,
               paramount_permissiontocontactfk, cncdemographicupdated, cncinterviewagreement,
               aetnaagentengage_calllistfk, aetnaagentengage_ae_namefk, zinghealth_cmsguid,
               paramountvbe_confirmedplanid, bcbsmailfulfillmenthistoryid, centenepso_ae_appointmentrecordfk,
               callactions, hcscsmallgroupsales_referralsourcefk, ehealth_ehealthappinfofk,
               fk_focusedhealthdl_commentid, fk_focusedhealthxsell_commentid, clearspringsha_confirmedplanid,
               focusedhealthha_confirmedplanid, clearspringsales_commentid, aetnama_commentid,
               medicalmutualma_commentid, medicalmutualhve_membercomplaintid, healthfirst_transfercustomerid,
               ascendbrokerhelpdesk_helpdeskissueid, zinghealthha_confirmedplanid, zinghealthha_pcpinfoid,MMOHVE_PCPInfoID,
HF_VerifyMarxID, current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-10 19:49:17.975461', 'tsaxen', '2025-02-10 19:49:17.975461', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select calltype_id, calldirection, callshortdirection,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:18:45.671018', 'tsaxen', '2025-02-12 21:18:45.671018', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, clientname, reportname, filename, filesharepath, includereport, renderformat, fileextension,
       isactive, dateintervalfk, datecreated, requestername, notes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 18:36:35.970883', 'tsaxen', '2025-02-14 18:36:35.970883', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, clientname, reportname, toemailaddress, ccemailaddress, bccemailaddress, replytoemailaddress, includereport,
       renderformat, priority, subject, comment, includelink, isactive, dateintervalfk, datecreated, requestername,
       notes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 19:12:39.728535', 'tsaxen', '2025-03-04 19:12:39.728535', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select sourceid, leadsource, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 15:46:33.335749', 'tsaxen', '2025-03-06 15:46:33.335749', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      sfcustomprospectdataid, prospectid, salesforceid, columnname, datatype, value, datecreated, datemodified, audituserid, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 20:54:48.972402', 'tsaxen', '2025-03-10 20:54:48.972402', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      accesstypeid, beid, accesstype, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 21:00:38.376049', 'tsaxen', '2025-03-10 21:00:38.376049', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkroutebyemail, projectfk, sendgridapikey, delay, maxperrun, isactive, minvalidationscore,
               sendgridvalidationapikey, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:25:39.646336', 'tsaxen', '2025-03-25 16:25:39.646336', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkproject, projectname, isactive, carrierfk, maxattempts, maxsmsattempts, maxemailattempts, maxivrattempts, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:29:13.568854', 'tsaxen', '2025-03-25 16:29:13.568854', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkroutebysms, projectfk, fromnumber, twilioaccountsid, twilioauthtoken, delay, maxperrun, isactive, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 16:32:07.568780', 'tsaxen', '2025-03-25 16:32:07.568780', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select dispcategorymapid, poolfk, callresultcode, dispcategoryid, sortorder, isdeleted,
       countaseligible, seminar, homevisit, agentconnect, mailinfo, dnc, followup, statscategoryid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-10 15:08:30.475688', 'tsaxen', '2025-02-10 15:08:30.475688', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    efr.enrollmentprovidermapid, efr.enrollmentid, efr.clientlocationidentifier, efr.npi, efr.isapplicantpcp, efr.specialization,
               replace(efr.firstname, \'\\\', \'\'), replace(efr.lastname, \'\\\', \'\'), efr.locationname, efr.street1, efr.street2, efr.city, efr.state, efr.zip, efr.phonenumber, efr.groupname,
               efr.currentpatient, efr.innetwork, efr.miscnotes, efr.zelisproviderenrollmentid, efr.pcpselectedbybeneficiary,
               efr.isprovidermanuallyentered,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-01-31 19:39:12.183650', 'tsaxen', '2025-01-31 19:39:12.183650', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.enrollmentwiproid, efr.enrollmentid, efr.wiproid, efr.date, efr.planyear, efr.miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-17 22:42:11.047792', 'tsaxen', '2025-02-17 22:42:11.047792', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.quickquoteplanmapid, efr.quickquoteid, efr.planid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.[Plan] e with (nolock) on efr.PlanId = e.PlanId', 'tsaxen', '2025-02-18 22:56:09.583046', 'tsaxen', '2025-02-18 22:56:09.583046', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
        carrierbepayermap, carrierid, beid, payerid, isactive, miscnotes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-30 21:50:19.362242', 'tsaxen', '2025-01-30 21:50:19.362242', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.planrolebuttonmapid, efr.planid, efr.roleid, efr.buttonid, efr.buttonorder, efr.isdeleted, efr.miscnotes, efr.enrollmentformtypeid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.[Plan] e with (nolock) on efr.PlanId = e.PlanId', 'tsaxen', '2025-02-19 15:03:44.950874', 'tsaxen', '2025-02-19 15:03:44.950874', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.formplanregionmapid, efr.formid, efr.planid, efr.regionid, efr.planorder, efr.criteriavalueid, efr.miscnotes, efr.externalplanid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.[Plan] e with (nolock) on efr.PlanId = e.PlanId', 'tsaxen', '2025-02-18 17:13:55.451662', 'tsaxen', '2025-02-18 17:13:55.451662', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select externaldatasourcetypeid, name, description, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 20:22:17.508217', 'tsaxen', '2025-02-14 20:22:17.508217', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select twiliolanguageid, name, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 16:00:45.929820', 'tsaxen', '2025-02-17 16:00:45.929820', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select sourcesystemtypeid, sourcesystemtypedescription,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 16:04:00.817071', 'tsaxen', '2025-02-17 16:04:00.817071', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, pkagenturl, agenturlid, agentid, isdeleted, creationdate, miscnotes, beid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-07 14:46:51.944571', 'tsaxen', '2025-02-07 14:46:51.944571', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,aveinformationstatushistoryid, awvinformationid, awvstatusid,
        statusupdatedate, ascenduserid, buttonid, actionid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-07 15:32:14.414242', 'tsaxen', '2025-02-07 15:32:14.414242', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select id, help_type_code, displayorder, help_type_description,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:06:59.809169', 'tsaxen', '2025-03-06 16:06:59.809169', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, pkoutreachlistmap, outreachmemberinfofk, memberinformationfk, outreachlistfk, listsource, isactive,
               miscnotes, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 17:47:59.567888', 'tsaxen', '2025-03-25 17:47:59.567888', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select buttontypeid, type, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:40:36.756783', 'tsaxen', '2025-02-14 19:40:36.756783', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select hrastatuscodeid, name, description, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:47:09.069666', 'tsaxen', '2025-02-14 19:47:09.069666', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkpreferredmethodsofcontact, contactmethodname, isdeleted, miscnotes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 19:49:36.067152', 'tsaxen', '2025-02-14 19:49:36.067152', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
   ###REFERENCE_ID### as carrier_id,agentid,npn,isdeleted,miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-28 17:15:02.209165', 'tsaxen', '2025-01-28 17:15:02.209165', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      prospectcustomobjectid, prospectid, externalid, datecreated, datemodified, notes, audituserid,
               campaignmemberid, salesforceid, campaignmemberobject,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 21:09:37.291405', 'tsaxen', '2025-03-10 21:09:37.291405', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachccsresults, outreachmemberinfofk, memberinformationfk, ccsoutreachactivityid, contactinfofk,
                 dateofcall, pkcallresults, poolfk, contactnumber, callresultcode, callresultdescription, agentfk,
                 hrainformationid, interviewagreement, recordingfilename, fullrecordingfilepathandname,
                 excludefromreporting, miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 19:50:20.367576', 'tsaxen', '2025-02-19 19:50:20.367576', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      documentid, businessentityid, documentname, publishdate, expirydate, createddate, folderid,
               subfolderid, replacesdocumentid, documentpath, isdeleted, notes, audituserid, resourcetype,
               displayonhomescreen, passauth, action, ranking, recipientcount,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 21:24:09.808386', 'tsaxen', '2025-03-10 21:24:09.808386', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      dispositionsid, businessentityid, code, description, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-10 21:53:00.847847', 'tsaxen', '2025-03-10 21:53:00.847847', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    efr.enrollmentpharmacymapid, efr.enrollmentid, efr.pharmacynpi, efr.innetwork, efr.pharmacyname, efr.retail, efr.mailorder,
               efr.prefretail, efr.prefmailorder, efr.distance, efr.miscnotes, efr.validfrom, efr.validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-01-31 20:16:42.821033', 'tsaxen', '2025-01-31 20:16:42.821033', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, pkoutreachemailresults, outreachmemberinfofk, memberinformationfk, emailoutreachactivityid,
               emailstartdatetime, emailenddatetime, emailoutcome, inserteddate, hrainformationid, excludefromreporting,
               miscnotes, email, timestamp as oer_TimeStamp, smtpid, event, category, sg_content_type, sg_eventid, sg_message_id, response,
               attempt, useragent, ip, url, urloffset, reason, status, asm_group_id, type, validfrom, validto,
               projectfk, outreachattemptfk, outreachlistfk, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-25 18:51:15.567345', 'tsaxen', '2025-03-25 18:51:15.567345', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select enrollmentformtypeid, enrollmentformtypedescription, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 20:20:05.748548', 'tsaxen', '2025-02-14 20:20:05.748548', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        memberinformationid, firstname, lastname, middlename, phonenumber, dob, gender, address1, address2, city,
                 state, zipcode, electionperiodinfo, memberhicn, sourcesystemtypeid, sourcesystemid, clientuniqueid,
                 originalsourcefilename, originalsourcefiledate, updatesfilename, contractnumber, plancode, planid,
                 planname, planyear, dateadded, twiliolanguageid, permissiontocontactthroughphone, ptcdate,
                 permissiontocontactthroughemail, permissiontocontactthroughsms, preferredmethodofcontact, pcpfirstname,
                 pcplastname, pcpaddress1, pcpaddress2, pcpcity, pcpstate, pcpzip, pcpeffectivedate, iscallable,
                 isdeleted, isactiveforoutreach, agencyname, vbeactionid, ascenduserid, agentnpn, applicationdate,
                 vbememberid, externalauthcode, deactivateddate, deactivatedreason, alternateexternalauthcode, updateddate,
                 miscnotes, beid, ascendleadid, smsattempts, ivrattempts, emailattempts, county,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 21:03:12.862397', 'tsaxen', '2025-02-19 21:03:12.862397', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachsmsresults, outreachmemberinfofk, memberinformationfk, smsoutreachactivityid, smsstartdatetime,
                smsenddatetime, smsoutcome, smssentphonenumber, hrainformationid, excludefromreporting, miscnotes,
                account_sid, api_version, body, date_updated, direction, error_code, error_message, [from] as from_sms,
                messaging_service_sid, num_media, num_segments, price, price_unit, sid, status, [to] as to_sms, uri,
                inserteddate, validfrom, validto, projectFK, OutreachAttemptFK, OutreachListFK,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 15:46:58.208127', 'tsaxen', '2025-02-19 15:46:58.208127', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    planid, productid, name, coveragetype, plantype, contract, pbp_id, segment_id, extended_description,
       premiumdescription, premiumvalue, paymentfrequency, enrollmentactive, planorder, compareorder, planyear,
       miscnotes, enrollmentpremiumdescription, isdeleted, partialappexpiry, partialapplinkexpiry, ishraenabled,
       isawvenabled, partdpremiumvalue, premiumdisclaimertext, bestigepath, bestigeplanid, partcpremiumvalue,
       brandname, providerinoutindicatortext, isvisibleforagent, isvisibleforconsumer, excludefromcopaylvlpremiumcalc,
       isvbeenabled, confirmationpagebuttonvisibility, addmemberpagebuttonvisibility, vbesearchpagebuttonvisibility,
       isdocumentuploadavailable, isvisibleonaddmemberpage, isnewplan, rtsplantypeid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-30 22:37:01.731287', 'tsaxen', '2025-01-30 22:37:01.731287', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select licenseformfirmtypesid, firmtypeid, displayname, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 15:56:53.176303', 'tsaxen', '2025-03-06 15:56:53.176303', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select entityfeaturemapid, carrierid, beid, userid, featureid, isactive, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:04:20.059446', 'tsaxen', '2025-03-06 16:04:20.059446', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select contenttypeid, projectfk, contentname, miscnotes, inserteddate, validfrom, validto, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-26 15:27:51.088251', 'tsaxen', '2025-03-26 15:27:51.088251', 'DE-130');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkreason, logout, pause, text,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 19:24:56.151910', 'tsaxen', '2025-02-12 19:24:56.151910', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      messageid, businessentityid, publishdate, expirydate, createddate, requireack, left(messagetext, 9000) + \'...\' as messagetext, title,
               isdeleted, notes, audituserid, left(htmlformattedtext, 9000) + \'...\' as htmlformattedtext, messagereceviedby, usersacknowledged, recipientcount,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 13:07:13.648854', 'tsaxen', '2025-03-11 13:07:13.648854', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      languagesid, businessentityid, code, description, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 13:25:07.809247', 'tsaxen', '2025-03-11 13:25:07.809247', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select poolsfk, queriesfk, loadfactor, ordinal, liststate, outcomebased, targetleads, settostandby,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:15:12.571134', 'tsaxen', '2025-02-12 20:15:12.571134', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select projectfk, engineid, numberoflines,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:23:22.549869', 'tsaxen', '2025-02-12 20:23:22.549869', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkusers, name, login, null as password, issupervisor, isoutbound, isinbound, isverification, ismanualdial, isemail, skilllevel,
       userlanguage, deleted, isloggedin, playvoicemailthroughpcspeakers, voicemailgreeting, viewdeletedvoicemails, extension,
       isadminsiteaccess, voicemailboxfk, startdate, firstname, lastname, teamname, isteammanager, islicensedagent, isuambrpuser,
       uam_eeid, isbaamuser, null as salt, null as password2, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-26 19:47:01.246968', 'tsaxen', '2025-03-26 19:47:01.246968', 'DE-131');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkemailproject, name, databasetype, databasename, databaseserver, dbuserid, dbpassword, dbuseswindows, allowmanualemails,
       allowtemplatesonly, allowresponsetosender, allowcc, allowresponsetoall, allowbcc, overflowintogroupfk, fromaddress, fromdisplayname,
       autoresponseavailablefk, autoresponsenotavailablefk, outgoingserveraddress, outgoingport, outgoingencrypted, outgoingusername,
       outgoingpassword, allowmanualdial, callbacktype, isrunning, manualdialscriptfk, callbackscriptfk, anitosend, bypassmdnc,
       emailscriptfk, engineid, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-26 19:57:53.894463', 'tsaxen', '2025-03-26 19:57:53.894463', 'DE-131');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkdniscategory, dniscategoryname, deleted, clientrequested,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:12:50.490983', 'tsaxen', '2025-02-12 21:12:50.490983', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select carrierfeaturemapid, carrierid, featureid, isenabled, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 21:46:23.602187', 'tsaxen', '2025-01-31 21:46:23.602187', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select featureid, name, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 21:33:30.954300', 'tsaxen', '2025-01-31 21:33:30.954300', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select sftpcredentialid, sftpname, sftphostname, sftpusername, sftppassword, sftpport, isactive, lastmodifieddate,
       miscnotes, auditusername, sftpkeyfile,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 18:54:46.022613', 'tsaxen', '2025-03-04 18:54:46.022613', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, clientname, reportname, filename, filesharepath, includereport, renderformat, fileextension, isactive,
       dateintervalfk, datecreated, requestername, notes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 19:19:59.968066', 'tsaxen', '2025-03-04 19:19:59.968066', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.enrollmentformresponseid, efr.enrollmentid, efr.field, efr.formfieldstructureid, left(efr.value, 8000) + \'...\' as value, efr.displaytext, efr.formelementid, efr.miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-17 20:56:39.678030', 'tsaxen', '2025-02-17 20:56:39.678030', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.enrollmentformularyid, efr.enrollmentid, efr.ndc, efr.days_supply, efr.drugtier, efr.quantity,
       efr.pharmacynpi, efr.covered, efr.planpays, efr.beneficiarypays, efr.manufacturerpays,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-18 14:53:02.927257', 'tsaxen', '2025-02-18 14:53:02.927257', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.pkenrollmentleadascendcallsid, efr.enrollmentid, efr.leadascendcallid, efr.miscnotes, efr.validfrom, efr.validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-18 15:12:43.171402', 'tsaxen', '2025-02-18 15:12:43.171402', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      prospectid, beid, meetingid, firstname, middleinitial, lastname, phone, streetaddress, city, state,
               zipcode, county, email, creationmethod, leadsourceid, dateofcreation, islead, leaddate, agentid, commission,
               altexternalid, leadstatusid, isdeleted, viewed, birthdate, gender, medicareclaimnumber,
               medicarepartaeffectivedate, medicarepartbeffectivedate, lastmodifieddate, lastmodifiednotes, notes,
               audituserid, CuID, streetaddress2,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 13:39:26.961755', 'tsaxen', '2025-03-11 13:39:26.961755', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      faxnumberid, beid, tofaxnumber, description, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 14:49:29.409294', 'tsaxen', '2025-03-11 14:49:29.409294', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      zoneid, beid, zone, county, isactive, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 14:57:40.922434', 'tsaxen', '2025-03-11 14:57:40.922434', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      phonetypeid, phonetypename, beid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 15:33:27.443694', 'tsaxen', '2025-03-11 15:33:27.443694', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      groupsid, businessentityid, code, description, groupdescription, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 15:38:57.089493', 'tsaxen', '2025-03-11 15:38:57.089493', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select callresultcode, callresultdescription, statuscode, elderplancorecode, windsorcorecode, bluechoicecorecode,
       hphccorecode, avetacorecode, appttype, heritage_apfcorecode, heritage_thcorecode, heritage_ghcorecode,
       heritage_sctcorecode, heritage_tfcorecode, arcadiancorecode, todaysoptionscorecode, todaysoptions_ccrxcorecode,
       cs_uac_over65corecode, presentation, countaslead, printable, systemcode, verification, nevercall,
       addtomasterdonotcall, printpage, deleted, phonenumbernevercall, countascontact, countassale,
       countasdonotmail, countasdonotcontact, countasdeceased,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:24:51.036858', 'tsaxen', '2025-02-12 21:24:51.036858', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkagentgroups, name,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:54:53.582611', 'tsaxen', '2025-02-12 21:54:53.582611', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      hvv2appointmentid, beid, leadid, userid, startdatetime, enddatetime, durationinminutes,
               scopeofappointmentid, meetinghistoryid, notes, audituserid, hvv2scheduleid, regionid, languageid,
               isdeleted, isvirtual, meetingcode, recordingurl, agentmeetinglink, guestmeetinglink,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 15:55:58.288886', 'tsaxen', '2025-03-11 15:55:58.288886', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select statefk, statecode, statename,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 21:13:52.064656', 'tsaxen', '2025-02-14 21:13:52.064656', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        efr.enrollmentpersonmap, efr.enrollmentid, efr.personid, efr.personrelationshipid, efr.persontypeid,
       efr.providerid, efr.providertypeid, efr.premiumamount, efr.relationship, efr.miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.###SRC_SCHEMA###.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-18 15:33:59.185029', 'tsaxen', '2025-02-18 15:33:59.185029', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select bloomenrollmentid, bloomenrollmentguid, contactinfofk, enrollmentid, verificationid, enrollmenturi, planfk,
               premiumquote, paymentmethod, paymentfrequency, verificationcalldate, hicn, planid, planeffectivedate, product,
               proposedeffectivedate, enrollmenttype, caseid, enrollquoteid, validationid, binderpayment, newenrollplanchange,
               agentemail, [agentawn/npn], hcontract, pbp, segmentid, planyear, carrier, plantype, gender, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-04-01 20:58:53.151379', 'tsaxen', '2025-04-01 20:58:53.151379', 'DE-138');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      subscriptionid, businessentityid, apptid, leadid, prospectid, generalseats, isactive,
               attendedappointment, notes, audituserid, passcode,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 16:21:39.011823', 'tsaxen', '2025-03-11 16:21:39.011823', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      sourceid, businessentityid, leadsource, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 16:28:07.640221', 'tsaxen', '2025-03-11 16:28:07.640221', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      userlangid, businessentityid, userid, languageid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 16:42:33.649046', 'tsaxen', '2025-03-11 16:42:33.649046', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkemail, projectfk, mailboxfk, projecttype, fromaddress, replytoaddress, toaddress, ccaddress, received,
               header, subject, body, mime, parentemailfk, contactemailfk, incoming, priority, status, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-04-01 21:29:52.572150', 'tsaxen', '2025-04-01 21:29:52.572150', 'DE-138');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkmailbox, emailprojectfk, name, serveraddress, port, encrypted, username, password, protocol, category, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-04-01 21:33:37.823824', 'tsaxen', '2025-04-01 21:33:37.823824', 'DE-138');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkqueries, name, sqltext, databasestructure, availablesqltext, availablecampaignslist, sortbyphonetype,
               sortbylastcontacted, agentfk, totalsqltext, dialingsqltext, persistonexhaust, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-04-01 21:37:58.412670', 'tsaxen', '2025-04-01 21:37:58.412670', 'DE-138');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, efr.enrollmentstatusid, efr.enrollmentid, efr.datesenttocallcenter, efr.datedeliveredtoclient,
       efr.sendtoclient, efr.miscnotes, efr.externalenrollmentstatusid, efr.externalenrollmentstatusdate, efr.adhocexecution,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Enrollment e with (nolock) on efr.EnrollmentId = e.EnrollmentId', 'tsaxen', '2025-02-03 21:16:22.746380', 'tsaxen', '2025-02-03 21:16:22.746380', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        leadproviderselectionsid, npi, locationid, siteid, clientlocationidentifier, groupname, street, zip, ispcp, miscnotes, validfrom, validto, pcpselectedbybeneficiary,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 18:32:35.244227', 'tsaxen', '2025-02-18 18:32:35.244227', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        leadproviderselectionmapid, leadid, leadproviderselectionsid, isactive, datecreated, lastupdateddate, miscnotes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 20:43:41.110740', 'tsaxen', '2025-02-18 20:43:41.110740', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
   ###REFERENCE_ID### as carrier_id,
    EnrollmentId, Date, AgentId, EnrollmentFormId, null as RawData, StartDate, PlanId,
                                   AgentFirstName, AgentLastName, AgentEmail, AgentURL, UserID, Premium, ApplicationType,
                                   SendToUnderwriter, PlanYear, PharmacyNPI, ScopeOfAppointmentId, ProviderNPI, ConfirmationId,
                                   ExternalLeadId, AscendLeadID, AscendMeetingID, BEID, MiscNotes, Browser, BlueButtonPatientId,
                                   RequestedEffectiveDate, AgentNPN, AgentAWN, IPAddress, UserAgent, 
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-22 21:04:19.638794', 'tsaxen', '2025-01-22 21:04:19.638794', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        partialapplicationid, userid, agentid, formid, planid, planyear, applicationtype, marketingcode,
                agentfirstname, agentlastname, agentemail, firstname, lastname, dateofbirth, null as applicationdata,
                null as applicationformrestoredata, pharmacynpi, providernpi, datesaved, enrollmentid, isapplicationcomplete,
                isreturnablebyagent, scopeofappointmentid, expirationdatetime, isdeleted, miscnotes,
                isreachedapplicationsummary, browser, null as guidsessiondata, consumerapptrackingcode, beid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 21:09:18.451348', 'tsaxen', '2025-02-18 21:09:18.451348', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.eventagentmapid, efr.eventid, efr.userid, efr.isdeleted, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.events e with (nolock) on e.eventid = efr.eventid ', 'tsaxen', '2025-03-11 17:29:50.288289', 'tsaxen', '2025-03-11 17:29:50.288289', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      faxtransmissionid, leadid, userid, faxstatus, tofaxnumber, externalfaxtransmissionid, paperid,
               soaid, docid, faxdatetime, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 16:05:20.368949', 'tsaxen', '2025-03-11 16:05:20.368949', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        personcontactinfoid, personid, contactinfoid, contactinfotypeid, startdate, enddate, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 21:47:54.389839', 'tsaxen', '2025-02-18 21:47:54.389839', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        agentreadytosellstatusid, agentid, businessentityid, payerid, planyear, state, readytosellflag, isdeleted,
       author, systemuser_createdby, miscnotes, validfrom, validto, rtsplantypeid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 17:14:47.807634', 'tsaxen', '2025-02-17 17:14:47.807634', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        personrelationshipid, relationship, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 22:00:17.246834', 'tsaxen', '2025-02-18 22:00:17.246834', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        salesregionid, name, description, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 22:15:02.707148', 'tsaxen', '2025-02-18 22:15:02.707148', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        regionfipscodesid, regionid, statefipscode, countyfipscode, stateabbreviation, county, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 22:22:27.536502', 'tsaxen', '2025-02-18 22:22:27.536502', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, hrainformationid, memberinformationid, formsubmissionid, hrastatusid, dynamicinformation,
               statusupdatedate, ascenduserid, miscnotes, buttonid, actionid, savetotable, senttofile,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-03 22:16:30.178153', 'tsaxen', '2025-02-03 22:16:30.178153', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    actiontrackingid, memberinformationid, buttonid, vbeactionid,
       actiondatetime, ascenduserid, isactioncomplete, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 17:20:23.335085', 'tsaxen', '2025-01-31 17:20:23.335085', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        contactinfoid, street1, street2, city, county, state, zipcode, country, phone, email, fax, miscnotes, secondaryphone,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 20:24:25.142589', 'tsaxen', '2025-02-17 20:24:25.142589', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        enrollmentbeqresponsemapid, enrollmentid, beqresponseid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 20:37:34.112708', 'tsaxen', '2025-02-17 20:37:34.112708', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    agentsalesregionmapid, agentid, salesregionid, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 18:31:17.954953', 'tsaxen', '2025-01-31 18:31:17.954953', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
    awvinformationid, memberinformationid, awvstatusid, miscnotes, statusupdatedate, providername,
               appointmentdate, npi, confirmeddate, pcpphone, pcpstreet1, pcpstreet2, pcpcity, pcpstate, pcpzip,
               timezone, ascenduserid, buttonid, actionid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 18:52:27.542524', 'tsaxen', '2025-01-31 18:52:27.542524', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      emailtemplatetrackid, beid, templateid, datetimesent, senderuserid, receiveruserid, receiveremail,
               response, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 17:57:37.319048', 'tsaxen', '2025-03-11 17:57:37.319048', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select agentgroupsfk, poolsfk, start, stop,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 22:01:35.290689', 'tsaxen', '2025-02-12 22:01:35.290689', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkid, hourofcall, hour,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 22:16:55.658877', 'tsaxen', '2025-02-12 22:16:55.658877', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select bloom_clientcampaignmapid, bloom_clientid, campaignid, auditusername, isactiveforstats, isactive,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:22:43.408245', 'tsaxen', '2025-03-04 20:22:43.408245', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkbloomdispositionmapping, callresultcode, clientid, thirdpartyname, externalcode, testing, isactive,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:25:25.954780', 'tsaxen', '2025-03-04 20:25:25.954780', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkcarriergroup, carriergroupname, isdeleted, carrierfk, auditusername,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:49:38.027557', 'tsaxen', '2025-03-04 20:49:38.027557', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select plantypeid, plantypedescription, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 21:31:53.780004', 'tsaxen', '2025-02-14 21:31:53.780004', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, personid, replace(firstname, \'\\\', \'\'), replace(lastname, \'\\\', \'\'), replace(middlename, \'\\\', \'\'), nameprefix,
        gender, dob, retirementdate, ssn, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-06 21:37:10.439590', 'tsaxen', '2025-02-06 21:37:10.439590', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select producttypeid, name, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-14 21:43:57.331473', 'tsaxen', '2025-02-14 21:43:57.331473', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.mapmessagetargetid, efr.businessentityid, efr.messageid, efr.userid, efr.groupid, efr.isdeleted, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Messages e with (nolock) on efr.messageid = e.messageid', 'tsaxen', '2025-03-11 18:34:33.569128', 'tsaxen', '2025-03-11 18:34:33.569128', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      id, beid, name, description, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 18:57:12.608329', 'tsaxen', '2025-03-11 18:57:12.608329', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      leadgenerationtrackingid, beid, prospectid, fieldagentid, callcenteragentname, contactinfofk,
               leadfirstname, leadlastname, leadaddress, leadcity, leadstate, leadzip, leadcounty, leadphone,
               datetimecallwastransferred, uniquecallid, carriername, agentavailable, radius, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 19:28:48.914606', 'tsaxen', '2025-03-11 19:28:48.914606', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      scopeofappointmentid, formsubmissionid, displayname, beid, userid, prospectid, requestedmeetingdate,
               statustypeid, creationdate, statuschanged, emailsent, senton, passcode, useragent, ipaddress, notes,
               audituserid, paperscopefilename, reminderlastsent, signaturetype,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 19:40:49.728419', 'tsaxen', '2025-03-11 19:40:49.728419', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        quickquoteid, displayid, userid, firstname, lastname, email, phone, zipcode, statefipscode, countyfipscode,
                county, state, sendtoenrollment, sentdate, expirationdate, verificationcode, expirationdatepii, agentnpn,
                confirmationid, partialapplicationid, beid, ascendleadid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 22:32:16.599783', 'tsaxen', '2025-02-18 22:32:16.599783', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        vbeinformationstatushistoryid, vbeinformationid, memberinformationid, formsubmissionid,
                buttonid, actionid, vbestatusid, statusupdatedate, ascenduserid, miscnotes, formid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 14:34:50.073947', 'tsaxen', '2025-02-19 14:34:50.073947', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        vbeinformationid, memberinformationid, formsubmissionid, buttonid, actionid, vbestatusid,
                statusupdatedate, ascenduserid, miscnotes, formid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 14:44:37.804974', 'tsaxen', '2025-02-19 14:44:37.804974', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        leadpharmacyselectionsid, leadid, pharmacynpi, isactive, datecreated, lastupdateddate, miscnotes, validfrom, validto, primarypharmacy,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 17:53:57.588749', 'tsaxen', '2025-02-18 17:53:57.588749', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachvendorresults, outreachmemberinfofk, memberinformationfk, vendoroutreachactivityid,
                activitydate, hraactivitydate, activityoutcome, activitytypeid, activitytypedescription,
                hrainformationid, programtype, questionversion, excludefromreporting, miscnotes, inserteddate,
                validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 15:15:03.130983', 'tsaxen', '2025-02-19 15:15:03.130983', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachmailresults, outreachmemberinfofk, memberinformationfk, mailoutreachactivityid, mailsentdatetime,
                 activitydate, hraactivitydate, mailoutcome, hrainformationid, pdffilename, mailcrosswalkstatus,
                 mailcrosswalkstatusupdatedate, programtype, questionversion, barcode, excludefromreporting, miscnotes,
                 inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 18:40:51.453473', 'tsaxen', '2025-02-19 18:40:51.453473', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachemailresults, outreachmemberinfofk, memberinformationfk, emailoutreachactivityid, emailstartdatetime,
                 emailenddatetime, emailoutcome, inserteddate, hrainformationid, excludefromreporting, miscnotes, email,
                 timestamp as timestamp_num, smtpid, event, category, sg_content_type, sg_eventid, sg_message_id, response, attempt,
                 useragent, ip, url, urloffset, reason, status, asm_group_id, type, validfrom, validto,
                 ProjectFK,OutreachAttemptFK,OutreachListFK,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 19:30:45.395358', 'tsaxen', '2025-02-19 19:30:45.395358', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachmembercustominfo, outreachmemberinfofk, memberinformationfk, fieldname, fieldvalue, datatype,
                 isactive, miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 18:22:20.566874', 'tsaxen', '2025-02-19 18:22:20.566874', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, pkagentsalesregionproductmap, agentsalesregionmapid, productid, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-04 15:40:32.551322', 'tsaxen', '2025-02-04 15:40:32.551322', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select contacttypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 16:09:32.048068', 'tsaxen', '2025-02-17 16:09:32.048068', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select statustypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-17 16:13:01.242817', 'tsaxen', '2025-02-17 16:13:01.242817', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachlistmap, outreachmemberinfofk, memberinformationfk, outreachlistfk, listsource, isactive,
                 miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 19:09:34.106123', 'tsaxen', '2025-02-19 19:09:34.106123', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachivrresults, outreachmemberinfofk, memberinformationfk, ivroutreachactivityid, calldirection,
                 ivrstartdatetime, ivrenddatetime, ivroutcome, ivrphonenumber, memberanswer, caregiveranswer,
                 interviewagreement, hrainformationid, excludefromreporting, miscnotes, inserteddate, validfrom, validto,
                 ProjectFK,OutreachAttemptFK,OutreachListFK,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 19:24:21.478805', 'tsaxen', '2025-02-19 19:24:21.478805', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachsubsequentresults, outreachmemberinfofk, memberinformationfk, clientuniqueid,
                subsequentoutreachactivityid, activitydate, activityoutcome, pdfactivityid, subsequentreason,
                excludefromreporting, miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 15:30:18.246254', 'tsaxen', '2025-02-19 15:30:18.246254', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        schedulinginformationid, memberinformationid, timeoffset, starttime, endtime, timesenttocallcenter, timezone, isdeleted,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 14:54:10.623257', 'tsaxen', '2025-02-19 14:54:10.623257', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachportalresults, outreachmemberinfofk, memberinformationfk, portaloutreachactivityid,
                 activitydate, activityoutcome, interviewagreement, hrainformationid, agentfk, excludefromreporting,
                 miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 17:32:01.480362', 'tsaxen', '2025-02-19 17:32:01.480362', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select dispositionsid, code, description, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 17:11:23.089036', 'tsaxen', '2025-03-06 17:11:23.089036', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      dispositiontypeid, businessentityid, code, description, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 20:14:59.144312', 'tsaxen', '2025-03-11 20:14:59.144312', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select statusid, leadstatus, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 15:50:37.968764', 'tsaxen', '2025-03-06 15:50:37.968764', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select faxstatusid, efaxid, faxstatus, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 15:54:49.792530', 'tsaxen', '2025-03-06 15:54:49.792530', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
   pkrowid, usersfk, signin, signout, stationid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-28 22:34:32.608646', 'tsaxen', '2025-01-28 22:34:32.608646', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkagentstats, usersfk, campaignfk, pausetime, waittime, notavailabletime, systemtime, statsdate,
       statstime, numberofcampaigns, prevstate, nextstate, pausereasonfk, logoutreasonfk,
       replace(pausereasontext, \'\\\', \'\'), replace(logoutreasontext, \'\\\', \'\'), projecttype,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-07 19:04:54.098902', 'tsaxen', '2025-02-07 19:04:54.098902', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkplan, planname, plantype, isdeleted, carrierfk, commissionrate, plangroup, auditusername,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 20:59:48.128106', 'tsaxen', '2025-03-04 20:59:48.128106', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkcallresults, agentexitcode, agentwrapendtime, autoattendant, callaccount, calldurationseconds, agentfk,
       callendtime, contactnumber, callline, callstarttime, calltype, dnis, exitstate, callwastransferred,
       overflowgroupfk, dateofcall, dniscategoryfk, callsenttoagenttime, voicemailstarttime, voicemailstoptime,
       contactnumberfk, poolfk, notes, recordingfilename, morephonenumbers, outofhours, queryid, commentfk,
       previewtime, holdtime, finaldisposition, appointmentid, agentactionid, emailfk, projecttype,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-10 21:08:28.603464', 'tsaxen', '2025-02-10 21:08:28.603464', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkplanmapping, carrierfk, planfk, carriermappingfk, isdeleted, auditusername,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-04 21:03:37.258448', 'tsaxen', '2025-03-04 21:03:37.258448', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.eventprospectmapid, efr.eventid, efr.prospectid, efr.isdeleted, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Events e with (nolock) on efr.eventid = e.eventid', 'tsaxen', '2025-03-11 20:24:45.249292', 'tsaxen', '2025-03-11 20:24:45.249292', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      leadviewid, beid, name, [rule], xmlrule, description, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 20:41:44.282302', 'tsaxen', '2025-03-11 20:41:44.282302', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      eventstatusid, eventstatusname, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 20:48:11.568318', 'tsaxen', '2025-03-11 20:48:11.568318', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      isfawntypeid, beid, description, code, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 20:53:09.888881', 'tsaxen', '2025-03-11 20:53:09.888881', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      itemtypeid, beid, itemtype, itemtablename, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 21:00:43.088207', 'tsaxen', '2025-03-11 21:00:43.088207', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select id, definitionlabel, definition,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:12:18.960696', 'tsaxen', '2025-03-06 16:12:18.960696', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select eventstatusid, eventstatusname, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:20:46.778895', 'tsaxen', '2025-03-06 16:20:46.778895', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select businessentityid, carrierid, businessentityname, spacequota, servername, serverusername, authenticationkey, pointofcontact,
       documentroot, recordingroot, recordingmeth, paperscoperoot, pushnotificationpath, pushcertpassword, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:26:28.852640', 'tsaxen', '2025-03-06 16:26:28.852640', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select
        agentuserroleid, name, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-30 21:23:44.330789', 'tsaxen', '2025-01-30 21:23:44.330789', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select eventtypeid, eventtypename, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:29:19.093491', 'tsaxen', '2025-03-06 16:29:19.093491', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select id, line, catalogid, definitiontype, reportname, definitionid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 16:33:08.707934', 'tsaxen', '2025-03-06 16:33:08.707934', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      eventtypeid, eventtypename, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 21:08:14.830988', 'tsaxen', '2025-03-11 21:08:14.830988', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      emailtemplatemergeid, beid, templateid, agentfirstname, agentlastname, agentprimaryphone, agentcellphone,
               agentofficephone, agentenrollmentphone, agentemail, agentaddress, agentcity, agentstate, agentzipcode,
               agentnpn, agentawn, prospectfirstname, prospectlastname, prospectemail, prospectphonenumber, prospectaddress,
               prospectcity, prospectstate, prospectzipcode, prospectcounty, templatetype, responsetype, respondtoagent,
               respondtootheremail, respondtootheremailaddress, fromname, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 21:13:54.811878', 'tsaxen', '2025-03-11 21:13:54.811878', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      statusid, businessentityid, leadstatus, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 21:22:51.279090', 'tsaxen', '2025-03-11 21:22:51.279090', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      calltoleadmapid, callsid, leadid, businessentityid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-11 21:28:51.568247', 'tsaxen', '2025-03-11 21:28:51.568247', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkwellcarecncsnpeligibilityfilearchiveid, pkwellcarecncsnpeligibilityfileimportid, outreach_id, outreach_start_date,
               hra_due_date, outreach_type, outreach_category, activity_date, disengage_date, disengage_reason, contract_number,
               plan_code, member_id, mbi, effective_date, term_date, program_type, question_version, member_first_name,
               member_last_name, member_dob, member_gender, member_preferred_language, member_address_1, member_address_2,
               member_city, member_state, member_zip, member_phone_1, member_phone_2, member_phone_3, member_phone_cell,
               member_email_1, member_email_2, member_consent, member_consent_date, pcp_first_name, pcp_last_name, pcp_address_1,
               pcp_address_2, pcp_city, pcp_state, pcp_zip, pcp_effective_date, disenrolled_outreach_id, datecreated, processed,
               processeddate, importfilename, isinvalidrecord, carrierid, isduplicate, fkoutreachmemberinfoid, sendtocallcenter,
               aqedmlaction, notes, fkmemberinformationid, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-04-08 16:56:52.866511', 'tsaxen', '2025-04-08 16:56:52.866511', 'adhoc request');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select userid, loginname, null as password, null as salt, fname, lname, datepwdchange, natpronum, locked, notes,
               audituserid, null as hash, null as truesalt, userversion, useriterations, apiversion, apiiterations, lockendtime,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-03-06 18:13:35.008622', 'tsaxen', '2025-03-06 18:13:35.008622', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select carrierid, carriername, databaseserver, databasename, apikey, totallicallowed, totallicused, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-03-06 15:38:49.008552', 'tsaxen', '2025-03-06 15:38:49.008552', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkenrollmentinfo, lisstatus, bloomenrollmentguid, dateadded, enrollmentid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-10 22:18:02.014560', 'tsaxen', '2025-02-10 22:18:02.014560', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkengine, name, host, port,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 20:55:53.935362', 'tsaxen', '2025-02-12 20:55:53.935362', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select pkdnismapping, dnis, dniscategoryfk, projectfk, lead_code, description, dnis_cat_desc, project, sub_project,
       campaign, source, pi_tv, zone, planname, transfer_from, scriptpage, bannertext, dnisstatusfk, modifieddate, modifieduser,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-12 21:01:58.931364', 'tsaxen', '2025-02-12 21:01:58.931364', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select dispositioncategoryid, dispcategory, isdeleted, auditusername,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-10 15:04:30.347484', 'tsaxen', '2025-02-10 15:04:30.347484', 'DE-2');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select persontypeid, name, description, isdeleted, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-03-03 15:33:15.544499', 'tsaxen', '2025-03-03 15:33:15.544499', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id, awnid, awn, agentid, productid, isdeleted, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-07 14:59:45.371027', 'tsaxen', '2025-02-07 14:59:45.371027', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        externalenrollmentstatusid, name, description, isdefault, ispositivestatus, miscnotes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-02-18 15:49:54.648265', 'tsaxen', '2025-02-18 15:49:54.648265', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select payerid, payername, isactive, miscnotes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 21:15:39.696734', 'tsaxen', '2025-01-31 21:15:39.696734', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      appointmenttagsmapid, beid, apptid, tagid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 14:16:58.277633', 'tsaxen', '2025-03-12 14:16:58.277633', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      eventstatusid, eventstatusname, beid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 14:25:45.572177', 'tsaxen', '2025-03-12 14:25:45.572177', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       tagid, tagname, beid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 14:34:16.516235', 'tsaxen', '2025-03-12 14:34:16.516235', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       regiongroupmapid, regionid, groupid, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 14:41:39.489474', 'tsaxen', '2025-03-12 14:41:39.489474', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       dispositiontypemapid, typeid, dispositionid, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 15:53:06.906530', 'tsaxen', '2025-03-12 15:53:06.906530', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       eventdurationid, eventdurationname, eventdurationinminutes, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 15:37:00.428473', 'tsaxen', '2025-03-12 15:37:00.428473', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       meetinghistoryid, beid, userid, token, isrecorded, address, city, state, zipcode, latitude, longitude,
               startdatetime, enddatetime, disposition, dispositiontype, filename, checksum, filesize,
               isrecordinguploaded, soaid, notes, audituserid, transcriptionrequestid, transcriptionrequeststatus,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 14:55:35.853299', 'tsaxen', '2025-03-12 14:55:35.853299', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       eventdurationid, eventdurationname, eventdurationinminutes, beid, status, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 15:42:23.865426', 'tsaxen', '2025-03-12 15:42:23.865426', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select productid, carrierid, name, producttypeid, additionalquestionsformid, premiummodifierequation, miscnotes,
       displayorder, partialappexpiry, partialapplinkexpiry, isdeleted, externalapisubmissionsusage, subcarrierid,
       payerid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock)', 'tsaxen', '2025-01-31 20:41:16.803575', 'tsaxen', '2025-01-31 20:41:16.803575', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        leaddrugselectionsid, leadid, drugndc, chosendosage, chosenpackage, chosenfrequency,
                chosenquantity, isactive, datecreated, lastupdateddate, miscnotes, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-18 17:30:56.441981', 'tsaxen', '2025-02-18 17:30:56.441981', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       itemtypeid, beid, itemtype, itemtablename, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 15:49:03.328897', 'tsaxen', '2025-03-12 15:49:03.328897', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       callsid, pkcallresult, dispostring, agentname, calldate, calltype, dnis,
               dnisdescription, dniscategory, origin, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 16:12:19.593363', 'tsaxen', '2025-03-12 16:12:19.593363', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       apptid, beid, appttypeid, description, location, date_time, address, city, state, zip, phone,
               website, capacity, zoneid, seatstaken, cancelled, notes, audituserid, isprivate, imagelocation,
               reservedseats, virtualmeetinglink,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 16:26:16.368355', 'tsaxen', '2025-03-12 16:26:16.368355', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.hvappointmentmeetingmapid, efr.hvappointmentid, efr.meetinghistoryid, efr.isdeleted, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Meetings e with (nolock) on efr.meetinghistoryid = e.meetinghistoryid', 'tsaxen', '2025-03-12 17:53:17.436334', 'tsaxen', '2025-03-12 17:53:17.436334', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       isfenrollmenthistoryid, beid, leadid, confirmationnumber, meetingid, planname, premiumvalue, datecreated, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 18:10:35.887681', 'tsaxen', '2025-03-12 18:10:35.887681', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.mapapptuserid, efr.businessentityid, efr.apptid, efr.userid, efr.notes, efr.audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Appointments e with (nolock) on efr.apptid = e.apptid', 'tsaxen', '2025-03-12 18:27:36.367709', 'tsaxen', '2025-03-12 18:27:36.367709', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
      efr.mapmessageuserid, efr.userid, efr.messageid, efr.businessentityid, efr.requireack, efr.userack, efr.timeacknowlwdged,
               efr.messagedelivered, efr.messagereceived, efr.isdeleted, efr.notes, efr.audituserid, efr.groupid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### efr with (nolock) join ###SRC_DB###.dbo.Messages e with (nolock) on efr.messageid = e.messageid', 'tsaxen', '2025-03-12 18:55:19.050800', 'tsaxen', '2025-03-12 18:55:19.050800', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       mapuserroleid, carrierid, businessentityid, userid, roleid, rolecode, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 19:18:06.806459', 'tsaxen', '2025-03-12 19:18:06.806459', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       mapusergroupid, userid, businessentityid, groupid, groupcode, isowner, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 19:27:03.807222', 'tsaxen', '2025-03-12 19:27:03.807222', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       isfuserawnid, beid, userid, awn, isfawntype, isdeleted, notes, audituserid,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 19:40:46.129643', 'tsaxen', '2025-03-12 19:40:46.129643', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       formsubmissionid, formid, useragent, ipaddress, ispartial, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 20:00:31.304778', 'tsaxen', '2025-03-12 20:00:31.304778', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       formsubmissiondataid, formsubmissionid, formpageelementmapid, left(value, 8000) + \'...\' as value, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 20:07:29.328310', 'tsaxen', '2025-03-12 20:07:29.328310', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
       id, beid, leadid, permissionid, audituserid, notes,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-12 20:45:56.137023', 'tsaxen', '2025-03-12 20:45:56.137023', 'DE-40');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select businessentityid, carrierid, businessentityname, spacequota, servername, serverusername, null as authenticationkey,
               pointofcontact, documentroot, recordingroot, recordingmeth, paperscoperoot, pushnotificationpath, pushcertpassword,
               isdeleted, notes, audituserid, auditdatastate, auditdmlaction, auditdatetime, uniquekey, current_timestamp as refresh_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 18:41:22.934366', 'tsaxen', '2025-03-17 18:41:22.934366', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select userid, loginname, null as password, null as salt, fname, lname, datepwdchange, natpronum, locked, notes, audituserid,
               auditdatastate, auditdmlaction, auditdatetime, uniquekey, null as hash, null as truesalt, userversion, useriterations, apiversion, apiiterations, lockendtime, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 19:21:32.174702', 'tsaxen', '2025-03-17 19:21:32.174702', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select usersessionid, userid, clientid, sessionstartdatetime, sessionenddatetime, useragent, buildversion,
               osversion, ipaddress, iscellular, iswifi, devicetype, audituserid, auditdatastate, auditdmlaction,
               auditdatetime, uniquekey, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 19:35:36.128189', 'tsaxen', '2025-03-17 19:35:36.128189', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id, subscriptionid, businessentityid, apptid, leadid, prospectid, generalseats, isactive, attendedappointment,
               notes, audituserid, auditdatastate, auditdmlaction, auditdatetime, uniquekey, passcode, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 20:24:52.926605', 'tsaxen', '2025-03-17 20:24:52.926605', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        availableid, beid, userid, startdatetime, enddatetime, notes, audituserid, auditdatastate,
               auditdmlaction, sysuser, auditdatetime, uniquekey, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 20:41:57.013262', 'tsaxen', '2025-03-17 20:41:57.013262', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        documentid, businessentityid, documentname, publishdate, expirydate, createddate, folderid, subfolderid,
               replacesdocumentid, documentpath, isdeleted, notes, audituserid, auditdatastate, auditdmlaction, sysuser,
               auditdatetime, resourcetype, displayonhomescreen, passauth, action, ranking, uniquekey, recipientcount, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 20:53:48.207121', 'tsaxen', '2025-03-17 20:53:48.207121', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        leadgenerationtrackingid, beid, prospectid, fieldagentid, callcenteragentname, contactinfofk, leadfirstname,
               leadlastname, leadaddress, leadcity, leadstate, leadzip, leadcounty, leadphone, datetimecallwastransferred,
               uniquecallid, carriername, agentavailable, radius, notes, audituserid, auditdatastate, auditdmlaction,
               sysuser, auditdatetime, uniquekey, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 21:08:45.481350', 'tsaxen', '2025-03-17 21:08:45.481350', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        meetingtoleadmapid, beid, meetingid, leadid, scopeofappointmentid, bloomclientid, datetimeofmeeting,
               notes, audituserid, auditdatastate, auditdmlaction, auditdatetime, uniquekey, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-17 21:19:43.808757', 'tsaxen', '2025-03-17 21:19:43.808757', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        prospectid, beid, meetingid, firstname, middleinitial, lastname, phone, streetaddress, city, state,
               zipcode, county, email, creationmethod, leadsourceid, dateofcreation, islead, leaddate, agentid, commission,
               altexternalid, leadstatusid, isdeleted, viewed, birthdate, gender, medicareclaimnumber,
               medicarepartaeffectivedate, medicarepartbeffectivedate, lastmodifieddate, lastmodifiednotes, notes,
               audituserid, auditdatastate, auditdmlaction, auditdatetime, uniquekey, cuid, streetaddress2, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-18 13:10:03.975881', 'tsaxen', '2025-03-18 13:10:03.975881', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        scopeofappointmentid, formsubmissionid, displayname, beid, userid, prospectid, requestedmeetingdate,
               statustypeid, creationdate, statuschanged, emailsent, senton, passcode, useragent, ipaddress, notes,
               audituserid, auditdatastate, auditdmlaction, auditdatetime, paperscopefilename, uniquekey,
               reminderlastsent, signaturetype, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-18 16:03:14.789501', 'tsaxen', '2025-03-18 16:03:14.789501', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as ascend_carrier_id,
        userdetailsid, userid, beid, primaryphone, officephone, homephone, mobilephone, fax, address, city, state,
               zipcode, extusername, extpassword, useenrollurl, leadgeneration, skilllevel, userurl, userate, enrollmentphone,
               contactnumbersid, natpronum, notes, audituserid, auditdatastate, auditdmlaction, auditdatetime, uniquekey,
               ratecallforwardingid, current_timestamp
        from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE### with (nolock) ', 'tsaxen', '2025-03-18 16:17:46.353224', 'tsaxen', '2025-03-18 16:17:46.353224', 'DE-120');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachroutedonotcontact, contact, sms, email, call, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 16:42:16.615057', 'tsaxen', '2025-02-19 16:42:16.615057', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachmemberphoneinfo, outreachmemberinfofk, memberinformationfk, contactnumber, [order] as order_num, phonetype,
                 smsattempts, ivrattempts, isactive, miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 17:56:54.711953', 'tsaxen', '2025-02-19 17:56:54.711953', 'DE-4');
INSERT INTO data_operations.data_transfer_sql (transfer_sql, created_by, created_at, last_modified_by, last_modified_at, notes) VALUES (e'select ###REFERENCE_ID### as carrier_id,
        pkoutreachmemberemailinfo, outreachmemberinfofk, memberinformationfk, emailaddress, [order] as order_num,
                 emailattempts, isactive, miscnotes, inserteddate, validfrom, validto,
       current_timestamp as refresh_timestamp
from ###SRC_DB###.###SRC_SCHEMA###.###SRC_TABLE###  with (nolock)', 'tsaxen', '2025-02-19 18:14:07.140232', 'tsaxen', '2025-02-19 18:14:07.140232', 'DE-4');
