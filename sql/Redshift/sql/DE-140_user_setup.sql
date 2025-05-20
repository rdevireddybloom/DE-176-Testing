create user analytics_report_user password '***';
create schema analytics;
grant usage on schema analytics to group named_user_ro;

create role analytics_ro;
create role analytics_rw;
create role analytics_full;

grant usage on schema dm_analytics to role analytics_ro;
grant select on all tables in schema dm_analytics to role analytics_ro;

grant usage on schema analytics to role analytics_ro
grant select on all tables in schema analytics to role analytics_ro;
grant insert,update,delete on all tables in schema analytics to role analytics_rw;
grant all on schema analytics to role analytics_full;
grant role analytics_ro to role analytics_rw;
grant role analytics_rw to role analytics_full;

grant role analytics_ro to analytics_report_user;

ALTER DEFAULT PRIVILEGES FOR USER rzhu IN SCHEMA analytics GRANT SELECT ON TABLES TO ROLE analytics_ro;
ALTER DEFAULT PRIVILEGES FOR USER rzhu IN SCHEMA analytics GRANT insert,update,delete ON TABLES TO ROLE analytics_rw;
ALTER DEFAULT PRIVILEGES FOR USER rzhu IN SCHEMA analytics GRANT all ON TABLES TO ROLE analytics_full;

ALTER DEFAULT PRIVILEGES FOR USER scastaneda IN SCHEMA analytics GRANT SELECT ON TABLES TO ROLE analytics_ro;
ALTER DEFAULT PRIVILEGES FOR USER scastaneda IN SCHEMA analytics GRANT insert,update,delete ON TABLES TO ROLE analytics_rw;
ALTER DEFAULT PRIVILEGES FOR USER scastaneda IN SCHEMA analytics GRANT all ON TABLES TO ROLE analytics_full;

ALTER DEFAULT PRIVILEGES FOR USER srajagopal IN SCHEMA analytics GRANT SELECT ON TABLES TO ROLE analytics_ro;
ALTER DEFAULT PRIVILEGES FOR USER srajagopal IN SCHEMA analytics GRANT insert,update,delete ON TABLES TO ROLE analytics_rw;
ALTER DEFAULT PRIVILEGES FOR USER srajagopal IN SCHEMA analytics GRANT all ON TABLES TO ROLE analytics_full;

grant role analytics_full to rzhu;
grant role analytics_full to scastaneda;
grant role analytics_full to srajagopal;