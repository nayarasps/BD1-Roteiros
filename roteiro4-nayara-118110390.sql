-- @author Nayara Souza - 118110390 - UFCG

-- Q1
SELECT * FROM department;

-- Q2
SELECT * FROM dependent;

-- Q3
SELECT * FROM dept_locations;

-- Q4
SELECT * FROM employee;

-- Q5
SELECT * FROM project;

-- Q6
SELECT * FROM works_on;

-- Q7
SELECT fname, lname
  FROM employee
 WHERE sex='M';

-- Q8
SELECT fname
  FROM employee
 WHERE sex='M' AND superssn IS NULL;

-- Q9
SELECT e.fname, s.fname
  FROM employee AS e,
        employee AS s
 WHERE e.superssn = s.ssn;

-- Q10
SELECT e.fname
  FROM employee AS e,
        employee AS s
 WHERE e.superssn = s.ssn AND s.fname = 'Franklin';

-- Q11
SELECT d.dname, l.dlocation
  FROM department AS d,
        dept_locations AS l
 WHERE d.dnumber = l.dnumber;

-- Q12
SELECT d.dname
  FROM department AS d,
        dept_locations AS l
 WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';

-- Q13
SELECT e.fname, e.lname, d.dependent_name
  FROM employee AS e,
        dependent AS d
 WHERE e.ssn = d.essn;

-- Q14
SELECT (fname || ' ' || minit || ' ' || lname) AS full_name, salary
  FROM employee
 WHERE salary > 50000;

-- Q15
SELECT p.pname, d.dname
  FROM project AS p,
        department AS d
 WHERE p.dnum = d.dnumber;

-- Q16
SELECT p.pname, e.fname
  FROM project AS p,
        employee AS e,
         department AS d
 WHERE p.dnum = d.dnumber AND d.mgrssn = e.ssn AND pnumber > 30;

-- Q17
SELECT e.fname, p.pname
  FROM project AS p,
        employee AS e,
         works_on AS w
 WHERE w.essn = e.ssn AND w.pno = p.pnumber;

-- Q18
SELECT e.fname, d.dependent_name, d.relationship 
  FROM employee AS e,
         works_on AS w,
          dependent AS d
 WHERE w.pno = 91 AND w.essn = d.essn AND d.essn = e.ssn;