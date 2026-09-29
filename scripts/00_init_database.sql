/* 
	Purpose :
		This is the ddl script for out database. 3 tables are created
		in the schema 'gold' because of gold layer as in medallion
		architecture. 
	=============================================================
	Important Note : 
		As is the nature of bulk insert it will give error if there
		is a conversion problem. Like in the case of dates if it
		finds a Null there it will not convert. We can change the 
		type of a date column to varchar in ddl and then convert 
		it later. What we can also do is to import the data as flat
		files. There in the wizard choose auto type selec type already
		ticked option, it auto chooses the datatypes but do recheck it,
		in the end it will give a warning but the data will get inserted.
	=============================================================
*/

USE MASTER ;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'data_warehouse_analytics')
BEGIN 
	ALTER DATABASE data_warehouse_analytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE ;
	DROP DATABASE data_warehouse_analytics ; 	
END ; 
GO 

CREATE DATABASE data_warehouse_analytics ;
GO 

USE data_warehouse_analytics ;
GO 

CREATE SCHEMA gold ;
GO 


-- Dimension : customers 
DROP TABLE IF EXISTS gold.dim_customers
CREATE TABLE gold.dim_customers (
customer_key int, 
customer_id int,
customer_number varchar(50), 
first_name varchar(50),
last_name varchar(50), 
country varchar(50),
gender varchar(20), 
marital_status varchar(20), 
birthdate date,
create_date date ) 


-- Dimension : products 
DROP TABLE IF EXISTS gold.dim_products 
CREATE TABLE gold.dim_products ( 
product_key int, 
product_id int, 
product_number varchar(50), 
product_name varchar(50), 
category_id varchar(50), 
category varchar(50), 
sub_category varchar(50), 
maintenance varchar(10), 
cost int, 
product_line varchar(50), 
product_start_date date ) 


-- Fact : sales
DROP TABLE IF EXISTS gold.fact_sales 
CREATE TABLE gold.fact_sales ( 
order_number varchar(50), 
customer_key int, 
product_key int, 
order_date date,
ship_date date, 
due_date date, 
sales int, 
quantity int,
price int ) 


TRUNCATE TABLE gold.dim_customers ;
GO

BULK INSERT gold.dim_customers 
FROM 'C:\Users\nawaz\Desktop\data_warehouse_analytics\datasets\gold.dim_customers.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	) ;
GO


TRUNCATE TABLE gold.dim_products ; 
GO 
BULK INSERT gold.dim_products 
FROM 'C:\Users\nawaz\Desktop\data_warehouse_analytics\datasets\gold.dim_products.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	) ;
GO


TRUNCATE TABLE gold.fact_sales ;
GO 
BULK INSERT gold.fact_sales 
FROM 'C:\Users\nawaz\Desktop\data_warehouse_analytics\datasets\gold.fact_sales.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	) ;
GO	