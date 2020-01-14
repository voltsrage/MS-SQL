DECLARE @employees nvarchar(MAX) = '{
    "Employees": [
        {
            "EmployeeNumber": 1,
            "EmployeeFirstName": "Dylan",
            "EmployeeLastName": "Word",
            "Departments": [
                {
                    "Department": "Customer Relations",
                    "DepartmentHead": "Andrew",
                    "Transactions": [
                        {
                            "Amount": 239.7800,
                            "DateOfTransaction": "2015-09-28T00:00:00"
                        },
                        {
                            "Amount": -399.6800,
                            "DateOfTransaction": "2014-04-10T00:00:00"
                        }
                    ]
                }
            ]
        },
        {
            "EmployeeNumber": 2,
            "EmployeeFirstName": "Jossef",
            "EmployeeLastName": "Wright",
            "Departments": [
                {
                    "Department": "Litigation",
                    "DepartmentHead": "Andrew",
                    "Transactions": [
                        {
                            "Amount": -600.0400,
                            "DateOfTransaction": "2014-08-17T00:00:00"
                        },
                        {
                            "Amount": -851.1400,
                            "DateOfTransaction": "2015-05-20T00:00:00"
                        },
                        {
                            "Amount": -414.5500,
                            "DateOfTransaction": "2015-03-12T00:00:00"
                        },
                        {
                            "Amount": 639.2200,
                            "DateOfTransaction": "2015-04-06T00:00:00"
                        }
                    ]
                }
            ]
        },
        {
            "EmployeeNumber": 123,
            "EmployeeFirstName": "Jane",
            "EmployeeLastName": "Zwilling",
            "Departments": [
                {
                    "Department": "Customer Relations",
                    "DepartmentHead": "Andrew",
                    "Transactions": [
                        {
                            "Amount": -179.4700,
                            "DateOfTransaction": "2015-03-18T00:00:00"
                        },
                        {
                            "Amount": 786.2200,
                            "DateOfTransaction": "2014-11-14T00:00:00"
                        },
                        {
                            "Amount": -967.3600,
                            "DateOfTransaction": "2015-10-25T00:00:00"
                        },
                        {
                            "Amount": 957.0300,
                            "DateOfTransaction": "2014-05-23T00:00:00"
                        }
                    ]
                }
            ]
        },
        {
            "EmployeeNumber": 124,
            "EmployeeFirstName": "Carolyn",
            "EmployeeLastName": "Zimmerman",
            "Departments": [
                {
                    "Department": "Commercial",
                    "DepartmentHead": "Brayan",
                    "Transactions": [
                        {
                            "Amount": -576.7700,
                            "DateOfTransaction": "2015-11-15T00:00:00"
                        }
                    ]
                }
            ]
        },
        {
            "EmployeeNumber": 125,
            "EmployeeFirstName": "Jane",
            "EmployeeLastName": "Zabokritski",
            "Departments": [
                {
                    "Department": "Commercial",
                    "DepartmentHead": "Brayan",
                    "Transactions": [
                        {
                            "Amount": -693.2600,
                            "DateOfTransaction": "2014-11-24T00:00:00"
                        }
                    ]
                }
            ]
        },
        {
            "EmployeeNumber": 126,
            "EmployeeFirstName": "Ken",
            "EmployeeLastName": "Yukish",
            "Departments": [
                {
                    "Department": "HR",
                    "DepartmentHead": "Catherine",
                    "Transactions": [
                        {
                            "Amount": 228.5100,
                            "DateOfTransaction": "2015-12-31T00:00:00"
                        },
                        {
                            "Amount": 390.5200,
                            "DateOfTransaction": "2014-12-02T00:00:00"
                        },
                        {
                            "Amount": -500.7300,
                            "DateOfTransaction": "2015-09-18T00:00:00"
                        }
                    ]
                }
            ]
        }]}
		'

SELECT * FROM OPENJSON(@employees,'$.Employees')
WITH(EmployeeNumber int ,EmployeeFirstName varchar(50),EmployeeLastName varchar(50))


SELECT Department,DepartmentHead FROM OPENJSON(@employees,'$.Employees')
WITH (Departments nvarchar(max) '$.Departments' AS JSON)
OUTER APPLY OPENJSON(Departments)
 WITH(Department varchar(20),DepartmentHead varchar(20) )

 SELECT EmployeeNumber,Amount,DateOfTransaction FROM OPENJSON(@employees,'$.Employees')
WITH (EmployeeNumber int,Departments nvarchar(max) '$.Departments' AS JSON)
OUTER APPLY OPENJSON(Departments)
 WITH(Transactions nvarchar(max) AS JSON)
 OUTER APPLY OPENJSON(Transactions)
  WITH(Amount smallmoney,DateOfTransaction smalldatetime)