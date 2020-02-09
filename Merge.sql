--Merge with Comments For Status
BEGIN TRAN

DELETE FROM TransactionsNew WHERE PersonID is Null
GO
ALTER TABLE Transactions
ADD Comments VARCHAR(50)
GO
MERGE INTO Transactions T
USING (SELECT PersonID,[TransactionDate],SUM(Amount)AS Amount FROM TransactionsNew
		GROUP BY PersonID,[TransactionDate]) S
ON T.PersonID = S.PersonID AND T.[TransactionDate] = S.[TransactionDate]
WHEN MATCHED THEN UPDATE SET Amount = S.Amount + T.AMOUNT,Comments = 'Matched - Updated'
WHEN NOT MATCHED THEN INSERT (Amount,[TransactionDate],[PersonID],Comments)
		VALUES (S.Amount,S.[TransactionDate],S.PersonID,'Not Matched By Target - Inserted')
WHEN NOT MATCHED BY SOURCE THEN UPDATE
		SET Comments = 'Not Matched by Source';

SELECT * FROM Transactions

ROLLBACK TRAN

