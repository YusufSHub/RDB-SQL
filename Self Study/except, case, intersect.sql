-- write a query that returns customer who have orders for 2018, 2019, 2020

select customer_id, first_name, last_name
from sale.customer
where customer_id in (
select customer_id
from sale.orders
where order_date between '2018-01-01' and '2018-12-31'
intersect
select customer_id
from sale.orders
where order_date between '2019-01-01' and '2019-12-31'
intersect
select customer_id
from sale.orders
where order_date between '2020-01-01' and '2020-12-31'
)



--Wrtie a query that returns brands that have a 2018 model year product but not a 2019 model product


select brand_id, brand_name
from product.brand
where brand_id in
(
select brand_id
from product.product
where model_year=2018
except
select brand_id 
from product.product
where model_year=2019
)



select DISTINCT product_id 
from sale.order_item
where order_id in (
select DISTINCT order_id
from sale.orders
where order_date between '2019-01-01' and '2019-12-31'
except 
select order_id
from sale.orders
where order_date between '2020-01-01' and '2020-12-31'
except
select order_id
from sale.orders
where order_date between '2018-01-01' and '2011-12-31'
)



--Simple Case Expressions
select order_id, order_status,
	CASE order_status 
		when 1 then 'Pending'
		when 2 then 'Processing'
		when 3 then 'Rejected'
		when 4 then 'Completed'
		end as order_stats
from sale.orders
order by order_status, order_id


select first_name, last_name, store_id,
	CASE store_id
		when 1 then 'Davi techno Retail'
		when 2 then 'The FBLO'
		when 3 then 'Burkes Outlet'
		end as Store_name
from sale.staff


select order_id, order_status,
	case
	when order_status=1 then 'Pending'
	when order_status=2 then 'Processing'
	when order_status=3 then 'Rejected'
	when order_status=4 then 'Completed'
	end as Order_Stat
from sale.orders


select first_name, last_name, store_id,
	CASE 
		when s1 then 'Davi techno Retail'
		when 2 then 'The FBLO'
		when 3 then 'Burkes Outlet'
		end as Store_name
from sale.staff


	select first_name, last_name, email,
		case 
		when email LIKE '%@gmail%' then 'Gmail'
		when email LIKE '%@hotmail%' then 'Hotmail'
		when email LIKE '%@yahoo%' then 'Yahoo'
		else 'Other'
		end as Mail_provider
	from sale.customer
