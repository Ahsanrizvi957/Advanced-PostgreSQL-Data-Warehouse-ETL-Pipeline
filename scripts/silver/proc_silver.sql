INSERT INTO silver.customers(

	customer_id,              
	customer_unique_id,       
	customer_zip_code_prefix, 
	customer_city, 			 
	customer_state 			 
)
SELECT 
customer_id::VARCHAR (50),
customer_unique_id::VARCHAR (50),
customer_zip_code_prefix::VARCHAR (5),
customer_city::VARCHAR (50),
customer_state::VARCHAR (2)
FROM bronze.customers
