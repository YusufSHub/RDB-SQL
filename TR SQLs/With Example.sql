--list the costumers with each order 500$ and reside in the city of Charleston..
WITH t1 AS (
    SELECT s.customer_id, s.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) as total
    FROM sale.order_item i, sale.orders s
    WHERE i.order_id=s.order_id
    GROUP BY s.customer_id, s.order_id
    HAVING SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) >500
),
t2 AS (    
    SELECT s.customer_id, s.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) as total
    FROM sale.order_item i, sale.orders s
    WHERE i.order_id=s.order_id
    GROUP BY s.customer_id, s.order_id
    HAVING SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) <500
),
t3 AS ( 
    SELECT customer_id, first_name, last_name, city
    FROM sale.customer
    WHERE city = 'Charleston'
)
SELECT Distinct t3.first_name, t3.last_name
FROM t3 
LEFT JOIN t1 ON t3.customer_id=t1.customer_id
LEFT JOIN t2 ON t3.customer_id=t2.customer_id
WHERE t3.customer_id in (
    SELECT t1.customer_id FROM t1 
    EXCEPT 
    SELECT t2.customer_id FROM t2 
)
ORDER BY 2 ASC, 1 ASC