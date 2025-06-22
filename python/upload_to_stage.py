import os
from datetime import datetime
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()

conn = snowflake.connector.connect(
    user=os.getenv("SNOWSQL_USER"),
    password=os.getenv("SNOWSQL_PWD"),
    account=os.getenv("SNOWSQL_ACCOUNT"),
    warehouse=os.getenv("SNOWSQL_WAREHOUSE"),
    database=os.getenv("SNOWSQL_DATABASE"),
    schema=os.getenv("SNOWSQL_SCHEMA")
)

cursor = conn.cursor()

file_path = "data/insurance_sample.csv"
file_name = os.path.basename(file_path)

# PUT command to upload to internal stage
put_command = f"PUT file://{os.path.abspath(file_path)} @{os.getenv('SNOWSQL_STAGE')} AUTO_COMPRESS=TRUE"
print("Uploading file to internal stage...")
cursor.execute(put_command)

# Optional: Print confirmation
for row in cursor.fetchall():
    print(row)

cursor.close()
conn.close()
