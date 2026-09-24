-- ====================== product_category data quality==========================

SELECT
*
FROM bronze.products_category


-- referential integrity check in product category name

SELECT DISTINCT
p.product_category_name
FROM bronze.products AS p
LEFT JOIN bronze.products_category AS pc
ON p.product_category_name = pc.product_category_name
WHERE p.product_category_name IS NOT NULL
AND pc.product_category_name IS NULL 

