/*Discount Effects

Generate a report including product IDs and discount effects 
on whether the increase in the discount rate positively impacts 
the number of orders for the products.

In this assignment, you are expected to generate a solution 
using SQL with a logical approach. */

select DISTINCT a.product_id, b.discount,
sum(b.quantity) over(partition by a.product_id, b.discount) total_per_discount,
sum(b.quantity) over(partition by a.product_id) total_per_product,
avg(b.quantity) over(partition by a.product_id, b.discount),
cast((sum(b.quantity) over(partition by a.product_id, b.discount)* 1.0/(sum(b.quantity) over(partition by a.product_id)))as numeric(3,2)) percentage
from product.product a, sale.order_item b, sale.orders c
where a.product_id=b.product_id and b.order_id=c.order_id
order by a.product_id,b.discount
