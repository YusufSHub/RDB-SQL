USE [BikeStores]

select * from sales.staffs
where manager_id =(
select staff_id from sales.staffs
where first_name='Venita' and last_name='Daniel')