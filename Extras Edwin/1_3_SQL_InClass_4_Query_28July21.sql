------------------------------ 28.07.2021 SQL InClass -------------


              --------------- VIEWS -------------------(Önceki derste işlendi. tekrar mahiyetinde buraya alındı)

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

	--subquery den hiç bir farkı yok. subquery içerde kullanılıyor, Ordinary CTE yukarda WITH ile oluşturuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH kısmını yazarsan tek başına çalışmaz. WITH ile belirttiğim query'yi birazdan kullanacağım demek bu. 
-- asıl SQL statement içinde bunu kullanıyoruz.

-- RECURSIVE

	-- UNION ALL ile kullanılıyor.

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



-- Question: List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
	-- and are residents of the city of San Diego.
--(TR) Sharyn Hopkins adlı bir müşterinin son siparişinden önce siparişi olan ve 
	--San Diego şehrinde ikamet eden müşterileri listeleyin

-- bu isimli müşteriyi nerden bulacağım? sales.customers tan.
-- son siparişini nerden bulacağım? sales.orders tan

SELECT MAX(B.order_date) --son sipariş tarihini getirmek için MAX fonksiyonunu kullandım. ORDER BY DESC de yapabilirdim
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'

WITH T1 AS
(
SELECT MAX(B.order_date) LAST_ORDER 
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Sharyn'
AND A.last_name = 'Hopkins'
)

SELECT A.customer_id, A.first_name, last_name, city, order_date
FROM sales.customers A, sales.orders B, T1 C
WHERE A.customer_id = B.customer_id 
AND B.order_date < C.LAST_ORDER
AND A.city = 'San Diego'
-- WITH ile başlayan CTE bloğu tek başına çalıştırırsan hata verir. 
	-- ardından gelen içinde CTE yi kullandığın query ile beraber seçerek çalıştırmalısın.

-- SORU2: 0'dan 9'a kadar her bir rakam bir satırda olacak şekilde bir tablo oluşturun

SELECT 0 number
UNION ALL
SELECT 1

SELECT 0 number
UNION ALL
SELECT 1
UNION ALL
SELECT 2

WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT 1
)

SELECT * 
FROM T1

-------her seferinde aynı tabloyu tekrar tekrar kullanmak istersem:
WITH T1 AS
(
SELECT 0 number
UNION ALL
SELECT number +1 
FROM T1
WHERE  number < 9 --sonsuza kadar yapmaması için ve hata vermemesi için burada limitliyoruz.
)

SELECT * FROM T1


--- WITH ıLE SADECE VAR OLAN DEğERLERDEN BıR TABLO OLUşTURMAK DEğıL, 
	--YENı DEğERLER EKLEYEREK BıR TABLO DA OLUşTURABıLıRıZ


--------------------------- SET----------------------------------

				------- IMPORTANT----------

-- Her iki select statemen da aynı sayıda column içermeli.

-- INTERSECT VE EXCEPT çok önemli. UNION hayat kurtarmaz ama diğer ikisi çok önemli işler yaparlar.

-- UNION ve INTERSECT'te positional ordering önemli değil 
	-- yani hangi tablo önce hangisi sonra geleceğinin önemi yok. 
	-- ama EXCEPT te bu önemli!!!

-- Select statement ta birbirine karşılık gelen sütunların data tipleri aynı olmalı.

-- ORDER BY ile bir sıralama yapmak istiyorsak, ORDER BY'ı son tablonun FROM'unun sonuna yazmalısın.
	-- diğer tabololarda bireysel olarak ORDER BY kullanamazsın!!

-- UNION, dublikasyonları filtreleyip göstermediği için fazladan işlem yapmaktadır. 
	-- fakat UNION ALL bu işlemi yapmadığı (dublikasyonlarla beraber sonuçları getirdiği) için
	-- performans açısından daha iyidir.

-- SÜTUN ıSıMLERı AYNI OLMAK ZORUNDA DEğıLDıR. ıKıNCı TABLONUN SÜTUN ıSıMLERı FARKLI ıSE; 
	-- UNION ıLE YAPTIğIMIZ SORGU SONUCU; SONUÇ TABLOSUNUN SÜTUN ıSıMLERı ıLK TABLONUN SÜTUN ıSıMLERı OLUR!!



-- SET-SORU 1: Sacremento şehrindeki müşteriler ile Monroe şehrindeki müşterilerin soyisimlerini listeleyin

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'
-- 6 tane satır geldi.

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 11 satır geldi. şimdi iki tabloyu birleştirelim

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 17 sonuç geldi. Rasmussen soyadı iki defa tekrar etmiş. şimdi UNION ile yapacağım ve tekrarı almayacak.

-- aynı işlemi UNION ile yaparsak dublikasyonu göz önüne alarak işlem yapacak ve:
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'
-- 16 satır getirecektir.

