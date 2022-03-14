/* Session 6 - Part:1: 03/07/2022 */
--List Customer's last names in City Charlotte and Aurora
SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION 
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

SELECT last_name
FROM sale.customer
WHERE city = 'Aurora' OR city = 'Charlotte'

SELECT last_name
FROM sale.customer
WHERE city IN ( 'Aurora' , 'Charlotte')
------------------------------------
--Write a query that returns customers who name is ‘Thomas’ or surname is ‘Thomas’. (Don't use 'OR')
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'
--------------------------------------
SELECT first_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL
SELECT last_name
FROM sale.customer
WHERE last_name = 'Thomas'
order by 1
----------------
-- Write a query that returns brands that have products for both 2018 and 2019.
SELECT  *
FROM product.brand
WHERE brand_id  IN (
	SELECT brand_id
	FROM product.product
	WHERE model_year = 2018
	INTERSECT
	SELECT brand_id
	FROM product.product
	WHERE model_year = 2019
	)
	--------------------------------------
-- Write a query that returns customers who have orders for both 2018, 2019, and 2020
SELECT *
FROM sale.customer
WHERE customer_id IN
		
		(SELECT customer_id
		FROM sale.orders
		WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
		INTERSECT
		SELECT customer_id
		FROM sale.orders
		WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31'
		INTERSECT
		SELECT customer_id
		FROM sale.orders
		WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'
		)


		SELECT customer_id
		FROM sale.orders
		WHERE DATEPART(yy,order_date ) = 2018

------------------------------------------------------

-- Write a query that returns brands that have a 2018 model product 
--but not a 2019 model product.

SELECt * FROM product.brand
WHERE brand_id IN (
		
		SELECT brand_id
		FROM product.product
		WHERE model_year = 2018
		EXCEPT
		SELECT brand_id
		FROM product.product
		WHERE model_year = 2019
		)
---------------------------------------------
-- Write a query that returns only products 
--ordered in 2019 (not ordered in other years).


SELECT product_name 
FROM product.product
WHERE product_id IN (
	
    SELECT product_id 
	FROM sale.orders A
		JOIN sale.order_item B ON A.order_id = B.order_id
	WHERE A.order_date BETWEEN '2019-01-01' AND '2019-12-31'
	EXCEPT
	    SELECT product_id
	FROM sale.orders A
		JOIN sale.order_item B ON A.order_id = B.order_id
	WHERE A.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
	)