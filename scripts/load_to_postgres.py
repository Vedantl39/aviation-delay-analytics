import pandas as pd
from sqlalchemy import create_engine

# Load cleaned data
df = pd.read_csv("data/processed/flights_clean.csv")

# Create connection (update with your credentials)
engine = create_engine("postgresql://postgres:password@localhost:5432/aviation_db")

# Load into fact_flights
df.to_sql("fact_flights", engine, if_exists="replace", index=False)

print("Data loaded into PostgreSQL successfully.")
