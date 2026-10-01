/*
=============================================================================
Script Purpose:
    This script performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		- It shows the load-duraton of each table along with the whole batch-duration.
		- It also has exception handling, if there is any error during the load process it tells the root cause.
		- It also has a separate audit table/log to track the pipeline status

Usage Example: CALL silver.load_silver();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$

DECLARE	
		v_batch_id         BIGINT; 
		v_batch_start_time TIMESTAMP;
		v_batch_end_time   TIMESTAMP;
		start_time 		   TIMESTAMP;
		end_time   		   TIMESTAMP;

		error_message	   TEXT;
		error_detail	   TEXT;
		error_hint		   TEXT;
		error_state 	   TEXT;

		
BEGIN
	RAISE NOTICE'============================================================';
	RAISE NOTICE'Loading silver layer';
	RAISE NOTICE'============================================================';

-- capture batch start time	

v_batch_id := nextval('etl.batch_id_seq');

v_batch_start_time := clock_timestamp();

-- inserting batch information in the audit table

INSERT INTO etl.batch_audit(
    batch_id,
    layer,
    batch_start_time,
    batch_end_time,
    status
)
VALUES (
    v_batch_id,
    'silver',
    v_batch_start_time,
    NULL,
    'RUNNING'
);

RAISE NOTICE 'Silver batch ID: %', v_batch_id;

RAISE NOTICE'==========================customers================================';

start_time := clock_timestamp();

TRUNCATE silver.customers;

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
FROM bronze.customers;
end_time := clock_timestamp();

RAISE NOTICE'customers loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================orders=================================';

start_time := clock_timestamp();

TRUNCATE silver.orders;

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

end_time := clock_timestamp();

RAISE NOTICE 'orders loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================orders_items===========================';

start_time := clock_timestamp();

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
FROM bronze.order_items;

end_time := clock_timestamp();

RAISE NOTICE 'order_items loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================orders_payments========================';

start_time := clock_timestamp();

TRUNCATE silver.order_payments;

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
FROM bronze.order_payments;

end_time := clock_timestamp();

RAISE NOTICE 'order_payments loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================orders_reviews=========================';

start_time := clock_timestamp();

TRUNCATE silver.order_reviews;

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
FROM bronze.order_reviews;

end_time := clock_timestamp();

RAISE NOTICE 'order_payments loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================products==============================';

start_time := clock_timestamp();

TRUNCATE silver.products;

INSERT INTO silver.products(

	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,		   
	product_width_cm 		   
)

SELECT 
	product_id::VARCHAR(50),
	CASE 
		WHEN product_category_name IS NULL THEN 'n/a' -- replacing null with n/a
		ELSE product_category_name::VARCHAR(50)
	END AS product_category_name,
	product_name_lenght::INTEGER,
	product_description_lenght::INTEGER,
	product_photos_qty::SMALLINT,
	product_weight_g::INTEGER,
	product_length_cm::INTEGER,
	product_height_cm::INTEGER,		   
	product_width_cm::INTEGER 		   
FROM bronze.products;

end_time := clock_timestamp();

RAISE NOTICE 'products loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'=======================products_category=========================';

start_time := clock_timestamp();

TRUNCATE silver.products_category;

INSERT INTO silver.products_category(
	
	product_category_name,
	product_category_name_english 

)
SELECT
	product_category_name,
	product_category_name_english 
FROM bronze.products_category;

end_time := clock_timestamp();

RAISE NOTICE 'products_category loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE'==========================sellers================================';

start_time := clock_timestamp();

TRUNCATE silver.sellers;
INSERT INTO silver.sellers(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
SELECT
	seller_id::VARCHAR(50),
	seller_zip_code_prefix::VARCHAR(5),
	seller_city::CHAR(20),
	seller_state::CHAR(2)
FROM bronze.sellers;

end_time := clock_timestamp();

RAISE NOTICE 'sellers loading duration: % seconds',
EXTRACT(EPOCH FROM(end_time - start_time));

-- capture batch end time
v_batch_end_time := clock_timestamp();

-- updating the batch audit table

UPDATE etl.batch_audit
SET
    batch_end_time = v_batch_end_time,
    status = 'success'
WHERE batch_id = v_batch_id
  AND layer = 'silver';

RAISE NOTICE '=======================================================';
RAISE NOTICE 'total load duration: % seconds',
EXTRACT(EPOCH FROM(v_batch_end_time - v_batch_start_time));
RAISE NOTICE '=======================================================';

--==============================EXCEPTION=============================

EXCEPTION
		WHEN OTHERS THEN
						GET STACKED DIAGNOSTICS
						
						error_message = MESSAGE_TEXT,
						error_detail  = PG_EXCEPTION_DETAIL,
						error_hint    = PG_EXCEPTION_HINT,
						error_state   = RETURNED_SQLSTATE;

RAISE NOTICE'========================================================';
RAISE NOTICE 'ERROR OCCURRED DURING LOADING SILVER';
RAISE NOTICE'========================================================';

RAISE NOTICE 'error message: %', error_message;
RAISE NOTICE 'error detail: %', error_detail;
RAISE NOTICE 'error hint: %', error_hint;
RAISE NOTICE 'error state: %', error_state;

RAISE NOTICE'========================================================';
RAISE;

END $$;
