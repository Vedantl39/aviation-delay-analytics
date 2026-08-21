-- Aviation Delay Analytics — dimension loads + data marts
-- Adapted for SQLite: ::INT casts removed (columns already stored as
-- 0/1 integers), EXTRACT(... FROM ...) replaced with strftime().

-- ============================================
-- DIMENSION TABLE LOADS
-- ============================================

INSERT OR IGNORE INTO dim_airports (airport_code)
SELECT DISTINCT origin_airport FROM fact_flights WHERE origin_airport IS NOT NULL;

INSERT OR IGNORE INTO dim_airports (airport_code)
SELECT DISTINCT destination_airport FROM fact_flights WHERE destination_airport IS NOT NULL;

INSERT OR IGNORE INTO dim_date (flight_date, year, month, day, day_of_week)
SELECT DISTINCT
    flight_date,
    CAST(strftime('%Y', flight_date) AS INTEGER),
    CAST(strftime('%m', flight_date) AS INTEGER),
    CAST(strftime('%d', flight_date) AS INTEGER),
    CAST(strftime('%w', flight_date) AS INTEGER)
FROM fact_flights
WHERE flight_date IS NOT NULL;


-- ============================================
-- DATA MARTS / SUMMARY TABLES
-- ============================================

-- 1. Route performance summary
DROP TABLE IF EXISTS mart_route_performance;
CREATE TABLE mart_route_performance AS
SELECT
    origin_airport,
    destination_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled) AS cancellation_rate,
    AVG(diverted) AS diversion_rate,
    AVG(is_delayed_15) AS delayed_15_rate,
    AVG(distance) AS avg_distance
FROM fact_flights
GROUP BY origin_airport, destination_airport;

-- 2. Origin airport performance summary
DROP TABLE IF EXISTS mart_origin_airport_performance;
CREATE TABLE mart_origin_airport_performance AS
SELECT
    origin_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled) AS cancellation_rate,
    AVG(diverted) AS diversion_rate,
    AVG(is_delayed_15) AS delayed_15_rate
FROM fact_flights
GROUP BY origin_airport;

-- 3. Destination airport performance summary
DROP TABLE IF EXISTS mart_destination_airport_performance;
CREATE TABLE mart_destination_airport_performance AS
SELECT
    destination_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled) AS cancellation_rate,
    AVG(diverted) AS diversion_rate,
    AVG(is_delayed_15) AS delayed_15_rate
FROM fact_flights
GROUP BY destination_airport;

-- 4. Monthly performance summary
DROP TABLE IF EXISTS mart_monthly_performance;
CREATE TABLE mart_monthly_performance AS
SELECT
    year,
    month,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled) AS cancellation_rate,
    AVG(diverted) AS diversion_rate,
    AVG(is_delayed_15) AS delayed_15_rate
FROM fact_flights
GROUP BY year, month
ORDER BY year, month;

-- 5. Flight-number performance summary (NOT airline-level — see schema.sql note)
DROP TABLE IF EXISTS mart_flight_identifier_performance;
CREATE TABLE mart_flight_identifier_performance AS
SELECT
    flight_number,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled) AS cancellation_rate,
    AVG(diverted) AS diversion_rate,
    AVG(is_delayed_15) AS delayed_15_rate,
    AVG(distance) AS avg_distance
FROM fact_flights
GROUP BY flight_number;
