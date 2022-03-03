select * from t_date_time

select GETDATE();


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

select CONVERT(varchar, GETDATE(), 7)
/*Mar 03, 22*/

select CONVERT(varchar, GETDATE(), 2)
/*22.03.03*/

select CONVERT(varchar, GETDATE(), 4)
/*03.03.22*/

select CONVERT(DATE, '03 March 22', 6)
/*2022-03-03*/

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date) [Month],
		YEAR (A_date)[Year],


		A_time,
		DATEPART (NANOSECOND, A_time) [Nanosecond],
		DATEPART (MONTH, A_date) [Month]
FROM	t_date_time

/*
2022-03-03	Thursday	3	3	2022	00:22:05.3700000	370000000	3
2021-07-17	Saturday	17	7	2021	12:00:00.0000000	0	        7*/

select A_date, 
	DATENAME (DW, A_date) [Days],
	DAY (A_date) [Days2]
from t_date_time


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day,
		DATEDIFF (MONTH, A_date, A_datetime) Diff_month,
		DATEDIFF (YEAR, A_date, A_datetime) Diff_month,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time

SELECT order_date,
		DATEADD (YEAR, 3, order_date) [new_year],
		DATEADD (DAY, -5, order_date) [new_day]
FROM [sale].[orders]

select EOMONTH (DAY, '2024-02-29')

SELECT DAY(EOMONTH('02/15/2024'));


SELECT *
FROM [sale].[orders]
SELECT order_date,
		DATEADD (YEAR, 3, order_date) new_year,
		DATEADD (DAY, -5, order_date) NEW_DAY
FROM [sale].[orders]
-- EOMONTH
SELECT EOMONTH(order_date) LAST_DAY, order_date, EOMONTH(order_date, 2) after_2
FROM [sale].[orders]

select ISDATE ('01-01-999')

select ISDATE ('01-01-1999')

select ISDATE ('01-01-1972')


SELECT CHARINDEX('r', 'Reinvent yourself') AS start_position;


SELECT CHARINDEX('R', 'Reinvent yourself') AS start_position;

select CHARINDEX('C', 'CHARACTER', 2) /* 6 */

select PATINDEX('%R', 'CHARACTER') /* 9 */

select PATINDEX('R%', 'CHARACTER') /* 0 */

SELECT PATINDEX ('___R%','CHARACTER') /* 1 */

SELECT LEFT('CHARACTER', 3)
SELECT LEFT(' CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)
SELECT RIGHT('CHARACTER ', 3)

SELECT SUBSTRING('CHARACTER', 3, 5) --ARACT
SELECT SUBSTRING('CHARACTER', -1, 5) --CHA D�ND�R�R

SELECT SUBSTRING('CHARACTER', -2, 5) --CHA D�ND�R�R


-- make only C in 'character' upper
SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character',8))

SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character',LEN ('character')-1))

SELECT TRIM ('     CHARACTER')

SELECT TRIM ('     CHARACTER     ')

SELECT TRIM ('     CHAR ACTER     ')

SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;


SELECT REPLACE('CHARACTER STRING', ' ', '/')

select STR(412); -- prints up to 10 characters

select str(1234567892220);

select str(5454, 10, 5)

SELECT STR (133215.654645, 11, 3)


SELECT STR (133215.654645, 9, 3)


select CAST (456123 as char)

select CONVERT (varchar(10), '2020-10-10')

select coalesce(null, null, 'Hi', 'Hello', null )

select nullif('Hello', 'Hi');