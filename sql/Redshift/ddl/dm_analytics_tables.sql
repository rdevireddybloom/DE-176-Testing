create schema dm_analytics authorization etluser;
grant usage on schema dm_analytics to group named_user_ro;

create table dm_analytics.AgentLogTime_summarized
(
    usersfk                  bigint encode az64,
    name                     varchar(32),
    projectname              varchar(255),
    statsdate                date encode az64,
    hourofcall               integer encode az64,
    totalwait                numeric(26, 5) encode az64,
    totalpause               numeric(26, 5) encode az64,
    totalnotavailableseconds numeric(26, 5) encode az64,
    totalsystem              numeric(26, 5) encode az64,
    refresh_timestamp       timestamp
)
    sortkey (statsdate);

grant select on dm_analytics.AgentLogTime_summarized to group named_user_ro;

create table dm_analytics.AgentLogTime_raw
(
    usersfk              integer encode az64,
    name                 varchar(32),
    pausetime            timestamp encode az64,
    pauseseconds         numeric(26, 5) encode az64,
    waittime             timestamp encode az64,
    waitseconds          numeric(26, 5) encode az64,
    notavailabletime     timestamp encode az64,
    notavailableseconds  numeric(26, 5) encode az64,
    systemtime           timestamp encode az64,
    systemseconds        numeric(26, 5) encode az64,
    statsdate            date encode az64,
    statstime            timestamp,
    hourofcall           integer encode az64,
    halfhourofcall       integer encode az64,
    campaignfk           integer encode az64,
    numberofcampaigns    bigint encode az64,
    projectname          varchar(255),
    prevstate            bigint encode az64,
    nextstate            bigint encode az64,
    pausereasonfk        bigint encode az64,
    pausereason          varchar(255),
    logoutreasonfk       bigint encode az64,
    logoutreason         varchar(255),
    refresh_timestamp       timestamp
)
    sortkey (statstime);

grant select on dm_analytics.AgentLogTime_raw to group named_user_ro;

create table dm_analytics.aqe_enrollments_raw
(
    carrierid              bigint encode az64,
    carriername            varchar(256),
    enrollmentid           bigint encode az64,
    confirmationid         varchar(50),
    startdate              timestamp encode az64,
    enrollmentdate         timestamp encode az64,
    eststartdate           timestamp encode az64,
    planyear               bigint encode az64,
    applicationtypeid      varchar(50),
    applicationtype        varchar(19),
    agentnpn               varchar(100),
    ascenduserid           bigint encode az64,
    agentfirstname         varchar(50),
    agentlastname          varchar(50),
    agentemail             varchar(300),
    agentpurl              varchar(100),
    businessentityid       bigint encode az64,
    requestedeffectivedate date encode az64,
    city                   varchar(256),
    county                 varchar(256),
    state                  varchar(256),
    zipcode                varchar(256),
    aqeplanid              bigint encode az64,
    contract               varchar(50),
    pbp                    varchar(13),
    segment                varchar(13),
    planname               varchar(256),
    plantype               varchar(500),
    producttype            varchar(50),
    payerid                bigint encode az64,
    payername              varchar(256),
    refresh_timestamp      timestamp,
    both_aqe_and_ccs_enrollment   boolean default false
);

grant select on dm_analytics.aqe_enrollments_raw to group named_user_ro;
grant insert,update,delete on dm_analytics.aqe_enrollments_raw to role analytics_rw;
grant select on all tables in dm_analytics.aqe_enrollments_raw to role analytics_ro;

create table dm_analytics.ccs_enrollments_raw
(
    callaccount                   bigint encode az64,
    enrollmentid                  varchar(256),
    planname                      varchar(250),
    dateofcall                    timestamp encode az64,
    projectname                   varchar(255),
    agentname                     varchar(32),
    agentfk                       bigint encode az64,
    contactnumber                 varchar(32),
    databasename                  varchar(256),
    client                        varchar(256),
    callresultcode                bigint encode az64,
    callresultdescription         varchar(128),
    proposedeffectivedate         date encode az64,
    enrollmenttype                varchar(10),
    newenrollplanchange           varchar(20),
    refresh_timestamp             timestamp,
    both_aqe_and_ccs_enrollment   boolean default false,
    bloomenrollmentid             bigint
);


grant select on dm_analytics.ccs_enrollments_raw to group named_user_ro;
grant insert,update,delete on dm_analytics.ccs_enrollments_raw to role analytics_rw;
grant select on all tables in dm_analytics.ccs_enrollments_raw to role analytics_ro;

create table dm_analytics.ctm_tracking
(
    id                                   bigint encode az64 distkey,
    inv_id                               bigint encode az64,
    date_of_notice_from_carrier          date encode az64,
    recording_due_date                   date encode az64,
    date_requested_from_bloom            date encode az64,
    date_recording_received_by_bloom     date encode az64,
    date_recording_sent_to_carrier       date encode az64,
    remedial_action_notice               date encode az64,
    remedial_action_due_date             date encode az64,
    date_remedial_action_requested       date encode az64,
    date_remedial_action_sent_to_carrier date encode az64,
    application_date                     date encode az64,
    supervisor                           varchar(128),
    agent_name                           varchar(128),
    npn                                  varchar(32),
    complaint_type                       varchar(64),
    allegation                           varchar(128),
    agent_still_with_fh                  boolean,
    term_date                            date encode az64,
    app_id                               varchar(32),
    state                                varchar(4),
    beneficiary                          varchar(128),
    phone_number                         varchar(24),
    plan_id                              varchar(16),
    plan                                 varchar(512),
    effectuated_member_yn                boolean,
    founded_unfounded                    varchar(32),
    founded_for_other_yn                 boolean,
    remedial_action                      varchar(512),
    notes                                varchar(65000),
    refresh_timestamp                    timestamp encode az64
);


create table dm_analytics.pip_tracker_focused_health
(
    id                bigint encode az64 distkey,
    start_time        timestamp,
    completion_time   timestamp encode az64,
    email             varchar(128),
    name              varchar(128),
    date_of_delivery  date encode az64,
    pip_stage         varchar(128),
    agent_name        varchar(128),
    agent_supervisor  varchar(128),
    sales_manager     varchar(128),
    pip_reason        varchar(128),
    pip_reason_notes  varchar(65000),
    refresh_timestamp timestamp encode az64
)
    sortkey (start_time);

grant select on dm_analytics.pip_tracker_focused_health to group named_user_ro;
grant select on dm_analytics.ctm_tracking to group named_user_ro;