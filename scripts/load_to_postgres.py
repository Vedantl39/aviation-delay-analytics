"""
Loads cleaned flight data into a local SQLite database, then builds the
dimension tables and data marts defined in sql/schema.sql and sql/marts.sql.

Uses SQLite for a zero-setup local demo (no server to install or credential
to manage). The SQL is written in a portable style so pointing this at a
real Postgres instance instead would only need swapping the connection
string and re-running the same .sql files against psycopg2/SQLAlchemy.

Run:
    python scripts/load_to_postgres.py
"""
import sqlite3

import pandas as pd

CLEAN_CSV = "data/processed/flights_clean.csv"
DB_PATH = "data/processed/aviation.db"
SCHEMA_SQL = "sql/schema.sql"
MARTS_SQL = "sql/marts.sql"


def run_sql_file(conn: sqlite3.Connection, path: str) -> None:
    with open(path) as f:
        conn.executescript(f.read())
    conn.commit()


def main():
    df = pd.read_csv(CLEAN_CSV)

    conn = sqlite3.connect(DB_PATH)

    run_sql_file(conn, SCHEMA_SQL)

    df_load = df.rename(columns={"YEAR": "year", "MONTH": "month"})[
        [
            "year", "month", "flight_date", "flight_number",
            "origin_airport", "destination_airport",
            "departure_delay", "arrival_delay",
            "cancelled", "diverted", "distance", "is_delayed_15",
        ]
    ]
    # append (not replace) — schema.sql already created fact_flights with a
    # flight_id AUTOINCREMENT primary key; replace would drop that and let
    # pandas infer its own schema instead, losing the PK
    df_load.to_sql("fact_flights", conn, if_exists="append", index=False)

    run_sql_file(conn, MARTS_SQL)

    conn.close()
    print(f"Loaded {len(df_load)} rows and built marts in {DB_PATH}")


if __name__ == "__main__":
    main()
