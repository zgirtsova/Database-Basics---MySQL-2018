-- LAB - TABLE RELATIONS --
-- 1. Mountains and Peaks --

create table mountains (
`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE NOT NULL,
`name` varchar(50) 
);

create table peaks (
`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE NOT NULL,
`name` varchar(50),
`mountain_id` INT UNSIGNED UNIQUE NOT NULL,

CONSTRAINT fk_peaks_mountains 
FOREIGN KEY (mountain_id)
REFERENCES mountains(id)
);

-- 2. Books and Authors --

create table authors (
`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE NOT NULL,
`name` varchar(50) 
);

create table books (
`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE NOT NULL,
`name` varchar(50),
`author_id` INT UNSIGNED NOT NULL,

CONSTRAINT fk_books_authors 
FOREIGN KEY (author_id)
REFERENCES `authors`(id)
ON UPDATE CASCADE
ON DELETE CASCADE
);

-- 3. Trip Organization --

USE camp;

SELECT v.driver_id, v.vehicle_type, CONCAT(c.first_name, ' ', c.last_name) AS driver_name
FROM campers AS c
JOIN vehicles AS v
ON v.driver_id = c.id;

-- 4. SoftUni Hiking -- 

USE camp;

SELECT r.starting_point, r.end_point, r.leader_id, CONCAT(c.first_name, ' ', c.last_name)
FROM routes AS r
JOIN campers AS c
ON r.leader_id = c.id;

-- 5. Project Management DB --

CREATE TABLE projects (
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
client_id INT(11)  UNSIGNED NOT NULL,
project_lead_id INT(11)  UNSIGNED NOT NULL
);

CREATE TABLE clients (
id INT(11) UNSIGNED NOT NULL UNIQUE PRIMARY KEY,
client_name VARCHAR(100),
project_id INT(11) UNSIGNED NOT NULL,
CONSTRAINT fk_projects_clients
FOREIGN KEY (project_id)
REFERENCES projects(id)
);

CREATE TABLE employees (
id INT(11) UNSIGNED NOT NULL UNIQUE PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT(11) UNSIGNED NOT NULL,
CONSTRAINT fk_projects_employees
FOREIGN KEY (project_id)
REFERENCES projects(id)
);

ALTER TABLE projects 
ADD 
CONSTRAINT fk_projects_clients_id
FOREIGN KEY (client_id)
REFERENCES clients(id),
ADD
CONSTRAINT fk_projects_lead 
FOREIGN KEY (project_lead_id)
REFERENCES employees(id)
;

