USE SampleRetail
/*edir bu Windows Function ne işe yarar?:
Window fonksiyonları sql sorgusu ile elde edilen sonuç setini her fonksiyonun 
kendi karakterine göre parçalara ayırarak yine bu parçalara kendi fonksiyonlarına 
göre değer üretirler.
Bu değerler SELECT listesinde veya ORDER BY sıralama kriterleri içinde kullanılabilirler.
Window fonksiyonları kullanılırken OVER anahtarı ile kayıt setinin parçalara bölünmesi sağlanır.*/

-- Write a query that returns the stock amount of products. Use WF and Group By
select * from product.stock

select product_id, sum(quantity) 
from product.stock
group by product_id
order by product_id;

select *, 
sum(quantity) over (partition by product_id) total_stock
from product.stock
order by product_id;


--Write a query that returns the average list price of products by brands 

select DISTINCT brand_id, avg(list_price) over (partition by brand_id) avg_price 
from product.product
order by brand_id;

SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id;

-- What is the cheapes prodcut price ?

select TOP 1 list_price
from product.product
order by list_price;

select DISTINCT min(list_price) over() cheapest
from product.product;


select	*
from	(
		select	product_id, product_name, list_price, min(list_price) over() cheapest
		from	product.product
		) A
where	A.list_price = A.cheapest
;


--What is the cheapest price in each category ?

select DISTINCT category_id, min(list_price) over(partition by category_id) cat_cheapest
from product.product;


-- How many product in product table 

select count(product_id)
from product.product

select count(product_name)
from product.product

select DISTINCT count(*) OVER() 
from product.product

-- How many product in the order_item table ?

select count(DISTINCT product_id)
from sale.order_item

select count(product_id) OVER()
from sale.order_item

--write a query that returns how many products in each order?

select DISTINCT order_id, count(item_id) over(partition by order_id) pro_order
from sale.order_item

--how many different product are in each brand in each category

select DISTINCT category_id, brand_id, count(*) over(partition by brand_id, category_id) no_products
from product.product
order by category_id, brand_id


select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date) min_order_date
from	sale.customer a, sale.orders b
where a.customer_id =b.customer_id

select a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by a.first_name) last_order_date
from	sale.customer a, sale.orders b
where a.customer_id =b.customer_id


select a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(b.order_date) over(order by b.order_date) last_order_date
from	sale.customer a, sale.orders b
where a.customer_id =b.customer_id

select a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(b.order_date) over(order by b.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_order_date
from	sale.customer a, sale.orders b
where a.customer_id =b.customer_id

--What is the name of the cheapest product ?

select DISTINCT FIRST_VALUE(product_name) over(order by list_price, model_year DESC) name_cheapest
from product.product


select DISTINCT 
	FIRST_VALUE(product_name) over(order by list_price, model_year ASC) name_cheapest,
	FIRST_VALUE(list_price) over(order by list_price, model_year ASC) price_cheapest
from product.product

/*
	LAG, current row'dan belirtilen argümandaki rakam kadar önceki değeri getiriyor.
	LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki değeri getiriyor.
*/


--Write a query that returns the order date of the one previous sale of each staff(use lag)


select b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
	lag(b.order_date) over(partition by a.staff_id order by b.order_id) prev_date
from sale.staff a, sale.orders b
where a.staff_id = b.staff_id
order by a.staff_id, b.order_date

select b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
	lead(b.order_date) over(partition by a.staff_id order by b.order_id) prev_date
from sale.staff a, sale.orders b
where a.staff_id = b.staff_id
order by a.staff_id, b.order_date