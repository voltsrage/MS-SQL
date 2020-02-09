--Maths Fucntions - Quadratic Formula

--Declare Variable for formula
Declare @a decimal(7,2) = 5
Declare @b decimal(7,2) = 3
Declare @c decimal(7,2) = -8

--Declare Result Variable
Declare @root1 decimal(7,2)
Declare @root2 decimal(7,2)

--Calculate First Root
SET @root1 = (SQUARE(@b) - SQRT(SQUARE(@b) - 4*@a*@c))/(2*@a)

--Calculate Second Root
SET @root2 = (SQUARE(@b) + SQRT(SQUARE(@b) - 4*@a*@c))/(2*@a)

--Output Roots
SELECT @root1 Root1,@root2 Root2