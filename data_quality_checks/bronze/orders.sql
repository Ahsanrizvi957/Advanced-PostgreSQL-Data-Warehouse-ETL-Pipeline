-- ======================orders data quality==========================

SELECT * FROM bronze.orders

-- null check in order id

SELECT 
order_id
FROM bronze.orders
WHERE order_id IS NULL;

-- duplicate check in order id

SELECT 
order_id,
COUNT(*) AS total_rows
FROM bronze.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- null check in customer id

SELECT 
customer_id
FROM bronze.orders
WHERE customer_id IS NULL;

-- duplicate check in customer id

SELECT 
customer_id,
COUNT(*) AS total_rows
FROM bronze.orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- referential integrity check in customer id

SELECT 
customer_id
FROM bronze.orders
WHERE customer_id  NOT IN
(SELECT customer_id FROM bronze.customers)

-- unique order status check in order status

SELECT DISTINCT 
order_status AS unique_status
FROM bronze.orders

-- unwanted spaces check in order status

SELECT DISTINCT 
order_status 
FROM bronze.orders
WHERE order_status != TRIM(order_status)

-- null count for all timestamp columns 

SELECT 
COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS order_purchase_timestamp,
COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS order_approved_at,
COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL) AS order_delivered_carrier_date,
COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS order_delivered_customer_date,
COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS order_estimated_delivery_date 
FROM bronze.orders;

-- date range check for all timestamp

SELECT
MIN(order_purchase_timestamp) AS min_purchase,
MAX(order_purchase_timestamp) AS max_purchase,

MIN(order_approved_at) AS min_approval,
MAX(order_approved_at) AS max_approval,

MIN(order_delivered_carrier_date) AS min_carrier_delivery,
MAX(order_delivered_carrier_date) AS max_carrier_delivery,

MIN(order_delivered_customer_date) AS min_customer_delivery,
MAX(order_delivered_customer_date) AS max_customer_delivery,

MIN(order_estimated_delivery_date) AS min_estimated_delivery,
MAX(order_estimated_delivery_date) AS max_estimated_delivery
FROM bronze.orders

-- invalid date ordering check 

SELECT 
*
FROM bronze.orders
WHERE order_approved_at < order_purchase_timestamp

SELECT 
*
FROM bronze.orders
WHERE order_delivered_carrier_date < order_approved_at; 

SELECT 
*
FROM bronze.orders
WHERE order_delivered_customer_date < order_delivered_carrier_date 

SELECT 
*
FROM bronze.orders
WHERE order_delivered_customer_date < order_purchase_timestamp


SELECT 
*
FROM bronze.orders
WHERE order_estimated_delivery_date < order_purchase_timestamp

-- checking the orders based on order status

SELECT 
order_status,
count(*) AS order_count
FROM bronze.orders
GROUP BY order_status
ORDER BY order_count DESC

-- data integrity check

SELECT 
*
FROM bronze.orders
WHERE order_status = 'delivered'
AND  order_delivered_customer_date IS NULL
