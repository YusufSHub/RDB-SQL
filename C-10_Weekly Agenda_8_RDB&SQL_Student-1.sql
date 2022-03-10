---- C-10 WEEKLY AGENDA-8 RD&SQL STUDENT

---- 1. List all the cities in the Texas and the numbers of customers in each city.----

select city, COUNT(customer_id) no_of_customers
from sale.customer 
where state='TX'
group by city
order by no_of_customers;


---- 2. List all the cities in the California which has more than 5 customer, 
--by showing the cities which have more customers first.---

select city, count(customer_id) AS no_customers
from sale.customer
where state= 'CA'
group by city
having count(customer_id) > 5


---- 3. List the top 10 most expensive products----
select TOP 10 product_name, list_price 
from product.product
order by list_price DESC;

select max(list_price) 
from product.product


---- 4. List store_id, product name and list price and the quantity of 
--the products which are located in the store id 2 and the quantity is greater than 25----

select P.product_name, P.list_price, S.quantity, S.store_id
from product.product P
left join product.stock S 
on p.product_id = S.product_id 
where S.store_id = 2 and S.quantity > 25
group by P.product_name, P.list_price, S.quantity, S.store_id


---- 5. Find the sales order of the customers who lives in Boulder order by order date----
-- order ID, 
select C.city, O.order_id,O.order_date, C.first_name, C.last_name 
from sale.customer C, sale.orders O
where C.customer_id = O.customer_id
and C.city = 'Boulder'
order by O.order_date

---- 6. Get the sales by staffs and years using the AVG() aggregate function.


select S.first_name, S.last_name, 
YEAR(O.order_date) [Year], 
avg((I.list_price - I.list_price * I.discount) * I.quantity) [Avg_Sale]
from sale.staff S, sale.orders O, sale.order_item I
where S.staff_id = O.staff_id and 
O.order_id = I.order_id
group by S.first_name, S.last_name, YEAR(O.order_date)
order by 1,2,3

select YEAR(O.order_date) [Year], S.first_name, S.last_name,
avg((I.list_price - I.list_price * I.discount) * I.quantity) [Avg_Sale]
from sale.staff S, sale.orders O, sale.order_item I
where S.staff_id = O.staff_id and 
O.order_id = I.order_id
group by S.first_name, S.last_name, YEAR(O.order_date)
order by 1, 2, 3



---- 7. What is the sales quantity of product according 
--to the brands and sort them highest-lowest----

select B.brand_name, P.product_name, count(O.quantity) Quantity 
from product.brand B, sale.order_item O, product.product P 
where B.brand_id = P.brand_id and
O.product_id = P.product_id
group by B.brand_name, P.product_name
order by Quantity DESC;




---- 8. What are the categories that each brand has?----
select B.brand_name, C.category_name 
from product.product P, product.category C, product.brand B
where P.category_id = C.category_id 
and P.brand_id = B.brand_id
group by B.brand_name, C.category_name


---- 9. Select the avg prices according to brands and categories----
select B.brand_name, C.category_name, round(avg(P.list_price),2)
from product.product P, product.category C, product.brand B
where P.category_id = C.category_id 
and P.brand_id = B.brand_id
group by B.brand_name, C.category_name


---- 10. Select the annual amount of product produced according to brands----

select B.brand_name, P.model_year, COUNT(P.product_id) Total
from product.product P, product.brand B
where P.brand_id = B.brand_id
group by P.model_year, B.brand_name
order by B.brand_name, P.model_year

select *
from product.product P, product.brand B
where P.brand_id = B.brand_id and
B.brand_name = 'Apple' 
and P.model_year='2018'


SELECT  model_year
FROM product.product


select *
from product.product P, product.brand B
where P.brand_id = B.brand_id and
B.brand_name = 'Apple' 
and P.model_year='2021'


---- 11. Select the store which has the most sales quantity in 2019.----
select TOP 1 S.store_name, YEAR(O.order_date) [Year], sum(I.quantity) Total
from sale.orders O, sale.store S, sale.order_item I
where S.store_id = O.store_id and O.order_id = I.order_id 
and YEAR(O.order_date) = 2019
group by S.store_name, YEAR(O.order_date)
order by Total DESC;


---- 12 Select the store which has the most sales amount in 2018.----

select TOP 1 S.store_name, YEAR(O.order_date), 
sum((I.list_price - (I.quantity * I.discount))*I.quantity) Total
from sale.orders O, sale.store S, sale.order_item I
where S.store_id = O.store_id 
and I.order_id = O.order_id
and YEAR(O.order_date) = 2018
group by S.store_name, YEAR(O.order_date)
order by Total DESC;




---- 13. Select the personnel which has the most sales amount in 2019.----

select TOP 1 S.first_name, S.last_name, YEAR(O.order_date) Year, 
sum((I.list_price - I.list_price*I.discount)*I.quantity) Total
from sale.staff S, sale.orders O, sale.order_item I
where S.staff_id = O.staff_id
and O.order_id = I.order_id
and YEAR(O.order_date)=2019
group by S.first_name, S.last_name, YEAR(O.order_date)
order by Total DESC;



SELECT TOP(1) A.first_name, A.last_name, SUM(C.list_price) AS [staff sales]
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id
AND B.order_id = C.order_id
AND YEAR(B.order_date) = 2019
GROUP BY A.first_name, A.last_name
ORDER BY SUM(C.quantity) DESC;