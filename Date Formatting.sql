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