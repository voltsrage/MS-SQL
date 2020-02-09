IF EXISTS(SELECT 1 FROM sys.views WHERE name = 'vGetPersonTransactionStats')
	DROP VIEW vGetPersonTransactionStats

GO 

CREATE VIEW vGetPersonTransactionStats
AS
SELECT TOP (100) PERCENT PersonName, FORMAT(SUM(Amount),'C') TotalTransactions
				,FORMAT(MAX(Amount),'C') MAXAmt
				,FORMAT(AVG(Amount),'C') AVGAmt
				,FORMAT(MIN(Amount),'C') MINAmt
				,COUNT(*) Transactions
				,DeptName FROM Departments D
				JOIN Person P
				ON D.DeptID = P.Department
JOIN Transactions T
ON P.PersonID = T.PersonID
GROUP BY PersonName,DeptName
ORDER BY SUM(Amount) DESC

GO

SELECT * FROM vGetPersonTransactionStats

--The Script From the View Can be found in the 'text' Column of the sys.comments table
-- Use the Following Query
SELECT OBJECT_NAME(object_id) AS ViewName,text AS ViewScript FROM sys.syscomments C
JOIN sys.views V
ON C.id = V.object_id

 --OR
 select OBJECT_DEFINITION(object_id('vGetPersonTransactionStats')) ViewScript

 --OR
 SELECT OBJECT_NAME(V.object_id) AS ViewName,definition AS ViewScript FROM sys.sql_modules M
JOIN sys.views V
ON M.object_id = V.object_id


-- To prevent this use WITH ENCRYPTION
GO
IF EXISTS(SELECT 1 FROM sys.views WHERE name = 'vGetDeptTotals')
	DROP VIEW vGetDeptTotals
GO

CREATE VIEW vGetDeptTotals WITH ENCRYPTION
AS 
SELECT TOP 100 Percent PersonName, FORMAT(SUM(Amount),'C') TotalTransactions
				,FORMAT(MAX(Amount),'C') MAXAmt
				,FORMAT(AVG(Amount),'C') AVGAmt
				,FORMAT(MIN(Amount),'C') MINAmt
				,COUNT(*) Transactions
				,DeptName FROM Departments D
				JOIN Person P
				ON D.DeptID = P.Department
JOIN Transactions T
ON P.PersonID = T.PersonID
GROUP BY PersonName,DeptName
ORDER BY SUM(Amount) DESC

GO

SELECT OBJECT_NAME(object_id) AS ViewName,text AS ViewScript FROM sys.syscomments C
JOIN sys.views V
ON C.id = V.object_id

 --OR
 select OBJECT_DEFINITION(object_id('vGetPersonTransactionStats')) ViewScript

 --OR
 SELECT OBJECT_NAME(V.object_id) AS ViewName,definition AS ViewScript FROM sys.sql_modules M
JOIN sys.views V
ON M.object_id = V.object_id

--Script For Second View Appear as NULL or not at all

-------------------Update View ------------------
BEGIN TRAN
SELECT * FROM vGetPersonTransactionStats
--Can't change Views,Distinct,Group BY or Pivot/UnPivot with Aggregrates
UPDATE vGetPersonTransactionStats SET PersonName = 'Brent Lawrence' WHERE PersonName = 'Jack Ramthun'
SELECT * FROM vGetPersonTransactionStats
ROLLBACK TRAN

-----------------------------------------------
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name = 'vWTransactions')
	DROP VIEW vWTransactions
GO

CREATE View vWTransactions
AS
SELECT P.PersonID,PersonName,DeptName,Amount,TransactionDate FROM Departments D
LEFT JOIN Person P
ON D.DeptID = P.Department
LEFT JOIN Transactions T
ON P.PersonID = T.PersonID
WHERE P.PersonID BETWEEN 5 AND 8

GO

SELECT * FROM vWTransactions

-----------------Update View ---------------
BEGIN TRAN

SELECT * FROM vWTransactions
--Change Name of Person 5
UPDATE vWTransactions SET PersonName = 'Brent Lawrence' WHERE PersonID = 5
SELECT * FROM vWTransactions
ROLLBACK TRAN

-- Adding WITH CHECK OPTION Prevents ANY DML take affect the Visibility of the Rows initally greated
-- E.G. UPDATE vWTransactions SET PersonID = 23 WHERE PersonID = 5
-- This is invalid because it removes all the ROWS with PersonID 5 from the View

-- On Views based on multiple tables DELETE cannot be used since it affects all of the tables
-- involved.

-- ------------------- Create Indexed View --------------------
--Schemas must be used
--Only inner joins
--Uses WITH SchemaBinding
IF EXISTS(SELECT 1 FROM sys.views WHERE name = 'vWTransactions')
	DROP VIEW vWTransactions
GO

CREATE View dbo.vWTransactions 
AS
SELECT P.PersonID,PersonName,DeptName,Amount,TransactionDate FROM dbo.Departments D
JOIN dbo.Person P
ON D.DeptID = P.Department
JOIN dbo.Transactions T
ON P.PersonID = T.PersonID
WHERE P.PersonID BETWEEN 5 AND 8

GO

--IF EXISTS(SELECT 1 FROM sys.indexes WHERE NAME = 'inx_vWTransactions')
--	SELECT 1
	
--CREATE UNIQUE CLUSTERED INDEX inx_vWTransactions on dbo.vWTransactions(PersonID,DeptName,Amount,TransactionDate)


