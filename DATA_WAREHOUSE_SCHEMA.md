## Data Warehouse Star Schema Documentation

This repository contains the schema design and documentation for a modern, analytics-ready **Star Schema** used in a Data Warehouse environment. This schema is designed to integrate CRM and ERP sources to provide clean, denormalized, and business-friendly datasets for BI tools, reporting, and analytics.

## Overview

This data dictionary features:
- Data integration across multiple systems (CRM & ERP)
- Star schema modeling with conformed dimensions
- Clean and readable SQL transformation logic
- Optimized for analytical performance and usability

---

## Schema Design

The star schema consists of the following core components:

- **Fact Table**: `fact_sales`
- **Dimension Tables**: `dim_product`, `dim_customer`
---

## Dimension: `gold.dim_product`

| Column Name           | Description                               | Source Column                |
|-----------------------|-------------------------------------------|------------------------------|
| `product_id`          | Unique identifier for the product          | `pf.prd_id`                  |
| `product_key`         | Internal surrogate product key             | `pf.prd_key`                 |
| `product_category_key`| Foreign key to category                    | `pf.cat_id`                  |
| `product_category`    | Product category name                      | `pcg.cat`                    |
| `product_subcategory` | Product subcategory                        | `pcg.subcat`                 |
| `product_name`        | Name of the product                        | `pf.prd_nm`                  |
| `product_line`        | Product line type                          | `pf.prd_line`                |
| `maintenance`         | Maintenance indicator                      | `pcg.maintenance`            |
| `product_cost`        | Cost to produce or procure the product     | `pf.prd_cost`                |
| `product_start_date`  | Start of product availability              | `pf.prd_start_dt`            |
| `product_end_date`    | End of product lifecycle                   | `pf.prd_end_dt`              |

> Business Rule: Only products with a non-null `prd_end_dt` are included to ensure data completeness.

---

## Dimension: `gold.dim_customer`

| Column Name            | Description                                | Transformation / Notes                  |
|------------------------|--------------------------------------------|------------------------------------------|
| `customer_id`          | Unique customer identifier                  | `cf.cst_id`                              |
| `customer_key`         | Internal customer key                       | `cf.cst_key`                             |
| `firstname`            | Customer first name                         | `cf.cst_firstname`                       |
| `lastname`             | Customer last name                          | `cf.cst_lastname`                        |
| `gender`               | Customer gender                             | Fallback logic: `cf.cst_gndr` or `ca.gen`|
| `marital_status`       | Marital status                              | `cf.cst_marital_status`                  |
| `country`              | Country of residence                        | `la.cntry`                               |
| `birthdate`            | Date of birth                               | `ca.bdate`                               |
| `age`                  | Age (pre-calculated)                        | `ca.cust_age`                            |
| `customer_created_date`| Date the customer was created               | `cf.cst_create_date`                     |

> Gender logic: Uses fallback from ERP if CRM value is `'N/A'`.

---

## Fact Table: `gold.fact_sales`

| Column Name     | Description                          | Source Column         |
|-----------------|--------------------------------------|------------------------|
| `order_number`  | Unique sales order number            | `sls_ord_num`          |
| `product_key`   | Foreign key to product dimension     | `sls_prd_key`          |
| `customer_id`   | Foreign key to customer dimension    | `sls_cust_id`          |
| `order_date`    | Order placement date                 | `sls_order_dt`         |
| `ship_date`     | Shipment date                        | `sls_ship_dt`          |
| `due_date`      | Expected delivery date               | `sls_due_dt`           |
| `sales_amount`  | Total sale amount                    | `sls_sales`            |
| `sales_quantity`| Quantity of products sold            | `sls_quantity`         |
| `sales_price`   | Unit price at time of sale           | `sls_price`            |

> Uses `DISTINCT` to ensure unique sales rows and ensure analytical correctness.

---

## Key Design Highlights

- **Clean Column Naming**: All fields are renamed to be descriptive and analytics-friendly.
- **Integrated Sources**: Combines CRM and ERP data with appropriate left joins and filters.
- **Business Rules Applied**: Handling of null values and fallback logic in gender fields.
- **Modular Views**: Each component is a reusable, modular SQL view.
- **Ready for BI Tools**: Easily connectable to Tableau, Power BI, or Looker.

---





