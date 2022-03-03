SELECT LEN('this is an example') AS sample
/* # of characters*/

SELECT LEN(NULL) AS col1, LEN(10) AS col2, LEN(10.5) AS col3

SELECT CHARINDEX('yourself', 'Reinvent yourself') AS start_position;

SELECT CHARINDEX('el', 'Reinvent yourself') AS start_position;

SELECT CHARINDEX('r', 'Reinvent yourself') AS start_position;


SELECT CHARINDEX('R', 'Reinvent yourself') AS start_position;

SELECT CHARINDEX('self', 'Reinvent yourself and ourself') AS motto;
/*14*/

SELECT CHARINDEX('self', 'Reinvent yourself and ourself', 15) AS motto;
/*26 we entered start position of 15*/

SELECT PATINDEX('%ern%', 'this is not a pattern') AS sample

SELECT PATINDEX('%er', 'this is not a serber pattern') AS sample

SELECT SUBSTRING('clarusway.com', LEN('clarusway.com')-1, LEN('clarusway.com'));

SELECT UPPER('clarusway') AS col;

SELECT LOWER('CLARUSWAY') AS col;

SELECT value from string_split('John,is,a,very,tall,boy.', ',')

SELECT value from string_split('John,is-a,very-tall,boy.', ',')

SELECT SUBSTRING('Clarusway', 1, 3) AS substr

SELECT SUBSTRING('Clarusway', 3, 3) AS substr

/* SELECT SUBSTRING('Clarusway', 4) AS substr
error substring requaires 3 arguments
SELECT SUBSTRING('Clarusway', -5) AS substr */ 

SELECT SUBSTRING('Clarusway', -6, 2) AS substr

SELECT LEFT('Clarusway', 2) AS leftchars

SELECT right('Clarusway', 2) AS leftchars

SELECT UPPER (SUBSTRING('clarusway.com', 0 , CHARINDEX('.','clarusway.com')));

SELECT TRIM('  Reinvent Yourself  ') AS new_string;

SELECT TRIM('@' FROM '@@@clarusway@@@@') AS new_string;

SELECT TRIM('-' FROM '-cla-rusway---') AS new_string;

SELECT TRIM('ca' FROM 'cadillac') AS new_string;

SELECT LTRIM('   cadillac') AS new_string;

SELECT RTRIM('   cadillac   ') AS new_string;

SELECT REPLACE('REIMVEMT','M','N');

SELECT REPLACE('I do it my way.','do','did') AS song_name;

SELECT STR(123.45, 6, 1) AS num_to_str;
/*123.5*/

SELECT STR(123.45, 4, 2) AS num_to_str;
/*123*/
SELECT STR(123.45, 3, 2) AS num_to_str;
/*123*/
SELECT STR(123.45, 7, 3) AS num_to_str;
/*123.450*/
SELECT STR(FLOOR (123.45), 8, 3) AS num_to_str;
/* 123.000*/

SELECT 'Reinvent' + ' yourself' AS concat_string;
/*Reinvent yourself*/
SELECT CONCAT('Reinvent' , ' yourself') AS concat_string;
/*Reinvent yourself*/

SELECT 'Way' + ' to ' + 'Reinvent ' + 'Yourself' AS motto;
/*Way to Reinvent Yourself*/

SELECT CONCAT ('Robert' , ' ', 'Gilmore') AS full_name 
/*Robert Gilmore*/

select 'Robert' + ' ' + 'Gilmore'
/*Robert Gilmore*/

SELECT 'customer' + '_' + CAST(1 AS VARCHAR(1)) AS col
/*customer_1*/

SELECT CAST(4599.999999 AS numeric(5,1)) AS col
/*4600.0*/

SELECT GETDATE(), CONVERT(DATE, GETDATE());

SELECT GETDATE(), CONVERT(NVARCHAR, GETDATE(), 11);

SELECT ROUND(565.49, -1) AS col;
/*570.0*/

SELECT ROUND(565.49, -2) AS col;
/*600.00*/

SELECT ROUND(123.9994, 3) AS col1, ROUND(123.9995, 3) AS col2;
/*123.9990	124.0000*/

SELECT ROUND(123.4545, 2) col1, ROUND(123.45, -2) AS col2;
/*123.4500	100.00*/

SELECT ROUND(150.75, 0) AS col1, ROUND(150.75, 0, 1) AS col2;
/*151.00	150.00*/

SELECT ISNULL(NULL, 'Not null yet.') AS col;

SELECT ISNULL(1, 2) AS col;

SELECT COALESCE(Null, Null, 1, 3) AS col

SELECT COALESCE(Null, Null, 'William', Null) AS col

SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different;

SELECT NULLIF(2,2) AS Same, NULLIF(5,7) AS Different;

SELECT NULLIF('2021-01-01', '2021-01-01') AS col

SELECT ISNUMERIC ('William') AS col

SELECT ISNUMERIC (123.455) AS col

select * from [product].[brand]
where [brand_name]='Samsung'

select * from [product].[brand]