-- This example has been made following the video tutorial in this link: https://www.youtube.com/watch?v=HXV3zeQKqGY
-- This example sheet is compiled by Mohamed Kwaik
-- Welcome to Exam Prep Cheat Sheet 2. This will cover more advanced things on MySQL and SQL in general.
-- This contains advanced examples with Functions, wildcards, Unions, Joins, Nested Queries, On Delete, Triggers, ETC. Here we actually build a full and functional database and play with whatever MySQL has to offer.
-- To minimize comment clutter i have decided to stop commenting on previously mentioned or known examples. 
-- I also will stop commenting on repetetive examples and only mentioning important information to avoid clutter and misunderstanding.



-- To see how the tables look like and understand them, refer to "Company Database" picture. It will give you a quick overview on how the tables look like.

-- For this example we will be making and building on a whole database for a company.
CREATE DATABASE exam_test_example2; -- lets start by making a new database as the last one i reserved for the first part.
USE exam_test_example2;

-- Added these in case we need to reset a table to remake them or just delete them.
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS works_with;
DROP TABLE IF EXISTS branch_supplier;

-- Creating tables
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT, -- This is technically a foreign key. But we cannot add that in yet because we still havent technically entered this table yet. and it points to itself
  branch_id INT -- This is pretty much the same as above. we need to create more tables before we could refere to them. this points to another table that hasnt been created yet.
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT, -- An foreign key we CAN make. this points to the employee table which we have already created.
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL -- Here we create the foreign key, it points to employees table and more specifically to the employee ID.
); -- we have more types of ON DELETE (like Cascase and Set Null).  These will be talked about more later in the file. 

ALTER TABLE employee  -- Here we start to alter to employee table to set the keys we couldnt set to foreign keys.
ADD FOREIGN KEY(branch_id) -- here we set the branch_id
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee -- and here too. 
ADD FOREIGN KEY(super_id) -- here we set the super_id 
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE clients (
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
-- ----------------------------------------------------------------------------- ON DELETE AND ON UPDATE CONSTRAINT
-- Let's look at the ON UPDATE clause:
-- ON UPDATE RESTRICT : the default : if you try to update a employee id in table employee the engine will reject the operation if one entry in the whole database at least links on this the employee.
-- ON UPDATE NO ACTION : same as RESTRICT.
-- ON UPDATE CASCADE : the best one usually : if you update a employee id in a row of table employee the engine will update it accordingly on all entry rows referencing this employee (but no triggers activated on entry table, warning). The engine will track the changes for you, it's good.
-- ON UPDATE SET NULL : if you update a employee id in a row of table employee the engine will set related entry employee ids to NULL (should be available in entry employee id field). I cannot see any interesting thing to do with that on an update, but I may be wrong.
-- SUMMARY:
-- To summarize, RESTRICT will stop the SQL update request from running if there is a reference to the ID you are trying to update.
-- NO ACTION will go back to default which is usually RESTRICT.
-- CASCADE will update all references in the database to the new ID you updated the row with.
-- SET NULL will set all references in the database to null where the reference is stored. Lets say employee ID 102 in the "works with" table will be set to null if you update the relevant employee id 102 in the employee table. 


-- And now on the ON DELETE side:
-- ON DELETE RESTRICT : the default : if you try to delete a employee id in table employee the engine will reject the operation if one entry in the whole database at least links on this the employee.
-- ON DELETE NO ACTION : same as RESTRICT
-- ON DELETE CASCADE : dangerous : if you delete an employee in table employee the engine will delete as well the related or refering entries. This is dangerous but can be used to make automatic cleanups on secondary tables (but be careful when using it)
-- ON DELETE SET NULL : handful : if you delete an employee the related or refering entries will automatically have the relationship to NULL. Some IDs that also count as a primary key cannot be set to null, in this case you have to use cascade.
-- SUMMARY:
-- To summarize, RESTRICT will stop the SQL update request from running if there is a reference to the ID you are trying to delete.
-- NO ACTION will go back to default which is usually RESTRICT.
-- CASCADE will delete all refering rows in the database. BE CAREFUL WITH THAT. if you forexample use this on an employee table, you WILL delete the branches, all other employees, clients and etc that reference to that employee!!!!
-- SET NULL will set all references in the database to null where the reference is stored. Lets say employee ID 102 in the "works with" table will be set to null if you delete  the relevant employee id 102 in the employee table. 



-- ----------------------------------------------------------------------------- Here we start inserting entries into our tables
-- We need to add things in the proper order to make sure everything works as it should.
-- there will be things that will be left on NULL and that is on purpose. The database is connected together and there are many foreign keys and references. 
-- After the proper connections are made, we add the missing IDs and keys.

-- we start adding our supers and managers because everything else kind of refers and points to them. if we did it without doing this first, some if not most insertions will fail due to not pointing where they should.

-- and example is below.
-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL); -- We insert this first but leave out branch id. 
-- ^ Now we purposely left out the super id specifically on this entry because he is the boss. therefor  he has no one above him to supervise him.

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09'); -- now we add our branch that corresponds with the employee.

