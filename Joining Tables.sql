USE [70-761]
--JOIN Person Table to Transaction Table
SELECT * FROM Person P
JOIN Transactions T
ON P.PersonID = T.PersonID

--Check to See Which Persons have made no transactions
SELECT P.PersonID,P.PersonName,P.Email FROM Person P
Left JOIN Transactions T
ON P.PersonID = T.PersonID
WHERE T.PersonID IS NULL

--Check to See which transaction Persons not listed in Person Table
SELECT T.* FROM Person P
Right JOIN Transactions T
ON P.PersonID = T.PersonID
WHERE P.PersonID IS NULL AND T.PersonID IS NOT NULL

--Check to see those transactions which have no PersonID
SELECT T.* FROM Person P
Right JOIN Transactions T
ON P.PersonID = T.PersonID
WHERE P.PersonID IS NULL AND T.PersonID IS NULL

--Check to See Which Department has the most transactions
SELECT TOP 1 DeptName,COUNT(*) Transactions FROM Transactions T
JOIN Person P
ON P.PersonID = T.PersonID
JOIN Departments D
ON P.Department = D.DeptID
GROUP BY DeptName
ORDER BY Transactions DESC

--Check to See Which Department has the least transactions
SELECT TOP 1 DeptName,COUNT(*) Transactions FROM Transactions T
JOIN Person P
ON P.PersonID = T.PersonID
JOIN Departments D
ON P.Department = D.DeptID
GROUP BY DeptName
ORDER BY Transactions

--Check to See Each Departments Total Transactions Amount
SELECT DeptName,FORMAT(SUM(Amount),'C') Total FROM Transactions T
JOIN Person P
ON P.PersonID = T.PersonID
JOIN Departments D
ON P.Department = D.DeptID
GROUP BY DeptName
ORDER BY SUM(Amount) DESC 

--Check Total Transaction Statistics
SELECT PersonName, FORMAT(SUM(Amount),'C') TotalTransactions
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

--Retrieve the best performing Employee by Total Transactions Amount
SELECT TOP 1 PersonName, FORMAT(SUM(Amount),'C') TotalTransactions FROM Person P
JOIN Transactions T
ON P.PersonID = T.PersonID
GROUP BY PersonName
ORDER BY SUM(Amount) DESC

--Retrieve the least performing Employee by Total Transactions Amount
SELECT TOP 1 PersonName, FORMAT(SUM(Amount),'C') TotalTransactions FROM Person P
JOIN Transactions T
ON P.PersonID = T.PersonID
GROUP BY PersonName
ORDER BY SUM(Amount)

