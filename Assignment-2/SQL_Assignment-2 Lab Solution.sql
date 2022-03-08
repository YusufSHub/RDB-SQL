/*You need to create a report on whether customers who purchased the product named 
'2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.
1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)
2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)
3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)
To generate this report, you are required to use the appropriate SQL Server 
Built-in string functions (ISNULL(), NULLIF(), etc.) and Joins, as well 
as basic SQL knowledge. As a result, a report exactly like the attached file is expected from you.*/


select 
E.*,  
ISNULL(NULLIF(ISNULL(STR(F.customer_id), 'No'), STR(F.customer_id)), 'Yes') as First_product, 
ISNULL(NULLIF(ISNULL(STR(G.customer_id), 'No'), STR(G.customer_id)), 'Yes') as Second_product, 
ISNULL(NULLIF(ISNULL(STR(H.customer_id), 'No'), STR(H.customer_id)), 'Yes') as Third_product 
from 
(
select DISTINCT A.customer_id, A.first_name, A.last_name
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
) as E
left join 
(
select DISTINCT A.customer_id, A.first_name, A.last_name
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'Polk Audio - 50 W Woofer - Black'
) as F
on E.customer_id = F.customer_id
left join
(
select DISTINCT A.customer_id, A.first_name, A.last_name
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
) as G
on E.customer_id = G.customer_id
left join 
(
select DISTINCT A.customer_id, A.first_name, A.last_name
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
) as H
on E.customer_id = H.customer_id
order by E.customer_id



