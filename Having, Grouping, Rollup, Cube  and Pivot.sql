-- Cross Join Q
/* In the stocks table, there are not all products held on the product table
and you want to insert into the stock table.
You have to insert all these products for every three stores with "0" quantity.
Write a query*/

select * from sale.store

select product_id, quantity
from product.stock

select B.store_id, A.product_id, A.product_name, A.list_price, 0 Quantity
from product.product A
cross join sale.store B
where A.product_id NOT IN (select product_id
from product.stock)
order by A.product_id, B.store_id, A.list_price

-- there are 5 agg functions = avg, min, max, sum, count
/* sql workflow
from > where > group by > having > select > order by */
-- 
select product_id, product_name, count(product_id) more_one
from product.product
group by product_id, product_name
having count(product_id) > 1

/* since product_id is PK. must return no columns.*/

--Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.
select category_id, max(list_price) max_price, min(list_price) min_price
from product.product
group by category_id
having max(list_price)> 4000 or min(list_price) <500
order by category_id

--Find the average product prices of the brands.
select B.brand_name, AVG(list_price) avg_list_price
from product.product A, product.brand B
where A.brand_id = B.brand_id
group by B.brand_name
order by avg_list_price DESC


--Write a query that returns BRANDS with an average product price of more than 1000.
select B.brand_name, AVG(list_price) avg_list_price
from product.product A, product.brand B
where A.brand_id = B.brand_id
group by B.brand_name
having avg(list_price) > 1000
order by avg_list_price DESC


SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


select * from sale.sales_summary

-- Total sale 
select sum(total_sales_price)
from sale.sales_summary

-- Calculate total sale per brand
select brand, sum(total_sales_price) sum_per_brand
from sale.sales_summary
group by Brand

select Category, sum(total_sales_price) sum_per_brand
from sale.sales_summary
group by Category

-- Calculate sum per brand and category
select Brand, Category, sum(total_sales_price) sum_per_brand_category
from sale.sales_summary
group by Brand, Category

select Brand, Category, sum(total_sales_price) TOTAL
from sale.sales_summary
group by 
	GROUPING SETS(
	(),
	(Brand),
	(Category),
	(Brand, Category)
	)
order by Brand, Category

--group by kullaniyorsak agg function da olmali. must be 


select Brand, Category, sum(total_sales_price) TOTAL
from sale.sales_summary
group by 
	GROUPING SETS(
	(),
	(Brand),
	(Category),
	(Brand, Category)
	)
order by Brand, Category

select Brand, Category, sum(total_sales_price) TOTAL
from sale.sales_summary
group by ROLLUP
	(Brand, Category)
order by Brand, Category

---------- ROLLUP ---------
--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
select Brand, Category, sum(total_sales_price) TOTAL
from sale.sales_summary
group by ROLLUP
	(Brand, Category)
order by Brand, Category

-- Calculate sum total_sales_price
--brand, category, model_year sütunları için Rollup kullanarak total sales hesaplaması yapın.
select Brand, Category, model_year, sum(total_sales_price) TOTAL
from sale.sales_summary
group by ROLLUP
	(Brand, Category, model_year)
order by Brand, Category, model_year

select * from sale.sales_summary
--üç sütun için 4 farklı gruplama varyasyonu üretiyor