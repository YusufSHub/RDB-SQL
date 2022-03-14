/* SEssion: 7: PART 1*/
--Using sub query in select statement
SELECT AVG (list_price)
FROM [sale].[order_item]

SELECT list_price -(SELECT AVG (list_price)FROM [sale].[order_item]) 
FROM [sale].[order_item]

select top 10 order_id
FROM sale.orders


--select order_id, (select top 10 order_id
--FROM sale.orders)
--FROM [sale].[order_item]

-- average price for each category
SELECT Y.product_name, Y.list_price, (Y.list_price - X.Avg_listPrice) as diff
FROM product.product Y JOIN 
	(   SELECT A.category_id, AVG(B.list_price) as Avg_listPrice
		FROM product.category A JOIN product.product B
	    ON A.category_id = B.category_id
		GROUP BY A.category_id) X
ON X.category_id = Y.category_id

--Can you write this query using joins

--Write a query that returns the total list price by each order ids.

SELECT DISTINCT order_id ,
		(SELECT SUM(list_price)
			FROM [sale].[order_item] A
			WHERE A.order_id = B.order_id)
FROM  [sale].[order_item] B

select * from 
[sale].[order_item]
where order_id = 1

SELECT SUM(list_price)
FROM [sale].[order_item]

--Bring all the staff from the store that Davis Thomas works
-- first lets find what store Davis Thomas works for
SELECT first_name, last_name, store_id
FROM sale.staff
WHERE store_id =
		(SELECT store_id
		FROM [sale].[staff]
		WHERE first_name = 'Davis'
		AND last_name = 'Thomas')

-- List the staff that Charles Cussona is the manager of.
---First lets find Charle's staff_id

SELECT staff_id
FROM sale.staff
WHERE first_name = 'Charles' AND last_name = 'Cussona'

select * from sale.staff

SELECT first_name, last_name
FROM sale.staff
WHERE manager_id = (SELECT staff_id
					FROM sale.staff
					WHERE first_name = 'Charles' AND last_name = 'Cussona')

					-- Write a query that returns customers in 
					--the city where the 'The BFLO Store' store is located.
  SELECT first_name,last_name, city
  FROM sale.customer
  WHERE city =(
					SELECT city
					FROM [sale].[store]
					WHERE [store_name] = 'The BFLO Store')

--List bikes that are more expensive than the 
--''Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' bike.
SELECT product_id, product_name , model_year, list_price
FROM product.product
WHERE list_price > (SELECT list_price
					FROM product.product
					WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')

-- List customers whose order dates are before Hassan Pope.
-- First lets find Hassan's order date
SELECT cust.first_name, cust.last_name
FROM sale.customer cust JOIN sale.orders ord ON cust.customer_id = ord.customer_id
WHERE order_date <
(SELECT order_date
FROM sale.orders A JOIN sale.customer B ON A.customer_id = B.customer_id
WHERE B.first_name = 'Hassan'
AND B.last_name = 'Pope')

-- List all customers who orders on the same dates as Laurel Goldammer.
--First find order dates for all orders placed by Laurel Goldammer
SELECT cust.first_name, cust.last_name
FROM sale.orders ord JOIN sale.customer cust ON ord.customer_id = cust.customer_id
WHERE order_date IN
(SELECT order_date
FROM [sale].[orders] A JOIN [sale].[customer] B on A.customer_id = B.customer_id
WHERE B.first_name = 'Laurel' AND B.last_name = 'Goldammer')

--List products other than of  
--“Game”, “gps”, or “Home Theater” categories and made in 2021.
SELECT A.product_id, A.product_name
FROM product.product A 
WHERE category_id NOT IN (
					SELECT category_id
					FROM product.category
					WHERE category_name IN ('Game', 'GPS', 'Home Theater'))












