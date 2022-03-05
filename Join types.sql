select [product].[product].product_id,
[product].[product].product_name, 
[product].[category].category_id,
[product].[category].category_name
from [product].[product]
inner join [product].[category]
on [product].[category].category_id = [product].[product].category_id

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product A
INNER JOIN product.category B ON A.category_id = B.category_id

select A.first_name, A.last_name, 
B.store_name
from [sale].[staff] A
inner join [sale].[store] B 
on  A.store_id = B.store_id

--Write a query that returns count of orders of the states by months.
SELECT X.[state], YEAR(Y.order_date) Year1, MONTH(Y.order_date) Month1, count(Distinct order_id) Num_Count
FROM sale.customer X, sale.orders Y
WHERE X.customer_id = Y.customer_id -- where used in the place of inner join
GROUP BY X.[state], YEAR(Y.order_date), MONTH(Y.order_date)


SELECT X.[state], YEAR(Y.order_date) Year1, MONTH(Y.order_date) Month1, count(DISTINCT Y.order_id) Num_Count
FROM sale.customer X 
INNER JOIN sale.orders Y
ON X.customer_id = Y.customer_id -- where used in the place of inner join
GROUP BY X.[state], YEAR(Y.order_date), MONTH(Y.order_date)

-- Write a query to return items that have never been ordered
select A.product_id, A.product_name, B.order_id
from product.product A
LEFT JOIN [sale].[order_item] B
on A.product_id = B.product_id
where order_id is NULL


--Report the stock of the products that product id > 310
select A.product_id, A.product_name, B.store_id, B.product_id, B.quantity
from product.product A
LEFT JOIN [product].[stock] B
on A.product_id = B.product_id
where A.product_id > 310

select B.product_id, B.product_name, A.* --A.* will bring all columns 
from [product].[stock] A
Right JOIN product.product B
on B.product_id = A.product_id
where B.product_id > 310

select S.staff_id, S.first_name, S.last_name, O.*
from sale.staff S
RIGHT JOIN sale.orders O
on S.staff_id = O.staff_id

select S.staff_id, S.first_name, S.last_name, O.*
from sale.orders O
RIGHT JOIN sale.staff S
on S.staff_id = O.staff_id

select TOP 100 P.product_id, S.store_id, S.quantity,  O.order_id, O.list_price
from product.product P
FULL OUTER JOIN product.stock S ON P.product_id = S.product_id
FULL OUTER JOIN sale.order_item O ON P.product_id = O.product_id
order by P.product_id;

/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.

You have to insert all these products for every three stores with "0" quantity.

Write a query to prepare this data.
*/