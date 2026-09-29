/* Exploring the Boundaries of the dates we have in the datasets */

-- Find the date of the first and last order 
-- How many years of sales are available
SELECT MIN(order_date) AS first_order_date, 
MAX(order_date) AS last_order_date, 
DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales


-- Oldest and Youngest Customers 
SELECT MIN(birthdate) AS oldest_date, 
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_date,
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers