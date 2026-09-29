-- Q1). Find the total sales 
SELECT SUM(sales) AS total_sales
FROM gold.fact_sales


-- Q2). Find how many items are sold
SELECT SUM(quantity) AS total_sold_items
FROM gold.fact_sales


-- Q3). Find the average selling price
SELECT AVG(price) AS average_selling_price 
FROM gold.fact_sales


-- Q4). Find the total number of orders 
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales


-- Q5). Find the total number of products 
SELECT COUNT(product_key) AS total_products 
FROM gold.dim_products 


-- Q6). Find the total number of customers 
SELECT COUNT(customer_key) AS total_customers 
FROM gold.dim_customers


-- Q7). Find the total number of customers that have placed an order
SELECT COUNT(DISTINCT customer_key) AS customers_with_an_order
FROM gold.fact_sales 



-- Big Measure
-- Generate a report that shows all key metrics of the business 

SELECT 'Total Sales' AS measure_name, 
SUM(sales) AS measure_value
FROM gold.fact_sales 

UNION 

SELECT 'Total Items Sold' AS measure_name, SUM(quantity) AS measure_value 
FROM gold.fact_sales

UNION

SELECT 'Average Selling Price' AS measure_name, AVG(price) AS measure_value
FROM gold.fact_sales

UNION 

SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value
FROM gold.fact_sales

UNION 

SELECT 'Total Products' AS measure_name, COUNT(product_key) AS measure_value 
FROM gold.dim_products

UNION 

SELECT 'Total Customers' AS measure_name, COUNT(first_name) AS measure_value 
FROM gold.dim_customers

UNION 

SELECT 'Total Customers With Orders' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value
FROM gold.fact_sales