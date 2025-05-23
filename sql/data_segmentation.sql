WITH product_segment AS(
SELECT
product_key,
product_name,
product_cost,
CASE
    WHEN product_cost < 100 then 'Below 100'
    WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
    WHEN product_cost BETWEEN 500 and 1000 THEN '500-1000'
    ELSE 'Above 1000'
END cost_range
from gold.dim_product
)

SELECT
cost_range,
count(product_key) as total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC