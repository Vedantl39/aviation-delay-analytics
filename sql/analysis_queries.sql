-- Average delay by airline
SELECT airline, AVG(arrival_delay) AS avg_delay
FROM fact_flights
GROUP BY airline
ORDER BY avg_delay DESC;

-- On-time performance
SELECT airline,
       1 - AVG(is_delayed_15::int) AS on_time_rate
FROM fact_flights
GROUP BY airline
ORDER BY on_time_rate DESC;

-- Worst airports
SELECT origin_airport, AVG(departure_delay) AS avg_delay
FROM fact_flights
GROUP BY origin_airport
ORDER BY avg_delay DESC
LIMIT 10;
