
-- QA for the crm prods_info
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
FROM bronze.crm_prd_info 




-- =========================================================================
-- ensure id is unique and not null
SELECT 
prd_id,
count(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING count(*) >1 OR prd_id IS NULL

-- =========================================================================

-- The product key is a combination of the category: 1;5 and the product label 7;end
-- create a new column for cat_key
SELECT
prd_key
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') in (
    SELECT
    id
    FROM bronze.erp_px_cat_g1v2

)
-- check for prd key

SELECT
prd_key
FROM bronze.crm_prd_info
WHERE prd_key IN(
    SELECT 
sls_prd_key
FROM bronze.crm_sales_details 

)
-- product keys

SELECT DISTINCT
SUBSTRING(prd_key,7) as prds_key_id
FROM bronze.crm_prd_info

-- ============================================================
-- check for the product name col

SELECT 
prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != btrim(prd_nm)

-- ============================================================
-- check prd cost 
SELECT
prd_cost,
CASE 
    WHEN prd_cost IS NULL THEN 0
    ELSE prd_cost
END prd_cost1
FROM bronze.crm_prd_info
--============================================
-- normalize the prd line
SELECT DISTINCT
btrim(prd_line),
prd_nm,
CASE
    WHEN btrim(prd_line) = 'M' THEN 'Mountain'
    WHEN btrim(prd_line) = 'T' THEN 'Touring'
    WHEN btrim(prd_line) = 'S' THEN 'Others'
    WHEN btrim(prd_line) = 'R' THEN 'Road'
    ELSE 'N/A'
END prd_line1
FROM bronze.crm_prd_info

-- ================================
-- prod start and end date
SELECT
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_start_dt IS NULL

-- the prod start dt < end dt 
SELECT 
prd_key,
prd_start_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
FROM bronze.crm_prd_info

--==================================================
-- check QA for customer table

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
WHERE cst_rank =1 AND cst_id IS NOT NULL

-- =====================================================
-- check for id
SELECT
cst_id,
count(*) as cst_currence
from bronze.crm_cust_info
GROUP BY cst_id
HAVING count(*) >1

-- =================================================
-- check cst key and relation with erp

SELECT
cst_key
FROM bronze.crm_cust_info
WHERE cst_key IN (
SELECT
REPLACE(cid,'-','') 
FROM bronze.erp_loc_a101
)

-- ====================================
-- trim and combine fistname and lastname
-- since names as null not combine

SELECT
cst_firstname,
cst_lastname
--concat_ws(' ',btrim(cst_firstname),btrim(cst_lastname)) AS cst_name
FROM bronze.crm_cust_info
WHERE cst_firstname IS NULL or cst_lastname IS NULL

-- =======================================
-- normalize gender
SELECT 
cst_gndr,
count(*)
FROM bronze.crm_cust_info
GROUP BY cst_gndr

SELECT 
cst_gndr,
CASE
    WHEN upper(btrim(cst_gndr)) = 'M' THEN 'Male'
    WHEN upper(btrim(cst_gndr)) = 'F' THEN 'Female'
    ELSE 'N/A'
END cst_gndr1

FROM bronze.crm_cust_info

--=====================================
-- marital status
SELECT 
cst_marital_status,
count(*)
FROM bronze.crm_cust_info
GROUP BY cst_marital_status

SELECT 
cst_marital_status,
CASE
    WHEN upper(btrim(cst_marital_status)) = 'M' THEN 'Married'
    WHEN upper(btrim(cst_gndr)) = 'S' THEN 'Single'
    ELSE 'N/A'
END cst_marital_status

FROM bronze.crm_cust_info

--===========================================
-- cst_create_date
SELECT
cst_create_date
FROM bronze.crm_cust_info
WHERE cst_create_date IS NULL

--============================================
-- QA for the sales details
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
FROM bronze.crm_sales_details


--===================================
-- check ord num

SELECT
btrim(sls_ord_num) AS sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num is NULL

--===================================
-- check prd key
SELECT
btrim(sls_prd_key) AS sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key is NULL
--===================================
-- cust id
SELECT
sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id IN(

    SELECT
    cst_id
    FROM bronze.crm_cust_info
)

--==================================
-- order dt | ship dt | due dt
SELECT
sls_order_dt,
sls_ship_dt,
sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR 
sls_order_dt > sls_due_dt OR 
sls_due_dt IS null OR 
sls_order_dt IS NULL OR 
sls_ship_dt IS NULL

--=================================
-- check sales = price * quantity
SELECT
sls_sales,
sls_price,
sls_quantity
FROM bronze.crm_sales_details
--WHERE sls_sales != sls_quantity * sls_price
WHERE sls_sales =0 or sls_sales IS NULL or sls_sales <0

SELECT
CASE
    WHEN sls_price IS NULL THEN abs(sls_sales)
    ELSE abs(sls_quantity) * abs(sls_price)
END sls_sales,
CASE
    WHEN sls_price <0 THEN abs(sls_price)
    WHEN sls_quantity =0 THEN 0
    ELSE round(abs(sls_sales) /abs(sls_quantity),2)
END sls_price,
sls_quantity
FROM bronze.crm_sales_details
