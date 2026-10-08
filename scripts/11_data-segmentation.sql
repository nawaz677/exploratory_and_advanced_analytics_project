-- [Measure] By [Measure]
-- Total Products By Sales Range
-- Total Customers By Age Group 

-- Q1). Segment products into cost ranges and count how many products fall into each segment.

--SELECT 
--	COUNT(product_key) AS total_products, 
--	cost_range
--FROM
--	(
--	SELECT 
--		product_key, 
--		product_name, 
--		cost, 
--		CASE 
--			WHEN cost <= 1000 THEN 'Cheap'
--			WHEN cost <= 2000 THEN 'Moderate' 
--			ELSE 'Expensive'
--		END AS cost_range
--	FROM gold.dim_products
--	) o 
--GROUP BY cost_range
--ORDER BY total_products


-- Q2) : 
/* Group customers into three segments based upon their spending behaviour
	- VIP : Customers with at least 12 months of history and spending more than $5000
	- Regular : Customers with at least 12 months of history and spending less than or equal to $5000
	- Seasonal : Customers with less than 12 months of history
And find the total number of customers by each group 
*/
 
WITH cte1 AS 
(
	SELECT 
		c.customer_key, 
		c.first_name, 
		MIN(order_date) AS first_order_date,
		MAX(order_date) AS last_order_date,
		SUM(s.sales) AS total_spending, 
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span_months
	FROM gold.dim_customers c
	LEFT JOIN gold.fact_sales s
	ON c.customer_key = s.customer_key 
	GROUP BY c.customer_key, c.first_name
	-- ORDER BY c.customer_key
), 

cte2 AS 
(
	SELECT 
		customer_key, 
		first_name, 
		total_spending, 
		life_span_months,
		CASE 
			WHEN life_span_months >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN life_span_months >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'Seasonal'
		END AS customer_segment
	FROM cte1
	-- ORDER BY customer_key
)

SELECT 
	customer_segment, 
	COUNT(customer_segment) AS total_customers
FROM cte2
GROUP BY customer_segment
ORDER BY total_customers DESC