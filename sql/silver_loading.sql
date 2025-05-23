
--======================================
-- full loading into the silver container

--==========================================
-- for crm

BEGIN;
-- clear target tables
TRUNCATE silver.crm_prd_info,silver.crm_cust_info,silver.crm_sales_details;
TRUNCATE silver.erp_px_cat_g1v2,silver.erp_cust_az12,silver.erp_loc_a101;

--======================================================================
ALTER TABLE silver.crm_prd_info
ADD column cat_id VARCHAR(50);
INSERT INTO silver.crm_prd_info(
    prd_id,
    prd_key,
    cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)

SELECT
prd_id,
SUBSTRING(prd_key,7) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
btrim(prd_nm) AS prd_nm,
CASE 
    WHEN prd_cost IS NULL THEN 0
    ELSE prd_cost
END prd_cost,
CASE
    WHEN btrim(prd_line) = 'M' THEN 'Mountain'
    WHEN btrim(prd_line) = 'T' THEN 'Touring'
    WHEN btrim(prd_line) = 'S' THEN 'Other Sales'
    WHEN btrim(prd_line) = 'R' THEN 'Road'
    ELSE 'N/A'
END prd_line,
prd_start_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
FROM bronze.crm_prd_info ;

--==========================================================

INSERT INTO silver.crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

SELECT
cst_id,
btrim(cst_key) AS cst_key,
btrim(cst_firstname) AS cst_firstname,
btrim(cst_lastname) AS cst_lastname,
CASE
    WHEN upper(btrim(cst_marital_status)) = 'M' THEN 'Married'
    WHEN upper(btrim(cst_gndr)) = 'S' THEN 'Single'
    ELSE 'N/A'
END cst_marital_status,
CASE
    WHEN upper(btrim(cst_gndr)) = 'M' THEN 'Male'
    WHEN upper(btrim(cst_gndr)) = 'F' THEN 'Female'
    ELSE 'N/A'
END cst_gndr,
cst_create_date
FROM (
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) AS cst_rank
from bronze.crm_cust_info
)
WHERE cst_rank =1 AND cst_id IS NOT NULL;

--=================================================================

INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_price,
    sls_quantity

)
SELECT
btrim(sls_ord_num) AS sls_ord_num,
btrim(sls_prd_key) AS sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
CASE
    WHEN sls_price IS NULL THEN abs(sls_sales)
    ELSE abs(sls_quantity) * abs(sls_price)
END sls_sales,
CASE
    WHEN (sls_sales IS NULL OR sls_sales=0.00) THEN abs(sls_price)
    ELSE round(abs(sls_sales) / abs(sls_quantity),2) 
END sls_price,
sls_quantity
FROM bronze.crm_sales_details;

--===============================================================
-- ERP
INSERT INTO silver.erp_px_cat_g1v2(
    id,
    cat,
    subcat,
    maintenance
)

SELECT
btrim(id) AS id,
btrim(cat) AS cat,
btrim(subcat) AS subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;

--==============================================================

ALTER TABLE silver.erp_cust_az12
ADD column cust_age INT;

INSERT INTO silver.erp_cust_az12(
    cid,
    bdate,
    cust_age,
    gen
)
SELECT
SUBSTRING(btrim(cid),4) as cid,
bdate,
EXTRACT(year from age(now(),bdate)) as cust_age,
CASE
    WHEN upper(btrim(gen)) = 'M' THEN 'Male'
    WHEN upper(btrim(gen)) = 'F' THEN 'Female'
    WHEN upper(btrim(gen)) = '' THEN 'N/A'
    WHEN upper(btrim(gen)) IS NULL THEN 'N/A'
    ELSE btrim(gen)
END gen
FROM bronze.erp_cust_az12
WHERE bdate <=NOW();
--=======================================

INSERT INTO silver.erp_loc_a101(
    cid,
    cntry
)
SELECT
REPLACE(btrim(cid),'-','') AS cid,
CASE
    WHEN lower(btrim(cntry)) = 'de' THEN 'Germany'
    WHEN lower(btrim(cntry)) = 'us' THEN 'United States'
    WHEN lower(btrim(cntry)) = 'usa' THEN 'United States'
    WHEN lower(btrim(cntry)) IS NULL THEN 'N/A'
    ELSE cntry
END cntry
FROM bronze.erp_loc_a101;

COMMIT;


