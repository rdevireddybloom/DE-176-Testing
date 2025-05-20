-- Initial sql used to create read only group and first set of users.

create group named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA integrated_aqe TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA integrated_ccs TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA integrated_asc TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA aqe_history TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA ccs_history TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA asc_history TO GROUP named_user_ro;

GRANT USAGE ON SCHEMA integrated_aqe TO GROUP named_user_ro;
GRANT USAGE ON SCHEMA integrated_ccs TO GROUP named_user_ro;
GRANT USAGE ON SCHEMA integrated_asc TO GROUP named_user_ro;
GRANT USAGE ON SCHEMA aqe_history TO GROUP named_user_ro;
GRANT USAGE ON SCHEMA ccs_history TO GROUP named_user_ro;
GRANT USAGE ON SCHEMA asc_history TO GROUP named_user_ro;

create user user_name password '*****';
ALTER GROUP named_user_ro ADD USER user_name;

create schema sandbox_user_name authorization user_name;

-- after share the password, the users can update with:
alter user user_name password '*****';

-- this allows user to see all records in stl_load_errors (where copy command errors show up)
alter user user_name SYSLOG ACCESS UNRESTRICTED;





-- NEW INFO BELOW…

-- other create users
-- done
create user etluser password '***';
create user analytics_report_user password '***';
-- named users
create user dmothukuri password '***';
create user hjalumuri password '***';
create user jbirch password '***';
create user kmulukutla password '***';
create user mchavan password '***';
create user mmuvva password '***';
create user rdevireddy password '***';
create user rzhu password '***';
create user scastaneda password '***';
create user srajagopal password '***';
create user tsaxen password '***';




-- create schemas
-- done
create schema admin;
create schema landing_aqe authorization etluser;
create schema landing_asc authorization etluser;
create schema landing_ccs authorization etluser;
create schema staging_aqe authorization etluser;
create schema staging_asc authorization etluser;
create schema staging_ccs authorization etluser;
create schema integrated_aqe authorization etluser;
create schema integrated_asc authorization etluser;
create schema integrated_ccs authorization etluser;
create schema aqe_history authorization etluser;
create schema asc_history authorization etluser;
create schema ccs_history authorization etluser;
create schema analytics;
create schema dm_analytics authorization etluser;
create schema reference authorization etluser;

-- other create sandbox schemas
-- done
create schema sandbox_dmothukuri authorization dmothukuri quota 256 GB;
create schema sandbox_hjalumuri authorization hjalumuri quota 256 GB;
create schema sandbox_jbirch authorization jbirch quota 256 GB;
create schema sandbox_kmulukutla authorization kmulukutla quota 256 GB;
create schema sandbox_mchavan authorization mchavan quota 256 GB;
create schema sandbox_mmuvva authorization mmuvva quota 256 GB;
create schema sandbox_rdevireddy authorization rdevireddy quota 256 GB;
create schema sandbox_rzhu authorization rzhu quota 256 GB;
create schema sandbox_scastaneda authorization scastaneda quota 256 GB;
create schema sandbox_srajagopal authorization srajagopal quota 256 GB;
create schema sandbox_tsaxen authorization tsaxen quota 256 GB;

-- create roles
create role etl_schemas_ro;
create role named_user_ro;
-- done
create role analytics_ro;
create role analytics_rw;
create role analytics_full;

-- grants:
-- grant usage on schemas
grant usage on schema landing_aqe to role etl_schemas_ro;
grant usage on schema landing_asc to role etl_schemas_ro;
grant usage on schema landing_ccs to role etl_schemas_ro;

grant usage on schema staging_aqe to role etl_schemas_ro;
grant usage on schema staging_asc to role etl_schemas_ro;
grant usage on schema staging_ccs to role etl_schemas_ro;

grant usage on schema integrated_aqe to role named_user_ro;
grant usage on schema integrated_asc to role named_user_ro;
grant usage on schema integrated_ccs to role named_user_ro;

grant usage on schema aqe_history to role named_user_ro;
grant usage on schema asc_history to role named_user_ro;
grant usage on schema ccs_history to role named_user_ro;

grant usage on schema reference to role named_user_ro;

grant usage on schema dm_analytics to role named_user_ro;
grant usage on schema analytics to role named_user_ro;

grant usage on schema dm_analytics to role analytics_ro;
grant usage on schema analytics to role analytics_ro;

-- grant selects to ro roles
grant select on all tables in schema landing_aqe to role etl_schemas_ro;
grant select on all tables in schema landing_asc to role etl_schemas_ro;
grant select on all tables in schema landing_ccs to role etl_schemas_ro;

grant select on all tables in schema staging_aqe to role etl_schemas_ro;
grant select on all tables in schema staging_asc to role etl_schemas_ro;
grant select on all tables in schema staging_ccs to role etl_schemas_ro;

grant select on all tables in schema integrated_aqe to role named_user_ro;
grant select on all tables in schema integrated_asc to role named_user_ro;
grant select on all tables in schema integrated_ccs to role named_user_ro;

grant select on all tables in schema aqe_history to role named_user_ro;
grant select on all tables in schema asc_history to role named_user_ro;
grant select on all tables in schema ccs_history to role named_user_ro;

grant select on all tables in schema reference to role named_user_ro;

GRANT select ON ALL TABLES IN SCHEMA analytics TO role named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA dm_analytics TO role named_user_ro;

-- grant additional privs to team based roles
grant all privileges on all tables in schema analytics to role analytics_full;
grant insert,update,delete  on all tables in schema analytics to role analytics_rw;
grant select on all tables in schema analytics to role analytics_ro;

-- grant roles to users
grant role etl_schemas_ro to jbirch;
grant role etl_schemas_ro to mchavan;
grant role etl_schemas_ro to rdevireddy;
grant role etl_schemas_ro to tsaxen;

grant role named_user_ro to dmothukuri;
grant role named_user_ro to hjalumuri;
grant role named_user_ro to jbirch;
grant role named_user_ro to kmulukutla;
grant role named_user_ro to mchavan;
grant role named_user_ro to mmuvva;
grant role named_user_ro to rdevireddy;
grant role named_user_ro to rzhu;
grant role named_user_ro to scastaneda;
grant role named_user_ro to srajagopal;
grant role named_user_ro to tsaxen;

grant role analytics_ro to analytics_report_user;

-- this allows user to see all records in stl_load_errors (where copy command errors show up)
alter user jbirch SYSLOG ACCESS UNRESTRICTED;
alter user mchavan SYSLOG ACCESS UNRESTRICTED;
alter user rdevireddy SYSLOG ACCESS UNRESTRICTED;
alter user tsaxen SYSLOG ACCESS UNRESTRICTED;