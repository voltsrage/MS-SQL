--IF EXISTS (SELECT 1 FROM sys.tables WHERE NAME = 'Attendance')
--	DROP TABLE Attendance

--GO

--CREATE TABLE Attendance
--(
--	PersonID int,
--	AttendanceMonth date,
--	AttendanceNumber smallint,
--	CONSTRAINT pk_Attendance PRIMARY KEY(PersonID,AttendanceMonth),
--	CONSTRAINT fk_Attendance_Person FOREIGN KEY (PersonID) REFERENCES
--	Person(PersonID)
--)

--GO

--Gives the Year Total For Everyone
SELECT PersonID, AttendanceMonth, AttendanceNumber, SUM(AttendanceNumber) OVER(Partition BY YEAR(AttendanceMonth)) AttendanceTotal FROM Attendance

--Gives the Yearly Total For each Employee
SELECT PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ) AttendanceTotal 
		FROM Attendance

--Gives the Yearly Total For each Employee As Running Total For Each Consecutive Month
SELECT PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth) AttendanceTotal 
		FROM Attendance

--Gives the Running Total of Each Employee Which includes current, previous and next Month
SELECT PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth) AttendanceTotal,
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth
								   ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AttendanceTotal  
		FROM Attendance

--This is the specific Definition of A Running Total
SELECT PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth) AttendanceTotal,
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth
								   ROWS BETWEEN UNBOUNDED PRECEDING AND 0 FOLLOWING) AttendanceTotal  
		FROM Attendance

--This is the specific Definition of A Reverse Running Total
SELECT PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth) AttendanceTotal,
		SUM(AttendanceNumber) OVER(Partition BY PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth
								   ROWS BETWEEN 0 PRECEDING AND UNBOUNDED FOLLOWING) AttendanceTotal  
		FROM Attendance

--Range Can Only be used with CURRENT ROW AND UNBOUNDED PRECEDING/FOLLOWING
-- Range includes ties while Row does not When dupliclates are involved
-- Range is slower
SELECT P.PersonID, AttendanceMonth, AttendanceNumber, 
		SUM(AttendanceNumber) OVER(Partition BY P.PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth
								   ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AttendanceTotal  ,
		SUM(AttendanceNumber) OVER(Partition BY P.PersonID,Year(AttendanceMonth)
								   ORDER BY AttendanceMonth
								   RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AttendanceTotal  
		FROM Person P
		JOIN (SELECT * FROM Attendance UNION ALL SELECT * FROM Attendance) AS A
		ON P.PersonID = A.PersonID

--Select NULL used when Only RowNumbers are needed
SELECT *,ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) RowNumber FROM Attendance

-----------------First Value/Last Value ---------------------
--Default - RANGE Between Unbounded Preceding AND Current Row
--So, For Last Value, USE ROWS Between UNBOUNDED Preceding AND UNBOUNDED Following
SELECT P.PersonID,AttendanceMonth,AttendanceNumber,
	   FIRST_VALUE(AttendanceNumber) OVER(PARTITION BY P.PersonID,YEAR(AttendanceMonth) ORDER BY AttendanceMonth) FirstVal,
	   LAST_VALUE(AttendanceNumber) OVER(PARTITION BY P.PersonID,YEAR(AttendanceMonth)  ORDER BY AttendanceMonth
	   ROWS Between UNBOUNDED Preceding AND UNBOUNDED Following) LastVal
	   FROM Person P
JOIN Attendance A
ON P.PersonID = A.PersonID

------------- Percentile_CONT(0.?) - gives exact value of percentage
------------- Percentile_DISC(0.?) - gives the closest source value to the req percentage

SELECT DISTINCT PersonID,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY CAST(AttendanceNumber as numeric(4,2))) OVER(Partition BY PersonID) AVGCont,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY AttendanceNumber) OVER(Partition BY PersonID) AVGDisc
 FROM Attendance
