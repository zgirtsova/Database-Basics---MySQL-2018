USE exam;

/*
CREATE TABLE users (
 id INT(11) AUTO_INCREMENT ,
 username VARCHAR(30) UNIQUE NOT NULL,
 `password` VARCHAR(30) NOT NULL,
 email VARCHAR(50) NOT NULL,
 CONSTRAINT PK_users PRIMARY KEY(id)
);

CREATE TABLE repositories (
 id INT(11) AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL,
 CONSTRAINT PK_repositories PRIMARY KEY(id)
);

CREATE TABLE repositories_contributors (
 repository_id INT(11),
 contributor_id INT(11),
 CONSTRAINT PK_repositories_contributors PRIMARY KEY(repository_id, contributor_id),
 CONSTRAINT FK_rep_con_repositories FOREIGN KEY(repository_id) REFERENCES repositories(id),
 CONSTRAINT FK_rep_con_contributors FOREIGN KEY(contributor_id) REFERENCES users(id)
);

CREATE TABLE issues (
 id INT(11) AUTO_INCREMENT,
 title VARCHAR(255) NOT NULL,
 issue_status VARCHAR(6) NOT NULL,
 repository_id INT(11) NOT NULL,
 assignee_id INT(11) NOT NULL,
 CONSTRAINT PK_issues PRIMARY KEY(id),
 CONSTRAINT FK_issues_repositories FOREIGN KEY(repository_id) REFERENCES repositories(id),
 CONSTRAINT FK_issues_users FOREIGN KEY(assignee_id) REFERENCES users(id)
);

CREATE TABLE commits (
 id INT(11) AUTO_INCREMENT,
 message VARCHAR(255) NOT NULL,
 issue_id INT(11),
 repository_id INT(11) NOT NULL,
 contributor_id INT(11) NOT NULL,
 CONSTRAINT PK_commits PRIMARY KEY(id),
 CONSTRAINT FK_commits_issues FOREIGN KEY(issue_id) REFERENCES issues(id),
 CONSTRAINT FK_commits_repositories FOREIGN KEY(repository_id) REFERENCES repositories(id),
 CONSTRAINT FK_commits_users FOREIGN KEY(contributor_id) REFERENCES users(id)
);

CREATE TABLE files (
 id INT(11) AUTO_INCREMENT,
 name VARCHAR(100) NOT NULL,
 size DECIMAL(10,2) NOT NULL,
 parent_id INT(11),
 commit_id INT(11) NOT NULL,
 CONSTRAINT PK_files PRIMARY KEY(id),
 CONSTRAINT FK_files_files FOREIGN KEY(parent_id) REFERENCES files(id),
 CONSTRAINT FK_files_commits FOREIGN KEY(commit_id) REFERENCES commits(id)
);
 
 */
--  2. Insert -------------------
INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT CONCAT('Critical Problem With', ' ', f.name,'!'),
'open',
CEIL((f.id*2)/3),
c.contributor_id
from files as f
INNER JOIN commits AS c
ON f.commit_id = c.id
where f.id between 46 and 50;

-- 3. Update----------------------------

UPDATE
repositories_contributors AS rc
SET rc.repository_id = 
	(SELECT MIN(r.id) 
FROM repositories AS r
WHERE r.id NOT IN (SELECT c.repository_id FROM commits AS c))
WHERE rc.contributor_id = rc.repository_id;
 
 -- 4. Delete ---------------------------------
 
 delete FROM repositories
WHERE id NOT IN (SELECT i.repository_id
						FROM issues AS i);
						
-- Section 3: Querying – 100 pts ---------------------------
-- 5.----------------------
SELECT u.id, u.username
FROM users AS u
ORDER BY u.id ASC;

-- 6.-------------------------------

SELECT rc.repository_id, rc.contributor_id
FROM repositories_contributors AS rc
JOIN repositories AS r
ON rc.repository_id = r.id
WHERE rc.repository_id = rc.contributor_id
ORDER BY r.id ASC;

-- 7.--------------------------------

SELECT f.id, f.name, f.size
FROM files AS f
WHERE f.size > 1000 AND f.name LIKE '%html%'
ORDER BY f.size DESC;

