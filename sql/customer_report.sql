
-- create a view for the report
CREATE view gold.customer_report AS
with base_query AS(

SELECT
sf.order_date,
sf.product_key,
sf.order_number,
sf.sales_amount,
sf.sales_quantity AS "quantity",
cd.customer_id AS "customer_number",
EXTRACT(YEAR from age(now(),cd.birthdate)) as customer_age,
concat_ws(' ', cd.firstname, cd.lastname) as customer_name,
cd.customer_key 
from gold.fact_sales sf 
LEFT JOIN gold.dim_customer cd ON sf.customer_id = cd.customer_id
WHERE sf.order_date is not NULL
),
customer_aggregation AS(

SELECT 
customer_age,
customer_name,
customer_key,
customer_number,
count(DISTINCT order_number) AS total_orders,
sum(sales_amount) AS total_sales,
count(DISTINCT product_key) AS total_products,
sum(quantity) as total_quantity,
max(order_date) as last_order_date,
EXTRACT(YEAR from age(max(order_date),min(order_date))) *12 +
EXTRACT(month from age(max(order_date),min(order_date))) AS lifespan
from base_query
GROUP BY customer_key, customer_number, customer_name, customer_age
)

SELECT
customer_age,
customer_name,
customer_key,
customer_number,
case
    when customer_age < 20 then 'under 20'
    when customer_age between 20 and 29 then '20-29'
    when customer_age between 30 and 39 then '30-39'
    when customer_age between 40 and 49 then '40-49'
    else '50 and above'
end age_group,
case
    when lifespan >= 12 and total_sales > 5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end customer_segment,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
-- is customer still active
EXTRACT(YEAR FROM AGE(NOW(), last_order_date)) * 12 +
EXTRACT(MONTH FROM AGE(NOW(), last_order_date)) AS recency,
lifespan,
-- avg order value
case
 when total_sales = 0 then 0
 else round(total_sales / total_orders,2)
end AS avg_order_value,
-- avg monthly spend
case
 when lifespan = 0 then total_sales
 else round(total_sales / lifespan,2)
end AS avg_monthly_spend
from customer_aggregation