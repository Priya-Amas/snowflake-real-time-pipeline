-- Create database and schema
CREATE DATABASE insurance_db;
CREATE OR REPLACE SCHEMA insurance_db.raw_layer;

-- Create raw table to store uploaded data
CREATE OR REPLACE TABLE insurance_db.raw_layer.raw_insurance_transactions (
    policy_id STRING,
    customer_name STRING,
    premium_amount NUMBER,
    status STRING,
    created_at TIMESTAMP_NTZ,
    file_name STRING,
    load_time TIMESTAMP_NTZ
);
