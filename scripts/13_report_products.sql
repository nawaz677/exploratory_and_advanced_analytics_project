/*
	Purpose : 
		This report consolidates key product metrics and behaviors

	Highlights : 
		1. Gathers essential fields such as product name, category, subcategory and cost
		2. Aggregates product level metrics : 
			- total orders 
			- total sales 
			- total quantity sold 
			- total customers (unique) 
			- lifespan (in months)
		3. Segments products by revenue to identify High-Performers, Mid-Range or Low-Performers
		4. Calculates valuable KPIs : 
			- recency (months since last order) 
			- average order revenue (AOR)
			- average monthly revenue 
*/

CREATE VIEW gold.report_products AS 

WITH base_query AS 
(
	SELECT 
		p.product_key, 
		p.product_name,
		p.category, 
		p.sub_category, 
		p.cost, 
		s.order_number,
		s.customer_key,
		s.order_date,
		s.sales, 
		s.quantity
	FROM gold.fact_sales s 
	JOIN gold.dim_products p  
	ON p.product_key = s.product_key
	WHERE s.order_date IS NOT NULL
	-- ORDER BY p.product_key
),

aggregations AS 
(
	SELECT 
		product_key, 
		product_name,
		category, 
		sub_category, 
		cost,
		COUNT(order_number) AS total_orders,
		SUM(sales) AS total_sales_revenue, 
		SUM(quantity) AS total_quantity_sold, 
		COUNT(DISTINCT customer_key) AS total_customers, 
		MIN(order_date) AS first_order_date, 
		MAX(order_date) AS last_order_date, 
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months 
		-- How DATEDIFF() works is very intriguing. Google more... 
	FROM base_query
	GROUP BY 
		product_key,
	    product_name,
		category, 
		sub_category,
		cost
)

SELECT 
	product_key, 
	product_name,
	category, 
	sub_category, 
	cost, 
	total_orders, 
	total_sales_revenue,
	total_quantity_sold, 
	total_customers,
	lifespan_months,
	CASE 
		WHEN total_sales_revenue < 100000 THEN 'Low-Performer'
		WHEN total_sales_revenue BETWEEN 100000 AND 200000 THEN 'Mid-Range' 
		ELSE 'High-Performer'
	END AS product_segment, 
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_months,
	CASE 
		WHEN total_orders = 0 THEN 0 -- doing this just incase you do a right join and then non-ordered products also get included 
		ELSE total_sales_revenue / total_orders
	END AS average_order_revenue, 
	CASE 
		WHEN lifespan_months = 0 THEN total_sales_revenue
		ELSE total_sales_revenue / lifespan_months 	
	END AS average_monthly_revenue
FROM aggregations 
-- ORDER BY product_key