# US Flight Delays & Cancellations — SQL Analysis

## About This Project

I wanted to work on a real-world dataset that connects to my aeronautical engineering background. The US flight delay dataset from the Department of Transportation caught my attention because it covers actual operational data from 14 airlines across 322 airports — the kind of data aviation operations teams work with daily.

The dataset had 5.8 million rows which made it challenging to import and work with, but that challenge itself taught me a lot about database performance and query optimization.

## Dataset
- Source: Kaggle — 2015 Flight Delays and Cancellations
- Size: 5,819,079 flights | 31 columns | 3 related tables
- Tool: MySQL 8.0, MySQL Workbench

## What I Investigated

- Which airlines have the worst on-time performance?
- What actually causes most flight cancellations — weather or airline fault?
- Does time of day affect how delayed your flight will be?
- Which airports are the most problematic for delays?
- Which routes have the worst delay history?
- How did each airline perform across the full year?

## Key Findings

**Airline Performance**
Alaska Airlines was the most punctual airline of 2015 with a 77.5% on-time rate. Spirit Airlines was the worst at 54.1% — a 23 percentage point gap between best and worst.

**What Actually Causes Cancellations**
Weather causes 54% of cancellations but airline fault causes 35% — meaning over one third of all cancellations are fully within the airline's control to prevent. 
Across 5.8 million flights that translates to roughly 30,000 preventable cancellations in a single year.

**Best and Worst Times to Fly**
Evening flights average 18 minutes delay versus 2 minutes for early morning flights. This is called delay propagation in aviation — delays compound throughout the day as aircraft and crew fall behind schedule.

**Seasonal Patterns**
June, July and Christmas week are the worst periods. 
November is the best month to fly with the lowest 
average delays of the year.

## Challenges I Faced

The biggest challenge was importing the raw CSV file into MySQL. The file is 5.8 million rows and MySQL kept rejecting it due to security restrictions on local file loading. After researching I discovered the file needed to be placed directly in the MySQL server uploads folder and loaded using LOAD DATA INFILE instead of the LOCAL variant.

Once the file loaded I ran into a second problem — the delay columns like departure delay, arrival delay and weather delay had empty values for cancelled flights. MySQL was treating these empty strings as invalid numbers and throwing Data Truncated errors. I solved this by loading those columns into temporary variables first and converting empty values to NULL using NULLIF() before inserting into the table.

I also found that some date columns were stored as separate year, month and day integers rather than a proper date format. I handled this by combining them using CONCAT and LPAD to ensure correct sorting and date range calculations.

These data quality issues taught me that in real projects cleaning the data often takes more time and thinking than writing the actual analysis queries.

## SQL Skills Demonstrated

- Complex multi-table JOINs including double joins 
  on the same table for origin and destination airports
- CTEs including chained multi-level CTEs
- Window functions — RANK, DENSE_RANK, ROW_NUMBER, 
  LAG, running averages with OVER and PARTITION BY
- Data quality checks and NULL analysis
- CASE WHEN classification and pivoting

## Project Structure

```
├── 00_sql_schema.sql
├── phase1_data_exploration.sql
├── phase2_data_cleaning.sql
├── phase3_airline_performance_analysis.sql
├── phase4_airport_route_analysis.sql
├── phase5_delay_cause_analysis.sql
├── phase6_cancellation_analysis.sql
├── phase7_advanced_analysis.sql
└── README.md
```

## How to Run

1. Run sql_schema.sql to create the database 
   and tables
2. Download the dataset from Kaggle and place in 
   MySQL uploads folder
3. Run the LOAD DATA INFILE command from 00_sql_schema.sql
4. Execute phases 1 through 5 in order
