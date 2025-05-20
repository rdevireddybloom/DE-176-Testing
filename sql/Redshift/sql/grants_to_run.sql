GRANT select ON ALL TABLES IN SCHEMA integrated_aqe TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA integrated_ccs TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA integrated_asc TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA aqe_history TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA ccs_history TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA asc_history TO GROUP named_user_ro;

GRANT select ON ALL TABLES IN SCHEMA analytics TO GROUP named_user_ro;
GRANT select ON ALL TABLES IN SCHEMA dm_analytics TO GROUP named_user_ro;


grant all privileges on all tables in schema analytics to role analytics_full;
grant insert,update,delete  on all tables in schema analytics to role analytics_rw;
grant select on all tables in schema analytics to role analytics_ro;








-- NEW INFO:


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
