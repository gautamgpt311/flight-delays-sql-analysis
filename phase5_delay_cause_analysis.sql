-- Phase 5 — Delay Cause Analysis --

-- What is the average contribution of each delay type (weather, airline, air system, security, late aircraft) across all flights? --
SELECT
	ROUND(AVG(COALESCE(WEATHER_DELAY, 0)),2) AS avg_weather_delay,
    ROUND(AVG(COALESCE(AIRLINE_DELAY, 0)),2) AS avg_airline_delay,
    ROUND(AVG(COALESCE(AIR_SYSTEM_DELAY, 0)),2) AS avg_air_system_delay,
    ROUND(AVG(COALESCE(SECURITY_DELAY, 0)),2) AS avg_security_delay,
    ROUND(AVG(COALESCE(LATE_AIRCRAFT_DELAY, 0)),2) AS avg_late_aircraft_delay
FROM flights;

-- Which month of the year has the highest average departure delay? --
SELECT
    MONTH,
    CASE MONTH
        WHEN 1  THEN 'January'
        WHEN 2  THEN 'February'
        WHEN 3  THEN 'March'
        WHEN 4  THEN 'April'
        WHEN 5  THEN 'May'
        WHEN 6  THEN 'June'
        WHEN 7  THEN 'July'
        WHEN 8  THEN 'August'
        WHEN 9  THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay
FROM flights
GROUP BY MONTH
ORDER BY avg_departure_delay DESC;

-- Which day of the week has the worst delays on average? --
SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1  THEN 'Monday'
        WHEN 2  THEN 'Tuesday'
        WHEN 3  THEN 'Wednesday'
        WHEN 4  THEN 'Thursday'
        WHEN 5  THEN 'Friday'
        WHEN 6  THEN 'Saturday'
        WHEN 7  THEN 'Sunday'
    END AS day_of_week_name,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay
FROM flights
GROUP BY DAY_OF_WEEK
ORDER BY avg_departure_delay DESC;