--Declare Constants

DECLARE @rho DECIMAL(4,3) = 1.225
DECLARE @R DECIMAL(5,2) = 287.05


-- Declare Variables

DECLARE @T DECIMAL(5,1)
DECLARE @P DECIMAL(8,2)

SET @T = 135.23

--Calculate Pressure
SET @P = @rho*@R*@T

--Display Pressure in Different Formats using Math Functions and Casting
SELECT @P Pressure,TRY_CAST(@P AS INT) [Pressure AS INT],ROUND(@P,1) [Pressure Rounded to Decimal Point],
		CEILING(@P) [Pressure Rounded Up],Floor(@P) [Pressure Rounded Down]