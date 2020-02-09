---Person Table can be now called as Employees
CREATE SYNONYM Employees
FOR Person

SELECT * FROM Employees


--You can also Create Tables ahead of time, but will not be able to use till underlying
--table is created

