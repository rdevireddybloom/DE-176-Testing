create table if not exists landing_aqe.agent
(
    carrier_id        bigint encode az64 distkey,
    agentid           bigint,
    npn               varchar(10),
    isdeleted         boolean,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
)
    sortkey (agentid);

alter table landing_aqe.agent
    owner to etluser;

create table if not exists staging_aqe.agent
(
    carrier_id            bigint encode az64 distkey,
    agentid               bigint encode az64,
    npn                   varchar(10),
    isdeleted             boolean,
    miscnotes             varchar(500) encode bytedict,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.agent
    owner to etluser;

create table if not exists integrated_aqe.agent
(
    dw_table_pk          bigint default "identity"(308773, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    agentid              bigint encode az64,
    npn                  varchar(10),
    isdeleted            boolean,
    miscnotes            varchar(500) encode bytedict,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agent
    owner to etluser;

grant select on integrated_aqe.agent to group named_user_ro;

create table if not exists landing_aqe.agentwritingnumber
(
    carrier_id        bigint encode az64,
    awnid             bigint distkey,
    awn               varchar(20),
    agentid           bigint encode az64,
    productid         bigint encode az64,
    isdeleted         boolean,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
)
    sortkey (awnid);

alter table landing_aqe.agentwritingnumber
    owner to etluser;

create table if not exists staging_aqe.agentwritingnumber
(
    carrier_id            bigint encode az64,
    awnid                 bigint encode az64 distkey,
    awn                   varchar(20),
    agentid               bigint encode az64,
    productid             bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.agentwritingnumber
    owner to etluser;

create table if not exists integrated_aqe.agentwritingnumber
(
    dw_table_pk          bigint default "identity"(308797, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    awnid                bigint encode az64,
    awn                  varchar(20),
    agentid              bigint encode az64,
    productid            bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agentwritingnumber
    owner to etluser;

grant select on integrated_aqe.agentwritingnumber to group named_user_ro;

create table if not exists landing_aqe.agenturl2
(
    carrier_id        bigint encode az64 distkey,
    pkagenturl        bigint encode az64,
    agenturlid        varchar(100),
    agentid           bigint encode az64,
    isdeleted         boolean,
    creationdate      timestamp,
    miscnotes         varchar(500),
    beid              double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (creationdate);

alter table landing_aqe.agenturl2
    owner to etluser;

create table if not exists staging_aqe.agenturl2
(
    carrier_id            bigint encode az64,
    pkagenturl            bigint encode az64,
    agenturlid            varchar(100),
    agentid               bigint encode az64,
    isdeleted             boolean,
    creationdate          timestamp encode az64,
    miscnotes             varchar(500) encode bytedict,
    beid                  bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.agenturl2
    owner to etluser;

create table if not exists integrated_aqe.agenturl2
(
    dw_table_pk          bigint default "identity"(308820, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    pkagenturl           bigint encode az64,
    agenturlid           varchar(100),
    agentid              bigint encode az64,
    isdeleted            boolean,
    creationdate         timestamp encode az64,
    miscnotes            varchar(500) encode bytedict,
    beid                 bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agenturl2
    owner to etluser;

grant select on integrated_aqe.agenturl2 to group named_user_ro;

create table if not exists landing_aqe.person
(
    carrier_id        bigint encode az64,
    personid          bigint distkey,
    firstname         varchar(256),
    lastname          varchar(256),
    middlename        varchar(256),
    nameprefix        varchar(50),
    gender            varchar(256),
    dob               timestamp encode az64,
    retirementdate    timestamp encode az64,
    ssn               varchar(256),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
)
    sortkey (personid);

alter table landing_aqe.person
    owner to etluser;

create table if not exists staging_aqe.person
(
    carrier_id            bigint encode az64,
    personid              bigint encode az64 distkey,
    firstname             varchar(256),
    lastname              varchar(256),
    middlename            varchar(256) encode bytedict,
    nameprefix            varchar(50) encode bytedict,
    gender                varchar(256) encode bytedict,
    dob                   timestamp encode az64,
    retirementdate        timestamp encode az64,
    ssn                   varchar(256),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.person
    owner to etluser;

create table if not exists integrated_aqe.person
(
    dw_table_pk          bigint default "identity"(308850, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64,
    personid             bigint encode az64 distkey,
    firstname            varchar(256),
    lastname             varchar(256),
    middlename           varchar(256) encode bytedict,
    nameprefix           varchar(50) encode bytedict,
    gender               varchar(256) encode bytedict,
    dob                  timestamp encode az64,
    retirementdate       timestamp encode az64,
    ssn                  varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.person
    owner to etluser;

grant select on integrated_aqe.person to group named_user_ro;

create table if not exists landing_aqe.agentsalesregionproductmap
(
    carrier_id                   bigint encode az64,
    pkagentsalesregionproductmap bigint encode az64,
    agentsalesregionmapid        double precision,
    productid                    bigint encode az64,
    isdeleted                    boolean,
    miscnotes                    varchar(500),
    refresh_timestamp            timestamp encode az64
);

alter table landing_aqe.agentsalesregionproductmap
    owner to etluser;

create table if not exists staging_aqe.agentsalesregionproductmap
(
    carrier_id                   bigint encode az64,
    pkagentsalesregionproductmap bigint encode az64 distkey,
    agentsalesregionmapid        bigint encode az64,
    productid                    bigint encode az64,
    isdeleted                    boolean,
    miscnotes                    varchar(500),
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char default 'N'::bpchar,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.agentsalesregionproductmap
    owner to etluser;

create table if not exists integrated_aqe.agentsalesregionproductmap
(
    dw_table_pk                  bigint default "identity"(308870, 0, '0,1'::text) encode az64,
    carrier_id                   bigint encode az64 distkey,
    pkagentsalesregionproductmap bigint encode az64,
    agentsalesregionmapid        bigint encode az64,
    productid                    bigint encode az64,
    isdeleted                    boolean,
    miscnotes                    varchar(500),
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agentsalesregionproductmap
    owner to etluser;

grant select on integrated_aqe.agentsalesregionproductmap to group named_user_ro;

create table if not exists landing_aqe.enrollmentstatus
(
    carrier_id                   bigint encode az64,
    enrollmentstatusid           bigint encode az64 distkey,
    enrollmentid                 bigint encode az64,
    datesenttocallcenter         timestamp encode az64,
    datedeliveredtoclient        timestamp,
    sendtoclient                 boolean,
    miscnotes                    varchar(500),
    externalenrollmentstatusid   double precision,
    externalenrollmentstatusdate timestamp encode az64,
    adhocexecution               boolean,
    refresh_timestamp            timestamp encode az64
)
    sortkey (datedeliveredtoclient);

alter table landing_aqe.enrollmentstatus
    owner to etluser;

create table if not exists staging_aqe.enrollmentstatus
(
    carrier_id                   bigint encode az64,
    enrollmentstatusid           bigint encode az64 distkey,
    enrollmentid                 bigint encode az64,
    datesenttocallcenter         timestamp encode az64,
    datedeliveredtoclient        timestamp encode az64,
    sendtoclient                 boolean,
    miscnotes                    varchar(500),
    externalenrollmentstatusid   bigint encode az64,
    externalenrollmentstatusdate timestamp encode az64,
    adhocexecution               boolean,
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char default 'N'::bpchar,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.enrollmentstatus
    owner to etluser;

create table if not exists integrated_aqe.enrollmentstatus
(
    dw_table_pk                  bigint default "identity"(308897, 0, '0,1'::text) encode az64,
    carrier_id                   bigint encode az64,
    enrollmentstatusid           bigint encode az64 distkey,
    enrollmentid                 bigint encode az64,
    datesenttocallcenter         timestamp encode az64,
    datedeliveredtoclient        timestamp encode az64,
    sendtoclient                 boolean,
    miscnotes                    varchar(500) encode bytedict,
    externalenrollmentstatusid   bigint encode az64,
    externalenrollmentstatusdate timestamp encode az64,
    adhocexecution               boolean,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentstatus
    owner to etluser;

grant select on integrated_aqe.enrollmentstatus to group named_user_ro;

create table if not exists landing_aqe.enrollmentpharmacymap
(
    carrier_id              bigint encode az64,
    enrollmentpharmacymapid bigint encode az64,
    enrollmentid            bigint encode az64 distkey,
    pharmacynpi             varchar(50),
    innetwork               boolean,
    pharmacyname            varchar(256),
    retail                  boolean,
    mailorder               boolean,
    prefretail              boolean,
    prefmailorder           boolean,
    distance                double precision,
    miscnotes               varchar(256),
    validfrom               timestamp,
    validto                 timestamp encode az64,
    refresh_timestamp       timestamp encode az64
)
    sortkey (validfrom);

alter table landing_aqe.enrollmentpharmacymap
    owner to etluser;

create table if not exists staging_aqe.enrollmentpharmacymap
(
    carrier_id              bigint encode az64,
    enrollmentpharmacymapid bigint encode az64,
    enrollmentid            bigint encode az64 distkey,
    pharmacynpi             varchar(50),
    innetwork               boolean,
    pharmacyname            varchar(256),
    retail                  boolean,
    mailorder               boolean,
    prefretail              boolean,
    prefmailorder           boolean,
    distance                double precision,
    miscnotes               varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    refresh_timestamp       timestamp encode az64,
    data_action_indicator   char default 'N'::bpchar,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table staging_aqe.enrollmentpharmacymap
    owner to etluser;

create table if not exists integrated_aqe.enrollmentpharmacymap
(
    dw_table_pk             bigint default "identity"(308940, 0, '0,1'::text) encode az64,
    carrier_id              bigint encode az64 distkey,
    enrollmentpharmacymapid bigint encode az64,
    enrollmentid            bigint encode az64,
    pharmacynpi             varchar(50),
    innetwork               boolean,
    pharmacyname            varchar(256),
    retail                  boolean,
    mailorder               boolean,
    prefretail              boolean,
    prefmailorder           boolean,
    distance                double precision,
    miscnotes               varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentpharmacymap
    owner to etluser;

grant select on integrated_aqe.enrollmentpharmacymap to group named_user_ro;

create table if not exists landing_aqe.enrollmentprovidermap
(
    carrier_id                bigint encode az64,
    enrollmentprovidermapid   bigint,
    enrollmentid              bigint encode az64 distkey,
    clientlocationidentifier  varchar(50),
    npi                       varchar(50),
    isapplicantpcp            boolean,
    specialization            varchar(100),
    firstname                 varchar(128),
    lastname                  varchar(128),
    locationname              varchar(256),
    street1                   varchar(256),
    street2                   varchar(256),
    city                      varchar(256),
    state                     varchar(256),
    zip                       varchar(256),
    phonenumber               varchar(50),
    groupname                 varchar(500),
    currentpatient            boolean,
    innetwork                 boolean,
    miscnotes                 varchar(500),
    zelisproviderenrollmentid varchar(20),
    pcpselectedbybeneficiary  boolean,
    isprovidermanuallyentered boolean,
    refresh_timestamp         timestamp encode az64
)
    sortkey (enrollmentprovidermapid);

alter table landing_aqe.enrollmentprovidermap
    owner to etluser;

create table if not exists staging_aqe.enrollmentprovidermap
(
    carrier_id                bigint encode az64,
    enrollmentprovidermapid   bigint encode az64,
    enrollmentid              bigint encode az64 distkey,
    clientlocationidentifier  varchar(50),
    npi                       varchar(50),
    isapplicantpcp            boolean,
    specialization            varchar(100),
    firstname                 varchar(128),
    lastname                  varchar(128),
    locationname              varchar(256),
    street1                   varchar(256),
    street2                   varchar(256),
    city                      varchar(256),
    state                     varchar(256),
    zip                       varchar(256),
    phonenumber               varchar(50),
    groupname                 varchar(500),
    currentpatient            boolean,
    innetwork                 boolean,
    miscnotes                 varchar(500),
    zelisproviderenrollmentid varchar(20),
    pcpselectedbybeneficiary  boolean,
    isprovidermanuallyentered boolean,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_aqe.enrollmentprovidermap
    owner to etluser;

create table if not exists integrated_aqe.enrollmentprovidermap
(
    dw_table_pk               bigint default "identity"(309196, 0, '0,1'::text) encode az64,
    carrier_id                bigint encode az64 distkey,
    enrollmentprovidermapid   bigint encode az64,
    enrollmentid              bigint encode az64,
    clientlocationidentifier  varchar(50),
    npi                       varchar(50),
    isapplicantpcp            boolean,
    specialization            varchar(100),
    firstname                 varchar(128),
    lastname                  varchar(128),
    locationname              varchar(256),
    street1                   varchar(256),
    street2                   varchar(256),
    city                      varchar(256),
    state                     varchar(256) encode bytedict,
    zip                       varchar(256),
    phonenumber               varchar(50),
    groupname                 varchar(500),
    currentpatient            boolean,
    innetwork                 boolean,
    miscnotes                 varchar(500),
    zelisproviderenrollmentid varchar(20),
    pcpselectedbybeneficiary  boolean,
    isprovidermanuallyentered boolean,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentprovidermap
    owner to etluser;

grant select on integrated_aqe.enrollmentprovidermap to group named_user_ro;

create table if not exists landing_aqe.agentsalesregionmap
(
    carrier_id            bigint encode az64 distkey,
    agentsalesregionmapid bigint,
    agentid               bigint encode az64,
    salesregionid         bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64
)
    sortkey (agentsalesregionmapid);

alter table landing_aqe.agentsalesregionmap
    owner to etluser;

create table if not exists staging_aqe.agentsalesregionmap
(
    carrier_id            bigint encode az64 distkey,
    agentsalesregionmapid bigint encode az64,
    agentid               bigint encode az64,
    salesregionid         bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.agentsalesregionmap
    owner to etluser;

create table if not exists integrated_aqe.agentsalesregionmap
(
    dw_table_pk           bigint default "identity"(309206, 0, '0,1'::text) encode az64,
    carrier_id            bigint encode az64 distkey,
    agentsalesregionmapid bigint encode az64,
    agentid               bigint encode az64,
    salesregionid         bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500) encode bytedict,
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agentsalesregionmap
    owner to etluser;

grant select on integrated_aqe.agentsalesregionmap to group named_user_ro;

create table if not exists landing_aqe.carrierfeaturemap
(
    carrierfeaturemapid bigint,
    carrierid           bigint encode az64 distkey,
    featureid           bigint encode az64,
    isenabled           boolean,
    miscnotes           varchar(500),
    refresh_timestamp   timestamp encode az64
)
    sortkey (carrierfeaturemapid);

alter table landing_aqe.carrierfeaturemap
    owner to etluser;

create table if not exists staging_aqe.carrierfeaturemap
(
    carrierfeaturemapid   bigint encode az64,
    carrierid             bigint encode az64 distkey,
    featureid             bigint encode az64,
    isenabled             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.carrierfeaturemap
    owner to etluser;

create table if not exists integrated_aqe.carrierfeaturemap
(
    dw_table_pk          bigint default "identity"(309272, 0, '0,1'::text) encode az64,
    carrierfeaturemapid  bigint encode az64,
    carrierid            bigint encode az64 distkey,
    featureid            bigint encode az64,
    isenabled            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.carrierfeaturemap
    owner to etluser;

grant select on integrated_aqe.carrierfeaturemap to group named_user_ro;

create table if not exists landing_aqe.feature
(
    featureid         bigint encode az64,
    name              varchar(100),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.feature
    owner to etluser;

create table if not exists staging_aqe.feature
(
    featureid             bigint encode az64,
    name                  varchar(100),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.feature
    owner to etluser;

create table if not exists integrated_aqe.feature
(
    dw_table_pk          bigint default "identity"(309282, 0, '0,1'::text) encode az64,
    featureid            bigint encode az64,
    name                 varchar(100),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.feature
    owner to etluser;

grant select on integrated_aqe.feature to group named_user_ro;

create table if not exists landing_aqe.payer
(
    payerid           bigint encode az64,
    payername         varchar(256),
    isactive          boolean,
    miscnotes         varchar(500),
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.payer
    owner to etluser;

create table if not exists staging_aqe.payer
(
    payerid               bigint encode az64,
    payername             varchar(256),
    isactive              boolean,
    miscnotes             varchar(500),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.payer
    owner to etluser;

create table if not exists integrated_aqe.payer
(
    dw_table_pk          bigint default "identity"(309292, 0, '0,1'::text) encode az64,
    payerid              bigint encode az64,
    payername            varchar(256),
    isactive             boolean,
    miscnotes            varchar(500),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.payer
    owner to etluser;

grant select on integrated_aqe.payer to group named_user_ro;

create table if not exists landing_aqe.product
(
    productid                   bigint encode az64,
    carrierid                   bigint encode az64,
    name                        varchar(256),
    producttypeid               double precision,
    additionalquestionsformid   double precision,
    premiummodifierequation     varchar(256),
    miscnotes                   varchar(500),
    displayorder                double precision,
    partialappexpiry            double precision,
    partialapplinkexpiry        double precision,
    isdeleted                   boolean,
    externalapisubmissionsusage boolean,
    subcarrierid                double precision,
    payerid                     double precision,
    refresh_timestamp           timestamp encode az64
);

alter table landing_aqe.product
    owner to etluser;

create table if not exists staging_aqe.product
(
    productid                   bigint encode az64,
    carrierid                   bigint encode az64,
    name                        varchar(256),
    producttypeid               bigint encode az64,
    additionalquestionsformid   bigint encode az64,
    premiummodifierequation     varchar(256),
    miscnotes                   varchar(500),
    displayorder                bigint encode az64,
    partialappexpiry            bigint encode az64,
    partialapplinkexpiry        bigint encode az64,
    isdeleted                   boolean,
    externalapisubmissionsusage boolean,
    subcarrierid                bigint encode az64 distkey,
    payerid                     bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_aqe.product
    owner to etluser;

create table if not exists integrated_aqe.product
(
    dw_table_pk                 bigint default "identity"(309324, 0, '0,1'::text) encode az64,
    productid                   bigint encode az64,
    carrierid                   bigint encode az64,
    name                        varchar(256),
    producttypeid               bigint encode az64,
    additionalquestionsformid   bigint encode az64,
    premiummodifierequation     varchar(256),
    miscnotes                   varchar(500),
    displayorder                bigint encode az64,
    partialappexpiry            bigint encode az64,
    partialapplinkexpiry        bigint encode az64,
    isdeleted                   boolean,
    externalapisubmissionsusage boolean,
    subcarrierid                bigint encode az64 distkey,
    payerid                     bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table integrated_aqe.product
    owner to etluser;

grant select on integrated_aqe.product to group named_user_ro;

create table if not exists landing_aqe.agentuserrole
(
    agentuserroleid   bigint encode az64,
    name              varchar(100),
    isdeleted         boolean,
    miscnotes         varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.agentuserrole
    owner to etluser;

create table if not exists staging_aqe.agentuserrole
(
    agentuserroleid       bigint encode az64,
    name                  varchar(100),
    isdeleted             boolean,
    miscnotes             varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.agentuserrole
    owner to etluser;

create table if not exists integrated_aqe.agentuserrole
(
    dw_table_pk          bigint default "identity"(309340, 0, '0,1'::text) encode az64,
    agentuserroleid      bigint encode az64,
    name                 varchar(100),
    isdeleted            boolean,
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.agentuserrole
    owner to etluser;

grant select on integrated_aqe.agentuserrole to group named_user_ro;

create table if not exists landing_aqe.carrier
(
    carrierid             bigint encode az64,
    name                  varchar(256),
    databaseserver        varchar(256),
    databasename          varchar(256),
    dbconnectionstring    varchar(256),
    emailaddress          varchar(75),
    emailname             varchar(75),
    bestigebaseurl        varchar(75),
    miscnotes             varchar(500),
    isdeleted             boolean,
    ismultitenant         boolean,
    isdeletedforreporting boolean,
    refresh_timestamp     timestamp encode az64
);

alter table landing_aqe.carrier
    owner to etluser;

create table if not exists staging_aqe.carrier
(
    carrierid             bigint encode az64 distkey,
    name                  varchar(256),
    databaseserver        varchar(256),
    databasename          varchar(256),
    dbconnectionstring    varchar(256),
    emailaddress          varchar(75),
    emailname             varchar(75),
    bestigebaseurl        varchar(75),
    miscnotes             varchar(500),
    isdeleted             boolean,
    ismultitenant         boolean,
    isdeletedforreporting boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.carrier
    owner to etluser;

create table if not exists integrated_aqe.carrier
(
    dw_table_pk           bigint default "identity"(309350, 0, '0,1'::text) encode az64,
    carrierid             bigint encode az64 distkey,
    name                  varchar(256),
    databaseserver        varchar(256),
    databasename          varchar(256),
    dbconnectionstring    varchar(256),
    emailaddress          varchar(75),
    emailname             varchar(75),
    bestigebaseurl        varchar(75),
    miscnotes             varchar(500),
    isdeleted             boolean,
    ismultitenant         boolean,
    isdeletedforreporting boolean,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_aqe.carrier
    owner to etluser;

grant select on integrated_aqe.carrier to group named_user_ro;

create table if not exists landing_aqe.carrierbepayermap
(
    carrierbepayermap bigint encode az64,
    carrierid         bigint encode az64,
    beid              bigint encode az64,
    payerid           double precision,
    isactive          boolean,
    miscnotes         varchar(500),
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.carrierbepayermap
    owner to etluser;

create table if not exists staging_aqe.carrierbepayermap
(
    carrierbepayermap     bigint encode az64,
    carrierid             bigint encode az64,
    beid                  bigint encode az64 distkey,
    payerid               bigint encode az64,
    isactive              boolean,
    miscnotes             varchar(500),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.carrierbepayermap
    owner to etluser;

create table if not exists integrated_aqe.carrierbepayermap
(
    dw_table_pk          bigint default "identity"(309360, 0, '0,1'::text) encode az64,
    carrierbepayermap    bigint encode az64,
    carrierid            bigint encode az64,
    beid                 bigint encode az64 distkey,
    payerid              bigint encode az64,
    isactive             boolean,
    miscnotes            varchar(500),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.carrierbepayermap
    owner to etluser;

grant select on integrated_aqe.carrierbepayermap to group named_user_ro;

create table if not exists landing_aqe.plans
(
    carrier_id                       bigint encode az64,
    planid                           bigint,
    productid                        bigint encode az64,
    name                             varchar(256),
    coveragetype                     varchar(256),
    plantype                         bigint encode az64,
    contract                         varchar(50),
    pbp_id                           varchar(10),
    segment_id                       varchar(10),
    extended_description             varchar(500),
    premiumdescription               varchar(50),
    premiumvalue                     double precision,
    paymentfrequency                 varchar(50),
    enrollmentactive                 boolean,
    planorder                        double precision,
    compareorder                     double precision,
    planyear                         double precision,
    miscnotes                        varchar(500),
    enrollmentpremiumdescription     varchar(500),
    isdeleted                        boolean,
    partialappexpiry                 double precision,
    partialapplinkexpiry             double precision,
    ishraenabled                     boolean,
    isawvenabled                     boolean,
    partdpremiumvalue                double precision,
    premiumdisclaimertext            varchar(1024),
    bestigepath                      varchar(256),
    bestigeplanid                    double precision distkey,
    partcpremiumvalue                double precision,
    brandname                        varchar(256),
    providerinoutindicatortext       boolean,
    isvisibleforagent                boolean,
    isvisibleforconsumer             boolean,
    excludefromcopaylvlpremiumcalc   boolean,
    isvbeenabled                     boolean,
    confirmationpagebuttonvisibility boolean,
    addmemberpagebuttonvisibility    boolean,
    vbesearchpagebuttonvisibility    boolean,
    isdocumentuploadavailable        boolean,
    isvisibleonaddmemberpage         boolean,
    isnewplan                        boolean,
    rtsplantypeid                    double precision,
    refresh_timestamp                timestamp encode az64
)
    sortkey (planid);

alter table landing_aqe.plans
    owner to etluser;

create table if not exists staging_aqe.plans
(
    carrier_id                       bigint encode az64 distkey,
    planid                           bigint encode az64,
    productid                        bigint encode az64,
    name                             varchar(256),
    coveragetype                     varchar(256),
    plantype                         bigint encode az64,
    contract                         varchar(50),
    pbp_id                           varchar(10),
    segment_id                       varchar(10),
    extended_description             varchar(500),
    premiumdescription               varchar(50),
    premiumvalue                     double precision,
    paymentfrequency                 varchar(50),
    enrollmentactive                 boolean,
    planorder                        bigint encode az64,
    compareorder                     bigint encode az64,
    planyear                         bigint encode az64,
    miscnotes                        varchar(500),
    enrollmentpremiumdescription     varchar(500),
    isdeleted                        boolean,
    partialappexpiry                 bigint encode az64,
    partialapplinkexpiry             bigint encode az64,
    ishraenabled                     boolean,
    isawvenabled                     boolean,
    partdpremiumvalue                double precision,
    premiumdisclaimertext            varchar(1024),
    bestigepath                      varchar(256),
    bestigeplanid                    bigint encode az64,
    partcpremiumvalue                double precision,
    brandname                        varchar(256),
    providerinoutindicatortext       boolean,
    isvisibleforagent                boolean,
    isvisibleforconsumer             boolean,
    excludefromcopaylvlpremiumcalc   boolean,
    isvbeenabled                     boolean,
    confirmationpagebuttonvisibility boolean,
    addmemberpagebuttonvisibility    boolean,
    vbesearchpagebuttonvisibility    boolean,
    isdocumentuploadavailable        boolean,
    isvisibleonaddmemberpage         boolean,
    isnewplan                        boolean,
    rtsplantypeid                    bigint encode az64,
    refresh_timestamp                timestamp encode az64,
    data_action_indicator            char default 'N'::bpchar,
    data_transfer_log_id             bigint encode az64,
    md5_hash                         varchar(32)
);

alter table staging_aqe.plans
    owner to etluser;

create table if not exists integrated_aqe.plans
(
    dw_table_pk                      bigint default "identity"(309410, 0, '0,1'::text) encode az64,
    carrier_id                       bigint encode az64 distkey,
    planid                           bigint encode az64,
    productid                        bigint encode az64,
    name                             varchar(256),
    coveragetype                     varchar(256),
    plantype                         bigint encode az64,
    contract                         varchar(50),
    pbp_id                           varchar(10),
    segment_id                       varchar(10),
    extended_description             varchar(500),
    premiumdescription               varchar(50),
    premiumvalue                     double precision,
    paymentfrequency                 varchar(50),
    enrollmentactive                 boolean,
    planorder                        bigint encode az64,
    compareorder                     bigint encode az64,
    planyear                         bigint encode az64,
    miscnotes                        varchar(500),
    enrollmentpremiumdescription     varchar(500),
    isdeleted                        boolean,
    partialappexpiry                 bigint encode az64,
    partialapplinkexpiry             bigint encode az64,
    ishraenabled                     boolean,
    isawvenabled                     boolean,
    partdpremiumvalue                double precision,
    premiumdisclaimertext            varchar(1024),
    bestigepath                      varchar(256),
    bestigeplanid                    bigint encode az64,
    partcpremiumvalue                double precision,
    brandname                        varchar(256),
    providerinoutindicatortext       boolean,
    isvisibleforagent                boolean,
    isvisibleforconsumer             boolean,
    excludefromcopaylvlpremiumcalc   boolean,
    isvbeenabled                     boolean,
    confirmationpagebuttonvisibility boolean,
    addmemberpagebuttonvisibility    boolean,
    vbesearchpagebuttonvisibility    boolean,
    isdocumentuploadavailable        boolean,
    isvisibleonaddmemberpage         boolean,
    isnewplan                        boolean,
    rtsplantypeid                    bigint encode az64,
    refresh_timestamp                timestamp,
    data_transfer_log_id             bigint encode az64,
    md5_hash                         varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.plans
    owner to etluser;

grant select on integrated_aqe.plans to group named_user_ro;

create table if not exists landing_aqe.enrollment
(
    carrier_id             bigint encode az64,
    enrollmentid           bigint encode az64 distkey,
    enrollmentdate         timestamp,
    agentid                varchar(300),
    enrollmentformid       bigint encode az64,
    rawdata                varchar(256),
    startdate              timestamp encode az64,
    planid                 bigint encode az64,
    agentfirstname         varchar(50),
    agentlastname          varchar(50),
    agentemail             varchar(300),
    agenturl               varchar(100),
    userid                 double precision,
    premium                numeric(18, 2) encode az64,
    applicationtype        varchar(50),
    sendtounderwriter      boolean,
    planyear               double precision,
    pharmacynpi            double precision,
    scopeofappointmentid   varchar(50),
    providernpi            double precision,
    confirmationid         varchar(50),
    externalleadid         varchar(50),
    ascendleadid           double precision,
    ascendmeetingid        double precision,
    beid                   double precision,
    miscnotes              varchar(500),
    browser                varchar(300),
    bluebuttonpatientid    varchar(300),
    requestedeffectivedate date encode az64,
    agentnpn               varchar(100),
    agentawn               varchar(100),
    ipaddress              varchar(50),
    useragent              varchar(1024),
    refresh_timestamp      timestamp encode az64
)
    sortkey (enrollmentdate);

alter table landing_aqe.enrollment
    owner to etluser;

create table if not exists staging_aqe.enrollment
(
    carrier_id             bigint encode az64,
    enrollmentid           bigint encode az64 distkey,
    enrollmentdate         timestamp encode az64,
    agentid                varchar(300),
    enrollmentformid       bigint encode az64,
    rawdata                varchar(256),
    startdate              timestamp encode az64,
    planid                 bigint encode az64,
    agentfirstname         varchar(50),
    agentlastname          varchar(50),
    agentemail             varchar(300),
    agenturl               varchar(100),
    userid                 bigint encode az64,
    premium                numeric(18, 2) encode az64,
    applicationtype        varchar(50),
    sendtounderwriter      boolean,
    planyear               bigint encode az64,
    pharmacynpi            bigint encode az64,
    scopeofappointmentid   varchar(50),
    providernpi            bigint encode az64,
    confirmationid         varchar(50),
    externalleadid         varchar(50),
    ascendleadid           bigint encode az64,
    ascendmeetingid        bigint encode az64,
    beid                   bigint encode az64,
    miscnotes              varchar(500),
    browser                varchar(300),
    bluebuttonpatientid    varchar(300),
    requestedeffectivedate date encode az64,
    agentnpn               varchar(100),
    agentawn               varchar(100),
    ipaddress              varchar(50),
    useragent              varchar(1024),
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_aqe.enrollment
    owner to etluser;

create table if not exists integrated_aqe.enrollment
(
    dw_table_pk            bigint default "identity"(309471, 0, '0,1'::text) encode az64,
    carrier_id             bigint encode az64 distkey,
    enrollmentid           bigint encode az64,
    enrollmentdate         timestamp encode az64,
    agentid                varchar(300),
    enrollmentformid       bigint encode az64,
    rawdata                varchar(256),
    startdate              timestamp encode az64,
    planid                 bigint encode az64,
    agentfirstname         varchar(50),
    agentlastname          varchar(50),
    agentemail             varchar(300),
    agenturl               varchar(100),
    userid                 bigint encode az64,
    premium                numeric(18, 2) encode az64,
    applicationtype        varchar(50) encode bytedict,
    sendtounderwriter      boolean,
    planyear               bigint encode az64,
    pharmacynpi            bigint encode az64,
    scopeofappointmentid   varchar(50),
    providernpi            bigint encode az64,
    confirmationid         varchar(50),
    externalleadid         varchar(50),
    ascendleadid           bigint encode az64,
    ascendmeetingid        bigint encode az64,
    beid                   bigint encode az64,
    miscnotes              varchar(500),
    browser                varchar(300),
    bluebuttonpatientid    varchar(300),
    requestedeffectivedate date encode az64,
    agentnpn               varchar(100),
    agentawn               varchar(100),
    ipaddress              varchar(50),
    useragent              varchar(1024),
    refresh_timestamp      timestamp,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollment
    owner to etluser;

grant select on integrated_aqe.enrollment to group named_user_ro;

create table if not exists landing_aqe.actiontracking
(
    carrier_id          bigint encode az64 distkey,
    actiontrackingid    bigint encode az64,
    memberinformationid double precision,
    buttonid            double precision,
    vbeactionid         double precision,
    actiondatetime      timestamp encode az64,
    ascenduserid        double precision,
    isactioncomplete    boolean,
    miscnotes           varchar(500),
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.actiontracking
    owner to etluser;

create table if not exists staging_aqe.actiontracking
(
    carrier_id            bigint encode az64,
    actiontrackingid      bigint encode az64,
    memberinformationid   bigint encode az64,
    buttonid              bigint encode az64,
    vbeactionid           bigint encode az64,
    actiondatetime        timestamp encode az64,
    ascenduserid          bigint encode az64 distkey,
    isactioncomplete      boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.actiontracking
    owner to etluser;

create table if not exists integrated_aqe.actiontracking
(
    dw_table_pk          bigint default "identity"(309500, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    actiontrackingid     bigint encode az64,
    memberinformationid  bigint encode az64,
    buttonid             bigint encode az64,
    vbeactionid          bigint encode az64,
    actiondatetime       timestamp encode az64,
    ascenduserid         bigint encode az64,
    isactioncomplete     boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.actiontracking
    owner to etluser;

grant select on integrated_aqe.actiontracking to group named_user_ro;

create table if not exists landing_aqe.awvinformation
(
    carrier_id          bigint encode az64,
    awvinformationid    bigint encode az64,
    memberinformationid bigint encode az64 distkey,
    awvstatusid         bigint encode az64,
    miscnotes           varchar(500),
    statusupdatedate    timestamp,
    providername        varchar(100),
    appointmentdate     timestamp encode az64,
    npi                 double precision,
    confirmeddate       timestamp encode az64,
    pcpphone            varchar(10),
    pcpstreet1          varchar(256),
    pcpstreet2          varchar(256),
    pcpcity             varchar(100),
    pcpstate            varchar(2),
    pcpzip              varchar(10),
    timezone            varchar(100),
    ascenduserid        double precision,
    buttonid            double precision,
    actionid            double precision,
    refresh_timestamp   timestamp encode az64
)
    sortkey (statusupdatedate);

alter table landing_aqe.awvinformation
    owner to etluser;

create table if not exists staging_aqe.awvinformation
(
    carrier_id            bigint encode az64,
    awvinformationid      bigint encode az64,
    memberinformationid   bigint encode az64,
    awvstatusid           bigint encode az64,
    miscnotes             varchar(500),
    statusupdatedate      timestamp encode az64,
    providername          varchar(100),
    appointmentdate       timestamp encode az64,
    npi                   bigint encode az64,
    confirmeddate         timestamp encode az64,
    pcpphone              varchar(10),
    pcpstreet1            varchar(256),
    pcpstreet2            varchar(256),
    pcpcity               varchar(100),
    pcpstate              varchar(2),
    pcpzip                varchar(10),
    timezone              varchar(100),
    ascenduserid          bigint encode az64 distkey,
    buttonid              bigint encode az64,
    actionid              bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.awvinformation
    owner to etluser;

create table if not exists integrated_aqe.awvinformation
(
    dw_table_pk          bigint default "identity"(309525, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    awvinformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    awvstatusid          bigint encode az64,
    miscnotes            varchar(500),
    statusupdatedate     timestamp encode az64,
    providername         varchar(100),
    appointmentdate      timestamp encode az64,
    npi                  bigint encode az64,
    confirmeddate        timestamp encode az64,
    pcpphone             varchar(10),
    pcpstreet1           varchar(256),
    pcpstreet2           varchar(256),
    pcpcity              varchar(100),
    pcpstate             varchar(2),
    pcpzip               varchar(10),
    timezone             varchar(100),
    ascenduserid         bigint encode az64,
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.awvinformation
    owner to etluser;

grant select on integrated_aqe.awvinformation to group named_user_ro;

create table if not exists landing_aqe.hrainformation
(
    carrier_id          bigint encode az64,
    hrainformationid    bigint encode az64,
    memberinformationid bigint encode az64 distkey,
    formsubmissionid    double precision,
    hrastatusid         bigint encode az64,
    dynamicinformation  varchar(256),
    statusupdatedate    timestamp encode az64,
    ascenduserid        double precision,
    miscnotes           varchar(500),
    buttonid            double precision,
    actionid            double precision,
    savetotable         boolean,
    senttofile          boolean,
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.hrainformation
    owner to etluser;

create table if not exists staging_aqe.hrainformation
(
    carrier_id            bigint encode az64,
    hrainformationid      bigint encode az64,
    memberinformationid   bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    hrastatusid           bigint encode az64,
    dynamicinformation    varchar(256),
    statusupdatedate      timestamp encode az64,
    ascenduserid          bigint encode az64,
    miscnotes             varchar(500),
    buttonid              bigint encode az64,
    actionid              bigint encode az64,
    savetotable           boolean,
    senttofile            boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.hrainformation
    owner to etluser;

create table if not exists integrated_aqe.hrainformation
(
    dw_table_pk          bigint default "identity"(309550, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    hrainformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    formsubmissionid     bigint encode az64,
    hrastatusid          bigint encode az64,
    dynamicinformation   varchar(256),
    statusupdatedate     timestamp encode az64,
    ascenduserid         bigint encode az64,
    miscnotes            varchar(500),
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    savetotable          boolean,
    senttofile           boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.hrainformation
    owner to etluser;

grant select on integrated_aqe.hrainformation to group named_user_ro;

create table if not exists landing_aqe.awvinformationstatushistory
(
    carrier_id                    bigint encode az64,
    aveinformationstatushistoryid bigint encode az64 distkey,
    awvinformationid              bigint encode az64,
    awvstatusid                   bigint encode az64,
    statusupdatedate              timestamp,
    ascenduserid                  double precision,
    buttonid                      double precision,
    actionid                      double precision,
    refresh_timestamp             timestamp encode az64
)
    sortkey (statusupdatedate);

alter table landing_aqe.awvinformationstatushistory
    owner to etluser;

create table if not exists staging_aqe.awvinformationstatushistory
(
    carrier_id                    bigint encode az64,
    aveinformationstatushistoryid bigint encode az64,
    awvinformationid              bigint encode az64,
    awvstatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64 distkey,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.awvinformationstatushistory
    owner to etluser;

create table if not exists integrated_aqe.awvinformationstatushistory
(
    dw_table_pk                   bigint default "identity"(309576, 0, '0,1'::text) encode az64,
    carrier_id                    bigint encode az64 distkey,
    aveinformationstatushistoryid bigint encode az64,
    awvinformationid              bigint encode az64,
    awvstatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.awvinformationstatushistory
    owner to etluser;

grant select on integrated_aqe.awvinformationstatushistory to group named_user_ro;

create table if not exists landing_aqe.applicationstatus
(
    applicationstatusid          bigint encode az64,
    applicationstatusdescription varchar(100),
    refresh_timestamp            timestamp encode az64
);

alter table landing_aqe.applicationstatus
    owner to etluser;

create table if not exists staging_aqe.applicationstatus
(
    applicationstatusid          bigint encode az64,
    applicationstatusdescription varchar(100),
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char default 'N'::bpchar,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.applicationstatus
    owner to etluser;

create table if not exists integrated_aqe.applicationstatus
(
    dw_table_pk                  bigint default "identity"(342993, 0, '0,1'::text) encode az64,
    applicationstatusid          bigint encode az64,
    applicationstatusdescription varchar(100),
    refresh_timestamp            timestamp encode az64,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table integrated_aqe.applicationstatus
    owner to etluser;

grant select on integrated_aqe.applicationstatus to group named_user_ro;

create table if not exists landing_aqe.applicationtype
(
    applicationtypeid bigint encode az64,
    name              varchar(50),
    description       varchar(500),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.applicationtype
    owner to etluser;

create table if not exists staging_aqe.applicationtype
(
    applicationtypeid     bigint encode az64,
    name                  varchar(50),
    description           varchar(500),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.applicationtype
    owner to etluser;

create table if not exists integrated_aqe.applicationtype
(
    dw_table_pk          bigint default "identity"(343010, 0, '0,1'::text) encode az64,
    applicationtypeid    bigint encode az64,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.applicationtype
    owner to etluser;

grant select on integrated_aqe.applicationtype to group named_user_ro;

create table if not exists landing_aqe.awvstatuscode
(
    awvstatuscodeid   bigint encode az64,
    name              varchar(50),
    description       varchar(500),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.awvstatuscode
    owner to etluser;

create table if not exists staging_aqe.awvstatuscode
(
    awvstatuscodeid       bigint encode az64 distkey,
    name                  varchar(50),
    description           varchar(500),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.awvstatuscode
    owner to etluser;

create table if not exists integrated_aqe.awvstatuscode
(
    dw_table_pk          bigint default "identity"(343020, 0, '0,1'::text) encode az64,
    awvstatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.awvstatuscode
    owner to etluser;

grant select on integrated_aqe.awvstatuscode to group named_user_ro;

create table if not exists landing_aqe.buttontype
(
    buttontypeid      bigint encode az64,
    type              varchar(50),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.buttontype
    owner to etluser;

create table if not exists staging_aqe.buttontype
(
    buttontypeid          bigint encode az64,
    type                  varchar(50),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.buttontype
    owner to etluser;

create table if not exists integrated_aqe.buttontype
(
    dw_table_pk          bigint default "identity"(343046, 0, '0,1'::text) encode az64,
    buttontypeid         bigint encode az64,
    type                 varchar(50),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.buttontype
    owner to etluser;

grant select on integrated_aqe.buttontype to group named_user_ro;

create table if not exists landing_aqe.hrastatuscode
(
    hrastatuscodeid   bigint encode az64,
    name              varchar(50),
    description       varchar(500),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.hrastatuscode
    owner to etluser;

create table if not exists staging_aqe.hrastatuscode
(
    hrastatuscodeid       bigint encode az64 distkey,
    name                  varchar(50),
    description           varchar(500),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.hrastatuscode
    owner to etluser;

create table if not exists integrated_aqe.hrastatuscode
(
    dw_table_pk          bigint default "identity"(343065, 0, '0,1'::text) encode az64,
    hrastatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.hrastatuscode
    owner to etluser;

grant select on integrated_aqe.hrastatuscode to group named_user_ro;

create table if not exists landing_aqe.preferredmethodsofcontact
(
    pkpreferredmethodsofcontact bigint encode az64,
    contactmethodname           varchar(100),
    isdeleted                   boolean,
    miscnotes                   varchar(256),
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64
);

alter table landing_aqe.preferredmethodsofcontact
    owner to etluser;

create table if not exists staging_aqe.preferredmethodsofcontact
(
    pkpreferredmethodsofcontact bigint encode az64,
    contactmethodname           varchar(100),
    isdeleted                   boolean,
    miscnotes                   varchar(256),
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_aqe.preferredmethodsofcontact
    owner to etluser;

create table if not exists integrated_aqe.preferredmethodsofcontact
(
    dw_table_pk                 bigint default "identity"(343075, 0, '0,1'::text) encode az64,
    pkpreferredmethodsofcontact bigint encode az64,
    contactmethodname           varchar(100),
    isdeleted                   boolean,
    miscnotes                   varchar(256),
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table integrated_aqe.preferredmethodsofcontact
    owner to etluser;

grant select on integrated_aqe.preferredmethodsofcontact to group named_user_ro;

create table if not exists landing_aqe.vbeactions
(
    vbeactionid          bigint encode az64,
    vbeactionname        varchar(256),
    vbeactiondescription varchar(256),
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.vbeactions
    owner to etluser;

create table if not exists staging_aqe.vbeactions
(
    vbeactionid           bigint encode az64,
    vbeactionname         varchar(256),
    vbeactiondescription  varchar(256),
    miscnotes             varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.vbeactions
    owner to etluser;

create table if not exists integrated_aqe.vbeactions
(
    dw_table_pk          bigint default "identity"(343101, 0, '0,1'::text) encode az64,
    vbeactionid          bigint encode az64,
    vbeactionname        varchar(256),
    vbeactiondescription varchar(256),
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.vbeactions
    owner to etluser;

grant select on integrated_aqe.vbeactions to group named_user_ro;

create table if not exists landing_aqe.vbestatuscode
(
    vbestatuscodeid   bigint encode az64,
    name              varchar(50),
    description       varchar(500),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.vbestatuscode
    owner to etluser;

create table if not exists staging_aqe.vbestatuscode
(
    vbestatuscodeid       bigint distkey,
    name                  varchar(50),
    description           varchar(500),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    sortkey (vbestatuscodeid);

alter table staging_aqe.vbestatuscode
    owner to etluser;

create table if not exists integrated_aqe.vbestatuscode
(
    dw_table_pk          bigint default "identity"(343111, 0, '0,1'::text) encode az64,
    vbestatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.vbestatuscode
    owner to etluser;

grant select on integrated_aqe.vbestatuscode to group named_user_ro;

create table if not exists landing_aqe.contactinfotype
(
    contactinfotypeid bigint encode az64,
    type              varchar(256),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.contactinfotype
    owner to etluser;

create table if not exists staging_aqe.contactinfotype
(
    contactinfotypeid     bigint encode az64,
    type                  varchar(256),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.contactinfotype
    owner to etluser;

create table if not exists integrated_aqe.contactinfotype
(
    dw_table_pk          bigint default "identity"(343145, 0, '0,1'::text) encode az64,
    contactinfotypeid    bigint encode az64,
    type                 varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.contactinfotype
    owner to etluser;

grant select on integrated_aqe.contactinfotype to group named_user_ro;

create table if not exists landing_aqe.enrollmentformtype
(
    enrollmentformtypeid          bigint encode az64,
    enrollmentformtypedescription varchar(100),
    miscnotes                     varchar(256),
    refresh_timestamp             timestamp encode az64
);

alter table landing_aqe.enrollmentformtype
    owner to etluser;

create table if not exists staging_aqe.enrollmentformtype
(
    enrollmentformtypeid          bigint encode az64,
    enrollmentformtypedescription varchar(100),
    miscnotes                     varchar(256),
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.enrollmentformtype
    owner to etluser;

create table if not exists integrated_aqe.enrollmentformtype
(
    dw_table_pk                   bigint default "identity"(343162, 0, '0,1'::text) encode az64,
    enrollmentformtypeid          bigint encode az64,
    enrollmentformtypedescription varchar(100),
    miscnotes                     varchar(256),
    refresh_timestamp             timestamp encode az64,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table integrated_aqe.enrollmentformtype
    owner to etluser;

grant select on integrated_aqe.enrollmentformtype to group named_user_ro;

create table if not exists landing_aqe.externaldatasourcetype
(
    externaldatasourcetypeid bigint encode az64,
    name                     varchar(50),
    description              varchar(500),
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64
);

alter table landing_aqe.externaldatasourcetype
    owner to etluser;

create table if not exists staging_aqe.externaldatasourcetype
(
    externaldatasourcetypeid bigint encode az64,
    name                     varchar(50),
    description              varchar(500),
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.externaldatasourcetype
    owner to etluser;

create table if not exists integrated_aqe.externaldatasourcetype
(
    dw_table_pk              bigint default "identity"(343172, 0, '0,1'::text) encode az64,
    externaldatasourcetypeid bigint encode az64,
    name                     varchar(50),
    description              varchar(500),
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table integrated_aqe.externaldatasourcetype
    owner to etluser;

grant select on integrated_aqe.externaldatasourcetype to group named_user_ro;

create table if not exists landing_aqe.dbo_persontype
(
    persontypeid      bigint encode az64,
    type              varchar(256),
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.dbo_persontype
    owner to etluser;

create table if not exists staging_aqe.dbo_persontype
(
    persontypeid          bigint encode az64,
    type                  varchar(256),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.dbo_persontype
    owner to etluser;

create table if not exists integrated_aqe.dbo_persontype
(
    dw_table_pk          bigint default "identity"(343230, 0, '0,1'::text) encode az64,
    persontypeid         bigint encode az64,
    type                 varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.dbo_persontype
    owner to etluser;

grant select on integrated_aqe.dbo_persontype to group named_user_ro;

create table if not exists landing_aqe.plantype
(
    plantypeid          bigint encode az64,
    plantypedescription varchar(500),
    miscnotes           varchar(500),
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.plantype
    owner to etluser;

create table if not exists staging_aqe.plantype
(
    plantypeid            bigint encode az64,
    plantypedescription   varchar(500),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.plantype
    owner to etluser;

create table if not exists integrated_aqe.plantype
(
    dw_table_pk          bigint default "identity"(343241, 0, '0,1'::text) encode az64,
    plantypeid           bigint encode az64,
    plantypedescription  varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.plantype
    owner to etluser;

grant select on integrated_aqe.plantype to group named_user_ro;

create table if not exists landing_aqe.producttype
(
    producttypeid     bigint encode az64,
    name              varchar(50),
    isdeleted         boolean,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.producttype
    owner to etluser;

create table if not exists staging_aqe.producttype
(
    producttypeid         bigint encode az64,
    name                  varchar(50),
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.producttype
    owner to etluser;

create table if not exists integrated_aqe.producttype
(
    dw_table_pk          bigint default "identity"(343277, 0, '0,1'::text) encode az64,
    producttypeid        bigint encode az64,
    name                 varchar(50),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.producttype
    owner to etluser;

grant select on integrated_aqe.producttype to group named_user_ro;

create table if not exists landing_aqe.rtsplantypes
(
    rtsplantypeid        bigint encode az64,
    rtsplantypename      varchar(50),
    producttypeid        double precision,
    isdeleted            boolean,
    miscnotes            varchar(256),
    systemuser_createdby varchar(128),
    systemuser_updatedby varchar(128),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.rtsplantypes
    owner to etluser;

create table if not exists staging_aqe.rtsplantypes
(
    rtsplantypeid         bigint encode az64,
    rtsplantypename       varchar(50),
    producttypeid         bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(256),
    systemuser_createdby  varchar(128),
    systemuser_updatedby  varchar(128),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.rtsplantypes
    owner to etluser;

create table if not exists integrated_aqe.rtsplantypes
(
    dw_table_pk          bigint default "identity"(343287, 0, '0,1'::text) encode az64,
    rtsplantypeid        bigint encode az64,
    rtsplantypename      varchar(50),
    producttypeid        bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(256),
    systemuser_createdby varchar(128),
    systemuser_updatedby varchar(128),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.rtsplantypes
    owner to etluser;

grant select on integrated_aqe.rtsplantypes to group named_user_ro;

create table if not exists landing_aqe.twiliolanguage
(
    twiliolanguageid  bigint encode az64,
    name              varchar(256),
    miscnotes         varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.twiliolanguage
    owner to etluser;

create table if not exists staging_aqe.twiliolanguage
(
    twiliolanguageid      bigint encode az64,
    name                  varchar(256),
    miscnotes             varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.twiliolanguage
    owner to etluser;

create table if not exists integrated_aqe.twiliolanguage
(
    dw_table_pk          bigint default "identity"(344015, 0, '0,1'::text) encode az64,
    twiliolanguageid     bigint encode az64,
    name                 varchar(256),
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.twiliolanguage
    owner to etluser;

grant select on integrated_aqe.twiliolanguage to group named_user_ro;

create table if not exists landing_aqe.sourcesystemtype
(
    sourcesystemtypeid          bigint encode az64,
    sourcesystemtypedescription varchar(100),
    refresh_timestamp           timestamp encode az64
);

alter table landing_aqe.sourcesystemtype
    owner to etluser;

create table if not exists staging_aqe.sourcesystemtype
(
    sourcesystemtypeid          bigint encode az64,
    sourcesystemtypedescription varchar(100),
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_aqe.sourcesystemtype
    owner to etluser;

create table if not exists integrated_aqe.sourcesystemtype
(
    dw_table_pk                 bigint default "identity"(344025, 0, '0,1'::text) encode az64,
    sourcesystemtypeid          bigint encode az64,
    sourcesystemtypedescription varchar(100),
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table integrated_aqe.sourcesystemtype
    owner to etluser;

grant select on integrated_aqe.sourcesystemtype to group named_user_ro;

create table if not exists landing_aqe.contacttype
(
    contacttypeid     bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.contacttype
    owner to etluser;

create table if not exists staging_aqe.contacttype
(
    contacttypeid         bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.contacttype
    owner to etluser;

create table if not exists integrated_aqe.contacttype
(
    dw_table_pk          bigint default "identity"(344049, 0, '0,1'::text) encode az64,
    contacttypeid        bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.contacttype
    owner to etluser;

grant select on integrated_aqe.contacttype to group named_user_ro;

create table if not exists landing_aqe.statustype
(
    statustypeid      bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.statustype
    owner to etluser;

create table if not exists staging_aqe.statustype
(
    statustypeid          bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.statustype
    owner to etluser;

create table if not exists integrated_aqe.statustype
(
    dw_table_pk          bigint default "identity"(344059, 0, '0,1'::text) encode az64,
    statustypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.statustype
    owner to etluser;

grant select on integrated_aqe.statustype to group named_user_ro;

create table if not exists landing_aqe.agentreadytosellstatus
(
    carrier_id               bigint encode az64,
    agentreadytosellstatusid bigint,
    agentid                  bigint encode az64,
    businessentityid         bigint encode az64 distkey,
    payerid                  bigint encode az64,
    planyear                 bigint encode az64,
    state                    varchar(2),
    readytosellflag          boolean,
    isdeleted                boolean,
    author                   varchar(255),
    systemuser_createdby     varchar(128),
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    rtsplantypeid            bigint encode az64,
    refresh_timestamp        timestamp encode az64
)
    sortkey (agentreadytosellstatusid);

alter table landing_aqe.agentreadytosellstatus
    owner to etluser;

create table if not exists staging_aqe.agentreadytosellstatus
(
    carrier_id               bigint encode az64,
    agentreadytosellstatusid bigint encode az64,
    agentid                  bigint encode az64,
    businessentityid         bigint encode az64 distkey,
    payerid                  bigint encode az64,
    planyear                 bigint encode az64,
    state                    varchar(2),
    readytosellflag          boolean,
    isdeleted                boolean,
    author                   varchar(255),
    systemuser_createdby     varchar(128) encode bytedict,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    rtsplantypeid            bigint encode az64,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.agentreadytosellstatus
    owner to etluser;

create table if not exists integrated_aqe.agentreadytosellstatus
(
    dw_table_pk              bigint default "identity"(344188, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64 distkey,
    agentreadytosellstatusid bigint encode az64,
    agentid                  bigint encode az64,
    businessentityid         bigint encode az64,
    payerid                  bigint encode az64,
    planyear                 bigint encode az64,
    state                    varchar(2),
    readytosellflag          boolean,
    isdeleted                boolean,
    author                   varchar(255),
    systemuser_createdby     varchar(128) encode bytedict,
    miscnotes                varchar(256) encode bytedict,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    rtsplantypeid            bigint encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.agentreadytosellstatus
    owner to etluser;

grant select on integrated_aqe.agentreadytosellstatus to group named_user_ro;

create table if not exists landing_aqe.contactinfo
(
    carrier_id        bigint encode az64,
    contactinfoid     bigint encode az64 distkey,
    street1           varchar(256),
    street2           varchar(256),
    city              varchar(256),
    county            varchar(256),
    state             varchar(256),
    zipcode           varchar(256),
    country           varchar(256),
    phone             varchar(256),
    email             varchar(256),
    fax               varchar(256),
    miscnotes         varchar(500),
    secondaryphone    varchar(256),
    refresh_timestamp timestamp encode az64
)
    diststyle key
    sortkey (street2);

alter table landing_aqe.contactinfo
    owner to etluser;

create table if not exists staging_aqe.contactinfo
(
    carrier_id            bigint encode az64 distkey,
    contactinfoid         bigint encode az64,
    street1               varchar(256),
    street2               varchar(256),
    city                  varchar(256),
    county                varchar(256),
    state                 varchar(256) encode bytedict,
    zipcode               varchar(256),
    country               varchar(256),
    phone                 varchar(256),
    email                 varchar(256),
    fax                   varchar(256),
    miscnotes             varchar(500),
    secondaryphone        varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.contactinfo
    owner to etluser;

create table if not exists integrated_aqe.contactinfo
(
    dw_table_pk          bigint default "identity"(344750, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64,
    contactinfoid        bigint encode az64 distkey,
    street1              varchar(256),
    street2              varchar(256),
    city                 varchar(256),
    county               varchar(256),
    state                varchar(256) encode bytedict,
    zipcode              varchar(256),
    country              varchar(256),
    phone                varchar(256),
    email                varchar(256),
    fax                  varchar(256),
    miscnotes            varchar(500),
    secondaryphone       varchar(256),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.contactinfo
    owner to etluser;

grant select on integrated_aqe.contactinfo to group named_user_ro;

create table if not exists landing_aqe.enrollmentbeqresponsemap
(
    carrier_id                 bigint encode az64,
    enrollmentbeqresponsemapid bigint encode az64,
    enrollmentid               double precision,
    beqresponseid              double precision,
    refresh_timestamp          timestamp encode az64
);

alter table landing_aqe.enrollmentbeqresponsemap
    owner to etluser;

create table if not exists staging_aqe.enrollmentbeqresponsemap
(
    carrier_id                 bigint encode az64,
    enrollmentbeqresponsemapid bigint encode az64 distkey,
    enrollmentid               bigint encode az64,
    beqresponseid              bigint encode az64,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_aqe.enrollmentbeqresponsemap
    owner to etluser;

create table if not exists integrated_aqe.enrollmentbeqresponsemap
(
    dw_table_pk                bigint default "identity"(344786, 0, '0,1'::text) encode az64,
    carrier_id                 bigint encode az64 distkey,
    enrollmentbeqresponsemapid bigint encode az64,
    enrollmentid               bigint encode az64,
    beqresponseid              bigint encode az64,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentbeqresponsemap
    owner to etluser;

grant select on integrated_aqe.enrollmentbeqresponsemap to group named_user_ro;

create table if not exists landing_aqe.enrollmentformresponse
(
    carrier_id               bigint encode az64,
    enrollmentformresponseid bigint distkey,
    enrollmentid             bigint encode az64,
    field                    varchar(256),
    formfieldstructureid     double precision,
    value                    varchar(8192),
    displaytext              varchar(1024),
    formelementid            double precision,
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64
)
    sortkey (enrollmentformresponseid);

alter table landing_aqe.enrollmentformresponse
    owner to etluser;

create table if not exists staging_aqe.enrollmentformresponse
(
    carrier_id               bigint encode az64,
    enrollmentformresponseid bigint encode az64,
    enrollmentid             bigint encode az64 distkey,
    field                    varchar(256),
    formfieldstructureid     bigint encode az64,
    value                    varchar(8192),
    displaytext              varchar(1024),
    formelementid            bigint encode az64,
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.enrollmentformresponse
    owner to etluser;

create table if not exists integrated_aqe.enrollmentformresponse
(
    dw_table_pk              bigint default "identity"(344829, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64,
    enrollmentformresponseid bigint encode az64 distkey,
    enrollmentid             bigint encode az64,
    field                    varchar(256),
    formfieldstructureid     bigint encode az64,
    value                    varchar(8192),
    displaytext              varchar(1024),
    formelementid            bigint encode az64,
    miscnotes                varchar(500),
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentformresponse
    owner to etluser;

grant select on integrated_aqe.enrollmentformresponse to group named_user_ro;

create table if not exists landing_aqe.enrollmentwipro
(
    carrier_id        bigint encode az64,
    enrollmentwiproid bigint encode az64 distkey,
    enrollmentid      bigint encode az64,
    wiproid           bigint encode az64,
    date              timestamp,
    planyear          double precision,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
)
    sortkey (date);

alter table landing_aqe.enrollmentwipro
    owner to etluser;

create table if not exists staging_aqe.enrollmentwipro
(
    carrier_id            bigint encode az64,
    enrollmentwiproid     bigint encode az64 distkey,
    enrollmentid          bigint encode az64,
    wiproid               bigint encode az64,
    date                  timestamp encode az64,
    planyear              bigint encode az64,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.enrollmentwipro
    owner to etluser;

create table if not exists integrated_aqe.enrollmentwipro
(
    dw_table_pk          bigint default "identity"(345012, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    enrollmentwiproid    bigint encode az64,
    enrollmentid         bigint encode az64,
    wiproid              bigint encode az64,
    date                 timestamp encode az64,
    planyear             bigint encode az64,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentwipro
    owner to etluser;

grant select on integrated_aqe.enrollmentwipro to group named_user_ro;

create table if not exists landing_aqe.enrollmentformulary
(
    carrier_id            bigint encode az64,
    enrollmentformularyid bigint distkey,
    enrollmentid          bigint encode az64,
    ndc                   varchar(11),
    days_supply           double precision,
    drugtier              varchar(50),
    quantity              double precision,
    pharmacynpi           varchar(50),
    covered               boolean,
    planpays              varchar(50),
    beneficiarypays       varchar(50),
    manufacturerpays      varchar(50),
    refresh_timestamp     timestamp encode az64
)
    sortkey (enrollmentformularyid);

alter table landing_aqe.enrollmentformulary
    owner to etluser;

create table if not exists staging_aqe.enrollmentformulary
(
    carrier_id            bigint encode az64,
    enrollmentformularyid bigint encode az64 distkey,
    enrollmentid          bigint encode az64,
    ndc                   varchar(11),
    days_supply           integer encode az64,
    drugtier              varchar(50),
    quantity              bigint encode az64,
    pharmacynpi           varchar(50),
    covered               boolean,
    planpays              varchar(50),
    beneficiarypays       varchar(50),
    manufacturerpays      varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.enrollmentformulary
    owner to etluser;

create table if not exists integrated_aqe.enrollmentformulary
(
    dw_table_pk           bigint default "identity"(346130, 0, '0,1'::text) encode az64,
    carrier_id            bigint encode az64 distkey,
    enrollmentformularyid bigint encode az64,
    enrollmentid          bigint encode az64,
    ndc                   varchar(11),
    days_supply           integer encode az64,
    drugtier              varchar(50),
    quantity              bigint encode az64,
    pharmacynpi           varchar(50),
    covered               boolean,
    planpays              varchar(50),
    beneficiarypays       varchar(50),
    manufacturerpays      varchar(50),
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentformulary
    owner to etluser;

grant select on integrated_aqe.enrollmentformulary to group named_user_ro;

create table if not exists landing_aqe.enrollmentleadascendcalls
(
    carrier_id                    bigint encode az64,
    pkenrollmentleadascendcallsid bigint encode az64,
    enrollmentid                  double precision,
    leadascendcallid              double precision,
    miscnotes                     varchar(256),
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp encode az64
);

alter table landing_aqe.enrollmentleadascendcalls
    owner to etluser;

create table if not exists staging_aqe.enrollmentleadascendcalls
(
    carrier_id                    bigint encode az64,
    pkenrollmentleadascendcallsid bigint encode az64 distkey,
    enrollmentid                  bigint encode az64,
    leadascendcallid              bigint encode az64,
    miscnotes                     varchar(256),
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.enrollmentleadascendcalls
    owner to etluser;

create table if not exists integrated_aqe.enrollmentleadascendcalls
(
    dw_table_pk                   bigint default "identity"(346177, 0, '0,1'::text) encode az64,
    carrier_id                    bigint encode az64 distkey,
    pkenrollmentleadascendcallsid bigint encode az64,
    enrollmentid                  bigint encode az64,
    leadascendcallid              bigint encode az64,
    miscnotes                     varchar(256),
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentleadascendcalls
    owner to etluser;

grant select on integrated_aqe.enrollmentleadascendcalls to group named_user_ro;

create table if not exists landing_aqe.enrollmentpersonmap
(
    carrier_id           bigint encode az64,
    enrollmentpersonmap  bigint,
    enrollmentid         bigint encode az64,
    personid             bigint encode az64 distkey,
    personrelationshipid double precision,
    persontypeid         double precision,
    providerid           double precision,
    providertypeid       double precision,
    premiumamount        numeric(18, 2) encode az64,
    relationship         varchar(50),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64
)
    sortkey (enrollmentpersonmap);

alter table landing_aqe.enrollmentpersonmap
    owner to etluser;

create table if not exists staging_aqe.enrollmentpersonmap
(
    carrier_id            bigint encode az64,
    enrollmentpersonmap   bigint encode az64,
    enrollmentid          bigint encode az64,
    personid              bigint encode az64 distkey,
    personrelationshipid  bigint encode az64,
    persontypeid          bigint encode az64,
    providerid            bigint encode az64,
    providertypeid        bigint encode az64,
    premiumamount         numeric(18, 2) encode az64,
    relationship          varchar(50),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.enrollmentpersonmap
    owner to etluser;

create table if not exists integrated_aqe.enrollmentpersonmap
(
    dw_table_pk          bigint default "identity"(346219, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    enrollmentpersonmap  bigint encode az64,
    enrollmentid         bigint encode az64,
    personid             bigint encode az64,
    personrelationshipid bigint encode az64,
    persontypeid         bigint encode az64,
    providerid           bigint encode az64,
    providertypeid       bigint encode az64,
    premiumamount        numeric(18, 2) encode az64,
    relationship         varchar(50),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.enrollmentpersonmap
    owner to etluser;

grant select on integrated_aqe.enrollmentpersonmap to group named_user_ro;

create table if not exists landing_aqe.externalenrollmentstatus
(
    carrier_id                 bigint encode az64,
    externalenrollmentstatusid bigint encode az64,
    name                       varchar(500),
    description                varchar(500),
    isdefault                  boolean,
    ispositivestatus           boolean,
    miscnotes                  varchar(500),
    refresh_timestamp          timestamp encode az64
);

alter table landing_aqe.externalenrollmentstatus
    owner to etluser;

create table if not exists staging_aqe.externalenrollmentstatus
(
    carrier_id                 bigint encode az64,
    externalenrollmentstatusid bigint encode az64 distkey,
    name                       varchar(500),
    description                varchar(500),
    isdefault                  boolean,
    ispositivestatus           boolean,
    miscnotes                  varchar(500),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_aqe.externalenrollmentstatus
    owner to etluser;

create table if not exists integrated_aqe.externalenrollmentstatus
(
    dw_table_pk                bigint default "identity"(346255, 0, '0,1'::text) encode az64,
    carrier_id                 bigint encode az64 distkey,
    externalenrollmentstatusid bigint encode az64,
    name                       varchar(500),
    description                varchar(500),
    isdefault                  boolean,
    ispositivestatus           boolean,
    miscnotes                  varchar(500),
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.externalenrollmentstatus
    owner to etluser;

grant select on integrated_aqe.externalenrollmentstatus to group named_user_ro;

create table if not exists landing_aqe.formplanregionmap
(
    carrier_id          bigint encode az64 distkey,
    formplanregionmapid bigint encode az64,
    formid              bigint encode az64,
    planid              bigint encode az64,
    regionid            bigint encode az64,
    planorder           double precision,
    criteriavalueid     double precision,
    miscnotes           varchar(500),
    externalplanid      double precision,
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.formplanregionmap
    owner to etluser;

create table if not exists staging_aqe.formplanregionmap
(
    carrier_id            bigint encode az64,
    formplanregionmapid   bigint encode az64,
    formid                bigint encode az64,
    planid                bigint encode az64,
    regionid              bigint encode az64,
    planorder             bigint encode az64,
    criteriavalueid       bigint encode az64 distkey,
    miscnotes             varchar(500),
    externalplanid        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.formplanregionmap
    owner to etluser;

create table if not exists integrated_aqe.formplanregionmap
(
    dw_table_pk          bigint default "identity"(346300, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    formplanregionmapid  bigint encode az64,
    formid               bigint encode az64,
    planid               bigint encode az64,
    regionid             bigint encode az64,
    planorder            bigint encode az64,
    criteriavalueid      bigint encode az64,
    miscnotes            varchar(500),
    externalplanid       bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.formplanregionmap
    owner to etluser;

grant select on integrated_aqe.formplanregionmap to group named_user_ro;

create table if not exists landing_aqe.leaddrugselections
(
    carrier_id           bigint encode az64,
    leaddrugselectionsid bigint encode az64,
    leadid               bigint encode az64 distkey,
    drugndc              varchar(255),
    chosendosage         varchar(256),
    chosenpackage        varchar(256),
    chosenfrequency      double precision,
    chosenquantity       double precision,
    isactive             boolean,
    datecreated          timestamp,
    lastupdateddate      timestamp encode az64,
    miscnotes            varchar(256),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64
)
    sortkey (datecreated);

alter table landing_aqe.leaddrugselections
    owner to etluser;

create table if not exists staging_aqe.leaddrugselections
(
    carrier_id            bigint encode az64,
    leaddrugselectionsid  bigint encode az64,
    leadid                bigint encode az64 distkey,
    drugndc               varchar(255),
    chosendosage          varchar(256),
    chosenpackage         varchar(256),
    chosenfrequency       integer encode az64,
    chosenquantity        bigint encode az64,
    isactive              boolean,
    datecreated           timestamp encode az64,
    lastupdateddate       timestamp encode az64,
    miscnotes             varchar(256),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.leaddrugselections
    owner to etluser;

create table if not exists integrated_aqe.leaddrugselections
(
    dw_table_pk          bigint default "identity"(346338, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    leaddrugselectionsid bigint encode az64,
    leadid               bigint encode az64,
    drugndc              varchar(255),
    chosendosage         varchar(256),
    chosenpackage        varchar(256),
    chosenfrequency      integer encode az64,
    chosenquantity       bigint encode az64,
    isactive             boolean,
    datecreated          timestamp encode az64,
    lastupdateddate      timestamp encode az64,
    miscnotes            varchar(256),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.leaddrugselections
    owner to etluser;

grant select on integrated_aqe.leaddrugselections to group named_user_ro;

create table if not exists landing_aqe.leadpharmacyselections
(
    carrier_id               bigint encode az64,
    leadpharmacyselectionsid bigint encode az64,
    leadid                   bigint encode az64 distkey,
    pharmacynpi              double precision,
    isactive                 boolean,
    datecreated              timestamp encode az64,
    lastupdateddate          timestamp encode az64,
    miscnotes                varchar(256),
    validfrom                timestamp,
    validto                  timestamp encode az64,
    primarypharmacy          boolean,
    refresh_timestamp        timestamp encode az64
)
    sortkey (validfrom);

alter table landing_aqe.leadpharmacyselections
    owner to etluser;

create table if not exists staging_aqe.leadpharmacyselections
(
    carrier_id               bigint encode az64,
    leadpharmacyselectionsid bigint encode az64,
    leadid                   bigint encode az64 distkey,
    pharmacynpi              bigint encode az64,
    isactive                 boolean,
    datecreated              timestamp encode az64,
    lastupdateddate          timestamp encode az64,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    primarypharmacy          boolean,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.leadpharmacyselections
    owner to etluser;

create table if not exists integrated_aqe.leadpharmacyselections
(
    dw_table_pk              bigint default "identity"(346380, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64 distkey,
    leadpharmacyselectionsid bigint encode az64,
    leadid                   bigint encode az64,
    pharmacynpi              bigint encode az64,
    isactive                 boolean,
    datecreated              timestamp encode az64,
    lastupdateddate          timestamp encode az64,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    primarypharmacy          boolean,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.leadpharmacyselections
    owner to etluser;

grant select on integrated_aqe.leadpharmacyselections to group named_user_ro;

create table if not exists landing_aqe.leadproviderselections
(
    carrier_id               bigint encode az64 distkey,
    leadproviderselectionsid bigint encode az64,
    npi                      varchar(255),
    locationid               double precision,
    siteid                   varchar(255),
    clientlocationidentifier varchar(255),
    groupname                varchar(256),
    street                   varchar(256),
    zip                      varchar(10),
    ispcp                    boolean,
    miscnotes                varchar(256),
    validfrom                timestamp,
    validto                  timestamp encode az64,
    pcpselectedbybeneficiary boolean,
    refresh_timestamp        timestamp encode az64
)
    sortkey (validfrom);

alter table landing_aqe.leadproviderselections
    owner to etluser;

create table if not exists staging_aqe.leadproviderselections
(
    carrier_id               bigint encode az64,
    leadproviderselectionsid bigint encode az64,
    npi                      varchar(255),
    locationid               bigint encode az64 distkey,
    siteid                   varchar(255),
    clientlocationidentifier varchar(255),
    groupname                varchar(256),
    street                   varchar(256),
    zip                      varchar(10),
    ispcp                    boolean,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    pcpselectedbybeneficiary boolean,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.leadproviderselections
    owner to etluser;

create table if not exists integrated_aqe.leadproviderselections
(
    dw_table_pk              bigint default "identity"(346428, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64,
    leadproviderselectionsid bigint encode az64,
    npi                      varchar(255),
    locationid               bigint encode az64 distkey,
    siteid                   varchar(255),
    clientlocationidentifier varchar(255),
    groupname                varchar(256),
    street                   varchar(256),
    zip                      varchar(10),
    ispcp                    boolean,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    pcpselectedbybeneficiary boolean,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table integrated_aqe.leadproviderselections
    owner to etluser;

grant select on integrated_aqe.leadproviderselections to group named_user_ro;

create table if not exists landing_aqe.leadproviderselectionmap
(
    carrier_id                 bigint encode az64,
    leadproviderselectionmapid bigint encode az64,
    leadid                     bigint encode az64 distkey,
    leadproviderselectionsid   bigint encode az64,
    isactive                   boolean,
    datecreated                timestamp encode az64,
    lastupdateddate            timestamp,
    miscnotes                  varchar(256),
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp encode az64
)
    sortkey (lastupdateddate);

alter table landing_aqe.leadproviderselectionmap
    owner to etluser;

create table if not exists staging_aqe.leadproviderselectionmap
(
    carrier_id                 bigint encode az64,
    leadproviderselectionmapid bigint encode az64,
    leadid                     bigint encode az64 distkey,
    leadproviderselectionsid   bigint encode az64,
    isactive                   boolean,
    datecreated                timestamp encode az64,
    lastupdateddate            timestamp encode az64,
    miscnotes                  varchar(256),
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_aqe.leadproviderselectionmap
    owner to etluser;

create table if not exists integrated_aqe.leadproviderselectionmap
(
    dw_table_pk                bigint default "identity"(346478, 0, '0,1'::text) encode az64,
    carrier_id                 bigint encode az64 distkey,
    leadproviderselectionmapid bigint encode az64,
    leadid                     bigint encode az64,
    leadproviderselectionsid   bigint encode az64,
    isactive                   boolean,
    datecreated                timestamp encode az64,
    lastupdateddate            timestamp encode az64,
    miscnotes                  varchar(256),
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.leadproviderselectionmap
    owner to etluser;

grant select on integrated_aqe.leadproviderselectionmap to group named_user_ro;

create table if not exists landing_aqe.partialapplications
(
    carrier_id                  bigint encode az64,
    partialapplicationid        bigint encode az64 distkey,
    userid                      double precision,
    agentid                     varchar(200),
    formid                      bigint encode az64,
    planid                      bigint encode az64,
    planyear                    double precision,
    applicationtype             bigint encode az64,
    marketingcode               varchar(256),
    agentfirstname              varchar(256),
    agentlastname               varchar(256),
    agentemail                  varchar(256),
    firstname                   varchar(256),
    lastname                    varchar(256),
    dateofbirth                 timestamp encode az64,
    applicationdata             varchar(256),
    applicationformrestoredata  varchar(256),
    pharmacynpi                 double precision,
    providernpi                 double precision,
    datesaved                   timestamp,
    enrollmentid                double precision,
    isapplicationcomplete       boolean,
    isreturnablebyagent         boolean,
    scopeofappointmentid        varchar(50),
    expirationdatetime          timestamp encode az64,
    isdeleted                   boolean,
    miscnotes                   varchar(500),
    isreachedapplicationsummary boolean,
    browser                     varchar(256),
    guidsessiondata             varchar(256),
    consumerapptrackingcode     varchar(50),
    beid                        double precision,
    refresh_timestamp           timestamp encode az64
)
    sortkey (datesaved);

alter table landing_aqe.partialapplications
    owner to etluser;

create table if not exists staging_aqe.partialapplications
(
    carrier_id                  bigint encode az64,
    partialapplicationid        bigint encode az64,
    userid                      bigint encode az64,
    agentid                     varchar(200),
    formid                      bigint encode az64,
    planid                      bigint encode az64,
    planyear                    bigint encode az64,
    applicationtype             bigint encode az64,
    marketingcode               varchar(256),
    agentfirstname              varchar(256),
    agentlastname               varchar(256),
    agentemail                  varchar(256),
    firstname                   varchar(256),
    lastname                    varchar(256),
    dateofbirth                 timestamp encode az64,
    applicationdata             varchar(256),
    applicationformrestoredata  varchar(256),
    pharmacynpi                 bigint encode az64,
    providernpi                 bigint encode az64,
    datesaved                   timestamp encode az64,
    enrollmentid                bigint encode az64 distkey,
    isapplicationcomplete       boolean,
    isreturnablebyagent         boolean,
    scopeofappointmentid        varchar(50),
    expirationdatetime          timestamp encode az64,
    isdeleted                   boolean,
    miscnotes                   varchar(500),
    isreachedapplicationsummary boolean,
    browser                     varchar(256),
    guidsessiondata             varchar(256),
    consumerapptrackingcode     varchar(50),
    beid                        bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_aqe.partialapplications
    owner to etluser;

create table if not exists integrated_aqe.partialapplications
(
    dw_table_pk                 bigint default "identity"(346521, 0, '0,1'::text),
    carrier_id                  bigint encode az64,
    partialapplicationid        bigint encode az64 distkey,
    userid                      bigint encode az64,
    agentid                     varchar(200),
    formid                      bigint encode az64,
    planid                      bigint encode az64,
    planyear                    bigint encode az64,
    applicationtype             bigint encode az64,
    marketingcode               varchar(256),
    agentfirstname              varchar(256),
    agentlastname               varchar(256),
    agentemail                  varchar(256),
    firstname                   varchar(256),
    lastname                    varchar(256),
    dateofbirth                 timestamp encode az64,
    applicationdata             varchar(256),
    applicationformrestoredata  varchar(256),
    pharmacynpi                 bigint encode az64,
    providernpi                 bigint encode az64,
    datesaved                   timestamp encode az64,
    enrollmentid                bigint encode az64,
    isapplicationcomplete       boolean,
    isreturnablebyagent         boolean,
    scopeofappointmentid        varchar(50),
    expirationdatetime          timestamp encode az64,
    isdeleted                   boolean,
    miscnotes                   varchar(500),
    isreachedapplicationsummary boolean,
    browser                     varchar(256),
    guidsessiondata             varchar(256),
    consumerapptrackingcode     varchar(50),
    beid                        bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
)
    sortkey (dw_table_pk);

alter table integrated_aqe.partialapplications
    owner to etluser;

grant select on integrated_aqe.partialapplications to group named_user_ro;

create table if not exists landing_aqe.personcontactinfomap
(
    carrier_id          bigint encode az64,
    personcontactinfoid bigint encode az64,
    personid            bigint encode az64 distkey,
    contactinfoid       bigint encode az64,
    contactinfotypeid   bigint encode az64,
    startdate           timestamp,
    enddate             timestamp encode az64,
    miscnotes           varchar(500),
    refresh_timestamp   timestamp encode az64
)
    sortkey (startdate);

alter table landing_aqe.personcontactinfomap
    owner to etluser;

create table if not exists staging_aqe.personcontactinfomap
(
    carrier_id            bigint encode az64,
    personcontactinfoid   bigint encode az64,
    personid              bigint encode az64 distkey,
    contactinfoid         bigint encode az64,
    contactinfotypeid     bigint encode az64,
    startdate             timestamp encode az64,
    enddate               timestamp encode az64,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.personcontactinfomap
    owner to etluser;

create table if not exists integrated_aqe.personcontactinfomap
(
    dw_table_pk          bigint default "identity"(346569, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    personcontactinfoid  bigint encode az64,
    personid             bigint encode az64,
    contactinfoid        bigint encode az64,
    contactinfotypeid    bigint encode az64,
    startdate            timestamp encode az64,
    enddate              timestamp encode az64,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.personcontactinfomap
    owner to etluser;

grant select on integrated_aqe.personcontactinfomap to group named_user_ro;

create table if not exists landing_aqe.personrelationship
(
    carrier_id           bigint encode az64,
    personrelationshipid bigint encode az64,
    relationship         varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.personrelationship
    owner to etluser;

create table if not exists staging_aqe.personrelationship
(
    carrier_id            bigint encode az64,
    personrelationshipid  bigint encode az64 distkey,
    relationship          varchar(256),
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.personrelationship
    owner to etluser;

create table if not exists integrated_aqe.personrelationship
(
    dw_table_pk          bigint default "identity"(346613, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    personrelationshipid bigint encode az64,
    relationship         varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.personrelationship
    owner to etluser;

grant select on integrated_aqe.personrelationship to group named_user_ro;

create table if not exists landing_aqe.salesregion
(
    carrier_id        bigint encode az64,
    salesregionid     bigint encode az64,
    name              varchar(100),
    description       varchar(256),
    isdeleted         boolean,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.salesregion
    owner to etluser;

create table if not exists staging_aqe.salesregion
(
    carrier_id            bigint encode az64 distkey,
    salesregionid         bigint encode az64,
    name                  varchar(100),
    description           varchar(256),
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.salesregion
    owner to etluser;

create table if not exists integrated_aqe.salesregion
(
    dw_table_pk          bigint default "identity"(346660, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    salesregionid        bigint encode az64,
    name                 varchar(100),
    description          varchar(256),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.salesregion
    owner to etluser;

grant select on integrated_aqe.salesregion to group named_user_ro;

create table if not exists landing_aqe.regionfipscodes
(
    carrier_id        bigint encode az64 distkey,
    regionfipscodesid bigint,
    regionid          bigint encode az64,
    statefipscode     varchar(2),
    countyfipscode    varchar(3),
    stateabbreviation varchar(2),
    county            varchar(256),
    isdeleted         boolean,
    miscnotes         varchar(500),
    refresh_timestamp timestamp encode az64
)
    sortkey (regionfipscodesid);

alter table landing_aqe.regionfipscodes
    owner to etluser;

create table if not exists staging_aqe.regionfipscodes
(
    carrier_id            bigint encode az64 distkey,
    regionfipscodesid     bigint encode az64,
    regionid              bigint encode az64,
    statefipscode         varchar(2),
    countyfipscode        varchar(3),
    stateabbreviation     varchar(2),
    county                varchar(256),
    isdeleted             boolean,
    miscnotes             varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.regionfipscodes
    owner to etluser;

create table if not exists integrated_aqe.regionfipscodes
(
    dw_table_pk          bigint default "identity"(346705, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    regionfipscodesid    bigint encode az64,
    regionid             bigint encode az64,
    statefipscode        varchar(2),
    countyfipscode       varchar(3),
    stateabbreviation    varchar(2),
    county               varchar(256),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.regionfipscodes
    owner to etluser;

grant select on integrated_aqe.regionfipscodes to group named_user_ro;

create table if not exists landing_aqe.quickquote
(
    carrier_id           bigint encode az64,
    quickquoteid         bigint encode az64,
    displayid            varchar(256),
    userid               bigint encode az64 distkey,
    firstname            varchar(100),
    lastname             varchar(100),
    email                varchar(500),
    phone                varchar(50),
    zipcode              varchar(10),
    statefipscode        varchar(2),
    countyfipscode       varchar(3),
    county               varchar(50),
    state                varchar(50),
    sendtoenrollment     boolean,
    sentdate             timestamp encode az64,
    expirationdate       timestamp,
    verificationcode     varchar(50),
    expirationdatepii    timestamp encode az64,
    agentnpn             varchar(256),
    confirmationid       varchar(50),
    partialapplicationid double precision,
    beid                 double precision,
    ascendleadid         double precision,
    refresh_timestamp    timestamp encode az64
)
    sortkey (expirationdate);

alter table landing_aqe.quickquote
    owner to etluser;

create table if not exists staging_aqe.quickquote
(
    carrier_id            bigint encode az64,
    quickquoteid          bigint encode az64,
    displayid             varchar(256),
    userid                bigint encode az64 distkey,
    firstname             varchar(100),
    lastname              varchar(100),
    email                 varchar(500),
    phone                 varchar(50),
    zipcode               varchar(10),
    statefipscode         varchar(2),
    countyfipscode        varchar(3),
    county                varchar(50),
    state                 varchar(50),
    sendtoenrollment      boolean,
    sentdate              timestamp encode az64,
    expirationdate        timestamp encode az64,
    verificationcode      varchar(50),
    expirationdatepii     timestamp encode az64,
    agentnpn              varchar(256),
    confirmationid        varchar(50),
    partialapplicationid  bigint encode az64,
    beid                  bigint encode az64,
    ascendleadid          bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.quickquote
    owner to etluser;

create table if not exists integrated_aqe.quickquote
(
    dw_table_pk          bigint default "identity"(346745, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    quickquoteid         bigint encode az64,
    displayid            varchar(256),
    userid               bigint encode az64,
    firstname            varchar(100),
    lastname             varchar(100),
    email                varchar(500),
    phone                varchar(50),
    zipcode              varchar(10),
    statefipscode        varchar(2),
    countyfipscode       varchar(3),
    county               varchar(50),
    state                varchar(50) encode bytedict,
    sendtoenrollment     boolean,
    sentdate             timestamp encode az64,
    expirationdate       timestamp encode az64,
    verificationcode     varchar(50),
    expirationdatepii    timestamp encode az64,
    agentnpn             varchar(256),
    confirmationid       varchar(50),
    partialapplicationid bigint encode az64,
    beid                 bigint encode az64,
    ascendleadid         bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.quickquote
    owner to etluser;

grant select on integrated_aqe.quickquote to group named_user_ro;

create table if not exists landing_aqe.quickquoteplanmap
(
    carrier_id          bigint encode az64,
    quickquoteplanmapid bigint encode az64,
    quickquoteid        bigint encode az64 distkey,
    planid              bigint encode az64,
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.quickquoteplanmap
    owner to etluser;

create table if not exists staging_aqe.quickquoteplanmap
(
    carrier_id            bigint encode az64,
    quickquoteplanmapid   bigint encode az64,
    quickquoteid          bigint encode az64 distkey,
    planid                bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.quickquoteplanmap
    owner to etluser;

create table if not exists integrated_aqe.quickquoteplanmap
(
    dw_table_pk          bigint default "identity"(346792, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    quickquoteplanmapid  bigint encode az64,
    quickquoteid         bigint encode az64,
    planid               bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.quickquoteplanmap
    owner to etluser;

grant select on integrated_aqe.quickquoteplanmap to group named_user_ro;

create table if not exists landing_aqe.vbeinformationstatushistory
(
    carrier_id                    bigint encode az64,
    vbeinformationstatushistoryid bigint encode az64,
    vbeinformationid              bigint encode az64,
    memberinformationid           bigint encode az64,
    formsubmissionid              double precision,
    buttonid                      double precision,
    actionid                      double precision,
    vbestatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  double precision,
    miscnotes                     varchar(500),
    formid                        double precision,
    refresh_timestamp             timestamp encode az64
);

alter table landing_aqe.vbeinformationstatushistory
    owner to etluser;

create table if not exists staging_aqe.vbeinformationstatushistory
(
    carrier_id                    bigint encode az64,
    vbeinformationstatushistoryid bigint encode az64,
    vbeinformationid              bigint encode az64,
    memberinformationid           bigint encode az64,
    formsubmissionid              bigint encode az64 distkey,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    vbestatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    miscnotes                     varchar(500),
    formid                        bigint encode az64,
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.vbeinformationstatushistory
    owner to etluser;

create table if not exists integrated_aqe.vbeinformationstatushistory
(
    dw_table_pk                   bigint default "identity"(347705, 0, '0,1'::text) encode az64,
    carrier_id                    bigint encode az64 distkey,
    vbeinformationstatushistoryid bigint encode az64,
    vbeinformationid              bigint encode az64,
    memberinformationid           bigint encode az64,
    formsubmissionid              bigint encode az64,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    vbestatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    miscnotes                     varchar(500),
    formid                        bigint encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.vbeinformationstatushistory
    owner to etluser;

grant select on integrated_aqe.vbeinformationstatushistory to group named_user_ro;

create table if not exists landing_aqe.vbeinformation
(
    carrier_id          bigint encode az64,
    vbeinformationid    bigint encode az64,
    memberinformationid bigint encode az64,
    formsubmissionid    double precision,
    buttonid            double precision,
    actionid            double precision,
    vbestatusid         bigint encode az64,
    statusupdatedate    timestamp encode az64,
    ascenduserid        double precision,
    miscnotes           varchar(500),
    formid              double precision,
    refresh_timestamp   timestamp encode az64
);

alter table landing_aqe.vbeinformation
    owner to etluser;

create table if not exists staging_aqe.vbeinformation
(
    carrier_id            bigint encode az64,
    vbeinformationid      bigint encode az64,
    memberinformationid   bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    buttonid              bigint encode az64,
    actionid              bigint encode az64,
    vbestatusid           bigint encode az64,
    statusupdatedate      timestamp encode az64,
    ascenduserid          bigint encode az64,
    miscnotes             varchar(500),
    formid                bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.vbeinformation
    owner to etluser;

create table if not exists integrated_aqe.vbeinformation
(
    dw_table_pk          bigint default "identity"(347756, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    vbeinformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    formsubmissionid     bigint encode az64,
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    vbestatusid          bigint encode az64,
    statusupdatedate     timestamp encode az64,
    ascenduserid         bigint encode az64,
    miscnotes            varchar(500),
    formid               bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.vbeinformation
    owner to etluser;

grant select on integrated_aqe.vbeinformation to group named_user_ro;

create table if not exists landing_aqe.schedulinginformation
(
    carrier_id              bigint encode az64,
    schedulinginformationid bigint encode az64,
    memberinformationid     bigint encode az64 distkey,
    timeoffset              integer encode az64,
    starttime               timestamp encode az64,
    endtime                 timestamp encode az64,
    timesenttocallcenter    timestamp encode az64,
    timezone                varchar(100),
    isdeleted               boolean,
    refresh_timestamp       timestamp encode az64
);

alter table landing_aqe.schedulinginformation
    owner to etluser;

create table if not exists staging_aqe.schedulinginformation
(
    carrier_id              bigint encode az64,
    schedulinginformationid bigint encode az64,
    memberinformationid     bigint encode az64 distkey,
    timeoffset              integer encode az64,
    starttime               timestamp encode az64,
    endtime                 timestamp encode az64,
    timesenttocallcenter    timestamp encode az64,
    timezone                varchar(100),
    isdeleted               boolean,
    refresh_timestamp       timestamp encode az64,
    data_action_indicator   char default 'N'::bpchar,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table staging_aqe.schedulinginformation
    owner to etluser;

create table if not exists integrated_aqe.schedulinginformation
(
    dw_table_pk             bigint default "identity"(347811, 0, '0,1'::text) encode az64,
    carrier_id              bigint encode az64 distkey,
    schedulinginformationid bigint encode az64,
    memberinformationid     bigint encode az64,
    timeoffset              integer encode az64,
    starttime               timestamp encode az64,
    endtime                 timestamp encode az64,
    timesenttocallcenter    timestamp encode az64,
    timezone                varchar(100),
    isdeleted               boolean,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.schedulinginformation
    owner to etluser;

grant select on integrated_aqe.schedulinginformation to group named_user_ro;

create table if not exists landing_aqe.planrolebuttonmap
(
    carrier_id           bigint encode az64,
    planrolebuttonmapid  bigint encode az64,
    planid               double precision,
    roleid               double precision,
    buttonid             double precision,
    buttonorder          double precision,
    isdeleted            boolean,
    miscnotes            varchar(500),
    enrollmentformtypeid double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.planrolebuttonmap
    owner to etluser;

create table if not exists staging_aqe.planrolebuttonmap
(
    carrier_id            bigint encode az64,
    planrolebuttonmapid   bigint encode az64,
    planid                bigint encode az64,
    roleid                bigint encode az64,
    buttonid              bigint encode az64 distkey,
    buttonorder           bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500),
    enrollmentformtypeid  bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.planrolebuttonmap
    owner to etluser;

create table if not exists integrated_aqe.planrolebuttonmap
(
    dw_table_pk          bigint default "identity"(347852, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64 distkey,
    planrolebuttonmapid  bigint encode az64,
    planid               bigint encode az64,
    roleid               bigint encode az64,
    buttonid             bigint encode az64,
    buttonorder          bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(500),
    enrollmentformtypeid bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.planrolebuttonmap
    owner to etluser;

grant select on integrated_aqe.planrolebuttonmap to group named_user_ro;

create table if not exists landing_aqe.outreachvendorresults
(
    carrier_id               bigint encode az64 distkey,
    pkoutreachvendorresults  bigint encode az64,
    outreachmemberinfofk     double precision,
    memberinformationfk      double precision,
    vendoroutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    hraactivitydate          timestamp encode az64,
    activityoutcome          varchar(255),
    activitytypeid           double precision,
    activitytypedescription  varchar(255),
    hrainformationid         double precision,
    programtype              varchar(500),
    questionversion          varchar(500),
    excludefromreporting     boolean,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64
);

alter table landing_aqe.outreachvendorresults
    owner to etluser;

create table if not exists staging_aqe.outreachvendorresults
(
    carrier_id               bigint encode az64,
    pkoutreachvendorresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    vendoroutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    hraactivitydate          timestamp encode az64,
    activityoutcome          varchar(255),
    activitytypeid           bigint encode az64,
    activitytypedescription  varchar(255),
    hrainformationid         bigint encode az64 distkey,
    programtype              varchar(500),
    questionversion          varchar(500),
    excludefromreporting     boolean,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.outreachvendorresults
    owner to etluser;

create table if not exists integrated_aqe.outreachvendorresults
(
    dw_table_pk              bigint default "identity"(347938, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64 distkey,
    pkoutreachvendorresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    vendoroutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    hraactivitydate          timestamp encode az64,
    activityoutcome          varchar(255),
    activitytypeid           bigint encode az64,
    activitytypedescription  varchar(255) encode bytedict,
    hrainformationid         bigint encode az64,
    programtype              varchar(500) encode bytedict,
    questionversion          varchar(500) encode bytedict,
    excludefromreporting     boolean,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachvendorresults
    owner to etluser;

grant select on integrated_aqe.outreachvendorresults to group named_user_ro;

create table if not exists landing_aqe.outreachsubsequentresults
(
    carrier_id                   bigint encode az64 distkey,
    pkoutreachsubsequentresults  bigint encode az64,
    outreachmemberinfofk         double precision,
    memberinformationfk          double precision,
    clientuniqueid               varchar(100),
    subsequentoutreachactivityid varchar(100),
    activitydate                 timestamp encode az64,
    activityoutcome              varchar(255),
    pdfactivityid                varchar(255),
    subsequentreason             varchar(255),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64
);

alter table landing_aqe.outreachsubsequentresults
    owner to etluser;

create table if not exists staging_aqe.outreachsubsequentresults
(
    carrier_id                   bigint encode az64 distkey,
    pkoutreachsubsequentresults  bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    clientuniqueid               varchar(100),
    subsequentoutreachactivityid varchar(100),
    activitydate                 timestamp encode az64,
    activityoutcome              varchar(255),
    pdfactivityid                varchar(255),
    subsequentreason             varchar(255),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char default 'N'::bpchar,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.outreachsubsequentresults
    owner to etluser;

create table if not exists integrated_aqe.outreachsubsequentresults
(
    dw_table_pk                  bigint default "identity"(347980, 0, '0,1'::text) encode az64,
    carrier_id                   bigint encode az64 distkey,
    pkoutreachsubsequentresults  bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    clientuniqueid               varchar(100),
    subsequentoutreachactivityid varchar(100),
    activitydate                 timestamp encode az64,
    activityoutcome              varchar(255) encode bytedict,
    pdfactivityid                varchar(255),
    subsequentreason             varchar(255) encode bytedict,
    excludefromreporting         boolean,
    miscnotes                    varchar(256) encode bytedict,
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachsubsequentresults
    owner to etluser;

grant select on integrated_aqe.outreachsubsequentresults to group named_user_ro;

create table if not exists landing_aqe.outreachsmsresults
(
    carrier_id            bigint encode az64 distkey,
    pkoutreachsmsresults  bigint encode az64,
    outreachmemberinfofk  double precision,
    memberinformationfk   double precision,
    smsoutreachactivityid varchar(100),
    smsstartdatetime      timestamp encode az64,
    smsenddatetime        timestamp encode az64,
    smsoutcome            varchar(1000),
    smssentphonenumber    varchar(50),
    hrainformationid      double precision,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    account_sid           varchar(256),
    api_version           varchar(256),
    body                  varchar(2024),
    date_updated          timestamp encode az64,
    direction             varchar(256),
    error_code            varchar(256),
    error_message         varchar(256),
    from_sms              varchar(256),
    messaging_service_sid varchar(256),
    num_media             varchar(256),
    num_segments          varchar(256),
    price                 varchar(256),
    price_unit            varchar(256),
    sid                   varchar(256),
    status                varchar(256),
    to_sms                varchar(256),
    uri                   varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             double precision,
    outreachattemptfk     double precision,
    outreachlistfk        double precision,
    refresh_timestamp     timestamp encode az64
);

alter table landing_aqe.outreachsmsresults
    owner to etluser;

create table if not exists staging_aqe.outreachsmsresults
(
    carrier_id            bigint encode az64,
    pkoutreachsmsresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    smsoutreachactivityid varchar(100),
    smsstartdatetime      timestamp encode az64,
    smsenddatetime        timestamp encode az64,
    smsoutcome            varchar(1000),
    smssentphonenumber    varchar(50),
    hrainformationid      bigint encode az64 distkey,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    account_sid           varchar(256),
    api_version           varchar(256),
    body                  varchar(2024),
    date_updated          timestamp encode az64,
    direction             varchar(256),
    error_code            varchar(256),
    error_message         varchar(256),
    from_sms              varchar(256),
    messaging_service_sid varchar(256),
    num_media             varchar(256),
    num_segments          varchar(256),
    price                 varchar(256),
    price_unit            varchar(256),
    sid                   varchar(256),
    status                varchar(256),
    to_sms                varchar(256),
    uri                   varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.outreachsmsresults
    owner to etluser;

create table if not exists integrated_aqe.outreachsmsresults
(
    dw_table_pk           bigint default "identity"(348022, 0, '0,1'::text) encode az64,
    carrier_id            bigint encode az64 distkey,
    pkoutreachsmsresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    smsoutreachactivityid varchar(100),
    smsstartdatetime      timestamp encode az64,
    smsenddatetime        timestamp encode az64,
    smsoutcome            varchar(1000) encode bytedict,
    smssentphonenumber    varchar(50),
    hrainformationid      bigint encode az64,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    account_sid           varchar(256),
    api_version           varchar(256),
    body                  varchar(2024),
    date_updated          timestamp encode az64,
    direction             varchar(256),
    error_code            varchar(256),
    error_message         varchar(256),
    from_sms              varchar(256),
    messaging_service_sid varchar(256),
    num_media             varchar(256),
    num_segments          varchar(256),
    price                 varchar(256),
    price_unit            varchar(256),
    sid                   varchar(256),
    status                varchar(256) encode bytedict,
    to_sms                varchar(256),
    uri                   varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachsmsresults
    owner to etluser;

grant select on integrated_aqe.outreachsmsresults to group named_user_ro;

create table if not exists landing_aqe.outreachroutedonotcontact
(
    carrier_id                  bigint encode az64 distkey,
    pkoutreachroutedonotcontact bigint encode az64,
    contact                     varchar(255),
    sms                         boolean,
    email                       boolean,
    call                        boolean,
    inserteddate                timestamp,
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64
)
    sortkey (inserteddate);

alter table landing_aqe.outreachroutedonotcontact
    owner to etluser;

create table if not exists staging_aqe.outreachroutedonotcontact
(
    carrier_id                  bigint encode az64 distkey,
    pkoutreachroutedonotcontact bigint encode az64,
    contact                     varchar(255),
    sms                         boolean,
    email                       boolean,
    call                        boolean,
    inserteddate                timestamp encode az64,
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_aqe.outreachroutedonotcontact
    owner to etluser;

create table if not exists integrated_aqe.outreachroutedonotcontact
(
    dw_table_pk                 bigint default "identity"(348068, 0, '0,1'::text) encode az64,
    carrier_id                  bigint encode az64 distkey,
    pkoutreachroutedonotcontact bigint encode az64,
    contact                     varchar(255),
    sms                         boolean,
    email                       boolean,
    call                        boolean,
    inserteddate                timestamp encode az64,
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachroutedonotcontact
    owner to etluser;

grant select on integrated_aqe.outreachroutedonotcontact to group named_user_ro;

create table if not exists landing_aqe.outreachportalresults
(
    carrier_id               bigint encode az64 distkey,
    pkoutreachportalresults  bigint encode az64,
    outreachmemberinfofk     double precision,
    memberinformationfk      double precision,
    portaloutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    activityoutcome          varchar(255),
    interviewagreement       varchar(50),
    hrainformationid         double precision,
    agentfk                  double precision,
    excludefromreporting     boolean,
    miscnotes                varchar(1024),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64
);

alter table landing_aqe.outreachportalresults
    owner to etluser;

create table if not exists staging_aqe.outreachportalresults
(
    carrier_id               bigint encode az64,
    pkoutreachportalresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    portaloutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    activityoutcome          varchar(255),
    interviewagreement       varchar(50),
    hrainformationid         bigint encode az64 distkey,
    agentfk                  bigint encode az64,
    excludefromreporting     boolean,
    miscnotes                varchar(1024),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char default 'N'::bpchar,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.outreachportalresults
    owner to etluser;

create table if not exists integrated_aqe.outreachportalresults
(
    dw_table_pk              bigint default "identity"(348112, 0, '0,1'::text) encode az64,
    carrier_id               bigint encode az64 distkey,
    pkoutreachportalresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    portaloutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    activityoutcome          varchar(255),
    interviewagreement       varchar(50),
    hrainformationid         bigint encode az64,
    agentfk                  bigint encode az64,
    excludefromreporting     boolean,
    miscnotes                varchar(1024),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachportalresults
    owner to etluser;

grant select on integrated_aqe.outreachportalresults to group named_user_ro;

create table if not exists landing_aqe.outreachmemberphoneinfo
(
    carrier_id                bigint encode az64 distkey,
    pkoutreachmemberphoneinfo bigint encode az64,
    outreachmemberinfofk      double precision,
    memberinformationfk       double precision,
    contactnumber             varchar(50),
    order_num                 double precision,
    phonetype                 double precision,
    smsattempts               bigint encode az64,
    ivrattempts               bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256),
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp encode az64
);

alter table landing_aqe.outreachmemberphoneinfo
    owner to etluser;

create table if not exists staging_aqe.outreachmemberphoneinfo
(
    carrier_id                bigint encode az64 distkey,
    pkoutreachmemberphoneinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    contactnumber             varchar(50),
    order_num                 bigint encode az64,
    phonetype                 bigint encode az64,
    smsattempts               bigint encode az64,
    ivrattempts               bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256),
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_aqe.outreachmemberphoneinfo
    owner to etluser;

create table if not exists integrated_aqe.outreachmemberphoneinfo
(
    dw_table_pk               bigint default "identity"(348174, 0, '0,1'::text) encode az64,
    carrier_id                bigint encode az64 distkey,
    pkoutreachmemberphoneinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    contactnumber             varchar(50),
    order_num                 bigint encode az64,
    phonetype                 bigint encode az64,
    smsattempts               bigint encode az64,
    ivrattempts               bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256) encode bytedict,
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachmemberphoneinfo
    owner to etluser;

grant select on integrated_aqe.outreachmemberphoneinfo to group named_user_ro;

create table if not exists landing_aqe.outreachmemberemailinfo
(
    carrier_id                bigint encode az64,
    pkoutreachmemberemailinfo bigint encode az64,
    outreachmemberinfofk      double precision,
    memberinformationfk       double precision,
    emailaddress              varchar(500) distkey,
    order_num                 double precision,
    emailattempts             bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256),
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp encode az64
);

alter table landing_aqe.outreachmemberemailinfo
    owner to etluser;

create table if not exists staging_aqe.outreachmemberemailinfo
(
    carrier_id                bigint encode az64,
    pkoutreachmemberemailinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    emailaddress              varchar(500) distkey,
    order_num                 bigint encode az64,
    emailattempts             bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256),
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_aqe.outreachmemberemailinfo
    owner to etluser;

create table if not exists integrated_aqe.outreachmemberemailinfo
(
    dw_table_pk               bigint default "identity"(348215, 0, '0,1'::text) encode az64,
    carrier_id                bigint encode az64 distkey,
    pkoutreachmemberemailinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    emailaddress              varchar(500),
    order_num                 bigint encode az64,
    emailattempts             bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256) encode bytedict,
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachmemberemailinfo
    owner to etluser;

grant select on integrated_aqe.outreachmemberemailinfo to group named_user_ro;

create table if not exists landing_aqe.outreachmembercustominfo
(
    carrier_id                 bigint encode az64 distkey,
    pkoutreachmembercustominfo bigint encode az64,
    outreachmemberinfofk       double precision,
    memberinformationfk        double precision,
    fieldname                  varchar(1000),
    fieldvalue                 varchar(1000),
    datatype                   varchar(50),
    isactive                   boolean,
    miscnotes                  varchar(256),
    inserteddate               timestamp encode az64,
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp encode az64
);

alter table landing_aqe.outreachmembercustominfo
    owner to etluser;

create table if not exists staging_aqe.outreachmembercustominfo
(
    carrier_id                 bigint encode az64 distkey,
    pkoutreachmembercustominfo bigint encode az64,
    outreachmemberinfofk       bigint encode az64,
    memberinformationfk        bigint encode az64,
    fieldname                  varchar(1000),
    fieldvalue                 varchar(1000),
    datatype                   varchar(50),
    isactive                   boolean,
    miscnotes                  varchar(256),
    inserteddate               timestamp encode az64,
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_aqe.outreachmembercustominfo
    owner to etluser;

create table if not exists integrated_aqe.outreachmembercustominfo
(
    dw_table_pk                bigint default "identity"(348254, 0, '0,1'::text) encode az64,
    carrier_id                 bigint encode az64,
    pkoutreachmembercustominfo bigint encode az64,
    outreachmemberinfofk       bigint encode az64,
    memberinformationfk        bigint encode az64 distkey,
    fieldname                  varchar(1000) encode bytedict,
    fieldvalue                 varchar(1000),
    datatype                   varchar(50) encode bytedict,
    isactive                   boolean,
    miscnotes                  varchar(256) encode bytedict,
    inserteddate               timestamp encode az64,
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachmembercustominfo
    owner to etluser;

grant select on integrated_aqe.outreachmembercustominfo to group named_user_ro;

create table if not exists landing_aqe.outreachmailresults
(
    carrier_id                    bigint encode az64 distkey,
    pkoutreachmailresults         bigint encode az64,
    outreachmemberinfofk          double precision,
    memberinformationfk           double precision,
    mailoutreachactivityid        varchar(100),
    mailsentdatetime              timestamp encode az64,
    activitydate                  timestamp encode az64,
    hraactivitydate               timestamp encode az64,
    mailoutcome                   varchar(1000),
    hrainformationid              double precision,
    pdffilename                   varchar(500),
    mailcrosswalkstatus           varchar(256),
    mailcrosswalkstatusupdatedate timestamp encode az64,
    programtype                   varchar(500),
    questionversion               varchar(500),
    barcode                       varchar(500),
    excludefromreporting          boolean,
    miscnotes                     varchar(256),
    inserteddate                  timestamp encode az64,
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp encode az64
);

alter table landing_aqe.outreachmailresults
    owner to etluser;

create table if not exists staging_aqe.outreachmailresults
(
    carrier_id                    bigint encode az64,
    pkoutreachmailresults         bigint encode az64,
    outreachmemberinfofk          bigint encode az64,
    memberinformationfk           bigint encode az64,
    mailoutreachactivityid        varchar(100),
    mailsentdatetime              timestamp encode az64,
    activitydate                  timestamp encode az64,
    hraactivitydate               timestamp encode az64,
    mailoutcome                   varchar(1000),
    hrainformationid              bigint encode az64 distkey,
    pdffilename                   varchar(500),
    mailcrosswalkstatus           varchar(256),
    mailcrosswalkstatusupdatedate timestamp encode az64,
    programtype                   varchar(500),
    questionversion               varchar(500),
    barcode                       varchar(500),
    excludefromreporting          boolean,
    miscnotes                     varchar(256),
    inserteddate                  timestamp encode az64,
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.outreachmailresults
    owner to etluser;

create table if not exists integrated_aqe.outreachmailresults
(
    dw_table_pk                   bigint default "identity"(348298, 0, '0,1'::text) encode az64,
    carrier_id                    bigint encode az64 distkey,
    pkoutreachmailresults         bigint encode az64,
    outreachmemberinfofk          bigint encode az64,
    memberinformationfk           bigint encode az64,
    mailoutreachactivityid        varchar(100),
    mailsentdatetime              timestamp encode az64,
    activitydate                  timestamp encode az64,
    hraactivitydate               timestamp encode az64,
    mailoutcome                   varchar(1000) encode bytedict,
    hrainformationid              bigint encode az64,
    pdffilename                   varchar(500),
    mailcrosswalkstatus           varchar(256) encode bytedict,
    mailcrosswalkstatusupdatedate timestamp encode az64,
    programtype                   varchar(500),
    questionversion               varchar(500),
    barcode                       varchar(500),
    excludefromreporting          boolean,
    miscnotes                     varchar(256) encode bytedict,
    inserteddate                  timestamp encode az64,
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachmailresults
    owner to etluser;

grant select on integrated_aqe.outreachmailresults to group named_user_ro;

create table if not exists landing_aqe.outreachlistmap
(
    carrier_id           bigint encode az64 distkey,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk double precision,
    memberinformationfk  double precision,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000),
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.outreachlistmap
    owner to etluser;

create table if not exists staging_aqe.outreachlistmap
(
    carrier_id            bigint encode az64 distkey,
    pkoutreachlistmap     bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    outreachlistfk        bigint encode az64,
    listsource            varchar(1000),
    isactive              boolean,
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.outreachlistmap
    owner to etluser;

create table if not exists integrated_aqe.outreachlistmap
(
    dw_table_pk          bigint default "identity"(348358, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk bigint encode az64,
    memberinformationfk  bigint encode az64 distkey,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000) encode bytedict,
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachlistmap
    owner to etluser;

grant select on integrated_aqe.outreachlistmap to group named_user_ro;

create table if not exists landing_aqe.outreachivrresults
(
    carrier_id            bigint encode az64 distkey,
    pkoutreachivrresults  bigint encode az64,
    outreachmemberinfofk  double precision,
    memberinformationfk   double precision,
    ivroutreachactivityid varchar(100),
    calldirection         varchar(1000),
    ivrstartdatetime      timestamp encode az64,
    ivrenddatetime        timestamp encode az64,
    ivroutcome            varchar(1000),
    ivrphonenumber        varchar(50),
    memberanswer          boolean,
    caregiveranswer       boolean,
    interviewagreement    boolean,
    hrainformationid      double precision,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             double precision,
    outreachattemptfk     double precision,
    outreachlistfk        double precision,
    refresh_timestamp     timestamp encode az64
);

alter table landing_aqe.outreachivrresults
    owner to etluser;

create table if not exists staging_aqe.outreachivrresults
(
    carrier_id            bigint encode az64,
    pkoutreachivrresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    ivroutreachactivityid varchar(100),
    calldirection         varchar(1000),
    ivrstartdatetime      timestamp encode az64,
    ivrenddatetime        timestamp encode az64,
    ivroutcome            varchar(1000),
    ivrphonenumber        varchar(50),
    memberanswer          boolean,
    caregiveranswer       boolean,
    interviewagreement    boolean,
    hrainformationid      bigint encode az64 distkey,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.outreachivrresults
    owner to etluser;

create table if not exists integrated_aqe.outreachivrresults
(
    dw_table_pk           bigint default "identity"(348398, 0, '0,1'::text) encode az64,
    carrier_id            bigint encode az64 distkey,
    pkoutreachivrresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    ivroutreachactivityid varchar(100),
    calldirection         varchar(1000),
    ivrstartdatetime      timestamp encode az64,
    ivrenddatetime        timestamp encode az64,
    ivroutcome            varchar(1000) encode bytedict,
    ivrphonenumber        varchar(50),
    memberanswer          boolean,
    caregiveranswer       boolean,
    interviewagreement    boolean,
    hrainformationid      bigint encode az64,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachivrresults
    owner to etluser;

grant select on integrated_aqe.outreachivrresults to group named_user_ro;

create table if not exists landing_aqe.outreachccsresults
(
    carrier_id                   bigint encode az64 distkey,
    pkoutreachccsresults         bigint encode az64,
    outreachmemberinfofk         double precision,
    memberinformationfk          bigint encode az64,
    ccsoutreachactivityid        varchar(100),
    contactinfofk                bigint encode az64,
    dateofcall                   timestamp encode az64,
    pkcallresults                bigint encode az64,
    poolfk                       bigint encode az64,
    contactnumber                varchar(50),
    callresultcode               varchar(100),
    callresultdescription        varchar(500),
    agentfk                      double precision,
    hrainformationid             double precision,
    interviewagreement           varchar(50),
    recordingfilename            varchar(500),
    fullrecordingfilepathandname varchar(256),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64
);

alter table landing_aqe.outreachccsresults
    owner to etluser;

create table if not exists staging_aqe.outreachccsresults
(
    carrier_id                   bigint encode az64,
    pkoutreachccsresults         bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    ccsoutreachactivityid        varchar(100),
    contactinfofk                bigint encode az64,
    dateofcall                   timestamp encode az64,
    pkcallresults                bigint encode az64,
    poolfk                       bigint encode az64,
    contactnumber                varchar(50),
    callresultcode               varchar(100),
    callresultdescription        varchar(500),
    agentfk                      bigint encode az64,
    hrainformationid             bigint encode az64 distkey,
    interviewagreement           varchar(50),
    recordingfilename            varchar(500),
    fullrecordingfilepathandname varchar(256),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char default 'N'::bpchar,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.outreachccsresults
    owner to etluser;

create table if not exists integrated_aqe.outreachccsresults
(
    dw_table_pk                  bigint default "identity"(348466, 0, '0,1'::text) encode az64,
    carrier_id                   bigint encode az64 distkey,
    pkoutreachccsresults         bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    ccsoutreachactivityid        varchar(100),
    contactinfofk                bigint encode az64,
    dateofcall                   timestamp encode az64,
    pkcallresults                bigint encode az64,
    poolfk                       bigint encode az64,
    contactnumber                varchar(50),
    callresultcode               varchar(100) encode bytedict,
    callresultdescription        varchar(500) encode bytedict,
    agentfk                      bigint encode az64,
    hrainformationid             bigint encode az64,
    interviewagreement           varchar(50) encode bytedict,
    recordingfilename            varchar(500),
    fullrecordingfilepathandname varchar(256),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachccsresults
    owner to etluser;

grant select on integrated_aqe.outreachccsresults to group named_user_ro;

create table if not exists landing_aqe.outreachemailresults
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    double precision,
    memberinformationfk     double precision,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) distkey,
    inserteddate            timestamp,
    hrainformationid        double precision,
    excludefromreporting    boolean,
    miscnotes               varchar(1024),
    email                   varchar(256),
    timestamp_num           double precision,
    smtpid                  varchar(256),
    event                   varchar(256),
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(2048),
    attempt                 varchar(256),
    useragent               varchar(1024),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(4096),
    status                  varchar(256),
    asm_group_id            double precision,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               double precision,
    outreachattemptfk       double precision,
    outreachlistfk          double precision,
    refresh_timestamp       timestamp encode az64
)
    sortkey (inserteddate);

alter table landing_aqe.outreachemailresults
    owner to etluser;

create table if not exists staging_aqe.outreachemailresults
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) distkey,
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64,
    excludefromreporting    boolean,
    miscnotes               varchar(1024),
    email                   varchar(256),
    timestamp_num           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256),
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(2048),
    attempt                 varchar(256),
    useragent               varchar(1024),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(4096),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_action_indicator   char default 'N'::bpchar,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table staging_aqe.outreachemailresults
    owner to etluser;

create table if not exists integrated_aqe.outreachemailresults
(
    dw_table_pk             bigint default "identity"(348562, 0, '0,1'::text) encode az64,
    carrier_id              bigint encode az64 distkey,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) encode bytedict,
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64,
    excludefromreporting    boolean,
    miscnotes               varchar(1024),
    email                   varchar(256),
    timestamp_num           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256) encode bytedict,
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(2048),
    attempt                 varchar(256),
    useragent               varchar(1024),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(4096),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.outreachemailresults
    owner to etluser;

grant select on integrated_aqe.outreachemailresults to group named_user_ro;

create table if not exists landing_aqe.memberinformation
(
    carrier_id                      bigint encode az64,
    memberinformationid             bigint encode az64,
    firstname                       varchar(100),
    lastname                        varchar(100),
    middlename                      varchar(50),
    phonenumber                     varchar(50),
    dob                             date encode az64,
    gender                          varchar(10),
    address1                        varchar(200),
    address2                        varchar(200),
    city                            varchar(100),
    state                           varchar(50),
    zipcode                         varchar(10),
    electionperiodinfo              varchar(1024),
    memberhicn                      varchar(256) distkey,
    sourcesystemtypeid              bigint encode az64,
    sourcesystemid                  varchar(50),
    clientuniqueid                  varchar(100),
    originalsourcefilename          varchar(1000),
    originalsourcefiledate          date encode az64,
    updatesfilename                 varchar(1000),
    contractnumber                  varchar(10),
    plancode                        varchar(20),
    planid                          bigint encode az64,
    planname                        varchar(256),
    planyear                        double precision,
    dateadded                       timestamp,
    twiliolanguageid                double precision,
    permissiontocontactthroughphone boolean,
    ptcdate                         timestamp encode az64,
    permissiontocontactthroughemail boolean,
    permissiontocontactthroughsms   boolean,
    preferredmethodofcontact        double precision,
    pcpfirstname                    varchar(100),
    pcplastname                     varchar(100),
    pcpaddress1                     varchar(200),
    pcpaddress2                     varchar(200),
    pcpcity                         varchar(100),
    pcpstate                        varchar(50),
    pcpzip                          varchar(10),
    pcpeffectivedate                date encode az64,
    iscallable                      boolean,
    isdeleted                       boolean,
    isactiveforoutreach             boolean,
    agencyname                      varchar(256),
    vbeactionid                     double precision,
    ascenduserid                    double precision,
    agentnpn                        varchar(255),
    applicationdate                 timestamp encode az64,
    vbememberid                     varchar(100),
    externalauthcode                varchar(8),
    deactivateddate                 timestamp encode az64,
    deactivatedreason               varchar(256),
    alternateexternalauthcode       varchar(25),
    updateddate                     timestamp encode az64,
    miscnotes                       varchar(256),
    beid                            double precision,
    ascendleadid                    double precision,
    smsattempts                     bigint encode az64,
    ivrattempts                     bigint encode az64,
    emailattempts                   bigint encode az64,
    county                          varchar(100),
    refresh_timestamp               timestamp encode az64
)
    sortkey (dateadded);

alter table landing_aqe.memberinformation
    owner to etluser;

create table if not exists staging_aqe.memberinformation
(
    carrier_id                      bigint encode az64,
    memberinformationid             bigint encode az64,
    firstname                       varchar(100),
    lastname                        varchar(100),
    middlename                      varchar(50),
    phonenumber                     varchar(50),
    dob                             date encode az64,
    gender                          varchar(10),
    address1                        varchar(200),
    address2                        varchar(200),
    city                            varchar(100),
    state                           varchar(50),
    zipcode                         varchar(10),
    electionperiodinfo              varchar(1024),
    memberhicn                      varchar(256) distkey,
    sourcesystemtypeid              bigint encode az64,
    sourcesystemid                  varchar(50),
    clientuniqueid                  varchar(100),
    originalsourcefilename          varchar(1000),
    originalsourcefiledate          date encode az64,
    updatesfilename                 varchar(1000),
    contractnumber                  varchar(10),
    plancode                        varchar(20),
    planid                          bigint encode az64,
    planname                        varchar(256),
    planyear                        bigint encode az64,
    dateadded                       timestamp encode az64,
    twiliolanguageid                bigint encode az64,
    permissiontocontactthroughphone boolean,
    ptcdate                         timestamp encode az64,
    permissiontocontactthroughemail boolean,
    permissiontocontactthroughsms   boolean,
    preferredmethodofcontact        bigint encode az64,
    pcpfirstname                    varchar(100),
    pcplastname                     varchar(100),
    pcpaddress1                     varchar(200),
    pcpaddress2                     varchar(200),
    pcpcity                         varchar(100),
    pcpstate                        varchar(50),
    pcpzip                          varchar(10),
    pcpeffectivedate                date encode az64,
    iscallable                      boolean,
    isdeleted                       boolean,
    isactiveforoutreach             boolean,
    agencyname                      varchar(256),
    vbeactionid                     bigint encode az64,
    ascenduserid                    bigint encode az64,
    agentnpn                        varchar(255),
    applicationdate                 timestamp encode az64,
    vbememberid                     varchar(100),
    externalauthcode                varchar(8),
    deactivateddate                 timestamp encode az64,
    deactivatedreason               varchar(256),
    alternateexternalauthcode       varchar(25),
    updateddate                     timestamp encode az64,
    miscnotes                       varchar(256),
    beid                            bigint encode az64,
    ascendleadid                    bigint encode az64,
    smsattempts                     bigint encode az64,
    ivrattempts                     bigint encode az64,
    emailattempts                   bigint encode az64,
    county                          varchar(100),
    refresh_timestamp               timestamp encode az64,
    data_action_indicator           char default 'N'::bpchar,
    data_transfer_log_id            bigint encode az64,
    md5_hash                        varchar(32)
);

alter table staging_aqe.memberinformation
    owner to etluser;

create table if not exists integrated_aqe.memberinformation
(
    dw_table_pk                     bigint default "identity"(348641, 0, '0,1'::text) encode az64,
    carrier_id                      bigint encode az64 distkey,
    memberinformationid             bigint encode az64,
    firstname                       varchar(100),
    lastname                        varchar(100),
    middlename                      varchar(50) encode bytedict,
    phonenumber                     varchar(50),
    dob                             date encode az64,
    gender                          varchar(10),
    address1                        varchar(200),
    address2                        varchar(200),
    city                            varchar(100),
    state                           varchar(50) encode bytedict,
    zipcode                         varchar(10),
    electionperiodinfo              varchar(1024) encode bytedict,
    memberhicn                      varchar(256),
    sourcesystemtypeid              bigint encode az64,
    sourcesystemid                  varchar(50),
    clientuniqueid                  varchar(100),
    originalsourcefilename          varchar(1000) encode bytedict,
    originalsourcefiledate          date encode az64,
    updatesfilename                 varchar(1000),
    contractnumber                  varchar(10),
    plancode                        varchar(20),
    planid                          bigint encode az64,
    planname                        varchar(256) encode bytedict,
    planyear                        bigint encode az64,
    dateadded                       timestamp encode az64,
    twiliolanguageid                bigint encode az64,
    permissiontocontactthroughphone boolean,
    ptcdate                         timestamp encode az64,
    permissiontocontactthroughemail boolean,
    permissiontocontactthroughsms   boolean,
    preferredmethodofcontact        bigint encode az64,
    pcpfirstname                    varchar(100),
    pcplastname                     varchar(100),
    pcpaddress1                     varchar(200),
    pcpaddress2                     varchar(200),
    pcpcity                         varchar(100),
    pcpstate                        varchar(50),
    pcpzip                          varchar(10),
    pcpeffectivedate                date encode az64,
    iscallable                      boolean,
    isdeleted                       boolean,
    isactiveforoutreach             boolean,
    agencyname                      varchar(256),
    vbeactionid                     bigint encode az64,
    ascenduserid                    bigint encode az64,
    agentnpn                        varchar(255),
    applicationdate                 timestamp encode az64,
    vbememberid                     varchar(100),
    externalauthcode                varchar(8),
    deactivateddate                 timestamp encode az64,
    deactivatedreason               varchar(256),
    alternateexternalauthcode       varchar(25),
    updateddate                     timestamp encode az64,
    miscnotes                       varchar(256) encode bytedict,
    beid                            bigint encode az64,
    ascendleadid                    bigint encode az64,
    smsattempts                     bigint encode az64,
    ivrattempts                     bigint encode az64,
    emailattempts                   bigint encode az64,
    county                          varchar(100),
    refresh_timestamp               timestamp,
    data_transfer_log_id            bigint encode az64,
    md5_hash                        varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.memberinformation
    owner to etluser;

grant select on integrated_aqe.memberinformation to group named_user_ro;

create table if not exists landing_aqe.hrainformationstatushistory
(
    carrier_id                    bigint encode az64,
    hrainformationstatushistoryid bigint encode az64 distkey,
    hrainformationid              bigint encode az64,
    hrastatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  double precision,
    buttonid                      double precision,
    actionid                      double precision,
    refresh_timestamp             timestamp encode az64
);

alter table landing_aqe.hrainformationstatushistory
    owner to etluser;

create table if not exists staging_aqe.hrainformationstatushistory
(
    carrier_id                    bigint encode az64,
    hrainformationstatushistoryid bigint encode az64,
    hrainformationid              bigint encode az64,
    hrastatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64 distkey,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp encode az64,
    data_action_indicator         char default 'N'::bpchar,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
);

alter table staging_aqe.hrainformationstatushistory
    owner to etluser;

create table if not exists integrated_aqe.hrainformationstatushistory
(
    dw_table_pk                   bigint default "identity"(348698, 0, '0,1'::text) encode az64,
    carrier_id                    bigint encode az64,
    hrainformationstatushistoryid bigint encode az64,
    hrainformationid              bigint encode az64 distkey,
    hrastatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.hrainformationstatushistory
    owner to etluser;

grant select on integrated_aqe.hrainformationstatushistory to group named_user_ro;

create table if not exists integrated_ccs.bloom_dispositioncategorymap
(
    dw_table_pk          bigint default "identity"(356889, 0, '0,1'::text) encode az64,
    dispcategorymapid    bigint encode az64,
    poolfk               bigint encode az64 distkey,
    callresultcode       bigint encode az64,
    dispcategoryid       bigint encode az64,
    sortorder            bigint encode az64,
    isdeleted            boolean,
    countaseligible      boolean,
    seminar              boolean,
    homevisit            boolean,
    agentconnect         boolean,
    mailinfo             boolean,
    dnc                  boolean,
    followup             boolean,
    statscategoryid      bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.bloom_dispositioncategorymap
    owner to etluser;

grant select on integrated_ccs.bloom_dispositioncategorymap to group named_user_ro;

create table if not exists integrated_ccs.bloom_dispositioncategories
(
    dw_table_pk           bigint default "identity"(356893, 0, '0,1'::text) encode az64,
    dispositioncategoryid bigint encode az64,
    dispcategory          varchar(100),
    isdeleted             boolean,
    auditusername         varchar(200),
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.bloom_dispositioncategories
    owner to etluser;

grant select on integrated_ccs.bloom_dispositioncategories to group named_user_ro;

create table if not exists integrated_ccs.agentstats
(
    dw_table_pk          bigint default "identity"(356897, 0, '0,1'::text) encode az64,
    pkagentstats         bigint encode az64 distkey,
    usersfk              integer encode az64,
    campaignfk           integer encode az64,
    pausetime            timestamp encode az64,
    waittime             timestamp encode az64,
    notavailabletime     timestamp encode az64,
    systemtime           timestamp encode az64,
    statsdate            timestamp encode az64,
    statstime            timestamp encode az64,
    numberofcampaigns    bigint encode az64,
    prevstate            bigint encode az64,
    nextstate            bigint encode az64,
    pausereasonfk        bigint encode az64,
    logoutreasonfk       bigint encode az64,
    pausereasontext      varchar(250),
    logoutreasontext     varchar(250),
    projecttype          bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.agentstats
    owner to etluser;

grant select on integrated_ccs.agentstats to group named_user_ro;

create table if not exists integrated_ccs.agentsigninoutlog
(
    dw_table_pk          bigint default "identity"(356901, 0, '0,1'::text) encode az64,
    pkrowid              bigint encode az64 distkey,
    usersfk              bigint encode az64,
    signin               timestamp encode az64,
    signout              timestamp encode az64,
    stationid            bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.agentsigninoutlog
    owner to etluser;

grant select on integrated_ccs.agentsigninoutlog to group named_user_ro;

create table if not exists integrated_ccs.agentgroups
(
    dw_table_pk          bigint default "identity"(356905, 0, '0,1'::text) encode az64,
    pkagentgroups        bigint encode az64,
    name                 varchar(100),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.agentgroups
    owner to etluser;

grant select on integrated_ccs.agentgroups to group named_user_ro;

create table if not exists integrated_ccs.agentgrouploginhistorymap
(
    dw_table_pk          bigint default "identity"(356909, 0, '0,1'::text) encode az64,
    agentgroupsfk        bigint encode az64,
    poolsfk              bigint encode az64,
    start                timestamp encode az64,
    stop                 timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.agentgrouploginhistorymap
    owner to etluser;

grant select on integrated_ccs.agentgrouploginhistorymap to group named_user_ro;

create table if not exists integrated_ccs.bloom_reportschedule
(
    dw_table_pk          bigint default "identity"(356917, 0, '0,1'::text) encode az64,
    id                   bigint encode az64 distkey,
    pookfk               bigint encode az64,
    reportname           varchar(256),
    begdate              timestamp encode az64,
    enddate              timestamp encode az64,
    dayofweek            bigint encode az64,
    beghour              bigint encode az64,
    endhour              bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(200),
    notes                varchar(500),
    isarchived           boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.bloom_reportschedule
    owner to etluser;

grant select on integrated_ccs.bloom_reportschedule to group named_user_ro;

create table if not exists integrated_ccs.callcomments
(
    dw_table_pk                          bigint default "identity"(356925, 0, ('0,1'::character varying)::text) encode az64,
    pkcomment                            bigint encode az64,
    comment                              varchar(1000),
    appt_id                              bigint encode az64,
    verify_flag                          boolean,
    updated                              boolean,
    origagentexitcode                    varchar(5),
    enrollment_id                        varchar(50),
    call_id                              varchar(50),
    enrollmenturi                        varchar(150),
    verification_id                      varchar(20),
    plantypename                         varchar(50),
    enrollment_id_2                      varchar(50),
    plantypename_2                       varchar(100),
    enrollmenturi_2                      varchar(150),
    verificationid_2                     varchar(20),
    twoproduct                           boolean,
    confirmation_id                      varchar(20),
    bloomenrollmentguid                  varchar(75),
    bloomnosaleguid                      varchar(75),
    vns_ezrefcode                        varchar(20),
    soa_id                               varchar(7),
    bloomcallid                          bigint encode az64,
    issuestatus                          varchar(50),
    clientreferenceid                    bigint encode az64,
    ivr_id                               bigint encode az64,
    issue_tracking_id                    varchar(50),
    fkgenericnotesid                     bigint encode az64,
    hmoid                                bigint encode az64,
    hapmailfulfillmenthistoryid          bigint encode az64,
    pcpinfoid                            bigint encode az64,
    hraresponseid                        bigint encode az64,
    ascendhelpdeskguid                   varchar(75),
    advisemailfulfillmenthistoryid       bigint encode az64,
    marketguid                           varchar(75),
    permissiontocontact                  boolean,
    advisefollowupguid                   varchar(75),
    advisefollowupemailid                bigint encode az64 distkey,
    ptcfk                                bigint encode az64,
    tcpafk                               bigint encode az64,
    cmsguid                              varchar(75),
    rsvp_eventfk                         bigint encode az64,
    safesellsoaconfirmation              varchar(50),
    safesellattestconfirmation           varchar(50),
    safesellfk                           bigint encode az64,
    gh_permissiontocontactfk             bigint encode az64,
    zinghealth_permissiontocontactfk     bigint encode az64,
    paramount_permissiontocontactfk      bigint encode az64,
    cncdemographicupdated                boolean,
    cncinterviewagreement                bigint encode az64,
    aetnaagentengage_calllistfk          bigint encode az64,
    aetnaagentengage_ae_namefk           bigint encode az64,
    zinghealth_cmsguid                   varchar(75),
    paramountvbe_confirmedplanid         bigint encode az64,
    bcbsmailfulfillmenthistoryid         bigint encode az64,
    centenepso_ae_appointmentrecordfk    varchar(400),
    callactions                          varchar(400),
    hcscsmallgroupsales_referralsourcefk bigint encode az64,
    ehealth_ehealthappinfofk             bigint encode az64,
    fk_focusedhealthdl_commentid         bigint encode az64,
    fk_focusedhealthxsell_commentid      bigint encode az64,
    clearspringsha_confirmedplanid       bigint encode az64,
    focusedhealthha_confirmedplanid      bigint encode az64,
    clearspringsales_commentid           bigint encode az64,
    aetnama_commentid                    bigint encode az64,
    medicalmutualma_commentid            bigint encode az64,
    medicalmutualhve_membercomplaintid   bigint encode az64,
    healthfirst_transfercustomerid       bigint encode az64,
    ascendbrokerhelpdesk_helpdeskissueid bigint encode az64,
    zinghealthha_confirmedplanid         bigint encode az64,
    zinghealthha_pcpinfoid               bigint encode az64,
    mmohve_pcpinfoid                     bigint encode az64,
    hf_verifymarxid                      bigint encode az64,
    refresh_timestamp                    timestamp,
    data_transfer_log_id                 bigint encode az64,
    md5_hash                             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.callcomments
    owner to etluser;

grant select on integrated_ccs.callcomments to group named_user_ro;

create table if not exists integrated_ccs.callresults
(
    dw_table_pk          bigint default "identity"(356929, 0, ('0,1'::character varying)::text) encode az64,
    pkcallresults        bigint encode az64,
    agentexitcode        bigint encode az64,
    agentwrapendtime     timestamp encode az64,
    autoattendant        boolean,
    callaccount          bigint encode az64,
    calldurationseconds  bigint encode az64,
    agentfk              bigint encode az64,
    callendtime          timestamp encode az64,
    contactnumber        varchar(32),
    callline             varchar(512) encode bytedict,
    callstarttime        timestamp encode az64,
    calltype             bigint encode az64,
    dnis                 varchar(32),
    exitstate            bigint encode az64,
    callwastransferred   boolean,
    overflowgroupfk      bigint encode az64,
    dateofcall           timestamp encode az64,
    dniscategoryfk       bigint encode az64,
    callsenttoagenttime  timestamp encode az64,
    voicemailstarttime   timestamp encode az64,
    voicemailstoptime    timestamp encode az64,
    contactnumberfk      bigint encode az64,
    poolfk               bigint encode az64,
    notes                varchar(256),
    recordingfilename    varchar(260),
    morephonenumbers     boolean,
    outofhours           boolean,
    query_id             bigint encode az64 distkey,
    commentfk            bigint encode az64,
    previewtime          timestamp encode az64,
    holdtime             timestamp encode az64,
    finaldisposition     bigint encode az64,
    appointmentid        bigint encode az64,
    agentactionid        bigint encode az64,
    emailfk              bigint encode az64,
    projecttype          bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.callresults
    owner to etluser;

grant select on integrated_ccs.callresults to group named_user_ro;

create table if not exists integrated_ccs.enrollmentinfo
(
    dw_table_pk          bigint default "identity"(356933, 0, ('0,1'::character varying)::text) encode az64,
    pkenrollmentinfo     bigint encode az64,
    lisstatus            varchar(10),
    bloomenrollmentguid  varchar(75),
    dateadded            timestamp encode az64,
    enrollmentid         varchar(256),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.enrollmentinfo
    owner to etluser;

grant select on integrated_ccs.enrollmentinfo to group named_user_ro;

create table if not exists integrated_ccs.reasons
(
    dw_table_pk          bigint default "identity"(356937, 0, ('0,1'::character varying)::text) encode az64,
    pkreason             bigint encode az64,
    logout               boolean,
    pause                boolean,
    text                 varchar(255),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.reasons
    owner to etluser;

grant select on integrated_ccs.reasons to group named_user_ro;

create table if not exists integrated_ccs.querymaps
(
    dw_table_pk          bigint default "identity"(356941, 0, ('0,1'::character varying)::text) encode az64,
    poolsfk              bigint encode az64,
    queriesfk            bigint encode az64,
    loadfactor           bigint encode az64,
    ordinal              bigint encode az64,
    liststate            bigint encode az64,
    outcomebased         boolean,
    targetleads          bigint encode az64,
    settostandby         boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.querymaps
    owner to etluser;

grant select on integrated_ccs.querymaps to group named_user_ro;

create table if not exists integrated_ccs.projecttoenginesmap
(
    dw_table_pk          bigint default "identity"(356945, 0, ('0,1'::character varying)::text) encode az64,
    projectfk            bigint encode az64,
    engineid             bigint encode az64 distkey,
    numberoflines        bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.projecttoenginesmap
    owner to etluser;

grant select on integrated_ccs.projecttoenginesmap to group named_user_ro;

create table if not exists integrated_ccs.pools
(
    dw_table_pk          bigint default "identity"(356949, 0, ('0,1'::character varying)::text) encode az64,
    pkpool               bigint encode az64,
    name                 varchar(255),
    databasename         varchar(255),
    dbtype               bigint encode az64,
    databaseserver       varchar(255),
    dbusername           varchar(50),
    dbpassword           varchar(50),
    dbusewindowssecurity boolean,
    isactive             boolean,
    isopen               boolean,
    isrunning            boolean,
    outboundscriptfk     bigint encode az64,
    verificationscriptfk bigint encode az64,
    manualdialscriptfk   bigint encode az64,
    callbackscriptfk     bigint encode az64,
    anitosend            varchar(50),
    bypassmdnc           boolean,
    starttime            varchar(15),
    stoptime             varchar(15),
    daysmap              bigint encode az64,
    companyname          varchar(255),
    idleonexhaust        boolean,
    ispaused             boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.pools
    owner to etluser;

grant select on integrated_ccs.pools to group named_user_ro;

create table if not exists integrated_ccs.poolquerymap
(
    dw_table_pk          bigint default "identity"(356953, 0, ('0,1'::character varying)::text) encode az64,
    poolsfk              bigint encode az64,
    queriesfk            bigint encode az64,
    loadfactor           bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.poolquerymap
    owner to etluser;

grant select on integrated_ccs.poolquerymap to group named_user_ro;

create table if not exists integrated_ccs.inboundconfiguration
(
    dw_table_pk                 bigint default "identity"(356957, 0, ('0,1'::character varying)::text) encode az64,
    pkinboundconfiguration      bigint encode az64,
    dnis                        varchar(1000),
    name                        varchar(50),
    dniscategoryfk              bigint encode az64,
    dbtype                      bigint encode az64,
    databasename                varchar(255),
    databaseserver              varchar(255),
    dbuserid                    varchar(50) distkey,
    dbpassword                  varchar(50),
    dbuseswindows               boolean,
    greetingmessage             varchar(65000),
    holdmessage                 varchar(65000),
    intermittentmessage         varchar(65000),
    intermittentinterval        bigint encode az64,
    notavailablemessage         varchar(65000),
    noagentsloggedinmessage     varchar(65000),
    overflowgroupfk             bigint encode az64,
    scriptsfk                   bigint encode az64,
    starttime                   varchar(15),
    stoptime                    varchar(15),
    daysmap                     bigint encode az64,
    isrunning                   boolean,
    lookuppage                  varchar(255),
    verificationscriptfk        bigint encode az64,
    manualdialscriptfk          bigint encode az64,
    callbackscriptfk            bigint encode az64,
    autocreaterecord            boolean,
    playstatsaftergreeting      boolean,
    playstatsperiodically       bigint encode az64,
    overflowivr                 varchar(255),
    anitosend                   varchar(50),
    companyname                 varchar(255),
    ringsbeforeanswer           bigint encode az64,
    voicemailboxfk              bigint encode az64,
    busyonslabreach             boolean,
    deliverystrategy            bigint encode az64,
    beforeconnecttoagentmessage varchar(65000),
    refresh_timestamp           timestamp,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.inboundconfiguration
    owner to etluser;

grant select on integrated_ccs.inboundconfiguration to group named_user_ro;

create table if not exists integrated_ccs.engines
(
    dw_table_pk          bigint default "identity"(356961, 0, ('0,1'::character varying)::text) encode az64,
    pkengine             bigint encode az64,
    name                 varchar(50),
    host                 varchar(50),
    port                 bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.engines
    owner to etluser;

grant select on integrated_ccs.engines to group named_user_ro;

create table if not exists integrated_ccs.dnismapping
(
    dw_table_pk          bigint default "identity"(356965, 0, ('0,1'::character varying)::text) encode az64,
    pkdnismapping        bigint encode az64,
    dnis                 varchar(10),
    dniscategoryfk       bigint encode az64,
    projectfk            bigint encode az64,
    lead_code            varchar(10),
    description          varchar(1000),
    dnis_cat_desc        varchar(50),
    project              varchar(100),
    sub_project          varchar(50),
    campaign             varchar(50),
    source               varchar(50),
    pi_tv                boolean,
    zone                 varchar(50),
    planname             varchar(60),
    transfer_from        varchar(50),
    scriptpage           varchar(100),
    bannertext           varchar(225),
    dnisstatusfk         bigint encode az64,
    modifieddate         timestamp encode az64,
    modifieduser         varchar(50),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.dnismapping
    owner to etluser;

grant select on integrated_ccs.dnismapping to group named_user_ro;

create table if not exists integrated_ccs.dniscategory
(
    dw_table_pk          bigint default "identity"(356969, 0, ('0,1'::character varying)::text) encode az64,
    pkdniscategory       bigint encode az64,
    dniscategoryname     varchar(50),
    deleted              boolean,
    clientrequested      varchar(30),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.dniscategory
    owner to etluser;

grant select on integrated_ccs.dniscategory to group named_user_ro;

create table if not exists integrated_ccs.calltypedescription
(
    dw_table_pk          bigint default "identity"(356973, 0, ('0,1'::character varying)::text) encode az64,
    calltype_id          bigint encode az64 distkey,
    calldirection        varchar(50),
    callshortdirection   varchar(50),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.calltypedescription
    owner to etluser;

grant select on integrated_ccs.calltypedescription to group named_user_ro;

create table if not exists integrated_ccs.callresultcodes
(
    dw_table_pk                bigint default "identity"(356977, 0, ('0,1'::character varying)::text) encode az64,
    callresultcode             bigint encode az64,
    callresultdescription      varchar(128),
    statuscode                 varchar(10),
    elderplancorecode          varchar(10),
    windsorcorecode            varchar(10),
    bluechoicecorecode         varchar(10),
    hphccorecode               varchar(10),
    avetacorecode              varchar(10),
    appttype                   varchar(5),
    heritage_apfcorecode       varchar(50),
    heritage_thcorecode        varchar(50),
    heritage_ghcorecode        varchar(50),
    heritage_sctcorecode       varchar(50),
    heritage_tfcorecode        varchar(50),
    arcadiancorecode           varchar(50),
    todaysoptionscorecode      varchar(50),
    todaysoptions_ccrxcorecode varchar(50),
    cs_uac_over65corecode      varchar(50),
    presentation               boolean,
    countaslead                boolean,
    printable                  boolean,
    systemcode                 boolean,
    verification               boolean,
    nevercall                  boolean,
    addtomasterdonotcall       boolean,
    printpage                  varchar(255),
    deleted                    boolean,
    phonenumbernevercall       boolean,
    countascontact             boolean,
    countassale                boolean,
    countasdonotmail           boolean,
    countasdonotcontact        boolean,
    countasdeceased            boolean,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.callresultcodes
    owner to etluser;

grant select on integrated_ccs.callresultcodes to group named_user_ro;

create table if not exists integrated_ccs.callbacks
(
    dw_table_pk          bigint default "identity"(356981, 0, ('0,1'::character varying)::text) encode az64,
    callbackfk           bigint encode az64,
    contactnumber        varchar(32),
    callbackdatetime     timestamp encode az64,
    stationid            bigint encode az64 distkey,
    contactnumberfk      bigint encode az64,
    contactinfofk        bigint encode az64,
    poolfk               bigint encode az64,
    comments             varchar(65000),
    userfk               bigint encode az64,
    agentgroupfk         bigint encode az64,
    voicememopath        varchar(250),
    listsourcefk         bigint encode az64,
    queryfk              bigint encode az64,
    callbacktype         bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.callbacks
    owner to etluser;

grant select on integrated_ccs.callbacks to group named_user_ro;

create table if not exists integrated_ccs.holidaycalender
(
    dw_table_pk          bigint default "identity"(356985, 0, ('0,1'::character varying)::text) encode az64,
    holidaycalenderid    bigint encode az64 distkey,
    poolfk               bigint encode az64,
    holidaydate          date encode az64,
    isdeleted            boolean,
    auditusername        varchar(200),
    notes                varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.holidaycalender
    owner to etluser;

grant select on integrated_ccs.holidaycalender to group named_user_ro;

create table if not exists integrated_ccs.stateabbreviations
(
    dw_table_pk          bigint default "identity"(356997, 0, ('0,1'::character varying)::text) encode az64,
    statefk              bigint encode az64,
    statecode            varchar(2),
    statename            varchar(75),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.stateabbreviations
    owner to etluser;

grant select on integrated_ccs.stateabbreviations to group named_user_ro;

create table if not exists landing_ccs.callcomments
(
    pkcomment                            bigint encode az64,
    comment                              varchar(1000),
    appt_id                              double precision,
    verify_flag                          boolean,
    updated                              boolean,
    origagentexitcode                    varchar(5),
    enrollment_id                        varchar(50) distkey,
    call_id                              varchar(50),
    enrollmenturi                        varchar(150),
    verification_id                      varchar(20),
    plantypename                         varchar(50),
    enrollment_id_2                      varchar(50),
    plantypename_2                       varchar(100),
    enrollmenturi_2                      varchar(150),
    verificationid_2                     varchar(20),
    twoproduct                           boolean,
    confirmation_id                      varchar(20),
    bloomenrollmentguid                  varchar(75),
    bloomnosaleguid                      varchar(75),
    vns_ezrefcode                        varchar(20),
    soa_id                               varchar(7),
    bloomcallid                          double precision,
    issuestatus                          varchar(50),
    clientreferenceid                    double precision,
    ivr_id                               double precision,
    issue_tracking_id                    varchar(50),
    fkgenericnotesid                     double precision,
    hmoid                                double precision,
    hapmailfulfillmenthistoryid          double precision,
    pcpinfoid                            double precision,
    hraresponseid                        double precision,
    ascendhelpdeskguid                   varchar(75),
    advisemailfulfillmenthistoryid       double precision,
    marketguid                           varchar(75),
    permissiontocontact                  boolean,
    advisefollowupguid                   varchar(75),
    advisefollowupemailid                double precision,
    ptcfk                                double precision,
    tcpafk                               double precision,
    cmsguid                              varchar(75),
    rsvp_eventfk                         double precision,
    safesellsoaconfirmation              varchar(50),
    safesellattestconfirmation           varchar(50),
    safesellfk                           double precision,
    gh_permissiontocontactfk             double precision,
    zinghealth_permissiontocontactfk     double precision,
    paramount_permissiontocontactfk      double precision,
    cncdemographicupdated                boolean,
    cncinterviewagreement                double precision,
    aetnaagentengage_calllistfk          double precision,
    aetnaagentengage_ae_namefk           double precision,
    zinghealth_cmsguid                   varchar(75),
    paramountvbe_confirmedplanid         double precision,
    bcbsmailfulfillmenthistoryid         double precision,
    centenepso_ae_appointmentrecordfk    varchar(400),
    callactions                          varchar(400),
    hcscsmallgroupsales_referralsourcefk double precision,
    ehealth_ehealthappinfofk             double precision,
    fk_focusedhealthdl_commentid         double precision,
    fk_focusedhealthxsell_commentid      double precision,
    clearspringsha_confirmedplanid       double precision,
    focusedhealthha_confirmedplanid      double precision,
    clearspringsales_commentid           double precision,
    aetnama_commentid                    double precision,
    medicalmutualma_commentid            double precision,
    medicalmutualhve_membercomplaintid   double precision,
    healthfirst_transfercustomerid       double precision,
    ascendbrokerhelpdesk_helpdeskissueid double precision,
    zinghealthha_confirmedplanid         double precision,
    zinghealthha_pcpinfoid               double precision,
    mmohve_pcpinfoid                     double precision,
    hf_verifymarxid                      double precision,
    refresh_timestamp                    timestamp encode az64
)
    diststyle key;

alter table landing_ccs.callcomments
    owner to etluser;

create table if not exists landing_ccs.callresults
(
    pkcallresults       bigint encode az64,
    agentexitcode       double precision,
    agentwrapendtime    timestamp encode az64,
    autoattendant       boolean,
    callaccount         double precision,
    calldurationseconds double precision,
    agentfk             double precision,
    callendtime         timestamp encode az64,
    contactnumber       varchar(32),
    callline            varchar(512),
    callstarttime       timestamp encode az64,
    calltype            double precision,
    dnis                varchar(32),
    exitstate           double precision,
    callwastransferred  boolean,
    overflowgroupfk     double precision,
    dateofcall          timestamp encode az64,
    dniscategoryfk      double precision,
    callsenttoagenttime timestamp encode az64,
    voicemailstarttime  timestamp encode az64,
    voicemailstoptime   timestamp encode az64,
    contactnumberfk     double precision,
    poolfk              double precision,
    notes               varchar(256),
    recordingfilename   varchar(260),
    morephonenumbers    boolean,
    outofhours          boolean,
    query_id            double precision,
    commentfk           double precision,
    previewtime         timestamp encode az64,
    holdtime            timestamp encode az64,
    finaldisposition    double precision,
    appointmentid       double precision,
    agentactionid       double precision,
    emailfk             double precision,
    projecttype         double precision,
    refresh_timestamp   timestamp encode az64
);

alter table landing_ccs.callresults
    owner to etluser;

create table if not exists landing_ccs.enrollmentinfo
(
    pkenrollmentinfo    bigint encode az64,
    lisstatus           varchar(10),
    bloomenrollmentguid varchar(75),
    dateadded           timestamp,
    enrollmentid        varchar(256),
    refresh_timestamp   timestamp encode az64
)
    sortkey (dateadded);

alter table landing_ccs.enrollmentinfo
    owner to etluser;

create table if not exists landing_ccs.bloom_dispositioncategorymap
(
    dispcategorymapid bigint encode az64,
    poolfk            double precision,
    callresultcode    double precision,
    dispcategoryid    double precision,
    sortorder         double precision,
    isdeleted         boolean,
    countaseligible   boolean,
    seminar           boolean,
    homevisit         boolean,
    agentconnect      boolean,
    mailinfo          boolean,
    dnc               boolean,
    followup          boolean,
    statscategoryid   double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloom_dispositioncategorymap
    owner to etluser;

create table if not exists landing_ccs.bloom_dispositioncategories
(
    dispositioncategoryid bigint encode az64,
    dispcategory          varchar(100),
    isdeleted             boolean,
    auditusername         varchar(200),
    refresh_timestamp     timestamp encode az64
);

alter table landing_ccs.bloom_dispositioncategories
    owner to etluser;

create table if not exists landing_ccs.agentstats
(
    pkagentstats      bigint encode az64 distkey,
    usersfk           double precision,
    campaignfk        double precision,
    pausetime         timestamp encode az64,
    waittime          timestamp encode az64,
    notavailabletime  timestamp encode az64,
    systemtime        timestamp encode az64,
    statsdate         timestamp encode az64,
    statstime         timestamp encode az64,
    numberofcampaigns double precision,
    prevstate         bigint encode az64,
    nextstate         bigint encode az64,
    pausereasonfk     double precision,
    logoutreasonfk    double precision,
    pausereasontext   varchar(250),
    logoutreasontext  varchar(250),
    projecttype       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.agentstats
    owner to etluser;

create table if not exists landing_ccs.agentsigninoutlog
(
    pkrowid           bigint distkey,
    usersfk           bigint encode az64,
    signin            timestamp encode az64,
    signout           timestamp encode az64,
    stationid         double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (pkrowid);

alter table landing_ccs.agentsigninoutlog
    owner to etluser;

create table if not exists landing_ccs.reasons
(
    pkreason          bigint encode az64,
    logout            boolean,
    pause             boolean,
    text              varchar(255),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.reasons
    owner to etluser;

create table if not exists landing_ccs.querymaps
(
    poolsfk           bigint encode az64,
    queriesfk         bigint encode az64,
    loadfactor        bigint encode az64,
    ordinal           bigint encode az64,
    liststate         bigint encode az64,
    outcomebased      boolean,
    targetleads       bigint encode az64,
    settostandby      boolean,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.querymaps
    owner to etluser;

create table if not exists landing_ccs.projecttoenginesmap
(
    projectfk         bigint encode az64,
    engineid          bigint encode az64,
    numberoflines     double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.projecttoenginesmap
    owner to etluser;

create table if not exists landing_ccs.pools
(
    pkpool               bigint encode az64,
    name                 varchar(255),
    databasename         varchar(255),
    dbtype               double precision,
    databaseserver       varchar(255),
    dbusername           varchar(50),
    dbpassword           varchar(50),
    dbusewindowssecurity boolean,
    isactive             boolean,
    isopen               boolean,
    isrunning            boolean,
    outboundscriptfk     double precision,
    verificationscriptfk double precision,
    manualdialscriptfk   double precision,
    callbackscriptfk     double precision,
    anitosend            varchar(50),
    bypassmdnc           boolean,
    starttime            varchar(15),
    stoptime             varchar(15),
    daysmap              double precision,
    companyname          varchar(255),
    idleonexhaust        boolean,
    ispaused             boolean,
    refresh_timestamp    timestamp encode az64
);

alter table landing_ccs.pools
    owner to etluser;

create table if not exists landing_ccs.poolquerymap
(
    poolsfk           bigint encode az64,
    queriesfk         bigint encode az64,
    loadfactor        bigint encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.poolquerymap
    owner to etluser;

create table if not exists landing_ccs.inboundconfiguration
(
    pkinboundconfiguration      bigint encode az64,
    dnis                        varchar(1000),
    name                        varchar(50),
    dniscategoryfk              bigint encode az64,
    dbtype                      bigint encode az64,
    databasename                varchar(255),
    databaseserver              varchar(255),
    dbuserid                    varchar(50),
    dbpassword                  varchar(50),
    dbuseswindows               boolean,
    greetingmessage             varchar(65000),
    holdmessage                 varchar(65000),
    intermittentmessage         varchar(65000),
    intermittentinterval        bigint encode az64,
    notavailablemessage         varchar(65000),
    noagentsloggedinmessage     varchar(65000),
    overflowgroupfk             bigint encode az64,
    scriptsfk                   bigint encode az64,
    starttime                   varchar(15),
    stoptime                    varchar(15),
    daysmap                     bigint encode az64,
    isrunning                   boolean,
    lookuppage                  varchar(255),
    verificationscriptfk        bigint encode az64,
    manualdialscriptfk          bigint encode az64,
    callbackscriptfk            bigint encode az64,
    autocreaterecord            boolean,
    playstatsaftergreeting      boolean,
    playstatsperiodically       bigint encode az64,
    overflowivr                 varchar(255),
    anitosend                   varchar(50),
    companyname                 varchar(255),
    ringsbeforeanswer           bigint encode az64,
    voicemailboxfk              double precision,
    busyonslabreach             boolean,
    deliverystrategy            bigint encode az64,
    beforeconnecttoagentmessage varchar(65000),
    refresh_timestamp           timestamp encode az64
);

alter table landing_ccs.inboundconfiguration
    owner to etluser;

create table if not exists landing_ccs.engines
(
    pkengine          bigint encode az64,
    name              varchar(50),
    host              varchar(50),
    port              bigint encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.engines
    owner to etluser;

create table if not exists landing_ccs.dnismapping
(
    pkdnismapping     bigint,
    dnis              varchar(10),
    dniscategoryfk    bigint encode az64,
    projectfk         double precision,
    lead_code         varchar(10),
    description       varchar(1000),
    dnis_cat_desc     varchar(50),
    project           varchar(100),
    sub_project       varchar(50),
    campaign          varchar(50),
    source            varchar(50),
    pi_tv             boolean,
    zone              varchar(50),
    planname          varchar(60),
    transfer_from     varchar(50),
    scriptpage        varchar(100),
    bannertext        varchar(225),
    dnisstatusfk      double precision,
    modifieddate      timestamp encode az64,
    modifieduser      varchar(50),
    refresh_timestamp timestamp encode az64
)
    sortkey (pkdnismapping);

alter table landing_ccs.dnismapping
    owner to etluser;

create table if not exists landing_ccs.dniscategory
(
    pkdniscategory    bigint encode az64,
    dniscategoryname  varchar(50),
    deleted           boolean,
    clientrequested   varchar(30),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.dniscategory
    owner to etluser;

create table if not exists landing_ccs.calltypedescription
(
    calltype_id        bigint encode az64,
    calldirection      varchar(50),
    callshortdirection varchar(50),
    refresh_timestamp  timestamp encode az64
);

alter table landing_ccs.calltypedescription
    owner to etluser;

create table if not exists landing_ccs.callresultcodes
(
    callresultcode             bigint encode az64,
    callresultdescription      varchar(128),
    statuscode                 varchar(10),
    elderplancorecode          varchar(10),
    windsorcorecode            varchar(10),
    bluechoicecorecode         varchar(10),
    hphccorecode               varchar(10),
    avetacorecode              varchar(10),
    appttype                   varchar(5),
    heritage_apfcorecode       varchar(50),
    heritage_thcorecode        varchar(50),
    heritage_ghcorecode        varchar(50),
    heritage_sctcorecode       varchar(50),
    heritage_tfcorecode        varchar(50),
    arcadiancorecode           varchar(50),
    todaysoptionscorecode      varchar(50),
    todaysoptions_ccrxcorecode varchar(50),
    cs_uac_over65corecode      varchar(50),
    presentation               boolean,
    countaslead                boolean,
    printable                  boolean,
    systemcode                 boolean,
    verification               boolean,
    nevercall                  boolean,
    addtomasterdonotcall       boolean,
    printpage                  varchar(255),
    deleted                    boolean,
    phonenumbernevercall       boolean,
    countascontact             boolean,
    countassale                boolean,
    countasdonotmail           boolean,
    countasdonotcontact        boolean,
    countasdeceased            boolean,
    refresh_timestamp          timestamp encode az64
);

alter table landing_ccs.callresultcodes
    owner to etluser;

create table if not exists landing_ccs.callbacks
(
    callbackfk        bigint encode az64,
    contactnumber     varchar(32),
    callbackdatetime  timestamp,
    stationid         double precision,
    contactnumberfk   double precision,
    contactinfofk     double precision,
    poolfk            double precision,
    comments          varchar(65000),
    userfk            double precision,
    agentgroupfk      double precision,
    voicememopath     varchar(250),
    listsourcefk      bigint encode az64,
    queryfk           bigint encode az64,
    callbacktype      bigint encode az64,
    refresh_timestamp timestamp encode az64
)
    sortkey (callbackdatetime);

alter table landing_ccs.callbacks
    owner to etluser;

create table if not exists landing_ccs.agentgroups
(
    pkagentgroups     bigint encode az64,
    name              varchar(100),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.agentgroups
    owner to etluser;

create table if not exists landing_ccs.agentgrouploginhistorymap
(
    agentgroupsfk     bigint encode az64,
    poolsfk           bigint encode az64,
    start             timestamp encode az64,
    stop              timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.agentgrouploginhistorymap
    owner to etluser;

create table if not exists landing_ccs.bloom_reportschedule
(
    id                bigint encode az64 distkey,
    pookfk            double precision,
    reportname        varchar(256),
    begdate           timestamp encode az64,
    enddate           timestamp encode az64,
    dayofweek         double precision,
    beghour           double precision,
    endhour           double precision,
    isdeleted         boolean,
    auditusername     varchar(200),
    notes             varchar(500),
    isarchived        boolean,
    refresh_timestamp timestamp encode az64
)
    diststyle key;

alter table landing_ccs.bloom_reportschedule
    owner to etluser;

create table if not exists landing_ccs.holidaycalender
(
    holidaycalenderid bigint encode az64 distkey,
    poolfk            double precision,
    holidaydate       date encode az64,
    isdeleted         boolean,
    auditusername     varchar(200),
    notes             varchar(500),
    refresh_timestamp timestamp encode az64
)
    diststyle key;

alter table landing_ccs.holidaycalender
    owner to etluser;

create table if not exists landing_ccs.stateabbreviations
(
    statefk           bigint encode az64,
    statecode         varchar(2),
    statename         varchar(75),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.stateabbreviations
    owner to etluser;

create table if not exists staging_ccs.callcomments
(
    pkcomment                            bigint encode az64,
    comment                              varchar(1000),
    appt_id                              bigint encode az64,
    verify_flag                          boolean,
    updated                              boolean,
    origagentexitcode                    varchar(5),
    enrollment_id                        varchar(50),
    call_id                              varchar(50),
    enrollmenturi                        varchar(150),
    verification_id                      varchar(20),
    plantypename                         varchar(50),
    enrollment_id_2                      varchar(50),
    plantypename_2                       varchar(100),
    enrollmenturi_2                      varchar(150),
    verificationid_2                     varchar(20),
    twoproduct                           boolean,
    confirmation_id                      varchar(20),
    bloomenrollmentguid                  varchar(75),
    bloomnosaleguid                      varchar(75),
    vns_ezrefcode                        varchar(20),
    soa_id                               varchar(7),
    bloomcallid                          bigint encode az64,
    issuestatus                          varchar(50),
    clientreferenceid                    bigint encode az64,
    ivr_id                               bigint encode az64,
    issue_tracking_id                    varchar(50),
    fkgenericnotesid                     bigint encode az64,
    hmoid                                bigint encode az64,
    hapmailfulfillmenthistoryid          bigint encode az64,
    pcpinfoid                            bigint encode az64,
    hraresponseid                        bigint encode az64,
    ascendhelpdeskguid                   varchar(75),
    advisemailfulfillmenthistoryid       bigint encode az64,
    marketguid                           varchar(75),
    permissiontocontact                  boolean,
    advisefollowupguid                   varchar(75),
    advisefollowupemailid                bigint encode az64 distkey,
    ptcfk                                bigint encode az64,
    tcpafk                               bigint encode az64,
    cmsguid                              varchar(75),
    rsvp_eventfk                         bigint encode az64,
    safesellsoaconfirmation              varchar(50),
    safesellattestconfirmation           varchar(50),
    safesellfk                           bigint encode az64,
    gh_permissiontocontactfk             bigint encode az64,
    zinghealth_permissiontocontactfk     bigint encode az64,
    paramount_permissiontocontactfk      bigint encode az64,
    cncdemographicupdated                boolean,
    cncinterviewagreement                bigint encode az64,
    aetnaagentengage_calllistfk          bigint encode az64,
    aetnaagentengage_ae_namefk           bigint encode az64,
    zinghealth_cmsguid                   varchar(75),
    paramountvbe_confirmedplanid         bigint encode az64,
    bcbsmailfulfillmenthistoryid         bigint encode az64,
    centenepso_ae_appointmentrecordfk    varchar(400),
    callactions                          varchar(400),
    hcscsmallgroupsales_referralsourcefk bigint encode az64,
    ehealth_ehealthappinfofk             bigint encode az64,
    fk_focusedhealthdl_commentid         bigint encode az64,
    fk_focusedhealthxsell_commentid      bigint encode az64,
    clearspringsha_confirmedplanid       bigint encode az64,
    focusedhealthha_confirmedplanid      bigint encode az64,
    clearspringsales_commentid           bigint encode az64,
    aetnama_commentid                    bigint encode az64,
    medicalmutualma_commentid            bigint encode az64,
    medicalmutualhve_membercomplaintid   bigint encode az64,
    healthfirst_transfercustomerid       bigint encode az64,
    ascendbrokerhelpdesk_helpdeskissueid bigint encode az64,
    zinghealthha_confirmedplanid         bigint encode az64,
    zinghealthha_pcpinfoid               bigint encode az64,
    mmohve_pcpinfoid                     bigint encode az64,
    hf_verifymarxid                      bigint encode az64,
    refresh_timestamp                    timestamp encode az64,
    data_action_indicator                char default 'N'::bpchar,
    data_transfer_log_id                 bigint encode az64,
    md5_hash                             varchar(32)
)
    diststyle key;

alter table staging_ccs.callcomments
    owner to etluser;

create table if not exists staging_ccs.callresults
(
    pkcallresults         bigint encode az64,
    agentexitcode         bigint encode az64,
    agentwrapendtime      timestamp encode az64,
    autoattendant         boolean,
    callaccount           bigint encode az64,
    calldurationseconds   bigint encode az64,
    agentfk               bigint encode az64,
    callendtime           timestamp encode az64,
    contactnumber         varchar(32),
    callline              varchar(512),
    callstarttime         timestamp encode az64,
    calltype              bigint encode az64,
    dnis                  varchar(32),
    exitstate             bigint encode az64,
    callwastransferred    boolean,
    overflowgroupfk       bigint encode az64,
    dateofcall            timestamp encode az64,
    dniscategoryfk        bigint encode az64,
    callsenttoagenttime   timestamp encode az64,
    voicemailstarttime    timestamp encode az64,
    voicemailstoptime     timestamp encode az64,
    contactnumberfk       bigint encode az64,
    poolfk                bigint encode az64,
    notes                 varchar(256),
    recordingfilename     varchar(260),
    morephonenumbers      boolean,
    outofhours            boolean,
    query_id              bigint encode az64 distkey,
    commentfk             bigint encode az64,
    previewtime           timestamp encode az64,
    holdtime              timestamp encode az64,
    finaldisposition      bigint encode az64,
    appointmentid         bigint encode az64,
    agentactionid         bigint encode az64,
    emailfk               bigint encode az64,
    projecttype           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.callresults
    owner to etluser;

create table if not exists staging_ccs.enrollmentinfo
(
    pkenrollmentinfo      bigint encode az64,
    lisstatus             varchar(10),
    bloomenrollmentguid   varchar(75),
    dateadded             timestamp encode az64,
    enrollmentid          varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.enrollmentinfo
    owner to etluser;

create table if not exists staging_ccs.bloom_dispositioncategorymap
(
    dispcategorymapid     bigint encode az64,
    poolfk                bigint encode az64 distkey,
    callresultcode        bigint encode az64,
    dispcategoryid        bigint encode az64,
    sortorder             bigint encode az64,
    isdeleted             boolean,
    countaseligible       boolean,
    seminar               boolean,
    homevisit             boolean,
    agentconnect          boolean,
    mailinfo              boolean,
    dnc                   boolean,
    followup              boolean,
    statscategoryid       bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.bloom_dispositioncategorymap
    owner to etluser;

create table if not exists staging_ccs.bloom_dispositioncategories
(
    dispositioncategoryid bigint encode az64,
    dispcategory          varchar(100),
    isdeleted             boolean,
    auditusername         varchar(200),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloom_dispositioncategories
    owner to etluser;

create table if not exists staging_ccs.agentstats
(
    pkagentstats          bigint encode az64,
    usersfk               integer encode az64,
    campaignfk            integer encode az64,
    pausetime             timestamp encode az64,
    waittime              timestamp encode az64,
    notavailabletime      timestamp encode az64,
    systemtime            timestamp encode az64,
    statsdate             timestamp encode az64,
    statstime             timestamp encode az64,
    numberofcampaigns     bigint encode az64,
    prevstate             bigint encode az64,
    nextstate             bigint encode az64,
    pausereasonfk         bigint encode az64,
    logoutreasonfk        bigint encode az64,
    pausereasontext       varchar(250),
    logoutreasontext      varchar(250),
    projecttype           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.agentstats
    owner to etluser;

create table if not exists staging_ccs.agentsigninoutlog
(
    pkrowid               bigint encode az64 distkey,
    usersfk               bigint encode az64,
    signin                timestamp encode az64,
    signout               timestamp encode az64,
    stationid             bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.agentsigninoutlog
    owner to etluser;

create table if not exists staging_ccs.reasons
(
    pkreason              bigint encode az64,
    logout                boolean,
    pause                 boolean,
    text                  varchar(255),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    sortkey (logout);

alter table staging_ccs.reasons
    owner to etluser;

create table if not exists staging_ccs.querymaps
(
    poolsfk               bigint encode az64,
    queriesfk             bigint encode az64,
    loadfactor            bigint encode az64,
    ordinal               bigint encode az64,
    liststate             bigint encode az64,
    outcomebased          boolean,
    targetleads           bigint encode az64,
    settostandby          boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.querymaps
    owner to etluser;

create table if not exists staging_ccs.projecttoenginesmap
(
    projectfk             bigint encode az64,
    engineid              bigint encode az64 distkey,
    numberoflines         bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.projecttoenginesmap
    owner to etluser;

create table if not exists staging_ccs.pools
(
    pkpool                bigint encode az64,
    name                  varchar(255),
    databasename          varchar(255),
    dbtype                bigint encode az64,
    databaseserver        varchar(255),
    dbusername            varchar(50),
    dbpassword            varchar(50),
    dbusewindowssecurity  boolean,
    isactive              boolean,
    isopen                boolean,
    isrunning             boolean,
    outboundscriptfk      bigint encode az64,
    verificationscriptfk  bigint encode az64,
    manualdialscriptfk    bigint encode az64,
    callbackscriptfk      bigint encode az64,
    anitosend             varchar(50),
    bypassmdnc            boolean,
    starttime             varchar(15),
    stoptime              varchar(15),
    daysmap               bigint encode az64,
    companyname           varchar(255),
    idleonexhaust         boolean,
    ispaused              boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.pools
    owner to etluser;

create table if not exists staging_ccs.poolquerymap
(
    poolsfk               bigint encode az64,
    queriesfk             bigint encode az64,
    loadfactor            bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.poolquerymap
    owner to etluser;

create table if not exists staging_ccs.inboundconfiguration
(
    pkinboundconfiguration      bigint encode az64,
    dnis                        varchar(1000),
    name                        varchar(50),
    dniscategoryfk              bigint encode az64,
    dbtype                      bigint encode az64,
    databasename                varchar(255),
    databaseserver              varchar(255),
    dbuserid                    varchar(50) distkey,
    dbpassword                  varchar(50),
    dbuseswindows               boolean,
    greetingmessage             varchar(65000),
    holdmessage                 varchar(65000),
    intermittentmessage         varchar(65000),
    intermittentinterval        bigint encode az64,
    notavailablemessage         varchar(65000),
    noagentsloggedinmessage     varchar(65000),
    overflowgroupfk             bigint encode az64,
    scriptsfk                   bigint encode az64,
    starttime                   varchar(15),
    stoptime                    varchar(15),
    daysmap                     bigint encode az64,
    isrunning                   boolean,
    lookuppage                  varchar(255),
    verificationscriptfk        bigint encode az64,
    manualdialscriptfk          bigint encode az64,
    callbackscriptfk            bigint encode az64,
    autocreaterecord            boolean,
    playstatsaftergreeting      boolean,
    playstatsperiodically       bigint encode az64,
    overflowivr                 varchar(255),
    anitosend                   varchar(50),
    companyname                 varchar(255),
    ringsbeforeanswer           bigint encode az64,
    voicemailboxfk              bigint encode az64,
    busyonslabreach             boolean,
    deliverystrategy            bigint encode az64,
    beforeconnecttoagentmessage varchar(65000),
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
)
    diststyle key;

alter table staging_ccs.inboundconfiguration
    owner to etluser;

create table if not exists staging_ccs.engines
(
    pkengine              bigint encode az64,
    name                  varchar(50),
    host                  varchar(50),
    port                  bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.engines
    owner to etluser;

create table if not exists staging_ccs.dnismapping
(
    pkdnismapping         bigint encode az64,
    dnis                  varchar(10),
    dniscategoryfk        bigint encode az64,
    projectfk             bigint encode az64,
    lead_code             varchar(10),
    description           varchar(1000),
    dnis_cat_desc         varchar(50),
    project               varchar(100),
    sub_project           varchar(50),
    campaign              varchar(50),
    source                varchar(50),
    pi_tv                 boolean,
    zone                  varchar(50),
    planname              varchar(60),
    transfer_from         varchar(50),
    scriptpage            varchar(100),
    bannertext            varchar(225),
    dnisstatusfk          bigint encode az64,
    modifieddate          timestamp encode az64,
    modifieduser          varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.dnismapping
    owner to etluser;

create table if not exists staging_ccs.dniscategory
(
    pkdniscategory        bigint encode az64,
    dniscategoryname      varchar(50),
    deleted               boolean,
    clientrequested       varchar(30),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.dniscategory
    owner to etluser;

create table if not exists staging_ccs.calltypedescription
(
    calltype_id           bigint encode az64 distkey,
    calldirection         varchar(50),
    callshortdirection    varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.calltypedescription
    owner to etluser;

create table if not exists staging_ccs.callresultcodes
(
    callresultcode             bigint encode az64,
    callresultdescription      varchar(128),
    statuscode                 varchar(10),
    elderplancorecode          varchar(10),
    windsorcorecode            varchar(10),
    bluechoicecorecode         varchar(10),
    hphccorecode               varchar(10),
    avetacorecode              varchar(10),
    appttype                   varchar(5),
    heritage_apfcorecode       varchar(50),
    heritage_thcorecode        varchar(50),
    heritage_ghcorecode        varchar(50),
    heritage_sctcorecode       varchar(50),
    heritage_tfcorecode        varchar(50),
    arcadiancorecode           varchar(50),
    todaysoptionscorecode      varchar(50),
    todaysoptions_ccrxcorecode varchar(50),
    cs_uac_over65corecode      varchar(50),
    presentation               boolean,
    countaslead                boolean,
    printable                  boolean,
    systemcode                 boolean,
    verification               boolean,
    nevercall                  boolean,
    addtomasterdonotcall       boolean,
    printpage                  varchar(255),
    deleted                    boolean,
    phonenumbernevercall       boolean,
    countascontact             boolean,
    countassale                boolean,
    countasdonotmail           boolean,
    countasdonotcontact        boolean,
    countasdeceased            boolean,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_ccs.callresultcodes
    owner to etluser;

create table if not exists staging_ccs.callbacks
(
    callbackfk            bigint encode az64,
    contactnumber         varchar(32),
    callbackdatetime      timestamp encode az64,
    stationid             bigint encode az64 distkey,
    contactnumberfk       bigint encode az64,
    contactinfofk         bigint encode az64,
    poolfk                bigint encode az64,
    comments              varchar(65000),
    userfk                bigint encode az64,
    agentgroupfk          bigint encode az64,
    voicememopath         varchar(250),
    listsourcefk          bigint encode az64,
    queryfk               bigint encode az64,
    callbacktype          bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.callbacks
    owner to etluser;

create table if not exists staging_ccs.agentgroups
(
    pkagentgroups         bigint encode az64,
    name                  varchar(100),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.agentgroups
    owner to etluser;

create table if not exists staging_ccs.agentgrouploginhistorymap
(
    agentgroupsfk         bigint encode az64,
    poolsfk               bigint encode az64,
    start                 timestamp encode az64,
    stop                  timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.agentgrouploginhistorymap
    owner to etluser;

create table if not exists staging_ccs.bloom_reportschedule
(
    id                    bigint encode az64 distkey,
    pookfk                bigint encode az64,
    reportname            varchar(256),
    begdate               timestamp encode az64,
    enddate               timestamp encode az64,
    dayofweek             bigint encode az64,
    beghour               bigint encode az64,
    endhour               bigint encode az64,
    isdeleted             boolean,
    auditusername         varchar(200),
    notes                 varchar(500),
    isarchived            boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.bloom_reportschedule
    owner to etluser;

create table if not exists staging_ccs.holidaycalender
(
    holidaycalenderid     bigint encode az64 distkey,
    poolfk                bigint encode az64,
    holidaydate           date encode az64,
    isdeleted             boolean,
    auditusername         varchar(200),
    notes                 varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.holidaycalender
    owner to etluser;

create table if not exists staging_ccs.stateabbreviations
(
    statefk               bigint encode az64,
    statecode             varchar(2),
    statename             varchar(75),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.stateabbreviations
    owner to etluser;

create table if not exists landing_aqe.dynamo_persontype
(
    persontypeid      bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.dynamo_persontype
    owner to etluser;

create table if not exists staging_aqe.dynamo_persontype
(
    persontypeid          bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.dynamo_persontype
    owner to etluser;

create table if not exists integrated_aqe.dynamo_persontype
(
    dw_table_pk          bigint default "identity"(396657, 0, '0,1'::text) encode az64,
    persontypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.dynamo_persontype
    owner to etluser;

grant select on integrated_aqe.dynamo_persontype to group named_user_ro;

create table if not exists landing_aqe.wipro
(
    carrier_id                 bigint encode az64,
    wiproid                    bigint distkey,
    txndate                    varchar(256),
    mbdloadeffdate             varchar(256),
    requesthicnbr              varchar(256),
    requestlastname            varchar(256),
    requestdob                 varchar(256),
    foundhicnbr                varchar(256),
    foundnameordob             varchar(256),
    inquiryresponse            varchar(256),
    hicnbr                     varchar(256),
    lastname                   varchar(256),
    firstname                  varchar(256),
    middleinitial              varchar(256),
    gendercd                   varchar(256),
    racecd                     varchar(256),
    birthdate                  varchar(256),
    prtaentitlementdate        varchar(256),
    prtaentitleenddate         varchar(256),
    prtbentitlementdate        varchar(256),
    prtbentitleenddate         varchar(256),
    statecd                    varchar(256),
    countycd                   varchar(256),
    hospicestatus              varchar(256),
    hospicestartdate           varchar(256),
    hospiceenddate             varchar(256),
    inststatus                 varchar(256),
    inststartdate              varchar(256),
    instenddate                varchar(256),
    esrdstatus                 varchar(256),
    esrdstartdate              varchar(256),
    esrdenddate                varchar(256),
    medicaidstatus             varchar(256),
    medicaidstartdate          varchar(256),
    medicaidenddate            varchar(256),
    eghpind                    varchar(256),
    livingstatus               varchar(256),
    deathdate                  varchar(256),
    xrefhicnbr                 varchar(256),
    potentialuncvrdmths        varchar(256),
    potentialuncvrdmthseffdate varchar(256),
    prtdeligibledate           varchar(256),
    planyear                   double precision,
    miscnotes                  varchar(500),
    wiprojson                  varchar(8192),
    refresh_timestamp          timestamp encode az64
)
    sortkey (wiproid);

alter table landing_aqe.wipro
    owner to etluser;

create table if not exists staging_aqe.wipro
(
    carrier_id                 bigint encode az64,
    wiproid                    bigint encode az64 distkey,
    txndate                    varchar(256),
    mbdloadeffdate             varchar(256),
    requesthicnbr              varchar(256),
    requestlastname            varchar(256),
    requestdob                 varchar(256),
    foundhicnbr                varchar(256) encode bytedict,
    foundnameordob             varchar(256) encode bytedict,
    inquiryresponse            varchar(256) encode bytedict,
    hicnbr                     varchar(256),
    lastname                   varchar(256),
    firstname                  varchar(256),
    middleinitial              varchar(256),
    gendercd                   varchar(256) encode bytedict,
    racecd                     varchar(256) encode bytedict,
    birthdate                  varchar(256),
    prtaentitlementdate        varchar(256),
    prtaentitleenddate         varchar(256),
    prtbentitlementdate        varchar(256),
    prtbentitleenddate         varchar(256),
    statecd                    varchar(256),
    countycd                   varchar(256),
    hospicestatus              varchar(256),
    hospicestartdate           varchar(256),
    hospiceenddate             varchar(256),
    inststatus                 varchar(256),
    inststartdate              varchar(256),
    instenddate                varchar(256),
    esrdstatus                 varchar(256),
    esrdstartdate              varchar(256),
    esrdenddate                varchar(256),
    medicaidstatus             varchar(256) encode bytedict,
    medicaidstartdate          varchar(256),
    medicaidenddate            varchar(256),
    eghpind                    varchar(256),
    livingstatus               varchar(256) encode bytedict,
    deathdate                  varchar(256),
    xrefhicnbr                 varchar(256),
    potentialuncvrdmths        varchar(256) encode bytedict,
    potentialuncvrdmthseffdate varchar(256) encode bytedict,
    prtdeligibledate           varchar(256),
    planyear                   bigint encode az64,
    miscnotes                  varchar(500),
    wiprojson                  varchar(8192),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_aqe.wipro
    owner to etluser;

create table if not exists integrated_aqe.wipro
(
    dw_table_pk                bigint default "identity"(396682, 0, '0,1'::text) encode az64,
    carrier_id                 bigint encode az64 distkey,
    wiproid                    bigint encode az64,
    txndate                    varchar(256),
    mbdloadeffdate             varchar(256),
    requesthicnbr              varchar(256),
    requestlastname            varchar(256),
    requestdob                 varchar(256),
    foundhicnbr                varchar(256) encode bytedict,
    foundnameordob             varchar(256) encode bytedict,
    inquiryresponse            varchar(256) encode bytedict,
    hicnbr                     varchar(256),
    lastname                   varchar(256),
    firstname                  varchar(256),
    middleinitial              varchar(256) encode bytedict,
    gendercd                   varchar(256) encode bytedict,
    racecd                     varchar(256) encode bytedict,
    birthdate                  varchar(256),
    prtaentitlementdate        varchar(256),
    prtaentitleenddate         varchar(256),
    prtbentitlementdate        varchar(256),
    prtbentitleenddate         varchar(256),
    statecd                    varchar(256) encode bytedict,
    countycd                   varchar(256),
    hospicestatus              varchar(256),
    hospicestartdate           varchar(256),
    hospiceenddate             varchar(256),
    inststatus                 varchar(256),
    inststartdate              varchar(256),
    instenddate                varchar(256),
    esrdstatus                 varchar(256) encode bytedict,
    esrdstartdate              varchar(256),
    esrdenddate                varchar(256),
    medicaidstatus             varchar(256) encode bytedict,
    medicaidstartdate          varchar(256),
    medicaidenddate            varchar(256),
    eghpind                    varchar(256),
    livingstatus               varchar(256) encode bytedict,
    deathdate                  varchar(256),
    xrefhicnbr                 varchar(256),
    potentialuncvrdmths        varchar(256) encode bytedict,
    potentialuncvrdmthseffdate varchar(256) encode bytedict,
    prtdeligibledate           varchar(256),
    planyear                   bigint encode az64,
    miscnotes                  varchar(500),
    wiprojson                  varchar(8192),
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_aqe.wipro
    owner to etluser;

grant select on integrated_aqe.wipro to group named_user_ro;

create table if not exists landing_ccs.bloom_hourofcall
(
    pkid              integer encode az64,
    hourofcall        varchar(5),
    hour              bigint encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloom_hourofcall
    owner to etluser;

create table if not exists staging_ccs.bloom_hourofcall
(
    pkid                  integer encode az64,
    hourofcall            varchar(5),
    hour                  bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloom_hourofcall
    owner to etluser;

create table if not exists integrated_ccs.bloom_hourofcall
(
    dw_table_pk          bigint default "identity"(399268, 0, ('0,1'::character varying)::text) encode az64,
    pkid                 integer encode az64,
    hourofcall           varchar(5),
    hour                 bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.bloom_hourofcall
    owner to etluser;

grant select on integrated_ccs.bloom_hourofcall to group named_user_ro;

create table if not exists landing_ccs.ssrsemailsubscriptions
(
    pkid                bigint encode az64,
    clientname          varchar(100),
    reportname          varchar(100),
    toemailaddress      varchar(200),
    ccemailaddress      varchar(200),
    bccemailaddress     varchar(200),
    replytoemailaddress varchar(200),
    includereport       boolean,
    renderformat        varchar(20),
    priority            varchar(15),
    subject             varchar(150),
    comment             varchar(150),
    includelink         boolean,
    isactive            boolean,
    dateintervalfk      bigint encode az64,
    datecreated         timestamp encode az64,
    requestername       varchar(100),
    notes               varchar(100),
    validfrom           timestamp encode az64,
    validto             timestamp encode az64,
    refresh_timestamp   timestamp encode az64
);

alter table landing_ccs.ssrsemailsubscriptions
    owner to etluser;

create table if not exists staging_ccs.ssrsemailsubscriptions
(
    pkid                  bigint encode az64,
    clientname            varchar(100),
    reportname            varchar(100),
    toemailaddress        varchar(200) distkey,
    ccemailaddress        varchar(200),
    bccemailaddress       varchar(200),
    replytoemailaddress   varchar(200),
    includereport         boolean,
    renderformat          varchar(20),
    priority              varchar(15),
    subject               varchar(150),
    comment               varchar(150),
    includelink           boolean,
    isactive              boolean,
    dateintervalfk        bigint encode az64,
    datecreated           timestamp encode az64,
    requestername         varchar(100),
    notes                 varchar(100),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    diststyle key;

alter table staging_ccs.ssrsemailsubscriptions
    owner to etluser;

create table if not exists integrated_ccs.ssrsemailsubscriptions
(
    dw_table_pk          bigint default "identity"(399288, 0, ('0,1'::character varying)::text) encode az64,
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    toemailaddress       varchar(200) distkey,
    ccemailaddress       varchar(200),
    bccemailaddress      varchar(200),
    replytoemailaddress  varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    priority             varchar(15),
    subject              varchar(150),
    comment              varchar(150),
    includelink          boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (refresh_timestamp);

alter table integrated_ccs.ssrsemailsubscriptions
    owner to etluser;

grant select on integrated_ccs.ssrsemailsubscriptions to group named_user_ro;

create table if not exists integrated_ccs.ssrsfilesharesubscriptions
(
    dw_table_pk          bigint default "identity"(399302, 0, ('0,1'::character varying)::text) encode az64,
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    filename             varchar(200),
    filesharepath        varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    fileextension        boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_ccs.ssrsfilesharesubscriptions
    owner to etluser;

grant select on integrated_ccs.ssrsfilesharesubscriptions to group named_user_ro;

create table if not exists landing_ccs.ssrsfilesharesubscriptions
(
    pkid              bigint encode az64,
    clientname        varchar(100),
    reportname        varchar(100),
    filename          varchar(200),
    filesharepath     varchar(200),
    includereport     boolean,
    renderformat      varchar(20),
    fileextension     boolean,
    isactive          boolean,
    dateintervalfk    bigint encode az64,
    datecreated       timestamp encode az64,
    requestername     varchar(100),
    notes             varchar(100),
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.ssrsfilesharesubscriptions
    owner to etluser;

create table if not exists staging_ccs.ssrsfilesharesubscriptions
(
    pkid                  bigint encode az64,
    clientname            varchar(100),
    reportname            varchar(100),
    filename              varchar(200),
    filesharepath         varchar(200),
    includereport         boolean,
    renderformat          varchar(20),
    fileextension         boolean,
    isactive              boolean,
    dateintervalfk        bigint encode az64,
    datecreated           timestamp encode az64,
    requestername         varchar(100),
    notes                 varchar(100),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.ssrsfilesharesubscriptions
    owner to etluser;

create table if not exists landing_ccs.sftpcredentials
(
    sftpcredentialid  bigint encode az64,
    sftpname          varchar(500),
    sftphostname      varchar(500),
    sftpusername      varchar(500),
    sftppassword      varchar(500),
    sftpport          bigint encode az64,
    isactive          boolean,
    lastmodifieddate  timestamp encode az64,
    miscnotes         varchar(200),
    auditusername     varchar(50),
    sftpkeyfile       varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.sftpcredentials
    owner to etluser;

create table if not exists staging_ccs.sftpcredentials
(
    sftpcredentialid      bigint encode az64 distkey,
    sftpname              varchar(500),
    sftphostname          varchar(500),
    sftpusername          varchar(500),
    sftppassword          varchar(500),
    sftpport              bigint encode az64,
    isactive              boolean,
    lastmodifieddate      timestamp encode az64,
    miscnotes             varchar(200),
    auditusername         varchar(50),
    sftpkeyfile           varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.sftpcredentials
    owner to etluser;

create table if not exists integrated_ccs.sftpcredentials
(
    dw_table_pk          bigint default "identity"(399325, 0, '0,1'::text) encode az64,
    sftpcredentialid     bigint encode az64 distkey,
    sftpname             varchar(500),
    sftphostname         varchar(500),
    sftpusername         varchar(500),
    sftppassword         varchar(500),
    sftpport             bigint encode az64,
    isactive             boolean,
    lastmodifieddate     timestamp encode az64,
    miscnotes            varchar(200),
    auditusername        varchar(50),
    sftpkeyfile          varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.sftpcredentials
    owner to etluser;

grant select on integrated_ccs.sftpcredentials to group named_user_ro;

create table if not exists landing_ccs.ssrsemailsubscriptions_history
(
    pkid                bigint encode az64,
    clientname          varchar(100),
    reportname          varchar(100),
    toemailaddress      varchar(200),
    ccemailaddress      varchar(200),
    bccemailaddress     varchar(200),
    replytoemailaddress varchar(200),
    includereport       boolean,
    renderformat        varchar(20),
    priority            varchar(15),
    subject             varchar(255),
    comment             varchar(150),
    includelink         boolean,
    isactive            boolean,
    dateintervalfk      bigint encode az64,
    datecreated         timestamp encode az64,
    requestername       varchar(100),
    notes               varchar(100),
    validfrom           timestamp encode az64,
    validto             timestamp encode az64,
    refresh_timestamp   timestamp encode az64
);

alter table landing_ccs.ssrsemailsubscriptions_history
    owner to etluser;

create table if not exists staging_ccs.ssrsemailsubscriptions_history
(
    pkid                  bigint encode az64,
    clientname            varchar(100),
    reportname            varchar(100),
    toemailaddress        varchar(200) distkey,
    ccemailaddress        varchar(200),
    bccemailaddress       varchar(200),
    replytoemailaddress   varchar(200),
    includereport         boolean,
    renderformat          varchar(20),
    priority              varchar(15),
    subject               varchar(255),
    comment               varchar(150),
    includelink           boolean,
    isactive              boolean,
    dateintervalfk        bigint encode az64,
    datecreated           timestamp encode az64,
    requestername         varchar(100),
    notes                 varchar(100),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.ssrsemailsubscriptions_history
    owner to etluser;

create table if not exists integrated_ccs.ssrsemailsubscriptions_history
(
    dw_table_pk          bigint default "identity"(399353, 0, '0,1'::text) encode az64,
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    toemailaddress       varchar(200) distkey,
    ccemailaddress       varchar(200),
    bccemailaddress      varchar(200),
    replytoemailaddress  varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    priority             varchar(15),
    subject              varchar(255),
    comment              varchar(150),
    includelink          boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.ssrsemailsubscriptions_history
    owner to etluser;

grant select on integrated_ccs.ssrsemailsubscriptions_history to group named_user_ro;

create table if not exists landing_ccs.ssrsfilesharesubscriptions_history
(
    pkid              bigint encode az64,
    clientname        varchar(100),
    reportname        varchar(100),
    filename          varchar(200),
    filesharepath     varchar(200),
    includereport     boolean,
    renderformat      varchar(20),
    fileextension     boolean,
    isactive          boolean,
    dateintervalfk    bigint encode az64,
    datecreated       timestamp encode az64,
    requestername     varchar(100),
    notes             varchar(100),
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.ssrsfilesharesubscriptions_history
    owner to etluser;

create table if not exists staging_ccs.ssrsfilesharesubscriptions_history
(
    pkid                  bigint,
    clientname            varchar(100),
    reportname            varchar(100),
    filename              varchar(200),
    filesharepath         varchar(200),
    includereport         boolean,
    renderformat          varchar(20),
    fileextension         boolean,
    isactive              boolean,
    dateintervalfk        bigint encode az64,
    datecreated           timestamp encode az64,
    requestername         varchar(100),
    notes                 varchar(100),
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
)
    sortkey (pkid);

alter table staging_ccs.ssrsfilesharesubscriptions_history
    owner to etluser;

create table if not exists integrated_ccs.ssrsfilesharesubscriptions_history
(
    dw_table_pk          bigint default "identity"(399375, 0, '0,1'::text),
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    filename             varchar(200),
    filesharepath        varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    fileextension        boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (dw_table_pk);

alter table integrated_ccs.ssrsfilesharesubscriptions_history
    owner to etluser;

grant select on integrated_ccs.ssrsfilesharesubscriptions_history to group named_user_ro;

create table if not exists landing_ccs.bloom_clients
(
    pkbloomclientid   bigint encode az64,
    name              varchar(200),
    hostname          varchar(100),
    logopath          varchar(200),
    csspath           varchar(200),
    databasename      varchar(50),
    isactive          boolean,
    auditusername     varchar(200),
    isvbe             boolean,
    sendgrid          boolean,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloom_clients
    owner to etluser;

create table if not exists staging_ccs.bloom_clients
(
    pkbloomclientid       bigint encode az64,
    name                  varchar(200),
    hostname              varchar(100),
    logopath              varchar(200),
    csspath               varchar(200),
    databasename          varchar(50),
    isactive              boolean,
    auditusername         varchar(200),
    isvbe                 boolean,
    sendgrid              boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloom_clients
    owner to etluser;

create table if not exists integrated_ccs.bloom_clients
(
    dw_table_pk          bigint default "identity"(399402, 0, '0,1'::text) encode az64,
    pkbloomclientid      bigint encode az64,
    name                 varchar(200),
    hostname             varchar(100),
    logopath             varchar(200),
    csspath              varchar(200),
    databasename         varchar(50),
    isactive             boolean,
    auditusername        varchar(200),
    isvbe                boolean,
    sendgrid             boolean,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloom_clients
    owner to etluser;

grant select on integrated_ccs.bloom_clients to group named_user_ro;

create table if not exists landing_ccs.bloomcarrier
(
    pkcarrier         bigint encode az64,
    carriername       varchar(50),
    isdeleted         boolean,
    carriershortname  varchar(25),
    auditusername     varchar(50),
    bloomclientid     double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloomcarrier
    owner to etluser;

create table if not exists staging_ccs.bloomcarrier
(
    pkcarrier             bigint encode az64,
    carriername           varchar(50),
    isdeleted             boolean,
    carriershortname      varchar(25),
    auditusername         varchar(50),
    bloomclientid         bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomcarrier
    owner to etluser;

create table if not exists integrated_ccs.bloomcarrier
(
    dw_table_pk          bigint default "identity"(399419, 0, '0,1'::text) encode az64,
    pkcarrier            bigint encode az64,
    carriername          varchar(50),
    isdeleted            boolean,
    carriershortname     varchar(25),
    auditusername        varchar(50),
    bloomclientid        bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloomcarrier
    owner to etluser;

grant select on integrated_ccs.bloomcarrier to group named_user_ro;

create table if not exists landing_ccs.bloom_areacodestate_mapping
(
    pkareacodestatemapping bigint encode az64,
    areacode               varchar(150),
    region                 varchar(150),
    refresh_timestamp      timestamp encode az64
);

alter table landing_ccs.bloom_areacodestate_mapping
    owner to etluser;

create table if not exists staging_ccs.bloom_areacodestate_mapping
(
    pkareacodestatemapping bigint encode az64,
    areacode               varchar(150),
    region                 varchar(150),
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_ccs.bloom_areacodestate_mapping
    owner to etluser;

create table if not exists integrated_ccs.bloom_areacodestate_mapping
(
    dw_table_pk            bigint default "identity"(399446, 0, '0,1'::text) encode az64,
    pkareacodestatemapping bigint encode az64,
    areacode               varchar(150),
    region                 varchar(150),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_ccs.bloom_areacodestate_mapping
    owner to etluser;

grant select on integrated_ccs.bloom_areacodestate_mapping to group named_user_ro;

create table if not exists landing_ccs.bloom_clientcampaignmap
(
    bloom_clientcampaignmapid bigint encode az64,
    bloom_clientid            bigint encode az64,
    campaignid                bigint encode az64,
    auditusername             varchar(255),
    isactiveforstats          boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64
);

alter table landing_ccs.bloom_clientcampaignmap
    owner to etluser;

create table if not exists staging_ccs.bloom_clientcampaignmap
(
    bloom_clientcampaignmapid bigint encode az64,
    bloom_clientid            bigint encode az64,
    campaignid                bigint encode az64,
    auditusername             varchar(255),
    isactiveforstats          boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_ccs.bloom_clientcampaignmap
    owner to etluser;

create table if not exists integrated_ccs.bloom_clientcampaignmap
(
    dw_table_pk               bigint default "identity"(399463, 0, '0,1'::text) encode az64,
    bloom_clientcampaignmapid bigint encode az64,
    bloom_clientid            bigint encode az64,
    campaignid                bigint encode az64,
    auditusername             varchar(255),
    isactiveforstats          boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table integrated_ccs.bloom_clientcampaignmap
    owner to etluser;

grant select on integrated_ccs.bloom_clientcampaignmap to group named_user_ro;

create table if not exists landing_ccs.bloom_clientdispositionmapping
(
    pkbloomdispositionmapping bigint encode az64,
    callresultcode            bigint encode az64,
    clientid                  bigint encode az64,
    thirdpartyname            varchar(100),
    externalcode              varchar(100),
    testing                   boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64
);

alter table landing_ccs.bloom_clientdispositionmapping
    owner to etluser;

create table if not exists staging_ccs.bloom_clientdispositionmapping
(
    pkbloomdispositionmapping bigint encode az64,
    callresultcode            bigint encode az64,
    clientid                  bigint encode az64,
    thirdpartyname            varchar(100),
    externalcode              varchar(100),
    testing                   boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_ccs.bloom_clientdispositionmapping
    owner to etluser;

create table if not exists integrated_ccs.bloom_clientdispositionmapping
(
    dw_table_pk               bigint default "identity"(399480, 0, '0,1'::text) encode az64,
    pkbloomdispositionmapping bigint encode az64,
    callresultcode            bigint encode az64,
    clientid                  bigint encode az64,
    thirdpartyname            varchar(100),
    externalcode              varchar(100),
    testing                   boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table integrated_ccs.bloom_clientdispositionmapping
    owner to etluser;

grant select on integrated_ccs.bloom_clientdispositionmapping to group named_user_ro;

create table if not exists landing_ccs.bloomcarriergroup
(
    pkcarriergroup    bigint encode az64,
    carriergroupname  varchar(50),
    isdeleted         boolean,
    carrierfk         double precision,
    auditusername     varchar(50),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloomcarriergroup
    owner to etluser;

create table if not exists staging_ccs.bloomcarriergroup
(
    pkcarriergroup        bigint encode az64,
    carriergroupname      varchar(50),
    isdeleted             boolean,
    carrierfk             bigint encode az64,
    auditusername         varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomcarriergroup
    owner to etluser;

create table if not exists integrated_ccs.bloomcarriergroup
(
    dw_table_pk          bigint default "identity"(399518, 0, '0,1'::text) encode az64,
    pkcarriergroup       bigint encode az64,
    carriergroupname     varchar(50),
    isdeleted            boolean,
    carrierfk            bigint encode az64,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloomcarriergroup
    owner to etluser;

grant select on integrated_ccs.bloomcarriergroup to group named_user_ro;

create table if not exists landing_ccs.bloomcarriermapping
(
    pkcarriermapping  bigint encode az64,
    carriergroupfk    bigint encode az64,
    carrierfk         bigint encode az64,
    isdeleted         boolean,
    auditusername     varchar(50),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloomcarriermapping
    owner to etluser;

create table if not exists staging_ccs.bloomcarriermapping
(
    pkcarriermapping      bigint encode az64,
    carriergroupfk        bigint encode az64,
    carrierfk             bigint encode az64,
    isdeleted             boolean,
    auditusername         varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomcarriermapping
    owner to etluser;

create table if not exists integrated_ccs.bloomcarriermapping
(
    dw_table_pk          bigint default "identity"(399535, 0, '0,1'::text) encode az64,
    pkcarriermapping     bigint encode az64,
    carriergroupfk       bigint encode az64,
    carrierfk            bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloomcarriermapping
    owner to etluser;

grant select on integrated_ccs.bloomcarriermapping to group named_user_ro;

create table if not exists landing_ccs.bloomplan
(
    pkplan            bigint encode az64,
    planname          varchar(250),
    plantype          varchar(20),
    isdeleted         boolean,
    carrierfk         double precision,
    commissionrate    double precision,
    plangroup         varchar(20),
    auditusername     varchar(50),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloomplan
    owner to etluser;

create table if not exists staging_ccs.bloomplan
(
    pkplan                bigint encode az64,
    planname              varchar(250),
    plantype              varchar(20),
    isdeleted             boolean,
    carrierfk             bigint encode az64,
    commissionrate        double precision,
    plangroup             varchar(20),
    auditusername         varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomplan
    owner to etluser;

create table if not exists integrated_ccs.bloomplan
(
    dw_table_pk          bigint default "identity"(399560, 0, '0,1'::text) encode az64,
    pkplan               bigint encode az64,
    planname             varchar(250),
    plantype             varchar(20),
    isdeleted            boolean,
    carrierfk            bigint encode az64,
    commissionrate       double precision,
    plangroup            varchar(20),
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloomplan
    owner to etluser;

grant select on integrated_ccs.bloomplan to group named_user_ro;

create table if not exists landing_ccs.bloomplanmapping
(
    pkplanmapping     bigint encode az64,
    carrierfk         bigint encode az64,
    planfk            bigint encode az64,
    carriermappingfk  bigint encode az64,
    isdeleted         boolean,
    auditusername     varchar(50),
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.bloomplanmapping
    owner to etluser;

create table if not exists staging_ccs.bloomplanmapping
(
    pkplanmapping         bigint encode az64,
    carrierfk             bigint encode az64,
    planfk                bigint encode az64,
    carriermappingfk      bigint encode az64,
    isdeleted             boolean,
    auditusername         varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomplanmapping
    owner to etluser;

create table if not exists integrated_ccs.bloomplanmapping
(
    dw_table_pk          bigint default "identity"(399577, 0, '0,1'::text) encode az64,
    pkplanmapping        bigint encode az64,
    carrierfk            bigint encode az64,
    planfk               bigint encode az64,
    carriermappingfk     bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.bloomplanmapping
    owner to etluser;

grant select on integrated_ccs.bloomplanmapping to group named_user_ro;

create table if not exists landing_asc.carriers
(
    carrierid         bigint encode az64,
    carriername       varchar(50),
    databaseserver    varchar(50),
    databasename      varchar(50),
    apikey            varchar(256),
    totallicallowed   double precision,
    totallicused      double precision,
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.carriers
    owner to etluser;

create table if not exists staging_asc.carriers
(
    carrierid             bigint encode az64,
    carriername           varchar(50),
    databaseserver        varchar(50),
    databasename          varchar(50),
    apikey                varchar(256),
    totallicallowed       bigint encode az64,
    totallicused          bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.carriers
    owner to etluser;

create table if not exists integrated_asc.carriers
(
    dw_table_pk          bigint default "identity"(435729, 0, '0,1'::text) encode az64,
    carrierid            bigint encode az64,
    carriername          varchar(50),
    databaseserver       varchar(50),
    databasename         varchar(50),
    apikey               varchar(256),
    totallicallowed      bigint encode az64,
    totallicused         bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.carriers
    owner to etluser;

grant select on integrated_asc.carriers to group named_user_ro;

create table if not exists landing_asc.leadsource_base
(
    sourceid          bigint encode az64,
    leadsource        varchar(50),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadsource_base
    owner to etluser;

create table if not exists staging_asc.leadsource_base
(
    sourceid              bigint encode az64,
    leadsource            varchar(50),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadsource_base
    owner to etluser;

create table if not exists integrated_asc.leadsource_base
(
    dw_table_pk          bigint default "identity"(435739, 0, '0,1'::text) encode az64,
    sourceid             bigint encode az64,
    leadsource           varchar(50),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadsource_base
    owner to etluser;

grant select on integrated_asc.leadsource_base to group named_user_ro;

create table if not exists landing_asc.leadstatus_base
(
    statusid          bigint encode az64,
    leadstatus        varchar(50),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadstatus_base
    owner to etluser;

create table if not exists staging_asc.leadstatus_base
(
    statusid              bigint encode az64,
    leadstatus            varchar(50),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadstatus_base
    owner to etluser;

create table if not exists integrated_asc.leadstatus_base
(
    dw_table_pk          bigint default "identity"(435749, 0, '0,1'::text) encode az64,
    statusid             bigint encode az64,
    leadstatus           varchar(50),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadstatus_base
    owner to etluser;

grant select on integrated_asc.leadstatus_base to group named_user_ro;

create table if not exists landing_asc.faxstatus_base
(
    faxstatusid       bigint encode az64,
    efaxid            double precision,
    faxstatus         varchar(256),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.faxstatus_base
    owner to etluser;

create table if not exists staging_asc.faxstatus_base
(
    faxstatusid           bigint encode az64,
    efaxid                bigint encode az64,
    faxstatus             varchar(256),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.faxstatus_base
    owner to etluser;

create table if not exists integrated_asc.faxstatus_base
(
    dw_table_pk          bigint default "identity"(435759, 0, '0,1'::text) encode az64,
    faxstatusid          bigint encode az64,
    efaxid               bigint encode az64,
    faxstatus            varchar(256),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.faxstatus_base
    owner to etluser;

grant select on integrated_asc.faxstatus_base to group named_user_ro;

create table if not exists landing_asc.licenseformfirmtypes
(
    licenseformfirmtypesid bigint encode az64,
    firmtypeid             bigint encode az64,
    displayname            varchar(100),
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64
);

alter table landing_asc.licenseformfirmtypes
    owner to etluser;

create table if not exists staging_asc.licenseformfirmtypes
(
    licenseformfirmtypesid bigint encode az64,
    firmtypeid             bigint encode az64,
    displayname            varchar(100),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.licenseformfirmtypes
    owner to etluser;

create table if not exists integrated_asc.licenseformfirmtypes
(
    dw_table_pk            bigint default "identity"(435769, 0, '0,1'::text) encode az64,
    licenseformfirmtypesid bigint encode az64,
    firmtypeid             bigint encode az64,
    displayname            varchar(100),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.licenseformfirmtypes
    owner to etluser;

grant select on integrated_asc.licenseformfirmtypes to group named_user_ro;

create table if not exists landing_asc.entityfeaturemap
(
    entityfeaturemapid bigint encode az64,
    carrierid          double precision,
    beid               double precision,
    userid             double precision,
    featureid          double precision,
    isactive           boolean,
    notes              varchar(500),
    audituserid        double precision,
    refresh_timestamp  timestamp encode az64
);

alter table landing_asc.entityfeaturemap
    owner to etluser;

create table if not exists staging_asc.entityfeaturemap
(
    entityfeaturemapid    bigint encode az64,
    carrierid             bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64 distkey,
    featureid             bigint encode az64,
    isactive              boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.entityfeaturemap
    owner to etluser;

create table if not exists integrated_asc.entityfeaturemap
(
    dw_table_pk          bigint default "identity"(435779, 0, '0,1'::text) encode az64,
    entityfeaturemapid   bigint encode az64,
    carrierid            bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    featureid            bigint encode az64,
    isactive             boolean,
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.entityfeaturemap
    owner to etluser;

grant select on integrated_asc.entityfeaturemap to group named_user_ro;

create table if not exists landing_asc.help_definition_type
(
    id                    bigint encode az64,
    help_type_code        double precision,
    displayorder          double precision,
    help_type_description varchar(50),
    refresh_timestamp     timestamp encode az64
);

alter table landing_asc.help_definition_type
    owner to etluser;

create table if not exists staging_asc.help_definition_type
(
    id                    bigint encode az64 distkey,
    help_type_code        bigint encode az64,
    displayorder          bigint encode az64,
    help_type_description varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.help_definition_type
    owner to etluser;

create table if not exists integrated_asc.help_definition_type
(
    dw_table_pk           bigint default "identity"(435789, 0, '0,1'::text) encode az64,
    id                    bigint encode az64 distkey,
    help_type_code        bigint encode az64,
    displayorder          bigint encode az64,
    help_type_description varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_asc.help_definition_type
    owner to etluser;

grant select on integrated_asc.help_definition_type to group named_user_ro;

create table if not exists landing_asc.ascendfeatures
(
    featureid         bigint encode az64,
    feature           varchar(100),
    description       varchar(500),
    isactive          boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.ascendfeatures
    owner to etluser;

create table if not exists staging_asc.ascendfeatures
(
    featureid             bigint encode az64,
    feature               varchar(100),
    description           varchar(500),
    isactive              boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.ascendfeatures
    owner to etluser;

create table if not exists integrated_asc.ascendfeatures
(
    dw_table_pk          bigint default "identity"(435799, 0, '0,1'::text) encode az64,
    featureid            bigint encode az64,
    feature              varchar(100),
    description          varchar(500),
    isactive             boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.ascendfeatures
    owner to etluser;

grant select on integrated_asc.ascendfeatures to group named_user_ro;

create table if not exists landing_asc.help_definitions
(
    id                bigint encode az64,
    definitionlabel   varchar(50),
    definition        varchar(200),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.help_definitions
    owner to etluser;

create table if not exists staging_asc.help_definitions
(
    id                    bigint encode az64 distkey,
    definitionlabel       varchar(50),
    definition            varchar(200),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.help_definitions
    owner to etluser;

create table if not exists integrated_asc.help_definitions
(
    dw_table_pk          bigint default "identity"(435809, 0, '0,1'::text) encode az64,
    id                   bigint encode az64 distkey,
    definitionlabel      varchar(50),
    definition           varchar(200),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.help_definitions
    owner to etluser;

grant select on integrated_asc.help_definitions to group named_user_ro;

create table if not exists landing_asc.eventsstatus_base
(
    eventstatusid     bigint encode az64,
    eventstatusname   varchar(100),
    beid              double precision,
    status            varchar(1),
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.eventsstatus_base
    owner to etluser;

create table if not exists staging_asc.eventsstatus_base
(
    eventstatusid         bigint encode az64,
    eventstatusname       varchar(100),
    beid                  bigint encode az64,
    status                varchar(1),
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventsstatus_base
    owner to etluser;

create table if not exists integrated_asc.eventsstatus_base
(
    dw_table_pk          bigint default "identity"(435819, 0, '0,1'::text) encode az64,
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventsstatus_base
    owner to etluser;

grant select on integrated_asc.eventsstatus_base to group named_user_ro;

create table if not exists landing_asc.businessentities
(
    businessentityid     bigint encode az64,
    carrierid            bigint encode az64,
    businessentityname   varchar(100),
    spacequota           double precision,
    servername           varchar(50),
    serverusername       varchar(50),
    authenticationkey    varchar(3000),
    pointofcontact       varchar(100),
    documentroot         varchar(100),
    recordingroot        varchar(100),
    recordingmeth        varchar(50),
    paperscoperoot       varchar(100),
    pushnotificationpath varchar(50),
    pushcertpassword     varchar(50),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.businessentities
    owner to etluser;

create table if not exists staging_asc.businessentities
(
    businessentityid      bigint encode az64,
    carrierid             bigint encode az64,
    businessentityname    varchar(100),
    spacequota            bigint encode az64,
    servername            varchar(50),
    serverusername        varchar(50),
    authenticationkey     varchar(3000),
    pointofcontact        varchar(100),
    documentroot          varchar(100),
    recordingroot         varchar(100),
    recordingmeth         varchar(50),
    paperscoperoot        varchar(100),
    pushnotificationpath  varchar(50),
    pushcertpassword      varchar(50),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.businessentities
    owner to etluser;

create table if not exists integrated_asc.businessentities
(
    dw_table_pk          bigint default "identity"(435829, 0, '0,1'::text) encode az64,
    businessentityid     bigint encode az64,
    carrierid            bigint encode az64,
    businessentityname   varchar(100),
    spacequota           bigint encode az64,
    servername           varchar(50),
    serverusername       varchar(50),
    authenticationkey    varchar(3000),
    pointofcontact       varchar(100),
    documentroot         varchar(100),
    recordingroot        varchar(100),
    recordingmeth        varchar(50),
    paperscoperoot       varchar(100),
    pushnotificationpath varchar(50),
    pushcertpassword     varchar(50),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.businessentities
    owner to etluser;

grant select on integrated_asc.businessentities to group named_user_ro;

create table if not exists landing_asc.eventstype_base
(
    eventtypeid       bigint encode az64,
    eventtypename     varchar(100),
    beid              double precision,
    status            varchar(1),
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.eventstype_base
    owner to etluser;

create table if not exists staging_asc.eventstype_base
(
    eventtypeid           bigint encode az64,
    eventtypename         varchar(100),
    beid                  bigint encode az64,
    status                varchar(1),
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventstype_base
    owner to etluser;

create table if not exists integrated_asc.eventstype_base
(
    dw_table_pk          bigint default "identity"(435839, 0, '0,1'::text) encode az64,
    eventtypeid          bigint encode az64,
    eventtypename        varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventstype_base
    owner to etluser;

grant select on integrated_asc.eventstype_base to group named_user_ro;

create table if not exists landing_asc.help_catalog
(
    id                bigint encode az64,
    line              bigint encode az64,
    catalogid         double precision,
    definitiontype    double precision,
    reportname        varchar(500),
    definitionid      double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.help_catalog
    owner to etluser;

create table if not exists staging_asc.help_catalog
(
    id                    bigint encode az64 distkey,
    line                  bigint encode az64,
    catalogid             bigint encode az64,
    definitiontype        bigint encode az64,
    reportname            varchar(500),
    definitionid          bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.help_catalog
    owner to etluser;

create table if not exists integrated_asc.help_catalog
(
    dw_table_pk          bigint default "identity"(435849, 0, '0,1'::text) encode az64,
    id                   bigint encode az64 distkey,
    line                 bigint encode az64,
    catalogid            bigint encode az64,
    definitiontype       bigint encode az64,
    reportname           varchar(500),
    definitionid         bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.help_catalog
    owner to etluser;

grant select on integrated_asc.help_catalog to group named_user_ro;

create table if not exists landing_asc.ascendisf_map
(
    ascendisfid       bigint encode az64,
    beid              double precision,
    isfcarrierid      double precision,
    isfcarriername    varchar(50),
    notes             varchar(255),
    audituserid       double precision,
    isdeleted         boolean,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.ascendisf_map
    owner to etluser;

create table if not exists staging_asc.ascendisf_map
(
    ascendisfid           bigint encode az64,
    beid                  bigint encode az64,
    isfcarrierid          bigint encode az64,
    isfcarriername        varchar(50),
    notes                 varchar(255),
    audituserid           bigint encode az64 distkey,
    isdeleted             boolean,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.ascendisf_map
    owner to etluser;

create table if not exists integrated_asc.ascendisf_map
(
    dw_table_pk          bigint default "identity"(435859, 0, '0,1'::text) encode az64,
    ascendisfid          bigint encode az64,
    beid                 bigint encode az64,
    isfcarrierid         bigint encode az64,
    isfcarriername       varchar(50),
    notes                varchar(255),
    audituserid          bigint encode az64 distkey,
    isdeleted            boolean,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.ascendisf_map
    owner to etluser;

grant select on integrated_asc.ascendisf_map to group named_user_ro;

create table if not exists landing_asc.loginattempts
(
    loginattemptsid   bigint encode az64,
    loginattempts     double precision,
    userid            double precision,
    counter           bigint encode az64,
    dateentered       timestamp,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (dateentered);

alter table landing_asc.loginattempts
    owner to etluser;

create table if not exists staging_asc.loginattempts
(
    loginattemptsid       bigint encode az64,
    loginattempts         bigint encode az64,
    userid                bigint encode az64 distkey,
    counter               bigint encode az64,
    dateentered           timestamp encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.loginattempts
    owner to etluser;

create table if not exists integrated_asc.loginattempts
(
    dw_table_pk          bigint default "identity"(435869, 0, '0,1'::text) encode az64,
    loginattemptsid      bigint encode az64,
    loginattempts        bigint encode az64,
    userid               bigint encode az64 distkey,
    counter              bigint encode az64,
    dateentered          timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.loginattempts
    owner to etluser;

grant select on integrated_asc.loginattempts to group named_user_ro;

create table if not exists landing_asc.zipcodetimezone
(
    pkid              bigint,
    zipcode           varchar(64),
    county            varchar(256),
    countyfips        varchar(16),
    state             varchar(16),
    statefips         varchar(16),
    timezone          varchar(16),
    daylightsaving    varchar(8),
    refresh_timestamp timestamp encode az64
)
    sortkey (pkid);

alter table landing_asc.zipcodetimezone
    owner to etluser;

create table if not exists staging_asc.zipcodetimezone
(
    pkid                  bigint encode az64,
    zipcode               varchar(64),
    county                varchar(256),
    countyfips            varchar(16),
    state                 varchar(16),
    statefips             varchar(16),
    timezone              varchar(16),
    daylightsaving        varchar(8),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.zipcodetimezone
    owner to etluser;

create table if not exists integrated_asc.zipcodetimezone
(
    dw_table_pk          bigint default "identity"(435879, 0, '0,1'::text) encode az64,
    pkid                 bigint encode az64,
    zipcode              varchar(64),
    county               varchar(256),
    countyfips           varchar(16),
    state                varchar(16),
    statefips            varchar(16),
    timezone             varchar(16),
    daylightsaving       varchar(8),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.zipcodetimezone
    owner to etluser;

grant select on integrated_asc.zipcodetimezone to group named_user_ro;

create table if not exists landing_asc.roles_base
(
    roleid            bigint encode az64,
    code              varchar(50),
    name              varchar(256),
    notes             varchar(256),
    audituserid       double precision,
    role_permissions  varchar(2048),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.roles_base
    owner to etluser;

create table if not exists staging_asc.roles_base
(
    roleid                bigint encode az64,
    code                  varchar(50),
    name                  varchar(256),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    role_permissions      varchar(2048),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.roles_base
    owner to etluser;

create table if not exists integrated_asc.roles_base
(
    dw_table_pk          bigint default "identity"(435889, 0, '0,1'::text) encode az64,
    roleid               bigint encode az64,
    code                 varchar(50),
    name                 varchar(256),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    role_permissions     varchar(2048),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.roles_base
    owner to etluser;

grant select on integrated_asc.roles_base to group named_user_ro;

create table if not exists landing_asc.groups_base
(
    groupsid          bigint encode az64,
    code              varchar(10),
    description       varchar(50),
    groupdescription  varchar(500),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.groups_base
    owner to etluser;

create table if not exists staging_asc.groups_base
(
    groupsid              bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    groupdescription      varchar(500),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.groups_base
    owner to etluser;

create table if not exists integrated_asc.groups_base
(
    dw_table_pk          bigint default "identity"(435899, 0, '0,1'::text) encode az64,
    groupsid             bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    groupdescription     varchar(500),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.groups_base
    owner to etluser;

grant select on integrated_asc.groups_base to group named_user_ro;

create table if not exists landing_asc.usersession
(
    usersessionid        bigint encode az64 distkey,
    userid               double precision,
    clientid             double precision,
    sessionstartdatetime timestamp encode az64,
    sessionenddatetime   timestamp encode az64,
    useragent            varchar(256) encode bytedict,
    buildversion         varchar(50) encode bytedict,
    osversion            varchar(50) encode bytedict,
    ipaddress            varchar(50),
    iscellular           boolean,
    iswifi               boolean,
    devicetype           varchar(100),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.usersession
    owner to etluser;

create table if not exists staging_asc.usersession
(
    usersessionid         bigint encode az64 distkey,
    userid                bigint encode az64,
    clientid              bigint encode az64,
    sessionstartdatetime  timestamp encode az64,
    sessionenddatetime    timestamp encode az64,
    useragent             varchar(256) encode bytedict,
    buildversion          varchar(50) encode bytedict,
    osversion             varchar(50) encode bytedict,
    ipaddress             varchar(50),
    iscellular            boolean,
    iswifi                boolean,
    devicetype            varchar(100),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.usersession
    owner to etluser;

create table if not exists integrated_asc.usersession
(
    dw_table_pk          bigint default "identity"(435909, 0, '0,1'::text) encode az64,
    usersessionid        bigint encode az64 distkey,
    userid               bigint encode az64,
    clientid             bigint encode az64,
    sessionstartdatetime timestamp encode az64,
    sessionenddatetime   timestamp encode az64,
    useragent            varchar(256) encode bytedict,
    buildversion         varchar(50) encode bytedict,
    osversion            varchar(50) encode bytedict,
    ipaddress            varchar(50),
    iscellular           boolean,
    iswifi               boolean,
    devicetype           varchar(100),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.usersession
    owner to etluser;

grant select on integrated_asc.usersession to group named_user_ro;

create table if not exists landing_asc.dispositions_base
(
    dispositionsid    bigint encode az64,
    code              varchar(10),
    description       varchar(50),
    status            varchar(2),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.dispositions_base
    owner to etluser;

create table if not exists staging_asc.dispositions_base
(
    dispositionsid        bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    status                varchar(2),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositions_base
    owner to etluser;

create table if not exists integrated_asc.dispositions_base
(
    dw_table_pk          bigint default "identity"(435919, 0, '0,1'::text) encode az64,
    dispositionsid       bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dispositions_base
    owner to etluser;

grant select on integrated_asc.dispositions_base to group named_user_ro;

create table if not exists landing_asc.users
(
    userid            bigint encode az64 distkey,
    loginname         varchar(500),
    password          varchar(150),
    salt              varchar(50),
    fname             varchar(50),
    lname             varchar(50),
    datepwdchange     timestamp encode az64,
    natpronum         varchar(10),
    locked            boolean,
    notes             varchar(256) encode bytedict,
    audituserid       double precision,
    hash              varchar(16),
    truesalt          varchar(16),
    userversion       double precision,
    useriterations    double precision,
    apiversion        double precision,
    apiiterations     double precision,
    lockendtime       timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.users
    owner to etluser;

create table if not exists staging_asc.users
(
    userid                bigint encode az64 distkey,
    loginname             varchar(500),
    password              varchar(150),
    salt                  varchar(50),
    fname                 varchar(50),
    lname                 varchar(50),
    datepwdchange         timestamp encode az64,
    natpronum             varchar(10),
    locked                boolean,
    notes                 varchar(256) encode bytedict,
    audituserid           bigint encode az64,
    hash                  varchar(16),
    truesalt              varchar(16),
    userversion           bigint encode az64,
    useriterations        bigint encode az64,
    apiversion            bigint encode az64,
    apiiterations         bigint encode az64,
    lockendtime           timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.users
    owner to etluser;

create table if not exists integrated_asc.users
(
    dw_table_pk          bigint default "identity"(435929, 0, '0,1'::text) encode az64,
    userid               bigint encode az64 distkey,
    loginname            varchar(500),
    password             varchar(150),
    salt                 varchar(50),
    fname                varchar(50),
    lname                varchar(50),
    datepwdchange        timestamp encode az64,
    natpronum            varchar(10),
    locked               boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    hash                 varchar(16),
    truesalt             varchar(16),
    userversion          bigint encode az64,
    useriterations       bigint encode az64,
    apiversion           bigint encode az64,
    apiiterations        bigint encode az64,
    lockendtime          timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.users
    owner to etluser;

grant select on integrated_asc.users to group named_user_ro;

create table if not exists landing_asc.businessentityparameters
(
    businessentityparameterid   bigint encode az64,
    beid                        bigint encode az64,
    pwdage                      bigint encode az64,
    tokenage                    double precision,
    pwdrepeat                   double precision,
    loginattempts               double precision,
    logindelayminutes           double precision,
    imagelocation               varchar(500),
    armimagelocation            varchar(500),
    maplogo                     varchar(500),
    disclaimer                  varchar(8192),
    documentcount               double precision,
    maxdevicerecordings         double precision,
    availabilitytimeout         double precision,
    maxradius                   double precision,
    distributionpattern         double precision,
    apppath                     varchar(255),
    winapppath                  varchar(256),
    appbundleid                 varchar(50),
    servicecontactid_fk         double precision,
    backupservicecontactid_fk   double precision,
    quoteurl                    varchar(500),
    enrollmenturl               varchar(500),
    sendgridapikey              varchar(500),
    emaildisclaimer             varchar(8192),
    sendgridemailaddress        varchar(256),
    emailname                   varchar(256),
    emailaddress                varchar(256),
    emailbody                   varchar(8192),
    emailsubject                varchar(256),
    twiliosmsnumber             varchar(256),
    twiliotextbody              varchar(256),
    notes                       varchar(256),
    audituserid                 double precision,
    s3region                    varchar(100),
    s3secret                    varchar(256),
    s3accesskey                 varchar(256),
    s3bucketname                varchar(250),
    isparticipatinginsalesforce boolean,
    clientid                    varchar(255),
    clientsecret                varchar(255),
    salesforceusername          varchar(500),
    salesforcepassword          varchar(500),
    fein                        varchar(50),
    nipraccountid               varchar(10),
    niprpaymentcodeid           double precision,
    aqeimagepath                varchar(256),
    use2fa                      boolean,
    registrationemailid         double precision,
    refresh_timestamp           timestamp encode az64
);

alter table landing_asc.businessentityparameters
    owner to etluser;

create table if not exists staging_asc.businessentityparameters
(
    businessentityparameterid   bigint encode az64,
    beid                        bigint encode az64,
    pwdage                      bigint encode az64,
    tokenage                    bigint encode az64,
    pwdrepeat                   bigint encode az64,
    loginattempts               bigint encode az64,
    logindelayminutes           bigint encode az64,
    imagelocation               varchar(500),
    armimagelocation            varchar(500),
    maplogo                     varchar(500),
    disclaimer                  varchar(8192),
    documentcount               bigint encode az64,
    maxdevicerecordings         bigint encode az64,
    availabilitytimeout         bigint encode az64,
    maxradius                   bigint encode az64,
    distributionpattern         bigint encode az64,
    apppath                     varchar(255),
    winapppath                  varchar(256),
    appbundleid                 varchar(50),
    servicecontactid_fk         bigint encode az64,
    backupservicecontactid_fk   bigint encode az64,
    quoteurl                    varchar(500),
    enrollmenturl               varchar(500),
    sendgridapikey              varchar(500),
    emaildisclaimer             varchar(8192),
    sendgridemailaddress        varchar(256),
    emailname                   varchar(256),
    emailaddress                varchar(256),
    emailbody                   varchar(8192),
    emailsubject                varchar(256),
    twiliosmsnumber             varchar(256),
    twiliotextbody              varchar(256),
    notes                       varchar(256),
    audituserid                 bigint encode az64,
    s3region                    varchar(100),
    s3secret                    varchar(256),
    s3accesskey                 varchar(256),
    s3bucketname                varchar(250),
    isparticipatinginsalesforce boolean,
    clientid                    varchar(255),
    clientsecret                varchar(255),
    salesforceusername          varchar(500),
    salesforcepassword          varchar(500),
    fein                        varchar(50),
    nipraccountid               varchar(10),
    niprpaymentcodeid           bigint encode az64,
    aqeimagepath                varchar(256),
    use2fa                      boolean,
    registrationemailid         bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_asc.businessentityparameters
    owner to etluser;

create table if not exists integrated_asc.businessentityparameters
(
    dw_table_pk                 bigint default "identity"(435939, 0, '0,1'::text) encode az64,
    businessentityparameterid   bigint encode az64,
    beid                        bigint encode az64,
    pwdage                      bigint encode az64,
    tokenage                    bigint encode az64,
    pwdrepeat                   bigint encode az64,
    loginattempts               bigint encode az64,
    logindelayminutes           bigint encode az64,
    imagelocation               varchar(500),
    armimagelocation            varchar(500),
    maplogo                     varchar(500),
    disclaimer                  varchar(8192),
    documentcount               bigint encode az64,
    maxdevicerecordings         bigint encode az64,
    availabilitytimeout         bigint encode az64,
    maxradius                   bigint encode az64,
    distributionpattern         bigint encode az64,
    apppath                     varchar(255),
    winapppath                  varchar(256),
    appbundleid                 varchar(50),
    servicecontactid_fk         bigint encode az64,
    backupservicecontactid_fk   bigint encode az64,
    quoteurl                    varchar(500),
    enrollmenturl               varchar(500),
    sendgridapikey              varchar(500),
    emaildisclaimer             varchar(8192),
    sendgridemailaddress        varchar(256),
    emailname                   varchar(256),
    emailaddress                varchar(256),
    emailbody                   varchar(8192),
    emailsubject                varchar(256),
    twiliosmsnumber             varchar(256),
    twiliotextbody              varchar(256),
    notes                       varchar(256),
    audituserid                 bigint encode az64,
    s3region                    varchar(100),
    s3secret                    varchar(256),
    s3accesskey                 varchar(256),
    s3bucketname                varchar(250),
    isparticipatinginsalesforce boolean,
    clientid                    varchar(255),
    clientsecret                varchar(255),
    salesforceusername          varchar(500),
    salesforcepassword          varchar(500),
    fein                        varchar(50),
    nipraccountid               varchar(10),
    niprpaymentcodeid           bigint encode az64,
    aqeimagepath                varchar(256),
    use2fa                      boolean,
    registrationemailid         bigint encode az64 distkey,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table integrated_asc.businessentityparameters
    owner to etluser;

grant select on integrated_asc.businessentityparameters to group named_user_ro;

create table if not exists landing_asc.businessentityuser_map
(
    businessentityusermapid bigint encode az64 distkey,
    carrierid               double precision,
    businessentityid        double precision,
    userid                  bigint encode az64,
    userstatus              varchar(1),
    notes                   varchar(256) encode bytedict,
    audituserid             double precision,
    refresh_timestamp       timestamp encode az64
)
    sortkey (carrierid);

alter table landing_asc.businessentityuser_map
    owner to etluser;

create table if not exists staging_asc.businessentityuser_map
(
    businessentityusermapid bigint encode az64 distkey,
    carrierid               bigint encode az64,
    businessentityid        bigint encode az64,
    userid                  bigint encode az64,
    userstatus              varchar(1),
    notes                   varchar(256),
    audituserid             bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_action_indicator   char default 'N'::bpchar,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table staging_asc.businessentityuser_map
    owner to etluser;

create table if not exists integrated_asc.businessentityuser_map
(
    dw_table_pk             bigint default "identity"(437078, 0, '0,1'::text) encode az64,
    businessentityusermapid bigint encode az64 distkey,
    carrierid               bigint encode az64,
    businessentityid        bigint encode az64,
    userid                  bigint encode az64,
    userstatus              varchar(1),
    notes                   varchar(256) encode bytedict,
    audituserid             bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table integrated_asc.businessentityuser_map
    owner to etluser;

grant select on integrated_asc.businessentityuser_map to group named_user_ro;

create table if not exists landing_asc.dispositiontypes_base
(
    dispositiontypeid bigint encode az64,
    code              varchar(50),
    description       varchar(50),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.dispositiontypes_base
    owner to etluser;

create table if not exists staging_asc.dispositiontypes_base
(
    dispositiontypeid     bigint encode az64,
    code                  varchar(50),
    description           varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositiontypes_base
    owner to etluser;

create table if not exists integrated_asc.dispositiontypes_base
(
    dw_table_pk          bigint default "identity"(437088, 0, '0,1'::text) encode az64,
    dispositiontypeid    bigint encode az64,
    code                 varchar(50),
    description          varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dispositiontypes_base
    owner to etluser;

grant select on integrated_asc.dispositiontypes_base to group named_user_ro;

create table if not exists landing_asc.languages_base
(
    languagesid       bigint encode az64,
    code              varchar(10),
    description       varchar(50),
    status            varchar(2),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.languages_base
    owner to etluser;

create table if not exists staging_asc.languages_base
(
    languagesid           bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    status                varchar(2),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.languages_base
    owner to etluser;

create table if not exists integrated_asc.languages_base
(
    dw_table_pk          bigint default "identity"(437098, 0, '0,1'::text) encode az64,
    languagesid          bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.languages_base
    owner to etluser;

grant select on integrated_asc.languages_base to group named_user_ro;

create table if not exists landing_asc.leadsviewrules_base
(
    leadviewid        bigint encode az64,
    beid              double precision,
    name              varchar(50),
    rule              varchar(3072),
    xmlrule           varchar(512),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadsviewrules_base
    owner to etluser;

create table if not exists staging_asc.leadsviewrules_base
(
    leadviewid            bigint encode az64,
    beid                  bigint encode az64,
    name                  varchar(50),
    rule                  varchar(3072),
    xmlrule               varchar(512),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadsviewrules_base
    owner to etluser;

create table if not exists integrated_asc.leadsviewrules_base
(
    dw_table_pk          bigint default "identity"(437153, 0, '0,1'::text) encode az64,
    leadviewid           bigint encode az64,
    beid                 bigint encode az64,
    name                 varchar(50),
    rule                 varchar(3072),
    xmlrule              varchar(512),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadsviewrules_base
    owner to etluser;

grant select on integrated_asc.leadsviewrules_base to group named_user_ro;

create table if not exists landing_asc.permissiontocontact_base
(
    id                    bigint encode az64,
    permissiondescription varchar(100),
    isactive              boolean,
    audituserid           double precision,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64
);

alter table landing_asc.permissiontocontact_base
    owner to etluser;

create table if not exists staging_asc.permissiontocontact_base
(
    id                    bigint encode az64,
    permissiondescription varchar(100),
    isactive              boolean,
    audituserid           bigint encode az64 distkey,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.permissiontocontact_base
    owner to etluser;

create table if not exists integrated_asc.permissiontocontact_base
(
    dw_table_pk           bigint default "identity"(437178, 0, '0,1'::text) encode az64,
    id                    bigint encode az64,
    permissiondescription varchar(100),
    isactive              boolean,
    audituserid           bigint encode az64 distkey,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_asc.permissiontocontact_base
    owner to etluser;

grant select on integrated_asc.permissiontocontact_base to group named_user_ro;

create table if not exists landing_asc.phonetype_base
(
    phonetypeid       bigint encode az64,
    phonetypename     varchar(50),
    beid              double precision,
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.phonetype_base
    owner to etluser;

create table if not exists staging_asc.phonetype_base
(
    phonetypeid           bigint encode az64,
    phonetypename         varchar(50),
    beid                  bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.phonetype_base
    owner to etluser;

create table if not exists integrated_asc.phonetype_base
(
    dw_table_pk          bigint default "identity"(437188, 0, '0,1'::text) encode az64,
    phonetypeid          bigint encode az64,
    phonetypename        varchar(50),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.phonetype_base
    owner to etluser;

grant select on integrated_asc.phonetype_base to group named_user_ro;

create table if not exists landing_asc.ratecallforwarding_base
(
    pkratecallforwardingid bigint encode az64,
    callforwardvalue       varchar(50),
    isdeleted              boolean,
    refresh_timestamp      timestamp encode az64
);

alter table landing_asc.ratecallforwarding_base
    owner to etluser;

create table if not exists staging_asc.ratecallforwarding_base
(
    pkratecallforwardingid bigint encode az64 distkey,
    callforwardvalue       varchar(50),
    isdeleted              boolean,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.ratecallforwarding_base
    owner to etluser;

create table if not exists integrated_asc.ratecallforwarding_base
(
    dw_table_pk            bigint default "identity"(437220, 0, '0,1'::text) encode az64,
    pkratecallforwardingid bigint encode az64 distkey,
    callforwardvalue       varchar(50),
    isdeleted              boolean,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.ratecallforwarding_base
    owner to etluser;

grant select on integrated_asc.ratecallforwarding_base to group named_user_ro;

create table if not exists landing_asc.attributetype
(
    attributetypeid   bigint encode az64,
    name              varchar(256),
    description       varchar(1024),
    platformtypeid    double precision,
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.attributetype
    owner to etluser;

create table if not exists staging_asc.attributetype
(
    attributetypeid       bigint encode az64 distkey,
    name                  varchar(256),
    description           varchar(1024),
    platformtypeid        bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.attributetype
    owner to etluser;

create table if not exists integrated_asc.attributetype
(
    dw_table_pk          bigint default "identity"(437283, 0, '0,1'::text) encode az64,
    attributetypeid      bigint encode az64 distkey,
    name                 varchar(256),
    description          varchar(1024),
    platformtypeid       bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.attributetype
    owner to etluser;

grant select on integrated_asc.attributetype to group named_user_ro;

create table if not exists landing_asc.contacttype
(
    contacttypeid     bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.contacttype
    owner to etluser;

create table if not exists staging_asc.contacttype
(
    contacttypeid         bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.contacttype
    owner to etluser;

create table if not exists integrated_asc.contacttype
(
    dw_table_pk          bigint default "identity"(437297, 0, '0,1'::text) encode az64,
    contacttypeid        bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.contacttype
    owner to etluser;

grant select on integrated_asc.contacttype to group named_user_ro;

create table if not exists landing_asc.elementtype
(
    elementtypeid     bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(500),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.elementtype
    owner to etluser;

create table if not exists staging_asc.elementtype
(
    elementtypeid         bigint encode az64 distkey,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(500),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.elementtype
    owner to etluser;

create table if not exists integrated_asc.elementtype
(
    dw_table_pk          bigint default "identity"(437344, 0, '0,1'::text) encode az64,
    elementtypeid        bigint encode az64 distkey,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.elementtype
    owner to etluser;

grant select on integrated_asc.elementtype to group named_user_ro;

create table if not exists landing_asc.errortype
(
    errortypeid       bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.errortype
    owner to etluser;

create table if not exists staging_asc.errortype
(
    errortypeid           bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.errortype
    owner to etluser;

create table if not exists integrated_asc.errortype
(
    dw_table_pk          bigint default "identity"(437354, 0, '0,1'::text) encode az64,
    errortypeid          bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.errortype
    owner to etluser;

grant select on integrated_asc.errortype to group named_user_ro;

create table if not exists landing_asc.formtype
(
    formtypeid        bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.formtype
    owner to etluser;

create table if not exists staging_asc.formtype
(
    formtypeid            bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.formtype
    owner to etluser;

create table if not exists integrated_asc.formtype
(
    dw_table_pk          bigint default "identity"(437364, 0, '0,1'::text) encode az64,
    formtypeid           bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.formtype
    owner to etluser;

grant select on integrated_asc.formtype to group named_user_ro;

create table if not exists landing_asc.persontype
(
    persontypeid      bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.persontype
    owner to etluser;

create table if not exists staging_asc.persontype
(
    persontypeid          bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.persontype
    owner to etluser;

create table if not exists integrated_asc.persontype
(
    dw_table_pk          bigint default "identity"(437408, 0, '0,1'::text) encode az64,
    persontypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.persontype
    owner to etluser;

grant select on integrated_asc.persontype to group named_user_ro;

create table if not exists landing_asc.platformtype
(
    platformtypeid    bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.platformtype
    owner to etluser;

create table if not exists staging_asc.platformtype
(
    platformtypeid        bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.platformtype
    owner to etluser;

create table if not exists integrated_asc.platformtype
(
    dw_table_pk          bigint default "identity"(437418, 0, '0,1'::text) encode az64,
    platformtypeid       bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.platformtype
    owner to etluser;

grant select on integrated_asc.platformtype to group named_user_ro;

create table if not exists landing_asc.statustype
(
    statustypeid      bigint encode az64,
    name              varchar(256),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.statustype
    owner to etluser;

create table if not exists staging_asc.statustype
(
    statustypeid          bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.statustype
    owner to etluser;

create table if not exists integrated_asc.statustype
(
    dw_table_pk          bigint default "identity"(437438, 0, '0,1'::text) encode az64,
    statustypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.statustype
    owner to etluser;

grant select on integrated_asc.statustype to group named_user_ro;

create table if not exists landing_asc.sessionpropertytype
(
    sessionpropertytypeid bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64
);

alter table landing_asc.sessionpropertytype
    owner to etluser;

create table if not exists staging_asc.sessionpropertytype
(
    sessionpropertytypeid bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.sessionpropertytype
    owner to etluser;

create table if not exists integrated_asc.sessionpropertytype
(
    dw_table_pk           bigint default "identity"(437448, 0, '0,1'::text) encode az64,
    sessionpropertytypeid bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_asc.sessionpropertytype
    owner to etluser;

grant select on integrated_asc.sessionpropertytype to group named_user_ro;

create table if not exists landing_asc.regionlocationmap
(
    ascend_carrier_id bigint encode az64 distkey,
    regionlocationid  bigint,
    regionid          bigint encode az64,
    state             varchar(50),
    statefipscode     double precision,
    county            varchar(100),
    countyfipscode    double precision,
    zipcode           varchar(5),
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (regionlocationid);

alter table landing_asc.regionlocationmap
    owner to etluser;

create table if not exists staging_asc.regionlocationmap
(
    ascend_carrier_id     bigint encode az64,
    regionlocationid      bigint encode az64,
    regionid              bigint encode az64,
    state                 varchar(50),
    statefipscode         bigint encode az64,
    county                varchar(100),
    countyfipscode        bigint encode az64,
    zipcode               varchar(5),
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.regionlocationmap
    owner to etluser;

create table if not exists integrated_asc.regionlocationmap
(
    dw_table_pk          bigint default "identity"(439883, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    regionlocationid     bigint encode az64,
    regionid             bigint encode az64,
    state                varchar(50) encode bytedict,
    statefipscode        bigint encode az64,
    county               varchar(100),
    countyfipscode       bigint encode az64,
    zipcode              varchar(5),
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.regionlocationmap
    owner to etluser;

grant select on integrated_asc.regionlocationmap to group named_user_ro;

create table if not exists landing_asc.dynamoaqeformmap
(
    ascend_carrier_id  bigint encode az64,
    dynamoaqeformmapid bigint encode az64,
    dynamoformid       double precision,
    aqecarrierid       double precision,
    aqefromid          double precision,
    notes              varchar(500),
    audituserid        double precision,
    refresh_timestamp  timestamp encode az64
);

alter table landing_asc.dynamoaqeformmap
    owner to etluser;

create table if not exists staging_asc.dynamoaqeformmap
(
    ascend_carrier_id     bigint encode az64,
    dynamoaqeformmapid    bigint encode az64,
    dynamoformid          bigint encode az64,
    aqecarrierid          bigint encode az64,
    aqefromid             bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dynamoaqeformmap
    owner to etluser;

create table if not exists integrated_asc.dynamoaqeformmap
(
    dw_table_pk          bigint default "identity"(439929, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    dynamoaqeformmapid   bigint encode az64,
    dynamoformid         bigint encode az64,
    aqecarrierid         bigint encode az64,
    aqefromid            bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dynamoaqeformmap
    owner to etluser;

grant select on integrated_asc.dynamoaqeformmap to group named_user_ro;

create table if not exists landing_asc.availableagents
(
    ascend_carrier_id bigint encode az64,
    availableid       bigint encode az64,
    beid              double precision,
    userid            double precision,
    startdatetime     timestamp encode az64,
    enddatetime       timestamp encode az64,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.availableagents
    owner to etluser;

create table if not exists staging_asc.availableagents
(
    ascend_carrier_id     bigint encode az64,
    availableid           bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64 distkey,
    startdatetime         timestamp encode az64,
    enddatetime           timestamp encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.availableagents
    owner to etluser;

create table if not exists integrated_asc.availableagents
(
    dw_table_pk          bigint default "identity"(439954, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    availableid          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.availableagents
    owner to etluser;

grant select on integrated_asc.availableagents to group named_user_ro;

create table if not exists landing_asc.meetingtoleadmap
(
    ascend_carrier_id    bigint encode az64,
    meetingtoleadmapid   bigint encode az64 distkey,
    beid                 double precision,
    meetingid            double precision,
    leadid               double precision,
    scopeofappointmentid varchar(100),
    bloomclientid        varchar(100),
    datetimeofmeeting    timestamp,
    notes                varchar(256),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
)
    sortkey (datetimeofmeeting);

alter table landing_asc.meetingtoleadmap
    owner to etluser;

create table if not exists staging_asc.meetingtoleadmap
(
    ascend_carrier_id     bigint encode az64,
    meetingtoleadmapid    bigint encode az64,
    beid                  bigint encode az64,
    meetingid             bigint encode az64,
    leadid                bigint encode az64,
    scopeofappointmentid  varchar(100),
    bloomclientid         varchar(100),
    datetimeofmeeting     timestamp encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.meetingtoleadmap
    owner to etluser;

create table if not exists integrated_asc.meetingtoleadmap
(
    dw_table_pk          bigint default "identity"(439997, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    meetingtoleadmapid   bigint encode az64,
    beid                 bigint encode az64,
    meetingid            bigint encode az64,
    leadid               bigint encode az64,
    scopeofappointmentid varchar(100),
    bloomclientid        varchar(100),
    datetimeofmeeting    timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.meetingtoleadmap
    owner to etluser;

grant select on integrated_asc.meetingtoleadmap to group named_user_ro;

create table if not exists landing_asc.region
(
    ascend_carrier_id bigint encode az64,
    regionid          bigint encode az64,
    beid              bigint encode az64,
    regionname        varchar(100),
    isdeleted         boolean,
    updateinaqe       boolean,
    aqesalesregionid  double precision,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.region
    owner to etluser;

create table if not exists staging_asc.region
(
    ascend_carrier_id     bigint encode az64,
    regionid              bigint encode az64,
    beid                  bigint encode az64,
    regionname            varchar(100),
    isdeleted             boolean,
    updateinaqe           boolean,
    aqesalesregionid      bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.region
    owner to etluser;

create table if not exists integrated_asc.region
(
    dw_table_pk          bigint default "identity"(440061, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    regionid             bigint encode az64,
    beid                 bigint encode az64,
    regionname           varchar(100),
    isdeleted            boolean,
    updateinaqe          boolean,
    aqesalesregionid     bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.region
    owner to etluser;

grant select on integrated_asc.region to group named_user_ro;

create table if not exists landing_asc.dispositiontypedisposition_map_custom
(
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    businessentityid     bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.dispositiontypedisposition_map_custom
    owner to etluser;

create table if not exists staging_asc.dispositiontypedisposition_map_custom
(
    ascend_carrier_id     bigint encode az64,
    dispositiontypemapid  bigint encode az64,
    businessentityid      bigint encode az64,
    typeid                bigint encode az64,
    dispositionid         bigint encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositiontypedisposition_map_custom
    owner to etluser;

create table if not exists integrated_asc.dispositiontypedisposition_map_custom
(
    dw_table_pk          bigint default "identity"(440140, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    businessentityid     bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dispositiontypedisposition_map_custom
    owner to etluser;

grant select on integrated_asc.dispositiontypedisposition_map_custom to group named_user_ro;

create table if not exists landing_asc.userdetails
(
    ascend_carrier_id    bigint encode az64,
    userdetailsid        bigint encode az64,
    userid               bigint encode az64 distkey,
    beid                 bigint encode az64,
    primaryphone         varchar(15),
    officephone          varchar(15),
    homephone            varchar(15),
    mobilephone          varchar(15),
    fax                  varchar(15),
    address              varchar(50),
    city                 varchar(50),
    state                varchar(2),
    zipcode              varchar(5),
    extusername          varchar(150),
    extpassword          varchar(150),
    useenrollurl         boolean,
    leadgeneration       boolean,
    skilllevel           double precision,
    userurl              varchar(500),
    userate              boolean,
    enrollmentphone      varchar(20),
    contactnumbersid     varchar(50),
    natpronum            varchar(10),
    notes                varchar(500),
    audituserid          double precision,
    ratecallforwardingid double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.userdetails
    owner to etluser;

create table if not exists staging_asc.userdetails
(
    ascend_carrier_id     bigint encode az64,
    userdetailsid         bigint encode az64,
    userid                bigint encode az64 distkey,
    beid                  bigint encode az64,
    primaryphone          varchar(15),
    officephone           varchar(15),
    homephone             varchar(15),
    mobilephone           varchar(15),
    fax                   varchar(15),
    address               varchar(50),
    city                  varchar(50),
    state                 varchar(2),
    zipcode               varchar(5),
    extusername           varchar(150),
    extpassword           varchar(150),
    useenrollurl          boolean,
    leadgeneration        boolean,
    skilllevel            bigint encode az64,
    userurl               varchar(500),
    userate               boolean,
    enrollmentphone       varchar(20),
    contactnumbersid      varchar(50),
    natpronum             varchar(10),
    notes                 varchar(500) encode bytedict,
    audituserid           bigint encode az64,
    ratecallforwardingid  bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.userdetails
    owner to etluser;

create table if not exists integrated_asc.userdetails
(
    dw_table_pk          bigint default "identity"(440296, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    userdetailsid        bigint encode az64,
    userid               bigint encode az64 distkey,
    beid                 bigint encode az64,
    primaryphone         varchar(15),
    officephone          varchar(15),
    homephone            varchar(15),
    mobilephone          varchar(15),
    fax                  varchar(15),
    address              varchar(50),
    city                 varchar(50),
    state                varchar(2),
    zipcode              varchar(5),
    extusername          varchar(150),
    extpassword          varchar(150),
    useenrollurl         boolean,
    leadgeneration       boolean,
    skilllevel           bigint encode az64,
    userurl              varchar(500),
    userate              boolean,
    enrollmentphone      varchar(20),
    contactnumbersid     varchar(50),
    natpronum            varchar(10),
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    ratecallforwardingid bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.userdetails
    owner to etluser;

grant select on integrated_asc.userdetails to group named_user_ro;

create table if not exists landing_asc.userqueue_map
(
    ascend_carrier_id bigint encode az64,
    userqueuemapid    bigint encode az64,
    userid            bigint encode az64,
    leadqueueid       bigint encode az64,
    beid              bigint encode az64,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.userqueue_map
    owner to etluser;

create table if not exists staging_asc.userqueue_map
(
    ascend_carrier_id     bigint encode az64,
    userqueuemapid        bigint encode az64 distkey,
    userid                bigint encode az64,
    leadqueueid           bigint encode az64,
    beid                  bigint encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.userqueue_map
    owner to etluser;

create table if not exists integrated_asc.userqueue_map
(
    dw_table_pk          bigint default "identity"(440459, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    userqueuemapid       bigint encode az64 distkey,
    userid               bigint encode az64,
    leadqueueid          bigint encode az64,
    beid                 bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.userqueue_map
    owner to etluser;

grant select on integrated_asc.userqueue_map to group named_user_ro;

create table if not exists landing_asc.hvv2appointmentmeetingmap
(
    ascend_carrier_id           bigint encode az64,
    hvv2appointmentmeetingmapid bigint encode az64,
    hvv2appointmentid           bigint encode az64,
    meetinghistoryid            bigint encode az64 distkey,
    isdeleted                   boolean,
    notes                       varchar(500),
    audituserid                 double precision,
    refresh_timestamp           timestamp
)
    sortkey (refresh_timestamp);

alter table landing_asc.hvv2appointmentmeetingmap
    owner to etluser;

create table if not exists staging_asc.hvv2appointmentmeetingmap
(
    ascend_carrier_id           bigint encode az64,
    hvv2appointmentmeetingmapid bigint encode az64,
    hvv2appointmentid           bigint encode az64,
    meetinghistoryid            bigint encode az64,
    isdeleted                   boolean,
    notes                       varchar(500),
    audituserid                 bigint encode az64 distkey,
    refresh_timestamp           timestamp encode az64,
    data_action_indicator       char default 'N'::bpchar,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table staging_asc.hvv2appointmentmeetingmap
    owner to etluser;

create table if not exists integrated_asc.hvv2appointmentmeetingmap
(
    dw_table_pk                 bigint default "identity"(440496, 0, '0,1'::text) encode az64,
    ascend_carrier_id           bigint encode az64,
    hvv2appointmentmeetingmapid bigint encode az64,
    hvv2appointmentid           bigint encode az64,
    meetinghistoryid            bigint encode az64,
    isdeleted                   boolean,
    notes                       varchar(500),
    audituserid                 bigint encode az64 distkey,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32)
);

alter table integrated_asc.hvv2appointmentmeetingmap
    owner to etluser;

grant select on integrated_asc.hvv2appointmentmeetingmap to group named_user_ro;

create table if not exists landing_asc.roles_custom
(
    ascend_carrier_id bigint encode az64,
    roleid            bigint encode az64,
    carrierid         double precision,
    businessentityid  double precision,
    code              varchar(50),
    name              varchar(256),
    notes             varchar(256),
    audituserid       double precision,
    isactive          boolean,
    permission        varchar(1024),
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.roles_custom
    owner to etluser;

create table if not exists staging_asc.roles_custom
(
    ascend_carrier_id     bigint encode az64,
    roleid                bigint encode az64,
    carrierid             bigint encode az64,
    businessentityid      bigint encode az64,
    code                  varchar(50),
    name                  varchar(256),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    isactive              boolean,
    permission            varchar(1024),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.roles_custom
    owner to etluser;

create table if not exists integrated_asc.roles_custom
(
    dw_table_pk          bigint default "identity"(440537, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    roleid               bigint encode az64,
    carrierid            bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(50),
    name                 varchar(256),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    isactive             boolean,
    permission           varchar(1024),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.roles_custom
    owner to etluser;

grant select on integrated_asc.roles_custom to group named_user_ro;

create table if not exists landing_asc.hvv2appointmentscopemap
(
    ascend_carrier_id         bigint encode az64 distkey,
    hvv2appointmentscopemapid bigint encode az64,
    hvv2appointmentid         bigint encode az64,
    scopeofappointmentid      bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               double precision,
    refresh_timestamp         timestamp encode az64
)
    sortkey (audituserid);

alter table landing_asc.hvv2appointmentscopemap
    owner to etluser;

create table if not exists staging_asc.hvv2appointmentscopemap
(
    ascend_carrier_id         bigint encode az64,
    hvv2appointmentscopemapid bigint encode az64,
    hvv2appointmentid         bigint encode az64,
    scopeofappointmentid      bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_asc.hvv2appointmentscopemap
    owner to etluser;

create table if not exists integrated_asc.hvv2appointmentscopemap
(
    dw_table_pk               bigint default "identity"(440581, 0, '0,1'::text) encode az64,
    ascend_carrier_id         bigint encode az64,
    hvv2appointmentscopemapid bigint encode az64,
    hvv2appointmentid         bigint encode az64,
    scopeofappointmentid      bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table integrated_asc.hvv2appointmentscopemap
    owner to etluser;

grant select on integrated_asc.hvv2appointmentscopemap to group named_user_ro;

create table if not exists landing_asc.events
(
    ascend_carrier_id  bigint encode az64,
    eventid            bigint encode az64,
    eventtypeid        bigint encode az64 distkey,
    beid               bigint encode az64,
    eventstartdatetime timestamp encode az64,
    eventdurationid    double precision,
    eventstatusid      double precision,
    eventcreatedate    timestamp,
    isdeleted          boolean,
    ascendbaseeventid  double precision,
    notes              varchar(500),
    audituserid        double precision,
    refresh_timestamp  timestamp encode az64
)
    sortkey (eventcreatedate);

alter table landing_asc.events
    owner to etluser;

create table if not exists staging_asc.events
(
    ascend_carrier_id     bigint encode az64,
    eventid               bigint encode az64,
    eventtypeid           bigint encode az64,
    beid                  bigint encode az64,
    eventstartdatetime    timestamp encode az64,
    eventdurationid       bigint encode az64,
    eventstatusid         bigint encode az64,
    eventcreatedate       timestamp encode az64,
    isdeleted             boolean,
    ascendbaseeventid     bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.events
    owner to etluser;

create table if not exists integrated_asc.events
(
    dw_table_pk          bigint default "identity"(440613, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventid              bigint encode az64,
    eventtypeid          bigint encode az64,
    beid                 bigint encode az64,
    eventstartdatetime   timestamp encode az64,
    eventdurationid      bigint encode az64,
    eventstatusid        bigint encode az64,
    eventcreatedate      timestamp encode az64,
    isdeleted            boolean,
    ascendbaseeventid    bigint encode az64,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.events
    owner to etluser;

grant select on integrated_asc.events to group named_user_ro;

create table if not exists landing_asc.sfcustomprospectdata
(
    ascend_carrier_id      bigint encode az64,
    sfcustomprospectdataid bigint encode az64,
    prospectid             bigint encode az64,
    salesforceid           varchar(100),
    columnname             varchar(100),
    datatype               varchar(100),
    value                  varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    audituserid            double precision,
    notes                  varchar(500),
    refresh_timestamp      timestamp encode az64
);

alter table landing_asc.sfcustomprospectdata
    owner to etluser;

create table if not exists staging_asc.sfcustomprospectdata
(
    ascend_carrier_id      bigint encode az64,
    sfcustomprospectdataid bigint encode az64,
    prospectid             bigint encode az64,
    salesforceid           varchar(100),
    columnname             varchar(100),
    datatype               varchar(100),
    value                  varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    audituserid            bigint encode az64,
    notes                  varchar(500),
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.sfcustomprospectdata
    owner to etluser;

create table if not exists integrated_asc.sfcustomprospectdata
(
    dw_table_pk            bigint default "identity"(440706, 0, '0,1'::text) encode az64,
    ascend_carrier_id      bigint encode az64,
    sfcustomprospectdataid bigint encode az64,
    prospectid             bigint encode az64,
    salesforceid           varchar(100),
    columnname             varchar(100),
    datatype               varchar(100),
    value                  varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    audituserid            bigint encode az64,
    notes                  varchar(500),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.sfcustomprospectdata
    owner to etluser;

grant select on integrated_asc.sfcustomprospectdata to group named_user_ro;

create table if not exists landing_asc.accesstype_custom
(
    ascend_carrier_id bigint encode az64,
    accesstypeid      bigint encode az64,
    beid              double precision,
    accesstype        varchar(30),
    isdeleted         boolean,
    notes             varchar(1000),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.accesstype_custom
    owner to etluser;

create table if not exists staging_asc.accesstype_custom
(
    ascend_carrier_id     bigint encode az64,
    accesstypeid          bigint encode az64,
    beid                  bigint encode az64,
    accesstype            varchar(30),
    isdeleted             boolean,
    notes                 varchar(1000),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.accesstype_custom
    owner to etluser;

create table if not exists integrated_asc.accesstype_custom
(
    dw_table_pk          bigint default "identity"(440718, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    accesstypeid         bigint encode az64,
    beid                 bigint encode az64,
    accesstype           varchar(30),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.accesstype_custom
    owner to etluser;

grant select on integrated_asc.accesstype_custom to group named_user_ro;

create table if not exists landing_asc.customprospectdata
(
    ascend_carrier_id      bigint encode az64 distkey,
    prospectcustomobjectid bigint encode az64,
    prospectid             double precision,
    externalid             varchar(256),
    datecreated            timestamp,
    datemodified           timestamp encode az64,
    notes                  varchar(150),
    audituserid            double precision,
    campaignmemberid       varchar(256),
    salesforceid           varchar(256),
    campaignmemberobject   varchar(256),
    refresh_timestamp      timestamp encode az64
)
    sortkey (datecreated);

alter table landing_asc.customprospectdata
    owner to etluser;

create table if not exists staging_asc.customprospectdata
(
    ascend_carrier_id      bigint encode az64,
    prospectcustomobjectid bigint encode az64,
    prospectid             bigint encode az64,
    externalid             varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    notes                  varchar(150),
    audituserid            bigint encode az64 distkey,
    campaignmemberid       varchar(256),
    salesforceid           varchar(256),
    campaignmemberobject   varchar(256),
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.customprospectdata
    owner to etluser;

create table if not exists integrated_asc.customprospectdata
(
    dw_table_pk            bigint default "identity"(440730, 0, '0,1'::text) encode az64,
    ascend_carrier_id      bigint encode az64,
    prospectcustomobjectid bigint encode az64,
    prospectid             bigint encode az64,
    externalid             varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    notes                  varchar(150),
    audituserid            bigint encode az64 distkey,
    campaignmemberid       varchar(256),
    salesforceid           varchar(256),
    campaignmemberobject   varchar(256),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.customprospectdata
    owner to etluser;

grant select on integrated_asc.customprospectdata to group named_user_ro;

create table if not exists landing_asc.documents
(
    ascend_carrier_id   bigint encode az64,
    documentid          bigint encode az64,
    businessentityid    bigint encode az64 distkey,
    documentname        varchar(100),
    publishdate         timestamp encode az64,
    expirydate          timestamp encode az64,
    createddate         timestamp,
    folderid            double precision,
    subfolderid         double precision,
    replacesdocumentid  double precision,
    documentpath        varchar(4096),
    isdeleted           boolean,
    notes               varchar(256),
    audituserid         double precision,
    resourcetype        varchar(25),
    displayonhomescreen boolean,
    passauth            boolean,
    action              varchar(50),
    ranking             double precision,
    recipientcount      double precision,
    refresh_timestamp   timestamp encode az64
)
    sortkey (createddate);

alter table landing_asc.documents
    owner to etluser;

create table if not exists staging_asc.documents
(
    ascend_carrier_id     bigint encode az64,
    documentid            bigint encode az64,
    businessentityid      bigint encode az64,
    documentname          varchar(100),
    publishdate           timestamp encode az64,
    expirydate            timestamp encode az64,
    createddate           timestamp encode az64,
    folderid              bigint encode az64,
    subfolderid           bigint encode az64,
    replacesdocumentid    bigint encode az64,
    documentpath          varchar(4096),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    resourcetype          varchar(25),
    displayonhomescreen   boolean,
    passauth              boolean,
    action                varchar(50),
    ranking               bigint encode az64,
    recipientcount        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.documents
    owner to etluser;

create table if not exists integrated_asc.documents
(
    dw_table_pk          bigint default "identity"(440761, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    documentid           bigint encode az64,
    businessentityid     bigint encode az64,
    documentname         varchar(100),
    publishdate          timestamp encode az64,
    expirydate           timestamp encode az64,
    createddate          timestamp encode az64,
    folderid             bigint encode az64,
    subfolderid          bigint encode az64,
    replacesdocumentid   bigint encode az64,
    documentpath         varchar(4096),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    resourcetype         varchar(25),
    displayonhomescreen  boolean,
    passauth             boolean,
    action               varchar(50),
    ranking              bigint encode az64,
    recipientcount       bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.documents
    owner to etluser;

grant select on integrated_asc.documents to group named_user_ro;

create table if not exists landing_asc.dispositions_custom
(
    ascend_carrier_id bigint encode az64,
    dispositionsid    bigint encode az64,
    businessentityid  bigint encode az64,
    code              varchar(10),
    description       varchar(50),
    status            varchar(2),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.dispositions_custom
    owner to etluser;

create table if not exists staging_asc.dispositions_custom
(
    ascend_carrier_id     bigint encode az64,
    dispositionsid        bigint encode az64,
    businessentityid      bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    status                varchar(2),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositions_custom
    owner to etluser;

create table if not exists integrated_asc.dispositions_custom
(
    dw_table_pk          bigint default "identity"(440869, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    dispositionsid       bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dispositions_custom
    owner to etluser;

grant select on integrated_asc.dispositions_custom to group named_user_ro;

create table if not exists landing_asc.messages
(
    ascend_carrier_id bigint encode az64,
    messageid         bigint encode az64,
    businessentityid  double precision,
    publishdate       timestamp encode az64,
    expirydate        timestamp encode az64,
    createddate       timestamp encode az64,
    requireack        boolean,
    messagetext       varchar(9216),
    title             varchar(100),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    htmlformattedtext varchar(9216),
    messagereceviedby double precision,
    usersacknowledged double precision,
    recipientcount    double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.messages
    owner to etluser;

create table if not exists staging_asc.messages
(
    ascend_carrier_id     bigint encode az64,
    messageid             bigint encode az64 distkey,
    businessentityid      bigint encode az64,
    publishdate           timestamp encode az64,
    expirydate            timestamp encode az64,
    createddate           timestamp encode az64,
    requireack            boolean,
    messagetext           varchar(9216),
    title                 varchar(100),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    htmlformattedtext     varchar(9216),
    messagereceviedby     bigint encode az64,
    usersacknowledged     bigint encode az64,
    recipientcount        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.messages
    owner to etluser;

create table if not exists integrated_asc.messages
(
    dw_table_pk          bigint default "identity"(442115, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    messageid            bigint encode az64 distkey,
    businessentityid     bigint encode az64,
    publishdate          timestamp encode az64,
    expirydate           timestamp encode az64,
    createddate          timestamp encode az64,
    requireack           boolean,
    messagetext          varchar(9216),
    title                varchar(100),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64,
    htmlformattedtext    varchar(9216),
    messagereceviedby    bigint encode az64,
    usersacknowledged    bigint encode az64,
    recipientcount       bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.messages
    owner to etluser;

grant select on integrated_asc.messages to group named_user_ro;

create table if not exists landing_asc.languages_custom
(
    ascend_carrier_id bigint encode az64,
    languagesid       bigint encode az64,
    businessentityid  double precision,
    code              varchar(10),
    description       varchar(50),
    status            varchar(2),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.languages_custom
    owner to etluser;

create table if not exists staging_asc.languages_custom
(
    ascend_carrier_id     bigint encode az64,
    languagesid           bigint encode az64,
    businessentityid      bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    status                varchar(2),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.languages_custom
    owner to etluser;

create table if not exists integrated_asc.languages_custom
(
    dw_table_pk          bigint default "identity"(442207, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    languagesid          bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.languages_custom
    owner to etluser;

grant select on integrated_asc.languages_custom to group named_user_ro;

create table if not exists landing_asc.prospects
(
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint encode az64 distkey,
    beid                       bigint encode az64,
    meetingid                  double precision,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50),
    leadsourceid               double precision,
    dateofcreation             timestamp,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    double precision,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               double precision,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10),
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256),
    notes                      varchar(1024),
    audituserid                double precision,
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64
)
    sortkey (dateofcreation);

alter table landing_asc.prospects
    owner to etluser;

create table if not exists staging_asc.prospects
(
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint encode az64,
    beid                       bigint encode az64,
    meetingid                  bigint encode az64,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50),
    leadsourceid               bigint encode az64,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    bigint encode az64,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               bigint encode az64,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10),
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256),
    notes                      varchar(1024),
    audituserid                bigint encode az64 distkey,
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.prospects
    owner to etluser;

create table if not exists integrated_asc.prospects
(
    dw_table_pk                bigint default "identity"(442228, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint encode az64,
    beid                       bigint encode az64,
    meetingid                  bigint encode az64,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50) encode bytedict,
    leadsourceid               bigint encode az64,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    bigint encode az64,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               bigint encode az64,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10) encode bytedict,
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256) encode bytedict,
    notes                      varchar(1024),
    audituserid                bigint encode az64 distkey,
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.prospects
    owner to etluser;

grant select on integrated_asc.prospects to group named_user_ro;

create table if not exists landing_asc.faxnumbers
(
    ascend_carrier_id bigint encode az64,
    faxnumberid       bigint encode az64,
    beid              double precision,
    tofaxnumber       varchar(50),
    description       varchar(100),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.faxnumbers
    owner to etluser;

create table if not exists staging_asc.faxnumbers
(
    ascend_carrier_id     bigint encode az64,
    faxnumberid           bigint encode az64,
    beid                  bigint encode az64,
    tofaxnumber           varchar(50),
    description           varchar(100),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.faxnumbers
    owner to etluser;

create table if not exists integrated_asc.faxnumbers
(
    dw_table_pk          bigint default "identity"(442404, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    faxnumberid          bigint encode az64,
    beid                 bigint encode az64,
    tofaxnumber          varchar(50),
    description          varchar(100),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.faxnumbers
    owner to etluser;

grant select on integrated_asc.faxnumbers to group named_user_ro;

create table if not exists landing_asc.zones
(
    ascend_carrier_id bigint encode az64,
    zoneid            bigint encode az64,
    beid              double precision,
    zone              varchar(50),
    county            varchar(50),
    isactive          boolean,
    notes             varchar(150),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.zones
    owner to etluser;

create table if not exists staging_asc.zones
(
    ascend_carrier_id     bigint encode az64,
    zoneid                bigint encode az64,
    beid                  bigint encode az64,
    zone                  varchar(50),
    county                varchar(50),
    isactive              boolean,
    notes                 varchar(150),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.zones
    owner to etluser;

create table if not exists integrated_asc.zones
(
    dw_table_pk          bigint default "identity"(442431, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    zoneid               bigint encode az64,
    beid                 bigint encode az64,
    zone                 varchar(50),
    county               varchar(50),
    isactive             boolean,
    notes                varchar(150),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.zones
    owner to etluser;

grant select on integrated_asc.zones to group named_user_ro;

create table if not exists landing_asc.phonetype_custom
(
    ascend_carrier_id bigint encode az64,
    phonetypeid       bigint encode az64,
    phonetypename     varchar(50),
    beid              bigint encode az64,
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.phonetype_custom
    owner to etluser;

create table if not exists staging_asc.phonetype_custom
(
    ascend_carrier_id     bigint encode az64,
    phonetypeid           bigint encode az64,
    phonetypename         varchar(50),
    beid                  bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.phonetype_custom
    owner to etluser;

create table if not exists integrated_asc.phonetype_custom
(
    dw_table_pk          bigint default "identity"(442492, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    phonetypeid          bigint encode az64,
    phonetypename        varchar(50),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.phonetype_custom
    owner to etluser;

grant select on integrated_asc.phonetype_custom to group named_user_ro;

create table if not exists landing_asc.groups_custom
(
    ascend_carrier_id bigint encode az64,
    groupsid          bigint encode az64,
    businessentityid  bigint encode az64,
    code              varchar(10),
    description       varchar(50),
    groupdescription  varchar(500),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.groups_custom
    owner to etluser;

create table if not exists staging_asc.groups_custom
(
    ascend_carrier_id     bigint encode az64,
    groupsid              bigint encode az64,
    businessentityid      bigint encode az64,
    code                  varchar(10),
    description           varchar(50),
    groupdescription      varchar(500),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.groups_custom
    owner to etluser;

create table if not exists integrated_asc.groups_custom
(
    dw_table_pk          bigint default "identity"(442504, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    groupsid             bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    groupdescription     varchar(500),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.groups_custom
    owner to etluser;

grant select on integrated_asc.groups_custom to group named_user_ro;

create table if not exists landing_asc.hvv2appointments
(
    ascend_carrier_id    bigint encode az64 distkey,
    hvv2appointmentid    bigint encode az64,
    beid                 double precision,
    leadid               double precision,
    userid               double precision,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    durationinminutes    double precision,
    scopeofappointmentid double precision,
    meetinghistoryid     double precision,
    notes                varchar(500),
    audituserid          double precision,
    hvv2scheduleid       double precision,
    regionid             double precision,
    languageid           double precision,
    isdeleted            boolean,
    isvirtual            boolean,
    meetingcode          varchar(50),
    recordingurl         varchar(256),
    agentmeetinglink     varchar(256),
    guestmeetinglink     varchar(256),
    refresh_timestamp    timestamp encode az64
)
    sortkey (audituserid);

alter table landing_asc.hvv2appointments
    owner to etluser;

create table if not exists staging_asc.hvv2appointments
(
    ascend_carrier_id     bigint encode az64,
    hvv2appointmentid     bigint encode az64,
    beid                  bigint encode az64,
    leadid                bigint encode az64,
    userid                bigint encode az64 distkey,
    startdatetime         timestamp encode az64,
    enddatetime           timestamp encode az64,
    durationinminutes     bigint encode az64,
    scopeofappointmentid  bigint encode az64,
    meetinghistoryid      bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64,
    hvv2scheduleid        bigint encode az64,
    regionid              bigint encode az64,
    languageid            bigint encode az64,
    isdeleted             boolean,
    isvirtual             boolean,
    meetingcode           varchar(50),
    recordingurl          varchar(256),
    agentmeetinglink      varchar(256),
    guestmeetinglink      varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.hvv2appointments
    owner to etluser;

create table if not exists integrated_asc.hvv2appointments
(
    dw_table_pk          bigint default "identity"(442714, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    hvv2appointmentid    bigint encode az64,
    beid                 bigint encode az64,
    leadid               bigint encode az64,
    userid               bigint encode az64 distkey,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    durationinminutes    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    meetinghistoryid     bigint encode az64,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    hvv2scheduleid       bigint encode az64,
    regionid             bigint encode az64,
    languageid           bigint encode az64,
    isdeleted            boolean,
    isvirtual            boolean,
    meetingcode          varchar(50),
    recordingurl         varchar(256),
    agentmeetinglink     varchar(256),
    guestmeetinglink     varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.hvv2appointments
    owner to etluser;

grant select on integrated_asc.hvv2appointments to group named_user_ro;

create table if not exists landing_asc.faxtransmissions
(
    ascend_carrier_id         bigint encode az64,
    faxtransmissionid         bigint encode az64,
    leadid                    double precision,
    userid                    double precision,
    faxstatus                 varchar(256),
    tofaxnumber               varchar(50),
    externalfaxtransmissionid varchar(256),
    paperid                   varchar(100),
    soaid                     varchar(100),
    docid                     varchar(100),
    faxdatetime               timestamp encode az64,
    notes                     varchar(500),
    audituserid               double precision,
    refresh_timestamp         timestamp encode az64
);

alter table landing_asc.faxtransmissions
    owner to etluser;

create table if not exists staging_asc.faxtransmissions
(
    ascend_carrier_id         bigint encode az64,
    faxtransmissionid         bigint encode az64,
    leadid                    bigint encode az64,
    userid                    bigint encode az64 distkey,
    faxstatus                 varchar(256),
    tofaxnumber               varchar(50),
    externalfaxtransmissionid varchar(256),
    paperid                   varchar(100),
    soaid                     varchar(100),
    docid                     varchar(100),
    faxdatetime               timestamp encode az64,
    notes                     varchar(500),
    audituserid               bigint encode az64,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_asc.faxtransmissions
    owner to etluser;

create table if not exists integrated_asc.faxtransmissions
(
    dw_table_pk               bigint default "identity"(442751, 0, '0,1'::text) encode az64,
    ascend_carrier_id         bigint encode az64,
    faxtransmissionid         bigint encode az64,
    leadid                    bigint encode az64,
    userid                    bigint encode az64 distkey,
    faxstatus                 varchar(256),
    tofaxnumber               varchar(50),
    externalfaxtransmissionid varchar(256),
    paperid                   varchar(100),
    soaid                     varchar(100),
    docid                     varchar(100),
    faxdatetime               timestamp encode az64,
    notes                     varchar(500),
    audituserid               bigint encode az64,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table integrated_asc.faxtransmissions
    owner to etluser;

grant select on integrated_asc.faxtransmissions to group named_user_ro;

create table if not exists landing_asc.appointmentsubscription_map
(
    ascend_carrier_id   bigint encode az64,
    subscriptionid      bigint,
    businessentityid    bigint encode az64 distkey,
    apptid              bigint encode az64,
    leadid              bigint encode az64,
    prospectid          double precision,
    generalseats        double precision,
    isactive            boolean,
    attendedappointment boolean,
    notes               varchar(256),
    audituserid         double precision,
    passcode            varchar(100),
    refresh_timestamp   timestamp encode az64
)
    sortkey (subscriptionid);

alter table landing_asc.appointmentsubscription_map
    owner to etluser;

create table if not exists staging_asc.appointmentsubscription_map
(
    ascend_carrier_id     bigint encode az64,
    subscriptionid        bigint encode az64,
    businessentityid      bigint encode az64,
    apptid                bigint encode az64,
    leadid                bigint encode az64,
    prospectid            bigint encode az64,
    generalseats          bigint encode az64,
    isactive              boolean,
    attendedappointment   boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    passcode              varchar(100),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.appointmentsubscription_map
    owner to etluser;

create table if not exists integrated_asc.appointmentsubscription_map
(
    dw_table_pk          bigint default "identity"(442814, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    subscriptionid       bigint encode az64,
    businessentityid     bigint encode az64,
    apptid               bigint encode az64,
    leadid               bigint encode az64,
    prospectid           bigint encode az64,
    generalseats         bigint encode az64,
    isactive             boolean,
    attendedappointment  boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    passcode             varchar(100),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.appointmentsubscription_map
    owner to etluser;

grant select on integrated_asc.appointmentsubscription_map to group named_user_ro;

create table if not exists landing_asc.leadsource_custom
(
    ascend_carrier_id bigint encode az64,
    sourceid          bigint,
    businessentityid  double precision distkey,
    leadsource        varchar(300),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (sourceid);

alter table landing_asc.leadsource_custom
    owner to etluser;

create table if not exists staging_asc.leadsource_custom
(
    ascend_carrier_id     bigint encode az64,
    sourceid              bigint encode az64,
    businessentityid      bigint encode az64,
    leadsource            varchar(300),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadsource_custom
    owner to etluser;

create table if not exists integrated_asc.leadsource_custom
(
    dw_table_pk          bigint default "identity"(442857, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    sourceid             bigint encode az64,
    businessentityid     bigint encode az64,
    leadsource           varchar(300),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadsource_custom
    owner to etluser;

grant select on integrated_asc.leadsource_custom to group named_user_ro;

create table if not exists landing_asc.userlangmap
(
    ascend_carrier_id bigint encode az64,
    userlangid        bigint encode az64,
    businessentityid  double precision,
    userid            bigint encode az64,
    languageid        bigint encode az64,
    isdeleted         boolean,
    notes             varchar(50),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.userlangmap
    owner to etluser;

create table if not exists staging_asc.userlangmap
(
    ascend_carrier_id     bigint encode az64,
    userlangid            bigint encode az64,
    businessentityid      bigint encode az64,
    userid                bigint encode az64 distkey,
    languageid            bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(50),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.userlangmap
    owner to etluser;

create table if not exists integrated_asc.userlangmap
(
    dw_table_pk          bigint default "identity"(442948, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    userlangid           bigint encode az64,
    businessentityid     bigint encode az64,
    userid               bigint encode az64 distkey,
    languageid           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(50),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.userlangmap
    owner to etluser;

grant select on integrated_asc.userlangmap to group named_user_ro;

create table if not exists landing_asc.eventsagentmap
(
    ascend_carrier_id bigint encode az64,
    eventagentmapid   bigint encode az64,
    eventid           bigint encode az64,
    userid            bigint encode az64 distkey,
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (audituserid);

alter table landing_asc.eventsagentmap
    owner to etluser;

create table if not exists staging_asc.eventsagentmap
(
    ascend_carrier_id     bigint encode az64,
    eventagentmapid       bigint encode az64,
    eventid               bigint encode az64,
    userid                bigint encode az64 distkey,
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventsagentmap
    owner to etluser;

create table if not exists integrated_asc.eventsagentmap
(
    dw_table_pk          bigint default "identity"(443086, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventagentmapid      bigint encode az64,
    eventid              bigint encode az64,
    userid               bigint encode az64 distkey,
    isdeleted            boolean,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventsagentmap
    owner to etluser;

grant select on integrated_asc.eventsagentmap to group named_user_ro;

create table if not exists landing_asc.emailtemplatetrack
(
    ascend_carrier_id    bigint encode az64,
    emailtemplatetrackid bigint encode az64 distkey,
    beid                 double precision,
    templateid           varchar(100),
    datetimesent         timestamp,
    senderuserid         double precision,
    receiveruserid       double precision,
    receiveremail        varchar(100),
    response             varchar(100),
    notes                varchar(1000),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
)
    sortkey (datetimesent);

alter table landing_asc.emailtemplatetrack
    owner to etluser;

create table if not exists staging_asc.emailtemplatetrack
(
    ascend_carrier_id     bigint encode az64,
    emailtemplatetrackid  bigint encode az64,
    beid                  bigint encode az64,
    templateid            varchar(100),
    datetimesent          timestamp encode az64,
    senderuserid          bigint encode az64 distkey,
    receiveruserid        bigint encode az64,
    receiveremail         varchar(100),
    response              varchar(100),
    notes                 varchar(1000),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.emailtemplatetrack
    owner to etluser;

create table if not exists integrated_asc.emailtemplatetrack
(
    dw_table_pk          bigint default "identity"(443204, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    emailtemplatetrackid bigint encode az64,
    beid                 bigint encode az64,
    templateid           varchar(100),
    datetimesent         timestamp encode az64,
    senderuserid         bigint encode az64 distkey,
    receiveruserid       bigint encode az64,
    receiveremail        varchar(100),
    response             varchar(100),
    notes                varchar(1000),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.emailtemplatetrack
    owner to etluser;

grant select on integrated_asc.emailtemplatetrack to group named_user_ro;

create table if not exists landing_asc.messagetarget_map
(
    ascend_carrier_id  bigint encode az64,
    mapmessagetargetid bigint,
    businessentityid   double precision,
    messageid          bigint encode az64 distkey,
    userid             double precision,
    groupid            double precision,
    isdeleted          boolean,
    notes              varchar(256),
    audituserid        double precision,
    refresh_timestamp  timestamp encode az64
)
    sortkey (mapmessagetargetid);

alter table landing_asc.messagetarget_map
    owner to etluser;

create table if not exists staging_asc.messagetarget_map
(
    ascend_carrier_id     bigint encode az64,
    mapmessagetargetid    bigint encode az64,
    businessentityid      bigint encode az64,
    messageid             bigint encode az64,
    userid                bigint encode az64 distkey,
    groupid               bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.messagetarget_map
    owner to etluser;

create table if not exists integrated_asc.messagetarget_map
(
    dw_table_pk          bigint default "identity"(443234, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    mapmessagetargetid   bigint encode az64,
    businessentityid     bigint encode az64,
    messageid            bigint encode az64,
    userid               bigint encode az64 distkey,
    groupid              bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.messagetarget_map
    owner to etluser;

grant select on integrated_asc.messagetarget_map to group named_user_ro;

create table if not exists landing_asc.leadqueues
(
    ascend_carrier_id bigint encode az64,
    id                bigint encode az64,
    beid              bigint encode az64,
    name              varchar(50),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadqueues
    owner to etluser;

create table if not exists staging_asc.leadqueues
(
    ascend_carrier_id     bigint encode az64,
    id                    bigint encode az64,
    beid                  bigint encode az64,
    name                  varchar(50),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadqueues
    owner to etluser;

create table if not exists integrated_asc.leadqueues
(
    dw_table_pk          bigint default "identity"(443297, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    id                   bigint encode az64,
    beid                 bigint encode az64,
    name                 varchar(50),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadqueues
    owner to etluser;

grant select on integrated_asc.leadqueues to group named_user_ro;

create table if not exists landing_asc.leadgenerationtracking
(
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       double precision,
    prospectid                 double precision,
    fieldagentid               double precision,
    callcenteragentname        varchar(50),
    contactinfofk              double precision,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(64),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 5) encode az64,
    notes                      varchar(256),
    audituserid                double precision,
    refresh_timestamp          timestamp encode az64
);

alter table landing_asc.leadgenerationtracking
    owner to etluser;

create table if not exists staging_asc.leadgenerationtracking
(
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       bigint encode az64,
    prospectid                 bigint encode az64,
    fieldagentid               bigint encode az64,
    callcenteragentname        varchar(50),
    contactinfofk              bigint encode az64,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(64),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 5) encode az64,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.leadgenerationtracking
    owner to etluser;

create table if not exists integrated_asc.leadgenerationtracking
(
    dw_table_pk                bigint default "identity"(443407, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       bigint encode az64,
    prospectid                 bigint encode az64,
    fieldagentid               bigint encode az64,
    callcenteragentname        varchar(50),
    contactinfofk              bigint encode az64,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(64),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 5) encode az64,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.leadgenerationtracking
    owner to etluser;

grant select on integrated_asc.leadgenerationtracking to group named_user_ro;

create table if not exists landing_asc.scopeofappointment
(
    ascend_carrier_id    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    displayname          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    prospectid           bigint encode az64,
    requestedmeetingdate timestamp encode az64,
    statustypeid         double precision,
    creationdate         timestamp encode az64,
    statuschanged        timestamp,
    emailsent            timestamp encode az64,
    senton               timestamp encode az64,
    passcode             varchar(100),
    useragent            varchar(1024),
    ipaddress            varchar(50),
    notes                varchar(256),
    audituserid          double precision,
    paperscopefilename   varchar(500),
    reminderlastsent     timestamp encode az64,
    signaturetype        varchar(20),
    refresh_timestamp    timestamp encode az64
)
    sortkey (statuschanged);

alter table landing_asc.scopeofappointment
    owner to etluser;

create table if not exists staging_asc.scopeofappointment
(
    ascend_carrier_id     bigint encode az64,
    scopeofappointmentid  bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    displayname           bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64,
    prospectid            bigint encode az64,
    requestedmeetingdate  timestamp encode az64,
    statustypeid          bigint encode az64,
    creationdate          timestamp encode az64,
    statuschanged         timestamp encode az64,
    emailsent             timestamp encode az64,
    senton                timestamp encode az64,
    passcode              varchar(100),
    useragent             varchar(1024),
    ipaddress             varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64,
    paperscopefilename    varchar(500),
    reminderlastsent      timestamp encode az64,
    signaturetype         varchar(20),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.scopeofappointment
    owner to etluser;

create table if not exists integrated_asc.scopeofappointment
(
    dw_table_pk          bigint default "identity"(443449, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    displayname          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    prospectid           bigint encode az64,
    requestedmeetingdate timestamp encode az64,
    statustypeid         bigint encode az64,
    creationdate         timestamp encode az64,
    statuschanged        timestamp encode az64,
    emailsent            timestamp encode az64,
    senton               timestamp encode az64,
    passcode             varchar(100),
    useragent            varchar(1024),
    ipaddress            varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64,
    paperscopefilename   varchar(500),
    reminderlastsent     timestamp encode az64,
    signaturetype        varchar(20) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.scopeofappointment
    owner to etluser;

grant select on integrated_asc.scopeofappointment to group named_user_ro;

create table if not exists landing_asc.dispositiontypes_custom
(
    ascend_carrier_id bigint encode az64,
    dispositiontypeid bigint encode az64,
    businessentityid  bigint encode az64,
    code              varchar(50),
    description       varchar(50),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.dispositiontypes_custom
    owner to etluser;

create table if not exists staging_asc.dispositiontypes_custom
(
    ascend_carrier_id     bigint encode az64,
    dispositiontypeid     bigint encode az64,
    businessentityid      bigint encode az64,
    code                  varchar(50),
    description           varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositiontypes_custom
    owner to etluser;

create table if not exists integrated_asc.dispositiontypes_custom
(
    dw_table_pk          bigint default "identity"(443570, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    dispositiontypeid    bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(50),
    description          varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.dispositiontypes_custom
    owner to etluser;

grant select on integrated_asc.dispositiontypes_custom to group named_user_ro;

create table if not exists landing_asc.eventsprospectmap
(
    ascend_carrier_id  bigint encode az64,
    eventprospectmapid bigint distkey,
    eventid            bigint encode az64,
    prospectid         bigint encode az64,
    isdeleted          boolean,
    notes              varchar(500),
    audituserid        double precision,
    refresh_timestamp  timestamp encode az64
)
    sortkey (eventprospectmapid);

alter table landing_asc.eventsprospectmap
    owner to etluser;

create table if not exists staging_asc.eventsprospectmap
(
    ascend_carrier_id     bigint encode az64,
    eventprospectmapid    bigint encode az64,
    eventid               bigint encode az64,
    prospectid            bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventsprospectmap
    owner to etluser;

create table if not exists integrated_asc.eventsprospectmap
(
    dw_table_pk          bigint default "identity"(443582, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventprospectmapid   bigint encode az64,
    eventid              bigint encode az64,
    prospectid           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventsprospectmap
    owner to etluser;

grant select on integrated_asc.eventsprospectmap to group named_user_ro;

create table if not exists landing_asc.leadsviewrules
(
    ascend_carrier_id bigint encode az64,
    leadviewid        bigint encode az64,
    beid              double precision,
    name              varchar(50),
    rule              varchar(9216),
    xmlrule           varchar(9216),
    description       varchar(256),
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadsviewrules
    owner to etluser;

create table if not exists staging_asc.leadsviewrules
(
    ascend_carrier_id     bigint encode az64,
    leadviewid            bigint encode az64,
    beid                  bigint encode az64,
    name                  varchar(50),
    rule                  varchar(9216),
    xmlrule               varchar(9216),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadsviewrules
    owner to etluser;

create table if not exists integrated_asc.leadsviewrules
(
    dw_table_pk          bigint default "identity"(443652, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    leadviewid           bigint encode az64,
    beid                 bigint encode az64,
    name                 varchar(50),
    rule                 varchar(9216),
    xmlrule              varchar(9216),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadsviewrules
    owner to etluser;

grant select on integrated_asc.leadsviewrules to group named_user_ro;

create table if not exists landing_asc.eventsstatus_custom
(
    ascend_carrier_id bigint encode az64,
    eventstatusid     bigint encode az64,
    eventstatusname   varchar(100),
    beid              bigint encode az64,
    status            varchar(1),
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.eventsstatus_custom
    owner to etluser;

create table if not exists staging_asc.eventsstatus_custom
(
    ascend_carrier_id     bigint encode az64,
    eventstatusid         bigint encode az64,
    eventstatusname       varchar(100),
    beid                  bigint encode az64,
    status                varchar(1),
    notes                 varchar(500),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventsstatus_custom
    owner to etluser;

create table if not exists integrated_asc.eventsstatus_custom
(
    dw_table_pk          bigint default "identity"(443707, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventsstatus_custom
    owner to etluser;

grant select on integrated_asc.eventsstatus_custom to group named_user_ro;

create table if not exists landing_asc.isfawntype
(
    ascend_carrier_id bigint encode az64,
    isfawntypeid      bigint encode az64,
    beid              double precision,
    description       varchar(255),
    code              varchar(10),
    isdeleted         boolean,
    notes             varchar(255),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.isfawntype
    owner to etluser;

create table if not exists staging_asc.isfawntype
(
    ascend_carrier_id     bigint encode az64,
    isfawntypeid          bigint encode az64,
    beid                  bigint encode az64,
    description           varchar(255),
    code                  varchar(10),
    isdeleted             boolean,
    notes                 varchar(255),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.isfawntype
    owner to etluser;

create table if not exists integrated_asc.isfawntype
(
    dw_table_pk          bigint default "identity"(443721, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    isfawntypeid         bigint encode az64,
    beid                 bigint encode az64,
    description          varchar(255),
    code                 varchar(10),
    isdeleted            boolean,
    notes                varchar(255),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (refresh_timestamp);

alter table integrated_asc.isfawntype
    owner to etluser;

grant select on integrated_asc.isfawntype to group named_user_ro;

create table if not exists landing_asc.itemtype_custom
(
    ascend_carrier_id bigint encode az64,
    itemtypeid        bigint encode az64,
    beid              double precision,
    itemtype          varchar(50),
    itemtablename     varchar(50),
    isdeleted         boolean,
    notes             varchar(1000),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.itemtype_custom
    owner to etluser;

create table if not exists staging_asc.itemtype_custom
(
    ascend_carrier_id     bigint encode az64,
    itemtypeid            bigint encode az64,
    beid                  bigint encode az64,
    itemtype              varchar(50),
    itemtablename         varchar(50),
    isdeleted             boolean,
    notes                 varchar(1000),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.itemtype_custom
    owner to etluser;

create table if not exists integrated_asc.itemtype_custom
(
    dw_table_pk          bigint default "identity"(443764, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    itemtypeid           bigint encode az64,
    beid                 bigint encode az64,
    itemtype             varchar(50),
    itemtablename        varchar(50),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.itemtype_custom
    owner to etluser;

grant select on integrated_asc.itemtype_custom to group named_user_ro;

create table if not exists landing_asc.eventstype_custom
(
    ascend_carrier_id bigint encode az64,
    eventtypeid       bigint encode az64,
    eventtypename     varchar(100),
    beid              bigint encode az64,
    status            varchar(1),
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.eventstype_custom
    owner to etluser;

create table if not exists staging_asc.eventstype_custom
(
    ascend_carrier_id     bigint encode az64,
    eventtypeid           bigint encode az64,
    eventtypename         varchar(100),
    beid                  bigint encode az64,
    status                varchar(1),
    notes                 varchar(500),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventstype_custom
    owner to etluser;

create table if not exists integrated_asc.eventstype_custom
(
    dw_table_pk          bigint default "identity"(443800, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventtypeid          bigint encode az64,
    eventtypename        varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventstype_custom
    owner to etluser;

grant select on integrated_asc.eventstype_custom to group named_user_ro;

create table if not exists landing_asc.emailtemplatemerge_map
(
    ascend_carrier_id          bigint encode az64,
    emailtemplatemergeid       bigint encode az64,
    beid                       double precision,
    templateid                 varchar(100),
    agentfirstname             varchar(100),
    agentlastname              varchar(100),
    agentprimaryphone          varchar(100),
    agentcellphone             varchar(100),
    agentofficephone           varchar(100),
    agentenrollmentphone       varchar(100),
    agentemail                 varchar(100),
    agentaddress               varchar(100),
    agentcity                  varchar(100),
    agentstate                 varchar(100),
    agentzipcode               varchar(100),
    agentnpn                   varchar(100),
    agentawn                   varchar(100),
    prospectfirstname          varchar(100),
    prospectlastname           varchar(100),
    prospectemail              varchar(100),
    prospectphonenumber        varchar(100),
    prospectaddress            varchar(100),
    prospectcity               varchar(100),
    prospectstate              varchar(100),
    prospectzipcode            varchar(100),
    prospectcounty             varchar(100),
    templatetype               varchar(50),
    responsetype               varchar(50),
    respondtoagent             boolean,
    respondtootheremail        boolean,
    respondtootheremailaddress varchar(50),
    fromname                   varchar(100),
    isdeleted                  boolean,
    notes                      varchar(256),
    audituserid                double precision,
    refresh_timestamp          timestamp encode az64
);

alter table landing_asc.emailtemplatemerge_map
    owner to etluser;

create table if not exists staging_asc.emailtemplatemerge_map
(
    ascend_carrier_id          bigint encode az64,
    emailtemplatemergeid       bigint encode az64,
    beid                       bigint encode az64,
    templateid                 varchar(100),
    agentfirstname             varchar(100),
    agentlastname              varchar(100),
    agentprimaryphone          varchar(100),
    agentcellphone             varchar(100),
    agentofficephone           varchar(100),
    agentenrollmentphone       varchar(100),
    agentemail                 varchar(100),
    agentaddress               varchar(100),
    agentcity                  varchar(100),
    agentstate                 varchar(100),
    agentzipcode               varchar(100),
    agentnpn                   varchar(100),
    agentawn                   varchar(100),
    prospectfirstname          varchar(100),
    prospectlastname           varchar(100),
    prospectemail              varchar(100),
    prospectphonenumber        varchar(100),
    prospectaddress            varchar(100),
    prospectcity               varchar(100),
    prospectstate              varchar(100),
    prospectzipcode            varchar(100),
    prospectcounty             varchar(100),
    templatetype               varchar(50),
    responsetype               varchar(50),
    respondtoagent             boolean,
    respondtootheremail        boolean,
    respondtootheremailaddress varchar(50),
    fromname                   varchar(100),
    isdeleted                  boolean,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.emailtemplatemerge_map
    owner to etluser;

create table if not exists integrated_asc.emailtemplatemerge_map
(
    dw_table_pk                bigint default "identity"(443812, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    emailtemplatemergeid       bigint encode az64,
    beid                       bigint encode az64,
    templateid                 varchar(100),
    agentfirstname             varchar(100),
    agentlastname              varchar(100),
    agentprimaryphone          varchar(100),
    agentcellphone             varchar(100),
    agentofficephone           varchar(100),
    agentenrollmentphone       varchar(100),
    agentemail                 varchar(100),
    agentaddress               varchar(100),
    agentcity                  varchar(100),
    agentstate                 varchar(100),
    agentzipcode               varchar(100),
    agentnpn                   varchar(100),
    agentawn                   varchar(100),
    prospectfirstname          varchar(100),
    prospectlastname           varchar(100),
    prospectemail              varchar(100),
    prospectphonenumber        varchar(100),
    prospectaddress            varchar(100),
    prospectcity               varchar(100),
    prospectstate              varchar(100),
    prospectzipcode            varchar(100),
    prospectcounty             varchar(100),
    templatetype               varchar(50),
    responsetype               varchar(50),
    respondtoagent             boolean,
    respondtootheremail        boolean,
    respondtootheremailaddress varchar(50),
    fromname                   varchar(100),
    isdeleted                  boolean,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.emailtemplatemerge_map
    owner to etluser;

grant select on integrated_asc.emailtemplatemerge_map to group named_user_ro;

create table if not exists landing_asc.leadstatus_custom
(
    ascend_carrier_id bigint encode az64,
    statusid          bigint encode az64,
    businessentityid  double precision,
    leadstatus        varchar(300),
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.leadstatus_custom
    owner to etluser;

create table if not exists staging_asc.leadstatus_custom
(
    ascend_carrier_id     bigint encode az64,
    statusid              bigint encode az64,
    businessentityid      bigint encode az64,
    leadstatus            varchar(300),
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadstatus_custom
    owner to etluser;

create table if not exists integrated_asc.leadstatus_custom
(
    dw_table_pk          bigint default "identity"(443851, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    statusid             bigint encode az64,
    businessentityid     bigint encode az64,
    leadstatus           varchar(300),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadstatus_custom
    owner to etluser;

grant select on integrated_asc.leadstatus_custom to group named_user_ro;

create table if not exists landing_asc.calltoleadmap
(
    ascend_carrier_id bigint encode az64,
    calltoleadmapid   bigint encode az64,
    callsid           double precision,
    leadid            double precision,
    businessentityid  double precision distkey,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (leadid);

alter table landing_asc.calltoleadmap
    owner to etluser;

create table if not exists staging_asc.calltoleadmap
(
    ascend_carrier_id     bigint encode az64,
    calltoleadmapid       bigint encode az64,
    callsid               bigint encode az64,
    leadid                bigint encode az64,
    businessentityid      bigint encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.calltoleadmap
    owner to etluser;

create table if not exists integrated_asc.calltoleadmap
(
    dw_table_pk          bigint default "identity"(443908, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    calltoleadmapid      bigint encode az64,
    callsid              bigint encode az64,
    leadid               bigint encode az64,
    businessentityid     bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.calltoleadmap
    owner to etluser;

grant select on integrated_asc.calltoleadmap to group named_user_ro;

create table if not exists landing_asc.appointmenttagsmap
(
    ascend_carrier_id    bigint encode az64 distkey,
    appointmenttagsmapid bigint,
    beid                 double precision,
    apptid               double precision,
    tagid                double precision,
    notes                varchar(500),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
)
    sortkey (appointmenttagsmapid);

alter table landing_asc.appointmenttagsmap
    owner to etluser;

create table if not exists staging_asc.appointmenttagsmap
(
    ascend_carrier_id     bigint encode az64,
    appointmenttagsmapid  bigint encode az64,
    beid                  bigint encode az64,
    apptid                bigint encode az64,
    tagid                 bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.appointmenttagsmap
    owner to etluser;

create table if not exists integrated_asc.appointmenttagsmap
(
    dw_table_pk          bigint default "identity"(445701, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    appointmenttagsmapid bigint encode az64,
    beid                 bigint encode az64,
    apptid               bigint encode az64,
    tagid                bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.appointmenttagsmap
    owner to etluser;

grant select on integrated_asc.appointmenttagsmap to group named_user_ro;

create table if not exists landing_asc.eventsstatus
(
    ascend_carrier_id bigint encode az64,
    eventstatusid     bigint encode az64,
    eventstatusname   varchar(100),
    beid              double precision,
    isdeleted         bigint encode az64,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.eventsstatus
    owner to etluser;

create table if not exists staging_asc.eventsstatus
(
    ascend_carrier_id     bigint encode az64,
    eventstatusid         bigint encode az64,
    eventstatusname       varchar(100),
    beid                  bigint encode az64,
    isdeleted             bigint encode az64,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.eventsstatus
    owner to etluser;

create table if not exists integrated_asc.eventsstatus
(
    dw_table_pk          bigint default "identity"(445738, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    isdeleted            bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.eventsstatus
    owner to etluser;

grant select on integrated_asc.eventsstatus to group named_user_ro;

create table if not exists landing_asc.tags
(
    ascend_carrier_id bigint encode az64,
    tagid             bigint encode az64,
    tagname           varchar(500),
    beid              double precision,
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.tags
    owner to etluser;

create table if not exists staging_asc.tags
(
    ascend_carrier_id     bigint encode az64,
    tagid                 bigint encode az64,
    tagname               varchar(500),
    beid                  bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.tags
    owner to etluser;

create table if not exists integrated_asc.tags
(
    dw_table_pk          bigint default "identity"(445829, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    tagid                bigint encode az64,
    tagname              varchar(500),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.tags
    owner to etluser;

grant select on integrated_asc.tags to group named_user_ro;

create table if not exists landing_asc.regiongroupmap
(
    ascend_carrier_id bigint encode az64,
    regiongroupmapid  bigint encode az64,
    regionid          bigint encode az64,
    groupid           bigint encode az64,
    isdeleted         boolean,
    notes             varchar(500),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.regiongroupmap
    owner to etluser;

create table if not exists staging_asc.regiongroupmap
(
    ascend_carrier_id     bigint encode az64,
    regiongroupmapid      bigint encode az64,
    regionid              bigint encode az64,
    groupid               bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(500),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.regiongroupmap
    owner to etluser;

create table if not exists integrated_asc.regiongroupmap
(
    dw_table_pk          bigint default "identity"(445874, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    regiongroupmapid     bigint encode az64,
    regionid             bigint encode az64,
    groupid              bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.regiongroupmap
    owner to etluser;

grant select on integrated_asc.regiongroupmap to group named_user_ro;

create table if not exists landing_asc.meetings
(
    ascend_carrier_id          bigint encode az64,
    meetinghistoryid           bigint encode az64,
    beid                       bigint encode az64,
    userid                     bigint encode az64 distkey,
    token                      varchar(100),
    isrecorded                 boolean,
    address                    varchar(100),
    city                       varchar(100),
    state                      varchar(50),
    zipcode                    varchar(50),
    latitude                   varchar(50),
    longitude                  varchar(50),
    startdatetime              timestamp encode az64,
    enddatetime                timestamp,
    disposition                double precision,
    dispositiontype            double precision,
    filename                   varchar(50),
    checksum                   varchar(50),
    filesize                   varchar(50),
    isrecordinguploaded        boolean,
    soaid                      varchar(125),
    notes                      varchar(256),
    audituserid                double precision,
    transcriptionrequestid     varchar(50),
    transcriptionrequeststatus varchar(50),
    refresh_timestamp          timestamp encode az64
)
    sortkey (enddatetime);

alter table landing_asc.meetings
    owner to etluser;

create table if not exists staging_asc.meetings
(
    ascend_carrier_id          bigint encode az64,
    meetinghistoryid           bigint encode az64,
    beid                       bigint encode az64,
    userid                     bigint encode az64 distkey,
    token                      varchar(100),
    isrecorded                 boolean,
    address                    varchar(100),
    city                       varchar(100),
    state                      varchar(50),
    zipcode                    varchar(50),
    latitude                   varchar(50),
    longitude                  varchar(50),
    startdatetime              timestamp encode az64,
    enddatetime                timestamp encode az64,
    disposition                bigint encode az64,
    dispositiontype            bigint encode az64,
    filename                   varchar(50),
    checksum                   varchar(50),
    filesize                   varchar(50),
    isrecordinguploaded        boolean,
    soaid                      varchar(125),
    notes                      varchar(256),
    audituserid                bigint encode az64,
    transcriptionrequestid     varchar(50),
    transcriptionrequeststatus varchar(50),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char default 'N'::bpchar,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.meetings
    owner to etluser;

create table if not exists integrated_asc.meetings
(
    dw_table_pk                bigint default "identity"(445925, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    meetinghistoryid           bigint encode az64,
    beid                       bigint encode az64,
    userid                     bigint encode az64 distkey,
    token                      varchar(100),
    isrecorded                 boolean,
    address                    varchar(100),
    city                       varchar(100),
    state                      varchar(50) encode bytedict,
    zipcode                    varchar(50),
    latitude                   varchar(50),
    longitude                  varchar(50),
    startdatetime              timestamp encode az64,
    enddatetime                timestamp encode az64,
    disposition                bigint encode az64,
    dispositiontype            bigint encode az64,
    filename                   varchar(50),
    checksum                   varchar(50),
    filesize                   varchar(50),
    isrecordinguploaded        boolean,
    soaid                      varchar(125),
    notes                      varchar(256) encode bytedict,
    audituserid                bigint encode az64,
    transcriptionrequestid     varchar(50),
    transcriptionrequeststatus varchar(50),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.meetings
    owner to etluser;

grant select on integrated_asc.meetings to group named_user_ro;

create table if not exists landing_asc.eventsduration_custom
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            double precision,
    refresh_timestamp      timestamp encode az64
);

alter table landing_asc.eventsduration_custom
    owner to etluser;

create table if not exists staging_asc.eventsduration_custom
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.eventsduration_custom
    owner to etluser;

create table if not exists integrated_asc.eventsduration_custom
(
    dw_table_pk            bigint default "identity"(446014, 0, '0,1'::text) encode az64,
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.eventsduration_custom
    owner to etluser;

grant select on integrated_asc.eventsduration_custom to group named_user_ro;

create table if not exists landing_asc.eventsduration_base
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            double precision,
    refresh_timestamp      timestamp encode az64
);

alter table landing_asc.eventsduration_base
    owner to etluser;

create table if not exists staging_asc.eventsduration_base
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.eventsduration_base
    owner to etluser;

create table if not exists integrated_asc.eventsduration_base
(
    dw_table_pk            bigint default "identity"(446028, 0, '0,1'::text) encode az64,
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.eventsduration_base
    owner to etluser;

grant select on integrated_asc.eventsduration_base to group named_user_ro;

create table if not exists landing_asc.itemtype_base
(
    ascend_carrier_id bigint encode az64,
    itemtypeid        bigint encode az64,
    beid              double precision,
    itemtype          varchar(50),
    itemtablename     varchar(50),
    isdeleted         boolean,
    notes             varchar(1000),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
);

alter table landing_asc.itemtype_base
    owner to etluser;

create table if not exists staging_asc.itemtype_base
(
    ascend_carrier_id     bigint encode az64,
    itemtypeid            bigint encode az64,
    beid                  bigint encode az64,
    itemtype              varchar(50),
    itemtablename         varchar(50),
    isdeleted             boolean,
    notes                 varchar(1000),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.itemtype_base
    owner to etluser;

create table if not exists integrated_asc.itemtype_base
(
    dw_table_pk          bigint default "identity"(446049, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    itemtypeid           bigint encode az64,
    beid                 bigint encode az64,
    itemtype             varchar(50),
    itemtablename        varchar(50),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.itemtype_base
    owner to etluser;

grant select on integrated_asc.itemtype_base to group named_user_ro;

create table if not exists landing_asc.dispositiontypedisposition_map_base
(
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.dispositiontypedisposition_map_base
    owner to etluser;

create table if not exists staging_asc.dispositiontypedisposition_map_base
(
    ascend_carrier_id     bigint encode az64,
    dispositiontypemapid  bigint encode az64,
    typeid                bigint encode az64,
    dispositionid         bigint encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.dispositiontypedisposition_map_base
    owner to etluser;

create table if not exists integrated_asc.dispositiontypedisposition_map_base
(
    dw_table_pk          bigint default "identity"(446061, 0, '0,1'::text),
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    sortkey (dw_table_pk);

alter table integrated_asc.dispositiontypedisposition_map_base
    owner to etluser;

grant select on integrated_asc.dispositiontypedisposition_map_base to group named_user_ro;

create table if not exists landing_asc.leadcalls
(
    ascend_carrier_id bigint encode az64,
    callsid           bigint encode az64 distkey,
    pkcallresult      double precision,
    dispostring       varchar(100),
    agentname         varchar(100),
    calldate          timestamp,
    calltype          varchar(50),
    dnis              varchar(10),
    dnisdescription   varchar(300),
    dniscategory      varchar(300),
    origin            varchar(50),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (calldate);

alter table landing_asc.leadcalls
    owner to etluser;

create table if not exists staging_asc.leadcalls
(
    ascend_carrier_id     bigint encode az64,
    callsid               bigint encode az64,
    pkcallresult          bigint encode az64,
    dispostring           varchar(100),
    agentname             varchar(100),
    calldate              timestamp encode az64,
    calltype              varchar(50),
    dnis                  varchar(10),
    dnisdescription       varchar(300),
    dniscategory          varchar(300),
    origin                varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.leadcalls
    owner to etluser;

create table if not exists integrated_asc.leadcalls
(
    dw_table_pk          bigint default "identity"(446106, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    callsid              bigint encode az64,
    pkcallresult         bigint encode az64,
    dispostring          varchar(100),
    agentname            varchar(100),
    calldate             timestamp encode az64,
    calltype             varchar(50),
    dnis                 varchar(10),
    dnisdescription      varchar(300),
    dniscategory         varchar(300),
    origin               varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.leadcalls
    owner to etluser;

grant select on integrated_asc.leadcalls to group named_user_ro;

create table if not exists landing_asc.appointments
(
    ascend_carrier_id  bigint encode az64,
    apptid             bigint encode az64 distkey,
    beid               double precision,
    appttypeid         double precision,
    description        varchar(100),
    location           varchar(200),
    date_time          timestamp,
    address            varchar(100),
    city               varchar(50),
    state              varchar(2),
    zip                varchar(5),
    phone              varchar(10),
    website            varchar(256),
    capacity           double precision,
    zoneid             double precision,
    seatstaken         double precision,
    cancelled          boolean,
    notes              varchar(150),
    audituserid        double precision,
    isprivate          boolean,
    imagelocation      varchar(500),
    reservedseats      double precision,
    virtualmeetinglink varchar(256),
    refresh_timestamp  timestamp encode az64
)
    sortkey (date_time);

alter table landing_asc.appointments
    owner to etluser;

create table if not exists staging_asc.appointments
(
    ascend_carrier_id     bigint encode az64,
    apptid                bigint encode az64,
    beid                  bigint encode az64,
    appttypeid            bigint encode az64,
    description           varchar(100),
    location              varchar(200),
    date_time             timestamp encode az64,
    address               varchar(100),
    city                  varchar(50),
    state                 varchar(2),
    zip                   varchar(5),
    phone                 varchar(10),
    website               varchar(256),
    capacity              bigint encode az64,
    zoneid                bigint encode az64,
    seatstaken            bigint encode az64,
    cancelled             boolean,
    notes                 varchar(150),
    audituserid           bigint encode az64 distkey,
    isprivate             boolean,
    imagelocation         varchar(500),
    reservedseats         bigint encode az64,
    virtualmeetinglink    varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.appointments
    owner to etluser;

create table if not exists integrated_asc.appointments
(
    dw_table_pk          bigint default "identity"(446130, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    apptid               bigint encode az64,
    beid                 bigint encode az64,
    appttypeid           bigint encode az64,
    description          varchar(100),
    location             varchar(200),
    date_time            timestamp encode az64,
    address              varchar(100),
    city                 varchar(50),
    state                varchar(2),
    zip                  varchar(5),
    phone                varchar(10),
    website              varchar(256),
    capacity             bigint encode az64,
    zoneid               bigint encode az64,
    seatstaken           bigint encode az64,
    cancelled            boolean,
    notes                varchar(150),
    audituserid          bigint encode az64 distkey,
    isprivate            boolean,
    imagelocation        varchar(500),
    reservedseats        bigint encode az64,
    virtualmeetinglink   varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.appointments
    owner to etluser;

grant select on integrated_asc.appointments to group named_user_ro;

create table if not exists landing_asc.hvappointmentmeetingmap
(
    ascend_carrier_id         bigint encode az64,
    hvappointmentmeetingmapid bigint,
    hvappointmentid           bigint encode az64,
    meetinghistoryid          bigint encode az64 distkey,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               double precision,
    refresh_timestamp         timestamp encode az64
)
    sortkey (hvappointmentmeetingmapid);

alter table landing_asc.hvappointmentmeetingmap
    owner to etluser;

create table if not exists staging_asc.hvappointmentmeetingmap
(
    ascend_carrier_id         bigint encode az64,
    hvappointmentmeetingmapid bigint encode az64,
    hvappointmentid           bigint encode az64,
    meetinghistoryid          bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_action_indicator     char default 'N'::bpchar,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table staging_asc.hvappointmentmeetingmap
    owner to etluser;

create table if not exists integrated_asc.hvappointmentmeetingmap
(
    dw_table_pk               bigint default "identity"(446198, 0, '0,1'::text) encode az64,
    ascend_carrier_id         bigint encode az64,
    hvappointmentmeetingmapid bigint encode az64,
    hvappointmentid           bigint encode az64,
    meetinghistoryid          bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32)
);

alter table integrated_asc.hvappointmentmeetingmap
    owner to etluser;

grant select on integrated_asc.hvappointmentmeetingmap to group named_user_ro;

create table if not exists landing_asc.isfenrollmenthistory
(
    ascend_carrier_id      bigint encode az64,
    isfenrollmenthistoryid bigint encode az64 distkey,
    beid                   double precision,
    leadid                 double precision,
    confirmationnumber     varchar(50),
    meetingid              double precision,
    planname               varchar(100),
    premiumvalue           varchar(50),
    datecreated            timestamp,
    notes                  varchar(500),
    audituserid            double precision,
    refresh_timestamp      timestamp encode az64
)
    sortkey (datecreated);

alter table landing_asc.isfenrollmenthistory
    owner to etluser;

create table if not exists staging_asc.isfenrollmenthistory
(
    ascend_carrier_id      bigint encode az64,
    isfenrollmenthistoryid bigint encode az64 distkey,
    beid                   bigint encode az64,
    leadid                 bigint encode az64,
    confirmationnumber     varchar(50),
    meetingid              bigint encode az64,
    planname               varchar(100),
    premiumvalue           varchar(50),
    datecreated            timestamp encode az64,
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char default 'N'::bpchar,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_asc.isfenrollmenthistory
    owner to etluser;

create table if not exists integrated_asc.isfenrollmenthistory
(
    dw_table_pk            bigint default "identity"(446249, 0, '0,1'::text) encode az64,
    ascend_carrier_id      bigint encode az64,
    isfenrollmenthistoryid bigint encode az64 distkey,
    beid                   bigint encode az64,
    leadid                 bigint encode az64,
    confirmationnumber     varchar(50),
    meetingid              bigint encode az64,
    planname               varchar(100),
    premiumvalue           varchar(50),
    datecreated            timestamp encode az64,
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_asc.isfenrollmenthistory
    owner to etluser;

grant select on integrated_asc.isfenrollmenthistory to group named_user_ro;

create table if not exists landing_asc.appointmentuser_map
(
    ascend_carrier_id bigint encode az64,
    mapapptuserid     bigint encode az64 distkey,
    businessentityid  double precision,
    apptid            bigint encode az64,
    userid            double precision,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp
)
    sortkey (refresh_timestamp);

alter table landing_asc.appointmentuser_map
    owner to etluser;

create table if not exists staging_asc.appointmentuser_map
(
    ascend_carrier_id     bigint encode az64,
    mapapptuserid         bigint encode az64 distkey,
    businessentityid      bigint encode az64,
    apptid                bigint encode az64,
    userid                bigint encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.appointmentuser_map
    owner to etluser;

create table if not exists integrated_asc.appointmentuser_map
(
    dw_table_pk          bigint default "identity"(446321, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    mapapptuserid        bigint encode az64 distkey,
    businessentityid     bigint encode az64,
    apptid               bigint encode az64,
    userid               bigint encode az64,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.appointmentuser_map
    owner to etluser;

grant select on integrated_asc.appointmentuser_map to group named_user_ro;

create table if not exists landing_asc.messageuser_map
(
    ascend_carrier_id bigint encode az64,
    mapmessageuserid  bigint encode az64 distkey,
    userid            bigint encode az64,
    messageid         bigint,
    businessentityid  double precision,
    requireack        boolean,
    userack           boolean,
    timeacknowlwdged  timestamp encode az64,
    messagedelivered  boolean,
    messagereceived   boolean,
    isdeleted         boolean,
    notes             varchar(256),
    audituserid       double precision,
    groupid           double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (messageid);

alter table landing_asc.messageuser_map
    owner to etluser;

create table if not exists staging_asc.messageuser_map
(
    ascend_carrier_id     bigint encode az64,
    mapmessageuserid      bigint encode az64 distkey,
    userid                bigint encode az64,
    messageid             bigint encode az64,
    businessentityid      bigint encode az64,
    requireack            boolean,
    userack               boolean,
    timeacknowlwdged      timestamp encode az64,
    messagedelivered      boolean,
    messagereceived       boolean,
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    groupid               bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.messageuser_map
    owner to etluser;

create table if not exists integrated_asc.messageuser_map
(
    dw_table_pk          bigint default "identity"(446362, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    mapmessageuserid     bigint encode az64 distkey,
    userid               bigint encode az64,
    messageid            bigint encode az64,
    businessentityid     bigint encode az64,
    requireack           boolean,
    userack              boolean,
    timeacknowlwdged     timestamp encode az64,
    messagedelivered     boolean,
    messagereceived      boolean,
    isdeleted            boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    groupid              bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.messageuser_map
    owner to etluser;

grant select on integrated_asc.messageuser_map to group named_user_ro;

create table if not exists landing_asc.userrole_map
(
    ascend_carrier_id bigint encode az64,
    mapuserroleid     bigint,
    carrierid         double precision,
    businessentityid  double precision,
    userid            bigint encode az64 distkey,
    roleid            bigint encode az64,
    rolecode          varchar(50),
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    sortkey (mapuserroleid);

alter table landing_asc.userrole_map
    owner to etluser;

create table if not exists staging_asc.userrole_map
(
    ascend_carrier_id     bigint encode az64,
    mapuserroleid         bigint encode az64,
    carrierid             bigint encode az64,
    businessentityid      bigint encode az64,
    userid                bigint encode az64 distkey,
    roleid                bigint encode az64,
    rolecode              varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.userrole_map
    owner to etluser;

create table if not exists integrated_asc.userrole_map
(
    dw_table_pk          bigint default "identity"(446434, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    mapuserroleid        bigint encode az64,
    carrierid            bigint encode az64,
    businessentityid     bigint encode az64,
    userid               bigint encode az64 distkey,
    roleid               bigint encode az64,
    rolecode             varchar(50),
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.userrole_map
    owner to etluser;

grant select on integrated_asc.userrole_map to group named_user_ro;

create table if not exists landing_asc.usergroup_map
(
    ascend_carrier_id bigint encode az64,
    mapusergroupid    bigint distkey,
    userid            bigint encode az64,
    businessentityid  double precision,
    groupid           bigint encode az64,
    groupcode         varchar(50),
    isowner           boolean,
    notes             varchar(256),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    diststyle key
    sortkey (mapusergroupid);

alter table landing_asc.usergroup_map
    owner to etluser;

create table if not exists staging_asc.usergroup_map
(
    ascend_carrier_id     bigint encode az64,
    mapusergroupid        bigint encode az64,
    userid                bigint encode az64 distkey,
    businessentityid      bigint encode az64,
    groupid               bigint encode az64,
    groupcode             varchar(50),
    isowner               boolean,
    notes                 varchar(256) encode bytedict,
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.usergroup_map
    owner to etluser;

create table if not exists integrated_asc.usergroup_map
(
    dw_table_pk          bigint default "identity"(446484, 0, '0,1'::text),
    ascend_carrier_id    bigint encode az64,
    mapusergroupid       bigint encode az64 distkey,
    userid               bigint encode az64,
    businessentityid     bigint encode az64,
    groupid              bigint encode az64,
    groupcode            varchar(50),
    isowner              boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (dw_table_pk);

alter table integrated_asc.usergroup_map
    owner to etluser;

grant select on integrated_asc.usergroup_map to group named_user_ro;

create table if not exists landing_asc.isfuserawn_map
(
    ascend_carrier_id bigint encode az64,
    isfuserawnid      bigint encode az64 distkey,
    beid              double precision,
    userid            double precision,
    awn               varchar(20),
    isfawntype        double precision,
    isdeleted         boolean,
    notes             varchar(255),
    audituserid       double precision,
    refresh_timestamp timestamp encode az64
)
    diststyle key
    sortkey (userid);

alter table landing_asc.isfuserawn_map
    owner to etluser;

create table if not exists staging_asc.isfuserawn_map
(
    ascend_carrier_id     bigint encode az64,
    isfuserawnid          bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64 distkey,
    awn                   varchar(20),
    isfawntype            bigint encode az64,
    isdeleted             boolean,
    notes                 varchar(255),
    audituserid           bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.isfuserawn_map
    owner to etluser;

create table if not exists integrated_asc.isfuserawn_map
(
    dw_table_pk          bigint default "identity"(446543, 0, '0,1'::text),
    ascend_carrier_id    bigint encode az64,
    isfuserawnid         bigint encode az64 distkey,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    awn                  varchar(20),
    isfawntype           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(255) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key
    sortkey (dw_table_pk);

alter table integrated_asc.isfuserawn_map
    owner to etluser;

grant select on integrated_asc.isfuserawn_map to group named_user_ro;

create table if not exists landing_asc.formsubmission
(
    ascend_carrier_id bigint encode az64,
    formsubmissionid  bigint distkey,
    formid            bigint encode az64,
    useragent         varchar(256),
    ipaddress         varchar(50),
    ispartial         boolean,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
)
    sortkey (formsubmissionid);

alter table landing_asc.formsubmission
    owner to etluser;

create table if not exists staging_asc.formsubmission
(
    ascend_carrier_id     bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    formid                bigint encode az64,
    useragent             varchar(256),
    ipaddress             varchar(50),
    ispartial             boolean,
    notes                 varchar(256) encode bytedict,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.formsubmission
    owner to etluser;

create table if not exists integrated_asc.formsubmission
(
    dw_table_pk          bigint default "identity"(446622, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    formid               bigint encode az64,
    useragent            varchar(256),
    ipaddress            varchar(50),
    ispartial            boolean,
    notes                varchar(256) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.formsubmission
    owner to etluser;

grant select on integrated_asc.formsubmission to group named_user_ro;

create table if not exists landing_asc.formsubmissiondata
(
    ascend_carrier_id    bigint encode az64,
    formsubmissiondataid bigint encode az64 distkey,
    formsubmissionid     bigint,
    formpageelementmapid bigint encode az64,
    value                varchar(8192),
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64
)
    sortkey (formsubmissionid);

alter table landing_asc.formsubmissiondata
    owner to etluser;

create table if not exists staging_asc.formsubmissiondata
(
    ascend_carrier_id     bigint encode az64,
    formsubmissiondataid  bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    formpageelementmapid  bigint encode az64,
    value                 varchar(8192),
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.formsubmissiondata
    owner to etluser;

create table if not exists integrated_asc.formsubmissiondata
(
    dw_table_pk          bigint default "identity"(446652, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    formsubmissiondataid bigint encode az64 distkey,
    formsubmissionid     bigint encode az64,
    formpageelementmapid bigint encode az64,
    value                varchar(8192),
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.formsubmissiondata
    owner to etluser;

grant select on integrated_asc.formsubmissiondata to group named_user_ro;

create table if not exists landing_asc.permissionlead_map
(
    ascend_carrier_id bigint encode az64,
    id                bigint encode az64 distkey,
    beid              bigint encode az64,
    leadid            bigint,
    permissionid      bigint encode az64,
    audituserid       double precision,
    notes             varchar(256),
    refresh_timestamp timestamp encode az64
)
    sortkey (leadid);

alter table landing_asc.permissionlead_map
    owner to etluser;

create table if not exists staging_asc.permissionlead_map
(
    ascend_carrier_id     bigint encode az64,
    id                    bigint encode az64,
    beid                  bigint encode az64,
    leadid                bigint encode az64,
    permissionid          bigint encode az64,
    audituserid           bigint encode az64 distkey,
    notes                 varchar(256) encode bytedict,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char default 'N'::bpchar,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.permissionlead_map
    owner to etluser;

create table if not exists integrated_asc.permissionlead_map
(
    dw_table_pk          bigint default "identity"(446752, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    id                   bigint encode az64 distkey,
    beid                 bigint encode az64,
    leadid               bigint encode az64,
    permissionid         bigint encode az64,
    audituserid          bigint encode az64,
    notes                varchar(256) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key;

alter table integrated_asc.permissionlead_map
    owner to etluser;

grant select on integrated_asc.permissionlead_map to group named_user_ro;

create table if not exists landing_asc.audit_businessentities
(
    businessentityid     bigint distkey,
    carrierid            bigint encode az64,
    businessentityname   varchar(100),
    spacequota           double precision,
    servername           varchar(50),
    serverusername       varchar(50),
    authenticationkey    varchar(3000),
    pointofcontact       varchar(100),
    documentroot         varchar(100),
    recordingroot        varchar(100),
    recordingmeth        varchar(50),
    paperscoperoot       varchar(100),
    pushnotificationpath varchar(50),
    pushcertpassword     varchar(50),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          double precision,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64
)
    sortkey (businessentityid);

alter table landing_asc.audit_businessentities
    owner to etluser;

create table if not exists staging_asc.audit_businessentities
(
    businessentityid      bigint encode az64,
    carrierid             bigint encode az64,
    businessentityname    varchar(100),
    spacequota            bigint encode az64,
    servername            varchar(50),
    serverusername        varchar(50),
    authenticationkey     varchar(3000),
    pointofcontact        varchar(100),
    documentroot          varchar(100),
    recordingroot         varchar(100),
    recordingmeth         varchar(50),
    paperscoperoot        varchar(100),
    pushnotificationpath  varchar(50),
    pushcertpassword      varchar(50),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_businessentities
    owner to etluser;

create table if not exists integrated_asc.audit_businessentities
(
    dw_table_pk          bigint default "identity"(497397, 0, '0,1'::text) encode az64,
    businessentityid     bigint encode az64,
    carrierid            bigint encode az64,
    businessentityname   varchar(100),
    spacequota           bigint encode az64,
    servername           varchar(50),
    serverusername       varchar(50),
    authenticationkey    varchar(3000),
    pointofcontact       varchar(100),
    documentroot         varchar(100),
    recordingroot        varchar(100),
    recordingmeth        varchar(50),
    paperscoperoot       varchar(100),
    pushnotificationpath varchar(50),
    pushcertpassword     varchar(50),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_businessentities
    owner to etluser;

grant select on integrated_asc.audit_businessentities to group named_user_ro;

create table if not exists landing_asc.audit_users
(
    userid            bigint distkey,
    loginname         varchar(500),
    password          varchar(150),
    salt              varchar(50),
    fname             varchar(50),
    lname             varchar(50),
    datepwdchange     timestamp encode az64,
    natpronum         varchar(10),
    locked            boolean,
    notes             varchar(256),
    audituserid       double precision,
    auditdatastate    varchar(10),
    auditdmlaction    varchar(10),
    auditdatetime     timestamp encode az64,
    uniquekey         varchar(40),
    hash              varchar(10),
    truesalt          varchar(10),
    userversion       double precision,
    useriterations    double precision,
    apiversion        double precision,
    apiiterations     double precision,
    lockendtime       timestamp encode az64,
    refresh_timestamp timestamp encode az64
)
    sortkey (userid);

alter table landing_asc.audit_users
    owner to etluser;

create table if not exists staging_asc.audit_users
(
    userid                bigint encode az64 distkey,
    loginname             varchar(500),
    password              varchar(150),
    salt                  varchar(50),
    fname                 varchar(50),
    lname                 varchar(50),
    datepwdchange         timestamp encode az64,
    natpronum             varchar(10),
    locked                boolean,
    notes                 varchar(256) encode bytedict,
    audituserid           bigint encode az64,
    auditdatastate        varchar(10) encode bytedict,
    auditdmlaction        varchar(10) encode bytedict,
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    hash                  varchar(10),
    truesalt              varchar(10),
    userversion           bigint encode az64,
    useriterations        bigint encode az64,
    apiversion            bigint encode az64,
    apiiterations         bigint encode az64,
    lockendtime           timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_users
    owner to etluser;

create table if not exists integrated_asc.audit_users
(
    dw_table_pk          bigint default "identity"(497436, 0, '0,1'::text) encode az64,
    userid               bigint encode az64 distkey,
    loginname            varchar(500),
    password             varchar(150),
    salt                 varchar(50),
    fname                varchar(50),
    lname                varchar(50),
    datepwdchange        timestamp encode az64,
    natpronum            varchar(10),
    locked               boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    hash                 varchar(10),
    truesalt             varchar(10),
    userversion          bigint encode az64,
    useriterations       bigint encode az64,
    apiversion           bigint encode az64,
    apiiterations        bigint encode az64,
    lockendtime          timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_users
    owner to etluser;

grant select on integrated_asc.audit_users to group named_user_ro;

create table if not exists landing_asc.audit_usersession
(
    usersessionid        bigint encode az64 distkey,
    userid               double precision,
    clientid             double precision,
    sessionstartdatetime timestamp encode az64,
    sessionenddatetime   timestamp encode az64,
    useragent            varchar(256),
    buildversion         varchar(50),
    osversion            varchar(50),
    ipaddress            varchar(50),
    iscellular           boolean,
    iswifi               boolean,
    devicetype           varchar(100),
    audituserid          double precision,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64
)
    sortkey (auditdatetime);

alter table landing_asc.audit_usersession
    owner to etluser;

create table if not exists staging_asc.audit_usersession
(
    usersessionid         bigint encode az64 distkey,
    userid                bigint encode az64,
    clientid              bigint encode az64,
    sessionstartdatetime  timestamp encode az64,
    sessionenddatetime    timestamp encode az64,
    useragent             varchar(256),
    buildversion          varchar(50),
    osversion             varchar(50),
    ipaddress             varchar(50),
    iscellular            boolean,
    iswifi                boolean,
    devicetype            varchar(100),
    audituserid           bigint encode az64,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_usersession
    owner to etluser;

create table if not exists integrated_asc.audit_usersession
(
    dw_table_pk          bigint default "identity"(497462, 0, '0,1'::text) encode az64,
    usersessionid        bigint encode az64 distkey,
    userid               bigint encode az64,
    clientid             bigint encode az64,
    sessionstartdatetime timestamp encode az64,
    sessionenddatetime   timestamp encode az64,
    useragent            varchar(256) encode bytedict,
    buildversion         varchar(50) encode bytedict,
    osversion            varchar(50) encode bytedict,
    ipaddress            varchar(50),
    iscellular           boolean,
    iswifi               boolean,
    devicetype           varchar(100),
    audituserid          bigint encode az64,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_usersession
    owner to etluser;

grant select on integrated_asc.audit_usersession to group named_user_ro;

create table if not exists landing_asc.audit_appointmentsubscription_map
(
    ascend_carrier_id   bigint encode az64,
    subscriptionid      bigint encode az64,
    businessentityid    double precision distkey,
    apptid              bigint encode az64,
    leadid              double precision,
    prospectid          double precision,
    generalseats        double precision,
    isactive            boolean,
    attendedappointment boolean,
    notes               varchar(256),
    audituserid         double precision,
    auditdatastate      varchar(10),
    auditdmlaction      varchar(10),
    auditdatetime       timestamp,
    uniquekey           varchar(40),
    passcode            varchar(100),
    refresh_timestamp   timestamp encode az64
)
    sortkey (auditdatetime);

alter table landing_asc.audit_appointmentsubscription_map
    owner to etluser;

create table if not exists staging_asc.audit_appointmentsubscription_map
(
    ascend_carrier_id     bigint encode az64,
    subscriptionid        bigint encode az64,
    businessentityid      bigint encode az64,
    apptid                bigint encode az64,
    leadid                bigint encode az64,
    prospectid            bigint encode az64,
    generalseats          bigint encode az64,
    isactive              boolean,
    attendedappointment   boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    passcode              varchar(100),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_appointmentsubscription_map
    owner to etluser;

create table if not exists integrated_asc.audit_appointmentsubscription_map
(
    dw_table_pk          bigint default "identity"(497499, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    subscriptionid       bigint encode az64,
    businessentityid     bigint encode az64,
    apptid               bigint encode az64,
    leadid               bigint encode az64,
    prospectid           bigint encode az64,
    generalseats         bigint encode az64,
    isactive             boolean,
    attendedappointment  boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    passcode             varchar(100),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_appointmentsubscription_map
    owner to etluser;

grant select on integrated_asc.audit_appointmentsubscription_map to group named_user_ro;

create table if not exists landing_asc.audit_availableagents
(
    ascend_carrier_id bigint encode az64 distkey,
    availableid       bigint encode az64,
    beid              double precision,
    userid            double precision,
    startdatetime     timestamp encode az64,
    enddatetime       timestamp encode az64,
    notes             varchar(256),
    audituserid       double precision,
    auditdatastate    varchar(10),
    auditdmlaction    varchar(10),
    sysuser           varchar(128),
    auditdatetime     timestamp,
    uniquekey         varchar(40),
    refresh_timestamp timestamp encode az64
)
    sortkey (auditdatetime);

alter table landing_asc.audit_availableagents
    owner to etluser;

create table if not exists staging_asc.audit_availableagents
(
    ascend_carrier_id     bigint encode az64,
    availableid           bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64 distkey,
    startdatetime         timestamp encode az64,
    enddatetime           timestamp encode az64,
    notes                 varchar(256),
    audituserid           bigint encode az64,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    sysuser               varchar(128),
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_availableagents
    owner to etluser;

create table if not exists integrated_asc.audit_availableagents
(
    dw_table_pk          bigint default "identity"(497588, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    availableid          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    sysuser              varchar(128),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_availableagents
    owner to etluser;

grant select on integrated_asc.audit_availableagents to group named_user_ro;

create table if not exists landing_asc.audit_documents
(
    ascend_carrier_id   bigint encode az64,
    documentid          bigint encode az64,
    businessentityid    bigint encode az64,
    documentname        varchar(100),
    publishdate         timestamp encode az64,
    expirydate          timestamp encode az64,
    createddate         timestamp encode az64,
    folderid            double precision,
    subfolderid         double precision,
    replacesdocumentid  double precision,
    documentpath        varchar(256),
    isdeleted           boolean,
    notes               varchar(256),
    audituserid         double precision,
    auditdatastate      varchar(10),
    auditdmlaction      varchar(10),
    sysuser             varchar(128),
    auditdatetime       timestamp encode az64,
    resourcetype        varchar(25),
    displayonhomescreen boolean,
    passauth            boolean,
    action              varchar(50),
    ranking             double precision,
    uniquekey           varchar(40),
    recipientcount      double precision,
    refresh_timestamp   timestamp encode az64
);

alter table landing_asc.audit_documents
    owner to etluser;

create table if not exists staging_asc.audit_documents
(
    ascend_carrier_id     bigint encode az64,
    documentid            bigint encode az64,
    businessentityid      bigint encode az64,
    documentname          varchar(100),
    publishdate           timestamp encode az64,
    expirydate            timestamp encode az64,
    createddate           timestamp encode az64,
    folderid              bigint encode az64,
    subfolderid           bigint encode az64,
    replacesdocumentid    bigint encode az64,
    documentpath          varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    audituserid           bigint encode az64 distkey,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    sysuser               varchar(128),
    auditdatetime         timestamp encode az64,
    resourcetype          varchar(25),
    displayonhomescreen   boolean,
    passauth              boolean,
    action                varchar(50),
    ranking               bigint encode az64,
    uniquekey             varchar(40),
    recipientcount        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_documents
    owner to etluser;

create table if not exists integrated_asc.audit_documents
(
    dw_table_pk          bigint default "identity"(497674, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    documentid           bigint encode az64,
    businessentityid     bigint encode az64,
    documentname         varchar(100),
    publishdate          timestamp encode az64,
    expirydate           timestamp encode az64,
    createddate          timestamp encode az64,
    folderid             bigint encode az64,
    subfolderid          bigint encode az64,
    replacesdocumentid   bigint encode az64,
    documentpath         varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    sysuser              varchar(128),
    auditdatetime        timestamp encode az64,
    resourcetype         varchar(25),
    displayonhomescreen  boolean,
    passauth             boolean,
    action               varchar(50),
    ranking              bigint encode az64,
    uniquekey            varchar(40),
    recipientcount       bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_documents
    owner to etluser;

grant select on integrated_asc.audit_documents to group named_user_ro;

create table if not exists landing_asc.audit_leadgenerationtracking
(
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       double precision,
    prospectid                 double precision,
    fieldagentid               double precision,
    callcenteragentname        varchar(50),
    contactinfofk              double precision,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(40),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 6) encode az64,
    notes                      varchar(256),
    audituserid                double precision,
    auditdatastate             varchar(10),
    auditdmlaction             varchar(10),
    sysuser                    varchar(128),
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    refresh_timestamp          timestamp encode az64
);

alter table landing_asc.audit_leadgenerationtracking
    owner to etluser;

create table if not exists staging_asc.audit_leadgenerationtracking
(
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       bigint encode az64,
    prospectid                 bigint encode az64,
    fieldagentid               bigint encode az64,
    callcenteragentname        varchar(50),
    contactinfofk              bigint encode az64,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(40),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 6) encode az64,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    auditdatastate             varchar(10),
    auditdmlaction             varchar(10),
    sysuser                    varchar(128),
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char    default 'N'::bpchar,
    processed_flag             boolean default false,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.audit_leadgenerationtracking
    owner to etluser;

create table if not exists integrated_asc.audit_leadgenerationtracking
(
    dw_table_pk                bigint default "identity"(497788, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       bigint encode az64,
    prospectid                 bigint encode az64,
    fieldagentid               bigint encode az64,
    callcenteragentname        varchar(50),
    contactinfofk              bigint encode az64,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(40),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 6) encode az64,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    auditdatastate             varchar(10),
    auditdmlaction             varchar(10),
    sysuser                    varchar(128),
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.audit_leadgenerationtracking
    owner to etluser;

grant select on integrated_asc.audit_leadgenerationtracking to group named_user_ro;

create table if not exists landing_asc.audit_meetingtoleadmap
(
    ascend_carrier_id    bigint encode az64,
    meetingtoleadmapid   bigint encode az64 distkey,
    beid                 double precision,
    meetingid            double precision,
    leadid               double precision,
    scopeofappointmentid varchar(100),
    bloomclientid        varchar(100),
    datetimeofmeeting    timestamp,
    notes                varchar(256),
    audituserid          double precision,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64
)
    sortkey (datetimeofmeeting);

alter table landing_asc.audit_meetingtoleadmap
    owner to etluser;

create table if not exists staging_asc.audit_meetingtoleadmap
(
    ascend_carrier_id     bigint encode az64,
    meetingtoleadmapid    bigint encode az64,
    beid                  bigint encode az64,
    meetingid             bigint encode az64,
    leadid                bigint encode az64,
    scopeofappointmentid  varchar(100),
    bloomclientid         varchar(100),
    datetimeofmeeting     timestamp encode az64,
    notes                 varchar(256) encode bytedict,
    audituserid           bigint encode az64 distkey,
    auditdatastate        varchar(10) encode bytedict,
    auditdmlaction        varchar(10) encode bytedict,
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_meetingtoleadmap
    owner to etluser;

create table if not exists integrated_asc.audit_meetingtoleadmap
(
    dw_table_pk          bigint default "identity"(497868, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    meetingtoleadmapid   bigint encode az64,
    beid                 bigint encode az64,
    meetingid            bigint encode az64,
    leadid               bigint encode az64,
    scopeofappointmentid varchar(100),
    bloomclientid        varchar(100),
    datetimeofmeeting    timestamp encode az64,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64 distkey,
    auditdatastate       varchar(10) encode bytedict,
    auditdmlaction       varchar(10) encode bytedict,
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_meetingtoleadmap
    owner to etluser;

grant select on integrated_asc.audit_meetingtoleadmap to group named_user_ro;

create table if not exists landing_asc.audit_prospects
(
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint distkey,
    beid                       double precision,
    meetingid                  double precision,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50),
    leadsourceid               double precision,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    double precision,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               double precision,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10),
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256),
    notes                      varchar(1024),
    audituserid                double precision,
    auditdatastate             varchar(10),
    auditdmlaction             varchar(10),
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64
)
    sortkey (prospectid);

alter table landing_asc.audit_prospects
    owner to etluser;

create table if not exists staging_asc.audit_prospects
(
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint encode az64,
    beid                       bigint encode az64,
    meetingid                  bigint encode az64,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50) encode bytedict,
    state                      varchar(2),
    zipcode                    varchar(16) encode bytedict,
    county                     varchar(50) encode bytedict,
    email                      varchar(150) encode bytedict,
    creationmethod             varchar(50) encode bytedict,
    leadsourceid               bigint encode az64,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    bigint encode az64,
    commission                 boolean,
    altexternalid              varchar(100) encode bytedict,
    leadstatusid               bigint encode az64,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10) encode bytedict,
    medicareclaimnumber        varchar(25) encode bytedict,
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256),
    notes                      varchar(1024),
    audituserid                bigint encode az64 distkey,
    auditdatastate             varchar(10),
    auditdmlaction             varchar(10),
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char    default 'N'::bpchar,
    processed_flag             boolean default false,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_asc.audit_prospects
    owner to etluser;

create table if not exists integrated_asc.audit_prospects
(
    dw_table_pk                bigint default "identity"(501299, 0, '0,1'::text) encode az64,
    ascend_carrier_id          bigint encode az64,
    prospectid                 bigint encode az64,
    beid                       bigint encode az64,
    meetingid                  bigint encode az64,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50) encode bytedict,
    leadsourceid               bigint encode az64,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    bigint encode az64,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               bigint encode az64,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10) encode bytedict,
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256) encode bytedict,
    notes                      varchar(1024),
    audituserid                bigint encode az64 distkey,
    auditdatastate             varchar(10) encode bytedict,
    auditdmlaction             varchar(10) encode bytedict,
    auditdatetime              timestamp encode az64,
    uniquekey                  varchar(40),
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_asc.audit_prospects
    owner to etluser;

grant select on integrated_asc.audit_prospects to group named_user_ro;

create table if not exists landing_asc.audit_scopeofappointment
(
    ascend_carrier_id    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    displayname          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    prospectid           bigint encode az64,
    requestedmeetingdate timestamp encode az64,
    statustypeid         double precision,
    creationdate         timestamp encode az64,
    statuschanged        timestamp encode az64,
    emailsent            timestamp encode az64,
    senton               timestamp encode az64,
    passcode             varchar(100),
    useragent            varchar(256),
    ipaddress            varchar(50),
    notes                varchar(256),
    audituserid          double precision,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp,
    paperscopefilename   varchar(500),
    uniquekey            varchar(40),
    reminderlastsent     timestamp encode az64,
    signaturetype        varchar(20),
    refresh_timestamp    timestamp encode az64
)
    sortkey (auditdatetime);

alter table landing_asc.audit_scopeofappointment
    owner to etluser;

create table if not exists staging_asc.audit_scopeofappointment
(
    ascend_carrier_id     bigint encode az64,
    scopeofappointmentid  bigint encode az64,
    formsubmissionid      bigint encode az64 distkey,
    displayname           bigint encode az64,
    beid                  bigint encode az64,
    userid                bigint encode az64,
    prospectid            bigint encode az64,
    requestedmeetingdate  timestamp encode az64,
    statustypeid          bigint encode az64,
    creationdate          timestamp encode az64,
    statuschanged         timestamp encode az64,
    emailsent             timestamp encode az64,
    senton                timestamp encode az64,
    passcode              varchar(100),
    useragent             varchar(256),
    ipaddress             varchar(50),
    notes                 varchar(256),
    audituserid           bigint encode az64,
    auditdatastate        varchar(10) encode bytedict,
    auditdmlaction        varchar(10) encode bytedict,
    auditdatetime         timestamp encode az64,
    paperscopefilename    varchar(500),
    uniquekey             varchar(40),
    reminderlastsent      timestamp encode az64,
    signaturetype         varchar(20),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_scopeofappointment
    owner to etluser;

create table if not exists integrated_asc.audit_scopeofappointment
(
    dw_table_pk          bigint default "identity"(501734, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    displayname          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    prospectid           bigint encode az64,
    requestedmeetingdate timestamp encode az64,
    statustypeid         bigint encode az64,
    creationdate         timestamp encode az64,
    statuschanged        timestamp encode az64,
    emailsent            timestamp encode az64,
    senton               timestamp encode az64,
    passcode             varchar(100),
    useragent            varchar(256),
    ipaddress            varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64,
    auditdatastate       varchar(10) encode bytedict,
    auditdmlaction       varchar(10) encode bytedict,
    auditdatetime        timestamp encode az64,
    paperscopefilename   varchar(500),
    uniquekey            varchar(40),
    reminderlastsent     timestamp encode az64,
    signaturetype        varchar(20),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_scopeofappointment
    owner to etluser;

grant select on integrated_asc.audit_scopeofappointment to group named_user_ro;

create table if not exists landing_asc.audit_userdetails
(
    ascend_carrier_id    bigint encode az64,
    userdetailsid        bigint encode az64,
    userid               bigint encode az64,
    beid                 bigint encode az64,
    primaryphone         varchar(15),
    officephone          varchar(15),
    homephone            varchar(15),
    mobilephone          varchar(15),
    fax                  varchar(15),
    address              varchar(50),
    city                 varchar(50),
    state                varchar(2),
    zipcode              varchar(5),
    extusername          varchar(150),
    extpassword          varchar(150),
    useenrollurl         boolean,
    leadgeneration       boolean,
    skilllevel           double precision,
    userurl              varchar(500),
    userate              boolean,
    enrollmentphone      varchar(20),
    contactnumbersid     varchar(50),
    natpronum            varchar(10),
    notes                varchar(500),
    audituserid          double precision,
    auditdatastate       varchar(10),
    auditdmlaction       varchar(10),
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    ratecallforwardingid double precision,
    refresh_timestamp    timestamp encode az64
);

alter table landing_asc.audit_userdetails
    owner to etluser;

create table if not exists staging_asc.audit_userdetails
(
    ascend_carrier_id     bigint encode az64,
    userdetailsid         bigint encode az64,
    userid                bigint encode az64 distkey,
    beid                  bigint encode az64,
    primaryphone          varchar(15),
    officephone           varchar(15),
    homephone             varchar(15),
    mobilephone           varchar(15),
    fax                   varchar(15),
    address               varchar(50),
    city                  varchar(50),
    state                 varchar(2),
    zipcode               varchar(5),
    extusername           varchar(150),
    extpassword           varchar(150),
    useenrollurl          boolean,
    leadgeneration        boolean,
    skilllevel            bigint encode az64,
    userurl               varchar(500),
    userate               boolean,
    enrollmentphone       varchar(20),
    contactnumbersid      varchar(50),
    natpronum             varchar(10),
    notes                 varchar(500),
    audituserid           bigint encode az64,
    auditdatastate        varchar(10),
    auditdmlaction        varchar(10),
    auditdatetime         timestamp encode az64,
    uniquekey             varchar(40),
    ratecallforwardingid  bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_asc.audit_userdetails
    owner to etluser;

create table if not exists integrated_asc.audit_userdetails
(
    dw_table_pk          bigint default "identity"(501827, 0, '0,1'::text) encode az64,
    ascend_carrier_id    bigint encode az64,
    userdetailsid        bigint encode az64,
    userid               bigint encode az64 distkey,
    beid                 bigint encode az64,
    primaryphone         varchar(15),
    officephone          varchar(15),
    homephone            varchar(15),
    mobilephone          varchar(15),
    fax                  varchar(15),
    address              varchar(50),
    city                 varchar(50),
    state                varchar(2),
    zipcode              varchar(5),
    extusername          varchar(150),
    extpassword          varchar(150),
    useenrollurl         boolean,
    leadgeneration       boolean,
    skilllevel           bigint encode az64,
    userurl              varchar(500),
    userate              boolean,
    enrollmentphone      varchar(20),
    contactnumbersid     varchar(50),
    natpronum            varchar(10),
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    auditdatastate       varchar(10) encode bytedict,
    auditdmlaction       varchar(10) encode bytedict,
    auditdatetime        timestamp encode az64,
    uniquekey            varchar(40),
    ratecallforwardingid bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_asc.audit_userdetails
    owner to etluser;

grant select on integrated_asc.audit_userdetails to group named_user_ro;

create table if not exists landing_aqe.routebyoutboundivr
(
    pkroutebyoutboundivr  bigint encode az64,
    projectfk             bigint encode az64,
    fromnumber            varchar(20),
    twilioaccountsid      varchar(100),
    twilioauthtoken       varchar(100),
    delay                 bigint encode az64,
    maxperrun             double precision,
    isactive              boolean,
    timeout               bigint encode az64,
    useamd                boolean,
    amdtimeout            bigint encode az64,
    amdspeechthreshold    bigint encode az64,
    amdspeechendthreshold bigint encode az64,
    amdsilencetimeout     bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    callstarttime         varchar(64),
    callendtime           varchar(64),
    refresh_timestamp     timestamp encode az64
);

alter table landing_aqe.routebyoutboundivr
    owner to etluser;

create table if not exists staging_aqe.routebyoutboundivr
(
    pkroutebyoutboundivr  bigint encode az64,
    projectfk             bigint encode az64,
    fromnumber            varchar(20),
    twilioaccountsid      varchar(100) distkey,
    twilioauthtoken       varchar(100),
    delay                 bigint encode az64,
    maxperrun             bigint encode az64,
    isactive              boolean,
    timeout               bigint encode az64,
    useamd                boolean,
    amdtimeout            bigint encode az64,
    amdspeechthreshold    bigint encode az64,
    amdspeechendthreshold bigint encode az64,
    amdsilencetimeout     bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    callstarttime         varchar(64),
    callendtime           varchar(64),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.routebyoutboundivr
    owner to etluser;

create table if not exists integrated_aqe.routebyoutboundivr
(
    dw_table_pk           bigint default "identity"(524747, 0, '0,1'::text) encode az64,
    pkroutebyoutboundivr  bigint encode az64,
    projectfk             bigint encode az64,
    fromnumber            varchar(20),
    twilioaccountsid      varchar(100) distkey,
    twilioauthtoken       varchar(100),
    delay                 bigint encode az64,
    maxperrun             bigint encode az64,
    isactive              boolean,
    timeout               bigint encode az64,
    useamd                boolean,
    amdtimeout            bigint encode az64,
    amdspeechthreshold    bigint encode az64,
    amdspeechendthreshold bigint encode az64,
    amdsilencetimeout     bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    callstarttime         varchar(64),
    callendtime           varchar(64),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_aqe.routebyoutboundivr
    owner to etluser;

grant select on integrated_aqe.routebyoutboundivr to group named_user_ro;

create table if not exists landing_aqe.projectworkflow
(
    pkprojectworkflow     bigint encode az64,
    projectfk             bigint encode az64,
    outreachlistfk        bigint encode az64,
    ordinal               bigint encode az64,
    isactive              boolean,
    outreachtypefk        bigint encode az64,
    timesincelastoutreach double precision,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64
);

alter table landing_aqe.projectworkflow
    owner to etluser;

create table if not exists staging_aqe.projectworkflow
(
    pkprojectworkflow     bigint encode az64,
    projectfk             bigint encode az64,
    outreachlistfk        bigint encode az64,
    ordinal               bigint encode az64,
    isactive              boolean,
    outreachtypefk        bigint encode az64,
    timesincelastoutreach bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.projectworkflow
    owner to etluser;

create table if not exists integrated_aqe.projectworkflow
(
    dw_table_pk           bigint default "identity"(524786, 0, '0,1'::text) encode az64,
    pkprojectworkflow     bigint encode az64,
    projectfk             bigint encode az64,
    outreachlistfk        bigint encode az64,
    ordinal               bigint encode az64,
    isactive              boolean,
    outreachtypefk        bigint encode az64,
    timesincelastoutreach bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_aqe.projectworkflow
    owner to etluser;

grant select on integrated_aqe.projectworkflow to group named_user_ro;

create table if not exists landing_aqe.outreachtypes
(
    pkoutreachtype    bigint encode az64,
    outreachtype      varchar(100),
    isactive          boolean,
    inserteddate      timestamp encode az64,
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.outreachtypes
    owner to etluser;

create table if not exists staging_aqe.outreachtypes
(
    pkoutreachtype        bigint encode az64,
    outreachtype          varchar(100),
    isactive              boolean,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.outreachtypes
    owner to etluser;

create table if not exists integrated_aqe.outreachtypes
(
    dw_table_pk          bigint default "identity"(524805, 0, '0,1'::text) encode az64,
    pkoutreachtype       bigint encode az64,
    outreachtype         varchar(100),
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.outreachtypes
    owner to etluser;

grant select on integrated_aqe.outreachtypes to group named_user_ro;

create table if not exists landing_aqe.emailbyoutreachattempt
(
    pkemailbyoutreachattempt bigint encode az64,
    routebyemailfk           bigint encode az64,
    twiliolanguagefk         double precision,
    emailbody                varchar(10240),
    fromaddress              varchar(100),
    fromname                 varchar(100),
    subject                  varchar(100),
    outreachattempt          double precision,
    isactive                 boolean,
    contenttypefk            double precision,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64
);

alter table landing_aqe.emailbyoutreachattempt
    owner to etluser;

create table if not exists staging_aqe.emailbyoutreachattempt
(
    pkemailbyoutreachattempt bigint encode az64 distkey,
    routebyemailfk           bigint encode az64,
    twiliolanguagefk         bigint encode az64,
    emailbody                varchar(10240),
    fromaddress              varchar(100),
    fromname                 varchar(100),
    subject                  varchar(100),
    outreachattempt          bigint encode az64,
    isactive                 boolean,
    contenttypefk            bigint encode az64,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char    default 'N'::bpchar,
    processed_flag           boolean default false,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.emailbyoutreachattempt
    owner to etluser;

create table if not exists integrated_aqe.emailbyoutreachattempt
(
    dw_table_pk              bigint default "identity"(524915, 0, '0,1'::text) encode az64,
    pkemailbyoutreachattempt bigint encode az64 distkey,
    routebyemailfk           bigint encode az64,
    twiliolanguagefk         bigint encode az64,
    emailbody                varchar(10240),
    fromaddress              varchar(100),
    fromname                 varchar(100),
    subject                  varchar(100),
    outreachattempt          bigint encode az64,
    isactive                 boolean,
    contenttypefk            bigint encode az64,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table integrated_aqe.emailbyoutreachattempt
    owner to etluser;

grant select on integrated_aqe.emailbyoutreachattempt to group named_user_ro;

create table if not exists landing_aqe.ivrbyoutreachattempt
(
    pkivrbyoutreachattempt       bigint encode az64,
    routebyoutboundivrfk         bigint encode az64,
    authtext                     varchar(10240),
    caregiverauthtext            varchar(10240),
    authtext2                    varchar(10240),
    authtext3                    varchar(10240),
    authtext4                    varchar(10240),
    caregiverauthtext2           varchar(10240),
    caregiverauthtext3           varchar(10240),
    caregiverauthtext4           varchar(10240),
    introtext                    varchar(10240),
    wrongpartytext               varchar(10240),
    notgoodtimetext              varchar(10240),
    authtext2failed              varchar(10240),
    authtext3failed              varchar(10240),
    authtext4failed              varchar(10240),
    authcomplete                 varchar(10240),
    answeringmachinemessage      varchar(10240),
    inboundintro1                varchar(10240),
    inboundintro2                varchar(10240),
    inboundauth1                 varchar(10240),
    inboundauth2                 varchar(10240),
    inboundauth2failed           varchar(10240),
    inboundauth3                 varchar(10240),
    inboundauth4                 varchar(10240),
    inboundcaregiverauth1        varchar(10240),
    inboundcaregiverauth2        varchar(10240),
    inboundcaregiverauth3        varchar(10240),
    inboundcaregiverauth4        varchar(10240),
    inboundauthcomplete          varchar(10240),
    inboundcaregiverauthcomplete varchar(10240),
    inboundauthfailterminate     varchar(10240),
    outreachattempt              double precision,
    isactive                     boolean,
    twiliolanguagefk             bigint encode az64,
    contenttypefk                double precision,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64
);

alter table landing_aqe.ivrbyoutreachattempt
    owner to etluser;

create table if not exists staging_aqe.ivrbyoutreachattempt
(
    pkivrbyoutreachattempt       bigint encode az64,
    routebyoutboundivrfk         bigint encode az64,
    authtext                     varchar(10240),
    caregiverauthtext            varchar(10240),
    authtext2                    varchar(10240),
    authtext3                    varchar(10240),
    authtext4                    varchar(10240),
    caregiverauthtext2           varchar(10240),
    caregiverauthtext3           varchar(10240),
    caregiverauthtext4           varchar(10240),
    introtext                    varchar(10240),
    wrongpartytext               varchar(10240),
    notgoodtimetext              varchar(10240),
    authtext2failed              varchar(10240),
    authtext3failed              varchar(10240),
    authtext4failed              varchar(10240),
    authcomplete                 varchar(10240),
    answeringmachinemessage      varchar(10240),
    inboundintro1                varchar(10240),
    inboundintro2                varchar(10240),
    inboundauth1                 varchar(10240),
    inboundauth2                 varchar(10240),
    inboundauth2failed           varchar(10240),
    inboundauth3                 varchar(10240),
    inboundauth4                 varchar(10240),
    inboundcaregiverauth1        varchar(10240),
    inboundcaregiverauth2        varchar(10240),
    inboundcaregiverauth3        varchar(10240),
    inboundcaregiverauth4        varchar(10240),
    inboundauthcomplete          varchar(10240),
    inboundcaregiverauthcomplete varchar(10240),
    inboundauthfailterminate     varchar(10240),
    outreachattempt              bigint encode az64,
    isactive                     boolean,
    twiliolanguagefk             bigint encode az64,
    contenttypefk                bigint encode az64,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64,
    data_action_indicator        char    default 'N'::bpchar,
    processed_flag               boolean default false,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table staging_aqe.ivrbyoutreachattempt
    owner to etluser;

create table if not exists integrated_aqe.ivrbyoutreachattempt
(
    dw_table_pk                  bigint default "identity"(525038, 0, '0,1'::text) encode az64,
    pkivrbyoutreachattempt       bigint encode az64,
    routebyoutboundivrfk         bigint encode az64,
    authtext                     varchar(10240),
    caregiverauthtext            varchar(10240),
    authtext2                    varchar(10240),
    authtext3                    varchar(10240),
    authtext4                    varchar(10240),
    caregiverauthtext2           varchar(10240),
    caregiverauthtext3           varchar(10240),
    caregiverauthtext4           varchar(10240),
    introtext                    varchar(10240),
    wrongpartytext               varchar(10240),
    notgoodtimetext              varchar(10240),
    authtext2failed              varchar(10240),
    authtext3failed              varchar(10240),
    authtext4failed              varchar(10240),
    authcomplete                 varchar(10240),
    answeringmachinemessage      varchar(10240),
    inboundintro1                varchar(10240),
    inboundintro2                varchar(10240),
    inboundauth1                 varchar(10240),
    inboundauth2                 varchar(10240),
    inboundauth2failed           varchar(10240),
    inboundauth3                 varchar(10240),
    inboundauth4                 varchar(10240),
    inboundcaregiverauth1        varchar(10240),
    inboundcaregiverauth2        varchar(10240),
    inboundcaregiverauth3        varchar(10240),
    inboundcaregiverauth4        varchar(10240),
    inboundauthcomplete          varchar(10240),
    inboundcaregiverauthcomplete varchar(10240),
    inboundauthfailterminate     varchar(10240),
    outreachattempt              bigint encode az64,
    isactive                     boolean,
    twiliolanguagefk             bigint encode az64,
    contenttypefk                bigint encode az64,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32)
);

alter table integrated_aqe.ivrbyoutreachattempt
    owner to etluser;

grant select on integrated_aqe.ivrbyoutreachattempt to group named_user_ro;

create table if not exists landing_aqe.smsbyoutreachattempt
(
    pksmsbyoutreachattempt bigint encode az64,
    routebysmsfk           bigint encode az64,
    twiliolanguagefk       double precision,
    smstext                varchar(512),
    outreachattempt        double precision,
    isactive               boolean,
    contenttypefk          double precision,
    miscnotes              varchar(256),
    inserteddate           timestamp encode az64,
    validfrom              timestamp encode az64,
    validto                timestamp encode az64,
    refresh_timestamp      timestamp encode az64
);

alter table landing_aqe.smsbyoutreachattempt
    owner to etluser;

create table if not exists staging_aqe.smsbyoutreachattempt
(
    pksmsbyoutreachattempt bigint encode az64,
    routebysmsfk           bigint encode az64,
    twiliolanguagefk       bigint encode az64,
    smstext                varchar(512),
    outreachattempt        bigint encode az64,
    isactive               boolean,
    contenttypefk          bigint encode az64,
    miscnotes              varchar(256),
    inserteddate           timestamp encode az64,
    validfrom              timestamp encode az64,
    validto                timestamp encode az64,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char    default 'N'::bpchar,
    processed_flag         boolean default false,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_aqe.smsbyoutreachattempt
    owner to etluser;

create table if not exists integrated_aqe.smsbyoutreachattempt
(
    dw_table_pk            bigint default "identity"(525114, 0, '0,1'::text) encode az64,
    pksmsbyoutreachattempt bigint encode az64,
    routebysmsfk           bigint encode az64,
    twiliolanguagefk       bigint encode az64,
    smstext                varchar(512),
    outreachattempt        bigint encode az64,
    isactive               boolean,
    contenttypefk          bigint encode az64,
    miscnotes              varchar(256),
    inserteddate           timestamp encode az64,
    validfrom              timestamp encode az64,
    validto                timestamp encode az64,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_aqe.smsbyoutreachattempt
    owner to etluser;

grant select on integrated_aqe.smsbyoutreachattempt to group named_user_ro;

create table if not exists landing_aqe.outreachlist
(
    pkoutreachlist       bigint encode az64,
    projectfk            double precision,
    outreachtypefk       double precision,
    outreachlistname     varchar(1024),
    memberslistsqlquery  varchar(2048),
    memberslistsqlstruct varchar(2048),
    lastrefreshdatetime  timestamp encode az64,
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64
);

alter table landing_aqe.outreachlist
    owner to etluser;

create table if not exists staging_aqe.outreachlist
(
    pkoutreachlist        bigint encode az64,
    projectfk             bigint encode az64,
    outreachtypefk        bigint encode az64,
    outreachlistname      varchar(1024),
    memberslistsqlquery   varchar(2048),
    memberslistsqlstruct  varchar(2048),
    lastrefreshdatetime   timestamp encode az64,
    isactive              boolean,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.outreachlist
    owner to etluser;

create table if not exists integrated_aqe.outreachlist
(
    dw_table_pk          bigint default "identity"(525144, 0, '0,1'::text) encode az64,
    pkoutreachlist       bigint encode az64,
    projectfk            bigint encode az64,
    outreachtypefk       bigint encode az64,
    outreachlistname     varchar(1024),
    memberslistsqlquery  varchar(2048),
    memberslistsqlstruct varchar(2048),
    lastrefreshdatetime  timestamp encode az64,
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.outreachlist
    owner to etluser;

grant select on integrated_aqe.outreachlist to group named_user_ro;

create table if not exists landing_aqe.routes
(
    pkroute           bigint encode az64,
    projectfk         double precision,
    outreachtypefk    double precision,
    isactive          boolean,
    lastrundatetime   timestamp encode az64,
    timebetweenruns   double precision,
    inserteddate      timestamp encode az64,
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.routes
    owner to etluser;

create table if not exists staging_aqe.routes
(
    pkroute               bigint encode az64,
    projectfk             bigint encode az64,
    outreachtypefk        bigint encode az64,
    isactive              boolean,
    lastrundatetime       timestamp encode az64,
    timebetweenruns       bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.routes
    owner to etluser;

create table if not exists integrated_aqe.routes
(
    dw_table_pk          bigint default "identity"(525161, 0, '0,1'::text) encode az64,
    pkroute              bigint encode az64,
    projectfk            bigint encode az64,
    outreachtypefk       bigint encode az64,
    isactive             boolean,
    lastrundatetime      timestamp encode az64,
    timebetweenruns      bigint encode az64,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.routes
    owner to etluser;

grant select on integrated_aqe.routes to group named_user_ro;

create table if not exists landing_aqe.routebyemail
(
    pkroutebyemail           bigint encode az64,
    projectfk                bigint encode az64,
    sendgridapikey           varchar(100),
    delay                    bigint encode az64,
    maxperrun                double precision,
    isactive                 boolean,
    minvalidationscore       double precision,
    sendgridvalidationapikey varchar(100),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64
);

alter table landing_aqe.routebyemail
    owner to etluser;

create table if not exists staging_aqe.routebyemail
(
    pkroutebyemail           bigint encode az64,
    projectfk                bigint encode az64,
    sendgridapikey           varchar(100),
    delay                    bigint encode az64,
    maxperrun                bigint encode az64,
    isactive                 boolean,
    minvalidationscore       bigint encode az64,
    sendgridvalidationapikey varchar(100),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_action_indicator    char    default 'N'::bpchar,
    processed_flag           boolean default false,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table staging_aqe.routebyemail
    owner to etluser;

create table if not exists integrated_aqe.routebyemail
(
    dw_table_pk              bigint default "identity"(525177, 0, '0,1'::text) encode az64,
    pkroutebyemail           bigint encode az64,
    projectfk                bigint encode az64,
    sendgridapikey           varchar(100),
    delay                    bigint encode az64,
    maxperrun                bigint encode az64,
    isactive                 boolean,
    minvalidationscore       bigint encode az64,
    sendgridvalidationapikey varchar(100),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32)
);

alter table integrated_aqe.routebyemail
    owner to etluser;

grant select on integrated_aqe.routebyemail to group named_user_ro;

create table if not exists landing_aqe.projects
(
    pkproject         bigint encode az64,
    projectname       varchar(500),
    isactive          boolean,
    carrierfk         double precision,
    maxattempts       double precision,
    maxsmsattempts    double precision,
    maxemailattempts  double precision,
    maxivrattempts    double precision,
    inserteddate      timestamp encode az64,
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.projects
    owner to etluser;

create table if not exists staging_aqe.projects
(
    pkproject             bigint encode az64,
    projectname           varchar(500),
    isactive              boolean,
    carrierfk             bigint encode az64,
    maxattempts           bigint encode az64,
    maxsmsattempts        bigint encode az64,
    maxemailattempts      bigint encode az64,
    maxivrattempts        bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.projects
    owner to etluser;

create table if not exists integrated_aqe.projects
(
    dw_table_pk          bigint default "identity"(525193, 0, '0,1'::text) encode az64,
    pkproject            bigint encode az64,
    projectname          varchar(500),
    isactive             boolean,
    carrierfk            bigint encode az64,
    maxattempts          bigint encode az64,
    maxsmsattempts       bigint encode az64,
    maxemailattempts     bigint encode az64,
    maxivrattempts       bigint encode az64,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.projects
    owner to etluser;

grant select on integrated_aqe.projects to group named_user_ro;

create table if not exists landing_aqe.routebysms
(
    pkroutebysms      bigint encode az64,
    projectfk         double precision,
    fromnumber        varchar(20),
    twilioaccountsid  varchar(100),
    twilioauthtoken   varchar(100),
    delay             bigint encode az64,
    maxperrun         double precision,
    isactive          boolean,
    inserteddate      timestamp encode az64,
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.routebysms
    owner to etluser;

create table if not exists staging_aqe.routebysms
(
    pkroutebysms          bigint encode az64,
    projectfk             bigint encode az64,
    fromnumber            varchar(20),
    twilioaccountsid      varchar(100) distkey,
    twilioauthtoken       varchar(100),
    delay                 bigint encode az64,
    maxperrun             bigint encode az64,
    isactive              boolean,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.routebysms
    owner to etluser;

create table if not exists integrated_aqe.routebysms
(
    dw_table_pk          bigint default "identity"(525209, 0, '0,1'::text) encode az64,
    pkroutebysms         bigint encode az64,
    projectfk            bigint encode az64,
    fromnumber           varchar(20),
    twilioaccountsid     varchar(100) distkey,
    twilioauthtoken      varchar(100),
    delay                bigint encode az64,
    maxperrun            bigint encode az64,
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.routebysms
    owner to etluser;

grant select on integrated_aqe.routebysms to group named_user_ro;

create table if not exists landing_aqe.vbeaudit_outreachlistmap
(
    carrier_id           bigint encode az64 distkey,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk double precision,
    memberinformationfk  double precision,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000),
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp,
    refresh_timestamp    timestamp encode az64
)
    sortkey (validto);

alter table landing_aqe.vbeaudit_outreachlistmap
    owner to etluser;

create table if not exists staging_aqe.vbeaudit_outreachlistmap
(
    carrier_id            bigint encode az64 distkey,
    pkoutreachlistmap     bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    outreachlistfk        bigint encode az64,
    listsource            varchar(1000),
    isactive              boolean,
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.vbeaudit_outreachlistmap
    owner to etluser;

create table if not exists integrated_aqe.vbeaudit_outreachlistmap
(
    dw_table_pk          bigint default "identity"(525321, 0, '0,1'::text) encode az64,
    carrier_id           bigint encode az64,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk bigint encode az64,
    memberinformationfk  bigint encode az64 distkey,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000) encode bytedict,
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
)
    diststyle key;

alter table integrated_aqe.vbeaudit_outreachlistmap
    owner to etluser;

grant select on integrated_aqe.vbeaudit_outreachlistmap to group named_user_ro;

create table if not exists landing_aqe.vbeaudit_outreachemailresults
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    double precision,
    memberinformationfk     double precision,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) distkey,
    inserteddate            timestamp encode az64,
    hrainformationid        double precision,
    excludefromreporting    boolean,
    miscnotes               varchar(256),
    email                   varchar(256),
    oer_timestamp           double precision,
    smtpid                  varchar(256),
    event                   varchar(256),
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(512),
    attempt                 varchar(256),
    useragent               varchar(512),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(3072),
    status                  varchar(256),
    asm_group_id            double precision,
    type                    varchar(256),
    validfrom               timestamp,
    validto                 timestamp encode az64,
    projectfk               double precision,
    outreachattemptfk       double precision,
    outreachlistfk          double precision,
    refresh_timestamp       timestamp encode az64
)
    sortkey (validfrom);

alter table landing_aqe.vbeaudit_outreachemailresults
    owner to etluser;

create table if not exists staging_aqe.vbeaudit_outreachemailresults
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) distkey,
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64,
    excludefromreporting    boolean,
    miscnotes               varchar(256),
    email                   varchar(256),
    oer_timestamp           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256),
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(512),
    attempt                 varchar(256),
    useragent               varchar(512),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(3072),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_action_indicator   char    default 'N'::bpchar,
    processed_flag          boolean default false,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
);

alter table staging_aqe.vbeaudit_outreachemailresults
    owner to etluser;

create table if not exists integrated_aqe.vbeaudit_outreachemailresults
(
    dw_table_pk             bigint default "identity"(525506, 0, '0,1'::text) encode az64,
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64 distkey,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000),
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64,
    excludefromreporting    boolean,
    miscnotes               varchar(256) encode bytedict,
    email                   varchar(256),
    oer_timestamp           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256) encode bytedict,
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(512),
    attempt                 varchar(256) encode bytedict,
    useragent               varchar(512),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(3072),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32)
)
    diststyle key;

alter table integrated_aqe.vbeaudit_outreachemailresults
    owner to etluser;

grant select on integrated_aqe.vbeaudit_outreachemailresults to group named_user_ro;

create table if not exists landing_aqe.contenttype
(
    contenttypeid     bigint encode az64,
    projectfk         bigint encode az64,
    contentname       varchar(250),
    miscnotes         varchar(256),
    inserteddate      timestamp encode az64,
    validfrom         timestamp encode az64,
    validto           timestamp encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_aqe.contenttype
    owner to etluser;

create table if not exists staging_aqe.contenttype
(
    contenttypeid         bigint encode az64,
    projectfk             bigint encode az64,
    contentname           varchar(250),
    miscnotes             varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_aqe.contenttype
    owner to etluser;

create table if not exists integrated_aqe.contenttype
(
    dw_table_pk          bigint default "identity"(527897, 0, '0,1'::text) encode az64,
    contenttypeid        bigint encode az64,
    projectfk            bigint encode az64,
    contentname          varchar(250),
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_aqe.contenttype
    owner to etluser;

grant select on integrated_aqe.contenttype to group named_user_ro;

create table if not exists landing_ccs.users
(
    pkusers                        bigint,
    name                           varchar(32),
    login                          varchar(32),
    password                       varchar(32),
    issupervisor                   boolean,
    isoutbound                     boolean,
    isinbound                      boolean,
    isverification                 boolean,
    ismanualdial                   boolean,
    isemail                        boolean,
    skilllevel                     bigint encode az64,
    userlanguage                   bigint encode az64,
    deleted                        boolean,
    isloggedin                     boolean,
    playvoicemailthroughpcspeakers boolean,
    voicemailgreeting              varchar(100),
    viewdeletedvoicemails          boolean,
    extension                      bigint encode az64,
    isadminsiteaccess              boolean,
    voicemailboxfk                 double precision,
    startdate                      timestamp encode az64,
    firstname                      varchar(20),
    lastname                       varchar(50),
    teamname                       varchar(20),
    isteammanager                  boolean,
    islicensedagent                boolean,
    isuambrpuser                   boolean,
    uam_eeid                       varchar(255),
    isbaamuser                     boolean,
    salt                           varchar(32),
    password2                      varchar(32),
    refresh_timestamp              timestamp encode az64
)
    sortkey (pkusers);

alter table landing_ccs.users
    owner to etluser;

create table if not exists staging_ccs.users
(
    pkusers                        bigint encode az64,
    name                           varchar(32),
    login                          varchar(32),
    password                       varchar(32),
    issupervisor                   boolean,
    isoutbound                     boolean,
    isinbound                      boolean,
    isverification                 boolean,
    ismanualdial                   boolean,
    isemail                        boolean,
    skilllevel                     bigint encode az64,
    userlanguage                   bigint encode az64,
    deleted                        boolean,
    isloggedin                     boolean,
    playvoicemailthroughpcspeakers boolean,
    voicemailgreeting              varchar(100),
    viewdeletedvoicemails          boolean,
    extension                      bigint encode az64,
    isadminsiteaccess              boolean,
    voicemailboxfk                 bigint encode az64,
    startdate                      timestamp encode az64,
    firstname                      varchar(20),
    lastname                       varchar(50),
    teamname                       varchar(20),
    isteammanager                  boolean,
    islicensedagent                boolean,
    isuambrpuser                   boolean,
    uam_eeid                       varchar(255),
    isbaamuser                     boolean,
    salt                           varchar(32),
    password2                      varchar(32),
    refresh_timestamp              timestamp encode az64,
    data_action_indicator          char    default 'N'::bpchar,
    processed_flag                 boolean default false,
    data_transfer_log_id           bigint encode az64,
    md5_hash                       varchar(32)
);

alter table staging_ccs.users
    owner to etluser;

create table if not exists integrated_ccs.users
(
    dw_table_pk                    bigint default "identity"(527973, 0, '0,1'::text) encode az64,
    pkusers                        bigint encode az64,
    name                           varchar(32),
    login                          varchar(32),
    password                       varchar(32),
    issupervisor                   boolean,
    isoutbound                     boolean,
    isinbound                      boolean,
    isverification                 boolean,
    ismanualdial                   boolean,
    isemail                        boolean,
    skilllevel                     bigint encode az64,
    userlanguage                   bigint encode az64,
    deleted                        boolean,
    isloggedin                     boolean,
    playvoicemailthroughpcspeakers boolean,
    voicemailgreeting              varchar(100),
    viewdeletedvoicemails          boolean,
    extension                      bigint encode az64,
    isadminsiteaccess              boolean,
    voicemailboxfk                 bigint encode az64,
    startdate                      timestamp encode az64,
    firstname                      varchar(20),
    lastname                       varchar(50),
    teamname                       varchar(20),
    isteammanager                  boolean,
    islicensedagent                boolean,
    isuambrpuser                   boolean,
    uam_eeid                       varchar(255),
    isbaamuser                     boolean,
    salt                           varchar(32),
    password2                      varchar(32),
    refresh_timestamp              timestamp encode az64,
    data_transfer_log_id           bigint encode az64,
    md5_hash                       varchar(32)
);

alter table integrated_ccs.users
    owner to etluser;

grant select on integrated_ccs.users to group named_user_ro;

create table if not exists landing_ccs.emailprojects
(
    pkemailproject             bigint encode az64,
    name                       varchar(64),
    databasetype               bigint encode az64,
    databasename               varchar(256),
    databaseserver             varchar(256),
    dbuserid                   varchar(50),
    dbpassword                 varchar(50),
    dbuseswindows              boolean,
    allowmanualemails          boolean,
    allowtemplatesonly         boolean,
    allowresponsetosender      boolean,
    allowcc                    boolean,
    allowresponsetoall         boolean,
    allowbcc                   boolean,
    overflowintogroupfk        double precision,
    fromaddress                varchar(256),
    fromdisplayname            varchar(256),
    autoresponseavailablefk    double precision,
    autoresponsenotavailablefk double precision,
    outgoingserveraddress      varchar(256),
    outgoingport               bigint encode az64,
    outgoingencrypted          boolean,
    outgoingusername           varchar(256),
    outgoingpassword           varchar(256),
    allowmanualdial            boolean,
    callbacktype               double precision,
    isrunning                  boolean,
    manualdialscriptfk         double precision,
    callbackscriptfk           double precision,
    anitosend                  varchar(64),
    bypassmdnc                 boolean,
    emailscriptfk              double precision,
    engineid                   double precision,
    refresh_timestamp          timestamp encode az64
);

alter table landing_ccs.emailprojects
    owner to etluser;

create table if not exists staging_ccs.emailprojects
(
    pkemailproject             bigint encode az64,
    name                       varchar(64),
    databasetype               bigint encode az64,
    databasename               varchar(256),
    databaseserver             varchar(256),
    dbuserid                   varchar(50),
    dbpassword                 varchar(50),
    dbuseswindows              boolean,
    allowmanualemails          boolean,
    allowtemplatesonly         boolean,
    allowresponsetosender      boolean,
    allowcc                    boolean,
    allowresponsetoall         boolean,
    allowbcc                   boolean,
    overflowintogroupfk        bigint encode az64,
    fromaddress                varchar(256),
    fromdisplayname            varchar(256),
    autoresponseavailablefk    bigint encode az64,
    autoresponsenotavailablefk bigint encode az64,
    outgoingserveraddress      varchar(256),
    outgoingport               bigint encode az64,
    outgoingencrypted          boolean,
    outgoingusername           varchar(256),
    outgoingpassword           varchar(256),
    allowmanualdial            boolean,
    callbacktype               bigint encode az64,
    isrunning                  boolean,
    manualdialscriptfk         bigint encode az64,
    callbackscriptfk           bigint encode az64,
    anitosend                  varchar(64),
    bypassmdnc                 boolean,
    emailscriptfk              bigint encode az64,
    engineid                   bigint encode az64,
    refresh_timestamp          timestamp encode az64,
    data_action_indicator      char    default 'N'::bpchar,
    processed_flag             boolean default false,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table staging_ccs.emailprojects
    owner to etluser;

create table if not exists integrated_ccs.emailprojects
(
    dw_table_pk                bigint default "identity"(527991, 0, '0,1'::text) encode az64,
    pkemailproject             bigint encode az64,
    name                       varchar(64),
    databasetype               bigint encode az64,
    databasename               varchar(256),
    databaseserver             varchar(256),
    dbuserid                   varchar(50),
    dbpassword                 varchar(50),
    dbuseswindows              boolean,
    allowmanualemails          boolean,
    allowtemplatesonly         boolean,
    allowresponsetosender      boolean,
    allowcc                    boolean,
    allowresponsetoall         boolean,
    allowbcc                   boolean,
    overflowintogroupfk        bigint encode az64,
    fromaddress                varchar(256),
    fromdisplayname            varchar(256),
    autoresponseavailablefk    bigint encode az64,
    autoresponsenotavailablefk bigint encode az64,
    outgoingserveraddress      varchar(256),
    outgoingport               bigint encode az64,
    outgoingencrypted          boolean,
    outgoingusername           varchar(256),
    outgoingpassword           varchar(256),
    allowmanualdial            boolean,
    callbacktype               bigint encode az64,
    isrunning                  boolean,
    manualdialscriptfk         bigint encode az64,
    callbackscriptfk           bigint encode az64,
    anitosend                  varchar(64),
    bypassmdnc                 boolean,
    emailscriptfk              bigint encode az64,
    engineid                   bigint encode az64,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32)
);

alter table integrated_ccs.emailprojects
    owner to etluser;

grant select on integrated_ccs.emailprojects to group named_user_ro;

create table if not exists aqe_history.outreachvendorresults_history
(
    carrier_id               bigint encode az64,
    pkoutreachvendorresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    vendoroutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    hraactivitydate          timestamp encode az64,
    activityoutcome          varchar(255),
    activitytypeid           bigint encode az64,
    activitytypedescription  varchar(255) encode bytedict,
    hrainformationid         bigint encode az64 distkey,
    programtype              varchar(500) encode bytedict,
    questionversion          varchar(500) encode bytedict,
    excludefromreporting     boolean,
    miscnotes                varchar(256) encode bytedict,
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachvendorresults_history
    owner to etluser;

grant select on aqe_history.outreachvendorresults_history to group named_user_ro;

create table if not exists aqe_history.sourcesystemtype_history
(
    sourcesystemtypeid          bigint encode az64,
    sourcesystemtypedescription varchar(100),
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table aqe_history.sourcesystemtype_history
    owner to etluser;

grant select on aqe_history.sourcesystemtype_history to group named_user_ro;

create table if not exists aqe_history.outreachmembercustominfo_history
(
    carrier_id                 bigint encode az64,
    pkoutreachmembercustominfo bigint encode az64,
    outreachmemberinfofk       bigint encode az64,
    memberinformationfk        bigint encode az64,
    fieldname                  varchar(1000) encode bytedict,
    fieldvalue                 varchar(1000),
    datatype                   varchar(50) encode bytedict,
    isactive                   boolean,
    miscnotes                  varchar(256) encode bytedict,
    inserteddate               timestamp encode az64,
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
);

alter table aqe_history.outreachmembercustominfo_history
    owner to etluser;

grant select on aqe_history.outreachmembercustominfo_history to group named_user_ro;

create table if not exists aqe_history.vbeinformationstatushistory_history
(
    carrier_id                    bigint encode az64,
    vbeinformationstatushistoryid bigint encode az64,
    vbeinformationid              bigint encode az64,
    memberinformationid           bigint encode az64,
    formsubmissionid              bigint encode az64 distkey,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    vbestatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    miscnotes                     varchar(500),
    formid                        bigint encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.vbeinformationstatushistory_history
    owner to etluser;

grant select on aqe_history.vbeinformationstatushistory_history to group named_user_ro;

create table if not exists aqe_history.dbo_persontype_history
(
    persontypeid         bigint encode az64,
    type                 varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.dbo_persontype_history
    owner to etluser;

grant select on aqe_history.dbo_persontype_history to group named_user_ro;

create table if not exists aqe_history.carrierbepayermap_history
(
    carrierbepayermap    bigint encode az64,
    carrierid            bigint encode az64,
    beid                 bigint encode az64 distkey,
    payerid              bigint encode az64,
    isactive             boolean,
    miscnotes            varchar(500),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.carrierbepayermap_history
    owner to etluser;

grant select on aqe_history.carrierbepayermap_history to group named_user_ro;

create table if not exists aqe_history.personcontactinfomap_history
(
    carrier_id           bigint encode az64,
    personcontactinfoid  bigint encode az64,
    personid             bigint encode az64 distkey,
    contactinfoid        bigint encode az64,
    contactinfotypeid    bigint encode az64,
    startdate            timestamp encode az64,
    enddate              timestamp encode az64,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.personcontactinfomap_history
    owner to etluser;

grant select on aqe_history.personcontactinfomap_history to group named_user_ro;

create table if not exists aqe_history.vbeactions_history
(
    vbeactionid          bigint encode az64,
    vbeactionname        varchar(256),
    vbeactiondescription varchar(256),
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.vbeactions_history
    owner to etluser;

grant select on aqe_history.vbeactions_history to group named_user_ro;

create table if not exists aqe_history.enrollmentleadascendcalls_history
(
    carrier_id                    bigint encode az64,
    pkenrollmentleadascendcallsid bigint encode az64 distkey,
    enrollmentid                  bigint encode az64,
    leadascendcallid              bigint encode az64,
    miscnotes                     varchar(256),
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentleadascendcalls_history
    owner to etluser;

grant select on aqe_history.enrollmentleadascendcalls_history to group named_user_ro;

create table if not exists aqe_history.outreachmailresults_history
(
    carrier_id                    bigint encode az64,
    pkoutreachmailresults         bigint encode az64,
    outreachmemberinfofk          bigint encode az64,
    memberinformationfk           bigint encode az64,
    mailoutreachactivityid        varchar(100),
    mailsentdatetime              timestamp encode az64,
    activitydate                  timestamp encode az64,
    hraactivitydate               timestamp encode az64,
    mailoutcome                   varchar(1000) encode bytedict,
    hrainformationid              bigint encode az64 distkey,
    pdffilename                   varchar(500),
    mailcrosswalkstatus           varchar(256) encode bytedict,
    mailcrosswalkstatusupdatedate timestamp encode az64,
    programtype                   varchar(500) encode bytedict,
    questionversion               varchar(500) encode bytedict,
    barcode                       varchar(500),
    excludefromreporting          boolean,
    miscnotes                     varchar(256) encode bytedict,
    inserteddate                  timestamp encode az64,
    validfrom                     timestamp encode az64,
    validto                       timestamp encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachmailresults_history
    owner to etluser;

grant select on aqe_history.outreachmailresults_history to group named_user_ro;

create table if not exists aqe_history.externalenrollmentstatus_history
(
    carrier_id                 bigint encode az64,
    externalenrollmentstatusid bigint encode az64 distkey,
    name                       varchar(500),
    description                varchar(500),
    isdefault                  boolean,
    ispositivestatus           boolean,
    miscnotes                  varchar(500),
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.externalenrollmentstatus_history
    owner to etluser;

grant select on aqe_history.externalenrollmentstatus_history to group named_user_ro;

create table if not exists aqe_history.contactinfo_history
(
    carrier_id           bigint encode az64 distkey,
    contactinfoid        bigint encode az64,
    street1              varchar(256),
    street2              varchar(256),
    city                 varchar(256),
    county               varchar(256),
    state                varchar(256) encode bytedict,
    zipcode              varchar(256),
    country              varchar(256),
    phone                varchar(256),
    email                varchar(256),
    fax                  varchar(256),
    miscnotes            varchar(500),
    secondaryphone       varchar(256),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.contactinfo_history
    owner to etluser;

grant select on aqe_history.contactinfo_history to group named_user_ro;

create table if not exists aqe_history.formplanregionmap_history
(
    carrier_id           bigint encode az64,
    formplanregionmapid  bigint encode az64,
    formid               bigint encode az64,
    planid               bigint encode az64,
    regionid             bigint encode az64,
    planorder            bigint encode az64,
    criteriavalueid      bigint encode az64 distkey,
    miscnotes            varchar(500),
    externalplanid       bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.formplanregionmap_history
    owner to etluser;

grant select on aqe_history.formplanregionmap_history to group named_user_ro;

create table if not exists aqe_history.outreachmemberphoneinfo_history
(
    carrier_id                bigint encode az64 distkey,
    pkoutreachmemberphoneinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    contactnumber             varchar(50),
    order_num                 bigint encode az64,
    phonetype                 bigint encode az64,
    smsattempts               bigint encode az64,
    ivrattempts               bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256) encode bytedict,
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachmemberphoneinfo_history
    owner to etluser;

grant select on aqe_history.outreachmemberphoneinfo_history to group named_user_ro;

create table if not exists aqe_history.outreachlist_history
(
    pkoutreachlist       bigint encode az64,
    projectfk            bigint encode az64,
    outreachtypefk       bigint encode az64,
    outreachlistname     varchar(1024),
    memberslistsqlquery  varchar(2048),
    memberslistsqlstruct varchar(2048),
    lastrefreshdatetime  timestamp encode az64,
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.outreachlist_history
    owner to etluser;

grant select on aqe_history.outreachlist_history to group named_user_ro;

create table if not exists aqe_history.projectworkflow_history
(
    pkprojectworkflow     bigint encode az64,
    projectfk             bigint encode az64,
    outreachlistfk        bigint encode az64,
    ordinal               bigint encode az64,
    isactive              boolean,
    outreachtypefk        bigint encode az64,
    timesincelastoutreach bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table aqe_history.projectworkflow_history
    owner to etluser;

grant select on aqe_history.projectworkflow_history to group named_user_ro;

create table if not exists aqe_history.leadproviderselectionmap_history
(
    carrier_id                 bigint encode az64,
    leadproviderselectionmapid bigint encode az64,
    leadid                     bigint encode az64 distkey,
    leadproviderselectionsid   bigint encode az64,
    isactive                   boolean,
    datecreated                timestamp encode az64,
    lastupdateddate            timestamp encode az64,
    miscnotes                  varchar(256),
    validfrom                  timestamp encode az64,
    validto                    timestamp encode az64,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.leadproviderselectionmap_history
    owner to etluser;

grant select on aqe_history.leadproviderselectionmap_history to group named_user_ro;

create table if not exists aqe_history.twiliolanguage_history
(
    twiliolanguageid     bigint encode az64,
    name                 varchar(256),
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.twiliolanguage_history
    owner to etluser;

grant select on aqe_history.twiliolanguage_history to group named_user_ro;

create table if not exists aqe_history.planrolebuttonmap_history
(
    carrier_id           bigint encode az64,
    planrolebuttonmapid  bigint encode az64,
    planid               bigint encode az64,
    roleid               bigint encode az64,
    buttonid             bigint encode az64 distkey,
    buttonorder          bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(500),
    enrollmentformtypeid bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.planrolebuttonmap_history
    owner to etluser;

grant select on aqe_history.planrolebuttonmap_history to group named_user_ro;

create table if not exists aqe_history.plantype_history
(
    plantypeid           bigint encode az64,
    plantypedescription  varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.plantype_history
    owner to etluser;

grant select on aqe_history.plantype_history to group named_user_ro;

create table if not exists aqe_history.outreachsubsequentresults_history
(
    carrier_id                   bigint encode az64 distkey,
    pkoutreachsubsequentresults  bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    clientuniqueid               varchar(100),
    subsequentoutreachactivityid varchar(100),
    activitydate                 timestamp encode az64,
    activityoutcome              varchar(255) encode bytedict,
    pdfactivityid                varchar(255),
    subsequentreason             varchar(255) encode bytedict,
    excludefromreporting         boolean,
    miscnotes                    varchar(256) encode bytedict,
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachsubsequentresults_history
    owner to etluser;

grant select on aqe_history.outreachsubsequentresults_history to group named_user_ro;

create table if not exists aqe_history.personrelationship_history
(
    carrier_id           bigint encode az64,
    personrelationshipid bigint encode az64 distkey,
    relationship         varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.personrelationship_history
    owner to etluser;

grant select on aqe_history.personrelationship_history to group named_user_ro;

create table if not exists aqe_history.carrier_history
(
    carrierid             bigint encode az64,
    name                  varchar(256),
    databaseserver        varchar(256),
    databasename          varchar(256),
    dbconnectionstring    varchar(256),
    emailaddress          varchar(75),
    emailname             varchar(75),
    bestigebaseurl        varchar(75),
    miscnotes             varchar(500),
    isdeleted             boolean,
    ismultitenant         boolean,
    isdeletedforreporting boolean,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table aqe_history.carrier_history
    owner to etluser;

grant select on aqe_history.carrier_history to group named_user_ro;

create table if not exists aqe_history.ivrbyoutreachattempt_history
(
    pkivrbyoutreachattempt       bigint encode az64,
    routebyoutboundivrfk         bigint encode az64,
    authtext                     varchar(10240),
    caregiverauthtext            varchar(10240),
    authtext2                    varchar(10240),
    authtext3                    varchar(10240),
    authtext4                    varchar(10240),
    caregiverauthtext2           varchar(10240),
    caregiverauthtext3           varchar(10240),
    caregiverauthtext4           varchar(10240),
    introtext                    varchar(10240),
    wrongpartytext               varchar(10240),
    notgoodtimetext              varchar(10240),
    authtext2failed              varchar(10240),
    authtext3failed              varchar(10240),
    authtext4failed              varchar(10240),
    authcomplete                 varchar(10240),
    answeringmachinemessage      varchar(10240),
    inboundintro1                varchar(10240),
    inboundintro2                varchar(10240),
    inboundauth1                 varchar(10240),
    inboundauth2                 varchar(10240),
    inboundauth2failed           varchar(10240),
    inboundauth3                 varchar(10240),
    inboundauth4                 varchar(10240),
    inboundcaregiverauth1        varchar(10240),
    inboundcaregiverauth2        varchar(10240),
    inboundcaregiverauth3        varchar(10240),
    inboundcaregiverauth4        varchar(10240),
    inboundauthcomplete          varchar(10240),
    inboundcaregiverauthcomplete varchar(10240),
    inboundauthfailterminate     varchar(10240),
    outreachattempt              bigint encode az64,
    isactive                     boolean,
    twiliolanguagefk             bigint encode az64,
    contenttypefk                bigint encode az64,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp encode az64,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
);

alter table aqe_history.ivrbyoutreachattempt_history
    owner to etluser;

grant select on aqe_history.ivrbyoutreachattempt_history to group named_user_ro;

create table if not exists aqe_history.enrollmentpersonmap_history
(
    carrier_id           bigint encode az64,
    enrollmentpersonmap  bigint encode az64,
    enrollmentid         bigint encode az64,
    personid             bigint encode az64 distkey,
    personrelationshipid bigint encode az64,
    persontypeid         bigint encode az64,
    providerid           bigint encode az64,
    providertypeid       bigint encode az64,
    premiumamount        numeric(18, 2) encode az64,
    relationship         varchar(50),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentpersonmap_history
    owner to etluser;

grant select on aqe_history.enrollmentpersonmap_history to group named_user_ro;

create table if not exists aqe_history.producttype_history
(
    producttypeid        bigint encode az64,
    name                 varchar(50),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.producttype_history
    owner to etluser;

grant select on aqe_history.producttype_history to group named_user_ro;

create table if not exists aqe_history.applicationtype_history
(
    applicationtypeid    bigint encode az64,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.applicationtype_history
    owner to etluser;

grant select on aqe_history.applicationtype_history to group named_user_ro;

create table if not exists aqe_history.externaldatasourcetype_history
(
    externaldatasourcetypeid bigint encode az64,
    name                     varchar(50),
    description              varchar(500),
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
);

alter table aqe_history.externaldatasourcetype_history
    owner to etluser;

grant select on aqe_history.externaldatasourcetype_history to group named_user_ro;

create table if not exists aqe_history.agent_history
(
    carrier_id           bigint encode az64 distkey,
    agentid              bigint encode az64,
    npn                  varchar(10),
    isdeleted            boolean,
    miscnotes            varchar(500) encode bytedict,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agent_history
    owner to etluser;

grant select on aqe_history.agent_history to group named_user_ro;

create table if not exists aqe_history.agentsalesregionproductmap_history
(
    carrier_id                   bigint encode az64,
    pkagentsalesregionproductmap bigint encode az64 distkey,
    agentsalesregionmapid        bigint encode az64,
    productid                    bigint encode az64,
    isdeleted                    boolean,
    miscnotes                    varchar(500),
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agentsalesregionproductmap_history
    owner to etluser;

grant select on aqe_history.agentsalesregionproductmap_history to group named_user_ro;

create table if not exists aqe_history.enrollmentformulary_history
(
    carrier_id            bigint encode az64,
    enrollmentformularyid bigint encode az64 distkey,
    enrollmentid          bigint encode az64,
    ndc                   varchar(11),
    days_supply           integer encode az64,
    drugtier              varchar(50),
    quantity              bigint encode az64,
    pharmacynpi           varchar(50),
    covered               boolean,
    planpays              varchar(50),
    beneficiarypays       varchar(50),
    manufacturerpays      varchar(50),
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentformulary_history
    owner to etluser;

grant select on aqe_history.enrollmentformulary_history to group named_user_ro;

create table if not exists aqe_history.contactinfotype_history
(
    contactinfotypeid    bigint encode az64,
    type                 varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.contactinfotype_history
    owner to etluser;

grant select on aqe_history.contactinfotype_history to group named_user_ro;

create table if not exists aqe_history.plans_history
(
    carrier_id                       bigint encode az64 distkey,
    planid                           bigint encode az64,
    productid                        bigint encode az64,
    name                             varchar(256),
    coveragetype                     varchar(256),
    plantype                         bigint encode az64,
    contract                         varchar(50),
    pbp_id                           varchar(10),
    segment_id                       varchar(10),
    extended_description             varchar(500),
    premiumdescription               varchar(50),
    premiumvalue                     double precision,
    paymentfrequency                 varchar(50),
    enrollmentactive                 boolean,
    planorder                        bigint encode az64,
    compareorder                     bigint encode az64,
    planyear                         bigint encode az64,
    miscnotes                        varchar(500),
    enrollmentpremiumdescription     varchar(500),
    isdeleted                        boolean,
    partialappexpiry                 bigint encode az64,
    partialapplinkexpiry             bigint encode az64,
    ishraenabled                     boolean,
    isawvenabled                     boolean,
    partdpremiumvalue                double precision,
    premiumdisclaimertext            varchar(1024),
    bestigepath                      varchar(256),
    bestigeplanid                    bigint encode az64,
    partcpremiumvalue                double precision,
    brandname                        varchar(256),
    providerinoutindicatortext       boolean,
    isvisibleforagent                boolean,
    isvisibleforconsumer             boolean,
    excludefromcopaylvlpremiumcalc   boolean,
    isvbeenabled                     boolean,
    confirmationpagebuttonvisibility boolean,
    addmemberpagebuttonvisibility    boolean,
    vbesearchpagebuttonvisibility    boolean,
    isdocumentuploadavailable        boolean,
    isvisibleonaddmemberpage         boolean,
    isnewplan                        boolean,
    rtsplantypeid                    bigint encode az64,
    refresh_timestamp                timestamp,
    data_transfer_log_id             bigint encode az64,
    md5_hash                         varchar(32),
    record_version                   bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.plans_history
    owner to etluser;

grant select on aqe_history.plans_history to group named_user_ro;

create table if not exists aqe_history.agentuserrole_history
(
    agentuserroleid      bigint encode az64,
    name                 varchar(100),
    isdeleted            boolean,
    miscnotes            varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.agentuserrole_history
    owner to etluser;

grant select on aqe_history.agentuserrole_history to group named_user_ro;

create table if not exists aqe_history.hrainformationstatushistory_history
(
    carrier_id                    bigint encode az64,
    hrainformationstatushistoryid bigint encode az64,
    hrainformationid              bigint encode az64,
    hrastatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp encode az64,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
);

alter table aqe_history.hrainformationstatushistory_history
    owner to etluser;

grant select on aqe_history.hrainformationstatushistory_history to group named_user_ro;

create table if not exists aqe_history.memberinformation_history
(
    carrier_id                      bigint encode az64,
    memberinformationid             bigint encode az64,
    firstname                       varchar(100),
    lastname                        varchar(100),
    middlename                      varchar(50) encode bytedict,
    phonenumber                     varchar(50),
    dob                             date encode az64,
    gender                          varchar(10) encode bytedict,
    address1                        varchar(200),
    address2                        varchar(200),
    city                            varchar(100),
    state                           varchar(50) encode bytedict,
    zipcode                         varchar(10),
    electionperiodinfo              varchar(1024) encode bytedict,
    memberhicn                      varchar(256) distkey,
    sourcesystemtypeid              bigint encode az64,
    sourcesystemid                  varchar(50),
    clientuniqueid                  varchar(100),
    originalsourcefilename          varchar(1000) encode bytedict,
    originalsourcefiledate          date encode az64,
    updatesfilename                 varchar(1000),
    contractnumber                  varchar(10) encode bytedict,
    plancode                        varchar(20) encode bytedict,
    planid                          bigint encode az64,
    planname                        varchar(256) encode bytedict,
    planyear                        bigint encode az64,
    dateadded                       timestamp encode az64,
    twiliolanguageid                bigint encode az64,
    permissiontocontactthroughphone boolean,
    ptcdate                         timestamp encode az64,
    permissiontocontactthroughemail boolean,
    permissiontocontactthroughsms   boolean,
    preferredmethodofcontact        bigint encode az64,
    pcpfirstname                    varchar(100),
    pcplastname                     varchar(100),
    pcpaddress1                     varchar(200),
    pcpaddress2                     varchar(200),
    pcpcity                         varchar(100),
    pcpstate                        varchar(50) encode bytedict,
    pcpzip                          varchar(10),
    pcpeffectivedate                date encode az64,
    iscallable                      boolean,
    isdeleted                       boolean,
    isactiveforoutreach             boolean,
    agencyname                      varchar(256),
    vbeactionid                     bigint encode az64,
    ascenduserid                    bigint encode az64,
    agentnpn                        varchar(255),
    applicationdate                 timestamp encode az64,
    vbememberid                     varchar(100),
    externalauthcode                varchar(8),
    deactivateddate                 timestamp encode az64,
    deactivatedreason               varchar(256) encode bytedict,
    alternateexternalauthcode       varchar(25),
    updateddate                     timestamp encode az64,
    miscnotes                       varchar(256) encode bytedict,
    beid                            bigint encode az64,
    ascendleadid                    bigint encode az64,
    smsattempts                     bigint encode az64,
    ivrattempts                     bigint encode az64,
    emailattempts                   bigint encode az64,
    county                          varchar(100),
    refresh_timestamp               timestamp,
    data_transfer_log_id            bigint encode az64,
    md5_hash                        varchar(32),
    record_version                  bigint encode az64
);

alter table aqe_history.memberinformation_history
    owner to etluser;

grant select on aqe_history.memberinformation_history to group named_user_ro;

create table if not exists aqe_history.agentreadytosellstatus_history
(
    carrier_id               bigint encode az64,
    agentreadytosellstatusid bigint encode az64,
    agentid                  bigint encode az64,
    businessentityid         bigint encode az64 distkey,
    payerid                  bigint encode az64,
    planyear                 bigint encode az64,
    state                    varchar(2),
    readytosellflag          boolean,
    isdeleted                boolean,
    author                   varchar(255),
    systemuser_createdby     varchar(128) encode bytedict,
    miscnotes                varchar(256) encode bytedict,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    rtsplantypeid            bigint encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agentreadytosellstatus_history
    owner to etluser;

grant select on aqe_history.agentreadytosellstatus_history to group named_user_ro;

create table if not exists aqe_history.agenturl2_history
(
    carrier_id           bigint encode az64,
    pkagenturl           bigint encode az64,
    agenturlid           varchar(100),
    agentid              bigint encode az64,
    isdeleted            boolean,
    creationdate         timestamp encode az64,
    miscnotes            varchar(500) encode bytedict,
    beid                 bigint encode az64 distkey,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agenturl2_history
    owner to etluser;

grant select on aqe_history.agenturl2_history to group named_user_ro;

create table if not exists aqe_history.rtsplantypes_history
(
    rtsplantypeid        bigint encode az64,
    rtsplantypename      varchar(50),
    producttypeid        bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(256),
    systemuser_createdby varchar(128),
    systemuser_updatedby varchar(128),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.rtsplantypes_history
    owner to etluser;

grant select on aqe_history.rtsplantypes_history to group named_user_ro;

create table if not exists aqe_history.payer_history
(
    payerid              bigint encode az64,
    payername            varchar(256),
    isactive             boolean,
    miscnotes            varchar(500),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.payer_history
    owner to etluser;

grant select on aqe_history.payer_history to group named_user_ro;

create table if not exists aqe_history.routebyemail_history
(
    pkroutebyemail           bigint encode az64,
    projectfk                bigint encode az64,
    sendgridapikey           varchar(100),
    delay                    bigint encode az64,
    maxperrun                bigint encode az64,
    isactive                 boolean,
    minvalidationscore       bigint encode az64,
    sendgridvalidationapikey varchar(100),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
);

alter table aqe_history.routebyemail_history
    owner to etluser;

grant select on aqe_history.routebyemail_history to group named_user_ro;

create table if not exists aqe_history.leadproviderselections_history
(
    carrier_id               bigint encode az64,
    leadproviderselectionsid bigint encode az64,
    npi                      varchar(255),
    locationid               bigint encode az64 distkey,
    siteid                   varchar(255),
    clientlocationidentifier varchar(255),
    groupname                varchar(256),
    street                   varchar(256),
    zip                      varchar(10),
    ispcp                    boolean,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    pcpselectedbybeneficiary boolean,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
);

alter table aqe_history.leadproviderselections_history
    owner to etluser;

grant select on aqe_history.leadproviderselections_history to group named_user_ro;

create table if not exists aqe_history.quickquoteplanmap_history
(
    carrier_id           bigint encode az64,
    quickquoteplanmapid  bigint encode az64,
    quickquoteid         bigint encode az64 distkey,
    planid               bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.quickquoteplanmap_history
    owner to etluser;

grant select on aqe_history.quickquoteplanmap_history to group named_user_ro;

create table if not exists aqe_history.dynamo_persontype_history
(
    persontypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.dynamo_persontype_history
    owner to etluser;

grant select on aqe_history.dynamo_persontype_history to group named_user_ro;

create table if not exists aqe_history.feature_history
(
    featureid            bigint encode az64,
    name                 varchar(100),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.feature_history
    owner to etluser;

grant select on aqe_history.feature_history to group named_user_ro;

create table if not exists aqe_history.enrollment_history
(
    carrier_id             bigint encode az64,
    enrollmentid           bigint encode az64 distkey,
    enrollmentdate         timestamp encode az64,
    agentid                varchar(300),
    enrollmentformid       bigint encode az64,
    rawdata                varchar(256),
    startdate              timestamp encode az64,
    planid                 bigint encode az64,
    agentfirstname         varchar(50),
    agentlastname          varchar(50),
    agentemail             varchar(300),
    agenturl               varchar(100),
    userid                 bigint encode az64,
    premium                numeric(18, 2) encode az64,
    applicationtype        varchar(50) encode bytedict,
    sendtounderwriter      boolean,
    planyear               bigint encode az64,
    pharmacynpi            bigint encode az64,
    scopeofappointmentid   varchar(50),
    providernpi            bigint encode az64,
    confirmationid         varchar(50),
    externalleadid         varchar(50),
    ascendleadid           bigint encode az64,
    ascendmeetingid        bigint encode az64,
    beid                   bigint encode az64,
    miscnotes              varchar(500),
    browser                varchar(300),
    bluebuttonpatientid    varchar(300),
    requestedeffectivedate date encode az64,
    agentnpn               varchar(100),
    agentawn               varchar(100),
    ipaddress              varchar(50),
    useragent              varchar(1024),
    refresh_timestamp      timestamp,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollment_history
    owner to etluser;

grant select on aqe_history.enrollment_history to group named_user_ro;

create table if not exists aqe_history.projects_history
(
    pkproject            bigint encode az64,
    projectname          varchar(500),
    isactive             boolean,
    carrierfk            bigint encode az64,
    maxattempts          bigint encode az64,
    maxsmsattempts       bigint encode az64,
    maxemailattempts     bigint encode az64,
    maxivrattempts       bigint encode az64,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.projects_history
    owner to etluser;

grant select on aqe_history.projects_history to group named_user_ro;

create table if not exists aqe_history.product_history
(
    productid                   bigint encode az64,
    carrierid                   bigint encode az64,
    name                        varchar(256),
    producttypeid               bigint encode az64,
    additionalquestionsformid   bigint encode az64,
    premiummodifierequation     varchar(256),
    miscnotes                   varchar(500),
    displayorder                bigint encode az64,
    partialappexpiry            bigint encode az64,
    partialapplinkexpiry        bigint encode az64,
    isdeleted                   boolean,
    externalapisubmissionsusage boolean,
    subcarrierid                bigint encode az64 distkey,
    payerid                     bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table aqe_history.product_history
    owner to etluser;

grant select on aqe_history.product_history to group named_user_ro;

create table if not exists aqe_history.contenttype_history
(
    contenttypeid        bigint encode az64,
    projectfk            bigint encode az64,
    contentname          varchar(250),
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.contenttype_history
    owner to etluser;

grant select on aqe_history.contenttype_history to group named_user_ro;

create table if not exists aqe_history.contacttype_history
(
    contacttypeid        bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.contacttype_history
    owner to etluser;

grant select on aqe_history.contacttype_history to group named_user_ro;

create table if not exists aqe_history.vbestatuscode_history
(
    vbestatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.vbestatuscode_history
    owner to etluser;

grant select on aqe_history.vbestatuscode_history to group named_user_ro;

create table if not exists aqe_history.person_history
(
    carrier_id           bigint encode az64,
    personid             bigint encode az64 distkey,
    firstname            varchar(256),
    lastname             varchar(256),
    middlename           varchar(256) encode bytedict,
    nameprefix           varchar(50) encode bytedict,
    gender               varchar(256) encode bytedict,
    dob                  timestamp encode az64,
    retirementdate       timestamp encode az64,
    ssn                  varchar(256),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.person_history
    owner to etluser;

grant select on aqe_history.person_history to group named_user_ro;

create table if not exists aqe_history.awvinformationstatushistory_history
(
    carrier_id                    bigint encode az64,
    aveinformationstatushistoryid bigint encode az64,
    awvinformationid              bigint encode az64,
    awvstatusid                   bigint encode az64,
    statusupdatedate              timestamp encode az64,
    ascenduserid                  bigint encode az64 distkey,
    buttonid                      bigint encode az64,
    actionid                      bigint encode az64,
    refresh_timestamp             timestamp,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.awvinformationstatushistory_history
    owner to etluser;

grant select on aqe_history.awvinformationstatushistory_history to group named_user_ro;

create table if not exists aqe_history.enrollmentpharmacymap_history
(
    carrier_id              bigint encode az64,
    enrollmentpharmacymapid bigint encode az64,
    enrollmentid            bigint encode az64 distkey,
    pharmacynpi             varchar(50),
    innetwork               boolean,
    pharmacyname            varchar(256),
    retail                  boolean,
    mailorder               boolean,
    prefretail              boolean,
    prefmailorder           boolean,
    distance                double precision,
    miscnotes               varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32),
    record_version          bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentpharmacymap_history
    owner to etluser;

grant select on aqe_history.enrollmentpharmacymap_history to group named_user_ro;

create table if not exists aqe_history.preferredmethodsofcontact_history
(
    pkpreferredmethodsofcontact bigint encode az64,
    contactmethodname           varchar(100),
    isdeleted                   boolean,
    miscnotes                   varchar(256),
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table aqe_history.preferredmethodsofcontact_history
    owner to etluser;

grant select on aqe_history.preferredmethodsofcontact_history to group named_user_ro;

create table if not exists aqe_history.salesregion_history
(
    carrier_id           bigint encode az64 distkey,
    salesregionid        bigint encode az64,
    name                 varchar(100),
    description          varchar(256),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.salesregion_history
    owner to etluser;

grant select on aqe_history.salesregion_history to group named_user_ro;

create table if not exists aqe_history.leaddrugselections_history
(
    carrier_id           bigint encode az64,
    leaddrugselectionsid bigint encode az64,
    leadid               bigint encode az64 distkey,
    drugndc              varchar(255),
    chosendosage         varchar(256),
    chosenpackage        varchar(256),
    chosenfrequency      integer encode az64,
    chosenquantity       bigint encode az64,
    isactive             boolean,
    datecreated          timestamp encode az64,
    lastupdateddate      timestamp encode az64,
    miscnotes            varchar(256),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.leaddrugselections_history
    owner to etluser;

grant select on aqe_history.leaddrugselections_history to group named_user_ro;

create table if not exists aqe_history.enrollmentformtype_history
(
    enrollmentformtypeid          bigint encode az64,
    enrollmentformtypedescription varchar(100),
    miscnotes                     varchar(256),
    refresh_timestamp             timestamp encode az64,
    data_transfer_log_id          bigint encode az64,
    md5_hash                      varchar(32),
    record_version                bigint encode az64
);

alter table aqe_history.enrollmentformtype_history
    owner to etluser;

grant select on aqe_history.enrollmentformtype_history to group named_user_ro;

create table if not exists aqe_history.hrastatuscode_history
(
    hrastatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.hrastatuscode_history
    owner to etluser;

grant select on aqe_history.hrastatuscode_history to group named_user_ro;

create table if not exists aqe_history.routebyoutboundivr_history
(
    pkroutebyoutboundivr  bigint encode az64,
    projectfk             bigint encode az64,
    fromnumber            varchar(20),
    twilioaccountsid      varchar(100) distkey,
    twilioauthtoken       varchar(100),
    delay                 bigint encode az64,
    maxperrun             bigint encode az64,
    isactive              boolean,
    timeout               bigint encode az64,
    useamd                boolean,
    amdtimeout            bigint encode az64,
    amdspeechthreshold    bigint encode az64,
    amdspeechendthreshold bigint encode az64,
    amdsilencetimeout     bigint encode az64,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    callstarttime         varchar(64),
    callendtime           varchar(64),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table aqe_history.routebyoutboundivr_history
    owner to etluser;

grant select on aqe_history.routebyoutboundivr_history to group named_user_ro;

create table if not exists aqe_history.buttontype_history
(
    buttontypeid         bigint encode az64,
    type                 varchar(50),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.buttontype_history
    owner to etluser;

grant select on aqe_history.buttontype_history to group named_user_ro;

create table if not exists aqe_history.agentsalesregionmap_history
(
    carrier_id            bigint encode az64 distkey,
    agentsalesregionmapid bigint encode az64,
    agentid               bigint encode az64,
    salesregionid         bigint encode az64,
    isdeleted             boolean,
    miscnotes             varchar(500) encode bytedict,
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agentsalesregionmap_history
    owner to etluser;

grant select on aqe_history.agentsalesregionmap_history to group named_user_ro;

create table if not exists aqe_history.carrierfeaturemap_history
(
    carrierfeaturemapid  bigint encode az64,
    carrierid            bigint encode az64 distkey,
    featureid            bigint encode az64,
    isenabled            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.carrierfeaturemap_history
    owner to etluser;

grant select on aqe_history.carrierfeaturemap_history to group named_user_ro;

create table if not exists aqe_history.regionfipscodes_history
(
    carrier_id           bigint encode az64 distkey,
    regionfipscodesid    bigint encode az64,
    regionid             bigint encode az64,
    statefipscode        varchar(2),
    countyfipscode       varchar(3),
    stateabbreviation    varchar(2),
    county               varchar(256),
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.regionfipscodes_history
    owner to etluser;

grant select on aqe_history.regionfipscodes_history to group named_user_ro;

create table if not exists aqe_history.routes_history
(
    pkroute              bigint encode az64,
    projectfk            bigint encode az64,
    outreachtypefk       bigint encode az64,
    isactive             boolean,
    lastrundatetime      timestamp encode az64,
    timebetweenruns      bigint encode az64,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.routes_history
    owner to etluser;

grant select on aqe_history.routes_history to group named_user_ro;

create table if not exists aqe_history.vbeaudit_outreachlistmap_history
(
    carrier_id           bigint encode az64,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk bigint encode az64,
    memberinformationfk  bigint encode az64,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000) encode bytedict,
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.vbeaudit_outreachlistmap_history
    owner to etluser;

grant select on aqe_history.vbeaudit_outreachlistmap_history to group named_user_ro;

create table if not exists aqe_history.statustype_history
(
    statustypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.statustype_history
    owner to etluser;

grant select on aqe_history.statustype_history to group named_user_ro;

create table if not exists aqe_history.hrainformation_history
(
    carrier_id           bigint encode az64,
    hrainformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    hrastatusid          bigint encode az64,
    dynamicinformation   varchar(256),
    statusupdatedate     timestamp encode az64,
    ascenduserid         bigint encode az64,
    miscnotes            varchar(500),
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    savetotable          boolean,
    senttofile           boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.hrainformation_history
    owner to etluser;

grant select on aqe_history.hrainformation_history to group named_user_ro;

create table if not exists aqe_history.outreachmemberemailinfo_history
(
    carrier_id                bigint encode az64,
    pkoutreachmemberemailinfo bigint encode az64,
    outreachmemberinfofk      bigint encode az64,
    memberinformationfk       bigint encode az64,
    emailaddress              varchar(500) distkey,
    order_num                 bigint encode az64,
    emailattempts             bigint encode az64,
    isactive                  boolean,
    miscnotes                 varchar(256) encode bytedict,
    inserteddate              timestamp encode az64,
    validfrom                 timestamp encode az64,
    validto                   timestamp encode az64,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachmemberemailinfo_history
    owner to etluser;

grant select on aqe_history.outreachmemberemailinfo_history to group named_user_ro;

create table if not exists aqe_history.enrollmentbeqresponsemap_history
(
    carrier_id                 bigint encode az64,
    enrollmentbeqresponsemapid bigint encode az64 distkey,
    enrollmentid               bigint encode az64,
    beqresponseid              bigint encode az64,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentbeqresponsemap_history
    owner to etluser;

grant select on aqe_history.enrollmentbeqresponsemap_history to group named_user_ro;

create table if not exists aqe_history.outreachivrresults_history
(
    carrier_id            bigint encode az64,
    pkoutreachivrresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    ivroutreachactivityid varchar(100),
    calldirection         varchar(1000),
    ivrstartdatetime      timestamp encode az64,
    ivrenddatetime        timestamp encode az64,
    ivroutcome            varchar(1000) encode bytedict,
    ivrphonenumber        varchar(50),
    memberanswer          boolean,
    caregiveranswer       boolean,
    interviewagreement    boolean,
    hrainformationid      bigint encode az64 distkey,
    excludefromreporting  boolean,
    miscnotes             varchar(256) encode bytedict,
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachivrresults_history
    owner to etluser;

grant select on aqe_history.outreachivrresults_history to group named_user_ro;

create table if not exists aqe_history.leadpharmacyselections_history
(
    carrier_id               bigint encode az64,
    leadpharmacyselectionsid bigint encode az64,
    leadid                   bigint encode az64 distkey,
    pharmacynpi              bigint encode az64,
    isactive                 boolean,
    datecreated              timestamp encode az64,
    lastupdateddate          timestamp encode az64,
    miscnotes                varchar(256),
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    primarypharmacy          boolean,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.leadpharmacyselections_history
    owner to etluser;

grant select on aqe_history.leadpharmacyselections_history to group named_user_ro;

create table if not exists aqe_history.agentwritingnumber_history
(
    carrier_id           bigint encode az64,
    awnid                bigint encode az64 distkey,
    awn                  varchar(20),
    agentid              bigint encode az64,
    productid            bigint encode az64,
    isdeleted            boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.agentwritingnumber_history
    owner to etluser;

grant select on aqe_history.agentwritingnumber_history to group named_user_ro;

create table if not exists aqe_history.enrollmentformresponse_history
(
    carrier_id               bigint encode az64,
    enrollmentformresponseid bigint encode az64 distkey,
    enrollmentid             bigint encode az64,
    field                    varchar(256),
    formfieldstructureid     bigint encode az64,
    value                    varchar(8192),
    displaytext              varchar(1024),
    formelementid            bigint encode az64,
    miscnotes                varchar(500),
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
)
    diststyle key;

alter table aqe_history.enrollmentformresponse_history
    owner to etluser;

grant select on aqe_history.enrollmentformresponse_history to group named_user_ro;

create table if not exists aqe_history.routebysms_history
(
    pkroutebysms         bigint encode az64,
    projectfk            bigint encode az64,
    fromnumber           varchar(20),
    twilioaccountsid     varchar(100) distkey,
    twilioauthtoken      varchar(100),
    delay                bigint encode az64,
    maxperrun            bigint encode az64,
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.routebysms_history
    owner to etluser;

grant select on aqe_history.routebysms_history to group named_user_ro;

create table if not exists aqe_history.enrollmentprovidermap_history
(
    carrier_id                bigint encode az64,
    enrollmentprovidermapid   bigint encode az64,
    enrollmentid              bigint encode az64 distkey,
    clientlocationidentifier  varchar(50),
    npi                       varchar(50),
    isapplicantpcp            boolean,
    specialization            varchar(100),
    firstname                 varchar(128),
    lastname                  varchar(128),
    locationname              varchar(256),
    street1                   varchar(256),
    street2                   varchar(256),
    city                      varchar(256),
    state                     varchar(256) encode bytedict,
    zip                       varchar(256),
    phonenumber               varchar(50),
    groupname                 varchar(500),
    currentpatient            boolean,
    innetwork                 boolean,
    miscnotes                 varchar(500),
    zelisproviderenrollmentid varchar(20),
    pcpselectedbybeneficiary  boolean,
    isprovidermanuallyentered boolean,
    refresh_timestamp         timestamp,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentprovidermap_history
    owner to etluser;

grant select on aqe_history.enrollmentprovidermap_history to group named_user_ro;

create table if not exists aqe_history.vbeaudit_outreachemailresults_history
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000),
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64,
    excludefromreporting    boolean,
    miscnotes               varchar(256) encode bytedict,
    email                   varchar(256),
    oer_timestamp           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256) encode bytedict,
    category                varchar(256),
    sg_content_type         varchar(256),
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(512),
    attempt                 varchar(256) encode bytedict,
    useragent               varchar(512),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(3072),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32),
    record_version          bigint encode az64
);

alter table aqe_history.vbeaudit_outreachemailresults_history
    owner to etluser;

grant select on aqe_history.vbeaudit_outreachemailresults_history to group named_user_ro;

create table if not exists aqe_history.schedulinginformation_history
(
    carrier_id              bigint encode az64,
    schedulinginformationid bigint encode az64,
    memberinformationid     bigint encode az64 distkey,
    timeoffset              integer encode az64,
    starttime               timestamp encode az64,
    endtime                 timestamp encode az64,
    timesenttocallcenter    timestamp encode az64,
    timezone                varchar(100),
    isdeleted               boolean,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32),
    record_version          bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.schedulinginformation_history
    owner to etluser;

grant select on aqe_history.schedulinginformation_history to group named_user_ro;

create table if not exists aqe_history.outreachtypes_history
(
    pkoutreachtype       bigint encode az64,
    outreachtype         varchar(100),
    isactive             boolean,
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.outreachtypes_history
    owner to etluser;

grant select on aqe_history.outreachtypes_history to group named_user_ro;

create table if not exists aqe_history.vbeinformation_history
(
    carrier_id           bigint encode az64,
    vbeinformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    vbestatusid          bigint encode az64,
    statusupdatedate     timestamp encode az64,
    ascenduserid         bigint encode az64,
    miscnotes            varchar(500),
    formid               bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.vbeinformation_history
    owner to etluser;

grant select on aqe_history.vbeinformation_history to group named_user_ro;

create table if not exists aqe_history.outreachportalresults_history
(
    carrier_id               bigint encode az64,
    pkoutreachportalresults  bigint encode az64,
    outreachmemberinfofk     bigint encode az64,
    memberinformationfk      bigint encode az64,
    portaloutreachactivityid varchar(100),
    activitydate             timestamp encode az64,
    activityoutcome          varchar(255),
    interviewagreement       varchar(50),
    hrainformationid         bigint encode az64 distkey,
    agentfk                  bigint encode az64,
    excludefromreporting     boolean,
    miscnotes                varchar(1024),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachportalresults_history
    owner to etluser;

grant select on aqe_history.outreachportalresults_history to group named_user_ro;

create table if not exists aqe_history.enrollmentstatus_history
(
    carrier_id                   bigint encode az64,
    enrollmentstatusid           bigint encode az64 distkey,
    enrollmentid                 bigint encode az64,
    datesenttocallcenter         timestamp encode az64,
    datedeliveredtoclient        timestamp encode az64,
    sendtoclient                 boolean,
    miscnotes                    varchar(500) encode bytedict,
    externalenrollmentstatusid   bigint encode az64,
    externalenrollmentstatusdate timestamp encode az64,
    adhocexecution               boolean,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentstatus_history
    owner to etluser;

grant select on aqe_history.enrollmentstatus_history to group named_user_ro;

create table if not exists aqe_history.partialapplications_history
(
    carrier_id                  bigint encode az64,
    partialapplicationid        bigint encode az64,
    userid                      bigint encode az64,
    agentid                     varchar(200),
    formid                      bigint encode az64,
    planid                      bigint encode az64,
    planyear                    bigint encode az64,
    applicationtype             bigint encode az64,
    marketingcode               varchar(256),
    agentfirstname              varchar(256),
    agentlastname               varchar(256),
    agentemail                  varchar(256),
    firstname                   varchar(256),
    lastname                    varchar(256),
    dateofbirth                 timestamp encode az64,
    applicationdata             varchar(256),
    applicationformrestoredata  varchar(256),
    pharmacynpi                 bigint encode az64,
    providernpi                 bigint encode az64,
    datesaved                   timestamp encode az64,
    enrollmentid                bigint encode az64 distkey,
    isapplicationcomplete       boolean,
    isreturnablebyagent         boolean,
    scopeofappointmentid        varchar(50),
    expirationdatetime          timestamp encode az64,
    isdeleted                   boolean,
    miscnotes                   varchar(500),
    isreachedapplicationsummary boolean,
    browser                     varchar(256),
    guidsessiondata             varchar(256),
    consumerapptrackingcode     varchar(50),
    beid                        bigint encode az64,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table aqe_history.partialapplications_history
    owner to etluser;

grant select on aqe_history.partialapplications_history to group named_user_ro;

create table if not exists aqe_history.outreachroutedonotcontact_history
(
    carrier_id                  bigint encode az64,
    pkoutreachroutedonotcontact bigint encode az64,
    contact                     varchar(255),
    sms                         boolean,
    email                       boolean,
    call                        boolean,
    inserteddate                timestamp encode az64,
    validfrom                   timestamp encode az64,
    validto                     timestamp encode az64,
    refresh_timestamp           timestamp,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table aqe_history.outreachroutedonotcontact_history
    owner to etluser;

grant select on aqe_history.outreachroutedonotcontact_history to group named_user_ro;

create table if not exists aqe_history.emailbyoutreachattempt_history
(
    pkemailbyoutreachattempt bigint encode az64 distkey,
    routebyemailfk           bigint encode az64,
    twiliolanguagefk         bigint encode az64,
    emailbody                varchar(10240),
    fromaddress              varchar(100),
    fromname                 varchar(100),
    subject                  varchar(100),
    outreachattempt          bigint encode az64,
    isactive                 boolean,
    contenttypefk            bigint encode az64,
    miscnotes                varchar(256),
    inserteddate             timestamp encode az64,
    validfrom                timestamp encode az64,
    validto                  timestamp encode az64,
    refresh_timestamp        timestamp encode az64,
    data_transfer_log_id     bigint encode az64,
    md5_hash                 varchar(32),
    record_version           bigint encode az64
);

alter table aqe_history.emailbyoutreachattempt_history
    owner to etluser;

grant select on aqe_history.emailbyoutreachattempt_history to group named_user_ro;

create table if not exists aqe_history.enrollmentwipro_history
(
    carrier_id           bigint encode az64,
    enrollmentwiproid    bigint encode az64 distkey,
    enrollmentid         bigint encode az64,
    wiproid              bigint encode az64,
    date                 timestamp encode az64,
    planyear             bigint encode az64,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.enrollmentwipro_history
    owner to etluser;

grant select on aqe_history.enrollmentwipro_history to group named_user_ro;

create table if not exists aqe_history.wipro_history
(
    carrier_id                 bigint encode az64,
    wiproid                    bigint encode az64,
    txndate                    varchar(256),
    mbdloadeffdate             varchar(256),
    requesthicnbr              varchar(256),
    requestlastname            varchar(256),
    requestdob                 varchar(256),
    foundhicnbr                varchar(256) encode bytedict,
    foundnameordob             varchar(256) encode bytedict,
    inquiryresponse            varchar(256) encode bytedict,
    hicnbr                     varchar(256),
    lastname                   varchar(256),
    firstname                  varchar(256),
    middleinitial              varchar(256) encode bytedict,
    gendercd                   varchar(256) encode bytedict,
    racecd                     varchar(256) encode bytedict,
    birthdate                  varchar(256),
    prtaentitlementdate        varchar(256),
    prtaentitleenddate         varchar(256),
    prtbentitlementdate        varchar(256),
    prtbentitleenddate         varchar(256),
    statecd                    varchar(256) encode bytedict,
    countycd                   varchar(256),
    hospicestatus              varchar(256),
    hospicestartdate           varchar(256),
    hospiceenddate             varchar(256),
    inststatus                 varchar(256),
    inststartdate              varchar(256),
    instenddate                varchar(256),
    esrdstatus                 varchar(256) encode bytedict,
    esrdstartdate              varchar(256),
    esrdenddate                varchar(256),
    medicaidstatus             varchar(256) encode bytedict,
    medicaidstartdate          varchar(256),
    medicaidenddate            varchar(256),
    eghpind                    varchar(256),
    livingstatus               varchar(256) encode bytedict,
    deathdate                  varchar(256),
    xrefhicnbr                 varchar(256),
    potentialuncvrdmths        varchar(256) encode bytedict,
    potentialuncvrdmthseffdate varchar(256) encode bytedict,
    prtdeligibledate           varchar(256),
    planyear                   bigint encode az64,
    miscnotes                  varchar(500),
    wiprojson                  varchar(8192),
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
);

alter table aqe_history.wipro_history
    owner to etluser;

grant select on aqe_history.wipro_history to group named_user_ro;

create table if not exists aqe_history.outreachccsresults_history
(
    carrier_id                   bigint encode az64,
    pkoutreachccsresults         bigint encode az64,
    outreachmemberinfofk         bigint encode az64,
    memberinformationfk          bigint encode az64,
    ccsoutreachactivityid        varchar(100),
    contactinfofk                bigint encode az64,
    dateofcall                   timestamp encode az64,
    pkcallresults                bigint encode az64,
    poolfk                       bigint encode az64,
    contactnumber                varchar(50),
    callresultcode               varchar(100) encode bytedict,
    callresultdescription        varchar(500) encode bytedict,
    agentfk                      bigint encode az64,
    hrainformationid             bigint encode az64 distkey,
    interviewagreement           varchar(50) encode bytedict,
    recordingfilename            varchar(500),
    fullrecordingfilepathandname varchar(256),
    excludefromreporting         boolean,
    miscnotes                    varchar(256),
    inserteddate                 timestamp encode az64,
    validfrom                    timestamp encode az64,
    validto                      timestamp encode az64,
    refresh_timestamp            timestamp,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachccsresults_history
    owner to etluser;

grant select on aqe_history.outreachccsresults_history to group named_user_ro;

create table if not exists aqe_history.awvinformation_history
(
    carrier_id           bigint encode az64,
    awvinformationid     bigint encode az64,
    memberinformationid  bigint encode az64,
    awvstatusid          bigint encode az64,
    miscnotes            varchar(500),
    statusupdatedate     timestamp encode az64,
    providername         varchar(100),
    appointmentdate      timestamp encode az64,
    npi                  bigint encode az64,
    confirmeddate        timestamp encode az64,
    pcpphone             varchar(10),
    pcpstreet1           varchar(256),
    pcpstreet2           varchar(256),
    pcpcity              varchar(100),
    pcpstate             varchar(2),
    pcpzip               varchar(10),
    timezone             varchar(100) encode bytedict,
    ascenduserid         bigint encode az64 distkey,
    buttonid             bigint encode az64,
    actionid             bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.awvinformation_history
    owner to etluser;

grant select on aqe_history.awvinformation_history to group named_user_ro;

create table if not exists aqe_history.outreachsmsresults_history
(
    carrier_id            bigint encode az64,
    pkoutreachsmsresults  bigint encode az64,
    outreachmemberinfofk  bigint encode az64,
    memberinformationfk   bigint encode az64,
    smsoutreachactivityid varchar(100),
    smsstartdatetime      timestamp encode az64,
    smsenddatetime        timestamp encode az64,
    smsoutcome            varchar(1000) encode bytedict,
    smssentphonenumber    varchar(50),
    hrainformationid      bigint encode az64,
    excludefromreporting  boolean,
    miscnotes             varchar(256),
    account_sid           varchar(256),
    api_version           varchar(256),
    body                  varchar(2024),
    date_updated          timestamp encode az64,
    direction             varchar(256),
    error_code            varchar(256),
    error_message         varchar(256),
    from_sms              varchar(256),
    messaging_service_sid varchar(256),
    num_media             varchar(256),
    num_segments          varchar(256),
    price                 varchar(256),
    price_unit            varchar(256),
    sid                   varchar(256),
    status                varchar(256) encode bytedict,
    to_sms                varchar(256),
    uri                   varchar(256),
    inserteddate          timestamp encode az64,
    validfrom             timestamp encode az64,
    validto               timestamp encode az64,
    projectfk             bigint encode az64,
    outreachattemptfk     bigint encode az64,
    outreachlistfk        bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table aqe_history.outreachsmsresults_history
    owner to etluser;

grant select on aqe_history.outreachsmsresults_history to group named_user_ro;

create table if not exists aqe_history.awvstatuscode_history
(
    awvstatuscodeid      bigint encode az64 distkey,
    name                 varchar(50),
    description          varchar(500),
    miscnotes            varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table aqe_history.awvstatuscode_history
    owner to etluser;

grant select on aqe_history.awvstatuscode_history to group named_user_ro;

create table if not exists aqe_history.actiontracking_history
(
    carrier_id           bigint encode az64,
    actiontrackingid     bigint encode az64,
    memberinformationid  bigint encode az64,
    buttonid             bigint encode az64,
    vbeactionid          bigint encode az64,
    actiondatetime       timestamp encode az64,
    ascenduserid         bigint encode az64 distkey,
    isactioncomplete     boolean,
    miscnotes            varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.actiontracking_history
    owner to etluser;

grant select on aqe_history.actiontracking_history to group named_user_ro;

create table if not exists aqe_history.smsbyoutreachattempt_history
(
    pksmsbyoutreachattempt bigint encode az64,
    routebysmsfk           bigint encode az64,
    twiliolanguagefk       bigint encode az64,
    smstext                varchar(512),
    outreachattempt        bigint encode az64,
    isactive               boolean,
    contenttypefk          bigint encode az64,
    miscnotes              varchar(256),
    inserteddate           timestamp encode az64,
    validfrom              timestamp encode az64,
    validto                timestamp encode az64,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table aqe_history.smsbyoutreachattempt_history
    owner to etluser;

grant select on aqe_history.smsbyoutreachattempt_history to group named_user_ro;

create table if not exists aqe_history.outreachemailresults_history
(
    carrier_id              bigint encode az64,
    pkoutreachemailresults  bigint encode az64,
    outreachmemberinfofk    bigint encode az64,
    memberinformationfk     bigint encode az64,
    emailoutreachactivityid varchar(100),
    emailstartdatetime      timestamp encode az64,
    emailenddatetime        timestamp encode az64,
    emailoutcome            varchar(1000) encode bytedict,
    inserteddate            timestamp encode az64,
    hrainformationid        bigint encode az64 distkey,
    excludefromreporting    boolean,
    miscnotes               varchar(1024) encode bytedict,
    email                   varchar(256),
    timestamp_num           bigint encode az64,
    smtpid                  varchar(256),
    event                   varchar(256) encode bytedict,
    category                varchar(256),
    sg_content_type         varchar(256) encode bytedict,
    sg_eventid              varchar(256),
    sg_message_id           varchar(256),
    response                varchar(2048),
    attempt                 varchar(256) encode bytedict,
    useragent               varchar(1024),
    ip                      varchar(256),
    url                     varchar(256),
    urloffset               varchar(256),
    reason                  varchar(4096),
    status                  varchar(256),
    asm_group_id            bigint encode az64,
    type                    varchar(256),
    validfrom               timestamp encode az64,
    validto                 timestamp encode az64,
    projectfk               bigint encode az64,
    outreachattemptfk       bigint encode az64,
    outreachlistfk          bigint encode az64,
    refresh_timestamp       timestamp,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32),
    record_version          bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachemailresults_history
    owner to etluser;

grant select on aqe_history.outreachemailresults_history to group named_user_ro;

create table if not exists aqe_history.quickquote_history
(
    carrier_id           bigint encode az64,
    quickquoteid         bigint encode az64,
    displayid            varchar(256),
    userid               bigint encode az64 distkey,
    firstname            varchar(100),
    lastname             varchar(100),
    email                varchar(500),
    phone                varchar(50),
    zipcode              varchar(10),
    statefipscode        varchar(2),
    countyfipscode       varchar(3),
    county               varchar(50),
    state                varchar(50) encode bytedict,
    sendtoenrollment     boolean,
    sentdate             timestamp encode az64,
    expirationdate       timestamp encode az64,
    verificationcode     varchar(50),
    expirationdatepii    timestamp encode az64,
    agentnpn             varchar(256),
    confirmationid       varchar(50),
    partialapplicationid bigint encode az64,
    beid                 bigint encode az64,
    ascendleadid         bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.quickquote_history
    owner to etluser;

grant select on aqe_history.quickquote_history to group named_user_ro;

create table if not exists aqe_history.applicationstatus_history
(
    applicationstatusid          bigint encode az64,
    applicationstatusdescription varchar(100),
    refresh_timestamp            timestamp encode az64,
    data_transfer_log_id         bigint encode az64,
    md5_hash                     varchar(32),
    record_version               bigint encode az64
);

alter table aqe_history.applicationstatus_history
    owner to etluser;

grant select on aqe_history.applicationstatus_history to group named_user_ro;

create table if not exists aqe_history.outreachlistmap_history
(
    carrier_id           bigint encode az64 distkey,
    pkoutreachlistmap    bigint encode az64,
    outreachmemberinfofk bigint encode az64,
    memberinformationfk  bigint encode az64,
    outreachlistfk       bigint encode az64,
    listsource           varchar(1000) encode bytedict,
    isactive             boolean,
    miscnotes            varchar(256),
    inserteddate         timestamp encode az64,
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table aqe_history.outreachlistmap_history
    owner to etluser;

grant select on aqe_history.outreachlistmap_history to group named_user_ro;

create table if not exists asc_history.customprospectdata_history
(
    ascend_carrier_id      bigint encode az64,
    prospectcustomobjectid bigint encode az64,
    prospectid             bigint encode az64,
    externalid             varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    notes                  varchar(150),
    audituserid            bigint encode az64 distkey,
    campaignmemberid       varchar(256),
    salesforceid           varchar(256),
    campaignmemberobject   varchar(256),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.customprospectdata_history
    owner to etluser;

grant select on asc_history.customprospectdata_history to group named_user_ro;

create table if not exists asc_history.leadsource_custom_history
(
    ascend_carrier_id    bigint encode az64,
    sourceid             bigint encode az64,
    businessentityid     bigint encode az64,
    leadsource           varchar(300),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadsource_custom_history
    owner to etluser;

grant select on asc_history.leadsource_custom_history to group named_user_ro;

create table if not exists asc_history.dispositiontypedisposition_map_base_history
(
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.dispositiontypedisposition_map_base_history
    owner to etluser;

grant select on asc_history.dispositiontypedisposition_map_base_history to group named_user_ro;

create table if not exists asc_history.appointmentuser_map_history
(
    ascend_carrier_id    bigint encode az64,
    mapapptuserid        bigint encode az64 distkey,
    businessentityid     bigint encode az64,
    apptid               bigint encode az64,
    userid               bigint encode az64,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.appointmentuser_map_history
    owner to etluser;

grant select on asc_history.appointmentuser_map_history to group named_user_ro;

create table if not exists asc_history.eventsprospectmap_history
(
    ascend_carrier_id    bigint encode az64,
    eventprospectmapid   bigint encode az64,
    eventid              bigint encode az64,
    prospectid           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventsprospectmap_history
    owner to etluser;

grant select on asc_history.eventsprospectmap_history to group named_user_ro;

create table if not exists asc_history.hvv2appointments_history
(
    ascend_carrier_id    bigint,
    hvv2appointmentid    bigint encode az64,
    beid                 bigint encode az64,
    leadid               bigint encode az64,
    userid               bigint encode az64 distkey,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    durationinminutes    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    meetinghistoryid     bigint encode az64,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    hvv2scheduleid       bigint encode az64,
    regionid             bigint encode az64,
    languageid           bigint encode az64,
    isdeleted            boolean,
    isvirtual            boolean,
    meetingcode          varchar(50),
    recordingurl         varchar(256),
    agentmeetinglink     varchar(256),
    guestmeetinglink     varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.hvv2appointments_history
    owner to etluser;

grant select on asc_history.hvv2appointments_history to group named_user_ro;

create table if not exists asc_history.formsubmissiondata_history
(
    ascend_carrier_id    bigint,
    formsubmissiondataid bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    formpageelementmapid bigint encode az64,
    value                varchar(8192),
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.formsubmissiondata_history
    owner to etluser;

grant select on asc_history.formsubmissiondata_history to group named_user_ro;

create table if not exists asc_history.messagetarget_map_history
(
    ascend_carrier_id    bigint,
    mapmessagetargetid   bigint encode az64,
    businessentityid     bigint encode az64,
    messageid            bigint encode az64,
    userid               bigint encode az64 distkey,
    groupid              bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.messagetarget_map_history
    owner to etluser;

grant select on asc_history.messagetarget_map_history to group named_user_ro;

create table if not exists asc_history.leadsviewrules_history
(
    ascend_carrier_id    bigint encode az64,
    leadviewid           bigint,
    beid                 bigint encode az64,
    name                 varchar(50),
    rule                 varchar(9216),
    xmlrule              varchar(9216),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (leadviewid);

alter table asc_history.leadsviewrules_history
    owner to etluser;

grant select on asc_history.leadsviewrules_history to group named_user_ro;

create table if not exists asc_history.availableagents_history
(
    ascend_carrier_id    bigint encode az64,
    availableid          bigint,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    startdatetime        timestamp encode az64,
    enddatetime          timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (availableid);

alter table asc_history.availableagents_history
    owner to etluser;

grant select on asc_history.availableagents_history to group named_user_ro;

create table if not exists asc_history.userdetails_history
(
    ascend_carrier_id    bigint,
    userdetailsid        bigint encode az64,
    userid               bigint encode az64 distkey,
    beid                 bigint encode az64,
    primaryphone         varchar(15),
    officephone          varchar(15),
    homephone            varchar(15),
    mobilephone          varchar(15),
    fax                  varchar(15),
    address              varchar(50),
    city                 varchar(50),
    state                varchar(2),
    zipcode              varchar(5),
    extusername          varchar(150),
    extpassword          varchar(150),
    useenrollurl         boolean,
    leadgeneration       boolean,
    skilllevel           bigint encode az64,
    userurl              varchar(500),
    userate              boolean,
    enrollmentphone      varchar(20),
    contactnumbersid     varchar(50),
    natpronum            varchar(10),
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    ratecallforwardingid bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.userdetails_history
    owner to etluser;

grant select on asc_history.userdetails_history to group named_user_ro;

create table if not exists asc_history.dispositiontypes_base_history
(
    dispositiontypeid    bigint encode az64,
    code                 varchar(50),
    description          varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table asc_history.dispositiontypes_base_history
    owner to etluser;

grant select on asc_history.dispositiontypes_base_history to group named_user_ro;

create table if not exists asc_history.faxstatus_base_history
(
    faxstatusid          bigint encode az64,
    efaxid               bigint encode az64,
    faxstatus            varchar(256),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.faxstatus_base_history
    owner to etluser;

grant select on asc_history.faxstatus_base_history to group named_user_ro;

create table if not exists asc_history.emailtemplatetrack_history
(
    ascend_carrier_id    bigint encode az64,
    emailtemplatetrackid bigint encode az64,
    beid                 bigint encode az64,
    templateid           varchar(100),
    datetimesent         timestamp,
    senderuserid         bigint encode az64 distkey,
    receiveruserid       bigint encode az64,
    receiveremail        varchar(100),
    response             varchar(100),
    notes                varchar(1000),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (datetimesent);

alter table asc_history.emailtemplatetrack_history
    owner to etluser;

grant select on asc_history.emailtemplatetrack_history to group named_user_ro;

create table if not exists asc_history.platformtype_history
(
    platformtypeid       bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.platformtype_history
    owner to etluser;

grant select on asc_history.platformtype_history to group named_user_ro;

create table if not exists asc_history.ascendisf_map_history
(
    ascendisfid          bigint,
    beid                 bigint encode az64,
    isfcarrierid         bigint encode az64,
    isfcarriername       varchar(50),
    notes                varchar(255),
    audituserid          bigint encode az64 distkey,
    isdeleted            boolean,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascendisfid);

alter table asc_history.ascendisf_map_history
    owner to etluser;

grant select on asc_history.ascendisf_map_history to group named_user_ro;

create table if not exists asc_history.itemtype_base_history
(
    ascend_carrier_id    bigint encode az64,
    itemtypeid           bigint encode az64,
    beid                 bigint encode az64,
    itemtype             varchar(50),
    itemtablename        varchar(50),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.itemtype_base_history
    owner to etluser;

grant select on asc_history.itemtype_base_history to group named_user_ro;

create table if not exists asc_history.appointmentsubscription_map_history
(
    ascend_carrier_id    bigint encode az64,
    subscriptionid       bigint encode az64,
    businessentityid     bigint encode az64,
    apptid               bigint encode az64,
    leadid               bigint encode az64,
    prospectid           bigint encode az64,
    generalseats         bigint encode az64,
    isactive             boolean,
    attendedappointment  boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    passcode             varchar(100),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.appointmentsubscription_map_history
    owner to etluser;

grant select on asc_history.appointmentsubscription_map_history to group named_user_ro;

create table if not exists asc_history.sfcustomprospectdata_history
(
    ascend_carrier_id      bigint encode az64,
    sfcustomprospectdataid bigint encode az64,
    prospectid             bigint encode az64,
    salesforceid           varchar(100),
    columnname             varchar(100),
    datatype               varchar(100),
    value                  varchar(256),
    datecreated            timestamp encode az64,
    datemodified           timestamp encode az64,
    audituserid            bigint encode az64 distkey,
    notes                  varchar(500),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.sfcustomprospectdata_history
    owner to etluser;

grant select on asc_history.sfcustomprospectdata_history to group named_user_ro;

create table if not exists asc_history.eventsstatus_base_history
(
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventsstatus_base_history
    owner to etluser;

grant select on asc_history.eventsstatus_base_history to group named_user_ro;

create table if not exists asc_history.itemtype_custom_history
(
    ascend_carrier_id    bigint encode az64,
    itemtypeid           bigint encode az64,
    beid                 bigint encode az64,
    itemtype             varchar(50),
    itemtablename        varchar(50),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.itemtype_custom_history
    owner to etluser;

grant select on asc_history.itemtype_custom_history to group named_user_ro;

create table if not exists asc_history.faxtransmissions_history
(
    ascend_carrier_id         bigint encode az64,
    faxtransmissionid         bigint encode az64,
    leadid                    bigint encode az64,
    userid                    bigint encode az64 distkey,
    faxstatus                 varchar(256),
    tofaxnumber               varchar(50),
    externalfaxtransmissionid varchar(256),
    paperid                   varchar(100),
    soaid                     varchar(100),
    docid                     varchar(100),
    faxdatetime               timestamp encode az64,
    notes                     varchar(500),
    audituserid               bigint encode az64,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
);

alter table asc_history.faxtransmissions_history
    owner to etluser;

grant select on asc_history.faxtransmissions_history to group named_user_ro;

create table if not exists asc_history.elementtype_history
(
    elementtypeid        bigint encode az64 distkey,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.elementtype_history
    owner to etluser;

grant select on asc_history.elementtype_history to group named_user_ro;

create table if not exists asc_history.loginattempts_history
(
    loginattemptsid      bigint encode az64,
    loginattempts        bigint encode az64,
    userid               bigint encode az64 distkey,
    counter              bigint encode az64,
    dateentered          timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.loginattempts_history
    owner to etluser;

grant select on asc_history.loginattempts_history to group named_user_ro;

create table if not exists asc_history.licenseformfirmtypes_history
(
    licenseformfirmtypesid bigint encode az64,
    firmtypeid             bigint encode az64,
    displayname            varchar(100),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.licenseformfirmtypes_history
    owner to etluser;

grant select on asc_history.licenseformfirmtypes_history to group named_user_ro;

create table if not exists asc_history.leadstatus_custom_history
(
    ascend_carrier_id    bigint encode az64,
    statusid             bigint encode az64,
    businessentityid     bigint encode az64,
    leadstatus           varchar(300),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadstatus_custom_history
    owner to etluser;

grant select on asc_history.leadstatus_custom_history to group named_user_ro;

create table if not exists asc_history.usersession_history
(
    usersessionid        bigint encode az64 distkey,
    userid               bigint encode az64,
    clientid             bigint encode az64,
    sessionstartdatetime timestamp encode az64,
    sessionenddatetime   timestamp encode az64,
    useragent            varchar(256) encode bytedict,
    buildversion         varchar(50) encode bytedict,
    osversion            varchar(50) encode bytedict,
    ipaddress            varchar(50),
    iscellular           boolean,
    iswifi               boolean,
    devicetype           varchar(100),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.usersession_history
    owner to etluser;

grant select on asc_history.usersession_history to group named_user_ro;

create table if not exists asc_history.leadstatus_base_history
(
    statusid             bigint encode az64,
    leadstatus           varchar(50),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadstatus_base_history
    owner to etluser;

grant select on asc_history.leadstatus_base_history to group named_user_ro;

create table if not exists asc_history.zones_history
(
    ascend_carrier_id    bigint encode az64,
    zoneid               bigint encode az64,
    beid                 bigint encode az64,
    zone                 varchar(50),
    county               varchar(50),
    isactive             boolean,
    notes                varchar(150),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.zones_history
    owner to etluser;

grant select on asc_history.zones_history to group named_user_ro;

create table if not exists asc_history.businessentityuser_map_history
(
    businessentityusermapid bigint encode az64 distkey,
    carrierid               bigint encode az64,
    businessentityid        bigint encode az64,
    userid                  bigint encode az64,
    userstatus              varchar(1),
    notes                   varchar(256) encode bytedict,
    audituserid             bigint encode az64,
    refresh_timestamp       timestamp encode az64,
    data_transfer_log_id    bigint encode az64,
    md5_hash                varchar(32),
    record_version          bigint encode az64
);

alter table asc_history.businessentityuser_map_history
    owner to etluser;

grant select on asc_history.businessentityuser_map_history to group named_user_ro;

create table if not exists asc_history.appointments_history
(
    ascend_carrier_id    bigint encode az64,
    apptid               bigint encode az64,
    beid                 bigint encode az64,
    appttypeid           bigint encode az64,
    description          varchar(100),
    location             varchar(200),
    date_time            timestamp encode az64,
    address              varchar(100),
    city                 varchar(50),
    state                varchar(2),
    zip                  varchar(5),
    phone                varchar(10),
    website              varchar(256),
    capacity             bigint encode az64,
    zoneid               bigint encode az64,
    seatstaken           bigint encode az64,
    cancelled            boolean,
    notes                varchar(150),
    audituserid          bigint encode az64 distkey,
    isprivate            boolean,
    imagelocation        varchar(500),
    reservedseats        bigint encode az64,
    virtualmeetinglink   varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.appointments_history
    owner to etluser;

grant select on asc_history.appointments_history to group named_user_ro;

create table if not exists asc_history.appointmenttagsmap_history
(
    ascend_carrier_id    bigint encode az64,
    appointmenttagsmapid bigint encode az64,
    beid                 bigint encode az64,
    apptid               bigint encode az64,
    tagid                bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.appointmenttagsmap_history
    owner to etluser;

grant select on asc_history.appointmenttagsmap_history to group named_user_ro;

create table if not exists asc_history.meetings_history
(
    ascend_carrier_id          bigint encode az64,
    meetinghistoryid           bigint encode az64,
    beid                       bigint encode az64,
    userid                     bigint encode az64 distkey,
    token                      varchar(100),
    isrecorded                 boolean,
    address                    varchar(100),
    city                       varchar(100),
    state                      varchar(50) encode bytedict,
    zipcode                    varchar(50),
    latitude                   varchar(50),
    longitude                  varchar(50),
    startdatetime              timestamp encode az64,
    enddatetime                timestamp encode az64,
    disposition                bigint encode az64,
    dispositiontype            bigint encode az64,
    filename                   varchar(50),
    checksum                   varchar(50),
    filesize                   varchar(50),
    isrecordinguploaded        boolean,
    soaid                      varchar(125),
    notes                      varchar(256) encode bytedict,
    audituserid                bigint encode az64,
    transcriptionrequestid     varchar(50),
    transcriptionrequeststatus varchar(50),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
);

alter table asc_history.meetings_history
    owner to etluser;

grant select on asc_history.meetings_history to group named_user_ro;

create table if not exists asc_history.regionlocationmap_history
(
    ascend_carrier_id    bigint encode az64,
    regionlocationid     bigint encode az64,
    regionid             bigint encode az64,
    state                varchar(50) encode bytedict,
    statefipscode        bigint encode az64,
    county               varchar(100),
    countyfipscode       bigint encode az64,
    zipcode              varchar(5),
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.regionlocationmap_history
    owner to etluser;

grant select on asc_history.regionlocationmap_history to group named_user_ro;

create table if not exists asc_history.isfawntype_history
(
    ascend_carrier_id    bigint encode az64,
    isfawntypeid         bigint encode az64,
    beid                 bigint encode az64,
    description          varchar(255),
    code                 varchar(10),
    isdeleted            boolean,
    notes                varchar(255),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table asc_history.isfawntype_history
    owner to etluser;

grant select on asc_history.isfawntype_history to group named_user_ro;

create table if not exists asc_history.help_definition_type_history
(
    id                    bigint encode az64 distkey,
    help_type_code        bigint encode az64,
    displayorder          bigint encode az64,
    help_type_description varchar(50),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table asc_history.help_definition_type_history
    owner to etluser;

grant select on asc_history.help_definition_type_history to group named_user_ro;

create table if not exists asc_history.hvappointmentmeetingmap_history
(
    ascend_carrier_id         bigint encode az64,
    hvappointmentmeetingmapid bigint encode az64,
    hvappointmentid           bigint encode az64,
    meetinghistoryid          bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
);

alter table asc_history.hvappointmentmeetingmap_history
    owner to etluser;

grant select on asc_history.hvappointmentmeetingmap_history to group named_user_ro;

create table if not exists asc_history.help_definitions_history
(
    id                   bigint encode az64 distkey,
    definitionlabel      varchar(50),
    definition           varchar(200),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.help_definitions_history
    owner to etluser;

grant select on asc_history.help_definitions_history to group named_user_ro;

create table if not exists asc_history.faxnumbers_history
(
    ascend_carrier_id    bigint encode az64,
    faxnumberid          bigint encode az64,
    beid                 bigint encode az64,
    tofaxnumber          varchar(50),
    description          varchar(100),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.faxnumbers_history
    owner to etluser;

grant select on asc_history.faxnumbers_history to group named_user_ro;

create table if not exists asc_history.leadqueues_history
(
    ascend_carrier_id    bigint encode az64,
    id                   bigint encode az64,
    beid                 bigint encode az64,
    name                 varchar(50),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadqueues_history
    owner to etluser;

grant select on asc_history.leadqueues_history to group named_user_ro;

create table if not exists asc_history.permissionlead_map_history
(
    ascend_carrier_id    bigint encode az64,
    id                   bigint encode az64,
    beid                 bigint encode az64,
    leadid               bigint encode az64,
    permissionid         bigint encode az64,
    audituserid          bigint encode az64 distkey,
    notes                varchar(256) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.permissionlead_map_history
    owner to etluser;

grant select on asc_history.permissionlead_map_history to group named_user_ro;

create table if not exists asc_history.eventsagentmap_history
(
    ascend_carrier_id    bigint encode az64,
    eventagentmapid      bigint encode az64,
    eventid              bigint encode az64,
    userid               bigint encode az64 distkey,
    isdeleted            boolean,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventsagentmap_history
    owner to etluser;

grant select on asc_history.eventsagentmap_history to group named_user_ro;

create table if not exists asc_history.isfuserawn_map_history
(
    ascend_carrier_id    bigint encode az64,
    isfuserawnid         bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    awn                  varchar(20),
    isfawntype           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(255) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.isfuserawn_map_history
    owner to etluser;

grant select on asc_history.isfuserawn_map_history to group named_user_ro;

create table if not exists asc_history.events_history
(
    ascend_carrier_id    bigint encode az64,
    eventid              bigint encode az64,
    eventtypeid          bigint encode az64,
    beid                 bigint encode az64,
    eventstartdatetime   timestamp encode az64,
    eventdurationid      bigint encode az64,
    eventstatusid        bigint encode az64,
    eventcreatedate      timestamp encode az64,
    isdeleted            boolean,
    ascendbaseeventid    bigint encode az64,
    notes                varchar(500) encode bytedict,
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.events_history
    owner to etluser;

grant select on asc_history.events_history to group named_user_ro;

create table if not exists asc_history.region_history
(
    ascend_carrier_id    bigint encode az64,
    regionid             bigint encode az64,
    beid                 bigint encode az64,
    regionname           varchar(100),
    isdeleted            boolean,
    updateinaqe          boolean,
    aqesalesregionid     bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.region_history
    owner to etluser;

grant select on asc_history.region_history to group named_user_ro;

create table if not exists asc_history.leadcalls_history
(
    ascend_carrier_id    bigint encode az64,
    callsid              bigint encode az64,
    pkcallresult         bigint encode az64,
    dispostring          varchar(100),
    agentname            varchar(100),
    calldate             timestamp encode az64,
    calltype             varchar(50),
    dnis                 varchar(10),
    dnisdescription      varchar(300),
    dniscategory         varchar(300),
    origin               varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadcalls_history
    owner to etluser;

grant select on asc_history.leadcalls_history to group named_user_ro;

create table if not exists asc_history.ascendfeatures_history
(
    featureid            bigint encode az64,
    feature              varchar(100),
    description          varchar(500),
    isactive             boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.ascendfeatures_history
    owner to etluser;

grant select on asc_history.ascendfeatures_history to group named_user_ro;

create table if not exists asc_history.zipcodetimezone_history
(
    pkid                 bigint encode az64,
    zipcode              varchar(64),
    county               varchar(256),
    countyfips           varchar(16),
    state                varchar(16),
    statefips            varchar(16),
    timezone             varchar(16),
    daylightsaving       varchar(8),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.zipcodetimezone_history
    owner to etluser;

grant select on asc_history.zipcodetimezone_history to group named_user_ro;

create table if not exists asc_history.leadgenerationtracking_history
(
    ascend_carrier_id          bigint encode az64,
    leadgenerationtrackingid   bigint encode az64,
    beid                       bigint encode az64,
    prospectid                 bigint encode az64,
    fieldagentid               bigint encode az64,
    callcenteragentname        varchar(50),
    contactinfofk              bigint encode az64,
    leadfirstname              varchar(50),
    leadlastname               varchar(50),
    leadaddress                varchar(50),
    leadcity                   varchar(50),
    leadstate                  varchar(2),
    leadzip                    varchar(5),
    leadcounty                 varchar(50),
    leadphone                  varchar(50),
    datetimecallwastransferred timestamp encode az64,
    uniquecallid               varchar(64),
    carriername                varchar(50),
    agentavailable             boolean,
    radius                     numeric(14, 5) encode az64,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
);

alter table asc_history.leadgenerationtracking_history
    owner to etluser;

grant select on asc_history.leadgenerationtracking_history to group named_user_ro;

create table if not exists asc_history.formtype_history
(
    formtypeid           bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.formtype_history
    owner to etluser;

grant select on asc_history.formtype_history to group named_user_ro;

create table if not exists asc_history.ratecallforwarding_base_history
(
    pkratecallforwardingid bigint encode az64 distkey,
    callforwardvalue       varchar(50),
    isdeleted              boolean,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.ratecallforwarding_base_history
    owner to etluser;

grant select on asc_history.ratecallforwarding_base_history to group named_user_ro;

create table if not exists asc_history.eventsduration_base_history
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.eventsduration_base_history
    owner to etluser;

grant select on asc_history.eventsduration_base_history to group named_user_ro;

create table if not exists asc_history.hvv2appointmentscopemap_history
(
    ascend_carrier_id         bigint encode az64,
    hvv2appointmentscopemapid bigint encode az64,
    hvv2appointmentid         bigint encode az64,
    scopeofappointmentid      bigint encode az64,
    isdeleted                 boolean,
    notes                     varchar(500),
    audituserid               bigint encode az64 distkey,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
);

alter table asc_history.hvv2appointmentscopemap_history
    owner to etluser;

grant select on asc_history.hvv2appointmentscopemap_history to group named_user_ro;

create table if not exists asc_history.calltoleadmap_history
(
    ascend_carrier_id    bigint encode az64,
    calltoleadmapid      bigint encode az64,
    callsid              bigint encode az64,
    leadid               bigint encode az64,
    businessentityid     bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.calltoleadmap_history
    owner to etluser;

grant select on asc_history.calltoleadmap_history to group named_user_ro;

create table if not exists asc_history.userqueue_map_history
(
    ascend_carrier_id    bigint encode az64,
    userqueuemapid       bigint encode az64 distkey,
    userid               bigint encode az64,
    leadqueueid          bigint encode az64,
    beid                 bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.userqueue_map_history
    owner to etluser;

grant select on asc_history.userqueue_map_history to group named_user_ro;

create table if not exists asc_history.dynamoaqeformmap_history
(
    ascend_carrier_id    bigint encode az64,
    dynamoaqeformmapid   bigint encode az64,
    dynamoformid         bigint encode az64,
    aqecarrierid         bigint encode az64,
    aqefromid            bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.dynamoaqeformmap_history
    owner to etluser;

grant select on asc_history.dynamoaqeformmap_history to group named_user_ro;

create table if not exists asc_history.roles_base_history
(
    roleid               bigint encode az64,
    code                 varchar(50),
    name                 varchar(256),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    role_permissions     varchar(2048),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.roles_base_history
    owner to etluser;

grant select on asc_history.roles_base_history to group named_user_ro;

create table if not exists asc_history.groups_custom_history
(
    ascend_carrier_id    bigint encode az64,
    groupsid             bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    groupdescription     varchar(500),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.groups_custom_history
    owner to etluser;

grant select on asc_history.groups_custom_history to group named_user_ro;

create table if not exists asc_history.isfenrollmenthistory_history
(
    ascend_carrier_id      bigint encode az64,
    isfenrollmenthistoryid bigint encode az64 distkey,
    beid                   bigint encode az64,
    leadid                 bigint encode az64,
    confirmationnumber     varchar(50),
    meetingid              bigint encode az64,
    planname               varchar(100),
    premiumvalue           varchar(50),
    datecreated            timestamp encode az64,
    notes                  varchar(500),
    audituserid            bigint encode az64,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.isfenrollmenthistory_history
    owner to etluser;

grant select on asc_history.isfenrollmenthistory_history to group named_user_ro;

create table if not exists asc_history.userlangmap_history
(
    ascend_carrier_id    bigint encode az64,
    userlangid           bigint encode az64,
    businessentityid     bigint encode az64,
    userid               bigint encode az64 distkey,
    languageid           bigint encode az64,
    isdeleted            boolean,
    notes                varchar(50),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.userlangmap_history
    owner to etluser;

grant select on asc_history.userlangmap_history to group named_user_ro;

create table if not exists asc_history.phonetype_base_history
(
    phonetypeid          bigint encode az64,
    phonetypename        varchar(50),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.phonetype_base_history
    owner to etluser;

grant select on asc_history.phonetype_base_history to group named_user_ro;

create table if not exists asc_history.businessentities_history
(
    businessentityid     bigint encode az64,
    carrierid            bigint encode az64,
    businessentityname   varchar(100),
    spacequota           bigint encode az64,
    servername           varchar(50),
    serverusername       varchar(50),
    authenticationkey    varchar(3000),
    pointofcontact       varchar(100),
    documentroot         varchar(100),
    recordingroot        varchar(100),
    recordingmeth        varchar(50),
    paperscoperoot       varchar(100),
    pushnotificationpath varchar(50),
    pushcertpassword     varchar(50),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.businessentities_history
    owner to etluser;

grant select on asc_history.businessentities_history to group named_user_ro;

create table if not exists asc_history.messages_history
(
    ascend_carrier_id    bigint encode az64,
    messageid            bigint encode az64,
    businessentityid     bigint encode az64,
    publishdate          timestamp encode az64,
    expirydate           timestamp encode az64,
    createddate          timestamp encode az64,
    requireack           boolean,
    messagetext          varchar(9216),
    title                varchar(100),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64,
    htmlformattedtext    varchar(9216),
    messagereceviedby    bigint encode az64,
    usersacknowledged    bigint encode az64,
    recipientcount       bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.messages_history
    owner to etluser;

grant select on asc_history.messages_history to group named_user_ro;

create table if not exists asc_history.users_history
(
    userid               bigint encode az64 distkey,
    loginname            varchar(500),
    password             varchar(150),
    salt                 varchar(50),
    fname                varchar(50),
    lname                varchar(50),
    datepwdchange        timestamp encode az64,
    natpronum            varchar(10),
    locked               boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    hash                 varchar(16),
    truesalt             varchar(16),
    userversion          bigint encode az64,
    useriterations       bigint encode az64,
    apiversion           bigint encode az64,
    apiiterations        bigint encode az64,
    lockendtime          timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.users_history
    owner to etluser;

grant select on asc_history.users_history to group named_user_ro;

create table if not exists asc_history.businessentityparameters_history
(
    businessentityparameterid   bigint,
    beid                        bigint encode az64,
    pwdage                      bigint encode az64,
    tokenage                    bigint encode az64,
    pwdrepeat                   bigint encode az64,
    loginattempts               bigint encode az64,
    logindelayminutes           bigint encode az64,
    imagelocation               varchar(500),
    armimagelocation            varchar(500),
    maplogo                     varchar(500),
    disclaimer                  varchar(8192),
    documentcount               bigint encode az64,
    maxdevicerecordings         bigint encode az64,
    availabilitytimeout         bigint encode az64,
    maxradius                   bigint encode az64,
    distributionpattern         bigint encode az64,
    apppath                     varchar(255),
    winapppath                  varchar(256),
    appbundleid                 varchar(50),
    servicecontactid_fk         bigint encode az64,
    backupservicecontactid_fk   bigint encode az64,
    quoteurl                    varchar(500),
    enrollmenturl               varchar(500),
    sendgridapikey              varchar(500),
    emaildisclaimer             varchar(8192),
    sendgridemailaddress        varchar(256),
    emailname                   varchar(256),
    emailaddress                varchar(256),
    emailbody                   varchar(8192),
    emailsubject                varchar(256),
    twiliosmsnumber             varchar(256),
    twiliotextbody              varchar(256),
    notes                       varchar(256),
    audituserid                 bigint encode az64,
    s3region                    varchar(100),
    s3secret                    varchar(256),
    s3accesskey                 varchar(256),
    s3bucketname                varchar(250),
    isparticipatinginsalesforce boolean,
    clientid                    varchar(255),
    clientsecret                varchar(255),
    salesforceusername          varchar(500),
    salesforcepassword          varchar(500),
    fein                        varchar(50),
    nipraccountid               varchar(10),
    niprpaymentcodeid           bigint encode az64,
    aqeimagepath                varchar(256),
    use2fa                      boolean,
    registrationemailid         bigint encode az64 distkey,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
)
    sortkey (businessentityparameterid);

alter table asc_history.businessentityparameters_history
    owner to etluser;

grant select on asc_history.businessentityparameters_history to group named_user_ro;

create table if not exists asc_history.meetingtoleadmap_history
(
    ascend_carrier_id    bigint,
    meetingtoleadmapid   bigint encode az64,
    beid                 bigint encode az64,
    meetingid            bigint encode az64,
    leadid               bigint encode az64,
    scopeofappointmentid varchar(100),
    bloomclientid        varchar(100),
    datetimeofmeeting    timestamp encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.meetingtoleadmap_history
    owner to etluser;

grant select on asc_history.meetingtoleadmap_history to group named_user_ro;

create table if not exists asc_history.phonetype_custom_history
(
    ascend_carrier_id    bigint encode az64,
    phonetypeid          bigint encode az64,
    phonetypename        varchar(50),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.phonetype_custom_history
    owner to etluser;

grant select on asc_history.phonetype_custom_history to group named_user_ro;

create table if not exists asc_history.persontype_history
(
    persontypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.persontype_history
    owner to etluser;

grant select on asc_history.persontype_history to group named_user_ro;

create table if not exists asc_history.attributetype_history
(
    attributetypeid      bigint distkey,
    name                 varchar(256),
    description          varchar(1024),
    platformtypeid       bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (attributetypeid);

alter table asc_history.attributetype_history
    owner to etluser;

grant select on asc_history.attributetype_history to group named_user_ro;

create table if not exists asc_history.entityfeaturemap_history
(
    entityfeaturemapid   bigint encode az64,
    carrierid            bigint,
    beid                 bigint encode az64,
    userid               bigint encode az64 distkey,
    featureid            bigint encode az64,
    isactive             boolean,
    notes                varchar(500),
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (carrierid);

alter table asc_history.entityfeaturemap_history
    owner to etluser;

grant select on asc_history.entityfeaturemap_history to group named_user_ro;

create table if not exists asc_history.carriers_history
(
    carrierid            bigint,
    carriername          varchar(50),
    databaseserver       varchar(50),
    databasename         varchar(50),
    apikey               varchar(256),
    totallicallowed      bigint encode az64,
    totallicused         bigint encode az64,
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (carrierid);

alter table asc_history.carriers_history
    owner to etluser;

grant select on asc_history.carriers_history to group named_user_ro;

create table if not exists asc_history.help_catalog_history
(
    id                   bigint distkey,
    line                 bigint encode az64,
    catalogid            bigint encode az64,
    definitiontype       bigint encode az64,
    reportname           varchar(500),
    definitionid         bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (id);

alter table asc_history.help_catalog_history
    owner to etluser;

grant select on asc_history.help_catalog_history to group named_user_ro;

create table if not exists asc_history.usergroup_map_history
(
    ascend_carrier_id    bigint,
    mapusergroupid       bigint encode az64,
    userid               bigint encode az64 distkey,
    businessentityid     bigint encode az64,
    groupid              bigint encode az64,
    groupcode            varchar(50),
    isowner              boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.usergroup_map_history
    owner to etluser;

grant select on asc_history.usergroup_map_history to group named_user_ro;

create table if not exists asc_history.emailtemplatemerge_map_history
(
    ascend_carrier_id          bigint encode az64,
    emailtemplatemergeid       bigint,
    beid                       bigint encode az64,
    templateid                 varchar(100),
    agentfirstname             varchar(100),
    agentlastname              varchar(100),
    agentprimaryphone          varchar(100),
    agentcellphone             varchar(100),
    agentofficephone           varchar(100),
    agentenrollmentphone       varchar(100),
    agentemail                 varchar(100),
    agentaddress               varchar(100),
    agentcity                  varchar(100),
    agentstate                 varchar(100),
    agentzipcode               varchar(100),
    agentnpn                   varchar(100),
    agentawn                   varchar(100),
    prospectfirstname          varchar(100),
    prospectlastname           varchar(100),
    prospectemail              varchar(100),
    prospectphonenumber        varchar(100),
    prospectaddress            varchar(100),
    prospectcity               varchar(100),
    prospectstate              varchar(100),
    prospectzipcode            varchar(100),
    prospectcounty             varchar(100),
    templatetype               varchar(50),
    responsetype               varchar(50),
    respondtoagent             boolean,
    respondtootheremail        boolean,
    respondtootheremailaddress varchar(50),
    fromname                   varchar(100),
    isdeleted                  boolean,
    notes                      varchar(256),
    audituserid                bigint encode az64 distkey,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (emailtemplatemergeid);

alter table asc_history.emailtemplatemerge_map_history
    owner to etluser;

grant select on asc_history.emailtemplatemerge_map_history to group named_user_ro;

create table if not exists asc_history.languages_base_history
(
    languagesid          bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (code);

alter table asc_history.languages_base_history
    owner to etluser;

grant select on asc_history.languages_base_history to group named_user_ro;

create table if not exists asc_history.eventsduration_custom_history
(
    ascend_carrier_id      bigint encode az64,
    eventdurationid        bigint encode az64,
    eventdurationname      varchar(100),
    eventdurationinminutes bigint encode az64,
    beid                   bigint encode az64,
    status                 varchar(1),
    notes                  varchar(500),
    audituserid            bigint encode az64 distkey,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table asc_history.eventsduration_custom_history
    owner to etluser;

grant select on asc_history.eventsduration_custom_history to group named_user_ro;

create table if not exists asc_history.scopeofappointment_history
(
    ascend_carrier_id    bigint encode az64,
    scopeofappointmentid bigint encode az64,
    formsubmissionid     bigint encode az64,
    displayname          bigint encode az64,
    beid                 bigint encode az64,
    userid               bigint encode az64,
    prospectid           bigint encode az64,
    requestedmeetingdate timestamp encode az64,
    statustypeid         bigint encode az64,
    creationdate         timestamp encode az64,
    statuschanged        timestamp encode az64,
    emailsent            timestamp encode az64,
    senton               timestamp encode az64,
    passcode             varchar(100),
    useragent            varchar(1024),
    ipaddress            varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64,
    paperscopefilename   varchar(500),
    reminderlastsent     timestamp encode az64,
    signaturetype        varchar(20) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.scopeofappointment_history
    owner to etluser;

grant select on asc_history.scopeofappointment_history to group named_user_ro;

create table if not exists asc_history.prospects_history
(
    ascend_carrier_id          bigint,
    prospectid                 bigint encode az64,
    beid                       bigint encode az64,
    meetingid                  bigint encode az64,
    firstname                  varchar(50),
    middleinitial              varchar(1),
    lastname                   varchar(55),
    phone                      varchar(15),
    streetaddress              varchar(150),
    city                       varchar(50),
    state                      varchar(2),
    zipcode                    varchar(16),
    county                     varchar(50),
    email                      varchar(150),
    creationmethod             varchar(50) encode bytedict,
    leadsourceid               bigint encode az64,
    dateofcreation             timestamp encode az64,
    islead                     boolean,
    leaddate                   timestamp encode az64,
    agentid                    bigint encode az64,
    commission                 boolean,
    altexternalid              varchar(100),
    leadstatusid               bigint encode az64,
    isdeleted                  boolean,
    viewed                     boolean,
    birthdate                  timestamp encode az64,
    gender                     varchar(10) encode bytedict,
    medicareclaimnumber        varchar(25),
    medicarepartaeffectivedate timestamp encode az64,
    medicarepartbeffectivedate timestamp encode az64,
    lastmodifieddate           timestamp encode az64,
    lastmodifiednotes          varchar(256) encode bytedict,
    notes                      varchar(1024),
    audituserid                bigint encode az64 distkey,
    cuid                       varchar(32),
    streetaddress2             varchar(150),
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.prospects_history
    owner to etluser;

grant select on asc_history.prospects_history to group named_user_ro;

create table if not exists asc_history.dispositions_custom_history
(
    ascend_carrier_id    bigint,
    dispositionsid       bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (ascend_carrier_id);

alter table asc_history.dispositions_custom_history
    owner to etluser;

grant select on asc_history.dispositions_custom_history to group named_user_ro;

create table if not exists asc_history.contacttype_history
(
    contacttypeid        bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table asc_history.contacttype_history
    owner to etluser;

grant select on asc_history.contacttype_history to group named_user_ro;

create table if not exists asc_history.permissiontocontact_base_history
(
    id                    bigint encode az64,
    permissiondescription varchar(100),
    isactive              boolean,
    audituserid           bigint encode az64 distkey,
    notes                 varchar(256),
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
)
    sortkey (refresh_timestamp);

alter table asc_history.permissiontocontact_base_history
    owner to etluser;

grant select on asc_history.permissiontocontact_base_history to group named_user_ro;

create table if not exists asc_history.userrole_map_history
(
    ascend_carrier_id    bigint encode az64,
    mapuserroleid        bigint encode az64,
    carrierid            bigint encode az64,
    businessentityid     bigint encode az64,
    userid               bigint encode az64 distkey,
    roleid               bigint encode az64,
    rolecode             varchar(50),
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.userrole_map_history
    owner to etluser;

grant select on asc_history.userrole_map_history to group named_user_ro;

create table if not exists asc_history.tags_history
(
    ascend_carrier_id    bigint encode az64,
    tagid                bigint encode az64,
    tagname              varchar(500),
    beid                 bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.tags_history
    owner to etluser;

grant select on asc_history.tags_history to group named_user_ro;

create table if not exists asc_history.formsubmission_history
(
    ascend_carrier_id    bigint encode az64,
    formsubmissionid     bigint encode az64 distkey,
    formid               bigint encode az64,
    useragent            varchar(256),
    ipaddress            varchar(50),
    ispartial            boolean,
    notes                varchar(256) encode bytedict,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.formsubmission_history
    owner to etluser;

grant select on asc_history.formsubmission_history to group named_user_ro;

create table if not exists asc_history.leadsviewrules_base_history
(
    leadviewid           bigint encode az64,
    beid                 bigint encode az64,
    name                 varchar(50),
    rule                 varchar(3072),
    xmlrule              varchar(512),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadsviewrules_base_history
    owner to etluser;

grant select on asc_history.leadsviewrules_base_history to group named_user_ro;

create table if not exists asc_history.dispositiontypes_custom_history
(
    ascend_carrier_id    bigint encode az64,
    dispositiontypeid    bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(50),
    description          varchar(50),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.dispositiontypes_custom_history
    owner to etluser;

grant select on asc_history.dispositiontypes_custom_history to group named_user_ro;

create table if not exists asc_history.groups_base_history
(
    groupsid             bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    groupdescription     varchar(500),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.groups_base_history
    owner to etluser;

grant select on asc_history.groups_base_history to group named_user_ro;

create table if not exists asc_history.languages_custom_history
(
    ascend_carrier_id    bigint encode az64,
    languagesid          bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.languages_custom_history
    owner to etluser;

grant select on asc_history.languages_custom_history to group named_user_ro;

create table if not exists asc_history.eventsstatus_custom_history
(
    ascend_carrier_id    bigint encode az64,
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventsstatus_custom_history
    owner to etluser;

grant select on asc_history.eventsstatus_custom_history to group named_user_ro;

create table if not exists asc_history.statustype_history
(
    statustypeid         bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.statustype_history
    owner to etluser;

grant select on asc_history.statustype_history to group named_user_ro;

create table if not exists asc_history.eventsstatus_history
(
    ascend_carrier_id    bigint encode az64,
    eventstatusid        bigint encode az64,
    eventstatusname      varchar(100),
    beid                 bigint encode az64,
    isdeleted            bigint encode az64,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventsstatus_history
    owner to etluser;

grant select on asc_history.eventsstatus_history to group named_user_ro;

create table if not exists asc_history.eventstype_base_history
(
    eventtypeid          bigint encode az64,
    eventtypename        varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventstype_base_history
    owner to etluser;

grant select on asc_history.eventstype_base_history to group named_user_ro;

create table if not exists asc_history.messageuser_map_history
(
    ascend_carrier_id    bigint encode az64,
    mapmessageuserid     bigint encode az64 distkey,
    userid               bigint encode az64,
    messageid            bigint encode az64,
    businessentityid     bigint encode az64,
    requireack           boolean,
    userack              boolean,
    timeacknowlwdged     timestamp encode az64,
    messagedelivered     boolean,
    messagereceived      boolean,
    isdeleted            boolean,
    notes                varchar(256) encode bytedict,
    audituserid          bigint encode az64,
    groupid              bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.messageuser_map_history
    owner to etluser;

grant select on asc_history.messageuser_map_history to group named_user_ro;

create table if not exists asc_history.documents_history
(
    ascend_carrier_id    bigint encode az64,
    documentid           bigint encode az64,
    businessentityid     bigint encode az64,
    documentname         varchar(100),
    publishdate          timestamp encode az64,
    expirydate           timestamp encode az64,
    createddate          timestamp encode az64,
    folderid             bigint encode az64,
    subfolderid          bigint encode az64,
    replacesdocumentid   bigint encode az64,
    documentpath         varchar(4096),
    isdeleted            boolean,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    resourcetype         varchar(25),
    displayonhomescreen  boolean,
    passauth             boolean,
    action               varchar(50),
    ranking              bigint encode az64,
    recipientcount       bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.documents_history
    owner to etluser;

grant select on asc_history.documents_history to group named_user_ro;

create table if not exists asc_history.regiongroupmap_history
(
    ascend_carrier_id    bigint encode az64,
    regiongroupmapid     bigint encode az64,
    regionid             bigint encode az64,
    groupid              bigint encode az64,
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.regiongroupmap_history
    owner to etluser;

grant select on asc_history.regiongroupmap_history to group named_user_ro;

create table if not exists asc_history.eventstype_custom_history
(
    ascend_carrier_id    bigint encode az64,
    eventtypeid          bigint encode az64,
    eventtypename        varchar(100),
    beid                 bigint encode az64,
    status               varchar(1),
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.eventstype_custom_history
    owner to etluser;

grant select on asc_history.eventstype_custom_history to group named_user_ro;

create table if not exists asc_history.sessionpropertytype_history
(
    sessionpropertytypeid bigint encode az64,
    name                  varchar(256),
    description           varchar(256),
    isdeleted             boolean,
    notes                 varchar(256),
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
);

alter table asc_history.sessionpropertytype_history
    owner to etluser;

grant select on asc_history.sessionpropertytype_history to group named_user_ro;

create table if not exists asc_history.dispositions_base_history
(
    dispositionsid       bigint encode az64,
    code                 varchar(10),
    description          varchar(50),
    status               varchar(2),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.dispositions_base_history
    owner to etluser;

grant select on asc_history.dispositions_base_history to group named_user_ro;

create table if not exists asc_history.roles_custom_history
(
    ascend_carrier_id    bigint encode az64,
    roleid               bigint encode az64,
    carrierid            bigint encode az64,
    businessentityid     bigint encode az64,
    code                 varchar(50),
    name                 varchar(256),
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    isactive             boolean,
    permission           varchar(1024),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.roles_custom_history
    owner to etluser;

grant select on asc_history.roles_custom_history to group named_user_ro;

create table if not exists asc_history.hvv2appointmentmeetingmap_history
(
    ascend_carrier_id           bigint encode az64,
    hvv2appointmentmeetingmapid bigint encode az64,
    hvv2appointmentid           bigint encode az64,
    meetinghistoryid            bigint encode az64,
    isdeleted                   boolean,
    notes                       varchar(500),
    audituserid                 bigint encode az64 distkey,
    refresh_timestamp           timestamp encode az64,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
);

alter table asc_history.hvv2appointmentmeetingmap_history
    owner to etluser;

grant select on asc_history.hvv2appointmentmeetingmap_history to group named_user_ro;

create table if not exists asc_history.leadsource_base_history
(
    sourceid             bigint encode az64,
    leadsource           varchar(50),
    isdeleted            boolean,
    notes                varchar(500),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.leadsource_base_history
    owner to etluser;

grant select on asc_history.leadsource_base_history to group named_user_ro;

create table if not exists asc_history.accesstype_custom_history
(
    ascend_carrier_id    bigint encode az64,
    accesstypeid         bigint encode az64,
    beid                 bigint encode az64,
    accesstype           varchar(30),
    isdeleted            boolean,
    notes                varchar(1000),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.accesstype_custom_history
    owner to etluser;

grant select on asc_history.accesstype_custom_history to group named_user_ro;

create table if not exists asc_history.dispositiontypedisposition_map_custom_history
(
    ascend_carrier_id    bigint encode az64,
    dispositiontypemapid bigint encode az64,
    businessentityid     bigint encode az64,
    typeid               bigint encode az64,
    dispositionid        bigint encode az64,
    notes                varchar(256),
    audituserid          bigint encode az64 distkey,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.dispositiontypedisposition_map_custom_history
    owner to etluser;

grant select on asc_history.dispositiontypedisposition_map_custom_history to group named_user_ro;

create table if not exists asc_history.errortype_history
(
    errortypeid          bigint encode az64,
    name                 varchar(256),
    description          varchar(256),
    isdeleted            boolean,
    notes                varchar(256),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table asc_history.errortype_history
    owner to etluser;

grant select on asc_history.errortype_history to group named_user_ro;

create table if not exists ccs_history.bloom_hourofcall_history
(
    pkid                 integer encode az64,
    hourofcall           varchar(5),
    hour                 bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.bloom_hourofcall_history
    owner to etluser;

grant select on ccs_history.bloom_hourofcall_history to group named_user_ro;

create table if not exists ccs_history.bloom_clientcampaignmap_history
(
    bloom_clientcampaignmapid bigint encode az64,
    bloom_clientid            bigint encode az64,
    campaignid                bigint encode az64,
    auditusername             varchar(255),
    isactiveforstats          boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
);

alter table ccs_history.bloom_clientcampaignmap_history
    owner to etluser;

grant select on ccs_history.bloom_clientcampaignmap_history to group named_user_ro;

create table if not exists ccs_history.agentgroups_history
(
    pkagentgroups        bigint encode az64,
    name                 varchar(100),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.agentgroups_history
    owner to etluser;

grant select on ccs_history.agentgroups_history to group named_user_ro;

create table if not exists ccs_history.enrollmentinfo_history
(
    pkenrollmentinfo     bigint encode az64,
    lisstatus            varchar(10),
    bloomenrollmentguid  varchar(75),
    dateadded            timestamp encode az64,
    enrollmentid         varchar(256),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.enrollmentinfo_history
    owner to etluser;

grant select on ccs_history.enrollmentinfo_history to group named_user_ro;

create table if not exists ccs_history.stateabbreviations_history
(
    statefk              bigint encode az64,
    statecode            varchar(2),
    statename            varchar(75),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.stateabbreviations_history
    owner to etluser;

grant select on ccs_history.stateabbreviations_history to group named_user_ro;

create table if not exists ccs_history.calltypedescription_history
(
    calltype_id          bigint encode az64 distkey,
    calldirection        varchar(50),
    callshortdirection   varchar(50),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.calltypedescription_history
    owner to etluser;

grant select on ccs_history.calltypedescription_history to group named_user_ro;

create table if not exists ccs_history.callresultcodes_history
(
    callresultcode             bigint encode az64,
    callresultdescription      varchar(128),
    statuscode                 varchar(10),
    elderplancorecode          varchar(10),
    windsorcorecode            varchar(10),
    bluechoicecorecode         varchar(10),
    hphccorecode               varchar(10),
    avetacorecode              varchar(10),
    appttype                   varchar(5),
    heritage_apfcorecode       varchar(50),
    heritage_thcorecode        varchar(50),
    heritage_ghcorecode        varchar(50),
    heritage_sctcorecode       varchar(50),
    heritage_tfcorecode        varchar(50),
    arcadiancorecode           varchar(50),
    todaysoptionscorecode      varchar(50),
    todaysoptions_ccrxcorecode varchar(50),
    cs_uac_over65corecode      varchar(50),
    presentation               boolean,
    countaslead                boolean,
    printable                  boolean,
    systemcode                 boolean,
    verification               boolean,
    nevercall                  boolean,
    addtomasterdonotcall       boolean,
    printpage                  varchar(255),
    deleted                    boolean,
    phonenumbernevercall       boolean,
    countascontact             boolean,
    countassale                boolean,
    countasdonotmail           boolean,
    countasdonotcontact        boolean,
    countasdeceased            boolean,
    refresh_timestamp          timestamp,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.callresultcodes_history
    owner to etluser;

grant select on ccs_history.callresultcodes_history to group named_user_ro;

create table if not exists ccs_history.bloom_dispositioncategorymap_history
(
    dispcategorymapid    bigint encode az64,
    poolfk               bigint encode az64,
    callresultcode       bigint encode az64,
    dispcategoryid       bigint encode az64,
    sortorder            bigint encode az64,
    isdeleted            boolean,
    countaseligible      boolean,
    seminar              boolean,
    homevisit            boolean,
    agentconnect         boolean,
    mailinfo             boolean,
    dnc                  boolean,
    followup             boolean,
    statscategoryid      bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.bloom_dispositioncategorymap_history
    owner to etluser;

grant select on ccs_history.bloom_dispositioncategorymap_history to group named_user_ro;

create table if not exists ccs_history.inboundconfiguration_history
(
    pkinboundconfiguration      bigint encode az64,
    dnis                        varchar(1000),
    name                        varchar(50),
    dniscategoryfk              bigint encode az64,
    dbtype                      bigint encode az64,
    databasename                varchar(255),
    databaseserver              varchar(255),
    dbuserid                    varchar(50) distkey,
    dbpassword                  varchar(50),
    dbuseswindows               boolean,
    greetingmessage             varchar(65000),
    holdmessage                 varchar(65000),
    intermittentmessage         varchar(65000),
    intermittentinterval        bigint encode az64,
    notavailablemessage         varchar(65000),
    noagentsloggedinmessage     varchar(65000),
    overflowgroupfk             bigint encode az64,
    scriptsfk                   bigint encode az64,
    starttime                   varchar(15),
    stoptime                    varchar(15),
    daysmap                     bigint encode az64,
    isrunning                   boolean,
    lookuppage                  varchar(255),
    verificationscriptfk        bigint encode az64,
    manualdialscriptfk          bigint encode az64,
    callbackscriptfk            bigint encode az64,
    autocreaterecord            boolean,
    playstatsaftergreeting      boolean,
    playstatsperiodically       bigint encode az64,
    overflowivr                 varchar(255),
    anitosend                   varchar(50),
    companyname                 varchar(255),
    ringsbeforeanswer           bigint encode az64,
    voicemailboxfk              bigint encode az64,
    busyonslabreach             boolean,
    deliverystrategy            bigint encode az64,
    beforeconnecttoagentmessage varchar(65000),
    refresh_timestamp           timestamp,
    data_transfer_log_id        bigint encode az64,
    md5_hash                    varchar(32),
    record_version              bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.inboundconfiguration_history
    owner to etluser;

grant select on ccs_history.inboundconfiguration_history to group named_user_ro;

create table if not exists ccs_history.ssrsfilesharesubscriptions_history
(
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    filename             varchar(200),
    filesharepath        varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    fileextension        boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.ssrsfilesharesubscriptions_history
    owner to etluser;

grant select on ccs_history.ssrsfilesharesubscriptions_history to group named_user_ro;

create table if not exists ccs_history.holidaycalender_history
(
    holidaycalenderid    bigint encode az64 distkey,
    poolfk               bigint encode az64,
    holidaydate          date encode az64,
    isdeleted            boolean,
    auditusername        varchar(200),
    notes                varchar(500),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.holidaycalender_history
    owner to etluser;

grant select on ccs_history.holidaycalender_history to group named_user_ro;

create table if not exists ccs_history.bloomplan_history
(
    pkplan               bigint encode az64,
    planname             varchar(250),
    plantype             varchar(20),
    isdeleted            boolean,
    carrierfk            bigint encode az64,
    commissionrate       double precision,
    plangroup            varchar(20),
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.bloomplan_history
    owner to etluser;

grant select on ccs_history.bloomplan_history to group named_user_ro;

create table if not exists ccs_history.ssrsemailsubscriptions_history
(
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    toemailaddress       varchar(200),
    ccemailaddress       varchar(200),
    bccemailaddress      varchar(200),
    replytoemailaddress  varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    priority             varchar(15),
    subject              varchar(150),
    comment              varchar(150),
    includelink          boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.ssrsemailsubscriptions_history
    owner to etluser;

grant select on ccs_history.ssrsemailsubscriptions_history to group named_user_ro;

create table if not exists ccs_history.dniscategory_history
(
    pkdniscategory       bigint encode az64,
    dniscategoryname     varchar(50),
    deleted              boolean,
    clientrequested      varchar(30),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.dniscategory_history
    owner to etluser;

grant select on ccs_history.dniscategory_history to group named_user_ro;

create table if not exists ccs_history.poolquerymap_history
(
    poolsfk              bigint encode az64,
    queriesfk            bigint encode az64,
    loadfactor           bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.poolquerymap_history
    owner to etluser;

grant select on ccs_history.poolquerymap_history to group named_user_ro;

create table if not exists ccs_history.agentstats_history
(
    pkagentstats         bigint encode az64,
    usersfk              integer encode az64,
    campaignfk           integer encode az64,
    pausetime            timestamp encode az64,
    waittime             timestamp encode az64,
    notavailabletime     timestamp encode az64,
    systemtime           timestamp encode az64,
    statsdate            timestamp encode az64,
    statstime            timestamp encode az64,
    numberofcampaigns    bigint encode az64,
    prevstate            bigint encode az64,
    nextstate            bigint encode az64,
    pausereasonfk        bigint encode az64,
    logoutreasonfk       bigint encode az64,
    pausereasontext      varchar(250),
    logoutreasontext     varchar(250),
    projecttype          bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.agentstats_history
    owner to etluser;

grant select on ccs_history.agentstats_history to group named_user_ro;

create table if not exists ccs_history.callresults_history
(
    pkcallresults        bigint encode az64,
    agentexitcode        bigint encode az64,
    agentwrapendtime     timestamp encode az64,
    autoattendant        boolean,
    callaccount          bigint encode az64,
    calldurationseconds  bigint encode az64,
    agentfk              bigint encode az64,
    callendtime          timestamp encode az64,
    contactnumber        varchar(32),
    callline             varchar(512) encode bytedict,
    callstarttime        timestamp encode az64,
    calltype             bigint encode az64,
    dnis                 varchar(32),
    exitstate            bigint encode az64,
    callwastransferred   boolean,
    overflowgroupfk      bigint encode az64,
    dateofcall           timestamp encode az64,
    dniscategoryfk       bigint encode az64,
    callsenttoagenttime  timestamp encode az64,
    voicemailstarttime   timestamp encode az64,
    voicemailstoptime    timestamp encode az64,
    contactnumberfk      bigint encode az64,
    poolfk               bigint encode az64,
    notes                varchar(256),
    recordingfilename    varchar(260),
    morephonenumbers     boolean,
    outofhours           boolean,
    query_id             bigint encode az64 distkey,
    commentfk            bigint encode az64,
    previewtime          timestamp encode az64,
    holdtime             timestamp encode az64,
    finaldisposition     bigint encode az64,
    appointmentid        bigint encode az64,
    agentactionid        bigint encode az64,
    emailfk              bigint encode az64,
    projecttype          bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.callresults_history
    owner to etluser;

grant select on ccs_history.callresults_history to group named_user_ro;

create table if not exists ccs_history.bloom_clientdispositionmapping_history
(
    pkbloomdispositionmapping bigint encode az64,
    callresultcode            bigint encode az64,
    clientid                  bigint encode az64,
    thirdpartyname            varchar(100),
    externalcode              varchar(100),
    testing                   boolean,
    isactive                  boolean,
    refresh_timestamp         timestamp encode az64,
    data_transfer_log_id      bigint encode az64,
    md5_hash                  varchar(32),
    record_version            bigint encode az64
);

alter table ccs_history.bloom_clientdispositionmapping_history
    owner to etluser;

grant select on ccs_history.bloom_clientdispositionmapping_history to group named_user_ro;

create table if not exists ccs_history.bloomplanmapping_history
(
    pkplanmapping        bigint encode az64,
    carrierfk            bigint encode az64,
    planfk               bigint encode az64,
    carriermappingfk     bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.bloomplanmapping_history
    owner to etluser;

grant select on ccs_history.bloomplanmapping_history to group named_user_ro;

create table if not exists ccs_history.reasons_history
(
    pkreason             bigint encode az64,
    logout               boolean,
    pause                boolean,
    text                 varchar(255),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.reasons_history
    owner to etluser;

grant select on ccs_history.reasons_history to group named_user_ro;

create table if not exists ccs_history.bloom_dispositioncategories_history
(
    dispositioncategoryid bigint encode az64,
    dispcategory          varchar(100),
    isdeleted             boolean,
    auditusername         varchar(200),
    refresh_timestamp     timestamp,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32),
    record_version        bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.bloom_dispositioncategories_history
    owner to etluser;

grant select on ccs_history.bloom_dispositioncategories_history to group named_user_ro;

create table if not exists ccs_history.bloomcarriermapping_history
(
    pkcarriermapping     bigint encode az64,
    carriergroupfk       bigint encode az64,
    carrierfk            bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.bloomcarriermapping_history
    owner to etluser;

grant select on ccs_history.bloomcarriermapping_history to group named_user_ro;

create table if not exists ccs_history.bloomcarrier_history
(
    pkcarrier            bigint encode az64,
    carriername          varchar(50),
    isdeleted            boolean,
    carriershortname     varchar(25),
    auditusername        varchar(50),
    bloomclientid        bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.bloomcarrier_history
    owner to etluser;

grant select on ccs_history.bloomcarrier_history to group named_user_ro;

create table if not exists ccs_history.sftpcredentials_history
(
    sftpcredentialid     bigint encode az64 distkey,
    sftpname             varchar(500),
    sftphostname         varchar(500),
    sftpusername         varchar(500),
    sftppassword         varchar(500),
    sftpport             bigint encode az64,
    isactive             boolean,
    lastmodifieddate     timestamp,
    miscnotes            varchar(200),
    auditusername        varchar(50),
    sftpkeyfile          varchar(500),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (lastmodifieddate);

alter table ccs_history.sftpcredentials_history
    owner to etluser;

grant select on ccs_history.sftpcredentials_history to group named_user_ro;

create table if not exists ccs_history.ssrsemailsubscriptions_history_history
(
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    toemailaddress       varchar(200) distkey,
    ccemailaddress       varchar(200),
    bccemailaddress      varchar(200),
    replytoemailaddress  varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    priority             varchar(15),
    subject              varchar(255),
    comment              varchar(150),
    includelink          boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (validfrom);

alter table ccs_history.ssrsemailsubscriptions_history_history
    owner to etluser;

grant select on ccs_history.ssrsemailsubscriptions_history_history to group named_user_ro;

create table if not exists ccs_history.bloom_clients_history
(
    pkbloomclientid      bigint,
    name                 varchar(200),
    hostname             varchar(100),
    logopath             varchar(200),
    csspath              varchar(200),
    databasename         varchar(50),
    isactive             boolean,
    auditusername        varchar(200),
    isvbe                boolean,
    sendgrid             boolean,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (pkbloomclientid);

alter table ccs_history.bloom_clients_history
    owner to etluser;

grant select on ccs_history.bloom_clients_history to group named_user_ro;

create table if not exists ccs_history.querymaps_history
(
    poolsfk              bigint encode az64,
    queriesfk            bigint encode az64,
    loadfactor           bigint encode az64,
    ordinal              bigint encode az64,
    liststate            bigint encode az64,
    outcomebased         boolean,
    targetleads          bigint encode az64,
    settostandby         boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.querymaps_history
    owner to etluser;

grant select on ccs_history.querymaps_history to group named_user_ro;

create table if not exists ccs_history.callcomments_history
(
    pkcomment                            bigint encode az64,
    comment                              varchar(1000),
    appt_id                              bigint encode az64,
    verify_flag                          boolean,
    updated                              boolean,
    origagentexitcode                    varchar(5),
    enrollment_id                        varchar(50),
    call_id                              varchar(50),
    enrollmenturi                        varchar(150),
    verification_id                      varchar(20),
    plantypename                         varchar(50) encode bytedict,
    enrollment_id_2                      varchar(50),
    plantypename_2                       varchar(100),
    enrollmenturi_2                      varchar(150),
    verificationid_2                     varchar(20),
    twoproduct                           boolean,
    confirmation_id                      varchar(20),
    bloomenrollmentguid                  varchar(75),
    bloomnosaleguid                      varchar(75),
    vns_ezrefcode                        varchar(20),
    soa_id                               varchar(7),
    bloomcallid                          bigint encode az64,
    issuestatus                          varchar(50) encode bytedict,
    clientreferenceid                    bigint encode az64,
    ivr_id                               bigint encode az64,
    issue_tracking_id                    varchar(50),
    fkgenericnotesid                     bigint encode az64,
    hmoid                                bigint encode az64,
    hapmailfulfillmenthistoryid          bigint encode az64,
    pcpinfoid                            bigint encode az64,
    hraresponseid                        bigint encode az64,
    ascendhelpdeskguid                   varchar(75),
    advisemailfulfillmenthistoryid       bigint encode az64,
    marketguid                           varchar(75),
    permissiontocontact                  boolean,
    advisefollowupguid                   varchar(75),
    advisefollowupemailid                bigint encode az64 distkey,
    ptcfk                                bigint encode az64,
    tcpafk                               bigint encode az64,
    cmsguid                              varchar(75),
    rsvp_eventfk                         bigint encode az64,
    safesellsoaconfirmation              varchar(50),
    safesellattestconfirmation           varchar(50),
    safesellfk                           bigint encode az64,
    gh_permissiontocontactfk             bigint encode az64,
    zinghealth_permissiontocontactfk     bigint encode az64,
    paramount_permissiontocontactfk      bigint encode az64,
    cncdemographicupdated                boolean,
    cncinterviewagreement                bigint encode az64,
    aetnaagentengage_calllistfk          bigint encode az64,
    aetnaagentengage_ae_namefk           bigint encode az64,
    zinghealth_cmsguid                   varchar(75),
    paramountvbe_confirmedplanid         bigint encode az64,
    bcbsmailfulfillmenthistoryid         bigint encode az64,
    centenepso_ae_appointmentrecordfk    varchar(400),
    callactions                          varchar(400) encode bytedict,
    hcscsmallgroupsales_referralsourcefk bigint encode az64,
    ehealth_ehealthappinfofk             bigint encode az64,
    fk_focusedhealthdl_commentid         bigint encode az64,
    fk_focusedhealthxsell_commentid      bigint encode az64,
    clearspringsha_confirmedplanid       bigint encode az64,
    focusedhealthha_confirmedplanid      bigint encode az64,
    clearspringsales_commentid           bigint encode az64,
    aetnama_commentid                    bigint encode az64,
    medicalmutualma_commentid            bigint encode az64,
    medicalmutualhve_membercomplaintid   bigint encode az64,
    healthfirst_transfercustomerid       bigint encode az64,
    ascendbrokerhelpdesk_helpdeskissueid bigint encode az64,
    zinghealthha_confirmedplanid         bigint encode az64,
    zinghealthha_pcpinfoid               bigint encode az64,
    mmohve_pcpinfoid                     bigint encode az64,
    hf_verifymarxid                      bigint encode az64,
    refresh_timestamp                    timestamp,
    data_transfer_log_id                 bigint encode az64,
    md5_hash                             varchar(32),
    record_version                       bigint encode az64
);

alter table ccs_history.callcomments_history
    owner to etluser;

grant select on ccs_history.callcomments_history to group named_user_ro;

create table if not exists ccs_history.bloomcarriergroup_history
(
    pkcarriergroup       bigint encode az64,
    carriergroupname     varchar(50),
    isdeleted            boolean,
    carrierfk            bigint encode az64,
    auditusername        varchar(50),
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.bloomcarriergroup_history
    owner to etluser;

grant select on ccs_history.bloomcarriergroup_history to group named_user_ro;

create table if not exists ccs_history.dnismapping_history
(
    pkdnismapping        bigint encode az64,
    dnis                 varchar(10),
    dniscategoryfk       bigint encode az64,
    projectfk            bigint encode az64,
    lead_code            varchar(10),
    description          varchar(1000),
    dnis_cat_desc        varchar(50),
    project              varchar(100),
    sub_project          varchar(50),
    campaign             varchar(50),
    source               varchar(50),
    pi_tv                boolean,
    zone                 varchar(50),
    planname             varchar(60),
    transfer_from        varchar(50),
    scriptpage           varchar(100),
    bannertext           varchar(225),
    dnisstatusfk         bigint encode az64,
    modifieddate         timestamp encode az64,
    modifieduser         varchar(50),
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.dnismapping_history
    owner to etluser;

grant select on ccs_history.dnismapping_history to group named_user_ro;

create table if not exists ccs_history.callbacks_history
(
    callbackfk           bigint encode az64,
    contactnumber        varchar(32),
    callbackdatetime     timestamp encode az64,
    stationid            bigint encode az64 distkey,
    contactnumberfk      bigint encode az64,
    contactinfofk        bigint encode az64,
    poolfk               bigint encode az64,
    comments             varchar(65000),
    userfk               bigint encode az64,
    agentgroupfk         bigint encode az64,
    voicememopath        varchar(250),
    listsourcefk         bigint encode az64,
    queryfk              bigint encode az64,
    callbacktype         bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.callbacks_history
    owner to etluser;

grant select on ccs_history.callbacks_history to group named_user_ro;

create table if not exists ccs_history.agentsigninoutlog_history
(
    pkrowid              bigint encode az64 distkey,
    usersfk              bigint encode az64,
    signin               timestamp encode az64,
    signout              timestamp encode az64,
    stationid            bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.agentsigninoutlog_history
    owner to etluser;

grant select on ccs_history.agentsigninoutlog_history to group named_user_ro;

create table if not exists ccs_history.bloom_reportschedule_history
(
    id                   bigint encode az64 distkey,
    pookfk               bigint encode az64,
    reportname           varchar(256),
    begdate              timestamp encode az64,
    enddate              timestamp encode az64,
    dayofweek            bigint encode az64,
    beghour              bigint encode az64,
    endhour              bigint encode az64,
    isdeleted            boolean,
    auditusername        varchar(200),
    notes                varchar(500),
    isarchived           boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.bloom_reportschedule_history
    owner to etluser;

grant select on ccs_history.bloom_reportschedule_history to group named_user_ro;

create table if not exists ccs_history.ssrsfilesharesubscriptions_history_history
(
    pkid                 bigint encode az64,
    clientname           varchar(100),
    reportname           varchar(100),
    filename             varchar(200),
    filesharepath        varchar(200),
    includereport        boolean,
    renderformat         varchar(20),
    fileextension        boolean,
    isactive             boolean,
    dateintervalfk       bigint encode az64,
    datecreated          timestamp encode az64,
    requestername        varchar(100),
    notes                varchar(100),
    validfrom            timestamp encode az64,
    validto              timestamp encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
);

alter table ccs_history.ssrsfilesharesubscriptions_history_history
    owner to etluser;

grant select on ccs_history.ssrsfilesharesubscriptions_history_history to group named_user_ro;

create table if not exists ccs_history.projecttoenginesmap_history
(
    projectfk            bigint encode az64,
    engineid             bigint encode az64 distkey,
    numberoflines        bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.projecttoenginesmap_history
    owner to etluser;

grant select on ccs_history.projecttoenginesmap_history to group named_user_ro;

create table if not exists ccs_history.bloom_areacodestate_mapping_history
(
    pkareacodestatemapping bigint encode az64,
    areacode               varchar(150),
    region                 varchar(150),
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32),
    record_version         bigint encode az64
);

alter table ccs_history.bloom_areacodestate_mapping_history
    owner to etluser;

grant select on ccs_history.bloom_areacodestate_mapping_history to group named_user_ro;

create table if not exists ccs_history.pools_history
(
    pkpool               bigint encode az64,
    name                 varchar(255),
    databasename         varchar(255),
    dbtype               bigint encode az64,
    databaseserver       varchar(255),
    dbusername           varchar(50),
    dbpassword           varchar(50),
    dbusewindowssecurity boolean,
    isactive             boolean,
    isopen               boolean,
    isrunning            boolean,
    outboundscriptfk     bigint encode az64,
    verificationscriptfk bigint encode az64,
    manualdialscriptfk   bigint encode az64,
    callbackscriptfk     bigint encode az64,
    anitosend            varchar(50),
    bypassmdnc           boolean,
    starttime            varchar(15),
    stoptime             varchar(15),
    daysmap              bigint encode az64,
    companyname          varchar(255),
    idleonexhaust        boolean,
    ispaused             boolean,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.pools_history
    owner to etluser;

grant select on ccs_history.pools_history to group named_user_ro;

create table if not exists ccs_history.engines_history
(
    pkengine             bigint encode az64,
    name                 varchar(50),
    host                 varchar(50),
    port                 bigint encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.engines_history
    owner to etluser;

grant select on ccs_history.engines_history to group named_user_ro;

create table if not exists ccs_history.agentgrouploginhistorymap_history
(
    agentgroupsfk        bigint encode az64,
    poolsfk              bigint encode az64,
    start                timestamp encode az64,
    stop                 timestamp encode az64,
    refresh_timestamp    timestamp,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32),
    record_version       bigint encode az64
)
    sortkey (refresh_timestamp);

alter table ccs_history.agentgrouploginhistorymap_history
    owner to etluser;

grant select on ccs_history.agentgrouploginhistorymap_history to group named_user_ro;

create table if not exists ccs_history.emailprojects_history
(
    pkemailproject             bigint encode az64,
    name                       varchar(64),
    databasetype               bigint encode az64,
    databasename               varchar(256),
    databaseserver             varchar(256),
    dbuserid                   varchar(50) distkey,
    dbpassword                 varchar(50),
    dbuseswindows              boolean,
    allowmanualemails          boolean,
    allowtemplatesonly         boolean,
    allowresponsetosender      boolean,
    allowcc                    boolean,
    allowresponsetoall         boolean,
    allowbcc                   boolean,
    overflowintogroupfk        bigint encode az64,
    fromaddress                varchar(256),
    fromdisplayname            varchar(256),
    autoresponseavailablefk    bigint encode az64,
    autoresponsenotavailablefk bigint encode az64,
    outgoingserveraddress      varchar(256),
    outgoingport               bigint encode az64,
    outgoingencrypted          boolean,
    outgoingusername           varchar(256),
    outgoingpassword           varchar(256),
    allowmanualdial            boolean,
    callbacktype               bigint encode az64,
    isrunning                  boolean,
    manualdialscriptfk         bigint encode az64,
    callbackscriptfk           bigint encode az64,
    anitosend                  varchar(64),
    bypassmdnc                 boolean,
    emailscriptfk              bigint encode az64,
    engineid                   bigint encode az64,
    refresh_timestamp          timestamp encode az64,
    data_transfer_log_id       bigint encode az64,
    md5_hash                   varchar(32),
    record_version             bigint encode az64
);

alter table ccs_history.emailprojects_history
    owner to etluser;

grant select on ccs_history.emailprojects_history to group named_user_ro;

create table if not exists ccs_history.users_history
(
    pkusers                        bigint encode az64,
    name                           varchar(32),
    login                          varchar(32),
    password                       varchar(32),
    issupervisor                   boolean,
    isoutbound                     boolean,
    isinbound                      boolean,
    isverification                 boolean,
    ismanualdial                   boolean,
    isemail                        boolean,
    skilllevel                     bigint encode az64,
    userlanguage                   bigint encode az64,
    deleted                        boolean,
    isloggedin                     boolean,
    playvoicemailthroughpcspeakers boolean,
    voicemailgreeting              varchar(100),
    viewdeletedvoicemails          boolean,
    extension                      bigint encode az64,
    isadminsiteaccess              boolean,
    voicemailboxfk                 bigint encode az64,
    startdate                      timestamp encode az64,
    firstname                      varchar(20),
    lastname                       varchar(50),
    teamname                       varchar(20),
    isteammanager                  boolean,
    islicensedagent                boolean,
    isuambrpuser                   boolean,
    uam_eeid                       varchar(255),
    isbaamuser                     boolean,
    salt                           varchar(32),
    password2                      varchar(32),
    refresh_timestamp              timestamp encode az64,
    data_transfer_log_id           bigint encode az64,
    md5_hash                       varchar(32),
    record_version                 bigint encode az64
);

alter table ccs_history.users_history
    owner to etluser;

grant select on ccs_history.users_history to group named_user_ro;

create table if not exists landing_ccs.bloomenrollment
(
    bloomenrollmentid     bigint encode az64 distkey,
    bloomenrollmentguid   varchar(75),
    contactinfofk         double precision,
    enrollmentid          varchar(256),
    verificationid        varchar(50),
    enrollmenturi         varchar(300),
    planfk                double precision,
    premiumquote          double precision,
    paymentmethod         varchar(50),
    paymentfrequency      varchar(50),
    verificationcalldate  timestamp encode az64,
    hicn                  varchar(50),
    planid                varchar(50),
    planeffectivedate     varchar(10),
    product               varchar(12),
    proposedeffectivedate timestamp encode az64,
    enrollmenttype        varchar(10),
    caseid                varchar(50),
    enrollquoteid         varchar(50),
    validationid          varchar(50),
    binderpayment         varchar(50),
    newenrollplanchange   varchar(20),
    agentemail            varchar(50),
    agentawn_npn          varchar(50),
    hcontract             varchar(50),
    pbp                   varchar(50),
    segmentid             varchar(50),
    planyear              varchar(4),
    carrier               varchar(50),
    plantype              varchar(50),
    gender                varchar(30),
    refresh_timestamp     timestamp encode az64
);

alter table landing_ccs.bloomenrollment
    owner to etluser;

create table if not exists staging_ccs.bloomenrollment
(
    bloomenrollmentid     bigint encode az64 distkey,
    bloomenrollmentguid   varchar(75),
    contactinfofk         bigint encode az64,
    enrollmentid          varchar(256),
    verificationid        varchar(50),
    enrollmenturi         varchar(300),
    planfk                bigint encode az64,
    premiumquote          double precision,
    paymentmethod         varchar(50),
    paymentfrequency      varchar(50),
    verificationcalldate  timestamp encode az64,
    hicn                  varchar(50),
    planid                varchar(50),
    planeffectivedate     varchar(10),
    product               varchar(12),
    proposedeffectivedate timestamp encode az64,
    enrollmenttype        varchar(10),
    caseid                varchar(50),
    enrollquoteid         varchar(50),
    validationid          varchar(50),
    binderpayment         varchar(50),
    newenrollplanchange   varchar(20),
    agentemail            varchar(50),
    agentawn_npn          varchar(50),
    hcontract             varchar(50),
    pbp                   varchar(50),
    segmentid             varchar(50),
    planyear              varchar(4),
    carrier               varchar(50),
    plantype              varchar(50),
    gender                varchar(30),
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.bloomenrollment
    owner to etluser;

create table if not exists integrated_ccs.bloomenrollment
(
    dw_table_pk           bigint default "identity"(571172, 0, '0,1'::text) encode az64,
    bloomenrollmentid     bigint encode az64 distkey,
    bloomenrollmentguid   varchar(75),
    contactinfofk         bigint encode az64,
    enrollmentid          varchar(256),
    verificationid        varchar(50),
    enrollmenturi         varchar(300),
    planfk                bigint encode az64,
    premiumquote          double precision,
    paymentmethod         varchar(50),
    paymentfrequency      varchar(50),
    verificationcalldate  timestamp encode az64,
    hicn                  varchar(50),
    planid                varchar(50),
    planeffectivedate     varchar(10) encode bytedict,
    product               varchar(12) encode bytedict,
    proposedeffectivedate timestamp encode az64,
    enrollmenttype        varchar(10) encode bytedict,
    caseid                varchar(50),
    enrollquoteid         varchar(50),
    validationid          varchar(50),
    binderpayment         varchar(50),
    newenrollplanchange   varchar(20) encode bytedict,
    agentemail            varchar(50),
    agentawn_npn          varchar(50),
    hcontract             varchar(50),
    pbp                   varchar(50),
    segmentid             varchar(50),
    planyear              varchar(4),
    carrier               varchar(50),
    plantype              varchar(50),
    gender                varchar(30) encode bytedict,
    refresh_timestamp     timestamp encode az64,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table integrated_ccs.bloomenrollment
    owner to etluser;

grant select on integrated_ccs.bloomenrollment to group named_user_ro;

create table if not exists landing_ccs.emails
(
    pkemail           bigint encode az64,
    projectfk         bigint encode az64,
    mailboxfk         bigint encode az64,
    projecttype       bigint encode az64,
    fromaddress       varchar(1024),
    replytoaddress    varchar(1024),
    toaddress         varchar(65000),
    ccaddress         varchar(65000),
    received          timestamp encode az64,
    header            varchar(65000),
    subject           varchar(65000),
    body              varchar(65000),
    mime              varchar(65000),
    parentemailfk     bigint encode az64,
    contactemailfk    bigint encode az64,
    incoming          boolean,
    priority          bigint encode az64,
    status            bigint encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.emails
    owner to etluser;

create table if not exists staging_ccs.emails
(
    pkemail               bigint encode az64,
    projectfk             bigint encode az64,
    mailboxfk             bigint encode az64,
    projecttype           bigint encode az64,
    fromaddress           varchar(1024),
    replytoaddress        varchar(1024),
    toaddress             varchar(65000),
    ccaddress             varchar(65000),
    received              timestamp encode az64,
    header                varchar(65000),
    subject               varchar(65000),
    body                  varchar(65000),
    mime                  varchar(65000),
    parentemailfk         bigint encode az64,
    contactemailfk        bigint encode az64,
    incoming              boolean,
    priority              bigint encode az64,
    status                bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.emails
    owner to etluser;

create table if not exists integrated_ccs.emails
(
    dw_table_pk          bigint default "identity"(571199, 0, '0,1'::text) encode az64,
    pkemail              bigint encode az64,
    projectfk            bigint encode az64,
    mailboxfk            bigint encode az64,
    projecttype          bigint encode az64,
    fromaddress          varchar(1024),
    replytoaddress       varchar(1024),
    toaddress            varchar(65000),
    ccaddress            varchar(65000),
    received             timestamp encode az64,
    header               varchar(65000),
    subject              varchar(65000),
    body                 varchar(65000),
    mime                 varchar(65000),
    parentemailfk        bigint encode az64,
    contactemailfk       bigint encode az64,
    incoming             boolean,
    priority             bigint encode az64,
    status               bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.emails
    owner to etluser;

grant select on integrated_ccs.emails to group named_user_ro;

create table if not exists landing_ccs.emailboxes
(
    pkmailbox         bigint encode az64,
    emailprojectfk    bigint encode az64,
    name              varchar(64),
    serveraddress     varchar(256),
    port              bigint encode az64,
    encrypted         boolean,
    username          varchar(256),
    password          varchar(256),
    protocol          bigint encode az64,
    category          bigint encode az64,
    refresh_timestamp timestamp encode az64
);

alter table landing_ccs.emailboxes
    owner to etluser;

create table if not exists staging_ccs.emailboxes
(
    pkmailbox             bigint encode az64,
    emailprojectfk        bigint encode az64,
    name                  varchar(64),
    serveraddress         varchar(256),
    port                  bigint encode az64,
    encrypted             boolean,
    username              varchar(256),
    password              varchar(256),
    protocol              bigint encode az64,
    category              bigint encode az64,
    refresh_timestamp     timestamp encode az64,
    data_action_indicator char    default 'N'::bpchar,
    processed_flag        boolean default false,
    data_transfer_log_id  bigint encode az64,
    md5_hash              varchar(32)
);

alter table staging_ccs.emailboxes
    owner to etluser;

create table if not exists integrated_ccs.emailboxes
(
    dw_table_pk          bigint default "identity"(571211, 0, '0,1'::text) encode az64,
    pkmailbox            bigint encode az64,
    emailprojectfk       bigint encode az64,
    name                 varchar(64),
    serveraddress        varchar(256),
    port                 bigint encode az64,
    encrypted            boolean,
    username             varchar(256),
    password             varchar(256),
    protocol             bigint encode az64,
    category             bigint encode az64,
    refresh_timestamp    timestamp encode az64,
    data_transfer_log_id bigint encode az64,
    md5_hash             varchar(32)
);

alter table integrated_ccs.emailboxes
    owner to etluser;

grant select on integrated_ccs.emailboxes to group named_user_ro;

create table if not exists landing_ccs.queries
(
    pkqueries              bigint,
    name                   varchar(255),
    sqltext                varchar(65000),
    databasestructure      varchar(65000),
    availablesqltext       varchar(65000),
    availablecampaignslist varchar(500),
    sortbyphonetype        boolean,
    sortbylastcontacted    boolean,
    agentfk                double precision,
    totalsqltext           varchar(65000),
    dialingsqltext         varchar(65000),
    persistonexhaust       boolean,
    refresh_timestamp      timestamp encode az64
)
    sortkey (pkqueries);

alter table landing_ccs.queries
    owner to etluser;

create table if not exists staging_ccs.queries
(
    pkqueries              bigint encode az64,
    name                   varchar(255),
    sqltext                varchar(65000),
    databasestructure      varchar(65000),
    availablesqltext       varchar(65000),
    availablecampaignslist varchar(500),
    sortbyphonetype        boolean,
    sortbylastcontacted    boolean,
    agentfk                bigint encode az64,
    totalsqltext           varchar(65000),
    dialingsqltext         varchar(65000),
    persistonexhaust       boolean,
    refresh_timestamp      timestamp encode az64,
    data_action_indicator  char    default 'N'::bpchar,
    processed_flag         boolean default false,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table staging_ccs.queries
    owner to etluser;

create table if not exists integrated_ccs.queries
(
    dw_table_pk            bigint default "identity"(571223, 0, '0,1'::text) encode az64,
    pkqueries              bigint encode az64,
    name                   varchar(255),
    sqltext                varchar(65000),
    databasestructure      varchar(65000),
    availablesqltext       varchar(65000),
    availablecampaignslist varchar(500),
    sortbyphonetype        boolean,
    sortbylastcontacted    boolean,
    agentfk                bigint encode az64,
    totalsqltext           varchar(65000),
    dialingsqltext         varchar(65000),
    persistonexhaust       boolean,
    refresh_timestamp      timestamp encode az64,
    data_transfer_log_id   bigint encode az64,
    md5_hash               varchar(32)
);

alter table integrated_ccs.queries
    owner to etluser;

grant select on integrated_ccs.queries to group named_user_ro;

create table if not exists integrated_ccs.bloom_vwcallstats
(
    pkcallresults         bigint encode az64,
    callresultcode        bigint encode az64,
    callresultdescription varchar(128),
    presentation          boolean,
    countaslead           boolean,
    printable             boolean,
    systemcode            boolean,
    nevercall             boolean,
    addtomasterdonotcall  boolean,
    verification          boolean,
    agentwrapendtime      timestamp encode az64,
    agentwrapseconds      numeric(26, 5) encode az64,
    calldurationseconds   numeric(26, 5) encode az64,
    editseconds           numeric(26, 5) encode az64,
    holdseconds           numeric(26, 5) encode az64,
    holdtime              timestamp encode az64,
    previewseconds        numeric(26, 5) encode az64,
    previewtime           timestamp encode az64,
    queueseconds          numeric(26, 5) encode az64,
    queueseconds_email    numeric(26, 5) encode az64,
    readingseconds        numeric(26, 5) encode az64,
    talkseconds           numeric(26, 5) encode az64,
    writingseconds        numeric(26, 5) encode az64,
    hourofcall            integer encode az64,
    halfhourofcall        integer encode az64,
    agentfk               bigint encode az64,
    name                  varchar(32),
    callendtime           timestamp encode az64,
    callstarttime         timestamp encode az64,
    calltype              bigint encode az64,
    call_type             varchar(15) encode bytedict,
    dnis                  varchar(32),
    dateofcall            timestamp encode az64,
    dniscategoryfk        bigint encode az64,
    dniscategoryname      varchar(50),
    mediacategoryname     varchar(50),
    callsenttoagenttime   timestamp encode az64,
    poolfk                bigint encode az64,
    contactnumberfk       bigint encode az64,
    projectname           varchar(255),
    databasename          varchar(256) encode bytedict,
    dbtype                bigint encode az64,
    databaseserver        varchar(256) encode bytedict,
    dbusername            varchar(50),
    dbpassword            varchar(50),
    dbusewindowssecurity  boolean,
    more_phone_numbers    boolean,
    outofhours            boolean,
    callline              varchar(512) encode bytedict,
    callwastransferred    boolean,
    overflowgroupfk       bigint encode az64,
    recordingfilename     varchar(260),
    calllist              varchar(255),
    query_id              bigint encode az64 distkey,
    contactnumber         varchar(32),
    autoattendant         boolean,
    exitstate             bigint encode az64,
    countascontact        boolean,
    finaldisposition      bigint encode az64,
    appointmentid         bigint encode az64,
    agentactionid         bigint encode az64,
    emailfk               bigint encode az64,
    projecttype           bigint encode az64,
    pkemail               bigint encode az64,
    mailboxfk             bigint encode az64,
    mailboxname           varchar(64),
    fromaddress           varchar(1024),
    replytoaddress        varchar(1024),
    toaddress             varchar(65000),
    ccaddress             varchar(65000),
    received              timestamp encode az64,
    header                varchar(65000),
    subject               varchar(65000),
    body                  varchar(65000),
    mime                  varchar(65000),
    parentemailfk         bigint encode az64,
    contactemailfk        bigint encode az64,
    incoming              boolean,
    priority              bigint encode az64,
    status                bigint encode az64,
    statustext            varchar(17),
    version               varchar(11),
    callaccount           bigint encode az64,
    comment               varchar(1000),
    pkcomment             bigint encode az64,
    bloomenrollmentguid   varchar(75),
    bloomnosaleguid       varchar(75),
    countassale           boolean,
    bloomcallid           bigint encode az64,
    commentfk             bigint encode az64,
    refresh_timestamp     timestamp encode az64
);

alter table integrated_ccs.bloom_vwcallstats
    owner to etluser;

grant select on integrated_ccs.bloom_vwcallstats to group named_user_ro;

create table if not exists landing_aqe.wellcarecnc_snpeligibilityfile_archive
(
    pkwellcarecncsnpeligibilityfilearchiveid bigint encode az64,
    pkwellcarecncsnpeligibilityfileimportid  double precision,
    outreach_id                              varchar(256),
    outreach_start_date                      varchar(256),
    hra_due_date                             varchar(256),
    outreach_type                            varchar(256),
    outreach_category                        varchar(256),
    activity_date                            varchar(256),
    disengage_date                           varchar(256),
    disengage_reason                         varchar(256),
    contract_number                          varchar(256),
    plan_code                                varchar(256),
    member_id                                varchar(256),
    mbi                                      varchar(256),
    effective_date                           varchar(256),
    term_date                                varchar(256),
    program_type                             varchar(256),
    question_version                         varchar(256),
    member_first_name                        varchar(256),
    member_last_name                         varchar(256),
    member_dob                               varchar(256),
    member_gender                            varchar(256),
    member_preferred_language                varchar(256),
    member_address_1                         varchar(256),
    member_address_2                         varchar(256),
    member_city                              varchar(256),
    member_state                             varchar(256),
    member_zip                               varchar(256),
    member_phone_1                           varchar(256),
    member_phone_2                           varchar(256),
    member_phone_3                           varchar(256),
    member_phone_cell                        varchar(256),
    member_email_1                           varchar(256),
    member_email_2                           varchar(256),
    member_consent                           varchar(256),
    member_consent_date                      varchar(256),
    pcp_first_name                           varchar(256),
    pcp_last_name                            varchar(256),
    pcp_address_1                            varchar(256),
    pcp_address_2                            varchar(256),
    pcp_city                                 varchar(256),
    pcp_state                                varchar(256),
    pcp_zip                                  varchar(256),
    pcp_effective_date                       varchar(256),
    disenrolled_outreach_id                  varchar(256),
    datecreated                              timestamp encode az64,
    processed                                boolean,
    processeddate                            timestamp encode az64,
    importfilename                           varchar(256),
    isinvalidrecord                          boolean,
    carrierid                                double precision,
    isduplicate                              boolean,
    fkoutreachmemberinfoid                   double precision,
    sendtocallcenter                         boolean,
    aqedmlaction                             varchar(256),
    notes                                    varchar(256),
    fkmemberinformationid                    double precision,
    refresh_timestamp                        timestamp encode az64
);

alter table landing_aqe.wellcarecnc_snpeligibilityfile_archive
    owner to etluser;

create table if not exists staging_aqe.wellcarecnc_snpeligibilityfile_archive
(
    pkwellcarecncsnpeligibilityfilearchiveid bigint encode az64,
    pkwellcarecncsnpeligibilityfileimportid  bigint encode az64,
    outreach_id                              varchar(256),
    outreach_start_date                      varchar(256),
    hra_due_date                             varchar(256),
    outreach_type                            varchar(256),
    outreach_category                        varchar(256),
    activity_date                            varchar(256),
    disengage_date                           varchar(256),
    disengage_reason                         varchar(256),
    contract_number                          varchar(256),
    plan_code                                varchar(256),
    member_id                                varchar(256),
    mbi                                      varchar(256),
    effective_date                           varchar(256),
    term_date                                varchar(256),
    program_type                             varchar(256),
    question_version                         varchar(256),
    member_first_name                        varchar(256),
    member_last_name                         varchar(256),
    member_dob                               varchar(256),
    member_gender                            varchar(256),
    member_preferred_language                varchar(256),
    member_address_1                         varchar(256),
    member_address_2                         varchar(256),
    member_city                              varchar(256),
    member_state                             varchar(256),
    member_zip                               varchar(256),
    member_phone_1                           varchar(256),
    member_phone_2                           varchar(256),
    member_phone_3                           varchar(256),
    member_phone_cell                        varchar(256),
    member_email_1                           varchar(256),
    member_email_2                           varchar(256),
    member_consent                           varchar(256),
    member_consent_date                      varchar(256),
    pcp_first_name                           varchar(256),
    pcp_last_name                            varchar(256),
    pcp_address_1                            varchar(256),
    pcp_address_2                            varchar(256),
    pcp_city                                 varchar(256),
    pcp_state                                varchar(256),
    pcp_zip                                  varchar(256),
    pcp_effective_date                       varchar(256),
    disenrolled_outreach_id                  varchar(256),
    datecreated                              timestamp encode az64,
    processed                                boolean,
    processeddate                            timestamp encode az64,
    importfilename                           varchar(256),
    isinvalidrecord                          boolean,
    carrierid                                bigint encode az64,
    isduplicate                              boolean,
    fkoutreachmemberinfoid                   bigint encode az64,
    sendtocallcenter                         boolean,
    aqedmlaction                             varchar(256),
    notes                                    varchar(256),
    fkmemberinformationid                    bigint encode az64,
    refresh_timestamp                        timestamp encode az64,
    data_action_indicator                    char    default 'N'::bpchar,
    processed_flag                           boolean default false,
    data_transfer_log_id                     bigint encode az64,
    md5_hash                                 varchar(32)
);

alter table staging_aqe.wellcarecnc_snpeligibilityfile_archive
    owner to etluser;

create table if not exists integrated_aqe.wellcarecnc_snpeligibilityfile_archive
(
    dw_table_pk                              bigint default "identity"(587793, 0, '0,1'::text) encode az64,
    pkwellcarecncsnpeligibilityfilearchiveid bigint encode az64,
    pkwellcarecncsnpeligibilityfileimportid  bigint encode az64,
    outreach_id                              varchar(256),
    outreach_start_date                      varchar(256),
    hra_due_date                             varchar(256),
    outreach_type                            varchar(256),
    outreach_category                        varchar(256),
    activity_date                            varchar(256),
    disengage_date                           varchar(256),
    disengage_reason                         varchar(256),
    contract_number                          varchar(256),
    plan_code                                varchar(256),
    member_id                                varchar(256),
    mbi                                      varchar(256),
    effective_date                           varchar(256),
    term_date                                varchar(256),
    program_type                             varchar(256),
    question_version                         varchar(256),
    member_first_name                        varchar(256),
    member_last_name                         varchar(256),
    member_dob                               varchar(256),
    member_gender                            varchar(256),
    member_preferred_language                varchar(256),
    member_address_1                         varchar(256),
    member_address_2                         varchar(256),
    member_city                              varchar(256),
    member_state                             varchar(256),
    member_zip                               varchar(256),
    member_phone_1                           varchar(256),
    member_phone_2                           varchar(256),
    member_phone_3                           varchar(256),
    member_phone_cell                        varchar(256),
    member_email_1                           varchar(256),
    member_email_2                           varchar(256),
    member_consent                           varchar(256),
    member_consent_date                      varchar(256),
    pcp_first_name                           varchar(256),
    pcp_last_name                            varchar(256),
    pcp_address_1                            varchar(256),
    pcp_address_2                            varchar(256),
    pcp_city                                 varchar(256),
    pcp_state                                varchar(256),
    pcp_zip                                  varchar(256),
    pcp_effective_date                       varchar(256),
    disenrolled_outreach_id                  varchar(256),
    datecreated                              timestamp encode az64,
    processed                                boolean,
    processeddate                            timestamp encode az64,
    importfilename                           varchar(256),
    isinvalidrecord                          boolean,
    carrierid                                bigint encode az64,
    isduplicate                              boolean,
    fkoutreachmemberinfoid                   bigint encode az64,
    sendtocallcenter                         boolean,
    aqedmlaction                             varchar(256),
    notes                                    varchar(256),
    fkmemberinformationid                    bigint encode az64,
    refresh_timestamp                        timestamp encode az64,
    data_transfer_log_id                     bigint encode az64,
    md5_hash                                 varchar(32)
);

alter table integrated_aqe.wellcarecnc_snpeligibilityfile_archive
    owner to etluser;

grant select on integrated_aqe.wellcarecnc_snpeligibilityfile_archive to group named_user_ro;

create or replace view admin.v_generate_tbl_ddl(table_id, schemaname, tablename, seq, ddl) as
SELECT derived_table4.table_id,
       regexp_replace(derived_table4.schemaname::text, '^zzzzzzzz'::text, ''::text) AS schemaname,
       regexp_replace(derived_table4.tablename::text, '^zzzzzzzz'::text, ''::text)  AS tablename,
       derived_table4.seq,
       derived_table4.ddl
FROM (SELECT derived_table3.table_id,
             derived_table3.schemaname,
             derived_table3.tablename,
             derived_table3.seq,
             derived_table3.ddl
      FROM (((((((((((((((SELECT c.oid::bigint                                                 AS table_id,
                                 n.nspname                                                     AS schemaname,
                                 c.relname                                                     AS tablename,
                                 0                                                             AS seq,
                                 ('--DROP TABLE '::text + quote_ident(n.nspname::text) + '.'::text +
                                  quote_ident(c.relname::text) + ';'::text)::character varying AS ddl
                          FROM pg_namespace n
                                   JOIN pg_class c ON n.oid = c.relnamespace
                          WHERE c.relkind = 'r'::"char"
                          UNION
                          SELECT c.oid::bigint                                                AS table_id,
                                 n.nspname                                                    AS schemaname,
                                 c.relname                                                    AS tablename,
                                 2                                                            AS seq,
                                 ('CREATE TABLE IF NOT EXISTS '::text + quote_ident(n.nspname::text) + '.'::text +
                                  quote_ident(c.relname::text) + ''::text)::character varying AS ddl
                          FROM pg_namespace n
                                   JOIN pg_class c ON n.oid = c.relnamespace
                          WHERE c.relkind = 'r'::"char")
                         UNION
                         SELECT c.oid::bigint          AS table_id,
                                n.nspname              AS schemaname,
                                c.relname              AS tablename,
                                5                      AS seq,
                                '('::character varying AS ddl
                         FROM pg_namespace n
                                  JOIN pg_class c ON n.oid = c.relnamespace
                         WHERE c.relkind = 'r'::"char")
                        UNION
                        SELECT derived_table1.table_id,
                               derived_table1.schemaname,
                               derived_table1.tablename,
                               derived_table1.seq,
                               ('\011'::text + derived_table1.col_delim + derived_table1.col_name + ' '::text +
                                derived_table1.col_datatype + ' '::text + derived_table1.col_nullable + ' '::text +
                                derived_table1.col_default + ' '::text +
                                derived_table1.col_encoding)::character varying AS ddl
                        FROM (SELECT c.oid::bigint                AS table_id,
                                     n.nspname                    AS schemaname,
                                     c.relname                    AS tablename,
                                     100000000 + a.attnum         AS seq,
                                     CASE
                                         WHEN a.attnum > 1 THEN ','::text
                                         ELSE ''::text
                                         END                      AS col_delim,
                                     quote_ident(a.attname::text) AS col_name,
                                     CASE
                                         WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)),
                                                     'CHARACTER VARYING'::text) > 0 THEN "replace"(
                                                 upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING'::text,
                                                 'VARCHAR'::text)
                                         WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER'::text) > 0
                                             THEN "replace"(upper(format_type(a.atttypid, a.atttypmod)),
                                                            'CHARACTER'::text, 'CHAR'::text)
                                         ELSE upper(format_type(a.atttypid, a.atttypmod))
                                         END                      AS col_datatype,
                                     CASE
                                         WHEN format_encoding(a.attencodingtype::integer) = 'none'::bpchar
                                             THEN 'ENCODE RAW'::text
                                         ELSE 'ENCODE '::text + format_encoding(a.attencodingtype::integer)::text
                                         END                      AS col_encoding,
                                     CASE
                                         WHEN a.atthasdef IS TRUE THEN 'DEFAULT '::text + adef.adsrc
                                         ELSE ''::text
                                         END                      AS col_default,
                                     CASE
                                         WHEN a.attnotnull IS TRUE THEN 'NOT NULL'::text
                                         ELSE ''::text
                                         END                      AS col_nullable
                              FROM pg_namespace n
                                       JOIN pg_class c ON n.oid = c.relnamespace
                                       JOIN pg_attribute a ON c.oid = a.attrelid
                                       LEFT JOIN pg_attrdef adef ON a.attrelid = adef.adrelid AND a.attnum = adef.adnum
                              WHERE c.relkind = 'r'::"char"
                                AND a.attnum > 0
                              ORDER BY a.attnum) derived_table1)
                       UNION
                       (SELECT c.oid::bigint                                                      AS table_id,
                               n.nspname                                                          AS schemaname,
                               c.relname                                                          AS tablename,
                               200000000 + mod(con.oid::integer, 100000000)                       AS seq,
                               ('\011,'::text + pg_get_constraintdef(con.oid))::character varying AS ddl
                        FROM pg_constraint con
                                 JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
                                 JOIN pg_namespace n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'r'::"char"
                          AND pg_get_constraintdef(con.oid) !~~ 'FOREIGN KEY%'::text
                        ORDER BY 200000000 + mod(con.oid::integer, 100000000)))
                      UNION
                      SELECT c.oid::bigint          AS table_id,
                             n.nspname              AS schemaname,
                             c.relname              AS tablename,
                             299999999              AS seq,
                             ')'::character varying AS ddl
                      FROM pg_namespace n
                               JOIN pg_class c ON n.oid = c.relnamespace
                      WHERE c.relkind = 'r'::"char")
                     UNION
                     SELECT c.oid::bigint                  AS table_id,
                            n.nspname                      AS schemaname,
                            c.relname                      AS tablename,
                            300000000                      AS seq,
                            'BACKUP NO'::character varying AS ddl
                     FROM pg_namespace n
                              JOIN pg_class c ON n.oid = c.relnamespace
                              JOIN (SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                                    FROM pg_conf
                                    WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text
                                      AND split_part(pg_conf."key"::text, '_'::text, 4) = ((SELECT pg_database.oid
                                                                                            FROM pg_database
                                                                                            WHERE pg_database.datname = current_database()))::text) t
                                   ON t.id = c.oid::text
                     WHERE c.relkind = 'r'::"char")
                    UNION
                    SELECT c.oid::bigint                                                                                   AS table_id,
                           n.nspname                                                                                       AS schemaname,
                           c.relname                                                                                       AS tablename,
                           1                                                                                               AS seq,
                           '--WARNING: This DDL inherited the BACKUP NO property from the source table'::character varying AS ddl
                    FROM pg_namespace n
                             JOIN pg_class c ON n.oid = c.relnamespace
                             JOIN (SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                                   FROM pg_conf
                                   WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text
                                     AND split_part(pg_conf."key"::text, '_'::text, 4) = ((SELECT pg_database.oid
                                                                                           FROM pg_database
                                                                                           WHERE pg_database.datname = current_database()))::text) t
                                  ON t.id = c.oid::text
                    WHERE c.relkind = 'r'::"char")
                   UNION
                   SELECT c.oid::bigint              AS table_id,
                          n.nspname                  AS schemaname,
                          c.relname                  AS tablename,
                          300000001                  AS seq,
                          CASE
                              WHEN c.reldiststyle = 0 THEN 'DISTSTYLE EVEN'::text
                              WHEN c.reldiststyle = 1 THEN 'DISTSTYLE KEY'::text
                              WHEN c.reldiststyle = 8 THEN 'DISTSTYLE ALL'::text
                              WHEN c.reldiststyle = 9 THEN 'DISTSTYLE AUTO'::text
                              ELSE '<<Error - UNKNOWN DISTSTYLE>>'::text
                              END::character varying AS ddl
                   FROM pg_namespace n
                            JOIN pg_class c ON n.oid = c.relnamespace
                   WHERE c.relkind = 'r'::"char")
                  UNION
                  SELECT c.oid::bigint                                                                      AS table_id,
                         n.nspname                                                                          AS schemaname,
                         c.relname                                                                          AS tablename,
                         400000000 + a.attnum                                                               AS seq,
                         (' DISTKEY ('::text + quote_ident(a.attname::text) + ')'::text)::character varying AS ddl
                  FROM pg_namespace n
                           JOIN pg_class c ON n.oid = c.relnamespace
                           JOIN pg_attribute a ON c.oid = a.attrelid
                  WHERE c.relkind = 'r'::"char"
                    AND a.attisdistkey IS TRUE
                    AND a.attnum > 0)
                 UNION
                 SELECT derived_table2.table_id,
                        derived_table2.schemaname,
                        derived_table2.tablename,
                        derived_table2.seq,
                        CASE
                            WHEN derived_table2.min_sort < 0 THEN 'INTERLEAVED SORTKEY ('::text
                            ELSE ' SORTKEY ('::text
                            END::character varying AS ddl
                 FROM (SELECT c.oid::bigint        AS table_id,
                              n.nspname            AS schemaname,
                              c.relname            AS tablename,
                              499999999            AS seq,
                              min(a.attsortkeyord) AS min_sort
                       FROM pg_namespace n
                                JOIN pg_class c ON n.oid = c.relnamespace
                                JOIN pg_attribute a ON c.oid = a.attrelid
                       WHERE c.relkind = 'r'::"char"
                         AND abs(a.attsortkeyord) > 0
                         AND a.attnum > 0
                       GROUP BY c.oid::bigint, n.nspname, c.relname, 4) derived_table2)
                UNION
                (SELECT c.oid::bigint                    AS table_id,
                        n.nspname                        AS schemaname,
                        c.relname                        AS tablename,
                        500000000 + abs(a.attsortkeyord) AS seq,
                        CASE
                            WHEN abs(a.attsortkeyord) = 1 THEN '\011'::text + quote_ident(a.attname::text)
                            ELSE '\011, '::text + quote_ident(a.attname::text)
                            END::character varying       AS ddl
                 FROM pg_namespace n
                          JOIN pg_class c ON n.oid = c.relnamespace
                          JOIN pg_attribute a ON c.oid = a.attrelid
                 WHERE c.relkind = 'r'::"char"
                   AND abs(a.attsortkeyord) > 0
                   AND a.attnum > 0
                 ORDER BY abs(a.attsortkeyord)))
               UNION
               SELECT c.oid::bigint              AS table_id,
                      n.nspname                  AS schemaname,
                      c.relname                  AS tablename,
                      599999999                  AS seq,
                      '\011)'::character varying AS ddl
               FROM pg_namespace n
                        JOIN pg_class c ON n.oid = c.relnamespace
                        JOIN pg_attribute a ON c.oid = a.attrelid
               WHERE c.relkind = 'r'::"char"
                 AND abs(a.attsortkeyord) > 0
                 AND a.attnum > 0)
              UNION
              SELECT c.oid::bigint          AS table_id,
                     n.nspname              AS schemaname,
                     c.relname              AS tablename,
                     600000000              AS seq,
                     ';'::character varying AS ddl
              FROM pg_namespace n
                       JOIN pg_class c ON n.oid = c.relnamespace
              WHERE c.relkind = 'r'::"char")
             UNION
             SELECT c.oid::bigint                                        AS table_id,
                    n.nspname                                            AS schemaname,
                    c.relname                                            AS tablename,
                    600250000                                            AS seq,
                    ('COMMENT ON '::character varying::text +
                     nvl2(cl.column_name, 'column '::character varying, 'table '::character varying)::text +
                     quote_ident(n.nspname::character varying::text) + '.'::character varying::text +
                     quote_ident(c.relname::character varying::text) +
                     nvl2(cl.column_name, '.'::character varying::text + cl.column_name::character varying::text,
                          ''::character varying::text) + ' IS \''::character varying::text + btrim(des.description) +
                     '\'; '::character varying::text)::character varying AS ddl
             FROM pg_description des
                      JOIN pg_class c ON c.oid = des.objoid
                      JOIN pg_namespace n ON n.oid = c.relnamespace
                      LEFT JOIN information_schema."columns" cl
                                ON cl.ordinal_position::integer = des.objsubid AND cl.table_name::name = c.relname
             WHERE c.relkind = 'r'::"char")
            UNION
            SELECT c.oid::bigint                                                                      AS table_id,
                   n.nspname                                                                          AS schemaname,
                   c.relname                                                                          AS tablename,
                   600500000                                                                          AS seq,
                   ('ALTER TABLE '::text + quote_ident(n.nspname::text) + '.'::text + quote_ident(c.relname::text) +
                    ' owner to '::text + quote_ident(u.usename::text) + ';'::text)::character varying AS ddl
            FROM pg_namespace n
                     JOIN pg_class c ON n.oid = c.relnamespace
                     JOIN pg_user u ON c.relowner = u.usesysid
            WHERE c.relkind = 'r'::"char") derived_table3
      UNION
      (SELECT c.oid::bigint                                            AS table_id,
              ('zzzzzzzz'::text || n.nspname::text)::character varying AS schemaname,
              ('zzzzzzzz'::text || c.relname::text)::character varying AS tablename,
              700000000 + mod(con.oid::integer, 100000000)             AS seq,
              ('ALTER TABLE '::text + quote_ident(n.nspname::text) + '.'::text + quote_ident(c.relname::text) +
               ' ADD '::text + pg_get_constraintdef(con.oid)::character varying(10240)::text +
               ';'::text)::character varying                           AS ddl
       FROM pg_constraint con
                JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
                JOIN pg_namespace n ON n.oid = c.relnamespace
       WHERE c.relkind = 'r'::"char"
         AND con.contype = 'f'::"char"
       ORDER BY 700000000 + mod(con.oid::integer, 100000000))
      ORDER BY 1, 2, 3, 4) derived_table4;

alter table admin.v_generate_tbl_ddl
    owner to dbadmin;

grant select on admin.v_generate_tbl_ddl to etluser;

create or replace view admin.v_find_dropuser_objs(objtype, objowner, userid, schemaname, objname, ddl) as
SELECT "owner".objtype, "owner".objowner, "owner".userid, "owner".schemaname, "owner".objname, "owner".ddl
FROM ((((SELECT 'Function'::character varying,
                pgu.usename,
                pgu.usesysid,
                nc.nspname,
                textin(regprocedureout(pproc.oid::regprocedure))::character varying AS textin,
                (((('alter '::text ||
                    CASE
                        WHEN pproc.prorettype = 0::oid THEN 'procedure'::text
                        ELSE 'function'::text
                        END) || ' '::text) || textin(regprocedureout(pproc.oid::regprocedure))) ||
                 ' owner to '::text)::character varying
         FROM pg_proc pproc,
              pg_user pgu,
              pg_namespace nc
         WHERE pproc.pronamespace = nc.oid
           AND pproc.proowner = pgu.usesysid
         UNION ALL
         SELECT 'Database'::character varying,
                pgu.usename,
                pgu.usesysid,
                NULL::name,
                pgd.datname,
                (('alter database '::text || quote_ident(pgd.datname::text)) || ' owner to '::text)::character varying
         FROM pg_database pgd,
              pg_user pgu
         WHERE pgd.datdba = pgu.usesysid)
        UNION ALL
        SELECT 'Schema'::character varying,
               pgu.usename,
               pgu.usesysid,
               NULL::name,
               pgn.nspname,
               (('alter schema '::text || quote_ident(pgn.nspname::text)) || ' owner to '::text)::character varying
        FROM pg_namespace pgn,
             pg_user pgu
        WHERE pgn.nspowner = pgu.usesysid)
       UNION ALL
       SELECT CASE
                  WHEN pgc.relkind = 'r'::"char" OR pgc.relkind IS NULL AND 'r' IS NULL THEN 'Table'::text
                  WHEN pgc.relkind = 'v'::"char" OR pgc.relkind IS NULL AND 'v' IS NULL THEN 'View'::text
                  ELSE NULL::text
                  END::character varying AS "case",
              pgu.usename,
              pgu.usesysid,
              nc.nspname,
              pgc.relname,
              (((('alter table '::text || quote_ident(nc.nspname::text)) || '.'::text) ||
                quote_ident(pgc.relname::text)) || ' owner to '::text)::character varying
       FROM pg_class pgc,
            pg_user pgu,
            pg_namespace nc
       WHERE pgc.relnamespace = nc.oid
         AND (pgc.relkind = 'r'::"char" OR pgc.relkind = 'v'::"char")
         AND pgu.usesysid = pgc.relowner
         AND nc.nspname !~~* 'pg_temp_%'::text)
      UNION ALL
      SELECT 'Library'::character varying,
             pgu.usename,
             pgu.usesysid,
             ''::name,
             pgl.name,
             'No DDL available for Python Library. You should DROP OR REPLACE the Python Library'::character varying
      FROM pg_library pgl,
           pg_user pgu
      WHERE pgl."owner" = pgu.usesysid) "owner"(objtype, objowner, userid, schemaname, objname, ddl)
WHERE "owner".userid > 1;

alter table admin.v_find_dropuser_objs
    owner to dbadmin;

