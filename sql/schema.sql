-- FACT TABLE (core data)
CREATE TABLE fact_flights (
    flight_id SERIAL PRIMARY KEY,
    flight_date DATE,
    airline VARCHAR(10),
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    departure_delay FLOAT,
    arrival_delay FLOAT,
    cancelled BOOLEAN,
    diverted BOOLEAN,
    distance FLOAT,
    is_delayed_15 BOOLEAN
);

-- AIRPORT DIMENSION
CREATE TABLE dim_airports (
    airport_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

-- AIRLINE DIMENSION
CREATE TABLE dim_airlines (
    airline_code VARCHAR(10) PRIMARY KEY
);

-- DATE DIMENSION
CREATE TABLE dim_date (
    flight_date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    day_of_week INT
);
