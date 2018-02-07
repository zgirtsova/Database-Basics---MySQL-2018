/*--------Problem 1: Select Employee Information------*/

USE `hospital`;
SELECT `id`, `first_name`, `last_name`, `job_title` FROM `employees` ORDER BY `id`;

/*--------Problem 2: Select Employees with Filter------*/

USE `hospital`;
SELECT 
	`id`, 
	CONCAT(`first_name`,' ',`last_name`) AS 'full_name', 
	`job_title`, 
	`salary` 
		FROM `employees` WHERE `salary` > 1000
		ORDER BY `id`;
		
/*--------Problem 3: Update Employees Salary--------*/

USE `hospital`;
UPDATE `employees` 
	SET `salary` = `salary` * 1.1 
	WHERE `job_title` = 'Therapist';
	
SELECT `salary` FROM `employees`
	ORDER BY `salary`;
	
/*--------Problem 4: Top Paid Employee---------*/

USE `hospital`;

SELECT * FROM `employees`
	ORDER BY `salary` DESC
	LIMIT 1;
	
/*--------Problem 5: Select Employees by Multiple Filters--------*/

USE `hospital`;

SELECT * FROM `employees`
	WHERE `department_id` = 4 AND `salary` >= 1600
	ORDER BY `id`;
	
/*-------Problem 6: Delete from Table------------*/

USE `hospital`;

	DELETE FROM `employees`
	WHERE `department_id` = 1 OR `department_id` = 2;
	
SELECT * FROM `employees`
	ORDER BY `id`;
