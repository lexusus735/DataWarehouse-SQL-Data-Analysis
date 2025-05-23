
--================================
-- check cat g1v2
SELECT
btrim(id) AS id,
btrim(cat) AS cat,
btrim(subcat) AS subcat,
maintenance
FROM bronze.erp_px_cat_g1v2


--===============================
-- check all columns
SELECT
id
FROM bronze.erp_px_cat_g1v2
WHERE id IN (
    SELECT
    REPLACE(SUBSTRING(btrim(prd_key),1,5),'-','_')
    FROM bronze.crm_prd_info
)

SELECT
cat,
maintenance,
subcat
FROM bronze.erp_px_cat_g1v2
WHERE cat IS NULL or subcat IS NULL or maintenance IS NULL
--=====================================
-- check cust az12
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
WHERE bdate <=NOW()

--=====================================
-- check id uniqueness
SELECT
cid,
count(*) AS uniqueness_count
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING count(*) >1

--=====================================
SELECT
bdate,
EXTRACT(year from age(now(),bdate)) as cust_age
FROM bronze.erp_cust_az12
WHERE bdate <=NOW()
ORDER BY cust_age desc
--WHERE bdate IS NULL

--=====================================
-- normalize gneder
SELECT
btrim(gen),
count(*) AS uniqueness_count
FROM bronze.erp_cust_az12
GROUP BY gen
HAVING count(*) >1

SELECT
CASE
    WHEN upper(btrim(gen)) = 'M' THEN 'Male'
    WHEN upper(btrim(gen)) = 'F' THEN 'Female'
    WHEN upper(btrim(gen)) = '' THEN 'N/A'
    WHEN upper(btrim(gen)) IS NULL THEN 'N/A'
    ELSE btrim(gen)
END gen,
count(*) AS uniqueness_count
FROM bronze.erp_cust_az12
GROUP BY gen
HAVING count(*) >1

--=====================================
-- check cust location
SELECT
REPLACE(btrim(cid),'-','') AS cid,
CASE
    WHEN lower(btrim(cntry)) = 'de' THEN 'Germany'
    WHEN lower(btrim(cntry)) = 'us' THEN 'United States'
    WHEN lower(btrim(cntry)) = 'usa' THEN 'United States'
    WHEN lower(btrim(cntry)) IS NULL THEN 'N/A'
    ELSE cntry
END cntry
FROM bronze.erp_loc_a101

--====================================
--check id
SELECT
cid,
count(*) AS uniqueness_count
FROM bronze.erp_loc_a101
GROUP BY cid
HAVING count(*) >1

--==================================
-- check country
SELECT DISTINCT
btrim(cntry),
CASE
    WHEN lower(btrim(cntry)) = 'de' THEN 'Germany'
    WHEN lower(btrim(cntry)) = 'us' THEN 'United States'
    WHEN lower(btrim(cntry)) = 'usa' THEN 'United States'
    WHEN lower(btrim(cntry)) IS NULL THEN 'N/A'
    ELSE cntry
END cntry
FROM bronze.erp_loc_a101

SELECT
btrim(cntry) 
FROM bronze.erp_loc_a101
WHERE cntry IS NULL or cntry = ''