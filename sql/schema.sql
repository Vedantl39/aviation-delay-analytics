CREATE TABLE fact_flights (
    flight_id SERIAL PRIMARY KEY,
    year INT,
    month INT,
    flight_date DATE,
    op_carrier_fl_num VARCHAR(20),
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    departure_delay FLOAT,
    arrival_delay FLOAT,
    cancelled BOOLEAN,
    diverted BOOLEAN,
    distance FLOAT,
    is_delayed_15 BOOLEAN
);

CREATE TABLE dim_airports (
    airport_code VARCHAR(10) PRIMARY KEY
);

CREATE TABLE dim_date (
    flight_date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    day_of_week INT
);
