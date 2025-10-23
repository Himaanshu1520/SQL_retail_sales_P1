DROP TABLE IF EXISTS sales;
CREATE TABLE sales(

	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(50),
	age	INT,
	category VARCHAR(100),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM sales;

SELECT COUNT(*) FROM sales;

--Data Cleaning

SELECT * FROM sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Deleting NULL values 

DELETE FROM sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data exploration 

--1. how many sales we have?

SELECT COUNT(total_sale) AS total_sales FROM sales;

SELECT COUNT(*) AS total_sales FROM sales;

--2.how many customers we have?

SELECT COUNT(customer_id) AS total_customer FROM sales;

SELECT COUNT(DISTINCT customer_id) AS total_customer FROM sales;

--3.how many UNIQUE category we have ?

SELECT DISTINCT category FROM sales;

-- Data Analysis

--1. Write a sql query to retrive all columns for sales made on '2022-11-05'

SELECT * FROM sales 
WHERE sale_date = '2022-11-05';

--2.write a sql query
--to retrive all transactions where the category is colthing and 
--the quantiy sold is more then 10 in the month of nov-2022

SELECT *
FROM sales
WHERE category = 'Clothing'
AND quantiy >=4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--3.write a query to calculate the total sales for each category?

SELECT 
category, 
SUM(total_sale) AS current_sales,
COUNT(*) AS total_orders
FROM sales
GROUP BY 1;

--4.write a sql query to find the avg age of customers who purchased items from the 'beauty' category?

SELECT AVG(age) AS avg_age
FROM sales
WHERE category = 'beauty';


SELECT ROUND(AVG(age)) AS avg_age
FROM sales
WHERE TRIM(LOWER(category))= 'beauty';


--5.write the sql query to find all transations where the total sales is greater then 1000?

SELECT * FROM sales
WHERE total_sale > 1000;

--6.write a sql query to find the total number of transactions(transactions_id) made by each gender in each category?

SELECT 
gender,
category,
COUNT (*) AS total_trans
FROM sales 
GROUP BY category,gender;

--7.Writw a sql query to calculate the avg sale for each month . find out best selling month in each year 
SELECT * FROM
(
	SELECT 
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	ROUND(AVG(total_sale)) AS avg_sales,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date)ORDER BY ROUND(AVG(total_sale)) DESC) as rank 
	FROM sales 
	GROUP BY 1,2
) AS p1
WHERE rank =1;

--8. write a sql query to find the top 5 customer based on the higest total sales?

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9.write a sql query to find the number of unique customers who purchased items from each category?

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS total_customers
FROM sales
GROUP BY category;

--10.write a sql query to create each shift and number of orders (example;- mrg<12,aft b/w 12&17,evg>17)?

SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
	END AS shift 
FROM sales;
