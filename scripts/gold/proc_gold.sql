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

TRUNCATE gold.dim_products;
INSERT INTO gold.dim_products(
product_id,
product_category,
product_weight,
product_length,
product_height,
product_width

)
SELECT
p.product_id,
pc.product_category_name_english AS product_category,
p.product_weight_g AS product_weight,
p.product_length_cm AS product_length,
p.product_height_cm AS product_height,
p.product_width_cm AS product_width
FROM silver.products AS p
LEFT JOIN silver.products_category AS pc
ON p.product_category_name = pc.product_category_name
