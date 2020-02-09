--Declare Date

DECLARE @thedate DATETIME = '2020-06-19 08:36:45.456'

--Retrieving the date in a String
SELECT 'The date is ' + CONVERT(nvarchar(25),@thedate) TheDate

--Date Convert Formats
SELECT CONVERT(nvarchar(25),@thedate,101) [101] -- Slashes and m/d/y
	,CONVERT(nvarchar(25),@thedate,102) [102] -- Dots y.m.d
	,CONVERT(nvarchar(25),@thedate,103) [103] -- Slashes d/m/y
	,CONVERT(nvarchar(25),@thedate,104) [104] -- Dots d.m.y
	,CONVERT(nvarchar(25),@thedate,105) [105] -- Dashes d-m-y
	,CONVERT(nvarchar(25),@thedate,106) [106] -- MonthName d m y
	,CONVERT(nvarchar(25),@thedate,107) [107] -- MonthName m d, y

--To make sense of Worded Dates
--Has to be an actual date or their will be an error
BEGIN TRY
	SELECT PARSE('Saturday, 19 January 2020' as date) ParseDate -- Wont't work
															--because no such date exists
--Specify Culture
END TRY
BEGIN CATCH
	SELECT 'No such date exists'
	SELECT PARSE('Sunday, 19 January 2020' as date using 'en-vc') EnglishDate
	SELECT PARSE(N'2020?1?19?' as date using 'zh-TW' ) ChineseDate
END CATCH

--To Convert Date to String - USE Format

 SELECT FORMAT(Cast('2020-06-19 08:36:45.456' as datetime),'D') EnglishDate
	   ,FORMAT(Cast('2020-06-19 08:36:45.456' as datetime),'D','es-ES') SpanishDate
	   ,FORMAT(Cast('2020-06-19 08:36:45.456' as datetime),'D','fr-FR') FrenchDate
	   ,FORMAT(Cast('2020-06-19 08:36:45.456' as datetime),'D','zh-TW') ChineseDate
	   ,FORMAT(Cast('2020-06-19 08:36:45.456' as datetime),'D','de-DE') GermanDate