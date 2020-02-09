IF EXISTS(Select 1 FROM sys.tables WHERE name = 'Departments')
	DROP TABLE Departments

CREATE TABLE Departments
(
	DeptID int NOT NULL CONSTRAINT pk_Dept Primary Key IDENTITY(10,10),
	DeptName varchar(30),
	DeptManager int
)

INSERT INTO Departments(DeptName,DeptManager) VALUES
('Accounting',18),
('Management',1),
('Marketing',5),
('Finance',10),
('IT',15),
('Accounts',6),
('Customer Service',12)

SELECT * FROM Departments

--Return Department Table With Manager Names
SELECT DeptID, DeptName,PersonName FROM Departments D
JOIN Person P
ON D.DeptManager = P.PersonID

--IF EXISTS (SELECT  1 FROM sys.columns where name = 'Department' and Object_Name(object_id) = 'Person')
--	ALTER TABLE Person DROP COLUMN Department

----ADD Department Table in Persons
--ALTER TABLE Person
--ADD Department int

----Adding Managers to their Departments
--MERGE Person AS T
--USING Departments AS S
--ON T.PersonID = S.DeptManager
--WHEN MATCHED THEN UPDATE SET T.Department = S.DeptID;

--SELECT Everyone in Accounts
SELECT * FROM Person 
WHERE Department = 60

SELECT * FROM Person P 
JOIN Departments D
ON P.Department = D.DeptID
WHERE DeptName = 'Accounting'
