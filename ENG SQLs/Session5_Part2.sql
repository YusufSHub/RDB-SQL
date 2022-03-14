/*SEssion 5: PArt 2*/
CREATE VIEW sale.VW_sales_summary
as
SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
--INTO 
FROM sale.order_item A
	JOIN product.product B ON A.product_id = B.product_id
	JOIN product.brand C ON B.brand_id = C.brand_id
	JOIN product.category D ON B.category_id = D.category_id
GROUP BY C.brand_name , D.category_name , B.model_year 

SELECT * FROM [sale].[VW_sales_summary]

--TEMPORARY TABLES

SELECT *
into #temp
FROM [product].[stock]

select * FROM #temp

##myTable

select * FROM sale.sales_summary
------------------------------------
--1. Calculate the total sales price.
SELECT SUM(total_sales_price)
FROM sale.sales_summary

--2. Calculate the total sales price of the brands
SELECT brand,SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY Brand

--3. Calculate the total sales price of the categories
SELECT category,SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY category

--4. Calculate the total sales price by brands and categories.
SELECT brand, category,SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY brand, category

SELECT brand, category,model_year, SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY
	GROUPING SETS(
			(brand, category,Model_year),
			(brand),
			(category),
			()
	)
ORDER BY 1,2,3


select * from sale.sales_summary



SELECT brand, category,model_year, SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY
	ROLLUP(brand, category,Model_year)
	ORDER BY 1,2,3

SELECT brand, category,model_year, SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY
	GROUPING SETS(
		(brand, category,Model_year),
		(brand,category),
		(brand),
		()
		)
	ORDER BY 1,2,3

SELECT brand, category,model_year, SUM(total_sales_price) as Total_Sales_Price
FROM sale.sales_summary
GROUP BY
	CUBE(brand, category,Model_year)
	ORDER BY 1,2,3

	----------------------------
	/*
	1. grouping
	2. spreading
	3. aggregating
	*/

	SELECT <columns>

	FROM <Derived Table> D
	PIVOT
		( <aggregation function> 
		 FOR  <spreading element> IN <list of columns>) AS P

SELECT *
FROM (
		SELECT category, total_sales_price, model_year
		FROM sale.sales_summary
	) A   --DERIVED TABLE
PIVOT
   (SUM(total_sales_price) -- Aggrgation
   FOR category IN (       -- spreading out 
    [Audio & Video Accessories],
	[Bluetooth],
[Car Electronics],
[Computer Accessories],
[Earbud],
[gps],
[Hi-Fi Systems],
[Home Theater],
[mp4 player],
[Receivers Amplifiers],
[Speakers],
[Televisions & Accessories]) 
)AS P
   select distinct '[' +  category + '],'from sale.sales_summary
---Distribution by Days of Week

SELECT *
FROM 
	(select order_id,DATENAME(DW, order_date) day_of_week
	 FROM sale.orders ) A -- DERIVED TABLE
PIVOT   --PIVOT
	( COUNT(order_id)  -- Aggragate
	  FOR day_of_week IN --spreading
	  ([Monday],
	  [Tuesday],
	  [Wednesday],
	  [Thursday],
	  [Friday],
	  [Saturday],
	  [Sunday])

	) AS P






