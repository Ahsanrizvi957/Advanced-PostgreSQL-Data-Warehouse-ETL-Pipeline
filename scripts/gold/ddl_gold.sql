DROP TABLE IF EXISTS gold.dim_customers;
CREATE TABLE gold.dim_customers(
	
	customer_key			 BIGINT	GENERATED ALWAYS AS IDENTITY,
	customer_id              VARCHAR(50) UNIQUE NOT NULL,
	customer_unique_id       VARCHAR(50) NOT NULL,
	customer_zip_code_prefix VARCHAR(5)  NOT NULL,
	customer_city 			 VARCHAR(50) NOT NULL,
	customer_state 			 CHAR(2)     NOT NULL
);

DROP TABLE IF EXISTS gold.dim_products;
CREATE TABLE gold.dim_products(
	
	product_key			     BIGINT	GENERATED ALWAYS AS IDENTITY,
	product_id               VARCHAR(50) UNIQUE NOT NULL,
	product_category         VARCHAR(50),
	product_weight 			 INTEGER,
	product_length 			 INTEGER,
	product_height 			 INTEGER,
	product_width  			 INTEGER 
);

DROP TABLE IF EXISTS gold.dim_sellers;
CREATE TABLE gold.dim_sellers (
    seller_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id VARCHAR(50) NOT NULL,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(50),
    seller_state VARCHAR(2)
);
