-- Lab: Built-in Functions --
-- 1. Find Book Titles --

USE `book_library`;

SELECT `title`
FROM `books`
WHERE SUBSTR(`title`, 1, 3) = 'THE';

-- 2. Replace Titles --

USE `book_library`;

UPDATE `books`
SET `title` = REPLACE(`title`, 'The', '***')
WHERE SUBSTR(`title`, 1, 3) = 'The';

SELECT `title`
FROM `books`
WHERE SUBSTR(`title`, 1, 3) = '***';

-- 3. Sum Cost of All Books --

USE `book_library`;

SELECT ROUND(SUM(`cost`), 2)
FROM `books`;

-- 4. Days Lived -- 

USE `book_library`;

SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name', 
		 TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days Lived'
FROM `authors`;

-- 5. Harry Potter Books --

USE `book_library`;

SELECT `title`
FROM `books`
WHERE `title` LIKE 'Harry Potter%';