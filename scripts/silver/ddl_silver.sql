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
