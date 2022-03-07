-- Cross Join Q
/* In the stocks table, there are not all products held on the product table
and you want to insert into the stock table.
You have to insert all these products for every three stores with "0" quantity.
Write a query*/

select * from sale.store

select product_id, quantity
from product.stock

select B.store_id, A.product_id, A.product_name, 0 Quantity
from product.product A
cross join sale.store B
where A.product_id NOT IN (select product_id
from product.stock)
order by A.product_id, B.store_id
