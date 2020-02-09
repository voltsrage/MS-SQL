USE [70-761]

--Use INSERT SNIPPET To shortcut creating code
GO
IF EXISTS(SELECT 1 FROM sys.triggers WHERE NAME = 'tr_TransactionsReport')
	DROP TRIGGER tr_TransactionsReport
GO
--Create View Transaction Report Trigger
CREATE TRIGGER tr_TransactionsReport
ON Transactions
AFTER DELETE,INSERT,UPDATE
AS
BEGIN

	SELECT *,'Inserts' AS Operation FROM inserted
	SELECT *,'Deletes' AS Operation FROM deleted

END
GO

BEGIN TRAN
	--Insert a new record
	INSERT INTO Transactions(Amount,TransactionDate,PersonID)
	VALUES (749.23,'2015-12-28',21)
	--Update the newly added record
	UPDATE Transactions SET Amount = 816.53 WHERE TransactionDate = '2015-12-28' AND PersonID =  21

ROLLBACK TRAN

-----------------------------------------------------------------------------------
GO
IF EXISTS(SELECT 1 FROM sys.triggers WHERE NAME = 'tr_DeleteFromvWTransactions')
	DROP TRIGGER tr_DeleteFromvWTransactions
GO
--------- Delete From View Using Trigger
CREATE TRIGGER tr_DeleteFromvWTransactions
ON vWTransactions
INSTEAD OF DELETE
AS
BEGIN
	--Instead of deleting from the View we Delete directly from the underlying table
	--DELETE FROM Person WHERE PersonID IN (SELECT deleted.PersonID FROM deleted)

	---------------------Only deletes one record because variables can only store
	---------------------one record at a time. For multiple, it stores the last record in the set
	--DECLARE @Amount smallmoney
	--DECLARE @TransactionDate date
	--DECLARE @PersonID int

	--SELECT @Amount = deleted.Amount,@TransactionDate = deleted.TransactionDate
	--		,@PersonID = deleted.PersonID  FROM deleted


	--DELETE FROM Transactions WHERE Amount = @Amount AND TransactionDate = @TransactionDate
	--							   AND PersonID = @PersonID


	--This deletes all records in the set.
	DELETE Transactions FROM
	Transactions T
	JOIN deleted D
	ON T.PersonID = D.PersonID
	AND T.Amount = D.Amount
	AND T.TransactionDate = D.TransactionDate	
END

GO
BEGIN TRAN

	--SELECT * FROM vWTransactions
	--ORDER BY PersonID

	DELETE FROM vWTransactions WHERE PersonID = 6
	SELECT * FROM vWTransactions WHERE PersonID = 6
	

ROLLBACK TRAN