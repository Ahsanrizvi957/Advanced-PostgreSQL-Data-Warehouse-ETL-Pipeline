DROP TABLE IF EXISTS gold.dim_customers;
CREATE TABLE gold.dim_customers(
	
	customer_key			       BIGINT	GENERATED ALWAYS AS IDENTITY,
	customer_id              VARCHAR(50) UNIQUE NOT NULL,
	customer_unique_id       VARCHAR(50) NOT NULL,
	customer_zip_code_prefix VARCHAR(5)  NOT NULL,
	customer_city 			     VARCHAR(50) NOT NULL,
	customer_state 			     CHAR(2)     NOT NULL
);
