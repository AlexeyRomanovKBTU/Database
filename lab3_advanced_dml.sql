CREATE DATABASE advanced_lab;

-- Create employees table
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50) DEFAULT NULL,
    salary INTEGER DEFAULT 40000,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

-- Create departments table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INTEGER,
    manager_id INTEGER
);

-- Create projects table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

-- 2. INSERT with column specification
INSERT INTO employees (first_name, last_name, department)
VALUES ('John', 'Doe', 'IT');

-- 3. INSERT with DEFAULT values
INSERT INTO employees (first_name, last_name, hire_date)
VALUES ('Jane', 'Smith', CURRENT_DATE);

-- 4. INSERT multiple rows in single statement
INSERT INTO departments (dept_name, budget, manager_id)
VALUES ('HR', 60000, 1),
       ('IT', 120000, 2),
       ('Sales', 90000, 3);

-- 5. INSERT with expressions
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Mike', 'Brown', 'Finance', 50000 * 1.1, CURRENT_DATE);

-- 6. INSERT from SELECT
CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE department = 'IT';

-- 7. UPDATE with arithmetic expressions
UPDATE employees SET salary = salary * 1.1;

-- 8. UPDATE with WHERE clause
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

-- 9. UPDATE using CASE expression
UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

-- 10. UPDATE with DEFAULT
ALTER TABLE employees ALTER COLUMN department SET DEFAULT 'General';
UPDATE employees SET department = DEFAULT WHERE status = 'Inactive';

-- 11. UPDATE with subquery
UPDATE departments d
SET budget = (SELECT AVG(salary) * 1.2 FROM employees e WHERE e.department = d.dept_name);

-- 12. UPDATE multiple columns
UPDATE employees
SET salary = salary * 1.15, status = 'Promoted'
WHERE department = 'Sales';

-- 13. DELETE with simple WHERE condition
DELETE FROM employees WHERE status = 'Terminated';

-- 14. DELETE with complex WHERE clause
DELETE FROM employees
WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;

-- 15. DELETE with subquery
DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department FROM employees WHERE department IS NOT NULL
);

-- 16. DELETE with RETURNING clause
DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- 17. INSERT with NULL values
INSERT INTO employees (first_name, last_name, salary, department)
VALUES ('Null', 'Case', NULL, NULL);

-- 18. UPDATE NULL handling
UPDATE employees SET department = 'Unassigned' WHERE department IS NULL;

-- 19. DELETE with NULL conditions
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;

-- 20. INSERT with RETURNING
INSERT INTO employees (first_name, last_name, department, hire_date)
VALUES ('Alice', 'Green', 'IT', CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

-- 21. UPDATE with RETURNING
UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;

-- 22. DELETE with RETURNING all columns
DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

-- 23. Conditional INSERT
INSERT INTO employees (first_name, last_name, department, hire_date)
SELECT 'Tom', 'White', 'Marketing', CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees WHERE first_name = 'Tom' AND last_name = 'White'
);

-- 24. UPDATE with JOIN logic using subqueries
UPDATE employees e
SET salary = salary * CASE
    WHEN (SELECT budget FROM departments d WHERE d.dept_name = e.department) > 100000
        THEN 1.10 ELSE 1.05 END;

-- 25. Bulk operations
INSERT INTO employees (first_name, last_name, department, hire_date)
VALUES ('Emp1', 'Test', 'HR', CURRENT_DATE),
       ('Emp2', 'Test', 'HR', CURRENT_DATE),
       ('Emp3', 'Test', 'HR', CURRENT_DATE),
       ('Emp4', 'Test', 'HR', CURRENT_DATE),
       ('Emp5', 'Test', 'HR', CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.1
WHERE last_name = 'Test';

-- 26. Data migration simulation
CREATE TABLE employee_archive AS TABLE employees WITH NO DATA;
INSERT INTO employee_archive SELECT * FROM employees WHERE status = 'Inactive';
DELETE FROM employees WHERE status = 'Inactive';

-- 27. Complex business logic
UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000 AND (
    SELECT COUNT(*) FROM employees e WHERE e.department = (
        SELECT dept_name FROM departments d WHERE d.dept_id = p.dept_id
    )
) > 3;