UPDATE employee -- THEN we add our branch id to the employee (which i shall refer to as "emp" to save space and time)
SET branch_id = 1 
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1); -- we then add the rest of the employees that work in that branch.

-- So if you have noticed, we first insert the manager or boss of the branch, we then insert the branch itself then add the branch id to the manager or leading emp then and finally add the rest of the emps to that branch.
-- We do that because we need to have the leading emp first as there is an ID in the branch insertion that requires him to exist. and so does the EMP, but since the branch doesnt exist yet, we set the branch ID to null.
-- After we make the branch, we update the leading emp with the new branch ID.
-- After all of that is done, we now have set up and acquired the branch ID and the leading EMP id.
-- with everything now set up, we can insert the rest of the employees on that branch that require both the manager (leading emp) and the branch id comfortably and easily.
-- now we do this to all other branches!

-- Scranton
-- here we do the same thing as above. except the super_id is now set to 100 because this emp answers to 100 and is supervised by 100.
-- this is why we set up emp number 100 first. 
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


-- after we set up all the branches and employees, now we can easily insert the rest of the data which relies on those 2 tables. 
-- everything after this point on refers and points to them.

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Labels', 'Custom Forms');

-- CLIENT
INSERT INTO clients VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO clients VALUES(401, 'Lackawana Country', 2);
INSERT INTO clients VALUES(402, 'FedEx', 3);
INSERT INTO clients VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO clients VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO clients VALUES(405, 'Times Newspaper', 3);
INSERT INTO clients VALUES(406, 'FedEx', 2);

-- WORKS_WITH BTW!!! we use tables like these to connect one or more entry to the other table entries.
INSERT INTO works_with VALUES(105, 400, 55000); 
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- ----------------------------------------------------------------------------- More basic queries! Basically a revision of sheet 1 but on a bigger scale!
-- Find all employees
SELECT *
FROM employee;

-- Find all clients
SELECT *
FROM clients;

-- Find all employees ordered by salary
-- Ascending (can also removed ASC as it is default)
SELECT * 
from employee
ORDER BY salary ASC;

-- Descending
SELECT * 
from employee 
ORDER BY salary DESC;


-- Find all employees ordered by sex then first name then last name
SELECT *
from employee
ORDER BY sex, first_name, last_name;

-- Find the first 5 employees in the table
SELECT *
from employee
LIMIT 5;

-- Find the first and last names of all employees
SELECT first_name, last_name
FROM employee;

-- Find the forename and surnames names of all employees
-- This will return the firstname and lastname column but will just change the column name itself. (first_name - forename, last_name - surname)
SELECT first_name AS forename, employee.last_name AS surname 
FROM employee;

-- Find out all the different genders 
SELECT DISTINCT sex
FROM employee;

-- Lets try it on branch ids instead (yes... its clear in the branch table but we will get it from employees for the sake of the example).
SELECT DISTINCT branch_id
FROM employee;


-- Find all male employees
SELECT *
FROM employee
WHERE sex = 'M';

-- Equal opportunity
SELECT *
FROM employee
WHERE sex = 'F';


-- Find all employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2;

