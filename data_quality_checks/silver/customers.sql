-- ================================= CUSTOMERS_DATA_QUALITY======================================


-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'customers'
AND table_schema = 'silver'

-- identify the total_count by bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.customers

UNION ALL

SELECT 
COUNT(*) AS row_count
FROM silver.customers

-- null check in silver.customers

SELECT 
*
FROM silver.customers
WHERE customer_id IS NULL
   OR customer_unique_id IS NULL
   OR customer_zip_code_prefix IS NULL
   OR customer_city IS NULL
   OR customer_state IS NULL
   
-- duplicate check in customer_id
  
SELECT 
customer_id,
COUNT(*) AS total_counts
FROM silver.customers
GROUP BY customer_id
HAVING COUNT(*) > 1 
