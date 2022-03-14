-----------------SQL INCLASS SESSION-7 05 AGU 21 ------------------------------

---------------------------WINDOS FUNCTION----------------------------------------

--GROUP BY--> distinct kullanmıyoruz, distinct'i zaten kendi içinde yapıyor
--WF--> optioanal olarak yapabiliyoruz.

--GROUP BY -->  aggregate mutlaka gerekli, 
--WF--> aggregate optional

--GROUP BY --> Ordering invalid
--WF--> ordering valid

--GROUP BY --> performansı düþük
--WF --> performanslı



-- SYNTAX

SELECT {columns}
FUNCTION OVER (PARTITION BY...ORDER BY...WINDOW FRAME)
FROM table1

select *,
AVG(time) OVER(
				PARTITION BY id ORDER BY date
				ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
				) as avg_time
FROM time_of_sales


 
-- UNBOUNDED PRECEDING --> ÖNCEKı SATIRLARIN HEPSıNE BAK (kendi partition içinde)
-- UNBOUNDED FOLLOWING--> SONRAKı SATIRLARIN HEPSıNE BAK (kendi partition içinde)

-- N PRECEDING --> BELıRTıLEN N DEğERıNE KADAR ÖNCESıNE GıDıP BAK
-- M FOLLOWING --> BELıRTıLEN M DEğERıNE KADAR SONRASINA BAK


-------------------------------------------------------------------------------
-- SORU 1: ürünlerin stock sayılarını bulunuz

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id


SELECT product_id
FROM production.stocks
GROUP BY product_id
ORDER BY 1

-- window function ile yazalım
SELECT SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks
-- YENı BıR SÜTUN OLARAK sonuç geldi ama tek sütun olduğu için anlamak zor. yanına diğer sütunları da getirelim

SELECT *, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

--sadece product_id sütunu iþimizi görür
SELECT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

-- Distint atarak productÜ_id leri teke düþürürüm
SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks


-- SORU 2: Markalara göre ortalama bisiklet fiyatlarını hem GROUP BY hem de WINDOW Function ile hesaplayınız

-- GROUP BY ile :
SELECT brand_id, AVG(list_price) avg_price
FROM production.products
GROUP BY brand_id

-- window function ile:
SELECT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_price
FROM production.products


-----------------------------1. ANALYTIC AGGREGATE FUNCTIONS -----------------------------------------------------------------

--MIN()  --MAX()   --AVG()  --SUM()  -- COUNT()




--SORU 1: Tüm bisikletler arasında en ucuz bisikletin fiyatı

-- Minimum list_price istiyor. herhangi bir gruplamaya yani PARTITION a gerek yok!
SELECT DISTINCT MIN (list_price) OVER ()
FROM production.products



--SORU 2: Her bir kategorideki en ucuz bisikletin fiyatı?

-- kategoriye göre gruplama yapmak zorundayım yani PARTITION gerekli
SELECT DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id)
FROM production.products



--SORU 3: product tablosunda toplam kaç farklı bisiklet var?

SELECT DISTINCT COUNT (product_id) OVER () NUM_OF_BIKE
FROM production.products
-- sadece product_id leri unique olarak saydırdım. PARTITION (gruplamaya gerek yok)
-- product tablosunda 321 adet farklı bisiklet olduğunu gördüm.



--SORU 4: Order_items tablosunda kaç farklı bisiklet var?
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM sales.order_items
-- ürün sayısı : 4722

-- Bu hata verir!!
SELECT COUNT(DISTINCT product_id) OVER() order_num_of_bike
FROM sales.order_items
-- COUNT WINDOW fonksiyonunda yukardaki gibi içinde DISTINC'e izin vermiyor! Onun yerine,

SELECT COUNT(DISTINCT product_id)
FROM sales.order_items
--307 product_id geldi. bunun üzerinden bir sayma iþlemi yaparsam

-- yukardaki query'i window fonksiyonunu kullandığım query'nin subquerysi yapacağım.
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id  -- buradan 307 row değer gelecek
		FROM sales.order_items
	) A


