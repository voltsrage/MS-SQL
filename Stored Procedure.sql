USE [70-761]

IF OBJECT_ID('spGetEmployeeInfo','P') IS NOT NULL
	DROP PROC spGetEmployeeInfo
GO
CREATE PROC spGetEmployeeInfo
@PersonID int,
@NumOfRows int OUT
AS
BEGIN

SET NOCOUNT ON

IF EXISTS (SELECT 1 FROM Person WHERE PersonID = @PersonID)
	BEGIN
		--PersonIDs <= 4 Have no Transactions
		IF @PersonID <= 4
			BEGIN
				SELECT PersonID,PersonName,Email,Phone FROM Person
				WHERE PersonID = @PersonID
				RETURN 4 -- Means PersonID <= 4
			END
		ELSE
			--PersonIDs >= 5 Return about information + Transaction Info
			BEGIN
				SELECT P.PersonID,PersonName,Email,Phone,Amount,TransactionDate FROM Person P
				JOIN Transactions T
				ON P.PersonID = T.PersonID
				WHERE P.PersonID = @PersonID
				SET @NumOfRows = @@ROWCOUNT
				RETURN 5 -- Means PersonID >= 5
			END
	END
ELSE
	BEGIN
		SET @NumOfRows = 0
		Return 0
	END
END
GO


DECLARE @NumOfRows int,@ReturnStatus int
--EXEC spGetEmployeeInfo 2,@NumOfRows OUT
EXEC @ReturnStatus =  spGetEmployeeInfo 200,@NumOfRows OUT
SELECT @NumOfRows AS NumOfTransactions,@ReturnStatus ReturnStatus