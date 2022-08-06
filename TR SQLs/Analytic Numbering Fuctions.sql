
-- Herbir kategori içinde ürünlerin fiyat sıralamasını yapınız 
--(artan fiyata göre 1'den başlayıp birer birer artacak)

select category_id, list_price,
	ROW_NUMBER() over(order by list_price) row_num
from product.product;


select category_id, list_price,
	ROW_NUMBER() over(partition by category_id order by list_price) row_num
from product.product;

select category_id, list_price,
	ROW_NUMBER() over(partition by category_id order by list_price) row_num
from product.product
order by category_id, list_price;


-- Aynı soruyu aynı fiyatlı ürünler aynı sıra numarasını alacak şekilde yapınız (RANK fonksiyonunu kullanınız)
select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num,
		RANK() OVER(partition by category_id order by list_price ASC) Rank_num
from	product.product
order by category_id, list_price
;

select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num,
		RANK() OVER(partition by category_id order by list_price) Rank_num
from	product.product
order by category_id, list_price
;


select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num,
		RANK() OVER(partition by category_id order by list_price ASC) Rank_num,
		DENSE_RANK() OVER(partition by category_id order by list_price ASC) dense_rank_num
from	product.product
order by category_id, list_price
;


select brand_id, list_price,
  round(cume_dist() over (partition by brand_id order by list_price),3) c_lp,
  round(percent_rank() over (partition by brand_id order by list_price),3) p_lp
from product.product
order by brand_id, list_price
;




SELECT	brand_id, list_price,
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST
FROM	product.product;

	SELECT	brand_id, list_price,
			ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
			ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK
	FROM	product.product
	;


	SELECT	brand_id, list_price,
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK,
		NTILE(4) OVER (PARTITION BY brand_id ORDER BY list_price) AS NTILE_NUM
FROM	product.product
;


	SELECT	product_name, brand_id, list_price,
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK,
		NTILE(4) OVER (PARTITION BY brand_id ORDER BY list_price) AS NTILE_NUM,
		count(*) OVER(PARTITION By brand_id) as Product_count
FROM	product.product
;

-- Write a query that returns both of the following
--	the average product price of orders
-- average net amount of orders

select a.order_id, b.item_id, b.product_id, b.list_price, b.discount,
	b.list_price* (1-b.discount)*b.quantity 
	from sale.orders a, sale.order_item b
	where a.order_id = b.order_id
	order by a.order_id, b.item_id


select distinct o.order_id, 
    avg(i.list_price) over(partition by i.order_id order by i.order_id) Avg_price,
    avg(i.list_price*(1-i.discount)*quantity) over() Avg_net_amount
    
from sale.orders o,sale.order_item i
where o.order_id = i.order_id
;


with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order
from	tbl
order by order_id, 1 - (siparis_toplami / siparis_toplami_liste_fiyati) desc
;


with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order,
		cast( 100 * (1 - (siparis_toplami / siparis_toplami_liste_fiyati))
			as INT)
		discount_ratio_order_INT
from	tbl
order by 1 - (siparis_toplami / siparis_toplami_liste_fiyati) desc
;


-- Herbir ay için şu alanları hesaplayınız:
-- O aydaki toplam sipariş sayısı
-- Bir önceki aydaki toplam sipariş sayısı
-- Bir sonraki aydaki toplam sipariş sayısı
-- Aylara göre yıl içindeki kümülatif sipariş yüzdesi

