-- Part I – Queries for SoftUni Database --
-- 1. Find Names of All Employees by First Name --

USE `soft_uni`;

SELECT `first_name`, `last_name` FROM `employees`
WHERE `first_name` LIKE 'SA%'
ORDER BY `first_name` DESC;

-- 2. Find Names of All employees by Last Name --

USE `soft_uni`;

SELECT `first_name`, `last_name` 
FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id` ASC;

-- 3. Find First Names of All Employees -- 

USE `soft_uni`;

SELECT `first_name`
FROM `employees`
WHERE (`department_id` IN (3, 10)) AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `department_id` ASC;

-- 4. Find All Employees Except Engineers --

USE `soft_uni`;

SELECT `first_name`, `last_name`
FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id` ASC;

-- 5. Find Towns with Name Length --

USE `soft_uni`;

SELECT `name`
FROM `towns`
WHERE CHAR_LENGTH(`name`) = 5 OR CHAR_LENGTH(`name`) = 6
ORDER BY `name` ASC;

-- 6. Find Towns Starting With --

USE `soft_uni`;

SELECT `town_id`, `name`
FROM `towns`
WHERE `name` REGEXP '^(M|K|B|E)'
ORDER BY `name` ASC;

-- 7. Find Towns Not Starting With --

USE `soft_uni`;

SELECT `town_id`, `name`
FROM `towns`
WHERE `name` REGEXP '^[^RBD]'
ORDER BY `name` ASC;

-- 8. Create View Employees Hired After 2000 Year --

USE `soft_uni`;

CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name`
FROM `employees`
WHERE YEAR(`hire_date`) > 2000;

SELECT * FROM `v_employees_hired_after_2000`;
	
-- 9. Length of Last Name --

USE `soft_uni`;

SELECT `first_name`, `last_name`
FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;

-- Part II – Queries for Geography Database

-- 10. Countries Holding ‘A’ 3 or More Times

USE `geography`;

SELECT `country_name`, `iso_code`
FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

-- 11. Mix of Peak and River Names --

SELECT p.`peak_name`, r.`river_name`, LOWER(CONCAT(p.`peak_name`, SUBSTR(r.`river_name`,2))) AS `mix`
FROM `peaks` AS p, `rivers` AS r
WHERE RIGHT(p.`peak_name`, 1) = LEFT(r.`river_name`, 1)
ORDER BY `mix`;

-- Part III – Queries for Diablo Database
-- 12. Games from 2011 and 2012 year

SELECT `name`,
DATE_FORMAT(`start`, '%Y-%m-%d') AS `start` 
FROM `games`
WHERE YEAR(`start`) = 2011 or YEAR(`start`) = 2012
ORDER BY `start`, `name`
LIMIT 50

-- 13. User Email Providers --

SELECT `user_name`,
SUBSTRING_INDEX(`email`,'@',-1) AS `Email Provider` 
FROM `users`
ORDER BY `Email Provider` ASC, `user_name` ASC

-- 14. Get Users with IP Address Like Pattern --

SELECT `user_name`, `ip_address` 
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name` ASC

-- 15. Show All Games with Duration and Part of the Day

SELECT `name` AS `Game`,
	CASE 
		WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
      WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
      WHEN HOUR(`start`) BETWEEN 18 AND 23 THEN 'Evening'
	END 
	AS 'Part of the day',
	CASE 
		WHEN `duration` <= 3 THEN 'Extra Short'
      WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
      WHEN `duration` between 7 AND 10 THEN 'Long'
      ELSE 'Extra Long' 
	END 
	AS 'Duration'
FROM `games`
ORDER BY `Game`;

-- Part IV – Date Functions Queries --
-- 16. Orders Table --

SELECT `product_name`, `order_date`,
DATE_ADD(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
DATE_ADD(`order_date`, INTERVAL 1 month ) AS `deliver_due`
FROM `orders`;

-- -----------17-----------------
select name,
TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) AS age_in_years,
MONTH(birthdate) as age_in_months,
datediff(birthdate, CURDATE()) as age_in_days,
TIMESTAMPDIFF(SECOND, birthdate, CURDATE()) as age_in_minutes
from People;






