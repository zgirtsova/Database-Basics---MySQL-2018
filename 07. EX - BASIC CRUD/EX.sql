-- --------1. Find All Information About Departments----------
USE `soft_uni`;

SELECT *
FROM `departments`
ORDER BY `department_id`;

-- --------2. Find all Department Names------------

USE `soft_uni`;

SELECT DISTINCT `name` 
FROM `departments`
ORDER BY `department_id`;

-- --------3. Find salary of Each Employee---------

USE `soft_uni`;

SELECT `first_name`, `last_name`, `salary` 
FROM `employees`
ORDER BY `employee_id`;

-- --------4. Find Full Name of Each Employee---------

USE `soft_uni`;

SELECT `first_name`, `middle_name`, `last_name`
FROM `employees`
ORDER BY `employee_id`;

-- --------5. Find Email Address of Each Employee---------

USE `soft_uni`;

SELECT CONCAT(`first_name`, '.', `last_name`, '@softuni.bg') 
AS `full_email_address` FROM `employees`;

-- ---------6. Find All Different Employee’s Salaries----------

USE `soft_uni`;

SELECT DISTINCT `salary` 
FROM `employees` 
ORDER BY `employee_id`;

-- -------7. Find all Information About Employees----------

USE `soft_uni`;

SELECT *
FROM `employees`
WHERE `job_title` = 'Sales Representative'
ORDER BY `employee_id`;

-- --------8. Find Names of All Employees by salary in Range---------

USE `soft_uni`;

SELECT `first_name`, `last_name`, `job_titLe`
FROM `employees`
WHERE `salary` BETWEEN 20000 AND 30000
ORDER BY `employee_id`;
	
-- ------9. Find Names of All Employees---------

USE `soft_uni`;

SELECT CONCAT (`first_name`, ' ', `middle_name`, ' ', `last_name`) AS `full_name`
FROM `employees`
WHERE `salary` IN (12500, 14000, 23600, 25000)
ORDER BY `employee_id`;

-- ------10. Find All Employees Without Manager--------

USE `soft_uni`;

SELECT `first_name`, `last_name`  
FROM `employees`
WHERE `manager_id` IS NULL;

-- ------11. Find All Employees with salary More Than 50000------

USE `soft_uni`;

SELECT `first_name`, `last_name`, `salary`  
FROM `employees`
WHERE `salary` > 50000
ORDER BY `salary` DESC;

-- -----12. Find 5 Best Paid Employees----------

USE `soft_uni`;

SELECT `first_name`, `last_name` 
FROM `employees`
ORDER BY `salary` DESC
LIMIT 5;

-- ------13. Find All Employees Except Marketing------

USE `soft_uni`;

SELECT `first_name`, `last_name` 
FROM `employees`
WHERE `department_id` != 4;

-- -----14. Sort Employees Table------

USE `soft_uni`;


SELECT * FROM `employees`
ORDER BY `salary` DESC,
			`first_name` ASC,
			`last_name` DESC,
			`middle_name` ASC;
			
-- ----15. Create View Employees with Salaries-------

USE `soft_uni`;

CREATE VIEW `v_employees_salaries` AS
SELECT `first_name`, `last_name`, `salary`
FROM `employees`;

SELECT * FROM `v_employees_salaries`;

-- -----16. Create View Employees with Job Titles-------

UPDATE `employees`
	SET `middle_name` = ''
	WHERE `middle_name` IS NULL;
	
CREATE VIEW `v_employees_job_titles` AS
	SELECT CONCAT_WS(' ', `first_name`,`middle_name`, `last_name`) AS 'full_name' ,`job_title` 
	FROM `employees`;
	
SELECT * FROM `v_employees_job_titles`;

-- -----17. Distinct Job Titles-------

USE `soft_uni`;

SELECT DISTINCT `job_title` FROM `employees`
ORDER BY `job_title`;

-- -----18. Find First 10 Started Projects--------

USE `soft_uni`;

SELECT * FROM `projects`
ORDER BY `start_date` ASC, `name` ASC 
LIMIT 10;

-- ------19. Last 7 Hired Employees-------

USE `soft_uni`;

SELECT `first_name`, `last_name`, `hire_date` 
FROM `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

-- -----20. Increase Salaries--------

USE `soft_uni`;

UPDATE `employees`
SET `salary` = `salary` * 1.12
WHERE `department_id` = 1 OR `department_id` = 2 OR `department_id` = 4 OR `department_id` = 11;
SELECT `salary` FROM `employees`;

-- Part II – Queries for Geography Database --

-- ------21. All Mountain Peaks-------

USE `geography`;

SELECT `peak_name` FROM `peaks`
ORDER BY `peak_name` ASC;

-- -----22. Biggest Countries by Population------

USE `geography`;

SELECT `country_name`, `population` FROM `countries` 
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC, `country_name` ASC
LIMIT 30;

-- -----23. Countries and Currency (Euro / Not Euro)-------

USE `geography`;

SELECT `country_name` , `country_code`, 
IF (`currency_code` = 'EUR', 'Euro', 'Not Euro') AS currency 
FROM `countries` 
ORDER BY `country_name` ASC;

-- Part III – Queries for Diablo Database

-- -------24. All Diablo Characters-------

USE `diablo`;

SELECT `name` FROM `characters` ORDER BY `name` ASC;
