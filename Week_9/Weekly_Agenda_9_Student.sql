---- RDB&SQL Exercise-2 Student

----1. By using view get the average sales by staffs and years using the AVG() aggregate function.
	CREATE VIEW staff
	as
	select staff_id, first_name, last_name from sale.staff

	select * from sale.orders

	CREATE VIEW orders
	as
	select order_id, YEAR(order_date) Year, staff_id  from sale.orders

	select * from dbo.orders

	CREATE VIEW sales
	as
	select order_id, AVG((list_price - (list_price * discount)) * quantity) Avg_Sales from sale.order_item
	group by order_id

	select * from dbo.sales
	
  select a.staff_id, a.first_name, a.last_name, b.Year, avg(C.Avg_Sales) Avg_Sale
  from dbo.staff a, dbo.orders b, dbo.sales c
  where a.staff_id=b.staff_id and b.order_id = c.order_id
	group by a.staff_id, a.first_name, a.last_name, b.Year
	order by a.staff_id, a.first_name, a.last_name, b.Year



	CREATE VIEW staff_years AS (
SELECT b.staff_id, a.order_id, year(a.order_date) year
FROM sale.orders a, sale.staff b 
WHERE a.staff_id=b.staff_id
)

SELECT d.staff_id, year, AVG((c.list_price * (1-c.discount)) * c.quantity) as average_sales
FROM sale.order_item c, staff_years d
WHERE c.order_id = d.order_id
GROUP BY d.staff_id, year
ORDER BY d.staff_id, year


	select first_name, last_name, avg(Avg_Sales)
	from dbo.staff a, dbo.orders b, dbo.sales c
	  where a.staff_id=b.staff_id and b.order_id = c.order_id and
	  first_name= 'Charles' and last_name='Cussona'
	  and Year=2018
	  group by first_name, last_name


	  CREATE VIEW staff_sale AS
SELECT first_name, last_name, YIL, ortalama_satış
FROM
		(
		select A.first_name, A.last_name, YEAR(B.order_date) AS YIL, AVG(C.quantity*(C.list_price*(1-C.discount))) as ortalama_satış
		from sale.staff A, sale.orders B, sale.order_item C
		where A.staff_id = B.staff_id
		and B.order_id=C.order_id
		GROUP BY A.first_name, A.last_name, YEAR(B.order_date)
		) A
;
select first_name, last_name, YIL, ortalama_satış
from staff_sale
order by 1, 2, 3



----2. Select the annual amount of product produced according to brands (use window functions).

select b.brand_name, model_year,
count(a.product_id) over(PARTITION BY b.brand_name, a.model_year order by b.brand_name, a.model_year) num_item
from product.product a, product.brand b
where a.brand_id = b.brand_id

select b.brand_name, model_year, product_name
from product.product a, product.brand b
where a.brand_id = b.brand_id and brand_name='Acer' and model_year=2021


----3. Select the least 3 products in stock according to stores.

select TOP 3 *
from(
select s.store_id, p.product_name, sum(s.quantity) stock_quantity,
row_number() over(partition by s.store_id order by sum(s.quantity)) stock_out
from product.stock  s, product.product p
where s.product_id=p.product_id
group by store_id, p.product_name
having  sum(s.quantity)>=0
--order by 1, 3
) a
where a.stock_out<4
order by stock_out







----4. Return the average number of sales orders in 2020 sales


----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.
