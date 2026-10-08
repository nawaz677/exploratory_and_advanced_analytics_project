-- Sigma [Cumulative Measure] By [Date Dimension]
-- Running Total Sales By Year
-- Moving Average Sales By Month

/*
In cumulative measurements the difference between runnning and moving (also called rolling/sliding) is that running has an ever
expanding frame like rows between unbounded preceding and current row, while moving has a fixed frame size.
*/

-- Q). Calculate the total sales per month and the running total of sales over time. Also calculate the moving_average_price

-- DATETRUNC() function is highly flexible. You can change the granularity of the data really easily

SELECT 
	order_date, 
	monthly_sales, 
	SUM(monthly_sales) OVER(ORDER BY order_date) AS running_total_sales,
	avg_price,
	AVG(avg_price) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) AS moving_avg_price
FROM 
	( SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales) AS monthly_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
	-- ORDER BY order_date
	) o