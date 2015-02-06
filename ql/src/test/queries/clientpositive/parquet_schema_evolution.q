set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;

DROP TABLE parquet_schema_evolution_staging;
DROP TABLE parquet_schema_evolution;

CREATE TABLE parquet_schema_evolution_staging (
    id int,
    str string,
    part string
) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|';

CREATE TABLE parquet_schema_evolution (
    id int,
    str string
) PARTITIONED BY (part string)
STORED AS PARQUET;

LOAD DATA LOCAL INPATH '../../data/files/parquet_partitioned.txt' OVERWRITE INTO TABLE parquet_schema_evolution_staging;

INSERT OVERWRITE TABLE parquet_schema_evolution PARTITION (part) SELECT * FROM parquet_schema_evolution_staging;

ALTER TABLE parquet_schema_evolution ADD COLUMNS (new string);

-- returns nothing, but must not fail.
SELECT new FROM parquet_schema_evolution WHERE part='part1';

DROP TABLE parquet_schema_evolution_staging;
DROP TABLE parquet_schema_evolution;
