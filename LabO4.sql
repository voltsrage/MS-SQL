SELECT CompanyName,AddressLine1,City,'Billing' AS AddressTypes FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Main Office'

UNION ALL

SELECT CompanyName,AddressLine1,City,'Shipping' FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Shipping'
ORDER BY CompanyName,AddressTypes

--Companies with only a Main Office Address

SELECT CompanyName FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Main Office'

EXCEPT

SELECT CompanyName FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Shipping'
ORDER BY CompanyName

--Companies that have both a Main Office and Shipping Address

SELECT CompanyName FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Main Office'

INTERSECT 

SELECT CompanyName FROM SalesLT.Customer C
JOIN SalesLT.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID = A.AddressID
WHERE AddressType = 'Shipping'
ORDER BY CompanyName
