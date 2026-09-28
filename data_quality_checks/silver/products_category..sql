-- ====================== product_category data quality==========================

SELECT
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'products_category'
AND	  table_schema = 'silver'

-- referential integrity check in product category name

SELECT DISTINCT
p.product_category_name
FROM bronze.products AS p
LEFT JOIN silver.products_category AS pc
ON p.product_category_name = pc.product_category_name
WHERE p.product_category_name IS NOT NULL
AND pc.product_category_name IS NULL 
