-- ============================================================
-- Project  : US Flight Delays & Cancellations Analysis (2015)
-- File     : table_creation.sql
-- Tool     : MySQL 8.0
-- Dataset  : Kaggle — 2015 Flight Delays and Cancellations
-- Rows     : 5,819,079 flights | 31 columns | 3 tables
-- ============================================================

-- Create the database --
CREATE DATABASE flight_delays_cancellation;
USE flight_delays_cancellation;

-- Create the airlines table --
CREATE TABLE airlines (
    IATA_CODE VARCHAR(5)   PRIMARY KEY,
    AIRLINE   VARCHAR(100)
);


-- Create the airports table --
CREATE TABLE airports (
    IATA_CODE VARCHAR(5)   PRIMARY KEY,
    AIRPORT   VARCHAR(200),
    CITY      VARCHAR(100),
    STATE     VARCHAR(50),
    COUNTRY   VARCHAR(50),
    LATITUDE  FLOAT,
    LONGITUDE FLOAT
);

-- Create the flights table --
CREATE TABLE flights (
    YEAR                 INT,
    MONTH                INT,
    DAY                  INT,
    DAY_OF_WEEK          INT,
    AIRLINE              VARCHAR(5),
    FLIGHT_NUMBER        INT,
    TAIL_NUMBER          VARCHAR(10),
    ORIGIN_AIRPORT       VARCHAR(5),
    DESTINATION_AIRPORT  VARCHAR(5),
    SCHEDULED_DEPARTURE  INT,
    DEPARTURE_TIME       FLOAT,
    DEPARTURE_DELAY      FLOAT,
    TAXI_OUT             FLOAT,
    WHEELS_OFF           FLOAT,
    SCHEDULED_TIME       FLOAT,
    ELAPSED_TIME         FLOAT,
    AIR_TIME             FLOAT,
    DISTANCE             INT,
    WHEELS_ON            FLOAT,
    TAXI_IN              FLOAT,
    SCHEDULED_ARRIVAL    INT,
    ARRIVAL_TIME         FLOAT,
    ARRIVAL_DELAY        FLOAT,
    DIVERTED             INT,
    CANCELLED            INT,
    CANCELLATION_REASON  VARCHAR(5),
    AIR_SYSTEM_DELAY     FLOAT,
    SECURITY_DELAY       FLOAT,
    AIRLINE_DELAY        FLOAT,
    LATE_AIRCRAFT_DELAY  FLOAT,
    WEATHER_DELAY        FLOAT
);

-- Enable local file loading
-- Required setting to allow LOAD DATA INFILE to work.
-- Must be run before the import command below.

SET GLOBAL local_infile = 1;

-- Load airlines data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airlines.csv'
INTO TABLE airlines
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(IATA_CODE, AIRLINE);

-- Load airports data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airports.csv'
INTO TABLE airports
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(IATA_CODE, AIRPORT, CITY, STATE, COUNTRY, LATITUDE, LONGITUDE);

-- Load the flights data
-- Why @variables are used:
--   Delay columns are empty strings ('') for cancelled flights.
--   MySQL cannot store '' in a FLOAT column — it throws a
--   "Data Truncated" error. We load those columns into
--   temporary @variables first, then convert '' to NULL
--   using NULLIF() in the SET block below.
-- ------------------------------------------------------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flights.csv'
INTO TABLE flights
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    YEAR, MONTH, DAY, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER,
    TAIL_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT,
    SCHEDULED_DEPARTURE,
    @DEPARTURE_TIME, @DEPARTURE_DELAY, @TAXI_OUT, @WHEELS_OFF,
    @SCHEDULED_TIME, @ELAPSED_TIME, @AIR_TIME, @DISTANCE,
    @WHEELS_ON, @TAXI_IN,
    SCHEDULED_ARRIVAL,
    @ARRIVAL_TIME, @ARRIVAL_DELAY,
    DIVERTED, CANCELLED, @CANCELLATION_REASON,
    @AIR_SYSTEM_DELAY, @SECURITY_DELAY, @AIRLINE_DELAY,
    @LATE_AIRCRAFT_DELAY, @WEATHER_DELAY
)
SET
    -- Convert empty strings to NULL for all nullable columns
 DEPARTURE_TIME = NULLIF(@DEPARTURE_TIME, ''),
 DEPARTURE_DELAY = NULLIF(@DEPARTURE_DELAY, ''),
 TAXI_OUT = NULLIF(@TAXI_OUT, ''),
 WHEELS_OFF = NULLIF(@WHEELS_OFF, ''),
 SCHEDULED_TIME = NULLIF(@SCHEDULED_TIME, ''),
 ELAPSED_TIME = NULLIF(@ELAPSED_TIME, ''),
 AIR_TIME = NULLIF(@AIR_TIME, ''),
 DISTANCE = NULLIF(@DISTANCE, ''),
 WHEELS_ON = NULLIF(@WHEELS_ON, ''),
 TAXI_IN = NULLIF(@TAXI_IN, ''),
 ARRIVAL_TIME = NULLIF(@ARRIVAL_TIME, ''),
 ARRIVAL_DELAY = NULLIF(@ARRIVAL_DELAY, ''),
 CANCELLATION_REASON = NULLIF(@CANCELLATION_REASON, ''),
 AIR_SYSTEM_DELAY = NULLIF(@AIR_SYSTEM_DELAY, ''),
 SECURITY_DELAY = NULLIF(@SECURITY_DELAY, ''),
 AIRLINE_DELAY = NULLIF(@AIRLINE_DELAY, ''),
 LATE_AIRCRAFT_DELAY = NULLIF(@LATE_AIRCRAFT_DELAY, ''),
 WEATHER_DELAY = NULLIF(@WEATHER_DELAY, '');