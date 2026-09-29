-- Q1). Which five products generate the highest revenue 
--SELECT *
--FROM 
--(	SELECT 
--		product_key, 
--		SUM(sales) AS sales_revenue, 
--		RANK() OVER(ORDER BY SUM(sales) DESC) AS Ranking
--	FROM gold.fact_sales 
--	GROUP BY product_key ) o
--WHERE o.Ranking <= 5


-- Q2). Which are the five worst performing products 
--SELECT * 
--FROM 
--(	SELECT 
--	product_key, 
--	SUM(sales) AS sales_revenue, 
--	RANK() OVER(ORDER BY SUM(sales)) AS Ranking 
--	FROM gold.fact_sales
--	GROUP BY product_key ) o
--WHERE o.Ranking <= 5


-- Q3). Find the top 10 customers who have generated the highest revenue
--SELECT * 
--FROM 
--(	SELECT 
--		sls.customer_key,
--		cst.first_name, 
--		cst.last_name,
--		SUM(sales) AS sales_revenue, 
--		RANK() OVER(ORDER BY SUM(sales) DESC) AS Ranking 
--	FROM gold.fact_sales sls
--	JOIN gold.dim_customers cst
--	ON	 sls.customer_key = cst.customer_key 
--	GROUP BY sls.customer_key, cst.first_name, cst.last_name ) t
--WHERE t.Ranking <= 5
--ORDER BY t.sales_revenue DESC


-- Q4). Find 3 customers with fewest orders placed
--SELECT * 
--FROM 
--(	SELECT top 3
--	sls.customer_key,
--	cst.first_name, 
--	cst.last_name,
--	COUNT(DISTINCT sls.order_number) AS total_orders,
--	ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT sls.order_number)) AS Ranking 
--	FROM gold.fact_sales sls
--	JOIN gold.dim_customers cst
--	ON   sls.customer_key = cst.customer_key 
--	GROUP BY sls.customer_key, cst.first_name, cst.last_name ) o 
--WHERE o.Ranking <= 3