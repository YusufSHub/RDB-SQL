select Distinct brand_id, category_id, avg(list_price) over(partition by brand_id)
from product.product


select distinct category_id, brand_id, avg(list_price) over(partition by category_id)
from product.product


--product_name of the cheapest product
select list_price, product_name
from product.product
where product_name=
(select DISTINCT FIRST_VALUE(product_name) over(order by list_price) cheapest
from product.product
)

select list_price, product_name
from product.product
where product_name=
(select DISTINCT LAST_VALUE(product_name) over(order by list_price) cheapest
from product.product
)

select  top 1 last_value(product_name) over (order by list_price, model_year DESC) cheapest_product, list_price
from    product.product

--try using last_value
select DISTINCT list_price, FIRST_VALUE(product_name) 
over(order by list_price rows between unbounded preceding and unbounded following) cheapest
from product.product


--write a query that returns first order date by month

select DISTINCT YEAR(order_date) [Year], MONTH(order_date) [Month],
FIRST_VALUE(order_date) over(partition by YEAR(order_date), MONTH(order_date) order by order_date) [First Order]
from sale.orders