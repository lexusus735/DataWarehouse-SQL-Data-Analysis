
with customer_spending AS (
SELECT
cd.customer_key,
sum(sf.sales_amount) as total_spending,
min(sf.order_date) as first_order,
max(sf.order_date) as last_order,
EXTRACT(YEAR FROM AGE(MAX(sf.order_date), MIN(sf.order_date))) * 12 +
EXTRACT(MONTH FROM AGE(MAX(sf.order_date), MIN(sf.order_date))) AS lifespan_months
FROM gold.fact_sales sf
LEFT JOIN gold.dim_customer cd ON sf.customer_id = cd.customer_id
GROUP BY cd.customer_key
),
customer_segmentation AS (

SELECT
customer_key,
total_spending,
lifespan_months,
case
    when lifespan_months >= 12 and total_spending > 5000 then 'VIP'
    when lifespan_months >= 12 and total_spending <= 5000 then 'Regular'
    else 'New'
end customer_segment
FROM customer_spending

)

SELECT 
customer_segment,
count(customer_key) AS total_customers
FROM customer_segmentation
GROUP BY customer_segment
order BY total_customers desc