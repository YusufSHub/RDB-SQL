USE [BikeStores]
-- staff that venita daniel manager of 
select * from sales.staffs
where manager_id =(
select staff_id from sales.staffs
where first_name='Venita' and last_name='Daniel')

select A.*
from sales.staffs A, sales.staffs B
where A.manager_id = B.staff_id and
B.first_name='Venita' and B.last_name='Daniel'