-- soyisimle birlikte ismi de select satırında getirirsek...
SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Monroe'
-- iki Rasmussen soyadının farklı isimleri olduğundan UNION'da da 17 satır getirdi. çünkü artık tekrar eden satır yok.

-- Another Way 'OR' 'IN'
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento' or city = 'Monroe'

SELECT last_name
FROM sales.customers
WHERE city IN ('Sacramento', 'Monroe')


-------------------------
-------------------------

SELECT city
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- sonuç tablosunda ilk tablonun sütun ismini aldığına dikkat et!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state
from sales.stores
-- ilk tabloya select te bir sütun daha çağırdık. şimdi ilk tablodan 2, ikinciden 1 sütun çağırmış olduk.
-- iki sorgunun da aynı sayıda sütun içermesi gerektiğinden bu hata verdi!!

SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 'BALDWIN' AS city
from sales.stores
-- iki tablonun isimleri ve içerikleri farklı olsa da ikisini de birleştirdi.
-- çünkü önemli olan sütun sayılarının aynı olması. 
-- UNION ıLE SORGU SONUCU; SONUÇ TABLOSUNUN SÜTUN ıSıMLERı ıLK TABLONUN SÜTUN ıSıMLERı OLUR!!


SELECT city, 'STATE' AS STATE
from sales.stores

UNION ALL

SELECT state, 1 AS city
from sales.stores
-- iki tablonun data tipleri farklı olduğundan hata verdi!!!




-- SET- SORU 2: write a query that returns brands that have products for both 2016 and 2017

SELECT *
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT *
FROM production.products
WHERE model_year = 2017
-- SELECT * ıLE TÜM SÜTUNLARI ÇAğIRDIğIMIZ ıÇıN BÜTÜN SÜTUNLARIN ıÇıNDEKı DEğERLERı 
	--KESışTıRMEYE ÇALIşIYOR AMA KESışTıREMıYOR BU YÜZDEN BıR DEğER DÖNDÜREMıYOR.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
-- gördüğün gibi brand_id sütunlarını kesiştirdi ve sonuç getirdi.

SELECT brand_id
FROM production.products
WHERE model_year = 2016

INTERSECT

SELECT brand_id
FROM production.products
WHERE model_year = 2017
ORDER BY brand_id DESC  -- ORDER BY SATIRINI BURADAKı GıBı EN ALTTA KULLANMALIYIZ.


SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2016

INTERSECT

SELECT DISTINCT A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2017
-- INTERSECT TE DISTINCT KULLANMANA GEREK YOK!! O ZATEN DISTINCT YAPAR!!

-- Yukarda INTERSECT ile yaptığımız SET operation'u şimdi de bir subquery olarak kullanalım.
	-- ve brands tablosunda brand_id'lerin bu operation sonucu gelen id'ler olmasını sağlayalım.
SELECT *
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year= 2017
					)
-- production.brands tablosunda yalnızca brand_id ve brand_name olduğu için bir üstteki sorguya ilave olarak
	-- brand_name'i getirmiş oldukk.



-- SET-SORU 4: write a query that returns customer who have orders for each 2016, 2017, and 2018
-- (TR) 2016, 2017 ve 2018 için siparişleri olan müşteriyi döndüren bir sorgu yazın.


SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31' 

INTERSECT

SELECT customer_id
FROM sales.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
-- buraya kadar sadece customer_id leri getirdik. ancak customer isimleri istiyordu.
	-- bunu sales.custormers tablosundan alacağım. 

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)
-- az önceki INTERCEPT ettiğim (ve customer_id'leri getiren) tabloları subquery yaptım ve 
	-- where de customer_id IN (subquery) kullanarak sales.customers tablosundan isim, soyisim sütunlarını getirdim.



------------- EXCEPT------------
--TABLE A dan TABLE B'yi çıkartmak istiyorsan TABLE A'yı YUKARIYA yazmalısın.


-- SORU 5: Write a query that returns only products produced in 2016 (not ordered in 2017)

SELECT brand_id, model_year, product_name
FROM production.products
ORDER by 1
-- yıllara baktığımıda 2017 de olup diğer yıllarda üretilmeyen modelleri görebiliyoruz. bunların peşindeyiz.

SELECT brand_id
FROM production.products 
WHERE model_year = 2016
-- bu brandlerden 2017 de de üretilenleri çıkartmak istiyorum.


SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017
ORDER BY 1
-- 3, 4 ve 5 brand_id si olan markaların sadece 2016 yılı üretimleri olduğunu gördüm.
-- çünkü diğerleri 2017 de de üretildiği için EXCEPT ile çıkarıldı.


-- peki bir EXCEPT daha kullanarak 2018 yılında üretilenleri de çıkartabilir miyiz?:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2018
ORDER BY 1
-- iki EXCEPT kullanarak 2017 ve 2018 leri 2016'lardan çıkatmış olduk.

-- ikinci blokta 2017 ile 2018 yıllarını beraber condition'a sokarsak:
SELECT brand_id
FROM production.products 
WHERE model_year = 2016

EXCEPT

SELECT brand_id
FROM production.products 
WHERE model_year = 2017 or model_year = 2018
ORDER BY 1


--şimdi brand isimlerini de getirelim. products tablosunda brand name yok. bunun için production.brands tablosuna gideceğiz.
SELECT	*
FROM	production.brands 
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					EXCEPT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;


-- SORU 6 : write a query that returns only products ordered in 2017 (not ordered in other years)

SELECT *
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'
-- buraya kadar sadece 2017 de sipariş verilen ürüleri getirdik. 
	--ama bu ürünlerden 2017 haricinde sipariş edilen varsa bunları çıkartmamı istiyor

SELECT DISTINCT B.product_id --product_idlerin tekrarlarını önledik. aşağıdaki şartları sağlayan kaç farklı product_id var onu görmek için. 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date BETWEEN '2017-01-01' and '2017-12-31'

EXCEPT

SELECT DISTINCT B.product_id 
FROM sales.orders A, sales.order_items B
WHERE A.order_id = B.order_id
AND A.order_date NOT BETWEEN '2017-01-01' and '2017-12-31' --2017 dışındakiler için NOT BETWEEN DEDıK!!!! 

--şimdi bu ürünlerin isimlerini de products tablosuna müracaat ederek getirelim.
SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date BETWEEN '2017-01-01' AND '2017-12-31'
					EXCEPT
					SELECT	DISTINCT B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date NOT BETWEEN '2017-01-01' AND '2017-12-31'
					)


