CREATE OR REPLACE PROCEDURE gold.load_gold()
LANGUAGE plpgsql
AS $$
DECLARE
	v_batch_id		   BIGINT;
	v_batch_start_time TIMESTAMP;
	v_batch_end_time   TIMESTAMP;
    start_time 		   TIMESTAMP;
    end_time           TIMESTAMP;
	
	error_message 	   TEXT;
	error_detail       TEXT;
	error_hint         TEXT;
	error_state        TEXT;


BEGIN

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Loading Gold Layer';
    RAISE NOTICE '========================================';

    -- =========================================
    --  TRUNCATE GOLD
    -- =========================================

    TRUNCATE TABLE
        gold.fact_order_items,
        gold.fact_order_payments,
        gold.dim_customers,
        gold.dim_products,
        gold.dim_sellers;

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
VALUES(

v_batch_id,
'gold',
v_batch_start_time,
NULL,
'Running'
);


RAISE NOTICE '===================dim_customer========================';
    
start_time := clock_timestamp();

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

end_time := clock_timestamp();

    RAISE NOTICE 'dim_customers load duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));


RAISE NOTICE '===================dim_products========================';
    
	start_time := clock_timestamp();

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
ON p.product_category_name = pc.product_category_name;

end_time := clock_timestamp();

    RAISE NOTICE 'dim_products load duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));


RAISE NOTICE '===================dim_sellers========================';

start_time := clock_timestamp();

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


end_time := clock_timestamp();

    RAISE NOTICE 'dim_sellers load duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));


RAISE NOTICE '===================fact_order_items========================';
	
start_time := clock_timestamp();

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
ON op.seller_id = ds.seller_id;

end_time := clock_timestamp();

    RAISE NOTICE 'fact_order_items load duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));


RAISE NOTICE '===================fact_order_payments========================';
   
start_time := clock_timestamp();

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
ON o.customer_id = dc.customer_id;

end_time := clock_timestamp();

    RAISE NOTICE 'fact_order_payments load duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

v_batch_end_time := clock_timestamp();

 	RAISE NOTICE '========================================';
    RAISE NOTICE 'Total load duration: % seconds',
        EXTRACT(EPOCH FROM (v_batch_end_time - v_batch_start_time));
    RAISE NOTICE '========================================';

--updating the batch audit table

UPDATE etl.batch_audit
SET 
	batch_end_time = v_batch_end_time,
	status = 'success'
WHERE batch_id = v_batch_id
AND layer = 'gold';

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

END $$;
