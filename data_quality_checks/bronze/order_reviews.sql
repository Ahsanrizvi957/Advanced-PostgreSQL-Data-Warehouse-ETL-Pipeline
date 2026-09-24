-- ====================== order_reviews data quality==========================

-- check the columns and idenfity the data types and nulls
  
SELECT 
column_name,
data_type,
is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'order_reviews'
AND table_schema = 'bronze'

-- identify the total_count
  
SELECT 
COUNT(*) AS row_count
FROM bronze.order_reviews
	
-- null check in review id

SELECT
review_id
FROM bronze.order_reviews
WHERE review_id IS NULL

-- Expects multiple occurrences in review id

SELECT
review_id,
count(*) AS occurrences
FROM bronze.order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC

-- null check in order id

SELECT
order_id
FROM bronze.order_reviews
WHERE order_id IS NULL

-- referential integrity check in order id

SELECT 
order_id
FROM bronze.order_reviews
WHERE order_id NOT IN (
	SELECT order_id
	FROM bronze.orders
)

-- null check in review score

SELECT 
review_score
FROM bronze.order_reviews
WHERE review_score IS NULL 


-- score range check in review_score

SELECT 
MIN(review_score) AS min_score,
MAX(review_score) AS max_score
FROM bronze.order_reviews

-- date range check in review_creation_date and review_answer_timestamp

SELECT 
MIN(review_creation_date) AS oldest,
MAX(review_creation_date) AS newest,
MIN(review_answer_timestamp) AS oldest,
MAX(review_answer_timestamp) AS newest
FROM bronze.order_reviews

-- null check in review_creation_date and review_answer_timestamp

SELECT 
review_creation_date,
review_answer_timestamp
FROM  bronze.order_reviews
WHERE review_creation_date IS NULL 
   OR review_answer_timestamp IS NULL

-- check invalid relationship of dates 

SELECT 
review_creation_date,
review_answer_timestamp      
FROM bronze.order_reviews
WHERE review_creation_date > review_answer_timestamp
