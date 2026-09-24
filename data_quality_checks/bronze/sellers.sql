-- ====================== sellers data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'sellers'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.sellers
  
-- null and duplicate check in seller id

SELECT
seller_id,
COUNT(*) AS occurrences
FROM bronze.sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 OR NULL

-- null and length check in seller_zip_code_prefix

SELECT
seller_zip_code_prefix,
LENGTH(seller_zip_code_prefix)
FROM bronze.sellers
GROUP BY seller_zip_code_prefix
HAVING LENGTH(seller_zip_code_prefix) < 5 OR NULL

-- null and unwanted spaces check in seller city

SELECT 
seller_city
FROM bronze.sellers
WHERE seller_city != TRIM(seller_city) OR NULL

-- null and unwanted spaces check in seller city

SELECT DISTINCT 
seller_state
FROM bronze.sellers
WHERE seller_state != TRIM(seller_state) OR NULL