-- SORU 4: her bir kategoride toplam kaç farklı bisiklet var?

SELECT DISTINCT category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products
-- product_id zaten unique olduğu için ayrıca bir distinct e gerek kalmadı.


--SORU 5: Herbir kategorideki herbir  markada kaç farklı bisikletin bulunduğu
SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products



--SORU 6 : WF ile tek select'te herbir kategoride kaç farklı marka olduğunu hesaplayabilir miyiz?

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM production.products
-- burada her bir kategorideki satır sayısını getiriyor. bunu istemiyoruz!!

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM 
(
SELECT DISTINCT category_id, brand_id  -- ÖNCE DISTINCT ıLE BRAND_ID LERı GETıRDıM.
FROM production.products 
) A
-- görüldüğü gibi WF  ile tek bir SELECT satırı ile bu soru yapılamıyor.

SELECT	category_id, count (DISTINCT brand_id)
FROM	production.products
GROUP BY category_id

--Sonuç: iþin içinde DISTINCT varsa GROUP BY ile daha kolayca çözüme ulaþılıyor!!!




--------------------------- 2. ANALYTIC NAVIGATION FUNCTIONS ------------------------------------------------------------

-- FIRST_VALUE()  -- LAST_VALUE() -- LEAD() -- LAG()



-- SORU 1 : Order tablosuna aþağıdaki gibi yeni bir sütun ekleyiniz:
	-- Her bir personelin bir önceki satıþının sipariþ tarihini yazdırınız (LAG Fonksiyonunu kullanınız)

SELECT *, 
LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) prev_ord_date
-- HER BıR PERSONELıN DEDığı ıÇıN PARTITION BY a staff_id koyuyoruz. (staff_id lere göre grupluyoruz)
-- bir önceki sipariþ tarihini sorduğu için ORDER BY da order date'e (ve order_id'ye) göre sıralama yaptırdım
FROM sales.orders

-- LAG, current row'dan belirtilen argümandaki rakam kadar önceki değeri getiriyor..
-- query sonucu incelediğinde LAG fonksiyonu, prev_ord_date sütununda her satıra o satırın bir önceki satırındaki tarihi yazdığını görebilirsin.
	--yani her satır bir önceki order_date'i yazdırmıþ olduk

--staff_id'nin 2 den 3'e geçtiği 165. satıra dikkat et. o satırdan itibaren yeni bir pencere açtı ve 
	-- LAG() fonksiyonunu o pencereye ayrıca uyguladı. (165. satırda bir önceki tarih olmadığı için NULL yazdırdı.)




-- SORU 2: Order tablosuna aþağıdaki gibi yeni bir sütun ekleyiniz:
	--2. Herbir personelin bir sonraki satıþının sipariþ tarihini yazdırınız (LEAD fonksiyonunu kullanınız)

SELECT	*,
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

-- LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki değeri getiriyor
-- Niye iki sütunu order by yaptık? çünkü ayın aynı gününde birden fazla sipariþ verilmiþ olabilir.
	-- o yüzden tarihe ilave olarak bir de order_id ye göre sıralama yaptırdık

--GENELLıKLE LEAD VE LAG FONKSıYONLARI SIRALANMIÞ BıR LıSTEYE UYGULANIR!!! O YÜZDEN ORDER BY KULLANILMALIDIR!!




---------------------------------WINDOWS FRAME ----------------------------------------


SELECT category_id, product_id,
	COUNT (*) OVER () TOTAL_ROW  -- bunun bize toplam satır sayısını getirmesini bekliyoruz
FROM production.products


SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- son elde ettiğimiz sütunda category_id lerin satır sayısını kümülatif olarak toplayarak getirdi.
	-- category_id :1 olan pencerenin sonuna baktığımızda o kategoriye ait kaç satır olduğunu (59) anlıyoruz
	-- product_id ye göre order by yaptığımız için her bir categroy_id gruplaması içinde product_id leri sıralıyor
		-- ve bu sıralamanın her satırında kümülatif olarak toplama yapıyor.

