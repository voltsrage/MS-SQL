USE[70-761]

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SFTPXmlTable')
BEGIN
	--ALTER TABLE SFTPXmlTable
	--DROP CONSTRAINT secpk_SFTPXmlTable_Path
	--ALTER TABLE SFTPXmlTable
	--DROP CONSTRAINT secpk_SFTPXmlTable_Value
	--ALTER TABLE SFTPXmlTable
	--DROP CONSTRAINT secpk_SFTPXmlTable_Property
	--ALTER TABLE SFTPXmlTable
	--DROP CONSTRAINT pkSFTPXmlTable
	DROP TABLE SFTPXmlTable	
END

IF EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'SFTPTable')
 DROP TABLE SFTPTable

GO

CREATE TABLE SFTPXmlTable(id_col INT IDENTITY PRIMARY KEY,XmlCol xml)

CREATE PRIMARY XML INDEX pkSFTPXmlTable on SFTPXmlTable(XmlCol)
--CREATE XML INDEX secpk_SFTPXmlTable_PATH on SFTPXmlTable(XmlCol)
--	using XML INDEX pkSFTPXmlTable FOR PATH -- improve query speed
CREATE XML INDEX secpk_SFTPXmlTable_VALUE on SFTPXmlTable(XmlCol)
	using XML INDEX pkSFTPXmlTable FOR VALUE -- used when wildcards are used
--CREATE XML INDEX secpk_SFTPXmlTable_PROPERTY on SFTPXmlTable(XmlCol)
--	using XML INDEX pkSFTPXmlTable FOR PROPERTY --used for when multiple values are retrieved

INSERT INTO SFTPXmlTable(XmlCol)

SELECT * FROM 
openrowset(BULK 'C:\FTP\Arc_2020_01_25_17_01\aworkdo.xml' ,single_blob) AS X

SELECT Products.Product.value('@ID','varchar(MAX)') AS ID,
	   Products.Product.value('@UserTypeID','varchar(MAX)') AS UserTypeID,
	   Products.Product.value('@ParentID','varchar(MAX)') AS ParentID,
	   Products.Product.value('(Name)[1]','varchar(MAX)') AS [ProductName],
	   Products.Product.value('(ProductCrossReference/@ProductID)[1]','varchar(MAX)') AS ProductID,
	   Products.Product.value('(ProductCrossReference/@Type)[1]','varchar(MAX)') AS [ProductType],
	   Products.Product.value('(ProductCrossReference/MetaData/Value/@AttributeID)[1]','varchar(MAX)') AS [AttributeMetaID],
	   Products.Product.value('(ProductCrossReference/MetaData/Value/text())[1]','varchar(MAX)') AS [AttributeMetaValue],	

	   Products.Product.value('(AssetCrossReference/@AssetID)[1]','varchar(MAX)') AS AssetID,
	   Products.Product.value('(AssetCrossReference/@Type)[1]','varchar(MAX)') AS [AssetType],
	   Products.Product.value('(AssetCrossReference/MetaData/Value/@AttributeID)[1]','varchar(MAX)') AS [AssetMetaID],
	   Products.Product.value('(AssetCrossReference/MetaData/Value/text())[1]','varchar(MAX)') AS [AssetMetaValue],
	   Products.Product.query('(Values)') AS [ProductValues]
	   INTO SFTPTable
FROM SFTPXmlTable
CROSS APPLY
XmlCol.nodes('/STEP-ProductInformation/Assets/Products/Product') AS Products(Product)

IF EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'SFTPFullTable')
 DROP TABLE SFTPFullTable

SELECT [ID],[UserTypeID],[ParentID],[ProductID],[ProductName],[ProductType],
		Products.Product.value('(@AttributeID)','varchar(MAX)') AttributeID,
		Products.Product.value('(text())[1]','varchar(MAX)') AttributeValue,
		Products.Product.value('(@ContextID)','varchar(MAX)') ContextID,
		Products.Product.value('(@ID)','varchar(MAX)') ValueID,
		Products.Product.value('(@Inherited)','varchar(MAX)') Inherited,
		Products.Product.value('(@LOVQualifierID)','varchar(MAX)') LOVQualifierID
		INTO SFTPFullTable
		 FROM SFTPTable
CROSS APPLY
ProductValues.nodes('/Values/Value') AS Products(Product)

-----------------------------------------------------------------------------------------------------------------
-------------------------------------Pivots----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

USE[70-761]

SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) Keys,ID,[ProductName], AttributeID, AttributeValue INTO #Temp
 FROM SFTPFullTable
 where AttributeID like '%cont%'
 order by keys
 
GO
--SELECT * FROM  #Temp
DECLARE @cols AS NVARCHAR(MAX);
DECLARE @query AS NVARCHAR(MAX);

select @cols = STUFF((SELECT distinct ','+
                        QUOTENAME(AttributeID) 
                      FROM [dbo].[#Temp]
                      FOR XML PATH(''), TYPE
                     ).value('.', 'NVARCHAR(MAX)') 
                        , 1, 1, '');				
					

SELECT @query = 'SELECT *  INTO TEMP2               
                 FROM (  SELECT TOP 100 PERCENT AttributeID,AttributeValue,DENSE_RANK() OVER(ORDER BY ID) AS ID FROM [#Temp] as TEM
				 ORDER BY keys) AS t
                 PIVOT 
                 (
                   MAX(AttributeValue)
                   FOR AttributeID in ( ' + @cols + ' )
                 ) AS p';

execute(@query);

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TempPivot')
 DROP TABLE TempPivot

SELECT T1.ID As ProductID,ProductName,T2.* INTO TempPivot FROM Temp2 T2
JOIN ( SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) RowNo,* FROM
 (SELECT DISTINCT ID,[ProductName] FROM #Temp) AS T) T1
 ON T2.ID = T1.RowNo

 SELECT * FROM TempPivot

DROP TABLE #Temp
DROP TABLE Temp2


