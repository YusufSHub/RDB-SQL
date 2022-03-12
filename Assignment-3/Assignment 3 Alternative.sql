	/*1. Conversion Rate
	Below you see a table of the actions of customers visiting 
	the website by clicking on two different types of advertisements given 
	by an  E-Commerce company. Write a query to return
	the conversion rate for each Advertisement type.*/

	/*a. Create above table (Actions) and insert values,*/
		CREATE TABLE Actions
	(
    Visitor_ID BIGINT,
    Adv_Type  VARCHAR(20),
    Action VARCHAR(20)
	);
	INSERT Actions VALUES
	(1,'A','Left'),
	(2,'A','Order'),
	(3,'B','Left'),
	(4,'A','Order'),
	(5,'A','Review'),
	(6,'A','Left'),
	(7,'B','Left'),
	(8,'B','Order'),
	(9,'B','Review'),
	(10,'A','Review');

	b. /*Retrieve count of total Actions and Orders for each Advertisement Type,
	*/ 
	
	with t1 as(
	SELECT Adv_Type, COUNT([Action]) AS count_actions
	FROM Actions
	GROUP BY Adv_Type
	),
	t2 as(
	SELECT Adv_Type, COUNT([Action]) AS count_order
	FROM Actions
	WHERE [Action] = 'Order'
	GROUP BY Adv_Type
	)

	select t1.Adv_Type, count_actions, t2.count_order 
	from t1, t2
	where t1.Adv_Type = t2.Adv_Type




	/*c. Calculate Orders (Conversion) rates for each Advertisement Type by 
	dividing by total count of actions casting as float by multiplying by 1.0.*/


	with t1 as(
	SELECT Adv_Type, COUNT([Action]) AS count_actions
	FROM Actions
	GROUP BY Adv_Type
	),
	t2 as(
	SELECT Adv_Type, COUNT([Action]) AS count_order
	FROM Actions
	WHERE [Action] = 'Order'
	GROUP BY Adv_Type
	)

	select DISTINCT T1.Adv_Type, 
	CAST(count_order*1.0/count_actions AS numeric(3,2)) AS Conversion_Rate
	from t1, t2
	where t1.Adv_Type = t2.Adv_Type


	select A.Adv_Type,
	CAST(count_order*1.0/count_actions AS numeric(3,2)) AS Conversion_Rate	
	from
	(SELECT Adv_Type, COUNT([Action]) AS count_order
	FROM Actions
	WHERE [Action] = 'Order'
	GROUP BY Adv_Type
	)  AS A,
	(
	SELECT Adv_Type, COUNT([Action]) AS count_actions
	FROM Actions
	GROUP BY Adv_Type
	) AS B
	where A.Adv_Type = B.Adv_Type



	






