USE [70-761]

--Drop Table If It Exists
IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'Person')
	DROP TABLE dbo.Person
GO 

--Create Person Table
CREATE TABLE Person
(
	PersonID int NOT NULL CONSTRAINT Pk_Person PRIMARY KEY IDENTITY
	,PersonName nvarchar(50) NULL
	,Age tinyint NULL
	,Phone char(10) NULL
)

--INSERT 3 Records into Table
INSERT INTO Person(PersonName,Age,Phone) VALUES
		('Peter Parker',18,'0325484945'),
		('Tony Stark',35,'0154784612'),
		('Pepper Potts',30,'0741634879')


--Retrieve Table Data
SELECT * FROM Person

--Add Email Column with a Default for the older columns
ALTER TABLE Person
ADD Email varchar(100) NOT NULL CONSTRAINT def_Email DEFAULT 'N/A'

SELECT * FROM Person

--Delete Data From Table
BEGIN TRAN

DELETE FROM Person WHERE PersonID = 2
SELECT * FROM Person

ROLLBACK TRAN

--Truncate Table Data
BEGIN TRAN

TRUNCATE TABLE Person
SELECT * FROM Person

ROLLBACK TRAN