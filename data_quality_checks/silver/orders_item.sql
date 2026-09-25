-- ================================= ORDER_ITEMS_DATA_QUALITY======================================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_items'
AND table_schema = 'silver'

-- compare the total_count of bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.order_items

UNION ALL

SELECT 
COUNT(*) AS row_count
FROM silver.order_items

-- null check in order_item_id

SELECT
order_item_id 
FROM silver.order_items
WHERE order_item_id IS NULL

-- Expects to have multiple occurrences in order_item_id

SELECT 
order_item_id,
COUNT(*) AS occurrences_count
FROM silver.order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1
ORDER BY occurrences_count DESC


-- duplicate check in order_item_id

SELECT 
order_id,
order_item_id,
COUNT(*) occurrences_count
FROM silver.order_items
GROUP BY order_id,order_item_id
HAVING COUNT(*) > 1


-- null check in shipping_limit_date 

SELECT 
shipping_limit_date
FROM silver.order_items
WHERE shipping_limit_date IS NULL


-- check relationship with purchase date in shipping_limit_date

SELECT 
oi.order_id,
oi.order_item_id,
oi.shipping_limit_date,
o.order_purchase_timestamp
FROM silver.order_items AS oi
INNER JOIN silver.orders AS o
ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp > oi.shipping_limit_date

-- check null or negative values in price

SELECT 
price
FROM silver.order_items
WHERE price <= '0' OR price IS NULL


-- check null or negative values in freight_value

SELECT 
freight_value
FROM silver.order_items
WHERE freight_value <= '0' OR freight_value IS NULL
