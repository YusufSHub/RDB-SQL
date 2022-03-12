/* ====================================================================================================
									WEEKLY AGENDA 8
  =====================================================================================================*/


  /*									DÝKKAT! 
     QUERY YAZMAYA BAÞLAMADAN ÖNCE DATABASE ÇALIÞILMALI. DATABASE "ER DIAGRAM" ÝYÝCE ÝNCELENMELÝ
     HANGÝ TABLOLARIM VAR, TABLOLARIMDA HANGÝ ALANLARIM (SÜTUNLARIM) VAR, TABLOLARIM HANGÝ FOREIGN KEYLER
	 ÝLE BÝRBÝRÝNE BAÐLANMIÞ (RELATION KURULMUÞ) BUNLAR ÖNEMLÝ! 
	 ÇÜNKÜ SQL DE BÝZ RELATIONAL DATABASE'LER ÜZERÝNDE ÇALIÞIYORUZ VE ARALARINDAKÝ ÝLÝÞKÝYÝ BÝLMEK
	 SORULARIN ÇÖZÜM YOLUNU BELÝRLEMEDE ÇOK ÖNEMLÝDÝR.*/



/*1. List all the cities in the Texas and the numbers of customers in each city.
	Teksas'taki tüm þehirleri ve her þehirdeki müþteri sayýsýný listeleyin */

SELECT COUNT(first_name) AS müþteri_sayýsý
FROM sale.customer

SELECT City, COUNT(customer_id) AS müþteri_sayýsý  -- alan isimleri, allias isimleri vs. arasýnda asla boþluk býrakmýyoruz!
FROM sale.customer								
WHERE state = 'TX'  -- týrnak içinde olan ifadeler her zaman case sensitive! onun dýþýndakiler case insensitive
GROUP BY city;     -- GROUP BY yaptýðým sütun(lar) SELECT statement'da aynen yer almalý!!

/* Alan isimleri, allias isimleri vs. arasýnda asla boþluk býrakmýyoruz!
SQL derleyici boþluða farklý bir anlam yüklüyor. örneðin boþluktan sonra baþka bir keyword bekliyor.
veya alan adý ile allias (AS) yi ayýrmak için boþluk kullanýlýyor. gibi...

Týrnak içinde olan ifadeler (stringler) her zaman case sensitive! onun dýþýndakiler case insensitive

GROUP BY yaptýðým sütun(lar) SELECT statement'da aynen yer almalý!! */



SELECT City, COUNT(customer_id) AS müþteri_sayýsý
FROM sale.customer
WHERE state = 'TX'
GROUP BY city
ORDER BY müþteri_sayýs DESC;
/* ORDER BY için COUNT(customer_id) kullanabileceðimiz gibi, 
bunun alliasýný da kullanabiliriz
veya aþaðýda gösterildiði gibi o sütunun SELECT teki sýra numarasýný da kullanabiliriz.
  ---> ORDER BY 2 DESC; <-----    */


/* 2. List all the cities in the California which has more than 5 customer, 
	by showing the cities which have more customers first.---
	 Kaliforniya'da 40'tan fazla müþterisi olan tüm þehirleri önce daha fazla müþterisi olan þehirleri göstererek listeleyin.*/

SELECT city, COUNT(customer_id) AS müþteri_sayýsý
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 40
ORDER BY müþteri_sayýsý;

/* HAVING; GROUP BY ile birlikte kullandýðýmýz AGGREGATE fonksiyonundan gelen sonucu filtreler!! 
Yukarýdaki örnekte her þehrin customer sayýsý 5'ten büyük olanlarý getirir.*/

/* 3. List the top 10 most expensive products
	    En pahalý 10 ürünü listeleyin */

SELECT TOP 10 product_name, list_price
FROM product.product
ORDER BY list_price desc;

-- TOP keywordü ile select ten gelecek sonucun ilk kaç recordunu getireceðimizi belirliyoruz.


/* 4. List store_id, product name and list price and the quantity of the products 
	which are located in the store id 2 and the quantity is greater than 25----

	Store_id 2 de bulunan ve sayýsý 25 ten fazla olan ürünlerin store_id sini, product_name'ini, list_price'ýný 
	ve sayýsýný listeleyiniz.*/

