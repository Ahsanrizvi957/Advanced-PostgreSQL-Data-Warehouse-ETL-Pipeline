	-- ====================== products_data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'products'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.products

-- null check in product id

SELECT
product_id
FROM bronze.products
WHERE product_id IS NULL

--  duplicate check in product id

SELECT
product_id,
COUNT(*) AS occurrences
FROM bronze.products
GROUP BY product_id
HAVING COUNT(*) > 1

-- data standardization and consisitency check in product_category_name 

SELECT DISTINCT
product_category_name
FROM bronze.products

-- null and negative value check in product_name_lenght

SELECT 
product_name_lenght
FROM bronze.products
WHERE product_name_lenght = '0' OR product_name_lenght <='0' OR product_name_lenght IS NULL

-- length check in product_name_lenght

SELECT
MIN(product_name_lenght::int) AS min_lenght,
MAX(product_name_lenght::int) AS max_lenght
FROM bronze.products

-- null and negative value check in product_photos_qty

SELECT DISTINCT 
product_photos_qty
FROM bronze.products
WHERE product_photos_qty = '0' OR product_photos_qty <='0' OR product_photos_qty IS NULL

-- length check in product_photos_qty

SELECT
MIN(product_photos_qty::int) AS min_lenght,
MAX(product_photos_qty::int) AS max_lenght
FROM bronze.products

-- null and negative value check in product_weight_g

SELECT DISTINCT
product_weight_g
FROM bronze.products
WHERE product_weight_g = '0' OR product_weight_g <='0' OR product_weight_g IS NULL

-- length check in product_weight_g

SELECT
MIN(product_weight_g::int) AS min_lenght,
MAX(product_weight_g::int) AS max_lenght
FROM bronze.products


-- null and negative value check in product_length_cm

SELECT DISTINCT
product_length_cm
FROM bronze.products
WHERE product_length_cm = '0' OR product_length_cm <='0' OR product_length_cm IS NULL

-- length check in product_length_cm

SELECT
MIN(product_length_cm::int) AS min_lenght,
MAX(product_length_cm::int) AS max_lenght
FROM bronze.products


-- null and negative value check in product_height_cm

SELECT DISTINCT
product_height_cm
FROM bronze.products
WHERE product_height_cm = '0' OR product_height_cm <='0' OR product_height_cm IS NULL

-- length check in product_height_cm

SELECT
MIN(product_height_cm::int) AS min_lenght,
MAX(product_height_cm::int) AS max_lenght
FROM bronze.products

-- null and negative value check in product_width_cm

SELECT DISTINCT
product_width_cm
FROM bronze.products
WHERE product_width_cm = '0' OR product_width_cm <='0' OR product_width_cm IS NULL

-- length check in product_width_cm

SELECT
MIN(product_width_cm::int) AS min_lenght,
MAX(product_width_cm::int) AS max_lenght
FROM bronze.products