-- 8.----------------------------------
SELECT i.id, CONCAT(u.username,' : ',i.title) AS issue_assignee
FROM issues AS i
JOIN users AS u
ON i.assignee_id = u.id
ORDER BY i.id DESC;

-- 9.----------------------------------
SELECT f1.id, f1.name, CONCAT(f1.size,'KB') AS size
FROM files AS f1
LEFT OUTER JOIN files AS f2
ON f1.id = f2.parent_id
WHERE f2.id IS NULL
ORDER BY f1.id ASC;

-- 10.--------------------------------
SELECT r.id, r.name, COUNT(i.title) AS 'issues'
FROM repositories AS r
LEFT JOIN issues AS i
ON r.id = i.repository_id
GROUP BY r.id
ORDER BY `issues` DESC, r.id ASC
LIMIT 5;

-- 11.------------------------------- 120 pts

SELECT res.id, res.name, COUNT(c.id) AS 'commits', res.cnt AS 'contributors'
FROM
(SELECT r.id, r.name, COUNT(rc.contributor_id) AS cnt
FROM repositories_contributors AS rc
JOIN repositories AS r
ON rc.repository_id = r.id
GROUP BY r.id
order by cnt DESC
) AS res
LEFT JOIN commits AS c
ON res.id = c.repository_id
GROUP BY res.id
order by res.cnt DESC, res.id ASC
LIMIT 1;

-- 12. ------------------------------- 000

SELECT u.id, u.username, COUNT(c.id)
FROM users AS u
JOIN commits AS c
ON u.id = c.contributor_id
WHERE u.id IN (SELECT i.assignee_id
					FROM issues AS i
					JOIN users As u
					ON i.assignee_id = u.id)	
GROUP BY u.id

13.---------------------------------

SELECT f1.id, SUBSTRING_INDEX(f1.name,'.',1) AS 'file'
FROM files AS f1
JOIN files AS f2
ON f1.parent_id = f2.id
WHERE f1.id = f2.parent_id AND f2.id = f1.parent_id



-- 14.----------------------------------------
SELECT r.id, r.name, COUNT(DISTINCT c.contributor_id) AS `users`
FROM repositories AS r
LEFT JOIN commits AS c
ON r.id = c.repository_id
GROUP BY r.id
ORDER BY `users` DESC, r.id ASC

-- Section 4: Programmability – 30 pts --------
-- 15.	Commit--------------------------------

DELIMITER $$

CREATE PROCEDURE `udp_commit` (`username` VARCHAR(30), `password` VARCHAR(30), `message` VARCHAR(255), `issue_id` INT(11))
BEGIN
	START TRANSACTION;
	
		IF
			`username` NOT IN (SELECT u.username FROM `users` AS u)
		THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such User!';
			ROLLBACK;
		ELSEIF
			`password` != (SELECT u.password FROM `users` AS u WHERE u.username = `username`)
		THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
			ROLLBACK;
		ELSEIF
			`issue_id` NOT IN (SELECT i.id FROM `issues` AS i)
		THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The issue thas not exists!';
			ROLLBACK;
		ELSE
					INSERT INTO `commits` (`message`, `issue_id`, `repository_id`, `contributor_id`)
					VALUES(`message`, 
						 `issue_id`, 
						 (SELECT i.repository_id FROM issues AS i WHERE i.id = `issue_id`),
						 (SELECT u.id FROM users AS u WHERE u.username = `username`)
					);
				
					UPDATE issues AS i
					SET i.issue_status = 'closed'
					WHERE i.id = `issue_id`;
			COMMIT;
		END IF;
END $$

DELIMITER ;

-- 16.--------------------------------------------------
CREATE PROCEDURE `udp_findbyextension` (`extension` VARCHAR(30))
BEGIN
	SELECT f.id, f.name AS caption, CONCAT(f.size,'KB') AS `user`
	FROM files AS f
	WHERE SUBSTRING_INDEX(f.name,'.',-1) = `extension`
	ORDER BY f.id ASC;
END $$

DELIMITER ;














 
 
 
 
 
 
 
 
 
 
 
 
 
 
 