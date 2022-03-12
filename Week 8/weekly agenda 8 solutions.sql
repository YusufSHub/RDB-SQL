--What is the sales quantity of product according to the brands and sort them highest-lowest

select b.[brand_name], p.product_name, SUM(o.[quantity]) [Sales Quantitiy of Product]
from [product].[brand] b
inner join [product].[product] p
on b.brand_id = p.brand_id
inner join [sale].[order_item] o
on p.product_id = o.product_id
group by b.brand_name, p.product_name
order by [Sales Quantitiy of Product] desc;


--Select the top 5 most expensive products

select top 5 [product_name], [list_price]
from [product].[product]
order by [list_price] desc;

--What are the categories that each brand has

select b.[brand_name], c.[category_name]
from [product].[brand] b
inner join [product].[product] p
on b.brand_id = p.brand_id
inner join [product].[category] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name
order by 1,2

--Select the avg prices according to brands and categories

select b.[brand_name], c.[category_name], avg(p.[list_price]) as [Avg Price]
from [product].[brand] b
inner join [product].[product] p
on b.brand_id = p.brand_id
inner join [product].[category] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name


--Select the annual count of product produced according to brands

select p.[model_year],b.[brand_name], count(p.[product_name])
from [product].[brand] b
inner join [product].[product] p
on b.brand_id = p.brand_id
group by p.[model_year],b.[brand_name]
order by p.[model_year]




--Select the store that sells the most products in 2018.


select top 1 s.[store_name], sum(i.[quantity]) cnt_prod
from [sale].[store] s
inner join [sale].[orders] o
on s.store_id = o.store_id
inner join [sale].[order_item] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2018' -- year(o.[order_date])
group by s.[store_name] 
order by 2 desc;




--Select the store which has the most sales amount in 2018


select top 1 s.[store_name], sum(i.[quantity]*i.[list_price]) as sales_amount_2018
from [sale].[store] s
inner join [sale].[orders] o
on s.store_id = o.store_id
inner join [sale].[order_item] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2018' -- year(o.[order_date])
group by s.[store_name] 
order by 2 desc;



--Select the employee which has the most sales amount in 2018

select top 1 s.[first_name], s.[last_name], sum(i.[quantity]*i.[list_price]) as sales_amount_2018
from [sale].[staff] s
inner join [sale].[orders] o
on s.staff_id = o.staff_id
inner join [sale].[order_item] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2018'
group by s.[first_name], s.[last_name] 
order by 3 desc;


