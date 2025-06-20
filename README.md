# Data Warehouse and Analytics Project
This project is a complete end-to-end data engineering and analytics solution that demonstrates how to build a scalable data warehouse using modern best practices. It follows the Medallion Architecture (Bronze → Silver → Gold) and focuses on SQL-based ETL, star schema modeling, and analytical reporting.


---
## Project Architecture

The solution is designed around a layered Medallion Architecture:

### 🔸 Bronze Layer: Raw Data Ingestion

* **Source**: Raw CSV files
* **Target**: PostgreSQL staging tables
* **Purpose**: Store untransformed, original data

### 🔹 Silver Layer: Data Transformation

* Data type enforcement, normalization, and column derivation
* Intermediate schema for reliable transformations

### 🟡 Gold Layer: Business-Ready Schema

* Star schema modeling: `fact_sales`, `dim_customer`, `dim_product`, `dim_date`
* Designed for reporting, dashboards, and stakeholder queries

> **Architecture Diagram**
> **Replace the placeholder below with your own diagram:**

![Data Architecture Diagram](diagrams/medallion-architecture-placeholder.png)

---

## Key Components

| Area                      | Description                                             |
| ------------------------- | ------------------------------------------------------- |
| **Data Architecture**     | Modern Medallion model (Bronze → Silver → Gold)         |
| **ETL Pipelines**         | SQL scripts for ingestion, transformation, and modeling |
| **Data Modeling**         | Star schema for analytical workloads                    |
| **Analytics & Reporting** | SQL-based business insights, KPIs, and trends           |


---

## sample SQL Analysis

> 📌 **Replace these with your actual queries and charts later**

### Time-Based Trends

```sql
-- Total Sales Over Time
SELECT order_date, SUM(sales_amount) AS total_sales
FROM fact_sales
GROUP BY order_date
ORDER BY order_date;
```

### Cumulative Metrics

```sql
-- Running Total of Sales
SELECT 
  order_date,
  SUM(sales_amount) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM fact_sales;
```

### Performance Insights

```sql
-- Current vs. Previous Year Sales
SELECT 
  year,
  SUM(sales_amount) AS current_year_sales,
  LAG(SUM(sales_amount)) OVER (ORDER BY year) AS previous_year_sales
FROM (
  SELECT EXTRACT(YEAR FROM order_date) AS year, sales_amount
  FROM fact_sales
) sub
GROUP BY year;
```

---

## Folder Structure

```
├── data/                    # Raw data files (CSV)
├── sql/
│   ├── ingestion/           # Load scripts for Bronze layer
│   ├── transformation/      # Cleaning scripts for Silver layer
│   ├── modeling/            # Star schema and Gold layer scripts
│   └── analysis/            # SQL queries for reports and KPIs
├── diagrams/                # (Placeholder) ERD / Architecture images
├── README.md                # Project overview
```

---

## Getting Started

### Prerequisites

* PostgreSQL installed
* SQL client (pgAdmin, DBeaver, etc.)
* Git

### Setup
```bash
git clone https://github.com/your-username/data-warehouse-analytics.git
cd data-warehouse-analytics
```
1. Ingest raw data using scripts in `sql/ingestion/`
2. Transform data using scripts in `sql/transformation/`
3. Model data into a star schema using `sql/modeling/`
4. Analyze trends and KPIs with queries from `sql/analysis/`

----
## Acknowledgements

Thanks to [CodeWithBaraa](https://www.youtube.com/@DataWithBaraa) for providing the base knowledge, tutorial guide and structure that inspired this project.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
