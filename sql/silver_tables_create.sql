
-- create the tables to load all the transformation data
-- keep record of the creation date for metadata reference


-- create the table objects in the silver schema| STATE SOURCE IN NAMING
-- source crm
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE silver.crm_prd_info (
    prd_id         INT,
    prd_key        VARCHAR(50),
    prd_nm         VARCHAR(100),
    prd_cost       NUMERIC(10, 2),
    prd_line       VARCHAR(50),
    prd_start_dt   DATE,
    prd_end_dt     DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
CREATE TABLE silver.crm_sales_details (
    sls_ord_num    VARCHAR(50),
    sls_prd_key    VARCHAR(50),
    sls_cust_id    INT,
    sls_order_dt   DATE,
    sls_ship_dt    DATE,
    sls_due_dt     DATE,
    sls_sales      NUMERIC(10, 2),
    sls_quantity   INT,
    sls_price      NUMERIC(10, 2),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- SOURCE ERP
CREATE TABLE silver.erp_cust_az12 (
    cid     VARCHAR(50),
    bdate   DATE,
    gen     VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE silver.erp_loc_a101 (
    cid     VARCHAR(50),
    cntry   VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE silver.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(100),
    subcat       VARCHAR(100),
    maintenance  BOOLEAN,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);




