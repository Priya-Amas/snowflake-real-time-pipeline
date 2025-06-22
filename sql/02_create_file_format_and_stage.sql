
-- This file format is used for CSV files with optional field enclosure by double quotes,
-- skipping the header row, and treating empty strings or 'NULL' as null values.  
-- Create file format for CSV files
CREATE OR REPLACE FILE FORMAT insurance_db.raw_layer.csv_format
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    NULL_IF = ('', 'NULL');  

-- Create internal stage to store uploaded files
CREATE OR REPLACE STAGE insurance_db.raw_layer.insurance_stage
  FILE_FORMAT = insurance_db.raw_layer.csv_format;