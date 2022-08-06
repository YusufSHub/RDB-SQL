/*Session:6: Part2 */
------ CASE EXPRESSION ------

------ Simple Case Expression -----
-- Generate a new column containing what the mean of the values in 
--the Order_Status column.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

--select top 100 * from sale.orders

SELECT order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	ELSE 'Unknown'
	END  order_status_desc
FROM [sale].[orders]
order by 3 desc

SELECT distinct order_status
FROM sale.orders;

-- Add a column to the sales.staffs table containing the store names of the employees.
--1 = Davi techno Retail; 2 = The BFLO Store; 3 = Burkes Outlet
SELECT first_name, last_name,store_id,
	CASE store_id
	WHEN 1 THEN 'Davi techno Retail'
	WHEN 2 THEN 'The BFLO Store'
	ELSE 'Burkes Outlet'
	END store_name
FROM [sale].[staff]

-- Generate a new column containing what the mean of the values in 
--the Order_Status column.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT order_id, order_status,
CASE
	WHEN order_status = 1 THEN 'Pending'
	WHEN order_status = 2 THEN 'Processing'
	WHEN order_status = 3 THEN 'Rejected'
	WHEN order_id =10 THEN 'XXXXXX'
	ELSE  'Completed' 
	END as order_status_desc
FROM [sale].[orders]
;


-- Create a new column containing the labels of the customers' email service providers 
--( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT first_name, last_name, email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
		END as ESP
FROM [sale].[customer]

-- List customers who ordered products in the 
--computer accessories, speakers, and mp4 player categories in the same order.
SELECT A.customer_id,A.first_name,A.last_name
FROM [sale].[customer] A JOIN [sale].[orders] B
	ON A.customer_id = B.customer_id
	WHERE B.order_id IN (

SELECT B.order_id
FROM [product].[product] A JOIN 
	[sale].[order_item] B ON A.product_id = B.product_id
WHERE A.category_id IN (SELECT category_id FROM [product].[category] 
						WHERE category_name = 'computer accessories')
INTERSECT
SELECT B.order_id
FROM [product].[product] A JOIN 
	[sale].[order_item] B ON A.product_id = B.product_id
WHERE A.category_id IN (SELECT category_id FROM [product].[category] 
						WHERE category_name = 'speakers')
INTERSECT
SELECT B.order_id
FROM [product].[product] A JOIN 
	[sale].[order_item] B ON A.product_id = B.product_id
WHERE A.category_id IN (SELECT category_id FROM [product].[category] 
						WHERE category_name = 'mp4 player')
						);

/*
Question: Create a new column that contains labels of the shipping speed of products.

If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow"
*/

SELECT order_id, 
 CASE	
	WHEN shipped_date IS NULL THEN 'Not Shipped'
	WHEN shipped_date = order_date THEN 'Fast'
	WHEN DATEDIFF(DAY,order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
	ELSE 'Slow'
	END as order_label
FROM [sale].[orders]

----Write a query that returns the number distributions of the orders 
--in the previous query result, according to the days of the week.

SELECT 
SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END) as Monday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) as Tuesday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) as Wednesday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) as Thursday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) as Friday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) as Saturday,
SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) as Sunday
FROM sale.orders
WHERE DATEDIFF(DAY,order_date, shipped_date) >2



