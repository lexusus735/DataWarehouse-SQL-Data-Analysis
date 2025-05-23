
/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customer
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    product_category, 
    product_subcategory, 
    product_name 
FROM gold.dim_product
ORDER BY product_category, product_subcategory, product_name;

/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date)) *12) +
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(NOW(),MIN(birthdate))) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(YEAR FROM AGE(NOW(),MAX(birthdate))) AS youngest_age
FROM gold.dim_customer;

/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT ROUND(SUM(sales_amount),2) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(sales_quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT ROUND(AVG(sales_price),2) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_product

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customer;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(sales_quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(sales_price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_product
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customer;

/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Find total customers by countries
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customer
GROUP BY country
ORDER BY total_customers DESC;

-- Find total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customer
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT
    product_category,
    COUNT(product_key) AS total_products
FROM gold.dim_product
GROUP BY product_category
ORDER BY total_products DESC;

-- What is the average costs in each category?
SELECT
    product_category,
    ROUND(AVG(product_cost),2) AS avg_cost
FROM gold.dim_product
GROUP BY product_category
ORDER BY avg_cost DESC;

-- What is the total revenue generated for each category?
SELECT
    p.product_category,
    ROUND(SUM(f.sales_amount),2) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.product_category
ORDER BY total_revenue DESC;


-- What is the total revenue generated by each customer?
SELECT
    c.customer_key,
    concat_ws(' ',c.firstname,c.lastname) AS "fullname",
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_id = f.customer_id
GROUP BY 
    c.customer_key,
    c.firstname,
    c.lastname
ORDER BY total_revenue DESC;

-- What is the distribution of sold items across countries?
SELECT
    c.country,
    SUM(f.sales_quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_id = f.customer_id
GROUP BY c.country
ORDER BY total_sold_items DESC;

/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT 
    c.customer_key,
    c.firstname,
    c.lastname,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_id = f.customer_id
GROUP BY 
    c.customer_key,
    c.firstname,
    c.lastname
ORDER BY total_revenue DESC
LIMIT 10;

-- The 3 customers with the fewest orders placed
SELECT 
    c.customer_key,
    c.firstname,
    c.lastname,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
    ON c.customer_id = f.customer_id
GROUP BY 
    c.customer_key,
    c.firstname,
    c.lastname
ORDER BY total_orders 
LIMIT 3;