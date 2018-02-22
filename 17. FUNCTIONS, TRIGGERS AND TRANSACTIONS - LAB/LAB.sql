-- Lab: Functions, Triggers and Transactions --
-- 1. Count Employees by Town --

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS DOUBLE
BEGIN
	DECLARE e_count DOUBLE;
	SET e_count := (SELECT COUNT(e.first_name)
	FROM
	employees AS e
	LEFT JOIN addresses AS a
	ON e.address_id = a.address_id
	LEFT JOIN towns AS t
	ON a.town_id = t.town_id
	WHERE t.name = town_name);
	RETURN e_count;
END
$$

-- 2. Employees Promotion --

DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
	UPDATE employees AS e
	JOIN departments AS d
	ON e.department_id = d.department_id
	SET e.salary = e.salary * 1.05
	WHERE d.name = 'Engineering';
END
$$

-- 3. Employees Promotion By ID --

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
	IF ((SELECT COUNT(e.employee_id)
		FROM employees AS e
		WHERE e.employee_id = id) <> 1)
	THEN	
		ROLLBACK;
	ELSE 
		UPDATE employees AS e
		SET e.salary = e.salary * 1.05
		WHERE e.employee_id = id;
	END IF;	
END
$$

-- 4. Triggered --

CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20),
last_name VARCHAR(20),
middle_name VARCHAR(20),
job_title VARCHAR(50),
department_id INT,
salary DOUBLE
);

CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees
(first_name,last_name,middle_name,job_title,department_i
d,salary)
VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,OL
D.job_title,OLD.department_id,OLD.salary);
END;