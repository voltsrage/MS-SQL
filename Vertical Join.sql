--CREATE Second Table to USE 

IF EXISTS (SELECT 1 FROM sys.tables WHERE NAME = 'TransactionsNew')
	DROP TABLE TransactionsNew

--SELECT NULL Allows us to add RowNumbers with using a specific column
GO

SELECT *,ROW_NUMBER() OVER (ORDER BY (SELECT null)) % 3 RowNumber INTO TransactionsNew  FROM Transactions

UPDATE TransactionsNew SET TransactionDate = DATEADD(DAY,2,TransactionDate),Amount = Amount*1.1
WHERE RowNumber = 2

DELETE FROM TransactionsNew WHERE RowNumber = 1

ALTER TABLE TransactionsNew
DROP COLUMN RowNumber
GO

--------------------------------UNION VS UNION ALL ----------------------------

SELECT * FROM Transactions ---2002 Rows
UNION ALL -- Returns 3336 = 2002+1334 -- Does not eliminate Duplicates
SELECT * FROM TransactionsNew --1334 Rows


SELECT * FROM Transactions ---2002 Rows
UNION  -- Returns 2669 Rows = 2002+1334 - Duplicates -- Combines but eliminates Duplicates
SELECT * FROM TransactionsNew --1334 Rows

SELECT * FROM Transactions ---2002 Rows
INTERSECT -- Returns 667 Rows -- Only Returns the Matching Rows
SELECT * FROM TransactionsNew --1334 Rows

SELECT * FROM Transactions ---2002 Rows
EXCEPT --Returns 1335 Rows = 2002 - 667 Removes Matching Rows From First Table
SELECT * FROM TransactionsNew --1334 Rows

SELECT * FROM TransactionsNew ---1334 Rows
EXCEPT --Returns 667 Rows = 1334 - 667 Removes Matching Rows From First Table
SELECT * FROM Transactions --2002 Rows