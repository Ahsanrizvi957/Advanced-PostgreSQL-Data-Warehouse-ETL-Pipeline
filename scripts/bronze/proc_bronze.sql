COPY bronze.customers
FROM 'C:/Users/ahsan/Downloads/Temp/olist_customers_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

COPY bronze.orders
FROM 'C:/Users/ahsan/Downloads/Temp/olist_orders_dataset.csv'
WITH (
	FORMAT CSV,
	HEADER TRUE,
	DELIMITER ',',
	QUOTE '"'
);
