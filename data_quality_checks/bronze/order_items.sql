-- ================================= ORDER_ITEMS_DATA_QUALITY======================================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_items'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.customers

-- null check in order id

SELECT
order_id 
FROM bronze.order_items
WHERE order_id IS NULL

-- referential integrity check in order id

SELECT
order_id
FROM bronze.order_items
WHERE order_id NOT IN (	
	SELECT order_id
	FROM bronze.orders
)

-- null check in order_item_id

SELECT
order_item_id 
FROM bronze.order_items
WHERE order_item_id IS NULL

-- Expects to have multiple occurrences in order_item_id

SELECT 
order_item_id,
COUNT(*) AS occurrences_count
FROM bronze.order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1
ORDER BY occurrences_count DESC


-- duplicate check in order_item_id

SELECT 
order_id,
order_item_id,
COUNT(*) occurrences_count
FROM bronze.order_items
GROUP BY order_id,order_item_id
HAVING COUNT(*) > 1

-- null check in product_id

SELECT 
product_id
FROM bronze.order_items
WHERE product_id IS NULL

-- refertial integrity check in product_id

SELECT 
product_id
FROM bronze.order_items
WHERE product_id NOT IN (
	SELECT product_id
	FROM bronze.products
)


-- null check in seller_id

SELECT 
seller_id
FROM bronze.order_items
WHERE seller_id IS NULL

-- refertial integrity check in seller_id

SELECT 
seller_id
FROM bronze.order_items
WHERE seller_id NOT IN (
	SELECT seller_id
	FROM bronze.sellers
)


-- null check in shipping_limit_date 

SELECT 
shipping_limit_date
FROM bronze.order_items
WHERE shipping_limit_date IS NULL

-- date range check in shipping_limit_date

SELECT 
MIN(shipping_limit_date) AS earliest_dates,
MAX(shipping_limit_date) AS newest_dates
FROM bronze.order_items

-- check relationship with purchase date in shipping_limit_date

SELECT 
oi.order_id,
oi.order_item_id,
oi.shipping_limit_date,
o.order_purchase_timestamp
FROM bronze.order_items AS oi
INNER JOIN bronze.orders AS o
ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp > oi.shipping_limit_date

-- check null or negative values in price

SELECT 
price
FROM bronze.order_items
WHERE price <= '0' OR price IS NULL

-- check for unusual high values
SELECT 
MAX(price) AS max_price
FROM bronze.order_items

-- check null or negative values in freight_value

SELECT 
freight_value
FROM bronze.order_items
WHERE freight_value <= '0' OR freight_value IS NULL

-- check for unusual high values
SELECT 
MAX(freight_value) AS max_price
FROM bronze.order_items


