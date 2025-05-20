create table if not exists data_operations.data_transfer_target
(
    data_transfer_target_id bigint generated always as identity
        primary key,
    target_identifier       varchar(256),
    target_table            varchar(256),
    schedule                varchar(64),
    run_order               double precision,
    unique_record_fields    text,
    incr_where_clause       text,
    full_where_clause       text,
    track_history           boolean   default false,
    history_tracking_setup  boolean   default false,
    effective_start_date    date,
    effective_end_date      date      default '2099-12-31'::date,
    created_by              varchar(64),
    created_at              timestamp default CURRENT_TIMESTAMP,
    last_modified_by        varchar(64),
    last_modified_at        timestamp default CURRENT_TIMESTAMP,
    notes                   text,
    currently_running       boolean default false
);

create unique index if not exists unidx_tgt_id_name
    on data_operations.data_transfer_target (target_identifier, target_table, schedule);

create index if not exists idx_dt_tgt_schedule
    on data_operations.data_transfer_target (schedule);

grant delete, insert, references, select, trigger, truncate, update on data_operations.data_transfer_target to etluser;

grant delete, insert, select, update on data_operations.data_transfer_target to rdevireddy;


create table if not exists data_operations.data_transfer_sql
(
    data_transfer_sql_id bigint generated always as identity
        primary key,
    transfer_sql         text,
    created_by           varchar(64),
    created_at           timestamp default CURRENT_TIMESTAMP,
    last_modified_by     varchar(64),
    last_modified_at     timestamp default CURRENT_TIMESTAMP,
    notes                text
);

grant select on data_operations.data_transfer_sql to etluser;

grant delete, insert, select, update on data_operations.data_transfer_sql to rdevireddy;


create table if not exists data_operations.data_transfer_config
(
    data_transfer_config_id    bigint generated always as identity
        primary key,
    data_transfer_type         varchar(64),
    source_host                varchar(256),
    source_db                  varchar(256),
    source_schema              varchar(256),
    source_table               varchar(256),
    data_transfer_sql_id       bigint
        constraint fk_config_sql
            references data_operations.data_transfer_sql,
    data_transfer_sql_desc     varchar(256),
    reference_id               bigint,
    effective_start_date       date,
    effective_end_date         date         default '2099-12-31'::date,
    created_by                 varchar(64),
    created_at                 timestamp    default CURRENT_TIMESTAMP,
    last_modified_by           varchar(64),
    last_modified_at           timestamp    default CURRENT_TIMESTAMP,
    notes                      text,
    overlap_treatment          varchar(32),
    force_full_run_update      boolean      default false,
    run_now                    boolean      default false,
    override_incr_where_clause varchar(256) default NULL::character varying,
    data_transfer_target_id    bigint
        constraint fk_config_target
            references data_operations.data_transfer_target,
    override_schedule          varchar(64) default NULL::character varying,
    max_pk_value               bigint default 0,
    pk_val_lookback_cnt        bigint default 0
);

create unique index if not exists unidx_dt_config_src_info
    on data_operations.data_transfer_config (source_host, source_db, source_schema, source_table, data_transfer_target_id);

create index if not exists idx_dt_config_run_now
    on data_operations.data_transfer_config (run_now);

create index if not exists idx_dt_config_target
    on data_operations.data_transfer_config (data_transfer_target_id);

create index if not exists idx_dt_config_sql
    on data_operations.data_transfer_config (data_transfer_sql_id);

grant delete, insert, references, select, trigger, truncate, update on data_operations.data_transfer_config to etluser;

grant delete, insert, select, update on data_operations.data_transfer_config to rdevireddy;


create table if not exists data_operations.data_transfer_log
(
    data_transfer_log_id          bigint generated always as identity
        constraint data_transfer_log_new_pk
            primary key,
    data_transfer_config_id       bigint,
    run_status                    varchar(64),
    start_datetime                timestamp,
    transfer_end_datetime         timestamp,
    landing_end_datetime          timestamp,
    staging_end_datetime          timestamp,
    data_prep_end_datetime        timestamp,
    transfer_count                bigint,
    landed_count                  bigint,
    insert_count                  bigint,
    update_count                  bigint,
    delete_count                  bigint,
    finalize_table_start_datetime timestamp,
    finalize_table_end_datetime   timestamp
);

create index if not exists idx_dt_log_run_status
    on data_operations.data_transfer_log (run_status);

create index if not exists idx_dt_log_config
    on data_operations.data_transfer_log (data_transfer_config_id);

grant delete, insert, references, select, trigger, truncate, update on data_operations.data_transfer_log to etluser;

grant delete, insert, select, update on data_operations.data_transfer_log to rdevireddy;

