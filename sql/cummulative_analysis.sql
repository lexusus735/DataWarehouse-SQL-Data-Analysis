

--subquery
SELECT 
order_year,
total_sales,
avg_price,
--window func for runing total sales over time
sum(total_sales) OVER (ORDER BY order_year) as running_total_sales,
round(avg(avg_price) OVER (ORDER BY order_year),2) as moving_avg_price
FROM
-- the total sales per month
(SELECT 
date_trunc('year', order_date):: date as order_year,
sum(sales_amount) as total_sales,
round(avg(sales_price),2) as avg_price
from gold.fact_sales
where order_date is NOT NULL
GROUP BY order_year)