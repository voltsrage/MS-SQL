SELECT ProductID,UPPER(Name) Name,ROUND(Weight,0) ApproxWeight ,YEAR(SellStartDate) SellStartYear
		,DATENAME(mm,SellStartDate) SellStartMonth,LEFT(ProductNumber,2) ProductType FROM SalesLT.Product

SELECT ProductID,UPPER(Name) Name,ROUND(Weight,0) ApproxWeight ,YEAR(SellStartDate) SellStartYear
		,DATENAME(mm,SellStartDate) SellStartMonth,LEFT(ProductNumber,2) ProductType FROM SalesLT.Product
		WHERE ISNUMERIC(Size) = 1


SELECT CompanyName,TotalDue,RANK() OVER(ORDER BY TotalDue DESC) TotalRank FROM SalesLT.Customer C
JOIN SalesLT.SalesOrderHeader OH
ON C.CustomerID = OH.CustomerID

SELECT Name,SUM(LineTotal) LineSales FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail OD
ON P.ProductID = OD.ProductID
GROUP BY Name
ORDER BY LineTotal DESC

SELECT Name,SUM(LineTotal) LineSales FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail OD
ON P.ProductID = OD.ProductID
WHERE ListPrice > 1000
GROUP BY Name
ORDER BY LineTSales DESC

SELECT Name,SUM(LineTotal) LineSales FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail OD
ON P.ProductID = OD.ProductID
WHERE ListPrice > 1000
GROUP BY Name
HAVING SUM(LineTotal) > 20000
ORDER BY LineSales DESC



