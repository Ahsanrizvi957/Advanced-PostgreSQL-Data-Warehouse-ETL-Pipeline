/*
===========================================================================================
DDL script: Create gold Tables
============================================================================================
Script Purpose: This scripts create tables in the gold Schema,Dropping existing tables if
they already exists.
*/

DROP TABLE IF EXISTS gold.dim_customers;
CREATE TABLE gold.dim_customers(
	
	customer_key			 BIGINT	GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id              VARCHAR(50) UNIQUE NOT NULL,
	customer_unique_id       VARCHAR(50) NOT NULL,
	customer_zip_code_prefix VARCHAR(5)  NOT NULL,
	customer_city 			 VARCHAR(50) NOT NULL,
	customer_state 			 CHAR(2)     NOT NULL
);

DROP TABLE IF EXISTS gold.dim_products;
CREATE TABLE gold.dim_products(
	
	product_key			     BIGINT	GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id               VARCHAR(50) UNIQUE NOT NULL,
	product_category         VARCHAR(50),
	product_weight 			 INTEGER,
	product_length 			 INTEGER,
	product_height 			 INTEGER,
	product_width  			 INTEGER 
);

DROP TABLE IF EXISTS gold.dim_sellers;
CREATE TABLE gold.dim_sellers (
    seller_key 				BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id 				VARCHAR(50) NOT NULL,
    seller_zip_code_prefix  VARCHAR(5),
    seller_city             VARCHAR(50),
    seller_state            VARCHAR(2)
);
DROP TABLE IF EXISTS gold.fact_order_items;
CREATE TABLE gold.fact_order_items(
	
	order_id  	        VARCHAR(50) NOT NULL,
	order_item_id       INTEGER NOT NULL,
	customer_key        BIGINT NOT NULL,
	product_key	        BIGINT NOT NULL,
	seller_key          BIGINT NOT NULL,
	price 		        NUMERIC(12,2),
	freight_value       NUMERIC(12,2),
	shipping_limit_date DATE,

	CONSTRAINT pk_fact_order_items
	PRIMARY KEY(order_id, order_item_id),

	CONSTRAINT fk_fact_customers
	FOREIGN KEY (customer_key)
	REFERENCES gold.dim_customers (customer_key),

	CONSTRAINT fk_fact_products
	FOREIGN KEY (product_key)
	REFERENCES gold.dim_products (product_key),

	
	CONSTRAINT fk_fact_seller
	FOREIGN KEY (seller_key)
	REFERENCES gold.dim_sellers (seller_key)	
);

DROP TABLE IF EXISTS gold.fact_order_payments;
CREATE TABLE gold.fact_order_payments(

order_id 			 VARCHAR(50) NOT NULL,
payment_sequential   SMALLINT NOT NULL,
customer_key 		 BIGINT NOT NULL,
payment_type 		 VARCHAR (20),
payment_installments INTEGER,
payment_value  		 NUMERIC(12,2),
	

	CONSTRAINT pk_fact_order_payments
	PRIMARY KEY(order_id, payment_sequential),

	CONSTRAINT fk_fact_customers
	FOREIGN KEY (customer_key)
	REFERENCES gold.dim_customers (customer_key)

	
);
