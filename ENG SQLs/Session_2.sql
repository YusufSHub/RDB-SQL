/* Data Science - Session:2 02/28/2022 */

create table test
(Fullname varchar(45) NOT NULL,
Age int )

insert into test(Age) values (21)


insert into test values('',34)

insert into test (Fullname) values('def')


select * from test

--------------------------------
/*
1st Normal form
* All rows in the table must be unique (no duplicate rows) Primary key
* Each cell must contain only single value (not a list)
* Each value should be atomic (cannot be split further)

2nd Normal Form
* Your table must already be in 1st normal form
* There should NOT be any partial dependency on a composite Primary Key

3rd Normal Form
* Your table must already be in 2nd normal form
* No transitive dependencies, all fields must only be determinable by primary key , not by other keys
*/
--DDL-
--Create a Database
CREATE DATABASE LibDatabase;

Use LibDatabase;


--create 2 schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;

--Let's create couple of tables in the Book Schema

CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL

	);

sp_help 'Book.Book'

--create Book.Author table

CREATE TABLE [Book].[Author](
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);

--create Publisher Table
CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL
	);

--create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY NOT NULL,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);

--create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);

--cretae Person.Person_Phone table

CREATE TABLE [Person].[Person_Phone](
	[Phone_Number] [bigint] PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL	
	);

	--cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);

--dbo schema -- it is the default schema
create table NoSchema (
col1 int,
col2 char(1))
;

DROP TABLE NoSchema;

TRUNCATE TABLE --ddl permissions

DELETE from Book.Book
--WHERE AuthorName = 'Bob Marley'

DROP TABLE

--Insert commands
INSERT INTO Person.Person (SSN, Person_FirstName, Person_LastName) VALUES (75056659595,'Zehra', 'Tekin')

INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (889623212466,'Kerem')

SELECT * FROM Person.Person

SELECT *
INTO Person.Person_Copy
FROM Person.Person

select * from Person.Person_Copy

--INSERT INTO [Book].[Book] ([Book_ID], [Book_Name], [Author_ID], [Publisher_ID]) VALUES (

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)



	   SELECT @@SERVERNAME

	   SELECT @@VERSION


	INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (78962212466,'Kerem')

	SELECT * from Person.Person

	INSERT Person.Person VALUES (55556698752, 'Esra', Null)

	INSERT Book.Publisher
([Publisher_Name]) VALUES ('Sun Publishers')


sELECT * FROM Book.Publisher

SELECT @@IDENTITY