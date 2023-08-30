use Company_SD

--(check)1. Display (Using Union Function)
        --a. The name and the gender of the dependence that's gender is Female and depending on Female Employee.
        --b. And the male dependence that depends on Male Employee.
SELECT
    D.Dependent_name,D.Sex
FROM
    dependent D JOIN Employee E 
    ON D.ESSN = E.SSN
WHERE
    (D.Sex = 'F' AND E.Sex = 'F')
UNION
SELECT
    D.Dependent_name,D.Sex
FROM
    dependent D JOIN Employee E 
    ON D.ESSN = E.SSN
WHERE
    (D.Sex = 'M' AND E.Sex = 'M');
    
--2. For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT
    P.pname,SUM(W.HOURS) AS total_hours_per_week
FROM
    Project P
JOIN
    Works_for W ON P.Pnumber = W.Pno
GROUP BY
    P.pname;


--3. Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT *
FROM Departments d
WHERE d.Dnum =
    (SELECT e.Dno from Employee e  WHERE e.SSN = 
        (SELECT MIN(SSN) FROM Employee)); 

--4. For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT d.Dname,MAX(Salary) AS maximum,MIN(Salary) AS minimum, 
               AVG(Salary) AS AvgSalary
FROM Departments d INNER JOIN Employee e on d.Dnum=e.Dno
GROUP BY d.Dname

--(check)5. List the full name of all managers who have no dependents.
SELECT e.Fname + ' ' + e.Lname AS FullName
FROM Employee e
INNER JOIN Departments innd ON e.SSN = innd.MGRSSN
LEFT JOIN Dependent lefd ON e.SSN = lefd.ESSN
WHERE lefd.ESSN IS NULL;

--6. For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
SELECT Dno, Dname, COUNT(SSN)
FROM Employee INNER JOIN Departments ON Dno = Dnum
--where Dno id not NULL
GROUP BY Dno, Dname
HAVING AVG(Salary) < (SELECT AVG(Salary) FROM Employee)

--7. Retrieve a list of employees names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.
SELECT Fname, Lname, d.dnum, p.Pname
FROM Employee inner JOIN Departments d ON dno = d.dnum
            inner JOIN Project p ON d.dnum = p.dnum
ORDER BY Lname,Fname, d.dnum

--8. Try to get the max 2 salaries using subquery
SELECT DISTINCT Salary
FROM Employee e1
WHERE 2 >= (
    SELECT COUNT(DISTINCT Salary)
    FROM Employee e2
    WHERE e2.Salary >= e1.Salary 
)
ORDER BY Salary DESC;

--(check)9. Get the full name of employees that is similar to any dependent name
SELECT e.Fname+''+ e.Lname AS fullname
FROM Employee e
INNER JOIN Dependent d ON e.SSN = d.ESSN
WHERE e.Fname LIKE '%' + d.Dependent_name + '%'
   OR e.Lname LIKE '%' + d.Dependent_name + '%';

--10. Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
SELECT ssn, e.Fname + ' ' + e.Lname AS fullname
FROM Employee E
WHERE EXISTS (
    SELECT 1
    FROM dependent D
    WHERE D.ESSN = E.SSN
);

--11. In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'

INSERT INTO Departments (Dnum, Dname, MGRSSN,[MGRStart Date])
VALUES (100, 'DEPT IT', 112233,'2006-11-01');

--(check)12. Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager)
        --a. First try to update her record in the department table
        UPDATE Departments
        SET MGRSSN = 968574
        WHERE Dnum = 100;

        --b. Update your record to be department 20 manager.
        UPDATE Employee
        SET Dno = 20
        WHERE SSN = 102672;

        --c. Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
        UPDATE Employee
        SET Superssn = 102672
        WHERE SSN = 102660;

--13. Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
        --Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
        -- a. Check for Dependents
        SELECT COUNT(*) FROM dependent WHERE ESSN = '223344';

        -- b. Check for Department Manager Role
        SELECT COUNT(*) FROM Department WHERE Superssn = '223344';

        -- c. Check for Supervised Employees
        SELECT COUNT(*) FROM Employee WHERE Superssn = '223344';

        -- d. Check for Assigned Projects
        SELECT COUNT(*) FROM WorkAssignment WHERE SSN = '223344';

-- Delete Mr. Kamel's data
DELETE FROM Employee WHERE SSN = '223344';

--14. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
UPDATE Employee SET Salary = Salary+salary * 0.3
WHERE SSN IN (
    SELECT ESSn
    FROM Works_for INNER JOIN project ON Pno = Pnumber
    And Pname = 'Al Rabwah'
    )