-- ====================== order_payments data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_payments'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.order_payments

-- null check in order id

SELECT
order_id
FROM bronze.order_payments
WHERE order_id IS NULL

-- referential integrity check in order id

SELECT
order_id
FROM bronze.order_payments
WHERE order_id NOT IN(
	SELECT order_id 
	FROM bronze.orders
)


-- Expects multiple occurrences in order id

SELECT
order_id,
COUNT(*) AS occurrences
FROM bronze.order_payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC

-- null or negative value check in payment_sequential

SELECT 
payment_sequential
FROM bronze.order_payments
WHERE payment_sequential <= '0' OR payment_sequential IS NULL

-- duplicate check in payment_sequential

SELECT
order_id,
payment_sequential,
COUNT(*) AS occurrences
FROM bronze.order_payments
GROUP BY order_id,payment_sequential
HAVING COUNT(*) < 1

-- data standardization and consistency check in payment type

SELECT DISTINCT
payment_type
FROM bronze.order_payments

-- installment range check in payment_installlments

SELECT
MIN(payment_installments) AS low,
MAX(payment_installments) AS high
FROM bronze.order_payments

-- null or negative value check in payment installments

SELECT
payment_installments
FROM bronze.order_payments
WHERE payment_installments <= '0' OR payment_installments IS NULL

-- null or negative value check in payment value

SELECT
payment_value
FROM bronze.order_payments
WHERE payment_value <= '0' OR payment_value IS NULL

-- invalid payments check in payment_value

SELECT
MIN(payment_value) AS low,
MAX(payment_value) AS high
FROM bronze.order_payments











