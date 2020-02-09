
IF OBJECT_ID('spAverageBalance','P') IS NOT NULL
	DROP PROC  spAverageBalance
GO

CREATE PROC spAverageBalance
@PersonFrom int,
@PersonTo int,
@AvgBalance money OUT
AS
BEGIN

SET NOCOUNT ON
--IF EXISTS (SELECT 1 FROM Person WHERE PersonID IN (@PersonFrom,@PersonTo))
	BEGIN TRY
		BEGIN 
			DECLARE @TotalSum smallmoney
			DECLARE @PersonCount int

			SELECT @PersonCount = COUNT(DISTINCT P.PersonID) FROM Person P		
			WHERE P.PersonID BETWEEN @PersonFrom AND @PersonTo		

			SELECT @TotalSum = ISNULL(SUM(Amount),0) FROM Transactions
			WHERE PersonID BETWEEN @PersonFrom AND @PersonTo
			
			SET @AvgBalance = @TotalSum/@PersonCount
			
		END
	END TRY
	BEGIN CATCH
		set @AvgBalance = 0
		if ERROR_NUMBER() = 8134 -- 0 Divide Error
			BEGIN
				RETURN 8134
			END
		ELSE
			THROW 58994,'This is a medium Error',1

			--THROW Parameters (Msg Number,Severity,State,Procedure,Line,Message)
			
		---Gets the System Error Information
		--SELECT ERROR_MESSAGE() AS ErrorMsg
		--	  ,ERROR_LINE() AS ErrorLine
		--	  ,ERROR_NUMBER() AS ErrorNumber
		--	  ,ERROR_SEVERITY() AS ErrorSeverity
		--	  ,ERROR_PROCEDURE() AS ErrorProcedure
		--	  ,ERROR_STATE() AS ErrorState
	END CATCH
END

GO

DECLARE @AvgBalance money,@ReturnStatus int
EXEC @ReturnStatus = spAverageBalance 5,34,@AvgBalance OUT
SELECT @AvgBalance as AvgBalance,@ReturnStatus AS ReturnStatus
