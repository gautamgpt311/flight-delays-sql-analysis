-- Phase 6 — Cancellation Analysis --

-- How many flights were cancelled due to each reason? Show the reason name, not just the code. --
SELECT
    CANCELLATION_REASON,
    CASE WHEN CANCELLATION_REASON = 'A' THEN 'Airline Fault'
        WHEN CANCELLATION_REASON = 'B'  THEN 'Weather'
        WHEN CANCELLATION_REASON = 'C'  THEN 'National Air System'
        WHEN CANCELLATION_REASON = 'D'  THEN 'Security'
    END AS cancellation_name,
    COUNT(*) AS total_cancellation,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM flights
WHERE CANCELLED = 1
GROUP BY CANCELLATION_REASON
ORDER BY total_cancellation DESC;

-- Which airline has the most weather-related cancellations as a percentage of their total flights? --
WITH airline_totals AS (
    SELECT 
        AIRLINE,
        COUNT(*) AS total_flights
    FROM flights
    GROUP BY AIRLINE
),
weather_cancellations AS (
    SELECT 
        AIRLINE,
        COUNT(*) AS weather_cancelled
    FROM flights
    WHERE CANCELLED = 1
    AND CANCELLATION_REASON = 'B'
    GROUP BY AIRLINE
)
SELECT
    a.AIRLINE,
    wc.weather_cancelled,
    at.total_flights,
    ROUND(wc.weather_cancelled * 100.0 / at.total_flights, 2) AS pct_of_airline_flights
FROM airlines AS a
JOIN weather_cancellations AS wc ON a.IATA_CODE = wc.AIRLINE
JOIN airline_totals AS at ON a.IATA_CODE = at.AIRLINE
ORDER BY wc.weather_cancelled DESC;

-- Which time of day has the worst departure delays — early morning, morning, afternoon or evening? --
SELECT
	CASE 
		WHEN SCHEDULED_DEPARTURE < 600 THEN 'Early Morning'
		WHEN SCHEDULED_DEPARTURE BETWEEN 600 AND 1159 THEN 'Morning'
        WHEN SCHEDULED_DEPARTURE BETWEEN 1200 AND 1759 THEN 'Afternoon'
        WHEN SCHEDULED_DEPARTURE BETWEEN 1800 AND 2359 THEN 'Evening'
	END AS time_block,
    COUNT(*) AS total_flight,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay
FROM flights
WHERE DEPARTURE_DELAY IS NOT NULL
GROUP BY time_block
ORDER BY avg_departure_delay DESC;