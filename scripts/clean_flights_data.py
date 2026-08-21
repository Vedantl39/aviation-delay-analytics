"""
Cleans the raw BTS flight operations extract and prepares it for loading.

Fixes applied vs. the original version of this script:
  - The BTS field OP_CARRIER_FL_NUM is the flight NUMBER, not an airline
    carrier code — the raw export from this pull does not include an
    actual carrier identifier (no OP_UNIQUE_CARRIER / OP_CARRIER field).
    This script keeps it correctly labeled as `flight_number` rather than
    `airline`, so nothing downstream implies airline-level comparison
    from a field that can't support it.
  - Derives `is_delayed_15` (arrival delay >= 15 minutes), which the SQL
    layer references but which nothing previously computed.
"""
import pandas as pd

RAW_PATH = "data/raw/flights_raw_sample.csv"
OUT_PATH = "data/processed/flights_clean.csv"

SELECTED_COLUMNS = [
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
    "DISTANCE",
]

RENAME_MAP = {
    "FL_DATE": "flight_date",
    "OP_CARRIER_FL_NUM": "flight_number",   # NOT an airline identifier — see module docstring
    "ORIGIN": "origin_airport",
    "DEST": "destination_airport",
    "DEP_DELAY": "departure_delay",
    "ARR_DELAY": "arrival_delay",
    "CANCELLED": "cancelled",
    "DIVERTED": "diverted",
    "DISTANCE": "distance",
}


def main():
    df = pd.read_csv(RAW_PATH, low_memory=False)

    # The raw BTS export includes a large trailing block of fully blank
    # rows (a known quirk of TranStats CSV downloads) — drop rows with no
    # YEAR value, since those carry no real flight data at all.
    df = df[df["YEAR"].notna()]

    df = df[SELECTED_COLUMNS].rename(columns=RENAME_MAP)

    # Normalize to ISO date so SQLite's date functions (strftime) work downstream
    df["flight_date"] = pd.to_datetime(df["flight_date"], format="%m/%d/%y %H:%M").dt.strftime("%Y-%m-%d")

    df["cancelled"] = df["cancelled"].fillna(0).astype(int)
    df["diverted"] = df["diverted"].fillna(0).astype(int)

    # is_delayed_15: only defined for flights that actually departed/arrived
    # (cancelled flights have no arrival_delay value at all)
    df["is_delayed_15"] = (df["arrival_delay"] >= 15).astype("Int64")
    df.loc[df["arrival_delay"].isna(), "is_delayed_15"] = pd.NA

    df.to_csv(OUT_PATH, index=False)
    print(f"Cleaned file saved to {OUT_PATH}")
    print(f"Rows: {len(df)}, non-cancelled with arrival data: {df['arrival_delay'].notna().sum()}")


if __name__ == "__main__":
    main()
