-- CREATING TABLE
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20)
);
DESCRIBE student;
DROP TABLE student;
ALTER TABLE student ADD gpa DECIMAL(3,2);
ALTER TABLE student DROP COLUMN gpa;


-- INSERTING DATA
SELECT * FROM student;
INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Sociology');
INSERT INTO student(student_id, name, major) VALUES(3, 'Claire', 'Chemistry');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');


-- CONSTRAINTS
SELECT * FROM student;
DROP TABLE student;
CREATE TABLE student (
    student_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    major VARCHAR(20) UNIQUE DEFAULT 'undecided',
    PRIMARY KEY(student_id)
);
INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Kate', 'Sociology');


-- UPDATE AND DELETE
SELECT * FROM student;
UPDATE student
SET major = 'Biochemistry'
WHERE major = 'Biology' OR major = 'Chemistry';
UPDATE student
SET name = 'Tom', major = 'undecided'
WHERE student_id = 1;
DELETE FROM student
WHERE name = 'Tom' AND student_id = 5;


-- BASIC QUERIES
SELECT name, student.major
FROM student;
SELECT *
FROM student
ORDER BY student_id DESC -- DESCENDING ORDER
LIMIT 2; -- AMOUNT OF RESULTS
SELECT *
FROM student
WHERE major <> 'Chemistry' OR name = 'Kate';
SELECT *
FROM student
WHERE name IN ('Claire', 'Kate', 'Mike');


-- CREATE COMPANY DATABASE
DROP TABLE student;
CREATE TABLE employee (
	emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);
CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;
ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;
CREATE TABLE client (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);
CREATE TABLE works_with (
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);
CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Example
-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL); -- THE BRANCH IS NOT CREATED YET, SO SET branch_id TO NULL
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100; -- UPDATE THE MANAGER TO THE BRANCH
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);
INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');
UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);
INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');
UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SELECT * FROM employee;
SELECT * FROM works_with;


-- MORE BASIC QUERIES
SELECT first_name AS forename, last_name AS surname
FROM employee;
SELECT DISTINCT sex -- FIND ALL DIFFERENT VALUES
FROM employee;


-- FUNCTIONS
SELECT COUNT(emp_id) -- COUNT
FROM employee
WHERE sex = 'F' AND birth_date > '1970-01-01';
SELECT AVG(salary) -- AVERAGE
FROM employee
WHERE SEX = 'M';
SELECT SUM(salary) -- SUM
FROM employee;
SELECT COUNT(sex), sex -- AGGREGATION
FROM employee
GROUP BY sex;
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;


-- WILDCARDS (% = any # of characters, _ = one character)
SELECT *
FROM client
WHERE client_name LIKE '%LLC';
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%Label%';
SELECT *
FROM employee
WHERE birth_date LIKE '____-10%';
SELECT *
FROM client
WHERE client_name LIKE '%school%';


-- UNION (same # of columns and similar datatypes)
SELECT first_name AS Company_Names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;


-- JOIN (combine row from tables based on the related column)
INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);
SELECT * FROM branch;
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee -- LEFT TABLE
JOIN branch -- (INNER) JOIN / LEFT JOIN / RIGHT JOIN
ON employee.emp_id = branch.mgr_id; -- tell the name of the manager of each branch


-- NESTED QUERIES
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
	SELECT works_with.emp_id
	FROM works_with
	WHERE works_with.total_sales > 30000
);
SELECT client.client_name
FROM client
WHERE client.branch_id = (
	SELECT branch.branch_id
	FROM branch
	WHERE branch.mgr_id = 102
    LIMIT 1 -- return only one value
);


-- ON DELETE (Foreign key: ON DELETE SET NULL; Primary key: ON DELETE CASCADE)
CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
); -- if emp_id is deleted, set mgr_id to NULL
DELETE FROM employee
WHERE emp_id = 102;
SELECT * FROM branch;
SELECT * FROM employee; -- super_id also had ON DELETE SET NULL

CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
); -- if branch_id is deleted, delete the entire row
DELETE FROM branch
WHERE branch_id = 2;
SELECT * FROM branch_supplier;


-- TRIGGERS (define a certain action that should happen when a certain operation is performed)
CREATE TABLE trigger_test (
	message VARCHAR(100)
);
-- Paste this trigger in the Command Line Client
/*
DELIMITER $$ -- Change the delimiter from ; to $$
CREATE
	TRIGGER my_trigger2 BEFORE INSERT -- OR AFTER, DELETE
    ON employee
    FOR EACH ROW BEGIN
		IF NEW.sex = 'M' THEN
			INSERT INTO trigger_test VALUES('added male employee');
		ELSEIF NEW.sex = 'F' THEN
			INSERT INTO trigger_test VALUES('added female');
		ELSE
			INSERT INTO trigger_test VALUES('added other employee');
		END IF;
	END$$
CREATE   TRIGGER my_trigger BEFORE INSERT    ON employee FOR EACH ROW BEGIN	  INSERT INTO trigger_test VALUES('added new employee');END$$
CREATE   TRIGGER my_trigger1 BEFORE INSERT    ON employee    FOR EACH ROW BEGIN   INSERT INTO trigger_test VALUES(NEW.first_name);END$$

DELIMITER ; -- Change the delimiter from $$ to ; 
DROP TRIGGER my_trigger
*/
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);
INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);
SELECT * FROM trigger_test;
DROP TABLE trigger_test;
DELETE FROM employee
WHERE emp_id >= 109;


-- ER Diagrams Intro
/*
Entity - An object we want to model & store information about (Square)
Attributes - Specific pieces of information about an entity (Oval)
Primary Key - An attribute(s) that uniquely identify an entry in the database table (Underline)
Composite Attribute - An attribute that can be broken up into sub-attributes
Multi-valued Attribute - An attribute that can have more than one value (Extra oval)
Derived Attribute - An attribute that can be derived from the other attributes (Oval with dashed lines)
Multiple Entities - You can define more than one entity in the diagram
Relationships - Defines a relationship between two entities (Diamond)
Total Participation - All members must participate in the relationship (Double line)
Partial Participation - (Single line)
Relationship Attribute - An attribute about the relationship
Relationship Cardinality - The number of instances of an entity from a relation that can be associated with the relation
Weak Entity - An entity that cannot be uniquely identified by its attributes alone (Double square)
Identifying Relationship - A relationship that serves to uniquely identify the weak entity (Double diamond)
*/


-- Designing an ER Diagram
/*
Map out all the different Entities, all the different Attributes on the Entities and all the different Relationships
*/


-- Converting ER Diagrams to Schemas
/*
Step 1 - Mapping of Regular Entity Types
	For each regular entity type create a relation (table) that includes all the simple attributes of that entity

Step 2 - Mapping of Weak Entity Types
	For each regular entity type create a relation (table) that includes all the simple attributes of the weak entity
    The primary key of the new relation should be the partial key of the weak entity plus the primary key of its owner

Step 3 - Mapping of Binary 1:1 Relationship Types
	Include one side of the relationship as a foreign key in the other Favor total participation

Step 4 - Mapping of Binary 1:N Relationship Types
	Include the 1 side's primary key as a foreign key on the N side relation (table)

Step 5 - Mapping of Binary M:N Relationship Types
	Create a new relation (table) who's primary key is a combination of both entities' primary keys
    Also include any relationship attributes
*/

