-- This example has been made following the video tutorial in this link: https://www.youtube.com/watch?v=HXV3zeQKqGY
-- This example sheet is compiled by Mohamed Kwaik
-- Welcome to Exam Prep Cheat Sheet 1. This will cover only the most basic foundations of SQL. 
-- See "Exam Prep Cheat Sheet 2 (COMPLEX)" for more advanced examples with Functions, wildcards, Unions, Jions, Nested Queries, Deleted, Triggers, ETC.

-- This contains basic examples with creation of tables, deleting entries, inserting entries, updating entries, select, etc.

CREATE DATABASE exam_test_example1; -- To create a database/schema.

USE exam_test_example1; -- Highlight and select a schema/database for the program to focus on.

-- Datatypes:
-- INT         			Whole numbers.
-- DECIMAL(M, N)        Decimal Numbers - Exact Value. Where M is the total number of digits in the whole number, N is the amount of digits AFTER the decimal point.
-- Varchar(45)       	String of text of length 45.
-- BLOB					Very large object, Stores large data. (BLOB - Binary Larger Object).
-- DATE					'YYYY-MM-DD'.
-- TIMESTAMP			'YYYY-MM-DD HH:MM:SS'.



-- -----------------------------------------------------------------------------
-- Example 1 General table commands and insertion commands and types
DROP TABLE IF EXISTS student; -- Deletes or drops a table if it already exists.
CREATE TABLE student( -- Creates a table with the name "student".
	student_id INT, -- Creates a column with primary keys and datatype INT with the name student_id.
    student_name VARCHAR(40), -- Creates a column with datatype varchar that can contain 40 characters with the name student_name.
	student_major VARCHAR(20), -- Creates a column with datatype varchar that can contain 20 characters with the name student_major.
    PRIMARY KEY(student_id)
); -- Dont forget sermi colons at the end of every line***


INSERT INTO student VALUES(1, 'Jack', 'Biology'); -- Adds or inserts a row of data into the table. Make sure to follow the order of the table. These instances: ID - Name - Major
INSERT INTO student(student_id, student_name, student_major) VALUES(2, 'Kate', 'Sociology'); 
INSERT INTO student(student_id, student_name) VALUES(3, 'Claire');-- In case you want to use a specific order or only add data in specific colomns, specify it in the command like so.
INSERT INTO student VALUES(4, 'Jack', 'Biology'), (5, 'Mike', 'Computer Science'); -- In case you want to add multiple rows of data
SELECT * FROM student; -- Shows all data from table "student" DUPE (Added for ease of access)

-- Table commands
SELECT * FROM student; -- Shows all data from table "student"
DESCRIBE student; -- Describes the table
DROP TABLE student; -- deletes or "drops" the table
ALTER TABLE student ADD gpa DECIMAL(3, 2); -- edits the table and adds another column.
ALTER TABLE student DROP COLUMN gpa; -- edits the table and drops/deletes a specific column.


-- -----------------------------------------------------------------------------
-- Example 2 NOT NULL and UNIQUE Constraints
DROP TABLE IF EXISTS student;
CREATE TABLE student( -- Creates a table with the name "student". This is example 2, but this time with constraints!
	student_id INT,
    student_name VARCHAR(40) NOT NULL, -- NOT NULL (This means that this column HAS to have data, if not, insertion will fail)
	student_major VARCHAR(20) UNIQUE, -- UNIQUE (This means that the data given has to be different from other entries, if not, insertion WILL fail)
    PRIMARY KEY(student_id)
);

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Sociology'); 
INSERT INTO student VALUES(3, 'Claire', 'Chemistry'); -- This Here will work fine because she has a name
INSERT INTO student VALUES(3, Null, 'Chemistry'); -- This wont work and WILL fail because we have set the student_name column to NOT NULL, this HAS to have data.
INSERT INTO student VALUES(4, 'Jack', 'Math'); -- This will work fine because he has a unique major
INSERT INTO student VALUES(4, 'Jack', 'Biology'); -- This wont work and WILL fail because we have set the student_major column to UNIQUE, we already have someone with this major. this HAS to be unique
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');
SELECT * FROM student;
-- Quick confirmation, it checks our and works fine.

-- Example 3 DEFAULT and AUTO_INCREMENT constraints
DROP TABLE IF EXISTS student;
CREATE TABLE student( -- Creates a table with the name "student". This is example 3, but this time with even more constraints!
	student_id INT AUTO_INCREMENT,
    student_name VARCHAR(40),
	student_major VARCHAR(20) DEFAULT 'UNDECIDED', -- The default constraint will add a default value if no data is given in the insert command or data is NULL.
    PRIMARY KEY(student_id)
);

INSERT INTO student(student_id, student_name) VALUES(1, 'Jack'); -- In this entry we have purposefully left out the major to test if our constraint (DEFAULT 'UNDECIDED') will work. PS. It will.
INSERT INTO student(student_name, student_major) VALUES('Kate', 'Sociology'); -- In this istance we left out the id to test if our constraint (AUTO_INCREMENT) will work. It will. :) 
-- actually... all the instances below are going to be like that now.
INSERT INTO student(student_name, student_major) VALUES('Claire', 'Chemistry');
INSERT INTO student(student_name, student_major) VALUES('Jack', 'Math');
INSERT INTO student(student_name, student_major) VALUES('Mike', 'Computer Science'); 
SELECT * FROM student;
-- Quick confirmation, it checks our and works fine.