-- ORDER BY yapmazsak:
SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id) total_num_of_row,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- 2.COUNT'tan ORDER BY'ı kaldırınca product_id ye göre order by ı kaldırdığımız için, 
	-- gruplanan categoru_id ye göre COUNT(*) sonucunu yani toplam row sayısını her bir category_id satırının yanına yazdırdı!


SELECT category_id,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current
from production.products

-- Grupladığımız category_id satırlarını bu sefer ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ile saydırdık.
	-- Bulunduğu satırda o satırdan önceki tüm satırları ve o satırı iþleme sokarak toplama yapıyor.
	-- dolayısıyla bir önceki query deki gibi kümülatif bir toplama iþlemi yapmıþ oluyor.



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- OVER iþlemi içindeki order by --> window fonksiyonu uygularken dikkate alacağı order by
-- Sondaki order by --> select iþlemi sonundaki sonucun order by ı


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1  PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her satır için kendinden önceki 1 satırı ve sonraki 1 satırı hesap ederek count iþlemi yap
	-- mesela 5. satır için; önceki 1 satıra gitti, bu 4.satırdır... sonra kendinden sonraki 1.satıra gitti, bu 6. satırdır.
		-- bu iki satır (4. ve 6. satırlar) arasında 3 satır olduğundan COUNT fonk. return olarak 3 getirdi.

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her satır için kendinden önceki 2 satırı ve sonraki 3 satırı hesap ederek count iþlemi yap
	-- mesela 5. satır için; önceki 2 satıra gitti, bu 3.satırdır... sonra kendinden sonraki 3.satıra gitti, bu 8. satırdır.
		-- bu iki satır (3. ve 8. satırlar) arasında 6 satır olduğundan COUNT fonk. return olarak 6 getirdi.


-- SORU 1: Tüm bisikletler arasında en ucuz bisikletin adı (FIRST_VALUE fonksiyonunu kullanınız)

-- First_value içine argüman olarak hangi sütundaki ilk değeri istiyorsam onu alıyorum
SELECT *, FIRST_VALUE(product_name) OVER (ORDER BY list_price) 
FROM production.products


-- SORU 2: yukardaki sonucun yanına list price nasıl yazdırırız?

SELECT DISTINCT FIRST_VALUE(product_name) OVER (ORDER BY list_price), min(list_price) OVER() 
FROM production.products


-- SORU 3: Herbir kategorideki en ucuz bisikletin adı (FIRST_VALUE fonksiyonunu kullanınız)

SELECT DISTINCT category_id, FIRST_VALUE (product_name) OVER (partition by category_id  ORDER BY list_price)
FROM production.products
-- her kategorinin en ucuzunu sorduğu için category_id yi partition ile grupladık. 



-- SORU 4: Tüm bisikletler arasında en ucuz bisikletin adı (LAST_VALUE fonksiyonunu kullanınız)

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price)
FROM production.products
-- tek satırlık first_value değerini gördüm

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price),
		LAST_VALUE(product_name) OVER (ORDER BY list_price desc)
FROM production.products
-- LAST_VALUE satırını da girince birden fazla satır getirdi!! 
-- LAST_VALUE'da FIRST_VALUE'dan farklı olarak ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING girmem gerek.

SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products





---------------------------3. ANALYTIC NUMBERING FUNCTIONS -------------------------------

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



