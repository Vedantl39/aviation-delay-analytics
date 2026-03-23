CREATE TABLE flights (
    year INT,
    month INT,
    flight_date DATE,
    airline VARCHAR(10),
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    departure_delay FLOAT,
    arrival_delay FLOAT,
    cancelled BOOLEAN,
    diverted BOOLEAN,
    distance FLOAT
);