-- Find all employee's id's and names who were born after 1969
SELECT emp_id, first_name, last_name
FROM employee
WHERE birth_day >= 1970-01-01;

-- Find all female employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2 AND sex = 'F';

-- Find all employees who are female & born after 1969 or who make over 80000
SELECT *
FROM employee
WHERE (birth_day >= '1970-01-01' AND sex = 'F') OR salary > 80000;

-- Find all employees born between 1970 and 1975
SELECT *
FROM employee
WHERE birth_day BETWEEN '1970-01-01' AND '1975-01-01';

-- Find all employees named Jim, Michael, Johnny or David
SELECT *
FROM employee
WHERE first_name IN ('Jim', 'Michael', 'Johnny', 'David');


-- ----------------------------------------------------------------------------- Functions with select!
-- Find the number of employees (this one excludes the boss himself)
SELECT COUNT(super_id)
FROM employee;

-- Find the number of employees (this one includes the boss)
SELECT COUNT(emp_id)
FROM employee;

-- Find out how many males and females there are -- Aggregation: see definition below
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex; 
-- An aggregate function performs a calculation on multiple values and returns a single value. For example, you can use the AVG() aggregate function that takes multiple numbers and returns the average value of the numbers.


-- Find the number of female employees born after 1970!
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';

-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee;

-- Find the sum of all employee's salaries
SELECT SUM(salary)
FROM employee;

-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Find the total amount of money spent by each client
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;


-- I can add more examples but use your imagination ;)




-- ----------------------------------------------------------------------------- Wild Cards
-- % = any nunber of characters 
-- _ = one character

-- Find any client's who are an LLC
SELECT *
FROM clients
WHERE client_name LIKE '%LLC'; -- So what this means is, MySQL will find a client that ends with "LLC". it will skip all characters (%) and if it reaches LLC, it will give you that row.

-- Find any branch suppliers who are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%'; -- This will look for a labels supplier. MySQL will find a supplier that has Label in it. it will skip characters then match with the word "Label" and skip anything after then show results.

-- Find any employee born on the 10th day of the month
SELECT *
FROM employee
WHERE birth_day LIKE '____-10%'; -- This will find an employee born on a specific month. the date data type works like this YYYY-MM-DD by using this "_" four times, we skill the year and then match with -10 and skip all thats after it and show results.
-- Since we arent interested in what comes after the 10, we use % to skip the rest. we can theoretically (and it works) use "%" but i used "_" for the sake of this example.
-- We use "_" when we know how many letters we want to skip when looking for data. we use "%" when we dont know.

-- Find any clients who are schools (Another example.)
SELECT *
FROM clients
WHERE client_name LIKE '%school%' OR client_name LIKE '%Shool%'; -- here we use both small and capital letters just in case. Character results are case sensitive. :) i think


-- ----------------------------------------------------------------------------- Union
-- We use this to get everything requested in a single long column list. 
-- In order for us to use this, both select requests MUST have the same number of columns.
-- if you use two columns in the first select and one in the second, it will not run!!!
-- 2 and 2 of similar datatypes will work fine. :)

-- Union essentially combines the results of 2 or more select statements. and it can be used with more

-- Find a list of employee and branch names
SELECT employee.first_name AS Employee_Branch_Names -- We use this to change the column name to suit both entry types
FROM employee
UNION
SELECT branch.branch_name
FROM branch;

-- Find a list of all clients & branch suppliers' names
SELECT clients.client_name AS Non_Employee_Entities, clients.branch_id AS Branch_ID
FROM clients
UNION
SELECT branch_supplier.supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- You can also use multiple unions, like so:
SELECT employee.first_name AS Company_Names -- We use this to change the column name to suit all entry types
FROM employee
UNION
SELECT branch.branch_name
FROM branch
UNION
SELECT supplier_name
FROM branch_supplier
UNION
SELECT client_name
FROM clients;

-- lets use this for something helpfully
-- Lets find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- ----------------------------------------------------------------------------- Joins
-- Add the extra branch (we will need this for demonstration)
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);

 -- LEFT JOIN, RIGHT JOIN and other joins. See figure "Different Join Types In SQL" in images folder. 
 
 
