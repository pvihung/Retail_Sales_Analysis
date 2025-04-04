CREATE DATABASE aspiring;
USE aspiring;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
select *
from retail_sales;

SELECT count(*)
FROM retail_sales;

-- Check null
select *
from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- delete null
delete from retail_sales
WHERE transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Data Exploration 
-- How many sales we have
select count(*) as numsales 
from retail_sales;

-- how many unique customers we have
select count( distinct customer_id)
from retail_sales;

-- Business Key Problems 
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select *
from retail_sales
where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 
-- 'Clothing' and the quantity sold is >= 4 in the month of Nov-2022: 
-- hoặc dùng date_format(sale_date,'%Y-%M') = ' ' 
select * 
from retail_sales
where category = 'Clothing' 
and quantity>=4 
and year(sale_date)='2022'
and month(sale_date)='11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) 
from retail_sales
group by category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select category, round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty'
group by category;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select *
from retail_sales 
where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category, gender, count(transactions_id) 
from retail_sales 
group by 1,2;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with month_sale as (
				select year(sale_date) as sale_year,
				month(sale_date) as sale_month,
				round(avg(total_sale),2) as monthly_sale
		from retail_sales
		group by 1,2)
select sale_year, sale_month, monthly_sale
from (
	select *, 
    rank() over (partition by sale_year 
				 order by monthly_sale DESC) as rank_no
	from month_sale) as ranked
where rank_no =1;

-- Hoặc
select sale_month, sale_year, month_avg 
from ( 
	select 
			month(sale_date) as sale_month,
			year(sale_date) as sale_year, 
			round(avg(total_sale),2) as month_avg, 
            RANK() over (partition by year(sale_date) order by avg(total_sale) DESC) as rank_no
	from retail_sales
	group by year(sale_date), month(sale_date)) as subquery
where rank_no=1;
	
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
-- limit sẽ giống như head 
select customer_id, sum(total_sale) as sale
from retail_sales 
group by customer_id
order by sale desc
limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
select category, count( distinct customer_id)
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select 
	case 
		when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift,
    count(transactions_id) as numTrac
from retail_sales
group by shift;

-- END OF PROJECT
