/*==========================================================
					SQL SERVER - �NEML� KODLAR-3

				(ALANLAR �ZER�NDE YAPILACAK YAPISAL ��LEMLER)
============================================================
							INDEX
============================================================
	
1. B�R TABLOYA ALAN EKLEME
2. B�R TABLODAN ALAN �IKARTMA
3. B�R ALANIN VER� T�P�N� DE���T�RMEK 
4. B�R ALANA B�R KISIT (CONSTRAINT) EKLEMEK
5. B�R ALANDAN B�R KISITI (CONSTRAINT) KALDIRMAK
6. B�R ALANIN ADINI DE���T�RMEK
7. B�R TABLONUN ADINI DE���T�RMEK*/



/* ==================================================================
					1. B�R TABLOYA ALAN EKLEME
======================================================================*/

-- tek alan eklemek:
ALTER TABLE tablo_adi 
ADD alan_ad� veri_turu

-- birden fazla alan eklemek:
ALTER TABLE tablo_adi 
ADD alan1 veri_turu,
	alan2 veri_turu
	
/*NOT: E�er yeni eklenen alan otomatik artan say� olacaksa, alan olu�turulurken yap�lmas� gerekir. 
Sonradan yap�lmas� i�in alan�n kald�r�lmas� ve yeniden olu�turulmas� gerekir.

�RNEK: Ord_id alan�n� otomatik artan say� olacak �ekilde, Order_date
alan�n� date veri tipinde olacak �ekilde olu�turmak i�in: */
ALTER TABLE order_date  ADD  Ord_id INT IDENTITY(1,1),
						ADD Order_date date 


/* ==================================================================
					2. B�R TABLODAN ALAN �IKARTMA
=====================================================================*/

--tek s�tun kald�rma:
ALTER TABLE tablo_adi DROP COLUMN alan_adi
 
--birden fazla s�tun kald�rma:
ALTER TABLE tablo_adi  DROP COLUMN sutun1, sutun2

-- �RNEK: Orders_dimen tablosundan Order_date alan�n� ��karmak i�in
ALTER TABLE Orders_dimen DROP COLUMN Order_date

/* ==================================================================
				3. B�R ALANIN VER� T�P�N� DE���T�RMEK 
=====================================================================*/

/* E-Commerce database'indeki orders_dimen tablosunun Order_Date alan�n�n "date" olan veri tipini 
	 "varchar" olarak de�i�tirmek istiyorum.
	
	�ncelikle bu alan�n orjinal hali �zerinde de�i�iklik yapmak istemedi�im i�in 
	sonradan silmek �zere orders_dimen2 isminde yeni bir tablo olu�turay�m 
	ve bu tablonun i�eri�ini orders_dimen tablosundan als�n.*/

/*A�a��daki kod ile orders_dimen tablosuna git ve i�indeki t�m alanlar� 
orders_dimen2 adl� tabloya gir demi� oluyorum.(select into --> e�er hedef tablosu yoksa olu�turur)*/

select *
into orders_dimen2
from orders_dimen


/* A�a��daki iki fonksiyon(CAST ve CONVERT); 
SELECT ile birlikte kullan�l�r ve FROM ile ilgili alana gidip ordaki verinin tipini 
istedi�iniz veri tipiyle de�i�tirir ve yeni haliyle bize getirir. 

Ancak pek tabi ki SELECT keyword'� verinin tipi de�i�tirilmi� yeni halini 
bize SORGU SONUCU OLARAK GET�R�R. YAN� TABLODA YAPISAL B�R DE����KL�K� YAPMAZ.*/

select CAST(Order_date as date) from orders_dimen2

select CONVERT(datetime, Order_Date, 101) from orders_dimen2

/* Tablo �zerindeki alanlarda (ve di�er t�m database objectlerde) yap�sal bir de�i�iklik yapmak i�in 
ALTER TABLE komutunu kullan�yoruz. Syntax'i �u �ekildedir:*/

ALTER TABLE tablo_adi ALTER COLUMN  alan_adi veri_turu


/*A�a��daki kod ile diyoruz ki; orders_dimen2 tablosunda bir de�i�iklik yap ve bu de�i�iklik, 
Order_Date alan�n�n veri tipini date yapmak olsun.*/

ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date varchar
-- �imdi Object Explorer'dan bakarsak veri tipinin de�i�ti�ini g�rebiliriz.

-- Tekrar varchar dan date tipine �evirelim:
ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date date



