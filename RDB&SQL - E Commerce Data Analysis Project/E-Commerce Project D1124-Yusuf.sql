
--1. Join all the tables and create a new table called combined_table. 
--(market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

CREATE VIEW [combined_view] AS
(
SELECT a.Ord_id, a.prod_id, a.Ship_id, a.Cust_id, a.Sales, a.Discount, a.Order_Quantity, a.Product_Base_Margin,	   b.Customer_Name, b.Province, b.Region, b.Customer_Segment,	   c.Order_Date, c.Order_Priority,	   d.Product_Category, d.Product_Sub_Category,	   e.Order_ID, e.Ship_Date, e.Ship_Mode
	from market_fact a
	LEFT JOIN customer_dimension b	ON a.cust_id = b.cust_id	LEFT JOIN orders_dimen c	ON a.ord_id = c.ord_id	LEFT JOIN prod_dimen d	ON a.prod_id = d.prod_id	LEFT JOIN shipping_dimen e	ON a.ship_id = e.ship_id
)
select * 
into combined_table 
from combined_view







--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

select top 3 Customer_Name, cust_id, count(Order_ID) order_count
from combined_table
group by Customer_Name, cust_id
order by order_count DESC


select Cust_id, Customer_name
from (
	select top 3 Customer_Name, cust_id, count(Order_ID) order_count
	from combined_table
	group by Customer_Name, cust_id
	order by order_count DESC
	) T1
--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date 
--difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

select ship_date, order_date, DATEDIFF(DAY, order_date, ship_date) DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery DESC

alter table combined_table
drop column if exists DaysTakenForDelivery

alter table combined_table --1st way of adding datediff
add  DaysTakenForDelivery as 
(DATEDIFF(DAY, order_date, ship_date))

alter table combined_table
add DaysTakenForDelivery2 int

select  DaysTakenForDelivery2  from combined_table

update combined_table --2nd way of adding datediff
set DaysTakenForDelivery2 = DATEDIFF(DAY, order_date, ship_date)

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"

select TOP 1 Customer_Name, Cust_id, Order_Date, Ship_Date, DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery DESC


SELECT Cust_id, Customer_Name, Order_Date, Ship_Date, DaysTakenForDeliveryFROM combined_tableWHERE DaysTakenForDelivery = (							SELECT MAX(DaysTakenForDelivery)							FROM combined_table							)



--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every 
--month over the entire year in 2011
--You can use date functions and subqueries





--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions





--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions


with tablo1 as (
	select cust_id,
	sum(case when prod_id='Prod_11' then order_quantity else 0 end) count_prod11,
	sum(case when prod_id='Prod_14' then order_quantity else 0 end) count_prod14,
	sum(order_Quantity ) total_product
	from combined_table
	group by Cust_id
	having sum(case when prod_id='Prod_11' then order_quantity else 0 end) >0 and 
	sum(case when prod_id='Prod_14' then order_quantity else 0 end) > 0
) 
 select cust_id, 
	count_prod11,
	cast((1.0*count_prod11/total_product) as decimal (3,2)) [ratio_p11], 
	count_prod14,
	cast((1.0*count_prod14/total_product) as decimal (3,2)) [ratio_p14] ,
	total_product
 from tablo1 
 order by ratio_p14 DESC, ratio_p11 ASC

--/////////////////


select * from combined_table where  Cust_id='Cust_1538'
select * from combined_table where Cust_id='Cust_1538'

--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.



--//////////////////////////////////



  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.





--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.



--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.







--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	







--/////////////////////////////////////




--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!