select order_id, list_price,
(SELECT AVG(list_price)
from sale.order_item) as [AVG]
from sale.order_item

-- Bring all the staff from the store that Davis Thomas works

select * 
from sale.staff
where store_id = 
(select store_id
from sale.staff
where first_name='Davis' and last_name='Thomas')


--List the staff that Charles Cussoma is manager of..
select * 
from sale.staff
where manager_id = 
(select staff_id
from sale.staff
where first_name='Charles' and last_name='Cussona')


--Write a query that returns customers in the city  where 'The BFLO Store' is located

select first_name, last_name, city from sale.customer
where city = (
select city 
from sale.store 
where store_name = 'The BFLO Store'
)

--list bikes  that are more expensive than  the 
--'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'


select product_id, product_name, model_year, list_price
from product.product
where list_price > (
select list_price
from product.product
where product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')
and 
category_id = (
select category_id
from product.category
where category_name='Televisions & Accessories')

--list all customers who orders on the same date as Laurel Goldammer

select first_name, last_name, 
order_date 
from sale.orders O, sale.customer C
where O.customer_id = C.customer_id
and  O.order_date in (
select order_date
from sale.orders O, sale.customer C
where O.customer_id = C.customer_id
and first_name = 'Laurel'
and last_name ='Goldammer'
)

--list products made in 2021 and their categories other than Game, gps, or Home Theater

select product_id, product_name, model_year from product.product
where model_year = 2021
and category_id not in
	( select category_id from product.category 
	where category_name in ('Game', 'gps', 'Home Theater')
	)


-- List products made in 2020 and its prices more than all
--products in the Receivers Amplifiers category

select product_name, model_year, list_price
from product.product
where model_year=2020
and list_price > all
(
select P.list_price
from product.category C, product.product P
where category_name = 'Receivers Amplifiers'
and C.category_id = P.category_id)
order by list_price DESC;

select product_name, model_year, list_price
from product.product
where model_year=2020
and list_price >
(
select TOP 1 P.list_price
from product.category C, product.product P
where category_name = 'Receivers Amplifiers'
and C.category_id = P.category_id
order by P.list_price DESC)
order by list_price DESC;



select product_name, model_year, list_price
from product.product
where model_year=2020
and list_price > any
(
select P.list_price
from product.category C, product.product P
where category_name = 'Receivers Amplifiers'
and C.category_id = P.category_id)
order by list_price DESC;



--Write a query that returns State where 'Apple - Pre-Owned iPad 3 - 32GB - White'
--product is not ordered
select DISTINCT state 
from sale.customer A
where not exists (
	select * 
	from sale.orders O,
	sale.order_item I,
	product.product P,
	sale.customer C
	where O.order_id = I.order_id 
	and I.product_id = P.product_id
	and P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
	and O.customer_id = C.customer_id
	and C.state = A.state
)



/*EXISTS operatörü, bir alt sorgudaki kayıtların varlığını test eder, 
eğer alt sorgudan kayıt dönüyorsa TRUE değerini döndürür. 
kayıt yoksa FALSE döndürür.
NOT EXISTS operatörü de alt sorgudaki kayıtların varlığını test eder, 
eğer alt sorgudan kayıt dönmüyorsa TRUE döndürür. Kayıt varsa FALSE döndürür.*/

--Write a query that returns customers did not place an order before 2020-01-01

SELECT DISTINCT B.customer_id, B.first_name, B.last_name
FROM sale.orders A, sale.customer B 
WHERE A.customer_id = B.customer_id
    AND NOT EXISTS (
SELECT *
FROM sale.orders C
WHERE order_date < '2020-01-01' AND A.customer_id = C.customer_id);

with table_name as (
select max(B.order_date) last_order_date
from sale.customer A, sale.orders B
where 
A.first_name = 'Jerald'
and A.last_name = 'Berray'
and A.customer_id = B.customer_id
)

select * 
from table_name

; with tablorakam as (
	select 1 rakam
	union all
	select 2 rakam 
	union all
	select 3 rakam
)
select * from tablorakam

; with tablorakam as (
	select 1 rakam
	union all
	select rakam+1
	from tablorakam
	 where rakam<10
)
select * from tablorakam


/*CTE‘ler (Common Table Expressions) nedir ?
CTE (Common Table Expression), geçici olarak var olan ve 
genelde yinelemeli(recursive) ve büyük sorgu ifadelerinde 
kullanım için olan bir sorgunun sonuç kümesi olarak düşünebiliriz.
Veritabanı görünümleri(views) ne benzetebiliriz, ancak hiç bir 
şekilde alanların (field&column) deklare edilmesi gerekmez. 
CTE’lerin sonuçları depolanmaz ve yalnızca işlem süresince var olur.*/

/*CTE’leri nasıl oluştururuz ?
“WITH” keyword’ü ile başlatın.
Tablo olarak kullanacağımız, geçici bir “isim” ataması yapın.
İsim ataması yaptıktan sonra, “AS” ile devam edin.
İsteğe bağlı olarak, field’ların isimlerini yazabilirsiniz (field1,field2)
Sonuç için bir sorgu yazın.
Birden fazla CTE’yi bir araya getirmek için, her CTE’den sonra 
“,” ekleyerek 2–4. adımları tekrarlayın.
“CTE” dizilimi bittikten sonra, CTE’den referans alacak şekilde sorgunuzu yazın.*/