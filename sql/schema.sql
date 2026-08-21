-- Aviation Delay Analytics — schema
-- Adapted for SQLite (the project's loader connects to a local SQLite
-- database, not Postgres — see scripts/load_to_postgres.py). Column types
-- and constraints are written to be portable to Postgres if this project
-- is ever pointed at a real Postgres instance instead.

CREATE TABLE IF NOT EXISTS fact_flights (
    flight_id INTEGER PRIMARY KEY AUTOINCREMENT,
    year INTEGER,
    month INTEGER,
    flight_date TEXT,           -- ISO format YYYY-MM-DD
    flight_number TEXT,         -- BTS OP_CARRIER_FL_NUM; NOT an airline identifier
    origin_airport TEXT,
    destination_airport TEXT,
    departure_delay REAL,
    arrival_delay REAL,
    cancelled INTEGER,          -- 0/1
    diverted INTEGER,           -- 0/1
    distance REAL,
    is_delayed_15 INTEGER       -- 0/1, NULL if flight never arrived (cancelled)
);

CREATE TABLE IF NOT EXISTS dim_airports (
    airport_code TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS dim_date (
    flight_date TEXT PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    day_of_week INTEGER          -- 0=Sunday ... 6=Saturday (SQLite strftime %w)
);
