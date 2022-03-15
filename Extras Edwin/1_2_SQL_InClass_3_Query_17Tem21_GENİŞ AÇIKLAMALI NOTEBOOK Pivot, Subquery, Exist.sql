------DAwSQL 17.07.2021 Session 3 (Organize Complex Queries)-------

-- Bir tabloda meydana gelen sonucu başka bir tablo veya işlem için kullanmak için 3 yöntem:
	-- Subqueries
	-- Views
	-- Common Table Expression (CTE's)

-- subqueries, SELECT, FROM ve WHERE satırlarında kullanılabiliyor.
	-- WHERE'de subquery sonucunda dönen ifadelere göre ana tablo üzerinden bir filtreleme yapacağın anlamına geliyor.
		--WHERE'in her zaman ana tablo üzerinde filtreleme yaptığını unutma!
	-- SELECT'te subquery içindeki değeri SELECT satırında döndürmek için kullanılıyor
	-- SELECT satırındaki subquery TEK BıR SÜTUN VEYA SATIR DÖNDÜRMEK ZORUNDA! (sadece bir değer döndürmeli)
	-- FROM da subquery bir tablo getirmesi lazım. başka kıstaslara göre bir tablo oluşuruyor ve bunu Fromda kullanmak üzere getiriyor.

	-- SUBQUERY ÇEşıTLERı
		-- Single-row  : Tek bir satır döndürür. SELECT'te kullanılan gibi. 
		-- Multiple-row: Birden fazla değer döndüren subquery
		-- Correlated : üstteki sorgu ile alltaki sorgunun birbiri ile eşlenerek bağlantı kurulduğu subquery

	-- SINGLE-ROW SUBQUERY
		-- =, <, >, >=, <=, <>, != operatörleri ile özellikle WHERE satırında kullanılan subquerylerdir.


-------------- PIVOT -----------

-- Pivot, satır bazlı analiz sonucunu sütun bazına dönüştürülmesini sağlıyor. 
	-- group by gibi bir gruplama yapıyor. dolayısıyla group by kullanmıyoruz, pivota özel bir syntax kullanıyoruz
	-- bu syntax içerisinde aggregate işlemi yapıp ilgili sütunlardaki kategorilere göre bir pivot table oluşturuyor.
	-- ve o sütunun satırlarını oluşturan her bir kategoriyi birer sütuna dönüştürüyor. 
	-- yani satırlardaki value'lar sütunlarda sergileniyor

-- Pivot tablosunda sütun ve value olarak gözükmesini istediğim sütunları (feature'ları) Pivot'un üstündeki SELECT satırına ekliyorum.
	--Bunlardan VALUE olacak olan sütununa Pivot ile başlayan kod bloğunda AGGRAGATE işlemi uyguluyorum.
	-- Unutmayalım ki pivot table, group by işleminin aynısını yapıyor. Aggregate işlemi de oradan geliyor.

-- Eğer kaynak tablomdaki bir sütun hem value'lar için kullanılacak (aggregate yapılacak) hem de ayrı bir boyut olarak kullanılacak ise;
	-- SELECT satırında bu sütun iki kere yazılmalı (biri ilave boyut için diğeri value'ları oluşturmak için)
	-- Fakat "The column 'xxxxxx' was specified multiple times" hatası almamak için birine "Alias" (takma ad) verilmeli!!! Örneği aşağıda 

--SYNTAX
SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM
table_name
PIVOT
(
aggregate_function(aggregate_column)
FOR pivot_column
IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;


--ÖRNEK:

SELECT *
FROM sales.sales_summary

-- önce kaynak tabloyu oluşturuyoruz. ben pivot table'ı veya aggregate işlemini hangi tablodan oluşturmak istiyorum?
-- ben kategorilere göre toplam fiyatları bulmak istiyorum.
SELECT category, SUM(total_sales_price) as total
FROM sales.sales_summary
GROUP BY Category

-- şimdi category sütununun satırlarını (bisiklet kategorilerini) sütunlara alacak 
-- ve total_sales_price'ları value olarak satırlara getirecek şekilde pivot table yapalım

-- pivot tablonun sütun isimlerini almak için aşağıdaki iki query de kullanılabilir:
select distinct category
from sales.sales_summary

select distinct '['+ category + '],'
from sales.sales_summary

SELECT *
FROM sales.sales_summary
PIVOT
(
	SUM(total_sales_price) 
	FOR category IN  -- burada belirlediğimiz pivot column'un, grupladığımız column olduğuna dikkat et.
	(
	[Children Bicycles], -- category sütunu altında bu kategoriler vardı. bunlar pivot table ın sütunları olacak.
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE  -- pivot table'a bir isim vermemiz gerekiyor.

-- şimdi son dokunuşlarla bu kodu biraz daha spesifik hale getirelim.

-- önce kaynak tabloyu belirtiyoruz. kaynak tablom bu query:
SELECT Category, total_sales_price
FROM sales.sales_summary


--- şimdi Pivot işlemi sonucunda ortaya çıkacak tablo için  bir SELECT işlemi daha yapmam gerekiyor.
SELECT *  
FROM (
		SELECT Category, total_sales_price  -- bu parantezin içi kaynak tablom.
		FROM sales.sales_summary
	 ) A
PIVOT
(
	SUM(total_sales_price)
	FOR category	-- pivot sütunumuz category, ve value'larımız bu sütundaki bisiklet modelleri olacak
	IN(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE



-- ben buna bir boyut daha eklemek istersem..
	-- category sütununa göre gruplamıştık. bir de model_year gruplaması olsun.
SELECT category, model_year, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1  -- bir de order by ekleyelim güzel gözüksün.
	/* şimdi bir kırılma daha bir boyut daha eklemiş olduk. önceden sadece
kategorilere göre ayırım yapıyordu şimdi ise kategorilerin içinde 
model yıllara göre de ayırım yaptık.*/

-- model_year boyutunu pivot table'a ekleyip görelim.
	-- kaynak tablomun SELECT satırına model_year sütununu eklemeliyim.
SELECT category, Model_Year, total_sales_price 
			FROM SALES.sales_summary

SELECT *
FROM
			(
			SELECT category, Model_Year, total_sales_price --model_year eklendi.
			FROM SALES.sales_summary
			) A
PIVOT
(
	SUM(total_sales_price)
	FOR category IN
	(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE
-- görüldüğü gibi görsel olarak çok rahat okunan bir tablo elde ettik.


-- -------------------
CREATE VIEW Brands_Categories AS
SELECT	category_name, brand_name
FROM
	(
	SELECT
		C.category_name AS category_name,
		A.brand_name AS brand_name
	FROM production.brands A, production.products B, production.categories C
	WHERE A.brand_id = B.brand_id AND B.category_id = c.category_id
	GROUP BY C.category_name, A.brand_name
	) A
;

SELECT *
FROM
	(
	SELECT	category_name, brand_name
	FROM	Brands_Categories
	) A
PIVOT
(
COUNT(brand_name)
FOR	category_name
IN	(
	[Children Bicycles],
        [Comfort Bicycles],
        [Cruisers Bicycles],
        [Cyclocross Bicycles],
        [Electric Bikes],
        [Mountain Bikes],
        [Road Bikes]
	)
) AS PIVOT_TABLE

-- BU PıVOT TABLOSUNDA MARKA ıSıMLERıNı DE AYRI BıR BOYUT OLARAK KATALIM.
	-- Bunun için brand_name'i SELECT'te eklemem yeterli. ancak orada brand_name aggregate işlemi için yani
	-- value'ler için kullanıldığı için ikinci kez eklediğimde buna Alias vermem gerekiyor!!
SELECT	category_name, brand_name, brand_name as brand_name
	FROM	Brands_Categories

SELECT *
FROM
	(
	SELECT	category_name, brand_name AS BRAND_NAMES, brand_name -- 2. kere kullandığımda brand_name'e alias verdim.
	FROM	Brands_Categories
	) A
PIVOT
(
COUNT(brand_name)
FOR	category_name
IN	(
	[Children Bicycles],
        [Comfort Bicycles],
        [Cruisers Bicycles],
        [Cyclocross Bicycles],
        [Electric Bikes],
        [Mountain Bikes],
        [Road Bikes]
	)
) AS PIVOT_TABLE





----------------------- KONU: SUBQUERY -----------------

-- SORU 1 : Bring all the personnels from the store that Kali Vargas works.
-- (TR) Kali Vargas'ın çalıştığı mağazadan tüm personeli getirin.

------------SINGLE ROW SUBQUERIES----------------

SELECT *
FROM sales.staffs --tüm çalışanları ve çalıştıkları mağazaları getirdim. 8.satırda Kali Vargası ve çalıştığı store'un id sini görebiliyorum.

SELECT *
FROM sales.staffs
WHERE first_name = 'Kali' AND last_name = 'Vargas' 
-- staffs tablosunda first_name Kali ve last_name Vargas olan satırı getir dedik.
-- ve store_id sinin 3 olduğunu gördük. Aşağıda WHERE store_id=3 d e diyebiliriz.

-- staffs tablosunda store_id= (subquery'den gelen store_id) şeklinde bir query kuracağız.
SELECT *
FROM sales.staffs
WHERE store_id = (SELECT store_id
				  FROM sales.staffs
				  WHERE first_name = 'Kali' and last_name = 'Vargas')




-- SORU 2: List the staff what Venita Daniel is the manager of.
-- (Tr) Venita Daniel'in yöneticisi olduğu personeli listeleyin.

-- Venita Daniel'in staff_id si kimin manager_id'si ise onları listeleyeceğiz.
SELECT *
FROM sales.staffs
WHERE manager_id = (                -- Venita'nın staff id sinin manager_id si olan personeli tanımladık.
					SELECT staff_id		
					FROM sales.staffs
					WHERE first_name = 'Venita' AND last_name = 'Daniel' -- subquery'de Venita'nın staff id sini çektik.
					)

-- alternatif çözüm (self join ile):
SELECT A.*
FROM sales.staffs A, sales.staffs B
WHERE A.manager_id = B.staff_id
AND B.first_name = 'Venita' AND B.last_name = 'Daniel'
-- burada A.manager_id = B.staff_id dediğimiz için (yani A'nin manager_id'si B'nin staff_id'si olanlara eşit olma durumu) B.first_name='Venita' yaptık. 
	-- eğer A.first_name='Venita' deseydik (yani A'daki first_name Venita olsun deseydik) Venita'nın manager'ını getirirdi bize.



-- SORU 3: Write a query that returns customer in the city where the 'Rowlett Bikes' store is located.
-- (TR) 'Rowlett Bikes' mağazasının bulunduğu şehirde müşteriyi döndüren bir sorgu yazın.

-- önce Rowlet Bikes store'un bulunduğu city'i bulalım. (sales.stores tablosunda city isimleri var)
SELECT city
FROM sales.stores
WHERE store_name = 'Rowlett Bikes' 
-- Rowlet şehrinde olduğunu gördük. bu query aşağıda ana query'mizin subquery'si olacak.

-- şimdi sales.custormers tablosunda city=Rowlet olan verileri görelim.
SELECT *
FROM sales.customers
WHERE city= (
			SELECT city
			FROM sales.stores
			WHERE store_name = 'Rowlett Bikes'
			)



-- SORU 4: List bikes that are more expensive than the 'Trek CrossRip+ - 2018' bike
-- TR: 'Trek CrossRip - 2018' bisikletinden daha pahalı olan bisikletleri listeleyin

--önce subquery'i belirlemekle başlayalım. bahsedilen bisikletin fiyatını çekelim.
select list_price
from production.products 
where product_name = 'Trek CrossRip+ - 2018',

-- şimdi listenmesi istenen sütunların hangi listelerde olduğuna bakarak o listeleri join edeceğim 
	-- ve subquery'i WHERE satırında yerine koyarak query'mi oluşturacağım.
	-- istenen sütunlar: product_id, product_name, model_year, list_price, brand_name, category_name
SELECT DISTINCT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')
-- WHERE satırımda hem listelerimi join ettim hem de SUBQUERY kullanarak filtreleme şartımı ekledim.
-- DISTICT attım ki tekrarlayan sütunlar gelmesin. 
	-- Ancak burda DISTINCT atmadan da aynı sonuca ulaşıyorum, çünkü tekrar yok. 
	-- DISTINCT maliyetli bir iş, SQL e ekstra işlem ve yük getiren bir iş bu yüzden burda DISTINCT kullanmamam lazım. 
	-- Genelde DISTINCT'i bir aggregation işlemi yapmıyorsak en son sonuç tablosunda, sonuç select'in de kullanırız. 
	-- önceki select lerde kullanmayız.





-- SORU 5: List customers who orders previous dates than Arla Ellis.
-- (TR) Arla Ellis'ten önceki tarihlerde sipariş veren müşterileri listeleyin.

-- önce Arla Ellis'in sipariş verdiği tarihi bulalım ki onu ana query de subquery olarak kullanabilelim. 
	-- tarihler orders tablosunda, isimler customers tablosunda olduğu için orders ve customers tablolarını birleştirmem gerekiyor.
SELECT *
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
and A.first_name = 'Arla' and A.last_name='Ellis'
-- bu isimle tek bir customer var ve bir order var
-- bu sorgunun sonuçlarından order_date i alacağım ve bu sonucu da subquery yapıp 
-- aradığımız order_date'in bu subquery'den gelen date'ten önce olma durumunu < operatörü ile sorgulayacağız.


-- şimdi istenen sütunlarla birlikte query'mizi yazalım ve WHERE satırındaki condition'da yukardaki subquery'i kullanalım.
SELECT A.customer_id, A.first_name, A.last_name, B.order_date
FROM sales.customers A, sales.orders B
WHERE order_date < (
					SELECT B.order_date
					FROM sales.customers A, sales.orders B
					where A.customer_id = B.customer_id
					and A.first_name = 'Arla' and A.last_name='Ellis'
					)

--------------- MULTIPLE ROW SUBQUERIES -------------------
	--Birden çok değer döndüren subquerylerdir.
	-- Birçok değer içerisinden bir değer arıyor ve onlar içerisinde bir filtreleme yapacaksam IN, NOT IN, ANY ve ALL operatörlerini kullanıyorum.

					

-- SORU 6 : List order dates for customers residing in the Holbrook city.
-- (TR) Holbrook şehrinde oturan müşterilerin sipariş tarihlerini listeleyin.

-- bunu JOIN ile de yapabiliriz ama buda subquery ile yapacağız.

-- önce Holbrook şehrindeki customer id leri görelim.
select customer_id
from sales.customers 
where city='Holbrook'

-- orders tablosunda 1615 order_date var.
SELECT order_date
FROM sales.orders

-- yukardaki query'i subquery yaparak order_date'i filtreleyelim 
	--ve sadece Holbrook şehrinde yaşayan customer'ların order_date lerini getirsin.
SELECT order_date
FROM sales.orders
WHERE customer_id IN (
					SELECT customer_id
					FROM sales.customers 
					WHERE city='Holbrook'
					)
-- Holbrook şehrinde yaşayan müşterilere ait 3 order_date olduğunu gördüm.

-- NOT IN ile yaparsak Holbrook dışında yaşayanların tarihlerini getirecektir.
SELECT order_date
FROM sales.orders
WHERE customer_id NOT IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )




-- SORU 7: List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes.
-- (TR) Ürünleri Cruisers Bicycles, Mountain BikeS veya Road Bikes DIşINDAKı kategorilerde listeleyin.


SELECT category_id
FROM	production.categories
WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
-- bu kategorilerin categori id lerini çektim. bunu ana query de WHERE satırında kullanacağım.

SELECT *
FROM production.products A, production.categories B
WHERE A.category_id = B.category_id and category_name IN (
							SELECT category_name
							FROM production.categories
							WHERE category_name NOT IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
order by product_id --buna gerek yoktu, sıralı olması için kullandım.
-- aslında benden sadece product ları istediği için burada category_id ve category_name sütunlarını getirmeme gerek yoktu. 
	-- bu durumda fazladan bir join işlemi yapmış oldum. 
	-- joinsiz olarak çözüm daha az maliyetli olacaktır ve kesinlikle o şekilde tercih edilmelidir.

-- JOIN yapmaksızın sadece products tablosu ile çözüme ulaşalım
SELECT	product_name, list_price, model_year --bu sütunlar yeterli olacaktır.
FROM	production.products
WHERE	category_id NOT IN (       
							SELECT category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
-- dikkat edersen önceki çözümde subquery'de NOT IN kullandım WHERE satırında IN kullandım. 
	--burada ise tam tersini yaptım.

-- ayrıca subquery deki SELECT satırında * veya birden fazla sütun belirtemeyiz hata verir.
	-- çünkü bu subquery ile ana query'nin WHERE satırında category_id lere bir condition sağlayacağımdan,
	-- subquery sadece category_id sütunu döndürmelidir.


-- sadece 2016 yılına ait sonuçları getirmek istersek:
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
						SELECT category_id
						FROM	production.categories
						WHERE	category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
							)
AND model_year = '2016'  -- WHERE satırında bir filtreleme daha yaptım. AND ile istediğim kadar filtreleme yapabilirim.





-- SORU 8: Elektrikli bisikletlerden daha pahalı olan bisikletleri listeleyin.

-- önce subquery'mizi yazalım. electric bikes'ların fiyatlarını getirelim.
SELECT A.*, B.product_name, B.list_price
FROM production.categories A, production.products B
WHERE A.category_id = B.category_id 
AND A.category_name = 'Electric Bikes'

-- benim ilgilendiğim list_price'lar olduğundan list_price sütununu çekiyorum.
SELECT B.list_price
FROM production.categories A, production.products B
WHERE A.category_id = B.category_id 
AND A.category_name = 'Electric Bikes'

-- şimdi asıl sorgumuzu yazalım:
SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price > (           
					SELECT	B.list_price
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
-- "subquery returned more than 1 value" hatası verdi. çünkü > operatörü karşısında bir tek value ister.
	-- Aşağıdaki queryde "ALL" komutu ile bunu çözüyoruz.

SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price > ALL (               -- elektrikli bisikletlerin tümünden daha pahalı olanları getir.
					SELECT	B.list_price  -- yani en pahalı elektrikli bisikletten daha pahalı olanları getiriyor.
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
-- ALL yazarak, subquery deki BÜTÜN fiyatlardan daha yüksek olanlarınkini filtreliyoruz. 
	-- Dolayısıyla tek bir value olmasa da bu subquery'i kabul ediyor.

-- elektriklik bisikletlerden herhangi birinden daha pahalı olan bisikletleri listeleyin
SELECT	product_name, model_year, list_price
FROM	production.products
WHERE	list_price >  ANY (             -- elektrikli bisikletlerin herhangi birinden daha pahalı olanları getir.
					SELECT	B.list_price  --her bir elektrikli bisikletten daha pahalı olanları getiriyor.
					FROM	production.categories A, production.products B
					WHERE	A.category_id = B.category_id
					AND		A.category_name = 'Electric Bikes'
					)
--Elektrikli bisiklet kategorisindeki herhangi birinden daha yüksek fiyatlı olanları getiriyor.

-- Aslında ALL dediğimizde maksimum fiyatlı olandan daha yüksek fiyatlı olanları, 
-- ANY dediğimizde ise minimum fiyatlı olandan daha yüksek fiyiatlı olanları getirmiş oldu.


,

		--------------- CORRELATED SUBQUERIES ------------------

		-----------------EXISTS & NOT EXISTS -------------------

		-- SUBQERY ile ana QUERY tablolarının birbiri ile join edilmesi, birbirine bağlanmasıdır.

--- Bunlar genelde EXISTS ve NOT EXISTS ile kullanılıyor.

-- EXIST kullandığın zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIşTIR anlamına geliyor
-- NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIşTIRMA anlamına geliyor



-- SORU : Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered.
-- (TR) 'Trek Remedy 9.8 - 2017' ürününün sipariş edilmediği State'leri getir.


-- bu ürünün product_name'i elimde. yani products tablosunu kullanacağım. 
	--istenen ise bunun State'i, o da sales.customers tablosunda,
	-- bu iki tabloyu sales.order_items ve sales_orders tabloları üzerinden birbirine bağlayacağım.
SELECT D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE A.product_id = B.product_id and B.order_id = C.order_id and C.customer_id = D.customer_id
and A.product_name = 'Trek Remedy 9.8 - 2017'
-- 14 state var ama birbirini tekrar edenler de var. Bu yüzden DISTINCT çekiyorum

SELECT DISTINCT D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE A.product_id = B.product_id 
and B.order_id = C.order_id 
and C.customer_id = D.customer_id
and A.product_name = 'Trek Remedy 9.8 - 2017'
-- şimdi bu product ismiyle 2 state'ten sipariş verildiğini gördüm.


SELECT DISTINCT state
FROM sales.customers
WHERE state NOT IN (
					SELECT DISTINCT D.STATE -- BURADA DISTINCT'e gerek yok.
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017')					
-- NOT IN ile bu product'ın siparişinin verildiği (çünkü state'i sales.customers tablosundan çekiyoruz) state'lerin dışında kalan state'leri getir demiş olduk.


----- Ya NOT IN yerine NOT EXISTS kullanırsam:

SELECT DISTINCT state
FROM sales.customers
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'	
					)
-- Hata verdi. çünkü EXISTS kullanırsan subquery ile query'i join yapmanız gerekir

--query'leri sales.customer üzerinden joinleyelim:
SELECT DISTINCT state
FROM sales.customers X
WHERE EXISTS (
					SELECT DISTINCT D.STATE
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state
					) 
-- EXISTS ile demiş olduk ki: Subquery ile yukardaki ana tablonun ilgili değerleri eşleşiyorsa bu EXISTS bir değer döndürüyor.
	-- Yukardaki customer tablosunun state i ile subquery deki state eşitse bana onları getir diyorum
	
-- NOT EXISTS deseydik : eğer eşitlenenler varsa bunları getirme, bunlar olmasın diyorum. Yani burda NOT IN gibi davranıyor.
SELECT DISTINCT state
FROM sales.customers X
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE -- BURAYA HERHANGı BıR RAKAM KOYABıLıRSıN. SELECT SATIRINA BAKMIYOR
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state
					) 

--Bakın aşağıda subquery'nin SELECT satırına 1 yazdım. yine aynı sonucu verdi.
-- Çünkü EXISTS, subquery'nin SELECT ifadesinde çağırdığınız değerlerle ilgilenmiyor,
-- sadece buranın sonuç döndürüp döndürmediğiyle ile ilgileniyor.
-- yani sonda yazdığımız X.state=D.state joini ile ilgileniyor.
-- Aşağıdaki query de:
-- NOT EXISTS --> X.state = D.state ile eşitlenenleri getirme diyor.
-- EXIST -------> eşitlenenlerı getirebilirsin.
SELECT	DISTINCT STATE
FROM	sales.customers X
WHERE NOT EXISTS 	(
						SELECT	1
						FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
						WHERE	A.product_id = B.product_id
						AND		B.order_id = C.order_id
						AND		C.customer_id = D.customer_id
						AND		A.product_name = 'Trek Remedy 9.8 - 2017'
						AND		X.state = D.state
						)



              --------------- VIEWS -------------------

-- Subquery'ler, CTE(Common Table Expression)'lar, VIEW'lar hep aynı amaca hizmet ediyor. Tablolarla daha rahat çalışmamızı sağlıyorlar. ,
	-- Diğer bir avantajı da performansı artırmaktır. Siz query'nizi joinlerle tek bir query içinde değil, subery lerle, CTE'lerle,
	-- VIEW'larla daralta daralta (daraltılmış tablolarla) sonuca gitmeye çalışıyorsunuz.
				-----------AVANTAJLARI:-------------
	--        Performans + Simplicity + Security + Storage 
	
	-- VIEW : Tek bir tabloda yapacağımız işlemleri aşamalar bölerek yapmamızı sağlıyor. Bu da hızımızı arttırıyor.
	-- VIEW ile aynı tablo gibi oluşturuyoruz ve bu VIEW'a kimleri erişebileceğini belirleyebiliyoruz. bu da security sağlıyor.
	-- VIEW'ların kullanımı da oluşturması basittir. büyük tablonun içerisinde biz bir kısım ilgilendimiz verileri alıp onlar üzerinden çalışıyoruz.
	-- VIEW'lar çok az yer kaplar. çübkü asıl tablonun bir görüntüsüdür.


			-------------- CTE - COMMON TABLE ESPRESSIONS -------------

-- Subquery mantığı ile aynı. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazıyoruz.

--(CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir. 
-- Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.

--ORDINARY
WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement
-- sadece WITH kısmını yazarsan tek başına çalışmaz. WITH ile belirttiğim query'yi birazdan kullanacağım demek bu. 
-- asıl SQL statement içinde bunu kullanıyoruz.

-- RECURSIVE
WITH table_name (colum_list)
AS
(
	-- Anchor member
	initial_query
	UNION ALL
	-- Recursive member that references table_name.
	recursive_query
)
-- references table_name
SELECT *
FROM table_name

-- WITH ile yukarda tablo oluşturuyor, aşağıda da SELECT FROM ile bu tabloyu kullanıyor



-- SORU (VIEW): Sipariş detayları ile ilgili bir VIEW oluşturun ve birkaç sorgu içinde kullanın.

-- Müşteri adı soyadı, order_date, product_name, model_year, quantity, list_price, final_price (indirimli fiyat)
-- yukardaki bu bilgileri farklı tablolardan alabiliriz. farklı tablolardan her seferinde aynı sorguyu çalıştırıp bir sonuç almaktansa;
-- bunları ben bir kere kaydedeyim ve tablo güncellendikçe bunlar da güncellensin dediğimde VIEW kullanıyorum.

SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id
-- ben her defasında bu query'i çalıştırmam gerekiyor. Bu da her seferinde arka tarafta aynı işlemlerin yapılması anlamına geliyor.

-- ben bu tabloyu VIEW olarak CREATE etmek istiyorum:

CREATE VIEW SUMMARY_VIEW AS 
SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id

-- istediğim zaman VIEW'ı çağırarak kullanabilirim. 
SELECT *
FROM SUMMARY_VIEW

-- ana tablo güncellendikçe VIEW' da otomatik olarak güncellenir.
-- bu tablo olarak create edildiğinde ana tablodan verileri çekip ekstradan kaydetmiş olacaktım.
	-- ve ana tablodaki değerler güncellendiğinde bu tablo güncellenmemiş olacaktı. 
	-- yani tablo create etmek maliyetli bir işlemdir.


-- Eğer sadece bu session da tablonun create edilmesini istiyorum, session sonunda da tablonun gitmesini istiyorum dersen:

SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
		C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
INTO #SUMMARY_TABLE
FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id
	
SELECT *
FROM #SUMMARY_TABLE



--------------------- BU NOTEBOOK DA GEÇEN ÖNEMLı AÇIKLAMALAR--------------------

-- Bir tabloda meydana gelen sonucu başka bir tablo veya işlem için kullanmak için 3 yöntem:
	-- Subqueries
	-- Views
	-- Common Table Expression (CTE's)

-- subqueries, SELECT, FROM ve WHERE satırlarında kullanılabiliyor.
	-- WHERE'de subquery sonucunda dönen ifadelere göre ana tablo üzerinden bir filtreleme yapacağın anlamına geliyor.
		--WHERE'in her zaman ana tablo üzerinde filtreleme yaptığını unutma!
	-- SELECT'te subquery içindeki değeri SELECT satırında döndürmek için kullanılıyor
	-- SELECT satırındaki subquery TEK BıR SÜTUN VEYA SATIR DÖNDÜRMEK ZORUNDA! (sadece bir değer döndürmeli)
	-- FROM da subquery bir tablo getirmesi lazım. başka kıstaslara göre bir tablo oluşuruyor ve bunu Fromda kullanmak üzere getiriyor.

	-- SUBQUERY ÇEşıTLERı
		-- Single-row  : Tek bir satır döndürür. SELECT'te kullanılan gibi. 
		-- Multiple-row: Birden fazla değer döndüren subquery
		-- Correlated : üstteki sorgu ile alltaki sorgunun birbiri ile eşlenerek bağlantı kurulduğu subquery

	-- SINGLE-ROW SUBQUERY
		-- =, <, >, >=, <=, <>, != operatörleri ile özellikle WHERE satırında kullanılan subquerylerdir.


-------------- PIVOT -----------

-- Pivot, satır bazlı analiz sonucunu sütun bazına dönüştürülmesini sağlıyor. 
	-- group by gibi bir gruplama yapıyor. dolayısıla group by kullanmıyoruz, pivota özel bir syntax kullanıyoruz
	-- bu syntax içerisinde aggregate işlemi yapıp ilgili sütunlardaki kategorilere göre bir pivot table oluşturuyor.
	-- ve o sütunun satırlarını oluşturan her bir kategoriyi birer sütuna dönüştürüyor. yani satırlardaki value'lar sütunlarda sergileniyor


	-- Eğer DISTINCT atmadan da aynı sonuca ulaşıyorsak 
	-- DISTINCT maliyetli bir iş olduğundan ve SQL e ekstra işlem ve yük getirdiğinden DISTINCT kullanmamam lazım. 
	-- Genelde DISTINCT'i bir aggregation işlemi yapmıyorsak en son sonuç tablosunda, sonuç select'in de kullanırız. 
	-- önceki select lerde kullanmayız.


--------------- MULTIPLE ROW SUBQUERIES -------------------
	--Birden çok değer döndüren subquerylerdir.
	-- Birçok değer içerisinden bir değer arıyor ve onlar içerisinde bir filtreleme yapacaksam IN, NOT IN, ANY ve ALL operatörlerini kullanıyorum.


		--------------- CORRELATED SUBQUERIES ------------------

		-----------------EXISTS & NOT EXISTS -------------------

		-- SUBQERY ile ana QUERY tablolarının birbiri ile join edilmesi, birbirine bağlanmasıdır.

--- Bunlar genelde EXISTS ve NOT EXISTS ile kullanılıyor.

-- EXIST kullandığın zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIşTIR anlamına geliyor
-- NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIşTIRMA anlamına geliyor

--Subquery'nin SELECT satırına 1 yazdım. yine aynı sonucu verdi.
	-- Çünkü EXISTS, subquery'nin SELECT ifadesinde çağırdığınız değerlerle ilgilenmiyor,
	-- sadece buranın sonuç döndürüp döndürmediğiyle ile ilgileniyor.

	             --------------- VIEWS -------------------

-- Subquery'ler, CTE(Common Table Expression)'lar, VIEW'lar hep aynı amaca hizmet ediyor. Tablolarla daha rahat çalışmamızı sağlıyorlar. ,
	-- Diğer bir avantajı da performansı artırmaktır. Siz query'nizi joinlerle tek bir query içinde değil, subery lerle, CTE'lerle,
	-- VIEW'larla daralta daralta (daraltılmış tablolarla) sonuca gitmeye çalışıyorsunuz.
				-----------AVANTAJLARI:-------------
	--        Performans + Simplicity + Security + Storage 
	
	-- VIEW : Tek bir tabloda yapacağımız işlemleri aşamalar bölerek yapmamızı sağlıyor. Bu da hızımızı arttırıyor.
	-- VIEW ile aynı tablo gibi oluşturuyoruz ve bu VIEW'a kimleri erişebileceğini belirleyebiliyoruz. bu da security sağlıyor.
	-- VIEW'ların kullanımı da oluşturması basittir. büyük tablonun içerisinde biz bir kısım ilgilendimiz verileri alıp onlar üzerinden çalışıyoruz.
	-- VIEW'lar çok az yer kaplar. çübkü asıl tablonun bir görüntüsüdür.

	-- ana tablo güncellendikçe VIEW' da otomatik olarak güncellenir.
		-- bu tablo olarak create edildiğinde ana tablodan verileri çekip ekstradan kaydetmiş olacaktım.
		-- ve ana tablodaki değerler güncellendiğinde bu tablo güncellenmemiş olacaktı. 
		-- yani tablo create etmek maliyetli bir işlemdir.


	-- Müşteri adı soyadı, order_date, product_name, model_year, quantity, list_price, final_price (indirimli fiyat)
	-- yukardaki bu bilgileri farklı tablolardan alabiliriz. farklı tablolardan her seferinde aynı sorguyu çalıştırıp bir sonuç almaktansa;
	-- bunları ben bir kere kaydedeyim ve tablo güncellendikçe bunlar da güncellensin dediğimde VIEW kullanıyorum.



			-------------- CTE - COMMON TABLE ESPRESSIONS -------------

-- Subquery mantığı ile aynı. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazıyoruz.

--(CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir. 
-- Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.

