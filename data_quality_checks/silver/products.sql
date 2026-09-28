	-- ====================== products_data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'products'
AND table_schema = 'silver'

-- comparing the total_count of bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.products

UNION ALL

SELECT 
COUNT(*) AS row_count
FROM silver.products

-- data standardization and consisitency check in product_category_name 

SELECT DISTINCT
product_category_name
FROM silver.products
