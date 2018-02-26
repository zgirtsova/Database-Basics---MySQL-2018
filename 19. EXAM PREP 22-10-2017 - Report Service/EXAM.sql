-- Database Basics MS SQL Exam – 22 Oct 2017 --
-- Section 1. DDL (30 pts) --------------------

USE report_service;
CREATE TABLE users(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(30) UNIQUE,
	`password` VARCHAR(50) NOT NULL,
	name VARCHAR(50),
	gender VARCHAR(1),
	birthdate DATETIME,
	age INT(11) UNSIGNED,
	email VARCHAR(50) NOT NULL
);  

CREATE TABLE departments(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE employees(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	gender VARCHAR(1),
	birthdate DATETIME,
	age INT(11) UNSIGNED,
	department_id INT(11) UNSIGNED NOT NULL,
	CONSTRAINT fk_employees_deparments 
	FOREIGN KEY (department_id) 
	REFERENCES departments(id)
);

CREATE TABLE categories(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	department_id INT(11) UNSIGNED NOT NULL,
	CONSTRAINT fk_categories_deparments 
	FOREIGN KEY (department_id) 
	REFERENCES departments(id)
);

CREATE TABLE `status`(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	label VARCHAR(30) NOT NULL
);

CREATE TABLE `reports`(
	id INT(11) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	category_id INT(11) UNSIGNED NOT NULL,
	status_id INT(11) UNSIGNED NOT NULL,
	open_date DATETIME,
	close_date DATETIME,
	description VARCHAR(200),
	user_id INT(11) UNSIGNED NOT NULL,
	employee_id INT(11) UNSIGNED NOT NULL,
	CONSTRAINT fk_reports_categories FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT fk_reports_status FOREIGN KEY (status_id) REFERENCES `status`(id),
	CONSTRAINT fk_reports_users FOREIGN KEY (user_id) REFERENCES `users`(id),		
	CONSTRAINT fk_reports_employees FOREIGN KEY (employee_id) REFERENCES `employees`(id)		
);

-- Section 2. DML (10 pts) ------------------------
-- 2.	Insert --------------------------------------

INSERT INTO employees(first_name, last_name, gender, birthdate, department_id)
VALUES
('Marlo', 'O\'Malley', 'M', '1958-09-21',	1),
('Niki',	'Stanaghan',	'F', '1969-11-26',	4),
('Ayrton',	'Senna',	'M',	'1960-02-21', 	9),
('Ronnie',	'Peterson',	'M',	'1944-02-14',	9),
('Giovanna',	'Amati',	'F', '1959-07-20',	5);

INSERT INTO reports(category_id, status_id, open_date,	close_date,	description, user_id, employee_id)
VALUES
(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05',	'2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03',	'2017-07-06', 'Cut off streetlight on Str.11', 1, 1);

-- 3.	Update ---------------------------------------

UPDATE reports AS r
SET r.status_id = 2
WHERE r.status_id = 1 AND r.category_id = 4;

-- 4.	Delete --

DELETE FROM reports AS r
WHERE r.status_id = 4;

-- Section 3. Querying (40 pts) --------------------
-- 5.	Users by Age ---------------------------------

SELECT u.username, u.age
FROM users AS u
ORDER BY u.age ASC, u.username DESC;

-- 6.	Unassigned Reports ---------------------------

SELECT r.description, r.open_date
FROM reports AS r
WHERE r.employee_id IS NULL
ORDER BY r.open_date ASC, r.description;

-- 7.	Employees & Reports --------------------------

SELECT e.first_name, e.last_name, r.description, DATE_FORMAT(r.open_date, "%Y-%m-%d")
FROM employees AS e
INNER JOIN reports AS r
ON r.employee_id = e.id 
WHERE r.employee_id IS NOT NULL
ORDER BY r.employee_id, r.open_date, r.id;

-- 8.	Most reported Category -----------------------

SELECT c.name, COUNT(r.id) AS reports_number
FROM categories AS c
JOIN reports AS r
ON r.category_id = c.id
GROUP BY c.name
ORDER BY reports_number ASC, c.name ASC

-- 9.	Employees in Category ------------------------

SELECT c.name, COUNT(e.id) AS employees_number
FROM categories AS c
JOIN departments AS d ON d.id = c.department_id
JOIN employees AS e ON d.id = e.department_id
GROUP BY c.name
ORDER BY c.name ASC

-- 10.	Birthday Report ---------------------------

SELECT DISTINCT c.name
FROM categories AS c
JOIN reports AS r ON r.category_id = c.id
JOIN users AS u ON r.user_id = u.id
WHERE MONTH(r.open_date) = MONTH(u.birthdate) AND DAY(r.open_date) = DAY(u.birthdate)
ORDER BY c.name ASC

-- 11.	Users per Employee ------------------------

SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, COUNT(r.user_id) AS users_count
FROM employees AS e
JOIN reports AS r ON e.id = r.employee_id
JOIN users AS u ON r.user_id = u.id
GROUP BY u.id
ORDER BY users_count DESC, name ASC

-- 
















