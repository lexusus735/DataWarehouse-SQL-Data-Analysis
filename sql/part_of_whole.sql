
WITH category_sales AS (

SELECT
product_category AS "category",
sum(sales_amount) as total_sales
FROM gold.fact_sales sf
LEFT JOIN gold.dim_product pd ON sf.product_key = pd.product_key
GROUP BY product_category
)

SELECT 
category,
total_sales,
-- overall sales window, we need global sales no partition or order by
sum(total_sales) OVER() as overall_all,
round((total_sales / sum(total_sales) OVER()) * 100,2) as sales_percent
FROM category_sales
GROUP BY total_sales, category
ORDER BY total_sales DESC