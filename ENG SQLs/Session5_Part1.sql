/* SEssion :5: 03/03/2022 */

SELECT product_id, COUNT(product_id)
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1

SELECT A.product_id,B.product_name, COUNT(A.product_id)
FROM [sale].[order_item] A JOIN product.product B ON A.product_id = B.product_id
GROUP BY A.product_id,B.product_name
HAVING COUNT(A.product_id) > 100

/*
How many ? (COUNT) - how many of a particular item has been ordered
How much ? (SUM) -- whats the total sales for last year ?
The average ? (AVG) -- Whats the average amount of sales per customer?
Largest or highest ? (MAX)
Smallest or lowest ? (MIN) -- what is our most or least popular item?
*/

--Write a query that returns category ids with 
--a maximum list price above 4000 or a minimum list price below 500.

SELECT category_id ,MIN(list_price) as MinPrice,MAX(list_price) AS MaxPrice
FROM product.product
GROUP BY category_id 
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500


--Find the average product prices of the brands.
--As a result of the query, the average prices should be 
--displayed in descending order.

SELECT B.brand_name, AVG(A.list_price) AS AvgPrice
FROM product.product A 
	JOIN product.brand B ON A.brand_id = B.brand_id
GROUP BY B.brand_name
ORDER BY 2 DESC

--Write a query that returns BRANDS with an average product price of more than 1000.
SELECT B.brand_name, AVG(A.list_price) AS AvgPricing
FROM product.product A 
	JOIN product.brand B ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(A.list_price) > 1000
ORDER BY 2 DESC

--Write a query that returns the net price paid by the customer for each order. 
--(Don't neglect discounts and quantities)

SELECT order_id, SUM(quantity * list_price * (1-discount)) NetPrice
FROM [sale].[order_item]
GROUP BY order_id
ORDER BY 1
---------------------------------

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

		---------------
		--Data DEfinition Language DDL
		SELECT * FROM 
		sale.sales_summary