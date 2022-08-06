/*Session: 4: Part : 1 */
-- List products with category names
-- Select product ID, product name, category ID and category names


SELECT * FROM [product].[product]

SELECT * FROM 
[product].[category]

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM [product].[product] A INNER JOIN [product].[category] B
ON A.category_id = B.category_id

--List employees of stores with their store information
--Select employee name, surname, store names
select top 10 * from [sale].[staff]
select  * from [sale].[store]

SELECT A.first_name, A.last_name, B.store_name, A.store_id
FROM [sale].[staff] A JOIN [sale].[store] B
ON A.store_id = B.store_id

--Write a query that returns count of orders of the states by months.

SELECT B.state, YEAR (A.order_date)AS [Year],MONTH(A.order_date)[MONTH],COUNT( A.order_id) AS NumOfOrders
FROM [sale].[orders] A JOIN [sale].[customer] B 
ON A.customer_id = B.customer_id
GROUP BY B.state , YEAR (A.order_date),MONTH(A.order_date)

select * from [sale].[orders]


-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)

SELECT A.product_id, A.product_name , B.order_id
FROM  [product].[product] A LEFT JOIN [sale].[order_item] B
ON A.product_id = B.product_id
WHERE B.order_id IS NULL;

--Report the stock status of the products that 
--product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity
SELECT A.product_id, A.product_name, B.quantity
FROM [product].[product] A LEFT JOIN [product].[stock] B
ON A.product_id = B.product_id
WHERE A.product_id > 310

