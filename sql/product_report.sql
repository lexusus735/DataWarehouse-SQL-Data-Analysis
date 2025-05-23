

SELECT * FROM gold.product_report
-- create a view for the report
CREATE view gold.product_report AS
with base_query AS (
SELECT
sf.order_date,
sf.customer_id AS "customer_key",
sf.order_number,
sf.sales_amount,
sf.sales_quantity AS "quantity",
pd.product_key AS "product_number",
pd.product_name,
pd.product_category AS "category",
pd.product_subcategory AS "subcategory",
pd.maintenance,
pd.product_cost AS "cost",
pd.product_line,
pd.product_id AS "product_key"

from gold.fact_sales sf 
LEFT JOIN gold.dim_product pd ON sf.product_key = pd.product_key
WHERE sf.order_date is not NULL

),
product_aggregation AS(
SELECT 
product_number,
category,
subcategory,
product_name,
product_key,
cost ,
count(DISTINCT order_number) AS total_orders,
sum(sales_amount) AS total_sales,
count(DISTINCT customer_key) AS total_customers,
sum(quantity) as total_quantity,
max(order_date) as last_order_date,
EXTRACT(YEAR from age(max(order_date),min(order_date))) *12 +
EXTRACT(month from age(max(order_date),min(order_date))) AS lifespan
from base_query
GROUP BY product_key, product_number, product_name, category, subcategory,cost 

)

SELECT
product_number,
category,
subcategory,
product_name,
product_key,
cost ,
case
    when total_sales > 50000 then 'High-Performer'
    when total_sales >= 10000 then 'Mid-Range'
    else 'Low-Performer'
end product_segment,
total_orders,
total_sales,
total_quantity,
total_customers,
last_order_date,
-- is customer still active
EXTRACT(YEAR FROM AGE(NOW(), last_order_date)) * 12 +
EXTRACT(MONTH FROM AGE(NOW(), last_order_date)) AS recency,
lifespan,
-- avg order value
case
 when total_sales = 0 then 0
 else round(total_sales / total_orders,2)
end AS avg_order_revenue,
-- avg monthly spend
case
 when lifespan = 0 then total_sales
 else round(total_sales / lifespan,2)
end AS avg_monthly_revenue
from product_aggregation