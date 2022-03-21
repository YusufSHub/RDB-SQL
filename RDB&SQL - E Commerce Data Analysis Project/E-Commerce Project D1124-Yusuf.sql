use [E Commerce Project]
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

select * from combined_view





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

select MONTH(Order_Date) Month_Num, DATENAME(MONTH, Order_Date) Monthz, 
	COUNT(DISTINCT Cust_id) Cust_Count from combined_table
	where Cust_id in ( 
					select Cust_id from combined_table
					where MONTH(Order_Date)=1 and YEAR(Order_Date)=2011
					) 
	and YEAR(Order_Date)=2011
group by MONTH(Order_Date), DATENAME(MONTH, Order_Date)
order by 1


	SELECT MONTH(Order_Date) Month_No, COUNT(DISTINCT cust_id) MONTHLY_NUM_OF_CUST
		FROM combined_table A --exists te içerdeki query ile dışardakini bağlamam gerektiği için A dedim.
		WHERE
		EXISTS
		(
			SELECT cust_id
			FROM combined_table B
			WHERE YEAR(Order_Date) = 2011
			AND MONTH(Order_Date) = 1
			AND A.Cust_id = B.Cust_id
		)
		AND YEAR(Order_Date) = 2011
	GROUP BY MONTH(order_date)

--////////////////////////////////////////////

--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions

select DISTINCT Cust_id, Order_Date [third_order_date], first_order_date, third_order,
	DATEDIFF(Day, first_order_date, order_date) Date_difference
from 
 (
	select DISTINCT Cust_id, Order_Date,	
	 min(Order_date) over(Partition by Cust_id) first_order_date,
	 DENSE_RANK() over(Partition by Cust_id order by order_date) third_order
	from combined_table
	) T
where third_order=3


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
	cast((1.0*count_prod11/total_product)*100 as decimal (5,2)) [ratio_p11], 
	count_prod14,
	cast((1.0*count_prod14/total_product)*100 as decimal (5,2)) [ratio_p14] ,
	total_product
 from tablo1 
 order by ratio_p14 DESC, ratio_p11 ASC


 ------
 select cust_id,
	   SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity ELSE 0 end) Prod_11_count,
	   SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity ELSE 0 end) Prod_14_count,
	  format((SUM(CASE WHEN Prod_id='Prod_11' THEN order_quantity ELSE 0 end) + SUM(CASE WHEN Prod_id='Prod_14' THEN order_quantity ELSE 0 end))* 1.0 / SUM (Order_Quantity)*100, 'N1')  as Percentages
FROM combined_table
where Cust_id in (
				SELECT Cust_id
					 FROM combined_table
					 WHERE Prod_id IN ('Prod_11', 'Prod_14')
					 GROUP BY Cust_id
					 HAVING COUNT(DISTINCT Prod_id)=2
				)
GROUP BY Cust_id
order by Cust_id
--/////////////////


--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW Customer_Log as
select cust_id, DATENAME(YEAR, order_date) Year_Visit, DATENAME(MONTH, Order_Date) Month_Visit
from combined_table
group by Cust_id, DATENAME(YEAR, order_date), DATENAME(MONTH, Order_Date)



select * from Customer_Log
--//////////////////////////////////



  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

CREATE VIEW Monthly_Visit as 
select Cust_id, 		Customer_Name , 		year(Order_Date) years_, 		DATENAME(month,Order_Date) month_,		count(*) monthly_visitfrom combined_tablegroup by Cust_id, Customer_Name ,year(Order_Date) , DATENAME(month,Order_Date)

select * from Monthly_Visit






--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

CREATE VIEW NEXT_VISIT as 
	select *,
	lead(next_month,1) OVER(PARTITION by cust_id order by next_month) next_visit
	from
	(select *, 
	DENSE_RANK() over(order by years_, month_) Next_Month
	from Monthly_Visit
	)  A

	select * from NEXT_VISIT



--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.


CREATE VIEW month_gap as 
select Cust_id, next_visit, Next_Month, (next_visit-Next_Month) month_gap
from NEXT_VISIT

select * from month_gap





--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	
with T1 as(
select Cust_id, DATEDIFF(MONTH, order_date, second_order) Month_Gap
from (
	select DISTINCT Cust_id, Order_Date,	
	 min(Order_date) over(Partition by Cust_id) first_order_date,	 
	 lead(Order_Date,1) over(partition by cust_id order by order_date) second_order
	 from combined_table
	 ) T
)

SELECT cust_id, AVG(t1.month_gap) AS AvgTimeGap,       CASE WHEN AVG(t1.month_gap) IS NULL THEN 'Churn'	     WHEN MAX(t1.month_gap) = 1 THEN 'regular'	     ELSE 'irregular'	       END CustLabelsFROM T1GROUP BY cust_id
order by CustLabels




select * from combined_table
where Cust_id='Cust_59'

--/////////////////////////////////////




--MONTH-WISE RETENTION RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT DISTINCT YEAR(order_date) [year],                 MONTH(order_date) [month],                DATENAME(month,order_date) [month_name],                COUNT(cust_id) OVER (PARTITION BY year(order_date), month(order_date) order by year(order_date), month(order_date)  ) num_custFROM combined_table

--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

CREATE VIEW TA as
(
	SELECT DISTINCT YEAR(order_date) [year],                 MONTH(order_date) [month],                DATENAME(month,order_date) [month_name],                COUNT(cust_id) OVER (PARTITION BY year(order_date), month(order_date) order by year(order_date), month(order_date)  ) num_cust	FROM combined_table
	) 

select year, month, num_cust, lead(num_cust,1) over (order by year, month) rate_,
	FORMAT(num_cust*1.0*100/(lead(num_cust,1) over (order by year, month, num_cust)), 'N1') Retention_rate
from TA
order by year, month, num_cust



---///////////////////////////////////
--Good luck!