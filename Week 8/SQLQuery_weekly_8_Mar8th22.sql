/* ====================================================================================================
									WEEKLY AGENDA 8
  =====================================================================================================*/


  /*									D�KKAT! 
     QUERY YAZMAYA BA�LAMADAN �NCE DATABASE �ALI�ILMALI. DATABASE "ER DIAGRAM" �Y�CE �NCELENMEL�
     HANG� TABLOLARIM VAR, TABLOLARIMDA HANG� ALANLARIM (S�TUNLARIM) VAR, TABLOLARIM HANG� FOREIGN KEYLER
	 �LE B�RB�R�NE BA�LANMI� (RELATION KURULMU�) BUNLAR �NEML�! 
	 ��NK� SQL DE B�Z RELATIONAL DATABASE'LER �ZER�NDE �ALI�IYORUZ VE ARALARINDAK� �L��K�Y� B�LMEK
	 SORULARIN ��Z�M YOLUNU BEL�RLEMEDE �OK �NEML�D�R.*/



/*1. List all the cities in the Texas and the numbers of customers in each city.
	Teksas'taki t�m �ehirleri ve her �ehirdeki m��teri say�s�n� listeleyin */

SELECT COUNT(first_name) AS m��teri_say�s�
FROM sale.customer

SELECT City, COUNT(customer_id) AS m��teri_say�s�  -- alan isimleri, allias isimleri vs. aras�nda asla bo�luk b�rakm�yoruz!
FROM sale.customer								
WHERE state = 'TX'  -- t�rnak i�inde olan ifadeler her zaman case sensitive! onun d���ndakiler case insensitive
GROUP BY city;     -- GROUP BY yapt���m s�tun(lar) SELECT statement'da aynen yer almal�!!

/* Alan isimleri, allias isimleri vs. aras�nda asla bo�luk b�rakm�yoruz!
SQL derleyici bo�lu�a farkl� bir anlam y�kl�yor. �rne�in bo�luktan sonra ba�ka bir keyword bekliyor.
veya alan ad� ile allias (AS) yi ay�rmak i�in bo�luk kullan�l�yor. gibi...

T�rnak i�inde olan ifadeler (stringler) her zaman case sensitive! onun d���ndakiler case insensitive

GROUP BY yapt���m s�tun(lar) SELECT statement'da aynen yer almal�!! */



SELECT City, COUNT(customer_id) AS m��teri_say�s�
FROM sale.customer
WHERE state = 'TX'
GROUP BY city
ORDER BY m��teri_say�s DESC;
/* ORDER BY i�in COUNT(customer_id) kullanabilece�imiz gibi, 
bunun allias�n� da kullanabiliriz
veya a�a��da g�sterildi�i gibi o s�tunun SELECT teki s�ra numaras�n� da kullanabiliriz.
  ---> ORDER BY 2 DESC; <-----    */


/* 2. List all the cities in the California which has more than 5 customer, 
	by showing the cities which have more customers first.---
	 Kaliforniya'da 40'tan fazla m��terisi olan t�m �ehirleri �nce daha fazla m��terisi olan �ehirleri g�stererek listeleyin.*/

SELECT city, COUNT(customer_id) AS m��teri_say�s�
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 40
ORDER BY m��teri_say�s�;

/* HAVING; GROUP BY ile birlikte kulland���m�z AGGREGATE fonksiyonundan gelen sonucu filtreler!! 
Yukar�daki �rnekte her �ehrin customer say�s� 5'ten b�y�k olanlar� getirir.*/

/* 3. List the top 10 most expensive products
	    En pahal� 10 �r�n� listeleyin */

SELECT TOP 10 product_name, list_price
FROM product.product
ORDER BY list_price desc;

-- TOP keyword� ile select ten gelecek sonucun ilk ka� recordunu getirece�imizi belirliyoruz.


/* 4. List store_id, product name and list price and the quantity of the products 
	which are located in the store id 2 and the quantity is greater than 25----

	Store_id 2 de bulunan ve say�s� 25 ten fazla olan �r�nlerin store_id sini, product_name'ini, list_price'�n� 
	ve say�s�n� listeleyiniz.*/

SELECT S.store_id, P.product_name, P.list_price, S.quantity 
FROM product.product AS P, product.stock AS S
WHERE P.product_id = S.product_id 
	  AND S.store_id = 2
	  AND S.quantity > 25
ORDER BY P.product_name;

/* �nce benden istenenlere bakt�m. Bir tak�m �r�nlerin ismi istenmi�. Demek ki product tablosuna gitmeliyim
 sonra store_id ler istenmi�. bunun i�in akl�ma ilk store tablosu geldi. bakt�m evet orada store_id var,
 bu tabloyu kullanabilirim dedim. yani product tablosuna bu tabloyu join ederim dedim. 
 Sonra bakt�m quantity (ma�azalardaki �r�nlerin say�s�) istenmi�. 
 O zaman stock tablosuna da gitmem gerekti�ini anlad�m. Bakt�m evet orada quantity s�tunu var. Bu tabloyu da
 join edece�im dedim. Fakat bir de g�rd�m ki bu tabloda da store tablosunda da bulunan store_id s�tunu varm��. 
 O zaman store tablosundan ba�ka bir veri getirmeyece�im i�in, fazla tablo join etmeme ad�na store tablosundan
 vazge�tim. 
 Buraya dikkat!! --> Soru benden store_id'si �zerinden cevap istemi�. store_id si 2 olan ma�aza demi�. Ma�aza ismini de 
 isteseydi o zaman store_name'in yer ald��� store tablosundan vazge�emeyecek, onu da join etmek zorunda kalacakt�m.

*/

/* Find the sales order of the customers who lives in Boulder order by order date
	Boulder'da ya�ayan m��terilerin sales order'�n�, sipari� tarihine g�re bulun. */

SELECT C.city, A.order_id, A.order_date, C.customer_id, C.first_name, C.last_name
FROM sale.orders AS A, sale.customer AS C
WHERE A.customer_id = C.customer_id 
	AND city = 'Boulder'
ORDER BY A.order_date DESC;


/* 6. Get the sales by staffs and years using the AVG() aggregate function.
	   AVG() fonksiyonunu kullanarak personele (staff) ve y�llara g�re sat��lar� al�n. */

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
	Markalara g�re sat�lan �r�nlerin miktar� nedir ve bunlar� en y�ksekten en d����e do�ru s�ralay�n�z.*/

SELECT B.brand_name, P.product_name, COUNT(i.quantity) AS Sales_quantity_of_Product
from product.brand B, product.product P, sale.order_item i
WHERE B.brand_id = P.brand_id
AND P.product_id = i.product_id
GROUP BY B.brand_name, P.product_name
ORDER BY Sales_quantity_of_Product DESC;


---- 8. What are the categories that each brand has?----
--		Her markan�n kategorileri nelerdir?



---- 9. Select the avg prices according to brands and categories----
--	Markalara ve kategorilere g�re ortalama fiyatlar� se�in



---- 10. Select the annual amount of product produced according to brands----
--	Markalara g�re �retilen y�ll�k �r�n miktar�n� se�in



---- 11. Select the store which has the most sales quantity in 2016.----
--	2016 y�l�nda en �ok sat�� yapan ma�azay� se�in



---- 12 Select the store which has the most sales amount in 2018.----
--	 2018 y�l�nda en �ok sat�� miktar�na ula�aln ma�azay� se�in



---- 13. Select the personnel which has the most sales amount in 2019.----
--	2019 y�l�nda en �ok sat�� yapan personeli se�in



