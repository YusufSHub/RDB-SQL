use [SampleRetail ]

select * from sale.order_item

--average discount ve product_id 
CREATE VIEW asg4 AS 
select product_id, discount, SUM(quantity) quantity
from sale.order_item 
group by product_id, discount
order by product_id, discount

CREATE VIEW asg41 AS 
select product_id, AVG(discount) mean_discount, AVG(quantity*1.0) mean_quantity
from asg4 
group by product_id
order by product_id