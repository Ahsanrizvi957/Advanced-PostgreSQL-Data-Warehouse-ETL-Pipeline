TRUNCATE gold.dim_customers;
INSERT INTO gold.dim_customers(
customer_id,
customer_unique_id,
customer_zip_code_prefix,
customer_city,
customer_state

)
SELECT
customer_id,
customer_unique_id,
customer_zip_code_prefix,
customer_city,
customer_state
FROM silver.customers;
