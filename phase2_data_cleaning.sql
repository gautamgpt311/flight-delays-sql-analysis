-- Phase 2 Data Cleaning --

-- Are there any flights that show no arrival delay but were not cancelled? Flag them as data quality issues. --
SELECT 
	YEAR, MONTH, DAY,
    AIRLINE,
    FLIGHT_NUMBER,
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    CANCELLED,
    ARRIVAL_DELAY
FROM flights
WHERE ARRIVAL_DELAY IS NULL
	AND CANCELLED = 0;
    
-- Are there any duplicate flights — same airline, flight number and date appearing more than once? --
SELECT
	YEAR, MONTH, DAY,
	AIRLINE,
    FLIGHT_NUMBER,
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    COUNT(*) AS duplicate_flights
FROM flights
GROUP BY YEAR, MONTH, DAY, AIRLINE, FLIGHT_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT
HAVING COUNT(*) > 1
ORDER BY duplicate_flights DESC;

-- How many flights departed before their scheduled time? What does a negative departure delay mean in aviation? --
SELECT
	COUNT(*) AS early_departure,
    ROUND(AVG(DEPARTURE_DELAY),2) AS avg_early_minutes,
    MIN(DEPARTURE_DELAY) AS most_early_minutes
FROM flights
where DEPARTURE_DELAY < 0;

-- Classify all flights into Early/On-Time, Minor Delay and Major Delay categories and count each group. --
SELECT 
    CASE 
        WHEN DEPARTURE_DELAY <= 0 THEN 'Early or On-time'
        WHEN DEPARTURE_DELAY BETWEEN 1 AND 30 THEN 'Minor Delay'
        WHEN DEPARTURE_DELAY > 30 THEN 'Major Delay'
        ELSE 'Unknown'
    END AS delay_category,
    COUNT(*) AS flight_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM flights
WHERE DEPARTURE_DELAY IS NOT NULL
GROUP BY delay_category
ORDER BY flight_count DESC;