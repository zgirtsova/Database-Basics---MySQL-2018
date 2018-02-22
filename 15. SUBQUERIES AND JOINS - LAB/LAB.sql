-- Lab: Subqueries and JOINs --
-- 1.	Managers --

SELECT d.manager_id, CONCAT(e.first_name,' ', e.last_name) AS 'full_name', 
		 d.department_id, d.name AS 'department_name'
FROM employees AS e
JOIN departments AS d
ON e.employee_id = d.manager_id
ORDER BY d.manager_id
LIMIT 5;

-- 2.	Towns Adresses --

SELECT t.town_id, t.name AS 'town_name', ad.address_text
FROM towns AS t
JOIN addresses AS ad
ON t.town_id = ad.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id ASC, ad.address_id ASC;

-- 3.	Employees Without Managers --

SELECT e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
FROM employees AS e
WHERE e.manager_id IS NULL;

-- 4.	Higher Salary --

SELECT COUNT(e.employee_id)
FROM employees AS e
WHERE e.salary > (SELECT AVG(e.salary)
FROM employees AS e);