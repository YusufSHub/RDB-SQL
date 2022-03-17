-- list the products the last 10 orders in buffalo city

select b.product_name, a.product_id, a.order_id from sale.order_item a, product.product b
where a.product_id=b.product_id and a.order_id in 
	(
		select TOP 10 b.order_id
	from sale.customer a, sale.orders b
	where a.customer_id=b.customer_id and a.city='Buffalo'
	order by b.order_date DESC)


--musterilerin siparis sayilarini, siparis ettikleri urunlerin sayilarini, urunlere odedikleri toplam miktari raporlayiniz.
select a.customer_id, a.first_name, a.last_name,
	count(DISTINCT c.order_id) as cnt_order,
	sum(b.quantity) as total_product,
	sum(list_price*(1-discount)*quantity) Total_Paid
from sale.customer a, sale.order_item b, sale.orders c
where a.customer_id=c.customer_id and b.order_id=c.order_id
group by a.customer_id, a.first_name, a.last_name


--hic siparis vermemis musterileri de rapora dahil edin

select a.customer_id, a.first_name, a.last_name,
	count(DISTINCT c.order_id) as cnt_order,
	sum(b.quantity) as total_product,
	sum(list_price*(1-discount)*quantity) Total_Paid
from sale.customer a
	left join sale.orders c on A.customer_id=c.customer_id 
	left join sale.order_item b on b.order_id=c.order_id
group by a.customer_id, a.first_name, a.last_name
order by Total_Paid ASC;


--sehirlder verilen siparis sayilarini, siparis edilen urun sayilarini ve odenen toplam miktari raporlayiniz
select a.city, a.first_name, a.last_name,
	count(DISTINCT c.order_id) as cnt_order,
	sum(b.quantity) as total_product,
	sum(list_price*(1-discount)*quantity) Total_Paid
from sale.customer a
	left join sale.orders c on A.customer_id=c.customer_id 
	left join sale.order_item b on b.order_id=c.order_id
group by a.city, a.first_name, a.last_name

SELECT	 A.city,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY   A.city