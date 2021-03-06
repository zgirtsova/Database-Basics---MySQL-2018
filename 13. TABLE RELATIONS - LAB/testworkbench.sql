CREATE DATABASE cars;
USE cars;
CREATE TABLE driver (
id INT(11) unsigned NOT NULL UNIQUE PRIMARY KEY,
name VARCHAR(50) UNIQUE
);

CREATE TABLE car (
id INT(11) unsigned NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
driver_id  INT(11) unsigned NOT NULL UNIQUE,

CONSTRAINT fk_car_driver 
FOREIGN KEY (driver_id) 
REFERENCES driver(id)
ON UPDATE CASCADE
);