-- This will only show the managers, their ids and what branch they lead. -- Basically this shows the tables where all data is complete or connected. 
SELECT employee.emp_id, employee.first_name, branch.branch_name 
FROM employee -- TABLE A
JOIN branch    -- also known as INNER JOIN (TABLE B)
ON employee.emp_id = branch.mgr_id;

-- This will show all employees with their ids even if they arent managers. It will also show the managers, their ids and what branch they lead. Basically shows the table to the left or table A
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee -- TABLE A
LEFT JOIN branch -- LEFT JOIN (TABLE B)
ON employee.emp_id = branch.mgr_id;

-- This will show all branches even if they dont have a manager. It will show managers and their ids where they exist and show null where they dont. Basically this shows the table to the right or table B
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee -- TABLE A
RIGHT JOIN branch    -- Right Join (TABLE B)
ON employee.emp_id = branch.mgr_id;

-- There is also a 4th type of join call full outer join, this cant be run in MySQL but what it essentially does is it gets all the tables from left to right no matter the conditions. 
-- Even if employees are managers or not or if the branches have managers or not. it will show both sides of the tables.
 
-- There are some more basic but slightly unusable joins atm. If you want to see them look at the picture "Different Join Types In SQL" in the images folder that came with this script.



-- ----------------------------------------------------------------------------- Nested Queries
-- Nested queries are advanced select statements where we use another select statement's results to find a specfic piece of information / data within a table. 


-- Find names of all employees who have sold over 50,000
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (SELECT works_with.emp_id
                          FROM works_with
                          WHERE works_with.total_sales > 30000
                          );

-- Find all clients who are handles by the branch that Michael Scott manages
-- Assume you know Michael's ID
SELECT clients.client_id, clients.client_name
FROM clients
WHERE clients.branch_id = (SELECT branch.branch_id -- We are using "=" here and not "in" since every manager can manage 1 branch.
                          FROM branch
                          WHERE branch.mgr_id = 102
                          LIMIT 1 -- But we cant always guarantee that there will be ONE results, so... we make it only get 1 result. We limit the results to 1.
                          );

 -- here are a few more examples. 
 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 SELECT clients.client_id, clients.client_name -- Then we find the clients that are being supplied by the branch.
 FROM clients
 WHERE clients.branch_id = (SELECT branch.branch_id -- we then find the branch id he manages.
                           FROM branch
                           WHERE branch.mgr_id = (SELECT employee.emp_id
                                                  FROM employee
                                                  WHERE employee.first_name = 'Michael' AND employee.last_name ='Scott'
                                                  LIMIT 1 -- We first try to find his id through his name.
                                                  )
							);


-- Find the names of employees who work with clients handled by the scranton branch (assume you know the branch ID)
SELECT employee.first_name, employee.last_name -- 3rd Then we take the employee ids and find their names!
FROM employee
WHERE employee.emp_id IN (
                         SELECT works_with.emp_id
                         FROM works_with -- 1st  we find the all the employee ids who work with a client!
                         )
AND employee.branch_id = 2; -- 2nd then we filter it more by taking the employees that work in that branch!


-- Find the names of all clients who have spent more than 100,000 dollars
SELECT clients.client_name -- 3rd we find the client names through their IDs
FROM clients
WHERE clients.client_id IN (
                          SELECT client_id
                          FROM (
                                SELECT SUM(works_with.total_sales) AS totals, client_id
                                FROM works_with -- 1st we find all the clients
                                GROUP BY client_id) AS total_client_sales
                          WHERE totals > 100000 -- 2nd we filter out any client that spent less than 100K
);


-- ----------------------------------------------------------------------------- Triggers
-- a trigger is a block of code:
-- CREATE
--     TRIGGER `event_name` BEFORE/AFTER INSERT/UPDATE/DELETE
--     ON `database`.`table`
--     FOR EACH ROW BEGIN
-- 		-- trigger body
-- 		-- this code is applied to every
-- 		-- inserted/updated/deleted row
--     END;
-- this block of code performs a certain action when a certain condition is met.

