-- Exercises: Subqueries and JOINs --
-- 1. Employee Address

SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees AS e 
JOIN addresses AS a
ON e.address_id = a.address_id
ORDER BY e.address_id ASC
LIMIT 5

-- Problem 2.	Addresses with Towns --

SELECT e.first_name, e.last_name, t.name AS 'town', a.address_text
FROM employees AS e 
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
ORDER BY e.first_name ASC, e.last_name ASC
LIMIT 5

-- Problem 3.	Sales Employee --

SELECT e.employee_id, e.first_name, e.last_name, d.name AS department_name
FROM employees AS e 
JOIN departments AS d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 4. Employee Departments --

SELECT e.employee_id, e.first_name, e.salary, d.name AS department_name
FROM employees AS e 
RIGHT JOIN departments AS d
USING(`department_id`)
WHERE e.salary > 15000
ORDER BY e.department_id DESC, e.salary
LIMIT 5;

-- 5. Employees Without Project --

SELECT e.employee_id, e.first_name
FROM employees AS e
LEFT JOIN employees_projects AS ep
ON ep.employee_id = e.employee_id
WHERE ep.employee_id IS NULL
ORDER	 BY e.employee_id DESC
LIMIT 3;

-- 6. Employees Hired After --

SELECT e.first_name, e.last_name, DATE_FORMAT(e.hire_date, '%Y-%m-%d') AS 'hire_date ', d.name
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.department_id
WHERE e.hire_date > '1999-01-01' AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC;

-- 7. Employees with Project --

SELECT e.employee_id, e.first_name, p.name
FROM employees AS e
JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
JOIN projects AS p
ON ep.project_id = p.project_id
WHERE p.start_date > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name ASC, p.name ASC
LIMIT 5;

-- 8. Employee 24 --

SELECT e.employee_id, e.first_name,  
	CASE
      WHEN YEAR (p.start_date) >= 2005
	  	THEN p.name = NULL
      ELSE p.name
   END
AS project_name
FROM employees AS e
JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
JOIN projects AS p
ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY p.name ASC
LIMIT 5;

-- 9. Employee Manager --

SELECT e.employee_id, e.first_name, e.manager_id, ep.first_name AS 'manager_name'
FROM employees AS e
JOIN employees AS ep
ON e.manager_id = ep.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name ASC;

-- 10. Employee Summary --

SELECT e.employee_id, 
		CONCAT(e.first_name, ' ', e.last_name) AS 'employee_name',
		CONCAT(ep.first_name, ' ', ep.last_name) AS 'manager_name',
		d.name
FROM employees AS e
JOIN employees AS ep
ON e.manager_id = ep.employee_id
JOIN departments AS d
ON e.department_id = d.department_id
ORDER BY e.employee_id ASC
LIMIT 5;

-- 11. Min Average Salary --

SELECT MIN(tab.average)
FROM (SELECT e.department_id, d.name, AVG(e.salary) AS 'average'
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY d.name) AS tab

-- USE DATABASE `geography`
-- Problem 12.	Highest Peaks in Bulgaria --

SELECT ctr.country_code, m.mountain_range, peak_name, elevation 
FROM countries AS ctr
JOIN mountains_countries AS mc
ON ctr.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
JOIN peaks AS p
ON p.mountain_id = m.id
WHERE p.elevation > 2835 AND ctr.country_code = 'BG'
ORDER BY p.elevation DESC;

-- 13. Count Mountain Ranges --

SELECT ctr.country_code, COUNT(m.mountain_range) AS 'mountain_range'
FROM countries AS ctr
JOIN mountains_countries AS mc
ON ctr.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
WHERE ctr.country_code IN ('BG', 'US', 'RU')
GROUP BY ctr.country_code
ORDER BY `mountain_range` DESC;

-- 14. Countries with Rivers --

SELECT ctr.country_name, r.river_name
FROM continents AS cn
JOIN countries AS ctr
ON cn.continent_code = ctr.continent_code
LEFT JOIN countries_rivers AS cr
ON ctr.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE cn.continent_name = 'Africa'
ORDER BY ctr.country_name ASC
LIMIT 5;

-- 15. *Continents and Currencies --

SELECT cu2.continent_code, cu2.currency_code , cu2.currency_usage
	FROM (SELECT continent_code, currency_code ,count(currency_code) AS 'currency_usage'
	        FROM countries
			GROUP BY continent_code, currency_code
			HAVING count(currency_code) > 1
           ) AS cu2
	JOIN
		(SELECT cu.continent_code, max(currency_usage) AS 'max_currency_usage'
			FROM
		(SELECT continent_code, currency_code ,count(currency_code) AS 'currency_usage'
			FROM countries
			GROUP BY continent_code, currency_code
			HAVING count(currency_code) > 1) AS cu
			GROUP BY cu.continent_code) AS max_cu
ON cu2.continent_code = max_cu.continent_code
AND cu2.currency_usage = max_cu.max_currency_usage
ORDER BY cu2.continent_code, cu2.currency_code;

-- 15. Solution with view creation:

CREATE VIEW v_cur
AS 
(SELECT continent_code, currency_code ,count(currency_code) AS 'currency_usage'
	      FROM countries
			GROUP BY continent_code, currency_code
			HAVING count(currency_code) > 1
        );

SELECT v_cur.continent_code, v_cur.currency_code , v_cur.currency_usage
	FROM  
		  v_cur
	JOIN
		  (SELECT v_cur.continent_code, max(currency_usage) AS 'max_currency_usage'
			FROM
		     v_cur 
			GROUP BY v_cur.continent_code
			) 
			AS max_cu
	ON v_cur.continent_code = max_cu.continent_code
AND v_cur.currency_usage = max_cu.max_currency_usage
ORDER BY v_cur.continent_code, v_cur.currency_code;

-- 16.	Countries without any Mountains --??

SELECT COUNT(c.country_code) - COUNT(mountain_id) AS CountryCode 
FROM mountains AS m
RIGHT JOIN mountains_countries AS mc
ON m.id = mc.mountain_id
RIGHT JOIN countries AS c
ON mc.country_code = c.country_code

-- 17.	Highest Peak and Longest River by Country --

SELECT c.country_name,
       MAX(p.elevation) AS highest_peak_elevation,
       MAX(r.length) AS longest_river_length
FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON mc.country_code = c.country_code
LEFT JOIN peaks AS p
ON mc.mountain_id = p.mountain_id
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC,
longest_river_length DESC, c.country_name ASC
LIMIT 5;