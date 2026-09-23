-- ================================= CUSTOMERS_DATA_QUALITY======================================


-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'customers'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.customers


-- duplicate and null check in customer id

SELECT 
customer_id,
count(*) AS total_count
FROM bronze.customers
GROUP BY customer_id
HAVING count(*) > 1 OR NULL

-- duplicate and null check in customer_unique_id
  
SELECT 
customer_unique_id,
COUNT(*) AS total_counts
FROM bronze.customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1 OR NULL

-- lenght and null check in customer_zip_code_prefix
  
SELECT 
customer_zip_code_prefix,
LENGTH(customer_zip_code_prefix) AS len
FROM bronze.customers
GROUP BY customer_zip_code_prefix
HAVING LENGTH(customer_zip_code_prefix) < 5 OR NULL

--null and empty string check in customer city
  
SELECT 
customer_city
FROM bronze.customers
WHERE customer_city = '' OR customer_city IS NULL 

-- checking unwanted spaces in customer_city
  
SELECT 
customer_city
FROM bronze.customers
WHERE customer_city != TRIM(customer_city)


-- checking data standardizaton and consistency
  
SELECT DISTINCT
customer_state
FROM bronze.customers
