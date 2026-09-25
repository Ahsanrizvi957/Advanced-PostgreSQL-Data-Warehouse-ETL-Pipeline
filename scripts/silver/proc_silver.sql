INSERT INTO silver.customers(

	customer_id,              
	customer_unique_id,       
	customer_zip_code_prefix, 
	customer_city, 			 
	customer_state 			 
)
SELECT 
customer_id::VARCHAR (50), -- converting data type
customer_unique_id::VARCHAR (50),
customer_zip_code_prefix::VARCHAR (5),
customer_city::VARCHAR (50),
customer_state::VARCHAR (2)
FROM bronze.customers

TRUNCATE TABLE silver.orders;
INSERT INTO silver.orders(

order_id,
customer_id,
order_status,
order_purchase_timestamp,
order_approved_at,
order_delivered_carrier_date,
order_delivered_customer_date,
order_estimated_delivery_date

)
SELECT
order_id,
customer_id,
order_status,
order_purchase_timestamp::TIMESTAMP, -- converting data type
order_approved_at::TIMESTAMP,
order_delivered_carrier_date::TIMESTAMP,
order_delivered_customer_date::TIMESTAMP,
order_estimated_delivery_date::DATE 
FROM bronze.orders;

TRUNCATE TABLE silver.order_items;
INSERT INTO silver.order_items(

order_id,
order_item_id,
product_id,
seller_id,
shipping_limit_date,
price,
freight_value
)
SELECT
order_id::varchar(50), -- converting data type
order_item_id::smallint,
product_id::varchar(50),
seller_id::varchar(50),
shipping_limit_date::TIMESTAMP,
price::NUMERIC,
freight_value::NUMERIC
FROM bronze.order_items

INSERT INTO silver.order_payments(
order_id,
payment_sequential,
payment_type,
payment_installments,
payment_value

)
SELECT
order_id::VARCHAR(50),
payment_sequential::SMALLINT,
payment_type::CHAR(20),
payment_installments::INTEGER,
payment_value::NUMERIC 
FROM bronze.order_payments

INSERT INTO silver.order_reviews(

review_id,
order_id,
review_score,
review_comment_title,
review_comment_message,
review_creation_date,
review_answer_timestamp 

)
SELECT
review_id::VARCHAR (50), -- converting data types
order_id::VARCHAR (50),
review_score::INTEGER,
review_comment_title::TEXT,
review_comment_message::TEXT,
review_creation_date::TIMESTAMP,
review_answer_timestamp::TIMESTAMP
FROM bronze.order_reviews

