--CTE
WITH yearly_product_sales AS (
   

    SELECT
    EXTRACT(YEAR from sf.order_date) as order_year,
    pd.product_name,
    sum(sf.sales_amount) as current_sales

    FROM
    gold.fact_sales sf
    LEFT JOIN gold.dim_product pd
    ON sf.product_key = pd.product_key
    WHERE sf.order_date is not NULL
    GROUP BY 
    order_year, pd.product_name
)

SELECT 
order_year,
product_name,
current_sales,
--window for the avg sales
round(avg(current_sales) OVER(PARTITION BY product_name),2) AS avg_sales,
round(current_sales - avg(current_sales) OVER(PARTITION BY product_name),2) AS diff_avg,
-- case to high the below, abv avg target
case
    when current_sales - avg(current_sales) OVER(PARTITION BY product_name) > 0 then 'Above Avg'
    when current_sales - avg(current_sales) OVER(PARTITION BY product_name)  < 0 then 'Below Avg'
    else 'Average'
end avg_change,
--lag window  year over year
lag(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as py_sales,
current_sales - lag(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_py,
case
    when current_sales - lag(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 then 'Increase'
    when current_sales - lag(current_sales) OVER(PARTITION BY product_name ORDER BY order_year)  < 0 then 'Decrease'
    else 'No Change'
end py_change
from yearly_product_sales
ORDER BY
product_name, order_year