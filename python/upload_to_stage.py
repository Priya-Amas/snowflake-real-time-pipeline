import os
from datetime import datetime,timezone
import snowflake.connector
from dotenv import load_dotenv
import pytz

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

# ✅ Print clean upload time in IST
utc_now = datetime.now(timezone.utc)

# Print in same format as Snowflake stage
print("✅ File uploaded at (GMT):", utc_now.strftime("%A, %d %B %Y at %H:%M:%S %Z"))

cursor.execute(f"""list @{os.getenv('SNOWSQL_STAGE')}""");

# Optional: Print confirmation
for row in cursor.fetchall():
    print(row)

cursor.close()
conn.close()
