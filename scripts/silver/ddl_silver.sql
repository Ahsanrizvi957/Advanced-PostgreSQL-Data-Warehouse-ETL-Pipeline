/*
===========================================================================================
DDL script: Create silver Tables
============================================================================================
Script Purpose: This scripts create tables in the silver Schema,Dropping existing tables if
they already exists.
*/

DROP TABLE IF EXISTS silver.customers;
CREATE TABLE silver.customers(

	customer_id              VARCHAR(50) NOT NULL,
	customer_unique_id       VARCHAR(50) NOT NULL,
	customer_zip_code_prefix VARCHAR(5)  NOT NULL,
	customer_city 			 VARCHAR(50) NOT NULL,
	customer_state 			 CHAR(2)     NOT NULL
);

DROP TABLE IF EXISTS silver.orders;
CREATE TABLE silver.orders(

	order_id 					  VARCHAR (50) NOT NULL,
	customer_id 				  VARCHAR (50) NOT NULL,
	order_status 				  CHAR (20),
	order_purchase_timestamp  	  TIMESTAMP,
	order_approved_at 			  TIMESTAMP,
	order_delivered_carrier_date  TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date DATE
	
);

DROP TABLE IF EXISTS silver.order_items;
CREATE TABLE silver.order_items(

order_id 			VARCHAR(50),
order_item_id 		SMALLINT NOT NULL,
product_id 			VARCHAR(50),
seller_id 			VARCHAR(50),
shipping_limit_date TIMESTAMP,
price 				NUMERIC (12,2),
freight_value 		NUMERIC (12,2)
);

DROP TABLE IF EXISTS silver.order_payments;
CREATE TABLE silver.order_payments(

order_id             VARCHAR(50),
payment_sequential   SMALLINT,
payment_type         CHAR(20),
payment_installments INTEGER,
payment_value		 NUMERIC (12,2)

)
DROP TABLE IF EXISTS silver.order_reviews;
CREATE TABLE silver.order_reviews(

review_id			    VARCHAR (50) NOT NULL,
order_id 				VARCHAR (50),
review_score 			INTEGER,
review_comment_title 	TEXT,
review_comment_message 	TEXT,
review_creation_date 	TIMESTAMP,
review_answer_timestamp TIMESTAMP
);

