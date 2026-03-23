-- ============================================
-- DIMENSION TABLE LOADS
-- ============================================

-- Airports dimension
INSERT INTO dim_airports (airport_code)
SELECT DISTINCT origin_airport
FROM fact_flights
WHERE origin_airport IS NOT NULL

UNION

SELECT DISTINCT destination_airport
FROM fact_flights
WHERE destination_airport IS NOT NULL;


-- Date dimension
INSERT INTO dim_date (flight_date, year, month, day, day_of_week)
SELECT DISTINCT
    flight_date,
    EXTRACT(YEAR FROM flight_date)::INT AS year,
    EXTRACT(MONTH FROM flight_date)::INT AS month,
    EXTRACT(DAY FROM flight_date)::INT AS day,
    EXTRACT(DOW FROM flight_date)::INT AS day_of_week
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
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate,
    AVG(distance) AS avg_distance
FROM fact_flights
GROUP BY origin_airport, destination_airport;


-- 2. Airport origin performance summary
DROP TABLE IF EXISTS mart_origin_airport_performance;

CREATE TABLE mart_origin_airport_performance AS
SELECT
    origin_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate
FROM fact_flights
GROUP BY origin_airport;


-- 3. Airport destination performance summary
DROP TABLE IF EXISTS mart_destination_airport_performance;

CREATE TABLE mart_destination_airport_performance AS
SELECT
    destination_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate
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
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate
FROM fact_flights
GROUP BY year, month
ORDER BY year, month;


-- 5. Flight identifier performance summary
DROP TABLE IF EXISTS mart_flight_identifier_performance;

CREATE TABLE mart_flight_identifier_performance AS
SELECT
    op_carrier_fl_num,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate,
    AVG(distance) AS avg_distance
FROM fact_flights
GROUP BY op_carrier_fl_num;