SELECT S.store_id, P.product_name, P.list_price, S.quantity 
FROM product.product AS P, product.stock AS S
WHERE P.product_id = S.product_id 
	  AND S.store_id = 2
	  AND S.quantity > 25
ORDER BY P.product_name;

/* önce benden istenenlere baktým. Bir takým ürünlerin ismi istenmiþ. Demek ki product tablosuna gitmeliyim
 sonra store_id ler istenmiþ. bunun için aklýma ilk store tablosu geldi. baktým evet orada store_id var,
 bu tabloyu kullanabilirim dedim. yani product tablosuna bu tabloyu join ederim dedim. 
 Sonra baktým quantity (maðazalardaki ürünlerin sayýsý) istenmiþ. 
 O zaman stock tablosuna da gitmem gerektiðini anladým. Baktým evet orada quantity sütunu var. Bu tabloyu da
 join edeceðim dedim. Fakat bir de gördüm ki bu tabloda da store tablosunda da bulunan store_id sütunu varmýþ. 
 O zaman store tablosundan baþka bir veri getirmeyeceðim için, fazla tablo join etmeme adýna store tablosundan
 vazgeçtim. 
 Buraya dikkat!! --> Soru benden store_id'si üzerinden cevap istemiþ. store_id si 2 olan maðaza demiþ. Maðaza ismini de 
 isteseydi o zaman store_name'in yer aldýðý store tablosundan vazgeçemeyecek, onu da join etmek zorunda kalacaktým.

*/

/* Find the sales order of the customers who lives in Boulder order by order date
	Boulder'da yaþayan müþterilerin sales order'ýný, sipariþ tarihine göre bulun. */

SELECT C.city, A.order_id, A.order_date, C.customer_id, C.first_name, C.last_name
FROM sale.orders AS A, sale.customer AS C
WHERE A.customer_id = C.customer_id 
	AND city = 'Boulder'
ORDER BY A.order_date DESC;


/* 6. Get the sales by staffs and years using the AVG() aggregate function.
	   AVG() fonksiyonunu kullanarak personele (staff) ve yýllara göre satýþlarý alýn. */

select *
from sale.order_item


SELECT s.first_name, s.last_name, YEAR(o.order_date), AVG((i.list_price-i.list_price*i.discount)*quantity)
FROM sale.staff s 
INNER JOIN sale.orders o 
	ON s.staff_id = o.staff_id
INNER JOIN sale.order_item i
		ON o.order_id = i.order_id
GROUP BY s.first_name, s.last_name, YEAR(o.order_date)
ORDER BY 1, 2, 3;


/* 7. What is the sales quantity of product according to the brands and sort them highest-lowest
	Markalara göre satýlan ürünlerin miktarý nedir ve bunlarý en yüksekten en düþüðe doðru sýralayýnýz.*/

SELECT B.brand_name, P.product_name, COUNT(i.quantity) AS Sales_quantity_of_Product
from product.brand B, product.product P, sale.order_item i
WHERE B.brand_id = P.brand_id
AND P.product_id = i.product_id
GROUP BY B.brand_name, P.product_name
ORDER BY Sales_quantity_of_Product DESC;


---- 8. What are the categories that each brand has?----
--		Her markanýn kategorileri nelerdir?



---- 9. Select the avg prices according to brands and categories----
--	Markalara ve kategorilere göre ortalama fiyatlarý seçin



---- 10. Select the annual amount of product produced according to brands----
--	Markalara göre üretilen yýllýk ürün miktarýný seçin



---- 11. Select the store which has the most sales quantity in 2016.----
--	2016 yýlýnda en çok satýþ yapan maðazayý seçin



---- 12 Select the store which has the most sales amount in 2018.----
--	 2018 yýlýnda en çok satýþ miktarýna ulaþaln maðazayý seçin



---- 13. Select the personnel which has the most sales amount in 2019.----
--	2019 yýlýnda en çok satýþ yapan personeli seçin