CREATE TABLE trigger_test ( -- Lets use this as a test table. This will have things added to it everytime we... trigger a trigger i guess. activate a trigger?
     message VARCHAR(100)
);



-- Delimiter is basically this ";" the end quote of a statement. in a view/trigger/stored procedure/function we use the end quote multiple times which can lead to mysql thinking that the procedure or whatever you are doing ends there. 
-- we do not want that. We then change the delimiter to "$$" or anything of your choice tempoorarily while we finish the procedure script then we change it back to ";"

-- STEPS ARE HERE: since for some reason it refuses to have comments inside. should probably use # instead but... meh... too late to change that habit.
-- We start by changing the delimiter
-- Now we create a trigger that activates before we insert an entry into our "employee" table.
-- The use of "BEGIN/END" is not really necessary if you are only making a trigger for a single statement however it does not really hurt to have it.
-- The trigger then activates this statement which inserts this value/values into our selected table. You can really use your imagination here. Do what you want really.
-- We end here with our "END;" first then end the whole trigger statement with our new "$$" delimiter.
-- We then switch back to normal delimiters so we can resume doing anything else.

-- I must mention that you can create triggers both BEFORE and AFTER for INSERT, DELETE and UPDATE!
DELIMITER $$ 
CREATE
    TRIGGER my_trigger BEFORE INSERT 
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');  
    END;$$ 
DELIMITER ; 


INSERT INTO employee VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3); -- lets test this.
SELECT * FROM trigger_test; -- From my test, it works like a charm!

DROP TRIGGER IF EXISTS my_trigger; -- Lets delete this trigger and try again on a new example.


-- Now in here we use a new thing. the "NEW.first_name" thing. this allows us to access inserts. Lets say you want to log entries and stuff into a "company_log". 
-- Now you can have their name show up so you know forexample who is the new employee who was added.
-- also CONCAT() is a function we use to string together multiple strings. like this CONCAT('Kevin', 'Malone') will return "KevinMalone" yes... without the space.
-- You must add the " " yourself. :D Just look at my example to see how this works! 
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(CONCAT(NEW.first_name, ' ', NEW.last_name, ' Was Added To The Employee Roster!'));
    END;$$
DELIMITER ;

INSERT INTO employee VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3); -- Quick test to see if this worked. Now you should see "Kevin Malone Was Added To The Employee Roster!" in our test table.
SELECT * FROM trigger_test; -- This worked fine!

DROP TRIGGER IF EXISTS my_trigger; -- Lets drop this for the final trigger. BTW!!! i must mention that triggers cannot return things. for this you need a function, view or procedure. Recommend view as it is designed for this!




-- So this one shows how an if sentence works in here.
-- so we are going to check if the new entry is a female or male employee and insert accordingly into trigger_test.
-- Learn to always use a delimiter anyways, its good practice and will save you a lot of pain when dealing with multiple statement functions, procedures and triggers.
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female employee');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END;$$
DELIMITER ;

INSERT INTO employee VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3); -- Lets see if this works
SELECT * FROM trigger_test; 

-- Now lets clear our test things and prep for the next examples!
DELETE FROM employee WHERE emp_id = 109;
DELETE FROM employee WHERE emp_id = 110;
DELETE FROM employee WHERE emp_id = 111;
DROP TRIGGER my_trigger;
DROP TABLE trigger_test;

-- ----------------------------------------------------------------------------- Procedure
-- A procedure is a sequence of instructions like a trigger. However unlike a trigger, a procedure needs to be called. 
-- A procedure is like a void function in c++, it takes parameters, you can use it to edit variables and similar and it cant return anything.
-- Used for insert, delete, update. Or simply just building the database. 

-- This is the basic syntax of creating a stored procedure
-- CREATE PROCEDURE procedure_name(parameter_list)
-- BEGIN
--    statements;
-- END //

-- Lets try it out.
-- We want to insert a new employee but having to type everything over and over again can be a bit tedious. lets make a procedure that makes this easier
DELIMITER $$
CREATE PROCEDURE InsEmp (id INT, fn VARCHAR(20), ln VARCHAR(20), bd DATE, SEX varchar(5), sal INT, supID INT, bID INT)
BEGIN
	INSERT INTO employee VALUES(id, fn, ln, bd, SEX, sal, supID, bID);
