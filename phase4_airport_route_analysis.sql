-- Phase 4 — Airport & Route Analysis --

-- Which 10 airports handle the most departing flights? Show full airport name, city and state. --
SELECT
	a.AIRPORT,
    a.CITY,
    a.STATE,
    COUNT(*) AS total_departing_flights
FROM airports AS a
JOIN flights AS f
	ON a.IATA_CODE = f.ORIGIN_AIRPORT
GROUP BY a.AIRPORT, a.CITY, a.STATE
ORDER BY total_departing_flights DESC
LIMIT 10;

-- Which routes (origin to destination) are the busiest in the country? Show top 10 with full airport names. --
SELECT 
	orig.AIRPORT AS origin_name,
    dest.AIRPORT AS destination_name,
    f.ORIGIN_AIRPORT AS origin_code,
    f.DESTINATION_AIRPORT AS destination_code,
    COUNT(*) AS total_flights
FROM flights AS f
JOIN airports AS orig ON f.ORIGIN_AIRPORT = orig.IATA_CODE
JOIN airports AS dest ON f.DESTINATION_AIRPORT = dest.IATA_CODE
GROUP BY f.ORIGIN_AIRPORT, f.DESTINATION_AIRPORT, orig.AIRPORT, dest.AIRPORT
ORDER BY total_flights DESC
LIMIT 10;

-- Which routes have the worst average arrival delay? Only consider routes with at least 100 flights. --
SELECT 
	orig.AIRPORT AS origin_name,
    dest.AIRPORT AS destination_name,
    f.ORIGIN_AIRPORT AS origin_code,
    f.DESTINATION_AIRPORT AS destination_code,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.ARRIVAL_DELAY),2) AS worst_avg_arrival
FROM flights AS f
JOIN airports AS orig ON f.ORIGIN_AIRPORT = orig.IATA_CODE
JOIN airports AS dest ON f.DESTINATION_AIRPORT = dest.IATA_CODE
WHERE f.ARRIVAL_DELAY IS NOT NULL
GROUP BY f.ORIGIN_AIRPORT, f.DESTINATION_AIRPORT, orig.AIRPORT, dest.AIRPORT
HAVING COUNT(*) >= 100
ORDER BY worst_avg_arrival DESC
LIMIT 10;