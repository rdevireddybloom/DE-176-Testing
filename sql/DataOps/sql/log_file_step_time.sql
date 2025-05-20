-- initial version, needs tweaking yet:

select c.data_transfer_config_id, data_transfer_type, source_host, source_db, source_schema, source_table,
       target_identifier, target_table, c.overlap_treatment, l.transfer_count, l.start_datetime,
       l.transfer_end_datetime - l.start_datetime as transfer_time,
       l.landing_end_datetime - l.transfer_end_datetime as landing_time,
       l.staging_end_datetime - l.landing_end_datetime as staging_time,
       l.data_prep_end_datetime - l.start_datetime as total_data_prep_time,
       l.finalize_table_end_datetime - l.finalize_table_start_datetime as finalizing_time
from data_operations.data_transfer_target t
    join data_operations.data_transfer_config c on t.data_transfer_target_id = c.data_transfer_target_id
    join data_operations.data_transfer_log l on c.data_transfer_config_id = l.data_transfer_config_id
order by start_datetime desc;