/*Discount Effects

Generate a report including product IDs and discount effects  on whether the increase in the discount rate positively impacts 
the number of orders for the products.

In this assignment, you are expected to generate a solution  using SQL with a logical approach. */

with tbl1 as (
select DISTINCT a.product_id, b.discount,
sum(b.quantity) Total_product,
LEAD (SUM(b.quantity)) over(partition by a.product_id order by  discount ) Leadd
from product.product a, sale.order_item b, sale.orders c
where a.product_id=b.product_id and b.order_id=c.order_id
GROUP BY a.product_id, b.discount
), 

tbl2 as ( select product_id, Total_product, Leadd ,
 case 
 when (leadd - total_product)>0 then 1
 when (leadd - total_product)<0 then -1
 when (leadd - total_product)=0 then 0
 end as efekt
 from tbl1

)
select product_id, sum(efekt) Difference,
case 
when sum(efekt) > 0 then 'Positive'
when sum(efekt) < 0 then 'Negative'
when sum(efekt) = 0 then 'Neutral'
end as [Discount Effect]
from tbl2
group by  product_id
