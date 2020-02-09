--USE CASE Col WHEN ???
SELECT CASE PersonID WHEN 5 THEN 'Carri Burney'
					 WHEN 6 THEN 'Makeda Wilbanks'
					 WHEN 7 THEN 'Heidy Farone'
					 WHEN 8 THEN 'Karyn Janson'
					 WHEN 9 THEN 'Owen Cobos'
		END AS PersonName
		,Amount,TransactionDate FROM Transactions
WHERE PersonID BETWEEN 5 AND 9


--USE CASE When COL = ???
SELECT CASE WHEN PersonID = 5 THEN 'Carri Burney'
					 WHEN PersonID =  6 THEN 'Makeda Wilbanks'
					 WHEN PersonID =  7 THEN 'Heidy Farone'
					 WHEN PersonID =  8 THEN 'Karyn Janson'
					 WHEN PersonID =  9 THEN 'Owen Cobos'
		END AS PersonName
		,Amount,TransactionDate FROM Transactions
WHERE PersonID BETWEEN 5 AND 9


--USE CHOOSE(Col,A,B,C,D,E,F)
SELECT CHOOSE(PersonID,'','','','','Carri Burney','Makeda Wilbanks','Heidy Farone','Karyn Janson','Owen Cobos') AS PersonName
		,Amount,TransactionDate FROM Transactions
WHERE PersonID BETWEEN 5 AND 9