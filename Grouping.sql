---Returns the Total Attendance For Each Attendance Month
SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY DeptName,P.PersonID, AttendanceMonth
ORDER BY DeptName,P.PersonID, AttendanceMonth

--What if Other Column Totals are Required
--Rollup gives the Totals in Hierarchal Fashion, Total for Everyone
											   --Total for Each Department
											   --Total for EacH Person in the Department
											   --Total for every month

SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) TotalAttendance FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY ROLLUP(DeptName,P.PersonID, AttendanceMonth)
ORDER BY DeptName,P.PersonID, AttendanceMonth

--To see what is being grouped use GROUPING_ID, 0 means Grouped on, 2^m (1,2,4,8) means Column is NUll
--being grouped on it's Parent instead.

SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) TotalAttendance,
GROUPING_ID(DeptName,P.PersonID, AttendanceMonth) GroupingID
FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY ROLLUP(DeptName,P.PersonID, AttendanceMonth)
ORDER BY DeptName,P.PersonID, AttendanceMonth

--To see all the possible permutations USE Group by  CUBE

SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) TotalAttendance,
GROUPING_ID(DeptName,P.PersonID, AttendanceMonth) GroupingID
FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY CUBE(DeptName,P.PersonID, AttendanceMonth)
ORDER BY DeptName,P.PersonID, AttendanceMonth

-- Using Grouping Sets - IF SETS(A,B,C) - It will return list A only
-- B only and C only Grouped Results
SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) TotalAttendance,
GROUPING_ID(DeptName,P.PersonID, AttendanceMonth) GroupingID
FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY GROUPING SETS(DeptName,P.PersonID, AttendanceMonth)
ORDER BY DeptName,P.PersonID, AttendanceMonth

-- Using Grouping Sets - IF SETS((A,B,C),(D)) This Groups every in the first group
--by the second with a GROUP For D only a header

SELECT DeptName,P.PersonID, AttendanceMonth,SUM(AttendanceNumber) TotalAttendance,
GROUPING_ID(DeptName,P.PersonID, AttendanceMonth) GroupingID
FROM Departments D
JOIN Person P
ON D.DeptID = P.Department
JOIN Attendance A
ON P.PersonID = A.PersonID
GROUP BY GROUPING SETS((DeptName,P.PersonID, AttendanceMonth),(DeptName),())
ORDER BY DeptName,P.PersonID, AttendanceMonth