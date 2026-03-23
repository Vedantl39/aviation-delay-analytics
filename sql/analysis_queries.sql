-- ============================================
-- AVIATION DELAY ANALYTICS - BUSINESS QUERIES
-- ============================================

-- 1. Overall flight summary
SELECT
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate,
    1 - AVG(is_delayed_15::INT) AS on_time_rate
FROM fact_flights;


-- 2. Monthly delay trends
SELECT
    year,
    month,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate,
    1 - AVG(is_delayed_15::INT) AS on_time_rate
FROM fact_flights
GROUP BY year, month
ORDER BY year, month;


-- 3. Worst origin airports by average departure delay
SELECT
    origin_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay
FROM fact_flights
GROUP BY origin_airport
HAVING COUNT(*) >= 5
ORDER BY avg_departure_delay DESC
LIMIT 10;


-- 4. Worst destination airports by average arrival delay
SELECT
    destination_airport,
    COUNT(*) AS total_flights,
    AVG(arrival_delay) AS avg_arrival_delay
FROM fact_flights
GROUP BY destination_airport
HAVING COUNT(*) >= 5
ORDER BY avg_arrival_delay DESC
LIMIT 10;


-- 5. Best origin airports by lowest departure delay
SELECT
    origin_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay
FROM fact_flights
GROUP BY origin_airport
HAVING COUNT(*) >= 5
ORDER BY avg_departure_delay ASC
LIMIT 10;


-- 6. Route-level delay analysis
SELECT
    origin_airport,
    destination_airport,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate
FROM fact_flights
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 5
ORDER BY avg_arrival_delay DESC
LIMIT 15;


-- 7. Most cancelled routes
SELECT
    origin_airport,
    destination_airport,
    COUNT(*) AS total_flights,
    SUM(cancelled::INT) AS total_cancelled,
    AVG(cancelled::INT) AS cancellation_rate
FROM fact_flights
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 5
ORDER BY cancellation_rate DESC, total_cancelled DESC
LIMIT 15;


-- 8. Most diverted routes
SELECT
    origin_airport,
    destination_airport,
    COUNT(*) AS total_flights,
    SUM(diverted::INT) AS total_diverted,
    AVG(diverted::INT) AS diversion_rate
FROM fact_flights
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 5
ORDER BY diversion_rate DESC, total_diverted DESC
LIMIT 15;


-- 9. Flight identifiers with worst arrival delays
SELECT
    op_carrier_fl_num,
    COUNT(*) AS total_flights,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(departure_delay) AS avg_departure_delay
FROM fact_flights
GROUP BY op_carrier_fl_num
HAVING COUNT(*) >= 5
ORDER BY avg_arrival_delay DESC
LIMIT 15;


-- 10. Flight identifiers with best on-time performance
SELECT
    op_carrier_fl_num,
    COUNT(*) AS total_flights,
    1 - AVG(is_delayed_15::INT) AS on_time_rate,
    AVG(arrival_delay) AS avg_arrival_delay
FROM fact_flights
GROUP BY op_carrier_fl_num
HAVING COUNT(*) >= 5
ORDER BY on_time_rate DESC, avg_arrival_delay ASC
LIMIT 15;


-- 11. Distance vs delay analysis
SELECT
    CASE
        WHEN distance < 500 THEN 'Short-haul'
        WHEN distance >= 500 AND distance < 1500 THEN 'Medium-haul'
        ELSE 'Long-haul'
    END AS distance_band,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(is_delayed_15::INT) AS delayed_15_rate
FROM fact_flights
GROUP BY distance_band
ORDER BY total_flights DESC;


-- 12. Cancellation and diversion summary by month
SELECT
    year,
    month,
    SUM(cancelled::INT) AS total_cancelled,
    SUM(diverted::INT) AS total_diverted,
    AVG(cancelled::INT) AS cancellation_rate,
    AVG(diverted::INT) AS diversion_rate
FROM fact_flights
GROUP BY year, month
ORDER BY year, month;


-- 13. Top busiest origin airports
SELECT
    origin_airport,
    COUNT(*) AS total_flights
FROM fact_flights
GROUP BY origin_airport
ORDER BY total_flights DESC
LIMIT 10;


-- 14. Top busiest routes
SELECT
    origin_airport,
    destination_airport,
    COUNT(*) AS total_flights
FROM fact_flights
GROUP BY origin_airport, destination_airport
ORDER BY total_flights DESC
LIMIT 10;


-- 15. Average delay on cancelled vs non-cancelled flights
SELECT
    cancelled,
    COUNT(*) AS total_flights,
    AVG(departure_delay) AS avg_departure_delay,
    AVG(arrival_delay) AS avg_arrival_delay
FROM fact_flights
GROUP BY cancelled
ORDER BY cancelled DESC;
