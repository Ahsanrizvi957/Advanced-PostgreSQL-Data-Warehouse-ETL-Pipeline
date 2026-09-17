CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
	batch_start_time TIMESTAMP;
	batch_end_time 	 TIMESTAMP;
	start_time 		 TIMESTAMP;
	end_time 		 TIMESTAMP;

BEGIN

batch_start_time := clock_timestamp();

RAISE NOTICE '================================================';
RAISE NOTICE 'Loading bronze layer';
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


RAISE NOTICE '==================geolocation=====================';

start_time:= clock_timestamp();

TRUNCATE TABLE bronze.geolocation; 

COPY bronze.geolocation
FROM 'C:/Users/ahsan/Downloads/Temp/olist_geolocation_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);

end_time:= clock_timestamp();

RAISE NOTICE 'geolocation loading duration: % seconds',
			EXTRACT(EPOCH FROM(end_time - start_time));

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



batch_end_time := clock_timestamp();


RAISE NOTICE '================================================';
RAISE NOTICE 'Total load duration: % seconds',
			EXTRACT(EPOCH FROM(batch_end_time - batch_start_time));
RAISE NOTICE '================================================';

END $$;


CALL bronze.load_bronze()
