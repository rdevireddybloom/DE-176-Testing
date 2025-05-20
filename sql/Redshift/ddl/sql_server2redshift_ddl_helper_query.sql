use ReportObjects;

-- for generating landing table
SELECT concat(concat(concat(COLUMN_NAME, '  ', case when DATA_TYPE in ('int', 'bigint') and is_nullable = 'YES' then 'float,'
    when DATA_TYPE in ('int', 'bigint') and is_nullable = 'NO' then 'bigint,'
    when DATA_TYPE = 'bit' then 'boolean,'
    when DATA_TYPE in ('smallint', 'tinyint') and is_nullable = 'YES' then 'float,'
    when DATA_TYPE in ('smallint', 'tinyint') and is_nullable = 'NO' then 'integer,'
    when DATA_TYPE in ('datetime', 'datetime2') then 'timestamp,'
    when DATA_TYPE = 'float' then 'float,'
    when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then 'varchar(' end),
    case when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then case when CHARACTER_MAXIMUM_LENGTH = -1 then 256
                                                                    when CHARACTER_MAXIMUM_LENGTH > 5000 then 65000 else CHARACTER_MAXIMUM_LENGTH end end),
    case when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then '),' end)
    --,data_type, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SSRSEmailSubscriptions_History'
and table_schema != 'Audit'
order by ORDINAL_POSITION;

-- for generating staging and ingegrated
SELECT concat(concat(concat(COLUMN_NAME, '  ',
    case when DATA_TYPE in ('int', 'bigint') then 'bigint,'
    when DATA_TYPE = 'bit' then 'boolean,'
    when DATA_TYPE in ('smallint', 'tinyint') then 'integer,'
    when DATA_TYPE in ('datetime', 'datetime2') then 'timestamp,'
    when DATA_TYPE = 'float' then 'float,'
    when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then 'varchar(' end),
    case when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then case when CHARACTER_MAXIMUM_LENGTH = -1 then 256
                                                                    when CHARACTER_MAXIMUM_LENGTH > 5000 then 65000 else CHARACTER_MAXIMUM_LENGTH end end),
    case when DATA_TYPE in ('varchar', 'nvarchar', 'char', 'ntext') then '),' end)
   --,data_type, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SSRSEmailSubscriptions_History'
and table_schema != 'Audit'
order by ORDINAL_POSITION;