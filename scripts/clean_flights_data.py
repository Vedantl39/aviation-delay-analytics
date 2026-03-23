import pandas as pd

# Load raw flight data
flight_data = pd.read_csv("data/raw/flights_raw.csv")

# Keep only relevant columns
selected_columns = [
    "YEAR",
    "MONTH",
    "FL_DATE",
    "OP_CARRIER_FL_NUM",
    "ORIGIN",
    "DEST",
    "DEP_DELAY",
    "ARR_DELAY",
    "CANCELLED",
    "DIVERTED",
    "DISTANCE"
]

flight_data = flight_data[selected_columns]

# Rename columns
flight_data = flight_data.rename(columns={
    "FL_DATE": "flight_date",
    "OP_CARRIER_FL_NUM": "airline",
    "ORIGIN": "origin_airport",
    "DEST": "destination_airport",
    "DEP_DELAY": "departure_delay",
    "ARR_DELAY": "arrival_delay",
    "CANCELLED": "cancelled",
    "DIVERTED": "diverted",
    "DISTANCE": "distance"
})

# Save cleaned dataset
flight_data.to_csv("data/processed/flights_clean.csv", index=False)

print("Cleaned file saved to data/processed/flights_clean.csv")