END $$
DELIMITER ;



CALL insEmp(150, 'Mark', 'Jessheim', '1940-01-01', 'M', 1000000, 100, 1);
SELECT * FROM employee WHERE emp_id = 150;

-- Meh... we dont like him, too grumpy, lets fire him.

DELIMITER $$
CREATE PROCEDURE DelEmp (id INT)
BEGIN
	DELETE FROM employee WHERE emp_id = id;
END $$
DELIMITER ;

CALL DelEmp(150);
SELECT * FROM employee WHERE emp_id = 150;


DROP PROCEDURE InsEmp; -- To delete the procedure
DROP PROCEDURE DelEmp; -- To delete the procedure

-- You can use your imagination for this. You can also use it as a VIEW however it isnt really that fast like a VIEW.


-- More on stored procedures here: https://www.w3schools.com/sql/sql_stored_procedures.asp
-- and https://www.mysqltutorial.org/getting-started-with-mysql-stored-procedures.aspx/
-- ----------------------------------------------------------------------------- Function
-- A function is like a procedure, it takes parameters and returns data. Similar to already built functions in SQL:  SUM(), AVG(), COUNT(), CONCAT().

-- lets try this. we want to find someones age. lets say we want to find employee id 100s age.
DELIMITER $$
CREATE FUNCTION FindAGE(date1 DATE) 
RETURNS INT DETERMINISTIC
	BEGIN
		DECLARE date2 DATE;
		SELECT current_date() INTO date2;
        RETURN year(date2)-year(date1);
    END $$
DELIMITER ;
-- We use the delimiter so that mysql doesnt think the function creation ended at the first like.
-- We then tell mysql what is this function returning.
-- Then we declare a variable. date2 which we will use to store todays date in.
-- NB: we can use functions within functions like demonstrated. i called an inbuilt function current_date() to find todays date.
-- then we return what we want to return which is his age. now we get the age of a person by subtracting their birthday from todays date. and to make it easier, i decided to just subrtact the years. 

-- Just like so. Now lets use it!
SELECT employee.emp_id, employee.first_name, employee.last_name, findAGE(employee.birth_day) AS Age
FROM employee
WHERE employee.emp_ID = 100;

-- lets find my age then...
SELECT findAGE('2000-5-11') AS MyAge;

-- To delete the function
DROP FUNCTION FindAGE;


-- ----------------------------------------------------------------------------- View
-- A view is a sequence of instructions like a function, trigger, etc. However a view can be used to shorten complex select sentences. it shows you a virtual table with the select statements of your choice.
-- like a procedure and a function, it can be called. 

-- Now it took us a while to write that last select statement to find an employee, their age and etc. lets shorten it by writing it down one last time like so. but this time we want to find all employee ages.
CREATE VIEW employeeGeneral
AS
SELECT employee.emp_id, employee.first_name, employee.last_name, findAGE(employee.birth_day) AS Age
FROM employee;

-- lets call it thien.
SELECT * FROM employeeGeneral;

-- We want to find both oldert and youngest in the employee table
SELECT * FROM employeeGeneral ORDER BY Age ASC LIMIT 1; -- Youngest
SELECT * FROM employeeGeneral ORDER BY Age DESC LIMIT 1; -- Oldest


-- what if we want a specific employee?
SELECT * FROM employeeGeneral WHERE emp_id=100;

DROP VIEW employeeGeneral;

-- Use your imagination for the rest ;)
-- More on VIEW https://www.mysqltutorial.org/mysql-views-tutorial.aspx/
-- ----------------------------------------------------------------------------- ER Diagram?
-- An ER Diagram while unnecessary, it makes understanding databases easier. Its a... diagram. An Entity Relations Diagram.
-- It is a diagram that shows table (entity) relationships to each other.
-- It is not really possible to show this to you via code, but, i made an ER Diagram example of this company in the folder. ("Company ER Diagram.mwb")