INSERT INTO silver.customers(

	customer_id,              
	customer_unique_id,       
	customer_zip_code_prefix, 
	customer_city, 			 
	customer_state 			 
)
SELECT 
customer_id::VARCHAR (50), -- converting text to varchar
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
order_purchase_timestamp::TIMESTAMP, -- converting text to timestamp
order_approved_at::TIMESTAMP,
order_delivered_carrier_date::TIMESTAMP,
order_delivered_customer_date::TIMESTAMP,
order_estimated_delivery_date::DATE --converting text to date
FROM bronze.orders;
