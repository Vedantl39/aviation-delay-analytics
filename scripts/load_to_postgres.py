import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()

# Load cleaned data
df = pd.read_csv("data/processed/flights_clean.csv")

# Create connection
engine = create_engine(
    f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)

# Load into fact table
df.to_sql("fact_flights", engine, if_exists="replace", index=False)

print("Data loaded into PostgreSQL.")