-- C8329 JOSEPH HOCANIN KODU:
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and year(order_date) = 2017
except
select A.product_id, a.product_name
from production.products A, sales.orders B, sales.order_items C
where A.product_id = C.product_id
and B.order_id = C.order_id
and YEAR(order_date) <> 2017


-----------------------------------
-- NOT EXISTS YERıNE EXCEPT KULLANABıLıYORUZ:

SELECT DISTINCT state
FROM sales.customers X
WHERE NOT EXISTS (
					SELECT DISTINCT D.STATE -- BURAYA HERHANGı BıR RAKAM KOYABıLıRSıN. SELECT SATIRINA BAKMIYOR
					FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
					WHERE A.product_id = B.product_id
					and B.order_id = C.order_id
					and C.customer_id = D.customer_id 
					and A.product_name = 'Trek Remedy 9.8 - 2017'
					and X.state = D.state  -- dış query deki customers tablosu ile burdakini de join ediyor gibi..
					) 

-- ÖNCEKı DERS YAPILAN YUKARDAKı ÖRNEKTE NOT EXISTS YERıNE EXCEPT KULLANIRSAK:

SELECT	D.STATE
FROM	sales.customers D

EXCEPT

SELECT	D.STATE, A.product_name
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'
-- Alttaki sorguda Trek Remedy 'in satın alındığı state leri getirdiğine göre. 
-- EXCEPT ile kullandığımnızda Trek Remedy 'in satın alınmadığı state i bulmuş olduk.
-- ( üstteki sorguda customer ların state'lerinin tamamını getiriyor.

-------------------------------------------------------------------------

-------------------CASE EXPRESSION-------------------

--CASE-SORU 1 : Generate a new column containing what the mean of the values in the Order_Status column
	-- 1= Pending; 2= Processing, 3 = Rejected, 4 = Completed

SELECT order_status,
		CASE order_status WHEN 1 THEN 'Pending'  -- order_status'u WHEN'in dışında kullandığımız için bu zaten eşittir anlamına geliyor
							WHEN 2 THEN 'Processing' -- eğer WHEN'in içinde kullansaydık yanına = koymamız gerekecekti.
							WHEN 3 THEN 'Rejected'
							WHEN 4 THEN 'Completed'
		END AS meanofstatus
FROM sales.orders


-- CASE-SORU 2: -- Create a new column containing the labels of the customers' email service providers
	-- ( "Gmail", "Hotmail", "Yahoo" or "Other" )

select email from sales.customers

SELECT email, 
	CASE	   WHEN email like '%gmail%' THEN 'GMAIL'
			   WHEN email like '%hotmail%' THEN 'HOTMAIL'
			   WHEN email like '%yahoo%' THEN 'YAHOO'
			   ELSE 'OTHER'
	END AS email_service_providers
FROM sales.customers


-- Add a column to the sales.staffs table containing the store names of the employees.(CHINOOK DATABASE)

select *
from sale.staff

SELECT first_name, last_name, store_id,
		CASE store_id
			WHEN 1 THEN 'Davi techno Retail'
			WHEN 2 THEN 'The BFLO Store'
			ELSE 'Burkes Outlet'
		END store_name
FROM sale.staff



--- CASE'in WHERE'DE NASIL KULLANABıLECEğıMıZı ÇALIş. NE şEKıLDE KULLANABıLıRıZ?
