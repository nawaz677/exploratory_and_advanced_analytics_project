/*	Sigma [Measure] By [Dimension]
		Total Sales By Country
		Total Quantity By Category 
		Average Price By Product
		Total Orders By Customer
*/ 

-- Q1). Find total customers by countries 
--SELECT country, COUNT(*) AS customers  
--FROM gold.dim_customers
--GROUP BY country 
--ORDER BY customers DESC


-- Q2). Find total customers by genders 
--SELECT gender, COUNT(*) AS customers 
--FROM gold.dim_customers
--GROUP BY gender 
--ORDER BY customers DESC


-- Q3). Find total products by category 
--SELECT category, COUNT(*) AS products  
--FROM gold.dim_products
--GROUP BY category 
--ORDER BY products DESC	


-- Q4). What is the average cost in each category 
--SELECT category, AVG(cost) AS cost 
--FROM gold.dim_products
--GROUP BY category
--ORDER BY cost DESC


-- Q5). What is the total revenue generated for each category 
--SELECT prd.category, SUM(sls.sales) AS sales_revenue
--FROM gold.fact_sales sls
--RIGHT JOIN gold.dim_products prd
--ON   sls.product_key = prd.product_key 
--GROUP BY prd.category
--ORDER BY sales_revenue DESC


-- Q6). Find total revenue generated against each customer
--SELECT 
--sls.customer_key, cst.first_name, cst.last_name, 
--SUM(sls.sales) AS sales_revenue
--FROM gold.fact_sales sls
--RIGHT JOIN gold.dim_customers cst
--ON sls.customer_key = cst.customer_key
--GROUP BY sls.customer_key, cst.first_name, cst.last_name
--ORDER BY sales_revenue DESC


-- Q7). What is the distribution of sold items across countries 
--SELECT cst.country, SUM(sls.quantity) AS items_sold
--FROM gold.fact_sales sls 
--RIGHT JOIN gold.dim_customers cst
--ON		   sls.customer_key = cst.customer_key 
--GROUP BY cst.country
--ORDER BY items_sold DESC