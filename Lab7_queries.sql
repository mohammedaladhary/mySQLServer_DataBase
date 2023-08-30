--Notes:
--• Restore ITI and adventureworks2012 DBs to Server

--Part-1: Use ITI DB
use iti

--1. Retrieve number of students who have a value in their age.
SELECT COUNT(*) AS student_count
FROM Student
WHERE St_Age IS NOT NULL

--2. Get all instructors Names without repetition
SELECT DISTINCT Ins_Name
FROM Instructor

--3. Display student with the following Format (use isNull function)
--        Student ID
--        Student Full Name
--        Department name
SELECT
    Student.St_Id,
    ISNULL(Student.St_Fname+' '+St_Lname, 'N/A') AS Student_Full_Name,
    ISNULL(Department.Dept_Name, 'N/A') AS Department_Name
FROM
    Student
LEFT JOIN
    Department ON Student.Dept_Id = Department.Dept_Id

--4. Display instructor Name and Department Name
--   Note: display all the instructors if they are attached to a department or not
SELECT
    Instructor.Ins_Name,
    ISNULL(Department.Dept_Name, 'N/A') AS department_name
FROM
    Instructor
LEFT JOIN
    Department ON Instructor.Dept_Id = Department.Dept_Id

--5. Display student full name and the name of the course he is taking For only courses which have a grade
SELECT
    Student.St_Fname+' '+St_Lname AS Student_Full_Name,
    Course.Crs_Name
FROM
    Student
JOIN
    Stud_Course ON Student.St_Id = Stud_Course.st_id
JOIN
    Course ON Stud_Course.Crs_Id = Course.Crs_Id
WHERE
    Stud_Course.Grade IS NOT NULL

--6. Display number of courses for each topic name
SELECT
    T.Crs_Name,
    COUNT(C.Crs_Id) AS Number_of_Courses
FROM
    Course T
LEFT JOIN
    Course C ON T.Crs_Id = C.Crs_Id
GROUP BY
    T.Crs_Name

--7. Display max and min salary for instructors
SELECT
    MAX(Salary) AS Max_Salary,
    MIN(Salary) AS Min_Salary
FROM
    Instructor

--8. Display instructors who have salaries less than the average salary of all instructors.
SELECT Ins_Name,Salary
FROM Instructor
WHERE Salary < (select AVG(Salary) from Instructor)

--9. Display the Department name that contains the instructor who receives the minimum salary.
SELECT
    D.Dept_Name
FROM
    Department D
JOIN
    Instructor I ON D.Dept_Id = I.Dept_Id
WHERE
    I.Salary = (SELECT MIN(Salary) FROM Instructor)

--10. Select max two salaries in instructor table.
SELECT DISTINCT I.Salary as MAX_Salary
FROM Instructor I
WHERE 2 > (
    SELECT COUNT(DISTINCT II.Salary)
    FROM Instructor II
    WHERE II.Salary > I.Salary
)

--11. Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT
    Ins_Name, COALESCE(CAST(Salary AS VARCHAR), 'instructor bonus') AS Salary
FROM
    Instructor;

--12. Select Average Salary for instructors
SELECT AVG(Salary) as AVG_Salary
from Instructor

--13. Select Student first name and the data of his supervisor
SELECT
    S1.St_Fname AS Student_First_Name, S2.*
FROM
    Student S1
JOIN
    Student S2 ON S1.St_super = S2.St_Id

--14. Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
  select *

  from  (SELECT Ins_Name,Salary,I.dept_id,Dept_Name,Row_number() OVER (PARTITION BY I.Dept_Id ORDER BY Salary DESC) AS SalaryRank 
        from Instructor I join Department D on I.Dept_Id=D.Dept_Id)  as newTable

  WHERE SalaryRank in (1,2)
        
--Actual answer
  select *

  from  (SELECT Ins_Name, Salary, Dept_Id, Row_number() OVER (PARTITION BY Dept_Id ORDER BY Salary DESC) AS SalaryRank 
        from Instructor )  as newTable

  WHERE SalaryRank in (1,2)

--15. Write a query to select a random student from each department. “using one of Ranking Functions”
  select *

  from  (SELECT Ins_Name, Salary, Dept_Id, Row_number() OVER (PARTITION BY Dept_Id ORDER BY NEWID()) AS SalaryRank 
        from Instructor )  as newTable

  WHERE SalaryRank = 1

--Part-2: Use AdventureWorks DB
use AdventureWorks2012

--1. Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
SELECT
    SalesOrderID,
    ShipDate
FROM
    Sales.SalesOrderHeader
WHERE
    ShipDate >= '2002-07-28' AND ShipDate <= '2014-07-29'

--2. Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
SELECT
    ProductID,
    Name
FROM
    Production.Product
WHERE
    StandardCost < 110.00

--3. Display ProductID, Name if its weight is unknown
SELECT
    ProductID,
    Name
FROM
    Production.Product
WHERE
    Weight IS NULL

--4. Display all Products with a Silver, Black, or Red Color
SELECT
    ProductID,
    Name,
    Color
FROM
    Production.Product
WHERE
    Color IN ('Silver', 'Black', 'Red')

--5. Display any Product with a Name starting with the letter B
SELECT
    ProductID,
    Name
FROM
    Production.Product
WHERE
    Name LIKE 'B%'

--6. Run the following Query
--      UPDATE Production.ProductDescription
--      SET Description = 'Chromoly steel_High of defects'
--      WHERE ProductDescriptionID = 3
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

--      THEN write a query that displays any Product description with underscore value in its description.
SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%[_]%'

--7. Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between '7/1/2001' and '7/31/2014'
SELECT
    OrderDate,
    SUM(TotalDue) AS TotalDueSum
FROM
    Sales.SalesOrderHeader
WHERE
    OrderDate >= '2001-07-01' AND OrderDate <= '2014-07-31'
GROUP BY
    OrderDate
ORDER BY
    OrderDate

--8. Display the Employees HireDate (note no repeated values are allowed)
SELECT hireDate
FROM HumanResources.Employee

--9. Calculate the average of the unique ListPrices in the Product table
SELECT AVG(DISTINCT ListPrice) AS AverageListPrice
FROM Production.Product

--10. Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format 
--           "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
SELECT
    CONCAT('The ', Name, ' is only! ', ListPrice) AS Product_Info
FROM
    Production.Product
WHERE
    ListPrice >= 100 AND ListPrice <= 120
ORDER BY
    ListPrice


--11.
--    a) Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table in a newly created table named [store_Archive]
CREATE TABLE store_Archive (
    rowguid UNIQUEIDENTIFIER,
    Name NVARCHAR(50),
    SalesPersonID INT,
    Demographics XML
)

--Transfer
INSERT INTO store_Archive (rowguid, Name, SalesPersonID, Demographics)
SELECT rowguid, Name, SalesPersonID, Demographics
FROM Sales.Store

--    Note: Check your database to see the new table and how many rows in it?
SELECT COUNT(*) FROM store_Archive 

--    b) Try the previous query but without transferring the data?
SELECT rowguid, Name, SalesPersonID, Demographics
FROM Sales.Store
WHERE 1 = 0; --ensures no data is transferred

--12. Using union statement, retrieve the today’s date in different styles using convert or format funtion.
SELECT CONVERT(NVARCHAR(20), GETDATE(), 0) AS DateStyle
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 1)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 2)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 3)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 4)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 5)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 6)
UNION
SELECT CONVERT(NVARCHAR(20), GETDATE(), 7)
UNION
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS DateStyle