-- SORU 1 : Herbir kategori içinde bisikletlerin fiyat sıralamasını yapınız (artan fiyata göre 1'den baþlayıp birer birer artacak)

-- ROW_NUMBER baþtan aþağıya numara verir. Sıralanmıþ bir liste üzerinden bir değer seçebilmem için kullanıyoruz
	-- list_price sıralamasında 10 numaralı sıradaki ürünü getir dediğimde bu iþe yarar.
SELECT category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products
-- list price'ı niye sıraladık, artan fiyata göre 1 den baþlayıp birer birer artacak dediği için..



-- SORU 2: Aynı soruyu aynı fiyatlı bisikletler aynı sıra numarasını alacak þekilde yapınız 
	--(RANK fonksiyonunu kullanınız)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products
-- AYNI rank'te olan ikinci değerin ranknumarasını ilkinin numarası ile değiþtiriyor
	-- yani rank numrası önceki ile aynı oluyor ve sonraki gelen için numara bir atlayarak kendi numarası ile sıralanıyor.


-- SORU 3: Aynı soruyu aynı fiyatlı bisikletler aynı sıra numarasını alacak þekilde yapınız 
	--(DENSE_RANK fonksiyonunu kullanınız)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products
-- DENSE_RANK'te RANK'ten farklı olarak; aynı rank'te olanlara aynı numarayı vermesine rağmen sıra numaraları atlamıyor.



--SORU 4: Herbir kategori içinde bisikletlerin fiyatlarına göre bulundukları yüzdelik dilimleri yazdırınız. 
	-- PERCENT_RANK fonksiyonunu kullanınız.

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products
-- Bu fonksiyon da ORDER BY'a bağlı!! Mutlaka ORDER BY kullanılmalı!!!


--SORU 5: Aynı soruyu CUM_DIST ile yapınız:

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST
FROM	production.products



----------------- CUME_DIST ıLE PERCENT_RANK ARASINDAKı FARKLAR---------------------

-- CUME_DIST: 

	-- Bir grup içindeki bir değerin kümülatif dağılımını döndürür; 
	-- yani, geçerli satırdaki değerden küçük veya ona eþit partition değerlerinin yüzdesidir. 
	-- Bu, partition'un sıralamasındaki current row'dan önceki veya eþ olan SATIR SAYISINI, 
		-- partitiondaki TOPLAM SATIR SAYISINA BÖLEREK temsil eder. 
		-- 0 ile 1 arasında değiþen sonuçlar return eder ve partition'daki en büyük değer 1 dir.

-- PERCENT_RANK:

-- En yüksek değer hariç, geçerli satırdaki değerden küçük partition değerlerinin yüzdesini döndürür. 
	--Return değerleri 0 ile 1 arasındadır. 
	--Formülü þudur: (rank - 1) / (rows - 1) burada rank, o satırın rank'i; rows, partition satırlarının sayısıdır. 

-- ARALARINDAKı FARKI ÞU ÞEKıLDE ıZAH EDEBıLıRıZ:

	-- PERCENT_RANK, current score'dan (o row'dan) daha düþük değerlerin yüzdesini döndürür. 
	-- Kümülatif dağılım anlamına gelen CUME_DIST ise current skorun actual position'unu döndürür. 

	-- Yani bir partition'da (yukardaki örnekte category_id'leri gruplamıþtım) 100 score (değer) varsa 
		--ve PERCENT_RANK 90 ise, bu score'un 90 score'dan yüksek olduğu anlamına gelir. 
		-- CUME_DIST 90 ise, bu, score'un listedeki 90. olduğu anlamına gelir.

-- CUME_DIST tekrar eden değerleri iki kere hesaba katıyor. ama PERCENT_RANK bir kere katıyor.



--6. Her bir kategorideki bisikletleri artan fiyata göre 4 gruba ayırın. Mümkünse her grupta aynı sayıda bisiklet olacak.
	--(NTILE fonksiyonunu kullanınız)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products

-- NTILE : bir partition içindeki değerleri belirlediğimiz paremetre sayısına (burada 4) bölüyor ve her bölüme numara atıyor
	-- kategory_id ye göre grupladık. list_price a göre sıraladık.
	-- 59 değer var. NTILE bunları 4'e bölüyor (parametre olarak 4 girdiğimiz için)
	-- 15'er 15'er bunlara sıra numarası veriyor. ilk 15'e 1 diyor, sonraki 15'e 2 diyor.... son gruba da 4 diyor



	--ÖDEV OLARAK BIRAKILAN SORULAR:

--SORU 7: mağazaların 2016 yılına ait haftalık hareketli sipariþ sayılarını hesaplayınız


--SORU 8: '2016-03-12' ve '2016-04-12' arasında satılan ürün sayısının 7 günlük hareketli ortalamasını hesaplayın.
