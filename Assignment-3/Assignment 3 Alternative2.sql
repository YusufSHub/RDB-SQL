WITH table_name AS (
				select	distinct Adv_Type,Action,
				COUNT (Action) over (partition by Adv_Type ) total_actions_of_Adv_Type,
				COUNT (Action) over (partition by Adv_Type,Action) actions_portions_of_Adv_Type
				from	Actions
	)
SELECT	Adv_Type, Action, actions_portions_of_Adv_Type , total_actions_of_Adv_Type, round((cast(actions_portions_of_Adv_Type as float) / total_actions_of_Adv_Type),2) conv_rate
FROM	table_name
where Action = 'Order'
;


SELECT Adv_Type, CAST(ROUND((SUM(CASE WHEN Action='ORDER' THEN 1.0 END)/(COUNT(Action)*1.0)),2) AS numeric(2,2))  AS 'Conversion_Rate'
FROM Actions
GROUP BY Adv_Type