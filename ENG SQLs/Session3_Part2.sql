/* Session: 3: Part 2 03/03/2022 
	STRING FUNCTIONS 
*/

SELECT * FROM string_split ('John;Jack; Jeremy;Josh', ';')

--TRIM

SELECT TRIM('  CHARACTER ')
'CHARACTER'

SELECT LTRIM ('  CHARACTER ')
'CHARACTER '

SELECT RTRIM ('CHARACTER   ')
'CHARACTER'

TRIM = LTRIM + RTRIM ?

SELECT LTRIM(RTRIM ('  CHARACTER '))
'CHARACTER'

SELECT TRIM('CHA  RAC  TER')

--REPLACE
SELECT REPLACE('CHARACTER STRING',' ','-')

SELECT REPLACE('HAPPY BIRTHDAY TO YOU', ' ', '/')

SELECT STR(1234)
'      1234'

SELECT STR(1234,4)
'1234'

SELECT STR(1234,10,5)
'1234.00000'

SELECT STR(1345264.45678,10,3)

SELECT CAST(12345 as CHAR)

SELECT CAST(123.45 AS INT)
-------------------------

SELECT CONVERT(INT, 30.60)

SELECT CONVERT(VARCHAR(30), GETDATE(),112)

SELECT getdate()

--ROUND

SELECT ROUND(432.145,2,0)

SELECT ROUND(432.145,2,1)

SELECT ROUND(456.2345,3)

SELECT ISNULL (NULL,'S')

SELECT ISNULL(Age,18) from test

SELECT COALESCE(NULL, NULL, NULL, 'Hi',NULL, 'Hello');

--NULLIF
SELECT NULLIF('Hello','Hello')

SELECT NULLIF(2,2)

SELECT NULLIF('Hello','Hi')

SELECT ISNUMERIC ('1234')

-- How many yahoo mails in customer’s email column?
SELECT COUNT(email)
FROM [sale].[customer]
WHERE email LIKE '%yahoo%'

SELECT COUNT(email)
 FROM [sale].[customer]
WHERE   PATINDEX('%yahoo%',email) > 0

--Write a query that returns the characters before the '@' character in the email column.
SELECT LEFT(email,CHARINDEX('@',email)-1) FullName, email
FROM [sale].[customer]

---Add a new column to the customers table that contains the customers' 
--contact information. 
--If the phone is available, the phone information will be printed, if not, 
--the email information will be printed.

SELECT *,COALESCE(phone,email) AS ContactInformation
FROM [sale].[customer]

--Write a query that returns streets. The third character of the streets is numerical.
SELECT street, SUBSTRING(street,3,1)
FROM [sale].[customer]
WHERE ISNUMERIC(SUBSTRING(street,3,1)) = 1
-
SELECT street, SUBSTRING(street,3,1)
FROM [sale].[customer]
WHERE SUBSTRING(street,3,1) LIKE '[0-9]'

SELECT street, SUBSTRING(street,3,1)
FROM [sale].[customer]
WHERE SUBSTRING(street,3,1)  LIKE '[^0-9]'

A = B
A != B

LIKE [0-9]
LIKE [^0-9]

LIKE [0-9]
NOT LIKE [^0-9]

--Split the values in the mail column into two parts with '@'

SELECT LEFT(email,CHARINDEX('@',email)-1) as LEftPart
, RIGHT(email,LEN(email) - CHARINDEX('@',email)) as RightPart
FROM [sale].[customer]
/***************************************
--In the street column, clear the string characters that were accidentally added 
to the end of the initial numeric expression.

-------Home Work
****************************************/

