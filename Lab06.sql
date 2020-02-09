SELECT P.ProductID,Name, ListPrice FROM SalesLT.Product P
WHERE ListPrice > 100 AND 100 > ANY
(Select UnitPrice FROM SalesLT.SalesOrderDetail OD WHERE OD.ProductID = P.ProductID)

SELECT DISTINCT P.ProductID,P.ListPrice,OD.UnitPrice FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail OD
ON P.ProductID = OD.ProductID
WHERE ListPrice > 100 AND UnitPrice < 100
ORDER BY P.ProductID

SELECT P.ProductID, Name,StandardCost,ListPrice,
		(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail OD WHERE OD.ProductID = P.ProductID) AvgPrice
		FROM  SalesLT.Product P
ORDER BY ProductID

SELECT SalesOrderID,OH.CustomerID,FirstName,LastName,TotalDue FROM SalesLT.SalesOrderHeader OH
CROSS APPLY dbo.ufnGetCustomerInformation(OH.CustomerID)

SELECT CA.CustomerID,FirstName,LastName,AddressLine1,City FROM SalesLT.Address A
JOIN SalesLT.CustomerAddress CA
ON A.AddressID = CA.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(CA.CustomerID)
