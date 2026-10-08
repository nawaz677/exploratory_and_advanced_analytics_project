-- Current[Measure] - Target[Measure]
-- Current Sales - Average Sales
-- Current Year Sales - Previous Year Sales (Year-Over-Year Analysis)
-- Current Sales - Lowest Sales


/* 
Analyze the yearly performance of products by comparing each product's sales to both its average
sales performance and the previous year's sales.
Average : 
	say product_key : 7 has sales in years 2010 and 2011. Now find the average of these two years
	combine not separate. 
*/

WITH yearly_sales_performance AS  
( 
	SELECT 
		product_key,
		YEAR(order_date) AS order_year,
		SUM(sales) AS current_year_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY product_key, YEAR(order_date) 
) 

SELECT 
	product_key, 
	order_year, 
	current_year_sales,
	AVG(current_year_sales) OVER(PARTITION BY product_key) AS avg_yearly_sales, 
	current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_key) AS avg_difference,
	CASE 
		WHEN current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_key) > 0 THEN 'Above Avg'
		WHEN current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_key) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,

-- Year-Over-Year Analysis
	LAG(current_year_sales) OVER(PARTITION BY product_key ORDER BY order_year) AS previous_year_sales,
	current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_key ORDER BY order_year) AS yearly_sales_diff,
	CASE 
		WHEN current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_key ORDER BY order_year) > 0 THEN 'increase' 
		WHEN current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_key ORDER BY order_year) < 0 THEN 'decrease'
		ELSE 'no change'
	END AS yearly_change
FROM yearly_sales_performance 
ORDER BY product_key, order_year