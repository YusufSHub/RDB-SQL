/*Factorial Function
Create a scalar-valued function that returns the factorial of a number you gave it.*/


CREATE FUNCTION factorial
(@mynumber INT)

RETURNS INT

BEGIN
 declare @counter INT, @total INT

	SET @counter = 1
	SET @total = 1

	while @counter <= @mynumber
		BEGIN
		set @total = @total* @counter
		set @counter = @counter + 1
		END;
    RETURN @total
END;

print dbo.factorial(5)

select dbo.factorial(5)