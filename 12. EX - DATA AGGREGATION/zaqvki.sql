-- Exercises: Data Aggregation --
-- 1. Records’ Count --

SELECT COUNT(wd.first_name) AS 'Count' 
FROM wizzard_deposits AS wd;

-- 2. Longest Magic Wand --

 SELECT MAX(wd.magic_wand_size) AS 'longest_magic_wand' 
FROM wizzard_deposits AS wd;

-- 3. Longest Magic Wand per Deposit Groups --

SELECT wd.deposit_group, MAX(wd.magic_wand_size) AS 'longest_magic_wand' 
FROM wizzard_deposits AS wd
GROUP BY wd.deposit_group
ORDER BY `longest_magic_wand` ASC, wd.deposit_group ASC;

-- ** 4. Smallest Deposit Group per Magic Wand Size* --

  SELECT deposit_group FROM
(SELECT deposit_group, AVG(magic_wand_size) AS avrage_magic_wand_size
   FROM wizzard_deposits
  GROUP BY deposit_group) as avgm
  WHERE avrage_magic_wand_size = ( SELECT MIN(avrage_magic_wand_size) min_average_magic_wand_size 
								   FROM
								(SELECT deposit_group, AVG(magic_wand_size) AS avrage_magic_wand_size
								   FROM wizzard_deposits
								  GROUP BY deposit_group) AS av)
								  
-- My version of 4. Smallest Deposit Group per Magic Wand Size* -- 
CREATE VIEW VASDF AS

SELECT w.deposit_group, AVG(w.magic_wand_size) AS minavg
FROM wizzard_deposits AS w
GROUP BY w.deposit_group;

SELECT deposit_group
FROM vasdf
WHERE minavg = (SELECT MIN(minavg) FROM VASDF);

-- 5. Deposits Sum --

SELECT w.deposit_group, SUM(w.deposit_amount) AS 'total_sum'
FROM wizzard_deposits AS w
GROUP BY w.deposit_group
ORDER BY total_sum ASC;

-- 6. Deposits Sum for Ollivander family --

SELECT w.deposit_group, SUM(w.deposit_amount) AS 'total_sum'
FROM wizzard_deposits AS w
WHERE w.magic_wand_creator = 'Ollivander family'
GROUP BY w.deposit_group;

-- 7. Deposits Filter -- 

SELECT w.deposit_group, SUM(w.deposit_amount) AS 'total_sum'
FROM wizzard_deposits AS w
WHERE w.magic_wand_creator = 'Ollivander family'
GROUP BY w.deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

-- 8. Deposit charge --

SELECT w.deposit_group, w.magic_wand_creator, MIN(w.deposit_charge) AS 'min_deposit_charge'
FROM wizzard_deposits AS w
GROUP BY w.magic_wand_creator, w.deposit_group
ORDER BY w.magic_wand_creator ASC, w.deposit_group ASC;

-- ** 9. Age Groups --

 SELECT 
      CASE
			WHEN age <= 10 THEN '[0-10]'
			WHEN age <= 20 THEN '[11-20]'
			WHEN age <= 30 THEN '[21-30]'
			WHEN age <= 40 THEN '[31-40]'
			WHEN age <= 50 THEN '[41-50]'
			WHEN age <= 60 THEN '[51-60]'
			ELSE '[61+]'
		END 
		AS age_group,
        COUNT(*) AS wizzard_count
   FROM wizzard_deposits
  GROUP BY 
  		CASE
			WHEN age <= 10 THEN '[0-10]'
			WHEN age <= 20 THEN '[11-20]'
			WHEN age <= 30 THEN '[21-30]'
			WHEN age <= 40 THEN '[31-40]'
			WHEN age <= 50 THEN '[41-50]'
			WHEN age <= 60 THEN '[51-60]'
			ELSE '[61+]'
		END
-- 10. First Letter --
-- use gringotts;

SELECT DISTINCT SUBSTR(w.first_name, 1, 1) AS 'first_letter'
FROM wizzard_deposits as w
WHERE w.deposit_group = 'Troll Chest'
ORDER BY `first_letter` ASC;

-- 11. Average Interest --
-- use gringotts;

SELECT w.deposit_group, w.is_deposit_expired, AVG(w.deposit_interest) AS 'average_interest'
FROM wizzard_deposits as w
WHERE w.deposit_start_date > '1985-01-01'
GROUP BY w.deposit_group, w.is_deposit_expired
ORDER BY w.deposit_group DESC, w.is_deposit_expired ASC;

-- 12. Rich Wizard, Poor Wizard* --

CREATE VIEW rw_pw AS
SELECT w1.first_name AS host_wizzard, 
	w1.deposit_amount AS host_wizzard_deposit, 
		 w2.first_name AS guest_wizzard,
	w2.deposit_amount AS guest_wizzard_deposit
FROM 
	 wizzard_deposits AS w1, 
	 wizzard_deposits AS w2
WHERE w1.id + 1 = w2.id;

SELECT SUM(host_wizzard_deposit - guest_wizzard_deposit)
FROM rw_pw;

-- 13. Employees Minimum Salaries --

SELECT e.department_id, MIN(e.salary) AS minimum_salary
FROM employees AS e
WHERE e.hire_date>'2000-01-01'
GROUP BY e.department_id
HAVING e.department_id IN (2, 5, 7)
ORDER BY e.department_id ASC;

-- 14. Employees Average Salaries --

CREATE TABLE high_paid_empl
SELECT * FROM employees
WHERE salary > 30000;

DELETE FROM high_paid_empl
WHERE manager_id = 42;

UPDATE high_paid_empl
SET salary = salary + 5000
WHERE department_id = 1;

SELECT h.department_id, TRUNCATE(AVG(h.salary), 4)
FROM high_paid_empl AS h
GROUP BY h.department_id
order by h.department_id;

-- 15. Employees Maximum Salaries --

SELECT e.department_id, MAX(e.salary) AS max_salary
FROM employees AS e
GROUP BY e.department_id
having not max(Salary) between 30000 and 70000;

-- 16. Employees Count Salaries -- 

SELECT COUNT(*) AS COUNT 
FROM employees
WHERE manager_id IS NULL

-- 17. 3rd Highest Salary* --

SELECT e.department_id, MAX(salary) AS third_max_salary
FROM employees AS e
	
		JOIN
	
		(SELECT e.department_id, MAX(salary) AS second_max_salary 
		FROM employees AS e
	
						JOIN

						(SELECT e.department_id, MAX(salary) AS max_salary 
						FROM employees AS e
						GROUP BY department_id) AS max_salary_table
	      			ON e.department_id = max_salary_table.department_id
			   		AND e.salary < max_salary_table.max_salary
   
		GROUP BY e.department_id) AS second_max_salary_table
		ON e.department_id = second_max_salary_table.department_id
		AND e.salary < second_max_salary_table.second_max_salary
   
GROUP BY e.department_id;

-- 18. Salary Challenge** --

SELECT e.first_name, e.last_name, e.department_id
FROM employees AS e, 

(SELECT e.department_id, avg(e.salary) AS avg_salary
FROM employees AS e
GROUP BY e.department_id) AS avg_salary_by_dep

WHERE e.department_id = avg_salary_by_dep.department_id
AND e.salary > avg_salary_by_dep.avg_salary
ORDER BY e.department_id ASC
LIMIT 10;

-- 19. Departments Total Salaries --

SELECT department_id, SUM(salary) AS total_salary 
FROM employees
GROUP BY department_id
ORDER BY department_id ASC;

