CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);


INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE()) 

SELECT * from t_date_time


INSERT t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);
VALUES ("12:00:00", "2022-03-02", "2022-03-02","2022-03-02","2022-03-02","2022-03-02") 

SELECT CONVERT (VARCHAR, GETDATE(), 6)
/*220303 (number at the end gives me different format)
SQL Datetime Style Codes*/
SELECT CONVERT (VARCHAR, GETDATE(), 10)
/*03-03-22*/

SELECT CONVERT (VARCHAR, GETDATE(), 112
/*20220303*/

SELECT * from t_date_time

SELECT DATENAME(month, GETDATE()) /*March*/

SELECT DATENAME (MONTH, '11/23/2021'); /*November*/

SELECT DATENAME (M, '11/23/2021'); /*November*/

SELECT DATEPART (month, '11/23/2021'); /*11*/

SELECT DATEPART (DAY, '11/23/2021'); /*23*/

SELECT DATEPART (MONTH, GETDATE()) as Months, DATEPART(day, '11/23/2021') as Day

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date) [month],
		YEAR (A_date)[year],
		A_time [time],
		DATEPART (NANOSECOND, A_time) [nanosecod],
		DATEPART (MONTH, A_date) [month]
FROM	t_date_time

SELECT DATEDIFF (day, '02/01/2021', GETDATE());

SELECT DATEDIFF (day, '06/12/1989', GETDATE());
/* 11952 days i am alive*/ 

SELECT A_date,
		A_smalldatetime,
		DATEDIFF(day, A_date, A_smalldatetime) as DayDiff
from t_date_time

select * from [sale].[orders]

select order_id, 
	DATEDIFF(day, order_date, shipped_date) as DaystoShip
from [sale].[orders] /* returns difference days took ship orders*/

select order_id, order_date, shipped_date,
	DATEDIFF(day, order_date, shipped_date) as DaystoShip
from [sale].[orders] /* returns difference days took ship orders*/

select EOMONTH (GETDATE()); /*eo means end of the month*/

select day(EOMONTH (GETDATE()));

select day(EOMONTH ('04/06/2021'));

select day(EOMONTH ('02/06/2020')); /*29 days*/

select ISDATE('HelloWorld!') /* returns boolean*/

select ISDATE(9999)

select ISDATE('9999')

-- Write a query where ship days more than 2 days
select *, DATEDIFF(day, order_date, shipped_date) as DaystoShip
from [sale].[orders]
where DATEDIFF(day, order_date, shipped_date) >2


Select GETDATE() as now;


select DATENAME (WEEKDAY, '1989-12-06') as day; 
/* returns name of the day as Wednesday*/
/*nvarchar format.*/

select DATENAME (MONTH, '06-12-1989') as day; 
/* returns name of the month as June*/

select DATENAME (DAYOFYEAR, '06-12-1989') as day;
/*163*/


select DATEPART (minute, GETDATE());
/* returns minutes as an integer*/

select DATEPART (HOUR, GETDATE());

select DATEPART (DAYOFYEAR, GETDATE());
/*Tips: There ara fourty datepart tips in SQL Server you can use. 
Such as: DAY, HOUR, MINUTE, WEEKDAY, YEAR, DAYOFYEAR, MONTH, etc.*/

select day('1989-06-12') as day;
/* returns day of the date as an integer*/

select MONTH (GETDATE());
/* return month of the date as an integer. 3 */

select month('1989-06-12') as month;

select year('1989-06-12') as year;

select DATEDIFF(week, '1989-06-12', GETDATE());
/* weeks i am alive*/

select DATEDIFF(DAY, '1989-06-12', GETDATE());
/* days i am alive*/


select DATEDIFF(YEAR, '1989-06-12', GETDATE());


SELECT DATEADD (SECOND, 1, '2021-12-31 23:59:59') AS NewDate

SET DATEFORMAT DMY

select ISDATE ('12/06/1989')

select ISDATE ('12-06-1989')

select ISDATE ('1989-06-10')

select ISDATE ('10-1989-10')