/* ==================================================================
		 4. B�R ALANA B�R KISIT (CONSTRAINT) EKLEMEK
=====================================================================*/

/* Bir SQL tablosundaki bir alana NOT NULL ya da NULL constrainti eklemek istersek 
Syntax'i �u �ekildedir:*/

ALTER TABLE tablo_adi 
ALTER COLUMN  alan_adi veri_turu [NOT NULL | NULL ]

-- �rne�imizdeki alana NOT NULL k�s�t� ekleyelim:

ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date varchar NOT NULL


/* Bir SQL tablosundaki bir alana UNIQUE constrainti eklemek istersek 
Syntax'i �u �ekildedir:
(Not: hata mesaj� almamak i�in alandaki verilerin e�siz olmas� yada tablonun bo� olmas� gerekiyor.)*/

ALTER TABLE tablo_adi 
ADD CONSTRAINT kisit_adi UNIQUE(alan_adi)

-- �rne�imizdeki alana UNIQUE k�s�t� ekleyelim:

ALTER TABLE order_dimen2
ADD CONSTRAINT order_date_k�s�t UNIQUE (Order_Date)


/* Bir SQL tablosundaki bir alana PRIMARY KEY constrainti eklemek istersek 
Syntax'i �u �ekildedir:
(Not: K�s�t isimleri �nemlidir. Kald�rma i�lemleri bu k�s�t isimleri �zerinde yap�lacakt�r.*/

ALTER TABLE tablo_Adi 
ADD CONSTRAINT kisit_adi PRIMARY KEY (alan_adi)


/* �rne�imizde bir alan� �nce NOT NULL sonra da PRIMARY KEY yapal�m:

(PRIMARY KEY i�in temel kurallardan biri bo� ge�ilemez olmas�d�r. 
Bu y�zden pek tabi ki �ncelikle bu alan�n NOT NULL olmas� gerekmektedir.)*/

ALTER TABLE order_dimens2 ALTER COLUMN Ord_id INT NOT NULL
ALTER TABLE order_dimens2 ADD CONSTRAINT PK_ord_id PRIMARY KEY (Ord_id)


/* ==================================================================
		5. B�R ALANDAN B�R KISITI (CONSTRAINT) KALDIRMAK
=====================================================================*/

/* Bir SQL tablosundaki bir alan�n PRIMARY KEY constraintini kald�rmak istersek
Syntax'i �u �ekildedir:*/

ALTER TABLE tablo_adi DROP CONSTRAINT k�s�t_ad�

/*(Alanlardaki k�s�tlar� kald�rma i�lemi k�s�t adlar� ile yap�lmaktad�r. 
Di�er k�s�tlamalar� da k�s�tlama ad� ile kald�rabilirsiniz. 
Olmayan bir k�s�tlamay� yada daha �nce silinmi� olan bir k�s�tlamay� silmeye �al���yorsan�z. 
�Could not drop constraint. See previous errors.� hatas� ile kar��la��rs�n�z.*/


-- �RNEK: Ord_id alan�ndan UNIQUE k�s�t�n� kald�ral�m:
--(Ord_id i�in UNIQUE k�s�tlamas�n� "order_date_k�s�t" olarak eklemi�tik)

ALTER TABLE Ord_id DROP CONSTRAINT order_date_k�s�t


/* ==================================================================
					6. B�R ALANIN ADINI DE���T�RMEK
=====================================================================*/

/*ALTER Komutu ile s�tun isimlerini de�i�tirmek m�mk�n de�ildir. 
Bu i�lem i�in sp_rename sakl� yordam� ile yapmak m�mk�nd�r. 
Ancak SQL Server tabloyu yeniden olu�turman�z� �nerir.*/

--�rne�imizde Order_Date alan ad�n� Date_Order olarak de�i�tirelim:

sp_rename 'order_dimen2.Order_Date', 'Date_Order', 'COLUMN'



/* ==================================================================
					7. B�R TABLONUN ADINI DE���T�RMEK
=====================================================================*/

/*ALTER komutu ile tablo ad�n� de�i�tirmek m�mk�n de�ildir.
Fakat bu i�lem i�in sp_rename sakl� yordam� kullan�labilir. 
�li�ki ba��ml�l��� y�z�nden SQL Server tabloyunu yeniden olu�turmay� �neriyor.*/

-- orders_dimen2 tablo ad�n� orders_dimen3 olarak de�i�tirelim:

sp_rename 'orders_dimen2' , 'orders_dimen3'










