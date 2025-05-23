
-- create the table objects in the bronze schema| STATE SOURCE IN NAMING
-- source crm
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date DATE
);
CREATE TABLE bronze.crm_prd_info (
    prd_id         INT,
    prd_key        VARCHAR(50),
    prd_nm         VARCHAR(100),
    prd_cost       NUMERIC(10, 2),
    prd_line       VARCHAR(50),
    prd_start_dt   DATE,
    prd_end_dt     DATE
);
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num    VARCHAR(50),
    sls_prd_key    VARCHAR(50),
    sls_cust_id    INT,
    sls_order_dt   DATE,
    sls_ship_dt    DATE,
    sls_due_dt     DATE,
    sls_sales      NUMERIC(10, 2),
    sls_quantity   INT,
    sls_price      NUMERIC(10, 2)
);

-- SOURCE ERP
CREATE TABLE bronze.erp_cust_az12 (
    cid     VARCHAR(50),
    bdate   DATE,
    gen     VARCHAR(50)
);

CREATE TABLE bronze.erp_loc_a101 (
    cid     VARCHAR(50),
    cntry   VARCHAR(50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(100),
    subcat       VARCHAR(100),
    maintenance  BOOLEAN
);




