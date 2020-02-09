--Gets all transactions for everyone whose name begins with 'M' (INTERSECT)
SELECT * FROM Transactions
WHERE PersonID in 
(SELECT PersonID FROM Person WHERE PersonName Like 'm%') --Gets IDs of Everyone whose name starts with 'M'

--Gets all transactions for everyone whose name does not begin with 'M' (INNER JOIN)
SELECT * FROM Transactions
WHERE PersonID in 
(SELECT PersonID FROM Person WHERE PersonName not Like 'm%') 
 --Gets IDs of Everyone whose name does not start with 'M'

 --Subtracts All IDs in the subquery from the Main Query Results (EXCEPT)
SELECT * FROM Transactions
WHERE PersonID not in 
(SELECT PersonID FROM Person WHERE PersonName Like 'm%') 
--Gets IDs of Everyone whose name starts with 'M'

----------------------------- Any/Some ----------------------------------
--Give the same result
SELECT * FROM Transactions
WHERE PersonID = ANY
(SELECT PersonID FROM Person WHERE PersonName Like 'c%')

SELECT * FROM Transactions
WHERE PersonID = SOME
(SELECT PersonID FROM Person WHERE PersonName Like 'c%')

SELECT * FROM Transactions
WHERE PersonID in
(SELECT PersonID FROM Person WHERE PersonName Like 'c%')
-----------------------------------------------------------------------------------------
--For negations ALL is better (similar to not in)
SELECT * FROM Transactions
WHERE PersonID <> ALL
(SELECT PersonID FROM Person WHERE PersonName Like 'c%')

SELECT * FROM Transactions
WHERE PersonID not in 
(SELECT PersonID FROM Person WHERE PersonName Like 'c%') 
-------------------------------------------------------------------------------------------
--Will return the results for Any Person Lower than the Smallest Number in the Subquery
SELECT * FROM Transactions
WHERE PersonID <= ANY 
(SELECT PersonID FROM Person WHERE PersonName Like 'm%') 

--Will return the results for ONLY PersonIDs Lower than the Largest Number in the Subquery
SELECT * FROM Transactions
WHERE PersonID <= ALL 
(SELECT PersonID FROM Person WHERE PersonName Like 'm%')

--Get the Best Performing Employees of Each Dept
SELECT DeptName,PersonID,PersonName,Email,Amount,TransactionDate FROM
(SELECT DeptName,P.PersonID,PersonName,Email,Amount,TransactionDate,
	   RANK() OVER(PARTITION BY DeptName ORDER BY P.PersonID,Amount DESC) AS PersonRank FROM Departments D
JOIN Person P
ON D.DeptID = P.Department 
JOIN Transactions T
ON P.PersonID = T.PersonID) AS EmployeeTrans
WHERE PersonRank <= 5

--Get the Worst Performing Employees of Each Dept
SELECT DeptName,PersonID,PersonName,Email,Amount,TransactionDate FROM
(SELECT TOP 100 PERCENT DeptName,P.PersonID,PersonName,Email,Amount,TransactionDate,
	   ROW_NUmber() OVER(PARTITION BY DeptName ORDER BY T.PersonID) AS PersonRank FROM Departments D
JOIN Person P
ON D.DeptID = P.Department 
JOIN Transactions T
ON P.PersonID = T.PersonID
) AS EmployeeTrans
WHERE PersonRank < 5
ORDER BY DeptName,PersonID
