-- ====================== order_reviews data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_reviews'
AND table_schema = 'silver'

-- compare the total_count of bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.order_reviews

UNION ALL

SELECT 
COUNT(*) AS row_count
FROM silver.order_reviews
	
