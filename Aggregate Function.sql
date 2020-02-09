--Age Stats Since Opening
SELECT MAX(Age) Oldest,MIN(Age) Youngest,AVG(Age) AverageAge FROM Person

--Return the Oldest and Youngest Person
SELECT PersonName, Age FROM Person
WHERE Age = (SELECT MAX(Age) FROM Person)

SELECT PersonName,Age FROM Person -- Youngest Person
WHERE Age = (SELECT MIN(Age) FROM Person)

--Yearly Age Statistics
SELECT  Year(EntryDate) EntryDate,MAX(Age) Oldest,MIN(Age) Youngest,AVG(Age) AverageAge FROM Person
GROUP BY Year(EntryDate)

--Return how many people under 25
SELECT COUNT(*) Persons FROM Person
WHERE Age < 25

--Return how many people entered every year in the second half of the year
SELECT Year(EntryDate) EntryDate, COUNT(*) Persons FROM Person
WHERE MONTH(EntryDate) > 6
GROUP BY Year(EntryDate)

--Count Persons by their initials Appearing more than once
SELECT LEFT(PersonName,1) Initials,COUNT(*) Total FROM Person
GROUP BY LEFT(PersonName,1) 
HAVING COUNT(*) > 1
ORDER BY Initials
