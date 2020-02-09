-----------------------------------------------------------------------------------------------
--------------------------------Scalar Functions ----------------------------------------------
-----------------------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'fnShowMaxTransaction')
	DROP FUNCTION fnShowMaxTransaction

	GO

CREATE FUNCTION fnShowMaxTransaction
(
	@PersonID int
)
RETURNS smallmoney
AS
BEGIN
	
	IF EXISTS (SELECT 1 FROM Person WHERE PersonID = @PersonID)
		
			DECLARE @MaxTran smallmoney
			SELECT @MaxTran = MAX(Amount) FROM Person P
			JOIN Transactions T
			ON P.PersonID = T.PersonID
			WHERE P.PersonID = @PersonID

			Return @MaxTran

	END
GO
--Function in the Select Clause are very efficient
SELECT PersonName,dbo.fnShowMaxTransaction(PersonID) FROM Person

GO


--Return the Differenc Between the OverallMaxTransaction and Each Person's Max
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'fnShowHowFarFromMax')
	DROP FUNCTION fnShowHowFarFromMax

	GO

CREATE FUNCTION fnShowHowFarFromMax
(
	@PersonID int
)
RETURNS smallmoney
AS
BEGIN
	
	IF EXISTS (SELECT 1 FROM Person WHERE PersonID = @PersonID)
		
			DECLARE @MaxTran smallmoney
			;WITH MAxOverall AS
			(SELECT P.PersonID,MAX(Amount) OVER() AS MaxTransaction FROM Person P
			JOIN Transactions T
			ON P.PersonID = T.PersonID )
			SELECT @MaxTran  = MaxTransaction -MAX(Amount) FROM Person P
			JOIN Transactions T
			ON P.PersonID = T.PersonID
			JOIN MAxOverall M
			ON P.PersonID = M.PersonID
			WHERE P.PersonID = @PersonID
			GROUP BY MaxTransaction

			Return @MaxTran

	END
GO

SELECT PersonName,dbo.fnShowHowFarFromMax(PersonID) FROM Person
GO
-----------------------------------------------------------------------------------------------
--------------------------------Inline Table Functions ----------------------------------------
-----------------------------------------------------------------------------------------------
--Return Transaction History For Each Employee
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'fnPersonTransactions')
	DROP FUNCTION fnPersonTransactions

	GO
CREATE FUNCTION dbo.fnPersonTransactions
(@PersonID int)
RETURNS TABLE AS RETURN
(
	SELECT P.PersonID,PersonName,Email,Amount,TransactionDate FROM Person P
	JOIN Transactions T
	ON P.PersonID = @PersonID
)
GO

SELECT * FROM dbo.fnPersonTransactions(20)
WHERE Amount > 500 and Amount < 600 AND TransactionDate BETWEEN '20120101' AND '20150101'	
ORDER BY TransactionDate

GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'fnWhoHasHigherTransactionsThanMe')
	DROP FUNCTION fnWhoHasHigherTransactionsThanMe

	GO
CREATE FUNCTION dbo.fnWhoHasHigherTransactionsThanMe
(@PersonID int)
RETURNS TABLE AS RETURN
(
	SELECT P.PersonID,PersonName,Email,Amount,TransactionDate FROM Person P
	JOIN Transactions T 
	ON P.PersonID = T.PersonID
	WHERE Amount > (SELECT MAX(Amount) FROM Person P1 join Transactions T1 ON P1.PersonID = T1.PersonID
					WHERE P1.PersonID = @PersonID)
	
)
GO

SELECT * FROM dbo.fnWhoHasHigherTransactionsThanMe(150)

GO

-----------------------------------------------------------------------------------------------
--------------------------------MultiStatement Table Functions --------------------------------
-----------------------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME = 'fnGetPersonTransactions')
	DROP FUNCTION fnGetPersonTransactions

GO

CREATE FUNCTION fnGetPersonTransactions(@PersonID int)
RETURNS @Tranlist TABLE
(	
	PersonID int,
	PersonName nvarchar(50),
	Email varchar(100),
	Amount smallmoney,
	TransactionDate date
)
AS
BEGIN

	IF @PersonID IN (5,15,25,45,55,75,85,95,115,125)
		BEGIN
			INSERT INTO @TranList(PersonID,[PersonName],[Email])
			SELECT PersonID,[PersonName],[Email] FROM Person
			WHERE PersonID = @PersonID
		END
	ELSE
		BEGIN
			INSERT INTO @TranList(PersonID,[PersonName],[Email],Amount,TransactionDate)
			SELECT P.PersonID,[PersonName],[Email],Amount,TransactionDate FROM Person P
			JOIN Transactions T
			ON P.PersonID = T.PersonID
			WHERE P.PersonID = @PersonID
		END

	RETURN

END

GO

SELECT * FROM dbo.fnGetPersonTransactions(5)


--outer apply = left join
--cross apply = inner join
