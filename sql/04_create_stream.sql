-- Create a stream to track new rows in the raw table
CREATE OR REPLACE STREAM insurance_db.raw_layer.raw_insurance_stream
ON TABLE insurance_db.raw_layer.raw_insurance_transactions;
--APPEND_ONLY = TRUE; #if set to TRUE, the stream will only track new rows and not changes to existing rows
-- This stream will capture all changes (inserts, updates, deletes) to the raw table
-- and can be used to process new data as it arrives.
-- The stream can be queried to get the changes since the last time it was processed.
-- For example, you can use:
-- SELECT * FROM insurance_db.raw_layer.raw_insurance_stream
-- WHERE METADATA$IS_UPDATE = FALSE; -- to get only new rows
-- Or:
-- SELECT * FROM insurance_db.raw_layer.raw_insurance_stream
-- WHERE METADATA$IS_UPDATE = TRUE; -- to get only updated rows
-- Or:
-- SELECT * FROM insurance_db.raw_layer.raw_insurance_stream
-- WHERE METADATA$IS_DELETE = TRUE; -- to get only deleted rows
-- Or:
-- SELECT * FROM insurance_db.raw_layer.raw_insurance_stream ;
