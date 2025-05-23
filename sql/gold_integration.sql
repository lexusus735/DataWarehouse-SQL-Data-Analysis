
--=====================================================
/*
Integrate the datasets and join data table
rename filed names
check for product id uniqueness and not nulls

*/
CREATE VIEW gold.dim_product AS (

SELECT 
pf.prd_id AS "product_id",
pf.prd_key AS "product_key",
pf.cat_id AS "product_category_key",
pcg.cat AS "product_category",
pcg.subcat AS "product_subcategory",
pf.prd_nm AS "product_name",
pf.prd_line as "product_line",
pcg.maintenance,
pf.prd_cost AS "product_cost",
pf.prd_start_dt AS "product_start_date",
pf.prd_end_dt AS "product_end_date"
FROM silver.crm_prd_info pf 
LEFT JOIN silver.erp_px_cat_g1v2 pcg 
ON pf.cat_id = pcg.id
WHERE pf.prd_end_dt IS NOT NULL
);
--========================================================
-- customer dimension table
CREATE VIEW gold.dim_customer AS (
SELECT
cf.cst_id AS "customer_id",
cf.cst_key AS "customer_key",
cf.cst_firstname AS "firstname",
cf.cst_lastname AS "lastname",
CASE 
    WHEN cf.cst_gndr = 'N/A' THEN coalesce(ca.gen,'N/A')
    ELSE cf.cst_gndr
END gender,
cf.cst_marital_status AS "marital_status",
la.cntry AS "country",
ca.bdate AS "birthdate",
ca.cust_age AS "age",
cf.cst_create_date AS "customer_created_date"
FROM silver.crm_cust_info cf 
LEFT JOIN silver.erp_cust_az12 ca 
ON cf.cst_key = ca.cid 
LEFT JOIN silver.erp_loc_a101 la 
ON cf.cst_key = la.cid 
);

--===================================================
-- sales detail

CREATE VIEW gold.fact_sales AS(
SELECT DISTINCT
sls_ord_num AS "order_number",
sls_prd_key AS "product_key",
sls_cust_id AS "customer_id",
sls_order_dt AS "order_date",
sls_ship_dt AS "ship_date",
sls_due_dt AS "due_date",
sls_sales AS "sales_amount",
sls_quantity AS "sales_quantity",
sls_price AS "sales_price"
FROM silver.crm_sales_details
)