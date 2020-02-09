--Use for a brand new table
IF EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'PersonTemporal')
	BEGIN
		ALTER TABLE PersonTemporal
		SET (SYSTEM_VERSIONING = OFF)

		DROP TABLE PersonTemporal

		DROP TABLE dbo.tblPersonHistory
	END

GO

CREATE TABLE [dbo].[PersonTemporal](
	[PersonID] int NOT NULL PRIMARY KEY,
	[PersonName] nvarchar(50) NULL,
	[Age] tinyint NULL,
	[Phone] char(12) NULL,
	[Email] varchar(100) NOT NULL,
	[EntryDate] date NULL,
	[Department] int NULL,
	ValidFrom datetime2(2) GENERATED ALWAYS AS ROW START,
	ValidTo datetime2(2) GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME(ValidFrom,ValidTo))
	WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tblPersonHistory))

 GO

 --Insert Values into Table

 INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (1, N'Rosario Garrett', 18, N'450-901-2960', N'frosal@att.net', CAST(N'2001-06-02' AS Date), NULL)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (2, N'Lila Travis', 39, N'375-601-2880', N'gordonjcp@aol.com', CAST(N'1980-01-22' AS Date), 100)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (3, N'Cleo Frost', 33, N'328-454-2960', N'matsn@sbcglobal.net', CAST(N'1986-01-13' AS Date), 30)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (4, N'Rose Crawford', 53, N'492-730-1860', N'afeldspar@outlook.com', CAST(N'1966-04-23' AS Date), 30)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (5, N'Dewey Carrillo', 21, N'814-507-1021', N'gordonjcp@me.com', CAST(N'1998-08-08' AS Date), 10)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (6, N'Tabatha Liu', 30, N'353-308-7231', N'scotfl@me.com', CAST(N'1989-02-27' AS Date), 100)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (7, N'Wallace Kent', 27, N'905-557-7196', N'pthomsen@att.net', CAST(N'1992-06-25' AS Date), 30)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (8, N'Corey Burke', 47, N'348-570-3630', N'helger@aol.com', CAST(N'1972-01-19' AS Date), 60)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (9, N'Gaston Summers', 28, N'355-293-0523', N'squirrel@aol.com', CAST(N'1991-12-05' AS Date), 100)
INSERT [dbo].[PersonTemporal] ([PersonID], [PersonName], [Age], [Phone], [Email], [EntryDate], [Department]) VALUES (10, N'Ken Mcmillan', 19, N'284-312-6421', N'sinkou@gmail.com', CAST(N'2000-07-15' AS Date), 40)

----------------------------------------------------------------------------------------------------------------------

SELECT * FROM PersonTemporal

BEGIN TRAN

UPDATE PersonTemporal SET PersonName = 'Lila Gordon' WHERE PersonID = 2

SELECT * FROM PersonTemporal

UPDATE PersonTemporal SET PersonName = 'Lila Richards' WHERE PersonID = 2

SELECT * FROM PersonTemporal

ROLLBACK TRAN