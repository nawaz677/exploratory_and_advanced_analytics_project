/*
======================================================================================================
	Purpose : 
		This Report consolidates key customer metrics and behaviors 
	
	Highlights : 
		1. Gathers essential fields such as names, ages and transaction details
		2. Aggregates customer-level metrics : 
			- total orders
			- total sales
			- total quantity purchased 
			- total products 
			- lifespan (in months)
		3. Segments customers into categories (VIP, Regular, Seasonal) and age groups
		4. Calculates valuable KPIs : 
			- recency (months since last order)
			- average order value 
			- average monthly spending
=======================================================================================================
*/

CREATE VIEW gold.report_customers AS 

-------------------------------------------------------------------------
-- Base Query : Retrieves core columns from tables 
-------------------------------------------------------------------------
WITH base_query AS 
(
	SELECT 
		s.order_number,
		s.product_key,
		s.sales, 
		s.quantity, 
		s.order_date,
		c.customer_key, 
		CONCAT(c.first_name,' ',c.last_name) AS customer_name,
		DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales s
	JOIN gold.dim_customers c 
	ON s.customer_key = c.customer_key
	WHERE order_date IS NOT NULL
), 

aggregations AS 
(
	SELECT 
		customer_key, 
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales) AS total_sales,
		SUM(quantity) AS total_quantity_purchased, 
		COUNT(DISTINCT product_key) AS total_products_ordered,
		MAX(order_date) AS last_order_date, -- This dimension is needed for part 4 : recency kpi
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
	FROM base_query
	GROUP BY customer_key, customer_name, age
)

SELECT 
	customer_key, 
	customer_name, 
	age,
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 30 THEN '20-30'
		WHEN age BETWEEN 31 AND 40 THEN '31-40'
		WHEN age BETWEEN 41 AND 50 THEN '41-50'
		ELSE 'Over 50'
	END AS age_group,
	total_orders,
	total_sales, 
	total_quantity_purchased, 
	total_products_ordered, 
	lifespan_months,
	CASE 
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'Seasonal'
	END AS customer_segment,
	last_order_date, 
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS order_recency_months, -- recency (months since last order) kpi 
	ROUND(total_sales / CAST(total_orders AS FLOAT), 2) AS average_order_value, 
	CASE 
		WHEN lifespan_months != 0 THEN total_sales / lifespan_months
		ELSE total_sales
	END AS average_monthly_spending
FROM aggregations  