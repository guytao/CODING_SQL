-- the company has two main concerns.
-- 1. Is Magist a good fit for high-end tech products? 2. Are orders delivered on time?

USE magist;

-- 1. In relation to the products.
-- 1.1 What categories of tech products does Magist have?
SELECT
	pt.product_category_name_english, pt.product_category_name
FROM
	product_category_name_translation AS pt;
-- ANSWER: the TECH products are:
-- audio
-- consoles_games
-- informatica_acessorios
-- pc_gamer
-- pcs
-- telefonia
-- tablets_impressao_imagem

-- 1.2 How many products of these tech categories have been sold? What percentage does that represent from the overall?
-- Count the number of TECH products which were sold by product_category_name.
SELECT
	COUNT(oi.product_id) AS prodt_c, p.product_category_name
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem')
ORDER BY prodt_c DESC;
-- Count the total number of TECH products which were sold.

-- Creat TECH_IF categories. 
SELECT 
	p.product_category_name,
    CASE
		WHEN p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem') THEN 'TECH'
        ELSE 'NON_TECH'
	END AS 'TECH_IF'
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name;
    
SELECT
	COUNT(order_item_id)
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');

-- Count the total number of all the products which were sold.


SELECT
	COUNT(order_item_id)
FROM order_items;
-- ANSWER: the total number of all the TECH products is 14168. the percentage of TECH products which were sold is 14168 / 112650 = 12.6%

-- 1.3 What’s the average price of the products being sold?
SELECT
	AVG(price)
FROM
	order_items;
-- ANSWER: the average price of all the products being sold is 120.65.

-- 1.4 Are expensive tech products popular? 
SELECT
	price
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');
-- quantiles for price of TECH products
--     0%     25%     50%     75%    100% 
--    5.99   24.50   55.00  129.00 4099.99 
SELECT
	MIN(price), MAX(price)
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');

-- since the 25%_price is 24.5, the 75%_price is 129.0, I define the price of products into 3 categoris. 
-- expensive: > 129; normal: > 24.5; cheap: <= 24.5.
SELECT
	COUNT(*), COUNT(*)/14168,
    CASE
		WHEN price > 129 THEN 'expensive'
        WHEN price > 24.5 THEN 'normal'
        ELSE 'cheap'
	END AS 'price_category'
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem')
GROUP BY price_category;
-- ANSWER: the percentage of expensive 25.85%; normal 57.19%; cheap 16.96%. the popularity of expensive products is fair. 

SELECT
	COUNT(*), COUNT(*)/14168,
    CASE
		WHEN price > 129 THEN 'expensive'
        WHEN price > 24.5 THEN 'normal'
        ELSE 'cheap'
	END AS 'price_category'
FROM
	order_items oi
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem')
GROUP BY price_category;

-- 2. In relation to the sellers:
-- 2.1 How many months of data are included in the magist database?
SELECT
	YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
	orders
GROUP BY year_, month_
ORDER BY year_, month_;
-- ANSWER: 25 months of data are included in the magist databse. 

-- 2.2 How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT
	COUNT(DISTINCT seller_id)
FROM
	sellers;
-- 3095
SELECT
	COUNT(DISTINCT s.seller_id)
FROM
	sellers AS s
		JOIN
	order_items AS oi ON s.seller_id = oi.seller_id
		JOIN
	products AS p ON oi.product_id = p.product_id
WHERE 
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');
-- 415
SELECT 415/3095;
-- ANSWER: there are toally 3095 sellers, and 415 TECH sellers, the proportion of TECH sellers is 415/3095 = 13.41%.

-- 2.3 What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT
	SUM(payment_value)
FROM 
	order_payments;
-- total amount 16008872.139586091.

SELECT
	SUM(op.payment_value)
FROM
	order_payments op
		JOIN
	order_items oi ON op.order_id = oi.order_id
		JOIN
	products p ON oi.product_id = p.product_id
WHERE
	p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');
-- TECH amount 2619356.4055730924. 

-- 2.4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
SELECT
	SUM(op.payment_value), 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
	order_payments op
		JOIN
	orders o ON op.order_id = o.order_id
GROUP BY year_, month_
ORDER BY year_, month_;
-- ANSWER: All monthly income of all sellers caculated.

SELECT
	SUM(op.payment_value)/(25*3095)
FROM
	order_payments op;
-- ANSWER: Average monthly income of all sellers caculated: 206.8998014809188. 
	
SELECT
	SUM(op.payment_value), 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
	order_payments op
		JOIN
	orders o ON op.order_id = o.order_id
		JOIN
	order_items oi ON o.order_id = oi.order_id
		JOIN
	products p ON oi.product_id = p.product_id
WHERE 
p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem')
GROUP BY year_, month_
ORDER BY year_, month_;
-- ANSWER: all monthly income of TECH sellers caculated.

-- 2.4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
SELECT
	SUM(op.payment_value)/(25*3095)
FROM
	order_payments op;
-- ANSWER: Average monthly income of all sellers caculated: 206.8998014809188. 

SELECT
	SUM(op.payment_value)/(25*415)
FROM
	order_payments op
		JOIN
	orders o ON op.order_id = o.order_id
		JOIN
	order_items oi ON o.order_id = oi.order_id
		JOIN
	products p ON oi.product_id = p.product_id
WHERE 
p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');
-- ANSWER: Average monthly income of TECH sellers caculated: 252.47. 

SELECT
	SUM(op.payment_value)/(25),
    oi.seller_id
FROM
	order_payments op
		JOIN
	orders o ON op.order_id = o.order_id
		JOIN
	order_items oi ON o.order_id = oi.order_id
		JOIN
	products p ON oi.product_id = p.product_id
WHERE 
p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem')
GROUP BY 2;
-- ANSWER: Average monthly income of TECH sellers one by one.

-- 3. In relation to the delivery time:
-- 3.1 What’s the average time between the order being placed and the product being delivered?
SELECT 
	* 
FROM
	orders;
    
SELECT
	AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date))
FROM
	orders;
-- ANSWER: the average time between the order being placed and the product being delivered is 12.0960 Day.

-- 3.2 How many orders are delivered on time vs orders delivered with a delay?
-- select sum (case when acolumn >= 0 then 1 else 0 end) as positive,
--        sum (case when acolumn < 0 then 1 else 0 end) as negative
-- from table
SELECT
	SUM(CASE WHEN TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date) >= 0 THEN 1 ELSE 0 END) AS positive,
    SUM(CASE WHEN TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date) < 0 THEN 1 ELSE 0 END) AS negative
FROM
	orders;
-- ANSWER: ON time 89941, delay 6535. 

-- 3.3 Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT DISTINCT
	AVG(TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date)),
    COUNT(TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date)),
	pt.product_category_name_english,
    AVG(p.product_weight_g),
    AVG(p.product_length_cm),
    AVG(p.product_height_cm),
    AVG(p.product_width_cm)
FROM
	orders o 
		JOIN
	order_items oi ON o.order_id = oi.order_id
		JOIN
	products p ON oi.product_id = p.product_id
		JOIN
	product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date) < 0
GROUP BY 3
ORDER BY 2 DESC;
-- ANSWER: pattern for delayed orders calculated.
	
	
