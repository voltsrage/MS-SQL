--SEQUENCE
IF EXISTS(SELECT 1 FROM sys.sequences WHERE name = 'newSeq')
	DROP SEQUENCE newSeq

GO

CREATE SEQUENCE newSeq AS BigINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999
CYCLE

GO

ALTER TABLE [dbo].[TransactionsNew]
DROP sqTransaction

ALTER TABLE [dbo].[TransactionsNew]
DROP COLUMN NxtValue

ALTER TABLE [dbo].[TransactionsNew]
ADD NxtValue int CONSTRAINT sqTransaction DEFAULT NEXT VALUE FOR newSeq
BEGIN TRAN
UPDATE TransactionsNew SET NxtValue = NEXT VALUE FOR newSeq
SELECT * FROM TransactionsNew
ROLLBACK TRAN

--To Restart Seq
--ALTER SEQUENCE newSeq
--RESTART