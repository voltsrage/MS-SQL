USE [70-761]

-- ADD Unique Constraint on Email Address
UPDATE Person SET Email = 'tonystark@gmail.com' WHERE PersonID = 2

ALTER TABLE Person
ADD CONSTRAINT unq_Person_Email UNIQUE (Email)

BEGIN TRAN

--Looks for Unique Key Constraint
SELECT * FROM sys.indexes
WHERE OBJECT_NAME(object_id) = 'Person'

--Drops Constraint
ALTER TABLE Person
DROP CONSTRAINT unq_Person_Email

SELECT * FROM sys.indexes
WHERE OBJECT_NAME(object_id) = 'Person'

ROLLBACK TRAN

------------------------- Default ---------------------------------
BEGIN TRAN

--ALTER TABLE TRANSACTIONS
--DROP CONSTRAINT defDateOfEntry
 
--ALTER TABLE Transactions
--DROP COLUMN DateOfEntry
ALTER TABLE Transactions
ADD DateOfEntry datetime

ALTER TABLE Transactions
ADD CONSTRAINT defDateOfEntry DEFAULT GETDATE() FOR DateOfEntry


INSERT INTO Transactions(Amount,TransactionDate,PersonID)
 VALUES (562,'2015-06-23',23)

SELECT * FROM Transactions WHERE PersonID = 23

ROLLBACK TRAN

-------------------- Check ----------------------------
BEGIN TRAN
--Add Check Constraint to Person Table
ALTER TABLE Person 
ADD CONSTRAINT chk_Person_Email CHECK (Email LIKE '%@%')

--Test Constraint with Error Information
BEGIN TRY
	INSERT INTO Person VALUES ('Louie David',27,'0978434187','louiedavid hotmail.com',DEFAULT,40)
END TRY
BEGIN CATCH
	SELECT 'There was no @!' AS ErrorMsg
END CATCH

--Test Constraint with Correction Information
BEGIN TRY
	INSERT INTO Person VALUES ('Louie David',27,'0978434187','louiedavid@hotmail.com',DEFAULT,40)
	SELECT * FROM Person WHERE Age = 27
END TRY
BEGIN CATCH
	SELECT 'There was no @!' AS ErrorMsg
END CATCH

ROLLBACK TRAN

--------------- Foreign Key --------------------
 
 --Delete Foreign Key if Exists
 IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_Person_Dept' )
	ALTER TABLE Person
	DROP CONSTRAINT fk_Person_Dept

--Create Foreign Key on Person Table
 ALTER TABLE Person
 ADD CONSTRAINT fk_Person_Dept FOREIGN KEY (Department) REFERENCES Departments(DeptID)

  --Delete Foreign Key if Exists
 IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_Transaction_Person' )
	ALTER TABLE Person
	DROP CONSTRAINT fk_Transaction_Person

--Create Foreign Key on Transaction Table
 ALTER TABLE Transactions WITH NOCHECK
 ADD CONSTRAINT fk_Transaction_Person FOREIGN KEY (PersonID) REFERENCES Person(PersonID)

 --Create a Unique Clustered Index on Transaction Table
 CREATE UNIQUE CLUSTERED INDEX inx_Transactions ON dbo.Transactions(Amount,[TransactionDate],PersonID)