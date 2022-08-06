--use BikeStores
select * from production.stocks

select product_id, sum(quantity) from production.stocks
group by product_id
order by 1


select *, 
sum(quantity) over(partition by product_id) as Total_Stock 
from production.stocks

select product_id, 
sum(quantity) over(partition by product_id) as Total_Stock 
from production.stocks

select DISTINCT product_id, 
sum(quantity) over(partition by product_id) as Total_Stock 
from production.stocks


select DISTINCT brand_id, avg(list_price) over(partition by brand_id) Avg_Price
from production.products

select DISTINCT min(list_price) over()
from production.products

select DISTINCT category_id, min(list_price) over(partition by category_id) Cat_Min
from production.products

select * from production.products
where category_id=1

select DISTINCT count(product_id) over() num_bikes
from production.products

select distinct count(product_id) over()  
from(
	select distinct product_id from sales.order_items) A



	select *, 
	sum(quantity) over(partition by product_id) from product.stock

	--list the average list price of the products by brand
	select distinct b.brand_id, avg(a.list_price) over(partition by a.brand_id) avg_listprice
	from product.product a, product.brand b
	where a.brand_id=b.brand_id

	--cheapest product
	select DISTINCT min(list_price) over()
	from product.product

	select DISTINCT category_id, min(list_price) over(partition by category_id)
	from product.product

	select * 
	from (
	select product_id, product_name, list_price, min(list_price) over() cheapes
	from product.product) A
	where A.list_price=A.cheapes

	select count(product_id) over()
	from product.product





	select DISTINCT order_id, count(item_id) over(partition by order_id) count_product
	from sale.order_item

	--how many different product in each brand and in each category 
	select * 
	from product.product a, product.brand b, product.category c
	where a.brand_id=b.brand_id and a.category_id=c.category_id

	select DISTINCT category_id, brand_id, 
	count(*) over(partition by category_id, brand_id) product_count
	from product.product 

	select a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(order_date) over (partition by first_name order by b.order_date)
	from sale.customer a, sale.orders b
	where a.customer_id = b.customer_id

	select a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(store_id) over (partition by first_name order by b.order_date) store
	from sale.customer a, sale.orders b
	where a.customer_id = b.customer_id

	select a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(order_date) over (order by b.order_date)
	from sale.customer a, sale.orders b
	where a.customer_id = b.customer_id

	
	select a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(order_date) over (order by b.order_date rows between unbounded preceding and unbounded following)
	from sale.customer a, sale.orders b
	where a.customer_id = b.customer_id

	select a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(order_date) over (order by b.order_date rows between unbounded preceding and unbounded following)
	from sale.customer a, sale.orders b
	where a.customer_id = b.customer_id

	--name of the cheapes product

	select DISTINCT FIRST_VALUE(product_name) over(order by list_price, model_year DESC),
		FIRST_VALUE(list_price) over(order by list_price, model_year DESC)
	from product.product