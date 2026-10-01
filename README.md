# Olist Data Warehouse

This project is a PostgreSQL-based data warehouse built using the Olist e-commerce dataset. The goal was to transform raw CSV files containing customers, orders, products, sellers, payments, and other data into a structured model that can be used for reliable analysis. The project focuses on understanding the fundamentals of data engineering rather than relying on modern ETL tools.

The warehouse follows a **Medallion Architecture** with three layers: **Bronze, Silver, and Gold**. The Bronze layer stores the raw source data, the Silver layer applies data-type conversions, cleaning, and validation, and the Gold layer organizes the data into a dimensional model with customer, product, and seller dimensions and order-item and payment fact tables.

The ETL process was implemented using **SQL stored procedures**. The project includes data profiling, batch auditing, load-duration tracking, surrogate keys, primary and foreign keys, dependency-aware loading, and data-quality validation. The Gold layer was designed with a defined grain for each fact table to maintain accurate relationships and avoid incorrect aggregations.

The main purpose of this project was to strengthen practical SQL and data-engineering fundamentals by building the warehouse step by step and dealing with real data-quality and dependency issues along the way. More advanced orchestration and incremental-processing concepts can be explored in future projects.
