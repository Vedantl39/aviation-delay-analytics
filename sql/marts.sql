-- Airports
INSERT INTO dim_airports (airport_code, city_name)
SELECT DISTINCT origin_airport, origin_city
FROM fact_flights;

-- Airlines
INSERT INTO dim_airlines (airline_code)
SELECT DISTINCT airline
FROM fact_flights;

-- Date dimension
INSERT INTO dim_date (flight_date, year, month, day, day_of_week)
SELECT DISTINCT
    flight_date,
    EXTRACT(YEAR FROM flight_date),
    EXTRACT(MONTH FROM flight_date),
    EXTRACT(DAY FROM flight_date),
    EXTRACT(DOW FROM flight_date)
FROM fact_flights;
