
SELECT 
EXTRACT(YEAR from order_date) AS order_year,
sum(sales_amount) AS total_sales,
count(DISTINCT customer_id) AS total_customers,
sum(sales_quantity) as total_quantity
from gold.fact_sales
WHERE order_date is NOT NULL
GROUP BY order_year
ORDER BY order_year;