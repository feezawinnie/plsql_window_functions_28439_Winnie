# plsql_window_function_28439_Feeza_Winnie

# Municipal Rubbish Collection Analysis  
SQL JOINs and Window Functions Project

## Business Context
This project analyzes rubbish collection operations for a Municipal Waste Management Authority responsible for sanitation services across multiple districts and zones.

## Data Challenge
Although waste collection data is recorded daily, it is not analyzed to identify trends, inefficiencies, or high waste–generating areas. Decision-makers lack clear insights for optimizing collection schedules and resource allocation.

## Expected Outcome
The analysis identifies top waste-generating zones, tracks monthly waste trends, segments districts by waste volume, and supports data-driven planning.



## Success Criteria
1.  top waste-generating zones per month using RANK()  
2. running waste totals per district using SUM() OVER()  
3. month-over-month waste change using LAG()  
4.  districts into quartiles using NTILE(4)  
5.  three-month moving averages using AVG() OVER()



## Database Schema

A one-to-many relationship exists between districts and zones, and between zones and collections.

```sql
-- Create districts table
CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL,
    population INT NOT NULL
);

-- Create zones table
CREATE TABLE zones (
    zone_id SERIAL PRIMARY KEY,
    district_id INT REFERENCES districts(district_id),
    zone_name VARCHAR(100) NOT NULL
);

-- Create collections table
CREATE TABLE collections (
    collection_id SERIAL PRIMARY KEY,
    zone_id INT REFERENCES zones(zone_id),
    collection_date DATE NOT NULL,
    waste_kg DECIMAL(10,2) NOT NULL,
    contractor VARCHAR(100)
);

```
## ER DIAGRAM
![ERD](screenshots/ER%20DIAGRAM.png)



## Part A — SQL JOINs

### INNER JOIN
```sql
SELECT d.district_name, z.zone_name, c.collection_date, c.waste_kg
FROM collections c
INNER JOIN zones z ON c.zone_id = z.zone_id
INNER JOIN districts d ON z.district_id = d.district_id;

```


![ER](screenshots/inner_join.png)



Retrieves valid rubbish collection records with district and zone details.


### LEFT JOIN
```SQL
SELECT d.district_name
FROM districts d
LEFT JOIN zones z ON d.district_id = z.district_id
LEFT JOIN collections c ON z.zone_id = c.zone_id
WHERE c.collection_id IS NULL;
```
![ER](screenshots/left_join.png)

Identifies districts without any collection records.

### RIGHT JOIN
```sql
SELECT z.zone_name
FROM collections c
RIGHT JOIN zones z ON c.zone_id = z.zone_id
WHERE c.collection_id IS NULL;
```
![ER](screenshots/right_join.png)

Detects zones with no rubbish collection activity.

### FULL OUTER JOIN
```sql
SELECT d.district_name, z.zone_name
FROM districts d
FULL OUTER JOIN zones z
ON d.district_id = z.district_id;
```
![ER](screenshots/full_join.png)
Shows all districts and zones including unmatched records.

### SELF JOIN
```sql
SELECT a.zone_name AS zone_1, b.zone_name AS zone_2, d.district_name
FROM zones a
JOIN zones b ON a.district_id = b.district_id
JOIN districts d ON a.district_id = d.district_id
WHERE a.zone_id <> b.zone_id;
```
![ER](screenshots/self_join.png)
Compares zones within the same district.

## Part B — Window Functions

### Ranking Functions
```sql
SELECT zone_name, month, total_waste,
RANK() OVER (PARTITION BY month ORDER BY total_waste DESC) AS rank_in_month
FROM (
    SELECT z.zone_name,
    DATE_TRUNC('month', c.collection_date) AS month,
    SUM(c.waste_kg) AS total_waste
    FROM collections c
    JOIN zones z ON c.zone_id = z.zone_id
    GROUP BY z.zone_name, month
) t;
```
![ER](screenshots/rank_function.png)
RANK() used to identify top waste-generating zones per month.

### Aggregate Window Functions
```sql
SELECT district_name, collection_date,
SUM(waste_kg) OVER (
PARTITION BY district_name
ORDER BY collection_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total
FROM (
    SELECT d.district_name, c.collection_date, c.waste_kg
    FROM collections c
    JOIN zones z ON c.zone_id = z.zone_id
    JOIN districts d ON z.district_id = d.district_id
) x;
```
![ER](screenshots/running_total.png)

SUM() OVER used to compute running waste totals per district.

### Navigation Functions
```sql
SELECT month, total_waste,
total_waste - LAG(total_waste) OVER (ORDER BY month) AS monthly_change
FROM (
    SELECT DATE_TRUNC('month', collection_date) AS month,
    SUM(waste_kg) AS total_waste
    FROM collections
    GROUP BY month
) m;

```
![ER](screenshots/lag_growth.png)
LAG() used to calculate month-to-month waste change.

### Distribution Functions
```sql
SELECT district_name, total_waste,
NTILE(4) OVER (ORDER BY total_waste DESC) AS waste_quartile
FROM (
    SELECT d.district_name, SUM(c.waste_kg) AS total_waste
    FROM collections c
    JOIN zones z ON c.zone_id = z.zone_id
    JOIN districts d ON z.district_id = d.district_id
    GROUP BY d.district_name
) t;
```

![ER](screenshots/ntile.png)
NTILE(4) used to segment districts into four waste quartiles.

### Moving Average
```sql
SELECT month, total_waste,
AVG(total_waste) OVER (
ORDER BY month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS three_month_avg
FROM (
    SELECT DATE_TRUNC('month', collection_date) AS month,
    SUM(waste_kg) AS total_waste
    FROM collections
    GROUP BY month
) m;
```
![ER](screenshots/moving_average.png)



## Key Insights
- A small number of zones generate a large proportion of total waste.  
- Waste collection shows consistent monthly growth.  
- High-population districts dominate the top waste quartiles.


## Recommendations
- Increase collection frequency in high-waste zones.  
- Implement waste reduction programs in top quartile districts.  
- Reallocate resources from low-activity zones.

# Results Analysis

## 1. Descriptive (What happened?)
The analysis shows that waste generation is not evenly distributed across zones. A small number of zones consistently rank among the highest waste generators each month. Running totals indicate a steady increase in overall waste collected over time. Districts in the top quartile contribute a disproportionately large share of total waste.

## 2. Diagnostic (Why did it happen?)
High-waste zones are mainly located in densely populated and highly commercialized areas, which naturally generate more waste. Monthly growth is driven by increasing population, urban expansion, and limited recycling practices. Lower-performing zones are typically residential or rural areas with lower population density and fewer commercial activities.

## 3. Prescriptive (What should be done next?)
The municipality should increase collection frequency and allocate more trucks and staff to high-waste zones. Recycling and waste separation programs should be prioritized in top-quartile districts to reduce landfill pressure. Low-waste zones can maintain current schedules, allowing resources to be reallocated where demand is higher.

## References
# References

PostgreSQL Documentation – Window Functions  
https://www.postgresql.org/docs/current/tutorial-window.html  

PostgreSQL Documentation – JOIN Types  
https://www.postgresql.org/docs/current/queries-table-expressions.html  

Oracle SQL Analytical (Window) Functions Guide  
https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Analytic-Functions.html  

W3Schools SQL Window Functions Tutorial  
https://www.w3schools.com/sql/sql_window_functions.asp  

W3Schools SQL JOIN Tutorial  
https://www.w3schools.com/sql/sql_join.asp  


## Integrity Statement
“All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.”
