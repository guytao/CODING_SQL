USE magist;

-- 1. How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!
SELECT
	COUNT(order_id)
FROM 
	orders;
-- 99441

-- 2. Are orders actually delivered?  
SELECT
	order_status, count(*)
FROM
	orders
GROUP BY order_status;

-- 3. Is Magist having user growth?
SELECT
	YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
	orders
GROUP BY year_, month_
ORDER BY year_, month_;

-- 4. How many products are there on the products table?  
SELECT
	COUNT(DISTINCT product_id) AS products_dount
FROM
	products;
-- 32951

-- 5. Which are the categories with most products?
SELECT
	product_category_name,
    COUNT(DISTINCT product_id) AS products_count
FROM 
	products
GROUP BY product_category_name
ORDER BY products_count DESC;

-- 6. How many of those products were present in actual transactions?
SELECT 
	COUNT(DISTINCT product_id)
FROM
	order_items;
    
-- 7. What’s the price for the most expensive and cheapest products?
SELECT
	MAX(price), MIN(price)
FROM
	order_items;
    
-- 8. What are the highest and lowest payment values?
SELECT 
	MAX(payment_value), MIN(payment_value)
FROM
	order_payments;
    

	

