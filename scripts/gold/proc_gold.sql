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

TRUNCATE gold.dim_sellers;
INSERT INTO gold.dim_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM silver.sellers;

TRUNCATE gold.fact_order_items;
INSERT INTO gold.fact_order_items(

order_id,
order_item_id,
customer_key,
product_key,
seller_key,
price,
freight_value,
shipping_limit_date
)

SELECT
op.order_id,
op.order_item_id,
dm.customer_key,
dp.product_key,
ds.seller_key,
op.price,
op.freight_value,
op.shipping_limit_date::DATE
FROM silver.order_items AS op
LEFT JOIN silver.orders AS o
ON op.order_id = o.order_id
LEFT JOIN gold.dim_customers AS dm
ON dm.customer_id = o.customer_id
LEFT JOIN gold.dim_products AS dp
ON op.product_id = dp.product_id
LEFT JOIN gold.dim_sellers AS ds
ON op.seller_id = ds.seller_id

TRUNCATE gold.fact_order_payments;
INSERT INTO gold.fact_order_payments(

order_id,
payment_sequential,
customer_key,
payment_type,
payment_installments,
payment_value

)

SELECT
op.order_id,
op.payment_sequential,
dc.customer_key,
op.payment_type,
op.payment_installments,
op.payment_value
FROM silver.order_payments AS op
LEFT JOIN silver.orders AS o
ON op.order_id = o.order_id
LEFT JOIN gold.dim_customers AS dc
ON o.customer_id = dc.customer_id
