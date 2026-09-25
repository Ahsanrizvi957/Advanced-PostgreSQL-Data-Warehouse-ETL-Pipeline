-- ================================= ORDERS_DATA_QUALITY======================================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'orders'
AND table_schema = 'silver'

-- compare the total_count of bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.orders

UNION ALL

SELECT 
COUNT(*) AS row_count
FROM silver.orders
  
-- null check in order id

SELECT 
order_id
FROM silver.orders
WHERE order_id IS NULL;

-- duplicate check in order id

SELECT 
order_id,
COUNT(*) AS total_rows
FROM silver.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- check for 8 null delivery dates

SELECT 
COUNT(*)
FROM silver.orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NULL;

-- check for 23 timestamp inconsistencies

SELECT 
COUNT(*)
FROM silver.orders
WHERE order_delivered_customer_date < order_delivered_carrier_date 
