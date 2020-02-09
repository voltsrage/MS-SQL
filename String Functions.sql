--Declare Variable
DECLARE @salary numeric(7,2) = 1356.87

--Retrieve in Different Currencies
SELECT @salary AsNumeric,FORMAT(@salary,'C') US$,FORMAT(@salary,'C','en-GB') Pounds
			,FORMAT(@salary,'C','jp-JP') Yen, FORMAT(@salary,'C','fr-FR') Euros
			,FORMAT(@salary,'C','zh-tw') Taiwan,FORMAT(@salary,'C','zh-cn') Yuan
			,FORMAT(@salary,'C','en-vc') XCD,FORMAT(@salary,'C','th-th') BAHT