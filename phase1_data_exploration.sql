-- Phase 1 — Data Exploration (EDA) --

-- How many total flights are recorded in this dataset? --
SELECT 
	COUNT(*) AS total_flights 
FROM flights;

-- What is the date range covered by this dataset? --
SELECT 
    MIN(CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-', LPAD(DAY, 2, '0'))) AS earliest_date,
    MAX(CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-', LPAD(DAY, 2, '0'))) AS latest_date
FROM flights;

-- How many unique airlines operate in this dataset? List them with their total flights. --
SELECT
	a.IATA_CODE AS airline_code,
    a.AIRLINE AS airline_name,
	COUNT(f.AIRLINE) AS total_flights
FROM airlines AS a
JOIN flights AS f
	ON a.IATA_CODE = f.AIRLINE
GROUP BY a.IATA_CODE, a.AIRLINE
ORDER BY total_flights DESC;

-- How many NULL values exist in key columns like departure delay, arrival delay, air time and cancellation reason? --
SELECT
	SUM(CASE WHEN DEPARTURE_DELAY IS NULL THEN 1 ELSE 0 END) AS null_dep_delay,
    SUM(CASE WHEN ARRIVAL_DELAY IS NULL THEN 1 ELSE 0 END) AS null_arr_delay,
    SUM(CASE WHEN AIR_TIME IS NULL THEN 1 ELSE 0 END) AS null_air_time,
    SUM(CASE WHEN CANCELLATION_REASON IS NULL THEN 1 ELSE 0 END) AS null_cancellation
FROM flights;

-- What percentage of flights were cancelled vs successfully completed? --
SELECT 
	ROUND(COUNT(CASE WHEN CANCELLED = 1 THEN 1 ELSE NULL END) 
		* 100.0 / COUNT(*), 2) AS cancelled_flight_pct,
	ROUND(COUNT(CASE WHEN CANCELLED = 0 THEN 1 ELSE NULL END)
		* 100.0 / COUNT(*), 2) AS completed_flight_pct
FROM flights;

-- Which 5 states have the most airports? --
SELECT 
	STATE,
    COUNT(STATE) AS airport_count
FROM airports
GROUP BY STATE
ORDER BY airport_count DESC
LIMIT 5;