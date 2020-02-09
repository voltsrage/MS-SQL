--DECLARE @x xml = '<root>
--  <public fox="pole">generally</public>
--  <drop desert="another">hardly</drop>
--  <proud>-1886892596.6796713</proud>
--  <twenty charge="bridge">
--    <clay favorite="fell">-470024530</clay>
--    <weather game="buried">provide</weather>
--    <phrase>1090821876.310923</phrase>
--    <someone>
--      <coach>certain</coach>
--      <extra>-2100997395.0449662</extra>
--      <dead>swept</dead>
--      <tip oil="double">-1453752412.2789145</tip>
--      <carbon>something</carbon>
--      <anyone>567823426.8968673</anyone>
--    </someone>
--    <replied>-1264934212.9582324</replied>
--    <congress better="know">49934921.63117123</congress>
--  </twenty>
--  <shinning>348805037</shinning>
--  <fireplace>newspaper</fireplace>
--</root>'

----Extract Fireplace
--SELECT @x.value('(/root/fireplace)[1]','varchar(50)') AS Fireplace

----Extract Tip
--SELECT @x.value('(/root/twenty/someone/tip)[1]','varchar(50)') AS Tip

----Congress
--SELECT @x.value('(/root/twenty/congress)[1]','varchar(50)') AS Congress

----Get Attribute desert from Drop
--SELECT @x.value('(/root/drop/@desert)[1]','varchar(50)') AS Desert

----Get Attribute game From Weather
--SELECT @x.value('(/root/twenty/weather/@game)[1]','varchar(50)') AS game

-----------------------------------------------------------------------------------------

--DECLARE @x2 xml = '<?xml version="1.0" encoding="UTF-8"?>  
--<emails>  
--<email>  
--  <to>Vimal</to>  
--  <from>Sonoo</from>  
--  <heading>Hello</heading>  
--  <body>Hello brother, how are you!</body>  
--</email>  
--<email>  
--  <to>Peter</to>  
--  <from>Jack</from>  
--  <heading>Birth day wish</heading>  
--  <body>Happy birth day Tom!</body>  
--</email>  
--<email>  
--  <to>James</to>  
--  <from>Jaclin</from>  
--  <heading>Morning walk</heading>  
--  <body>Please start morning walk to stay fit!</body>  
--</email>  
--<email>  
--  <to>Kartik</to>  
--  <from>Kumar</from>  
--  <heading>Health Tips</heading>  
--  <body>Smoking is injurious to health!</body>  
--</email>  
--</emails>'

------Get Sender From 4th Email
----SELECT @x2.value('(/emails/email[4]/from)[1]','varchar(50)') Sender

------Get Message From 2nd Email
----SELECT @x2.value('(/emails/email[2]/body)[1]','varchar(50)') Sender


------------------------------------------------------------------------------------------
--------------------------------Modify----------------------------------------------------
------------------------------------------------------------------------------------------

----Change the heading of the 3rd Email (if you want a node and not a attribute)
----use /text() as the last piece of the source
--SET @x2.modify('replace value of (/emails/email[2]/heading/text())[1] with "Birtday Wish"')

----Change the receiver of the 1st Email
--SET @x2.modify('replace value of (/emails/email[1]/to/text())[1] with "Hakeem"')

