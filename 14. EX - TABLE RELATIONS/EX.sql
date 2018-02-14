-- Exercises: Table Relations --
-- 1. One-To- One Relationship --

CREATE TABLE persons(
    person_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    salary DECIMAL(10 , 2),
    passport_id INT UNIQUE NOT NULL,
    CONSTRAINT pk_persons 
	 PRIMARY KEY (person_id)    
);
CREATE TABLE passports(
  passport_id INT NOT NULL,
  passport_number VARCHAR(8),
  CONSTRAINT pk_passports 
  PRIMARY KEY (passport_id)
);

ALTER TABLE persons 
ADD CONSTRAINT fk_persons_passports
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);

INSERT INTO passports 
VALUES (101,'N34FG21B'), 
		 (102,'K65LO4R7'), 
		 (103,'ZE657QP2');
INSERT INTO persons 
VALUES(1, 'Roberto', 43300, 102), 
		(2, 'Tom', 56100, 103), 
		(3,'Yana',60200,101);

-- 2. One-To- Many Relationship --

CREATE TABLE manufacturers(
  manufacturer_id INT,
  name varchar(5),
  established_on datetime,
  PRIMARY KEY(manufacturer_id)
);
INSERT INTO manufacturers 
VALUES(1, 'BMW', '1916-03-01'), 
		(2, 'Tesla', '2003-01-01'), 
		(3,'Lada','1966-05-01');

CREATE TABLE models(
   model_id INT NOT NULL,
	name varchar(20),
	manufacturer_id INT,
	PRIMARY KEY(model_id),
	FOREIGN KEY (manufacturer_id) 
	REFERENCES manufacturers(manufacturer_id)	
);
INSERT INTO models 
VALUES (101, 'X1', 1), 
		 (102, 'i6', 1),
		 (103, 'Model S', 2), 
		 (104, 'Model X', 2),
		 (105, 'Model 3', 2),
		 (106, 'Nova', 3);
		 
-- 3. Many-To- Many Relationship --

CREATE TABLE students(
  student_id INT NOT NULL,
  name varchar(20),
  CONSTRAINT `pk_students` 
  PRIMARY KEY (`student_id`) 
);

CREATE TABLE exams(
  exam_id INT NOT NULL,
  name varchar(20),
  CONSTRAINT `pk_exams` 
  PRIMARY KEY (`exam_id`)
);

CREATE TABLE students_exams(
   student_id INT NOT NULL,
	exam_id INT NOT NULL,
	CONSTRAINT pk_students_exams 
	PRIMARY KEY(student_id, exam_id),
	
	CONSTRAINT fk_students 
	FOREIGN KEY (student_id) 
	REFERENCES students(student_id),
	
	CONSTRAINT fk_exam 
	FOREIGN KEY(exam_id) 
	REFERENCES exams(exam_id)	
);

INSERT INTO students(name, student_id) 
VALUES('Mila',1),('Toni',2),('Ron',3);
INSERT INTO exams(name,exam_id) 
VALUES('Spring MVC',101),('Neo4j',102),('Oracle 11g',103);
INSERT INTO students_exams(student_id,exam_id) 
VALUES(1,101),(1,102),(2,101),(3,103),(2,102),(2,103);

-- 4. Self-Referencing --

CREATE TABLE teachers(
    teacher_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    manager_id INT,
    CONSTRAINT pk_teacher_id 
	 PRIMARY KEY (teacher_id),
	 
    CONSTRAINT fk_teachers_teachers 
	 FOREIGN KEY (manager_id) 
	 REFERENCES teachers (teacher_id) 
);

INSERT INTO teachers 
	VALUES (101, 'John', NULL), 
			 (105, 'Mark', 101), 
			 (106, 'Greta', 101),
			 (102, 'Maya', 106), 
			 (103, 'Silvia', 106), 
			 (104, 'Ted', 105);
			 
-- 5. Online Store Database --

CREATE TABLE cities (
  city_id INT(11),
  name VARCHAR(50),
  CONSTRAINT pk_cities 
  PRIMARY KEY (city_id)
);

CREATE TABLE customers (
  customer_id INT(11),
  name VARCHAR(50),
  birthday DATE,
  city_id INT(11),
  CONSTRAINT pk_customers 
  PRIMARY KEY (customer_id),
  
  CONSTRAINT fk_customers_cities 
  FOREIGN KEY (city_id) 
  REFERENCES cities(city_id) 
);

CREATE TABLE orders(
  order_id INT(11),  
  customer_id INT(11),
  CONSTRAINT pk_orders 
  PRIMARY KEY(order_id),
  CONSTRAINT fk_orders_customers 
  FOREIGN KEY(customer_id) 
  REFERENCES customers (customer_id) 
);

CREATE TABLE item_types(
   item_type_id INT(11),
   name VARCHAR(50),
   CONSTRAINT pk_item_types 
	PRIMARY KEY (item_type_id)
);

CREATE TABLE items(
  item_id INT(11),
  name VARCHAR(50),
  item_type_id INT(11),
  CONSTRAINT pk_items 
  PRIMARY KEY (item_id),
  
  CONSTRAINT fk_items_item_types 
  FOREIGN KEY (item_type_id) 
  REFERENCES item_types(item_type_id)
);

CREATE TABLE order_items(
  order_id INT(11),
  item_id INT(11),
  CONSTRAINT pk_order_items 
  PRIMARY KEY (order_id, item_id),
  
  CONSTRAINT fk_order_items_orders 
  FOREIGN KEY(order_id) 
  REFERENCES orders(order_id),
  
  CONSTRAINT fk_order_items_items 
  FOREIGN KEY (item_id) 
  REFERENCES items(item_id)
);

-- 6. University Database --

CREATE DATABASE university;
USE univerity;

CREATE TABLE majors(
  major_id INT(11),
  name VARCHAR(50),
  CONSTRAINT pk_majors 
  PRIMARY KEY (major_id)
);
CREATE TABLE students(
  student_id INT(11),
  student_number VARCHAR(12),
  student_name VARCHAR(50),
  major_id INT(11),
  CONSTRAINT pk_students 
  PRIMARY KEY (student_id),
  
  CONSTRAINT fk_students_majors 
  FOREIGN KEY(major_id) 
  REFERENCES majors(major_id)
);

CREATE TABLE payments(
  payment_id INT(11),
  payment_date DATE,
  payment_amount DECIMAL(8,2),
  student_id INT(11),
  CONSTRAINT pk_payments 
  PRIMARY KEY (payment_id),
  
  CONSTRAINT fk_payments_students 
  FOREIGN KEY(student_id) 
  REFERENCES students(student_id)
);

CREATE TABLE subjects(
  subject_id INT(11),
  subject_name VARCHAR(50),
  CONSTRAINT pk_subjects 
  PRIMARY KEY(subject_id)
);

CREATE TABLE agenda(
   student_id INT(11),
   subject_id INT(11),
   CONSTRAINT pk_agenda 
	PRIMARY KEY (student_id, subject_id),
	
   CONSTRAINT fk_agenda_subjects 
	FOREIGN KEY (subject_id) 
	REFERENCES subjects(subject_id),
	
   CONSTRAINT fk_agenda_students 
	FOREIGN KEY (student_id) 
	REFERENCES students(student_id)
);

-- 7. SoftUni Design --
-- 8. Geography Design --
-- 9. Peaks in Rila -- 

SELECT m.mountain_range,p.peak_name, p.elevation AS peak_elevation 
FROM peaks AS p
JOIN mountains AS m
ON p.mountain_id = m.id
WHERE mountain_range = 'Rila'
ORDER BY peak_elevation DESC;