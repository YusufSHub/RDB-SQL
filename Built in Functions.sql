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
2021-07-17	Saturday	17	7	2021	12:00:00.0000000	0	        7

select A_date, 
	DATENAME (DW, A_date) [Days],
	DAY (A_date) [Days2]
from t_date_time