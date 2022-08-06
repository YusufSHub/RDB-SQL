/* Session: 3: 03/02/2022 */
SELECT GETDATE() AS Current_DateTime --aliasing

--https://docs.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver15

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);

SELECT * FROM t_date_time;

INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

INSERT t_date_time (A_date) VALUES ('ABC') -- not valid


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2022-03-02', '2022-03-02','2022-03-02', '2022-03-02', '2022-03-02' )

SELECT GETDATE();

SELECT CONVERT(VARCHAR, GETDATE(),6);

SELECT CONVERT(VARCHAR, GETDATE(),10);

SELECT CONVERT(VARCHAR, GETDATE(),112);

SELECT CONVERT(DATE, '02 Mar 22', 6);

/*
DateName function accepts following parameters:
	Required. The part to return. Can be one of the following values:
year, yyyy, yy = Year
quarter, qq, q = Quarter
month, mm, m = month
dayofyear = Day of the year
day, dy, y = Day
week, ww, wk = Week
weekday, dw, w = Weekday
hour, hh = hour
minute, mi, n = Minute
second, ss, s = Second
millisecond, ms = Millisecond
*/

SELECT DATENAME(month, GETDATE());

SELECT DATENAME(month, '11/23/2021');

SELECT DATENAME (MONTH, '11/23/2001');


SELECT DATEPart(month, GETDATE());

SELECT DATEPART(month, '11/23/2021');

SELECT DATEPART(day, '11/23/2021');

SELECT DATENAME(day, '11/23/2000'); -- returns string


SELECT DATEPart(month, GETDATE()) as months, DATEPART(day, '11/23/2021') as Day

SELECT * FROM 	t_date_time

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time;

SELECT DATEDIFF(month, '02/01/2022', '04/28/2022');


SELECT * FROM t_date_time

SELECT 
	 A_date
	,A_smalldatetime
	,DATEDIFF(day, A_date,A_smalldatetime) as Daydiff
FROM t_date_time


SELECT * FROM 
[sale].[orders]

SELECT 
order_id
, order_date
,shipped_date
, DATEDIFF(day, order_date, shipped_date) as DaysToShip
FROM [sale].[orders]

SELECT DATEDIFF (day, '01/01/1990', GETDATE()) AS [days i am alive]


SELECT 
order_id,
order_date,
DATEADD(YEAR, 5,order_date) as added5y,
DATEADD(MONTH, 3, order_date) as added3m,
DATEADD (DAY, -5, order_date) as sub5y
FROM [sale].[orders]

SELECT EOMONTH(GETDATE());

SELECT EOMONTH('02/02/2022');

SELECT DAY(EOMONTH('02/15/2022'));

SELECT DAY(EOMONTH('02/15/2021'));

SELECT DAY(EOMONTH('02/15/2020'));

SELECT DAY(EOMONTH('02/15/2024'));

SELECT ISDATE ('HelloWorld!')

SELECT ISDATE ('03/02/2022')

SELECT ISDATE ('03/02/202')

SELECT ISDATE('2001')
--------------------------------

--Write a query that returns orders that are shipped more than two days 
--after the ordered date. 

SELECT *, DATEDIFF(day,order_date,shipped_date) as daydifference
FROM [sale].[orders]
WHERE DATEDIFF(day,order_date,shipped_date) > 2


--Write a query that returns the order count of each state by month.

SELECT A.state,MONTH(B.order_date) AS MonthOfYear, COUNT(distinct order_id) AS NumOFOrders
FROM [sale].[customer] A JOIN [sale].[orders] B ON A.customer_id = B.customer_id
GROUP BY A.state, MONTH(B.order_date)
ORDER BY 1,2
---------------------------------------
----STRING FUNCTIONS ------------------
---------------------------------------

SELECT LEN('123456')

SELECT LEN(123456)

SELECT LEN('WELCOME')

SELECT LEN(' WELCOME')

SELECT LEN('Jack''s phone')

SELECT CHARINDEX('C','CHARACTER',1)

SELECT CHARINDEX('C','CHARACTER',2)

SELECT CHARINDEX('CT','CHARACTER',1)

firstname.lastname@yahoo.com
first.last@gmail.com

SELECT PATINDEX('%R','CHARACTER')

SELECT PATINDEX('R%','CHARACTER')

SELECT PATINDEX('%R%','CHARACTER')

SELECT PATINDEX('%AR%','CHARACTER')

SELECT PATINDEX('_H%','CHARACTER')

SELECT PATINDEX('%C%C%','ACHARACTER')

SELECT CHARINDEX('C','ACHARACTER',CHARINDEX('C','ACHARACTER', 1)+1)

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT RIGHT('CHARACTER ', 3)

SELECT SUBSTRING('CHARACTER', 3,4)

SELECT SUBSTRING('12345678', 3,2)

SELECT SUBSTRING('CHARACTER', -1,4)

SELECT * FROM sale.customer

SELECT email, SUBSTRING(email,CHARINDEX('@',email)+1, LEN(email)- CHARINDEX('@',email)) as email_domain

FROM sale.customer

DianeFlosi@msn.com

LEFT / RIGHT

SELECT UPPER('character')

SELECT LOWER('CHARACTER')

SELECT UPPER(LEFT('character',1))+ lower(right('character',8))