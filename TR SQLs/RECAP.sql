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

--State ortalamasinin altinda ortlama ciroya sahip sehirleri listeleyin..


with t1 as (
	select DISTINCT A.state, A.city, 
	avg(C.list_price*(1-C.discount)*C.quantity) over(partition by A.state) avg_state,
	avg(C.list_price*(1-C.discount)*C.quantity) over(partition by A.state, A.city) avg_city
	FROM sale.customer A, sale.orders B, sale.order_item C
	where A.customer_id=B.customer_id and B.order_id=C.order_id 
	)

select * from T1
where avg_city < avg_state


--Create a report shows daywise turnovers of the BFLO Store.

select * from
(
	select DATENAME(WEEKDAY, order_date) [dayz],
	list_price*(1-discount)*quantity total
	from sale.store a, sale.orders b, sale.order_item c
	where store_name='The BFLO Store' and
	a.store_id=b.store_id and b.order_id=c.order_id
) A
	PIVOT
(sum(total)
for dayz 
in ([Monday], [Tuesday], [Wednesday],[Thursday],[Friday])
) as pivot_table


select * from
(
	select DATENAME(WEEKDAY, order_date) [dayz],
	datepart(ISOWW, order_date) weekz,
	list_price*(1-discount)*quantity total
	from sale.store a, sale.orders b, sale.order_item c
	where store_name='The BFLO Store' and
	a.store_id=b.store_id and b.order_id=c.order_id
	and year(B.order_date)=2018
) A
	PIVOT
(sum(total)
for dayz 
in ([Monday], [Tuesday], [Wednesday],[Thursday],[Friday], [Saturday],[Sunday])
) as pivot_table


--Write a query that returns how many days are between the third and fourth order dates of each staff.
--Her bir personelin üçüncü ve dördüncü siparişleri arasındaki gün farkını bulunuz.
WITH T1 AS
(
SELECT staff_id, order_date, order_id,
		LEAD(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) next_ord_date,
		ROW_NUMBER () OVER (PARTITION BY staff_id ORDER BY order_id) row_num
FROM sale.orders
)
SELECT *, DATEDIFF(DAY, order_date, next_ord_date) DIFF_OFDATE
FROM T1
WHERE row_num = 3