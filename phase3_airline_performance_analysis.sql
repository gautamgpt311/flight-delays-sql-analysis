-- Phase 3 Airline Performance Analysis --

-- Which airline has the highest average arrival delay? --
SELECT
	a.AIRLINE,
    a.IATA_CODE,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay
FROM airlines AS a
JOIN flights AS f
	ON a.IATA_CODE = f.AIRLINE
WHERE f.ARRIVAL_DELAY IS NOT NULL
GROUP BY a.AIRLINE, a.IATA_CODE
ORDER BY avg_arrival_delay DESC;

-- Which airline cancels the most flights as a percentage of their total operations? --
SELECT
	a.AIRLINE,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS total_cancelled_flight,
    ROUND(SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END)
		* 100.0 / COUNT(*), 2) AS cancellation_pct
FROM airlines AS a
JOIN flights AS f
	ON a.IATA_CODE = f.AIRLINE
GROUP BY a.AIRLINE
ORDER BY cancellation_pct DESC
LIMIT 1;

-- Build a complete airline scorecard showing total flights, average departure delay, --
-- average arrival delay and on-time performance rate for every airline. --
SELECT
	a.AIRLINE,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.DEPARTURE_DELAY),1) AS avg_departure_delay,
    ROUND(AVG(f.ARRIVAL_DELAY),1) AS avg_arrival_delay,
    ROUND(SUM(CASE WHEN ARRIVAL_DELAY <= 0 THEN 1 ELSE 0 END)
		* 100.0 / COUNT(*), 2) AS ontime_performance_pct
FROM airlines AS a
JOIN flights AS f
	ON a.IATA_CODE = f.AIRLINE
GROUP BY a.AIRLINE
ORDER BY ontime_performance_pct DESC;