-- ====================== order_payments data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_payments'
AND table_schema = 'silver'

-- compare the total_count of bronze and silver
  
SELECT 
COUNT(*) AS row_count
FROM bronze.order_payments

UNION ALL


SELECT 
COUNT(*) AS row_count
FROM silver.order_payments


-- null or negative value check in payment_sequential

SELECT 
payment_sequential
FROM silver.order_payments
WHERE payment_sequential <= '0' OR payment_sequential IS NULL

-- duplicate check in payment_sequential

SELECT
order_id,
payment_sequential,
COUNT(*) AS occurrences
FROM silver.order_payments
GROUP BY order_id,payment_sequential
HAVING COUNT(*) > 1

-- data standardization and consistency check in payment type

SELECT DISTINCT
payment_type
FROM silver.order_payments
