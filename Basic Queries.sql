USE [70-761]

--Get all Table Information
SELECT * FROM Person

--Return Everyone with an Email 
SELECT * FROM Person
WHERE Email <> 'N/A'

--Return Everyone without an Email 
SELECT * FROM Person
WHERE Email = 'N/A'

--Return Everyone over 25ys old
SELECT * FROM Person
WHERE Age > 25

--Return Everyone Between and including 30  and 50 ys old
SELECT * FROM Person
WHERE Age >= 30 and Age <= 50

--Return Names and Phone Number of Everyone Between and including 30  and 50 ys old
SELECT PersonName, Phone FROM Person
WHERE Age BETWEEN 30 AND 50

--Return Names and Ages of Everyone whose name starts with A
SELECT PersonName, Age FROM Person
WHERE PersonName LIKE 'A%'

--Return Names and Ages of Everyone whose name starts with A,J or R
SELECT PersonName, Age FROM Person
WHERE PersonName LIKE '[AJR]%'

--Return Names and Ages of Everyone whose name doesn't start with A,J or R
SELECT PersonName, Age FROM Person
WHERE PersonName LIKE '[^AJR]%'

--Return Names and Ages of Everyone whose name starts with letter between J and R
SELECT PersonName, Age FROM Person
WHERE PersonName LIKE '[J-R]%'
ORDER BY PersonName

--Return Names and Ages of Everyone whose is 18 , 25 40 or 65
SELECT PersonName, Age FROM Person
WHERE Age in (18,25,40,65)

--Return Everyone entered in 2007
SELECT * FROM Person
WHERE YEAR(EntryDate) = '2007'

--Return Everyone entered before 2010
SELECT * FROM Person
WHERE EntryDate < '20100101'


--Return Everyone entered between 2015 and today
SELECT * FROM Person
WHERE EntryDate >= '20150101' AND EntryDate <= GETDATE()

