/*CREATE OR REPLACE PIPE insurance_db.raw_layer.insurance_pipe
  AUTO_INGEST = FALSE -- set to TRUE only if using S3 + Event Grid
  AS
  COPY INTO insurance_db.raw_layer.raw_insurance_transactions
  FROM @insurance_db.raw_layer.insurance_stage
  FILE_FORMAT = (FORMAT_NAME = insurance_db.raw_layer.csv_format)
  PATTERN = '.*insurance_sample.*.csv.gz'
  ON_ERROR = 'CONTINUE';*/

-- Create a Snowpipe to automatically load data from the stage into the raw table
-- This pipe will be used to load data from the stage into the raw table
-- The pipe will automatically load data from the stage into the raw table when new files are added
-- The pipe will use the file format defined earlier to parse the CSV files
-- The pipe will also handle errors by continuing on error, which means it will skip rows that
-- cannot be parsed or loaded into the raw table without failing the entire load operation. 
-- The pipe will also capture the file name and load time for each row loaded into the raw table.
-- The pipe will also parse the CSV files and convert the data types as needed.


CREATE OR REPLACE PIPE insurance_db.raw_layer.insurance_pipe
  AUTO_INGEST = FALSE -- set to TRUE only if using S3 + Event Grid
  AS
  -- Copy data from the stage into the raw table  
COPY INTO insurance_db.raw_layer.raw_insurance_transactions
FROM (
    SELECT
        $1 AS policy_id,
        $2 AS customer_name,
        $3::NUMBER AS premium_amount,
        $4 AS status,
        $5::TIMESTAMP_NTZ AS created_at,
        METADATA$FILENAME AS file_name,
        CURRENT_TIMESTAMP() AS load_time
    FROM @insurance_db.raw_layer.insurance_stage
)
FILE_FORMAT = (FORMAT_NAME = insurance_db.raw_layer.csv_format, ERROR_ON_COLUMN_COUNT_MISMATCH=FALSE)
PATTERN = '.*insurance_sample.*\.csv(\.gz)?'
ON_ERROR = 'CONTINUE';
