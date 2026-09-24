/*
===================================================================================================
Stored procedure: Load Bronze Layer(source -> bronze)
===================================================================================================
Script purpose: This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
- Truncate the bronze tables before loading the data
- Uses 'COPY' command to load the data from CSV files to bronze tables.
- It shows the load-duraton of each table along with the whole batch-duration.
- It also has exception handling, if there is any error during the load process it tells the root cause.
- It also has a separate audit table/log to track the pipeline status

Usage Example: CALL bronze.bronze_load();
===================================================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
	v_batch_start_time TIMESTAMP;
	v_batch_end_time   TIMESTAMP;
	start_time 		   TIMESTAMP;
	end_time 		   TIMESTAMP;
	
	error_message    TEXT;
	error_detail     TEXT;
	error_hint       TEXT;
	error_state      TEXT;
	
	v_batch_ID		 INT;

BEGIN

--      generate a unique batch id
v_batch_id:= nextval('bronze.batch_id_seq');

-- capture batch start time
v_batch_start_time := clock_timestamp();

-- storing the batch information into audit table
INSERT INTO bronze.batch_audit
(
	batch_id,
	batch_start_time,
	batch_end_time,
	status
)
VALUES
(
	v_batch_id,
	v_batch_start_time,
	NULL,
	'Running'
);

RAISE NOTICE '================================================';
RAISE NOTICE 'Loading bronze layer';
RAISE NOTICE 'batch ID: %',v_batch_id;
RAISE NOTICE '================================================';


RAISE NOTICE '==================customers=====================';

start_time := clock_timestamp();
	
TRUNCATE TABLE bronze.customers; 

COPY bronze.customers
FROM 'C:/Users/ahsan/Downloads/Temp/olist_customers_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'customers loading duration: % seconds',
	EXTRACT(EPOCH FROM (end_time - start_time));



RAISE NOTICE '==================order_items=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.order_items; 

COPY bronze.order_items
FROM 'C:/Users/ahsan/Downloads/Temp/olist_order_items_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'order_items loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE '==================order_payments=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.order_payments; 

COPY bronze.order_payments
FROM 'C:/Users/ahsan/Downloads/Temp/olist_order_payments_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();
RAISE NOTICE 'order_payments loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time -start_time));

RAISE NOTICE '==================order_reviews=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.order_reviews; 

COPY bronze.order_reviews
FROM 'C:/Users/ahsan/Downloads/Temp/olist_order_reviews_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();
RAISE NOTICE 'order_reviews loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE '==================orders=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.orders;

COPY bronze.orders
FROM 'C:/Users/ahsan/Downloads/Temp/olist_orders_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'orders loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE '==================products=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.products; 

COPY bronze.products
FROM 'C:/Users/ahsan/Downloads/Temp/olist_products_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'products loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));

RAISE NOTICE '==================sellers=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.sellers;

COPY bronze.sellers
FROM 'C:/Users/ahsan/Downloads/Temp/olist_sellers_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'sellers loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));
			
RAISE NOTICE '==================products_category=====================';

start_time := clock_timestamp();

TRUNCATE TABLE bronze.products_category; 

COPY bronze.products_category
FROM 'C:\Users\ahsan\Downloads\Temp\product_category_name_translation.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time := clock_timestamp();

RAISE NOTICE 'products_category loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));



v_batch_end_time := clock_timestamp();


RAISE NOTICE '================================================';
RAISE NOTICE 'Total load duration: % seconds',
			EXTRACT(EPOCH FROM(v_batch_end_time - v_batch_start_time));
RAISE NOTICE '================================================';

-- update the records in the audit table 
UPDATE bronze.batch_audit
SET 
	batch_end_time = v_batch_end_time,
	status = 'Success'
WHERE batch_id = v_batch_id;
	

--===========================EXCEPTION===========================;

EXCEPTION 
		WHEN OTHERS THEN

						 GET STACKED DIAGNOSTICS

						 error_message = MESSAGE_TEXT,
						 error_detail  = PG_EXCEPTION_DETAIL,
						 error_hint    = PG_EXCEPTION_HINT,
						 error_state   = RETURNED_SQLstate;

RAISE NOTICE '===================================================';
RAISE NOTICE 'ERROR OCCURED DURING LOADING BRONZE';
RAISE NOTICE '===================================================';


RAISE NOTICE 'Error_message: %', error_message;
RAISE NOTICE 'Error_detail: %', error_detail;
RAISE NOTICE 'Error_hint: %', error_hint;
RAISE NOTICE 'Error_state: %', error_state;

RAISE NOTICE '===================================================';
RAISE;

END $$;

