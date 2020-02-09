--Calculate Age from PreExisting DOB Field
MERGE Person AS T
USING
(SELECT IIF(MONTH(EntryDate) >= MONTH(GETDATE()),IIF(DAY(EntryDate) >= DAY(GETDATE()),
	DATEDIFF(YEar,EntryDate,GETDATE()),DATEDIFF(YEar,EntryDate,GETDATE())-1)
	,DATEDIFF(YEar,EntryDate,GETDATE())-1) AS Age,PersonID
	 FROm Person) AS S
ON T.PersonID = S.PersonID
WHEN MATCHED THEN UPDATE SET T.AGE = S.Age;