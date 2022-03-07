/* Session4 Part2 03/05/2022 */

--Homework from previous session

SELECT street, REPLACE (street, target_chars,numerical_chars)
FROM	(
			SELECT	street,
					LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
					RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

					LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

			FROM	sale.customer
			WHERE	ISNUMERIC (RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1)) = 0
		) A

--Right Join

--Report (AGAIN WITH RIGHT JOIN) the stock status of the 
--products that product id greater than 310 in the stores.

SELECT PRD.product_id, PRD.product_name, STK.quantity
FROM product.stock STK
	RIGHT JOIN product.product PRD
	 ON STK.product_id = PRD.product_id
WHERE PRD.product_id >310

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders
SELECT * from sale.staff

select count(distinct Staff_id)
FROM sale.staff

SELECT COUNT (Distinct staff_id)
FROM sale.orders

SELECT B.staff_id, B.first_name, B.last_name, A.*
FROM sale.orders A RIGHT JOIN sale.staff  B
	ON A.staff_id = B.staff_id
ORDER BY A.order_id

SELECT B.staff_id, B.first_name, B.last_name, A.*
FROM  sale.staff  B LEFT JOIN  sale.orders A
	ON A.staff_id = B.staff_id
ORDER BY A.order_id

----------------------------------------
--Write a query that returns stock and order information together for all products . 
--(TOP 100)
--Expected columns: Product_id, store_id, quantity, order_id, list_price
SELECT top 20 A.product_id, A.store_id, A.quantity, B.order_id, B.list_price, B.product_id
FROM product.stock A 
	FULL OUTER JOIN
	 sale.order_item B 
	 ON A.product_id = B.product_id
ORDER BY  1 

--ASC -- default sort order

----------------------------------------------------
/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.

You have to insert all these products for every three stores with “0” quantity.

Write a query to prepare this data.
*/

SELECT B.store_id, A.product_id, 0 as Quatity
FROM product.product A
	CROSS JOIN sale.store B
WHERE A.product_id NOT IN (
				SELECT product_id
				FROM product.stock
				)

------------------------
--find staff member who did not place any orders
select * from sale.staff

select staff_id, first_name, last_name, 0 as OrdersPlaced
FROM sale.staff
WHERE staff_id NOT IN
(
SELECT distinct staff_id
FROM sale.orders
)

------
--Self Join

select * from sale.staff

--Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name
SELECT STF.first_name +' '+ STF.last_name as StaffFullName, MGR.first_name
FROM sale.staff STF
	JOIN sale.staff MGR ON
	STF.manager_id = MGR.staff_id

	--Write a query that returns the 1st and 2nd degree managers of all staff
SELECT STF.first_name StaffName, MGR.first_name ManagerName, MGR2.first_name MAnagersManager
FROM sale.staff STF 
		JOIN sale.staff MGR ON STF.manager_id = MGR.staff_id
		JOIN sale.staff MGR2 ON MGR.manager_id = MGR2.staff_id

CREATE VIEW Staff_Manager 
AS
SELECT STF.first_name +' '+ STF.last_name as StaffFullName, MGR.first_name + ' '+ MGR.last_name as ManagerFullName
FROM sale.staff STF
	JOIN sale.staff MGR ON
	STF.manager_id = MGR.staff_id


SELECT * FROM 
[dbo].[Staff_Manager]
		
