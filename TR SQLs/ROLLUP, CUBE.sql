-- Generate different grouping variations that can be produced 
--with the brand and category columns using 'ROLLUP'
-- Calculate sum total_sales_price


select Brand, Category, Model_Year, SUM(total_sales_price) TOTAL
from sale.sales_summary
group by
	rollup(Brand, Category, Model_Year)

select Brand, Category, Model_Year, SUM(total_sales_price) TOTAL
from sale.sales_summary
group by
	CUBE(Brand, Category, Model_Year)
order by Brand, Category, Model_Year

select Brand, Category, Model_Year, SUM(total_sales_price) TOTAL
from sale.sales_summary
where Category = 'Computer Accessories'
group by
	CUBE(Brand, Category, Model_Year)
order by Brand, Category, Model_Year



SELECT *
FROM
(
SELECT Category, total_sales_price
FROM sale.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR Category
	IN
	([Audio & Video Accessories]
	,[Bluetooth]
	,[Car Electronics]
	,[Computer Accessories]
	,[Earbud]
	,[gps]
	,[Hi-Fi Systems]
	,[Home Theater]
	,[mp4 player]
	,[Receivers Amplifiers]
	,[Speakers]
	,[Televisions & Accessories])
) AS PIVOT_TABLE