create database if not exists salesdatawal;
CREATE TABLE IF NOT EXISTS sales (
    invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(30) not null,
    product_line varchar(100) not null,
    unit_price decimal not null,
    quantity int not null,
    vat float not null,
    total decimal not null,
    date datetime not null,
    time Time not null,
    payment_method varchar(15) not null,
    cogs decimal not null,
    gross_margin_pct float,
    gross_income decimal not null,
    rating float
);

select 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
	) AS time_of_datefrom sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
CASE
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening"
END);
SELECT 
	date,
	DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name = DAYNAME(date);

SELECT
	date,
    MONTHNAME(date)
from sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);

-- Unique cities
SELECT
	distinct city
from sales;
SELECT
	distinct branch
from sales;
-- In which city each branch is
SELECT
	distinct city,branch
from sales;

-- How many unique product-line does data have?
SELECT 
	count(distinct product_line)
from sales;

-- Most common payment method?
SELECT 
    payment_method, 
    COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;
-- Most selling product line
SELECT 
    product_line, 
    COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;
-- total revenu by month
select 
	month_name as month,
    sum(total) AS total_revenue
from sales
group by month_name
order by total_revenue;

-- what month had longest COGS?
SELECT
	month_name as month,
    sum(cogs) as cogs
FROM sales
group by month_name
order by cogs;

-- What product line had largest revenue
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
group by product_line
order by total_revenue DESC;

-- what is city with largest revenue
SELECT
	branch,
    city,
    SUM(total) AS total_revenue
FROM sales
group by city,branch
order by total_revenue DESC;

-- What product line had largest vat
SELECT
	product_line,
    AVG(vat) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- which branch sold more products than avg?
SELECT
	branch,
    AVG(quantity) AS qty
FROM sales
GROUP BY branch
Having SUM(quantity) > (select AVG(quantity) FROM sales)
ORDER BY qty DESC;

-- What is most common product line by gender?
SELECT
	gender,
    product_line,
    count(gender) AS total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt DESC;

-- What is average rating of each product_line
SELECT
	product_line,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


