SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
        ELSE 'others'
    END AS category
FROM departments;


SELECT name, salary
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END AS category
FROM departments;



SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
    END AS category
FROM departments


SELECT name, salary,
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END AS category
FROM departments;

--
SELECT name, salary
FROM departments
WHERE 
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END = 'High'
;

--
SELECT first_name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY first_name
HAVING SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0
	     AND
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0
  
;