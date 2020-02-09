--Create Parametized Dynamic Query to Search from Person Transactions
DECLARE @command as nvarchar(500),@params as nvarchar(50)
SET @command = N'SELECT P.PersonID,PersonName,Amount FROM Person P 
JOIN Transactions T
ON P.PersonID = T.PersonID
WHERE P.PersonID = @Someone'
SET @params = N'123'
EXECUTE sys.sp_executesql @statement = @command, @params = N'@Someone int',@Someone = @params


