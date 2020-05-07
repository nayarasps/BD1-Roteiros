-- @author Nayara Souza - 118110390 - UFCG

-- Q1
SELECT COUNT(sex)
  FROM employee
 WHERE sex = 'F';

-- Q2
SELECT AVG(salary)
  FROM employee
 WHERE adress LIKE '%TX' AND sex = 'M';

-- Q3
SELECT e.superssn AS ssn_supervisor, COUNT(e.ssn) AS qtd_supervisionados
  FROM employee AS e
 GROUP BY e.superssn
 ORDER BY COUNT(*) ASC;

-- Q4
SELECT e.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados
  FROM (employee AS e JOIN employee AS m ON e.ssn = m.superssn)
 GROUP BY e.ssn
 ORDER BY COUNT(*) ASC;

-- Q5
SELECT e.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados
  FROM (employee AS e RIGHT OUTER JOIN employee AS m ON e.ssn = m.superssn)
 GROUP BY e.ssn
 ORDER BY COUNT(*) ASC;

-- Q6
SELECT MIN(COUNT) AS qtd
  FROM (
    SELECT COUNT(*)
      FROM works_on
      GROUP BY pno
    ) AS a;

-- Q7
SELECT pno AS num_projeto, qtd AS qtd_func
FROM (
      (SELECT pno, COUNT(*)
        FROM works_on
        GROUP BY pno
      ) AS a
    JOIN
      (SELECT MIN(COUNT) AS qtd
        FROM (
            SELECT COUNT(*)
            FROM works_on
            GROUP BY pno
        ) AS b
    ) AS minimum

    ON a.COUNT = minimum.qtd
);

-- Q8
SELECT w.pno AS num_proj, AVG(e.salary) AS media_sal
  FROM works_on AS w JOIN (employee AS e ON (w.essn = e.ssn))
  GROUP BY w.pno;

-- Q9
SELECT w.pno AS proj_num, p.pname AS proj_name, AVG(e.salary) AS media_sal
  FROM project AS p JOIN (works_on AS w JOIN employee AS e ON (w.essn = e.ssn)) ON (p.pnumber = w.pno)
  GROUP BY w.pno, p.pname;

-- Q10
SELECT e.fname, e.salary
  FROM employee AS e
  WHERE e.salary > ALL (
    SELECT e.salary
    FROM works_on AS w JOIN employee AS e ON (w.essn = e.ssn AND w.pno = 92)
);

-- Q11
SELECT e.ssn AS ssn, COUNT(w.pno) AS qtd_proj
FROM employee AS e LEFT OUTER JOIN works_on AS w ON (e.ssn = w.essn)
GROUP BY e.ssn
ORDER BY COUNT(w.pno) ASC;

-- Q12
SELECT pno AS num_proj, COUNT AS qtd_func
  FROM (
    SELECT pno, COUNT(*)
    FROM employee AS e LEFT OUTER JOIN works_on AS w ON (w.essn = e.ssn) 
    GROUP BY pno
  ) AS qtd
WHERE qtd.count < 5;

-- Q13
SELECT e.fname 
  FROM employee AS e 
  WHERE e.ssn IN (SELECT e.ssn 
                    FROM works_on AS w WHERE(e.ssn = w.essn) AND w.pno IN 
                    (SELECT w.pno FROM project AS p WHERE (p.pnumber = w.pno) AND p.pname IN 
                    (SELECT p.pname FROM project AS p WHERE (p.plocation = 'Sugarland') AND EXISTS
                    (SELECT pname FROM dependent AS d WHERE d.essn = e.ssn))));

-- Q14
SELECT d.dname
FROM department AS d 
WHERE NOT EXISTS(
    SELECT *
    FROM project AS p
    WHERE p.dnum = d.dnumber
);

-- Q15
SELECT DISTINCT fname, lname
  FROM employee AS e, works_on 
  WHERE essn = ssn AND ssn <> '123456789' AND NOT EXISTS (
    (SELECT pno FROM works_on WHERE essn = '123456789')
    EXCEPT(SELECT pno FROM works_on WHERE essn = e.ssn));

-- Q16
SELECT e.fname, e.salary
  FROM (SELECT proj_number AS pj
            FROM (
              SELECT w.pno AS proj_number, AVG(e.salary) AS avg_salary
                FROM (works_on AS w JOIN employee AS e ON (w.essn = e.ssn))
                GROUP BY proj_number
            ) AS a
            WHERE avg_salary IN (SELECT MAX(avg_salary) FROM (
              SELECT w.pno AS proj_number, AVG(e.salary) AS avg_salary
                FROM (works_on AS w JOIN employee AS e ON (w.essn = e.ssn))
                GROUP BY proj_number
            ) AS b)
  )AS p_number, employee AS e
  WHERE e.salary > ALL (
    SELECT e.salary
    FROM works_on AS w JOIN employee AS e ON (w.essn = e.ssn AND w.pno = p_number.pj)
  );
