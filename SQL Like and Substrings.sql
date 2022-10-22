/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/ select distinct city from [sale].[customer] where city not like '[aeiou]%' and city not like '%[aeiou]'

select * from sale.sales_summary

select distinct Brand, Model_year from sale.sales_summary where total_sales_price>5000 order by Brand, Model_Year

 select * from [sale].[customer]
 select first_name from sale.customer where zip_code >60000 order by customer_id;

select round(38.7780,2,2) as decc;

