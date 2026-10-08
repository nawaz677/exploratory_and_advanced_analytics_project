-- ( [Measure] / Total [Measure] ) * 100 By [Dimension]
-- ( Sales / Total Sales ) * 100 By Category
-- ( Quantity / Total Quantity ) * 100 By Country


-- Q). Which categories contribute the most to overall sales

WITH contribution AS 
(
SELECT 
	category, 
	total_category_sales, 
	SUM(total_category_sales) OVER() AS overall_sales
FROM
	(
	SELECT  
		p.category, 
		SUM(s.sales) AS total_category_sales
	FROM gold.fact_sales s
	JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY category
	) o
)

SELECT 
	category, 
	total_category_sales, 
	overall_sales,
	CONCAT(ROUND(total_category_sales / CAST(overall_sales AS FLOAT) * 100, 2), ' % ') AS percentage_contribution
FROM contribution
ORDER BY total_category_sales DESC 