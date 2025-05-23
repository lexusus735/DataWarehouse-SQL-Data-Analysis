
/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

Possible Errors: 
- ERROR >>  duplicate key value violates unique constraint "company_dim_pkey"
- ERROR >> could not open file "C:\Users\...\company_dim.csv" for reading: Permission denied

1. Drop the Database 
            DROP DATABASE IF EXISTS sql_course;
2. Repeat steps to create database and load table schemas
            - 1_create_database.sql
            - 2_create_tables.sql
3. Open pgAdmin
4. In Object Explorer (left-hand pane), navigate to `sql_course` database
5. Right-click `sql_course` and select `PSQL Tool`
            - This opens a terminal window to write the following code
6. Get the absolute file path of your csv files
            1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
7. Paste the following into `PSQL Tool`, (with the CORRECT file path)
*/

-- NOTE: This has been updated from the video to fix issues with encoding
-- source erp : date type does not accept '0'

\COPY bronze.erp_cust_az12 FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY bronze.erp_loc_a101 FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY bronze.erp_px_cat_g1v2 FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- source crm

\COPY bronze.crm_cust_info FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY bronze.crm_prd_info FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY bronze.crm_sales_details FROM 'C:/Users/jarju/Downloads/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

