-- Phase 7 - Advanced Analysis --

-- Rank all airlines by average departure delay using window functions. Show both RANK and DENSE_RANK. --
WITH airline_delay AS (
	SELECT
		a.AIRLINE,
        a.IATA_CODE,
        ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_dep_delay
	FROM flights AS f
    JOIN airlines AS a
		ON f.AIRLINE = a.IATA_CODE
	GROUP BY a.AIRLINE, a.IATA_CODE
)
SELECT
	AIRLINE,
    IATA_CODE,
    avg_dep_delay,
    RANK() OVER (
		ORDER BY avg_dep_delay DESC) AS rank_position,
	DENSE_RANK() OVER (
		ORDER BY avg_dep_delay DESC) AS dense_rank_position
FROM airline_delay;

-- For each airline identify their best month, worst month and the performance gap between them. --
WITH monthly_avg AS (
    SELECT
        AIRLINE,
        MONTH,
        ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_dep_delay
    FROM flights
    GROUP BY AIRLINE, MONTH
)
SELECT
    AIRLINE,
    MONTH,
    avg_dep_delay,
    MIN(avg_dep_delay) OVER(PARTITION BY AIRLINE) AS best_month_delay,
    MAX(avg_dep_delay) OVER(PARTITION BY AIRLINE) AS worst_month_delay,
    ROUND(MAX(avg_dep_delay) OVER(PARTITION BY AIRLINE) -
          MIN(avg_dep_delay) OVER(PARTITION BY AIRLINE), 2) AS gap
FROM monthly_avg
ORDER BY gap DESC;

-- Find the top 3 most delayed flights for each airline --
WITH ranked_flights AS (
    SELECT
        AIRLINE,
        FLIGHT_NUMBER,
        ORIGIN_AIRPORT,
        DESTINATION_AIRPORT,
        DEPARTURE_DELAY,
        ROW_NUMBER() OVER(
            PARTITION BY AIRLINE
            ORDER BY DEPARTURE_DELAY DESC
        ) AS row_num
    FROM flights
    WHERE DEPARTURE_DELAY IS NOT NULL
)
SELECT
    a.AIRLINE,
    r.FLIGHT_NUMBER,
    r.ORIGIN_AIRPORT,
    r.DESTINATION_AIRPORT,
    r.DEPARTURE_DELAY
FROM ranked_flights AS r
JOIN airlines AS a ON r.AIRLINE = a.IATA_CODE
WHERE row_num <= 3
ORDER BY a.AIRLINE, r.DEPARTURE_DELAY DESC;