-- ----------------------------------------------------------------------------- 
-- Example 4 Update And Delete
DROP TABLE IF EXISTS student;
CREATE TABLE student( -- Creates a table with the name "student". This is example 4! Updates And Delete
	student_id INT,
    student_name VARCHAR(40),
	student_major VARCHAR(20),
    PRIMARY KEY(student_id)
);

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Sociology');
INSERT INTO student VALUES(3, 'Claire', 'Chemistry');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science'); 
SELECT * FROM student;

-- Update statement
UPDATE student SET student_major = 'Bio' WHERE student_major = 'Biology'; -- This is the update command, this updates the "major" columns that contain the string "Biologi" and changes them to "Bio".
UPDATE student SET student_major = 'Comp Sci' WHERE student_id = 4; -- Same thing but with the student ID. here we change the major for the student with ID 5.
UPDATE student SET student_major = 'Biochemistry' WHERE student_major = 'Bio' OR student_major = 'Chemistry'; -- This is an advanced update that changes any student with the major bio or chemistry to this major "Biochemistry".
UPDATE student SET student_name = 'Tom', student_major = 'UNDECIDED' WHERE student_id = 1; -- here we update multiple columns at the same time. In this instance, we change the name and major for the student with ID number 1.
UPDATE student SET student_major = 'UNDECIDED'; -- BE WARNED, this will change the data in the specified comlumn to new data. Be very careful with this!!!

-- Delete statement
DELETE FROM student; -- This deletes everything from the table BE FUCKING CAREFUL WITH THIS ONE TOO!!!!
DELETE FROM student Where student_id = 5; -- this deletes rows with the student id 5
DELETE FROM student Where name = 'Tom' AND major = 'UNDECIDED'; -- this is a more specific version in case you dont know an ID where the row with the name Tom and major UNDECIDED will be delted.

-- Comparison Operators:
-- = 	: EQUALS
-- <> 	: NOT EQUALS 
-- >	: GREATER THAN
-- <	: LESS THAN
-- >=	: GREATER THAN OR EQUAL
-- <=	: LESS THAN OR EQUAL

-- Quick confirmation, it checks our and works fine.


-- -----------------------------------------------------------------------------
-- Example 5 Simple Queries (Selects and such)
DROP TABLE IF EXISTS student;
CREATE TABLE student( -- Creates a table with the name "student". This is example 4! Updates And Delete
	student_id INT,
    student_name VARCHAR(40),
	student_major VARCHAR(20),
    PRIMARY KEY(student_id)
);

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Sociology');
INSERT INTO student VALUES(3, 'Claire', 'Chemistry');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science'); 
-- Nice to have  a fresh table with fresh data entries. :D


SELECT * FROM student; -- Shows all rows and columns from the table
SELECT student_name FROM student; -- Shows all rows from selected column from the table
SELECT student_name, student_major FROM student; -- Shows all rows from multiple selected columns from the table
SELECT student.student_name, student.student_major FROM student; -- Shows all rows from multiple selected columns from the table with a specified table. important if you have similar names on different tables!
SELECT * FROM student ORDER BY student_id; -- Order by, shows the selected data ordered by "student_id" or a specified column. ASCENDING by default.
SELECT * FROM student ORDER BY student_id ASC; -- It is unnecessary but you can write ASC or "Ascending" to clarify the order you want!
SELECT * FROM student ORDER BY student_id DESC; -- Same thing but with Descednding! by writing DESC at the end of selected "order by" column.
SELECT * FROM student ORDER BY student_major, student_id; -- You can also order by multiple columns in both ascending and descending order!
SELECT * FROM student LIMIT 2; -- This will just show you limited results. only 2 results or "rows" will be shown!
SELECT * FROM student ORDER BY student_id DESC LIMIT 2; -- You can also mix the limit with other things like order by.
SELECT * FROM student WHERE student_major = 'Biochemistry'; -- You can use "where" here to limit your results to specific data entries. so lets say that you want to see all the students with a major in biochemistry, this query will do so.

-- Comparison Operators: Always nice to know, so i pasted it here again. ;)
-- = 	: EQUALS
-- <> 	: NOT EQUALS 
-- >	: GREATER THAN
-- <	: LESS THAN
-- >=	: GREATER THAN OR EQUAL
-- <=	: LESS THAN OR EQUAL

-- Here is a nice example to show you what you can do with comparison ops, its not needed but why not. I like wasting time.
SELECT * FROM student WHERE student_major <> 'UNDECIDED'; -- this one will exclude a specified data entry. we used the <> "NOT EQUALS" operator with a where.
SELECT * FROM student WHERE student_id <= 3 AND student_name <> 'Jack'; -- this one will exclude multiple specified data entries.

-- IN?
select * FROM student WHERE student_name IN ('Tom', 'Kate', 'Mike'); -- This will only show entries matching the selected group of values written inbetween the parenthesis.
-- It can be used with other things and conditions like so:
SELECT * FROM student WHERE student_name IN ('Tom', 'Kate', 'Mike') AND student_id > 1; -- An example in which we use IN with other conditions.

-- The end of part 1.
-- This sheet only covers the most basic of SQL commands and queries.
-- See "Exam Prep Cheat Sheet 2 (COMPLEX)" for the next set of cheat sheets. This will have more and complex things surrounding MySQL.


