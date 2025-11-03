-- Task 1.1: Create Sample Tables
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2)
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10,2)
);

-- Task 1.2: Insert Sample Data
INSERT INTO employees (emp_id, emp_name, dept_id, salary) VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);


-- Task 2.1: Basic CROSS JOIN
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
-- 5 * 4 = 20 rows

-- Task 2.2: Alternative CROSS JOIN
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;

SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON TRUE;

-- Task 2.3: CROSS JOIN with projects
SELECT e.emp_name, p.project_name
FROM employees e CROSS JOIN projects p;


-- Task 3.1: INNER JOIN with ON
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
-- 4 rows
-- Tom Brown excluded because his dept_id is NULL

-- Task 3.2: INNER JOIN with USING
SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);
-- USING removes duplicate join column (dept_id) from output

-- Task 3.3: NATURAL INNER JOIN
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;

-- Task 3.4: Multi-table INNER JOIN
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;


-- Task 4.1: Basic LEFT JOIN
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- Tom Brown is shown with NULLs for department columns

-- Task 4.2: LEFT JOIN with USING
SELECT emp_name, dept_id, dept_name
FROM employees
LEFT JOIN departments USING (dept_id);

-- Task 4.3: Find employees without departments
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Task 4.4: LEFT JOIN with aggregation
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;


-- Task 5.1: Basic RIGHT JOIN
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Task 5.2: Convert to LEFT JOIN
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id;

-- Task 5.3: Departments without employees
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;


-- Task 6.1: Basic FULL JOIN
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
-- NULLs on left = departments with no employees (Marketing)
-- NULLs on right = employees with no department (Tom Brown)

-- Task 6.2: FULL JOIN with projects
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

-- Task 6.3: Orphaned records
SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;


-- Task 7.1: Filter in ON clause
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

-- Task 7.2: Filter in WHERE clause
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- ON clause: all employees kept, only Building A departments matched
-- WHERE clause: filters after join, so only employees in Building A remain

-- Task 7.3: Repeat with INNER JOIN
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- No difference for INNER JOIN, because unmatched rows are excluded anyway


-- Task 8.1: Multiple joins
SELECT d.dept_name, e.emp_name, e.salary, p.project_name, p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

-- Task 8.2: Self join
ALTER TABLE employees ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3 WHERE emp_id IN (1,2,4,5);
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;

SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Task 8.3: Join with subquery
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;


-- 1. What is the difference between INNER JOIN and LEFT JOIN?
-- INNER JOIN: Returns only rows where there is a match in both tables.
-- LEFT JOIN: Returns all rows from the left table, and matching rows from the right table (NULLs if no match).

-- 2. When would you use CROSS JOIN in a practical scenario?
-- When you need all possible combinations of two sets, e.g. generating an employee × project availability matrix,
-- seating arrangements, or testing all parameter combinations.

-- 3. Explain why the position of a filter condition (ON vs WHERE) matters for outer joins but not for inner joins.
-- Outer joins:
-- ON filter → applied during the join, unmatched rows are still preserved.
-- WHERE filter → applied after the join, unmatched rows may be eliminated.

-- Inner joins: Both ON and WHERE filters produce the same result, since only matched rows are kept anyway.

-- 4. What is the result of: SELECT COUNT(*) FROM table1 CROSS JOIN table2 if table1 has 5 rows and table2 has 10 rows?
-- 5 × 10 = 50 rows.

-- 5. How does NATURAL JOIN determine which columns to join on?
-- It automatically joins on all columns with the same name in both tables.

-- 6. What are the potential risks of using NATURAL JOIN?
-- Unintended joins if multiple columns share the same name.
-- Schema changes can silently alter query results.
-- Reduced readability and maintainability compared to explicit ON conditions.

-- 7. Convert this LEFT JOIN to a RIGHT JOIN: SELECT * FROM A LEFT JOIN B ON A.id = B.id Equivalent RIGHT JOIN:
-- SELECT *
-- FROM B
-- RIGHT JOIN A ON A.id = B.id;

-- 8. When should you use FULL OUTER JOIN instead of other join types?
-- When you need all rows from both tables, regardless of matches.


-- Additional Challenges

-- 1
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- 2
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IN (
    SELECT dept_id
    FROM projects
    GROUP BY dept_id
    HAVING COUNT(*) > 1
);

-- 3
SELECT e.emp_name AS employee,
       m.emp_name AS manager,
       mm.emp_name AS grand_manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
LEFT JOIN employees mm ON m.manager_id = mm.emp_id;

-- 4
SELECT e1.emp_name AS employee1, e2.emp_name AS employee2, e1.dept_id
FROM employees e1
JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id;