----Insert New Email
----Don't forget the {#} outside the soft brackets
--SET @x2.modify('insert <email>
--    <to>Julie</to>
--    <from>Roger</from>
--    <heading>Tomorrow''s Party</heading>
--    <body>The time is now 8:30pm not 7!</body>
--  </email> into (/emails)[1]')

--SET @x2.modify('insert <email>
--    <to>Meleano</to>
--    <from>Sam</from>
--    <heading>The song</heading>
--    <body>The title should Who am I</body>
--  </email> into (/emails)[1]')

--  SELECT @x2

------------------------------------------------------------------------------------------
--------------------------------FLWOR ----------------------------------------------------
----------------------FOR LET WHERE ORDER BY RETURN---------------------------------------
------------------------------------------------------------------------------------------

DECLARE @x3 xml = '<breakfast_menu>
<food>
<name>Belgian Waffles</name>
<price>$5.95</price>
<description>
Two of our famous Belgian Waffles with plenty of real maple syrup
</description>
<calories>650</calories>
</food>
<food>
<name>Strawberry Belgian Waffles</name>
<price>$7.95</price>
<description>
Light Belgian waffles covered with strawberries and whipped cream
</description>
<calories>900</calories>
</food>
<food>
<name>Berry-Berry Belgian Waffles</name>
<price>$8.95</price>
<description>
Light Belgian waffles covered with an assortment of fresh berries and whipped cream
</description>
<calories>900</calories>
</food>
<food>
<name>French Toast</name>
<price>$4.50</price>
<description>
Thick slices made from our homemade sourdough bread
</description>
<calories>600</calories>
</food>
<food>
<name>Homestyle Breakfast</name>
<price>$6.95</price>
<description>
Two eggs, bacon or sausage, toast, and our ever-popular hash browns
</description>
<calories>950</calories>
</food>
</breakfast_menu>'

----Get all the food names
--SELECT @x3.query('for $BreakFastName in /breakfast_menu/food/name
--					return $BreakFastName')
---- This comes out in xml nodes
---- To get string values, use string(variable name)
--SELECT @x3.query('for $BreakFastName in /breakfast_menu/food/name
--					return string($BreakFastName)')
----To add a separator and make it more presentable we use
--SELECT @x3.query('for $BreakFastName in /breakfast_menu/food/name
--					return concat(string($BreakFastName)," |")')

----Get all prices
--SELECT @x3.query('for $BreakFastPrice in /breakfast_menu/food/price
--					return concat(string($BreakFastPrice)," |")')

----Order Breakfast list by price
--SELECT @x3.query('for $BreakFastPrice in /breakfast_menu/food/price
--					order by $BreakFastPrice
--					return concat(string($BreakFastPrice)," |")')

------------------------------------------------------------------------------------------
--------------------------------Nodes ----------------------------------------------------
------------------------------------------------------------------------------------------

Select BreakFast.Food.query('.')
FROM @x3.nodes('/breakfast_menu/food') as BreakFast(Food)

--Complete shred of XML File above
Select BreakFast.Food.value('(name)[1]','varchar(50)') Name,
		BreakFast.Food.value('(price)[1]','varchar(50)') Price,
		BreakFast.Food.value('(description)[1]','varchar(50)') Description,
		BreakFast.Food.value('(calories)[1]','varchar(50)') Calories
FROM @x3.nodes('/breakfast_menu/*') as BreakFast(Food)

DECLARE @x4 xml ='<CATALOG>
<CD>
<TITLE>Empire Burlesque</TITLE>
<ARTIST>Bob Dylan</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>Columbia</COMPANY>
<PRICE>10.90</PRICE>
<YEAR>1985</YEAR>
</CD>
<CD>
<TITLE>Hide your heart</TITLE>
<ARTIST>Bonnie Tyler</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>CBS Records</COMPANY>
<PRICE>9.90</PRICE>
<YEAR>1988</YEAR>
</CD>
<CD>
<TITLE>Greatest Hits</TITLE>
<ARTIST>Dolly Parton</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>RCA</COMPANY>
<PRICE>9.90</PRICE>
<YEAR>1982</YEAR>
</CD>
<CD>
<TITLE>Still got the blues</TITLE>
<ARTIST>Gary Moore</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Virgin records</COMPANY>
<PRICE>10.20</PRICE>
<YEAR>1990</YEAR>
</CD>
<CD>
<TITLE>Eros</TITLE>
<ARTIST>Eros Ramazzotti</ARTIST>
<COUNTRY>EU</COUNTRY>
<COMPANY>BMG</COMPANY>
<PRICE>9.90</PRICE>
<YEAR>1997</YEAR>
</CD>
<CD>
<TITLE>One night only</TITLE>
<ARTIST>Bee Gees</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Polydor</COMPANY>
<PRICE>10.90</PRICE>
<YEAR>1998</YEAR>
</CD>
<CD>
<TITLE>Sylvias Mother</TITLE>
<ARTIST>Dr.Hook</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>CBS</COMPANY>
<PRICE>8.10</PRICE>
<YEAR>1973</YEAR>
</CD>
<CD>
<TITLE>Maggie May</TITLE>
<ARTIST>Rod Stewart</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Pickwick</COMPANY>
<PRICE>8.50</PRICE>
<YEAR>1990</YEAR>
</CD>
<CD>
<TITLE>Romanza</TITLE>
<ARTIST>Andrea Bocelli</ARTIST>
<COUNTRY>EU</COUNTRY>
<COMPANY>Polydor</COMPANY>
<PRICE>10.80</PRICE>
<YEAR>1996</YEAR>
</CD>
<CD>
<TITLE>When a man loves a woman</TITLE>
<ARTIST>Percy Sledge</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>Atlantic</COMPANY>
<PRICE>8.70</PRICE>
<YEAR>1987</YEAR>
</CD>
<CD>
<TITLE>Black angel</TITLE>
<ARTIST>Savage Rose</ARTIST>
<COUNTRY>EU</COUNTRY>
<COMPANY>Mega</COMPANY>
<PRICE>10.90</PRICE>
<YEAR>1995</YEAR>
</CD>
<CD>
<TITLE>1999 Grammy Nominees</TITLE>
<ARTIST>Many</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>Grammy</COMPANY>
<PRICE>10.20</PRICE>
<YEAR>1999</YEAR>
</CD>
<CD>
<TITLE>For the good times</TITLE>
<ARTIST>Kenny Rogers</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Mucik Master</COMPANY>
<PRICE>8.70</PRICE>
<YEAR>1995</YEAR>
</CD>
<CD>
<TITLE>Big Willie style</TITLE>
<ARTIST>Will Smith</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>Columbia</COMPANY>
<PRICE>9.90</PRICE>
<YEAR>1997</YEAR>
</CD>
<CD>
<TITLE>Tupelo Honey</TITLE>
<ARTIST>Van Morrison</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Polydor</COMPANY>
<PRICE>8.20</PRICE>
<YEAR>1971</YEAR>
</CD>
<CD>
<TITLE>Soulsville</TITLE>
<ARTIST>Jorn Hoel</ARTIST>
<COUNTRY>Norway</COUNTRY>
<COMPANY>WEA</COMPANY>
<PRICE>7.90</PRICE>
<YEAR>1996</YEAR>
</CD>
<CD>
<TITLE>The very best of</TITLE>
<ARTIST>Cat Stevens</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Island</COMPANY>
<PRICE>8.90</PRICE>
<YEAR>1990</YEAR>
</CD>
<CD>
<TITLE>Stop</TITLE>
<ARTIST>Sam Brown</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>A and M</COMPANY>
<PRICE>8.90</PRICE>
<YEAR>1988</YEAR>
</CD>
<CD>
<TITLE>Bridge of Spies</TITLE>
<ARTIST>T''Pau</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Siren</COMPANY>
<PRICE>7.90</PRICE>
<YEAR>1987</YEAR>
</CD>
<CD>
<TITLE>Private Dancer</TITLE>
<ARTIST>Tina Turner</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>Capitol</COMPANY>
<PRICE>8.90</PRICE>
<YEAR>1983</YEAR>
</CD>
<CD>
<TITLE>Midt om natten</TITLE>
<ARTIST>Kim Larsen</ARTIST>
<COUNTRY>EU</COUNTRY>
<COMPANY>Medley</COMPANY>
<PRICE>7.80</PRICE>
<YEAR>1983</YEAR>
</CD>
<CD>
<TITLE>Pavarotti Gala Concert</TITLE>
<ARTIST>Luciano Pavarotti</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>DECCA</COMPANY>
<PRICE>9.90</PRICE>
<YEAR>1991</YEAR>
</CD>
<CD>
<TITLE>The dock of the bay</TITLE>
<ARTIST>Otis Redding</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>Stax Records</COMPANY>
<PRICE>7.90</PRICE>
<YEAR>1968</YEAR>
</CD>
<CD>
<TITLE>Picture book</TITLE>
<ARTIST>Simply Red</ARTIST>
<COUNTRY>EU</COUNTRY>
<COMPANY>Elektra</COMPANY>
<PRICE>7.20</PRICE>
<YEAR>1985</YEAR>
</CD>
<CD>
<TITLE>Red</TITLE>
<ARTIST>The Communards</ARTIST>
<COUNTRY>UK</COUNTRY>
<COMPANY>London</COMPANY>
<PRICE>7.80</PRICE>
<YEAR>1987</YEAR>
</CD>
<CD>
<TITLE>Unchain my heart</TITLE>
<ARTIST>Joe Cocker</ARTIST>
<COUNTRY>USA</COUNTRY>
<COMPANY>EMI</COMPANY>
<PRICE>8.20</PRICE>
<YEAR>1987</YEAR>
</CD>
</CATALOG>'

--Shred Catalog
SELECT Catalogs.cd.value('(TITLE)[1]','varchar(50)') AS Title,
	   Catalogs.cd.value('(ARTIST)[1]','varchar(50)') AS Artist,
	   Catalogs.cd.value('(COUNTRY)[1]','varchar(50)') AS Country,
	   Catalogs.cd.value('(COMPANY)[1]','varchar(50)') AS Company,
	   Catalogs.cd.value('(PRICE)[1]','varchar(50)') AS Price,
	   Catalogs.cd.value('(YEAR)[1]','varchar(50)') AS [Year]
FROM @x4.nodes('/CATALOG/*') AS Catalogs(cd)

