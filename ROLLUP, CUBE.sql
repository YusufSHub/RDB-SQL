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