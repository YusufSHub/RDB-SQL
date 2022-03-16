/*Discount Effects

Generate a report including product IDs and discount effects 
on whether the increase in the discount rate positively impacts 
the number of orders for the products.

In this assignment, you are expected to generate a solution 
using SQL with a logical approach. */

select DISTINCT a.product_id, b.discount,
sum(b.quantity) over(partition by a.product_id, b.discount) total_per_discount
from product.product a, sale.order_item b, sale.orders c
where a.product_id=b.product_id and b.order_id=c.order_id
order by a.product_id,b.discount


select a.product_id, b.discount
from product.product a, sale.order_item b
where a.product_id=b.product_id 
order by a.product_id,b.discount

select * from product.product

select * from sale.order_item
where product_id=1
order by product_id
