-- Task 1.1
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

-- Task 1.2
CREATE TABLE products_catalog (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    regular_price NUMERIC NOT NULL,
    discount_price NUMERIC NOT NULL,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND discount_price > 0 AND discount_price < regular_price
    )
);

-- Task 1.3
CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INTEGER NOT NULL,
    CONSTRAINT chk_guests CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT chk_dates CHECK (check_out_date > check_in_date)
);

-- Task 1.4
INSERT INTO employees VALUES
(1, 'Aidar', 'Zhaksylykov', 28, 3500),
(2, 'Nurgul', 'Sariyeva', 45, 7200),
(3, 'Bauyrzhan', 'Tursyn', 33, 4200),
(4, 'Dana', 'Kenzhebek', 54, 6800),
(5, 'Serik', 'Abdulla', 22, 2900);

-- invalid test (age and salary)
INSERT INTO employees VALUES
(6, 'Timur', 'Seitov', 17, -2000);

INSERT INTO products_catalog VALUES
(1, 'Backpack', 50, 40),
(2, 'Thermos', 25, 20),
(3, 'Notebook', 5, 4),
(4, 'Pencil', 2, 1),
(5, 'Water Bottle', 10, 8);

-- invalid test (price)
INSERT INTO products_catalog VALUES
(6, 'Pen', 0, -10);

INSERT INTO bookings VALUES
(1, '2025-11-01', '2025-11-05', 2),
(2, '2025-12-24', '2025-12-26', 4),
(3, '2025-10-10', '2025-10-13', 3),
(4, '2025-09-05', '2025-09-10', 5),
(5, '2025-08-15', '2025-08-20', 2);

-- invalid test (wrong date and guests)
INSERT INTO bookings VALUES
(6, '2026-11-01', '2025-11-05', 11);

-- Task 2.1
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

-- Task 2.2
CREATE TABLE inventory (
    item_id INTEGER PRIMARY KEY NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

-- Task 2.3
INSERT INTO customers VALUES
(1, 'a.rom@example.com', '+7-701-111-2222', '2025-01-15'),
(2, 'n.bek@example.com', NULL, '2025-03-05'),
(3, 'b.kaz@example.com', '+7-701-222-3333', '2025-02-20'),
(4, 's.kz@example.com', '+7-701-333-4444', '2025-04-18'),
(5, 'm.ali@example.com', NULL, '2025-05-25');

-- invalid test (missing email)
INSERT INTO customers VALUES
(6, NULL, '+7-700-000-0000', '2025-07-01');

INSERT INTO inventory VALUES
(1, 'Screwdriver', 150, 5.5, '2025-09-01 10:00:00'),
(2, 'Nails', 3000, 3.75, '2025-09-05 12:30:00'),
(3, 'Hammer', 50, 12.9, '2025-09-07 09:10:00'),
(4, 'Wrench', 70, 9.4, '2025-09-08 14:20:00'),
(5, 'Pliers', 90, 8.6, '2025-09-10 11:45:00');

-- invalid test (negative quantity)
INSERT INTO inventory VALUES
(6, 'Broken Tool', -5, 10, '2025-09-12 10:00:00');

-- Task 3.1
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

-- Task 3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_code TEXT NOT NULL,
    semester TEXT NOT NULL,
    CONSTRAINT uq_student_course_semester UNIQUE (student_id, course_code, semester)
);

INSERT INTO course_enrollments VALUES
(1, 1, 'CS101', 'Fall2025'),
(2, 2, 'HIST200', 'Fall2025'),
(3, 3, 'MATH110', 'Fall2025'),
(4, 4, 'CS102', 'Spring2025'),
(5, 5, 'ENG101', 'Fall2025');

-- Task 3.3
ALTER TABLE users
    ADD CONSTRAINT unique_username UNIQUE (username),
    ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES
(1, 'aidar28', 'aidar@example.com', now()),
(2, 'nurgul45', 'nurgul@example.com', now()),
(3, 'beka33', 'beka@example.com', now()),
(4, 'serik55', 'serik@example.com', now()),
(5, 'dana01', 'dana@example.com', now());

-- testing duplicate username
INSERT INTO users VALUES
(6, 'aidar28', 'other@example.com', now());

-- Task 4.1
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES
(1, 'Engineering', 'Almaty'),
(2, 'HR', 'Astana'),
(3, 'Sales', 'Shymkent'),
(4, 'Marketing', 'Atyrau'),
(5, 'Finance', 'Kostanay');

INSERT INTO departments VALUES
(1, 'Marketing', 'Astana'),
(NULL, 'Marketing', 'Astana');
-- Task 4.2
CREATE TABLE student_courses (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES
(1, 101, '2025-02-01', 'A'),
(2, 101, '2025-02-02', 'B'),
(3, 102, '2025-03-01', 'A'),
(4, 103, '2025-03-15', 'C'),
(5, 104, '2025-04-01', 'B');

-- Task 4.3
-- Comparison Exercise
-- UNIQUE allows multiple NULLs and ensures only uniqueness.
-- PRIMARY KEY implies both NOT NULL and UNIQUE.
-- A table can have multiple UNIQUE constraints but only one PRIMARY KEY.

-- Task 5.1
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES
(1, 'Rinat', 1, '2024-09-10'),
(2, 'Aigerim', 2, '2023-05-01'),
(3, 'Dias', 3, '2022-03-12'),
(4, 'Aliya', 4, '2021-07-20'),
(5, 'Murat', 5, '2020-11-30');

-- invalid foreign key test
INSERT INTO employees_dept VALUES
(6, 'Ghost', 999, '2025-01-01');

-- Task 5.2
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES
(1, 'Abai Qunanbaiuly', 'Kazakhstan'),
(2, 'Chingiz Aitmatov', 'Kyrgyzstan'),
(3, 'Gabriel Garcia Marquez', 'Colombia'),
(4, 'Leo Tolstoy', 'Russia'),
(5, 'Fyodor Dostoevsky', 'Russia');

INSERT INTO publishers VALUES
(1, 'KazakhPub', 'Almaty'),
(2, 'CentralBooks', 'Bishkek'),
(3, 'GlobalReads', 'Bogota'),
(4, 'ClassicHouse', 'Moscow'),
(5, 'OldPrints', 'St. Petersburg');

INSERT INTO books VALUES
(1, 'The Path', 1, 1, 1885, 'ISBN-1'),
(2, 'Jamilia', 2, 2, 1958, 'ISBN-2'),
(3, 'One Hundred Years of Solitude', 3, 3, 1967, 'ISBN-3'),
(4, 'War and Peace', 4, 4, 1869, 'ISBN-4'),
(5, 'Crime and Punishment', 5, 5, 1866, 'ISBN-5');

-- Task 5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Toys'),
(4, 'Clothes'),
(5, 'Furniture');

INSERT INTO products_fk VALUES
(1, 'Smartphone', 1),
(2, 'Laptop', 1),
(3, 'Novel', 2),
(4, 'Teddy Bear', 3),
(5, 'Chair', 5);

INSERT INTO orders VALUES
(1, '2025-08-01'),
(2, '2025-08-02'),
(3, '2025-08-03'),
(4, '2025-08-04'),
(5, '2025-08-05');

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 2, 1),
(4, 3, 4, 5),
(5, 4, 5, 1);

-- Test ON DELETE RESTRICT
DELETE FROM categories WHERE category_id = 1;
-- There are rows in products_fk referencing it (ON DELETE RESTRICT prevents deletion).


-- Test ON DELETE CASCADE
DELETE FROM orders WHERE order_id = 1;
-- All related order_items with order_id = 1 are automatically deleted as well
-- due to ON DELETE CASCADE behavior.

-- Task 6.1
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders_ecom (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL,
    CONSTRAINT chk_order_status CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders_ecom(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

ALTER TABLE customers
    ADD CONSTRAINT unique_customer_email UNIQUE (email);

INSERT INTO products VALUES
(1, 'Wireless Mouse', 'Ergonomic wireless mouse', 19.99, 150),
(2, 'Mechanical Keyboard', 'Backlit keyboard', 79.99, 60),
(3, 'USB-C Hub', '5-in-1 USB-C hub', 34.50, 200),
(4, 'Gaming Headset', 'Surround sound headset', 59.00, 40),
(5, 'Desk Lamp', 'LED desk lamp', 22.00, 120);

INSERT INTO orders_ecom VALUES
(1, 1, '2025-09-01', 99.98, 'pending'),
(2, 2, '2025-09-02', 34.50, 'processing'),
(3, 3, '2025-09-03', 120.00, 'shipped'),
(4, 4, '2025-09-04', 22.00, 'delivered'),
(5, 5, '2025-09-05', 59.00, 'cancelled');

INSERT INTO order_details VALUES
(1, 1, 1, 2, 19.99),
(2, 1, 2, 1, 79.99),
(3, 2, 3, 1, 34.50),
(4, 3, 4, 2, 59.00),
(5, 4, 5, 1, 22.00);

-- Test invalid customer reference
INSERT INTO orders_ecom VALUES
(6, 999, '2025-09-10', 50, 'pending');
-- Because customer_id = 999 does not exist in the customers table.

-- Test ON DELETE CASCADE for e-commerce
DELETE FROM orders_ecom WHERE order_id = 1;
-- All related rows in order_details (order_id = 1) are automatically deleted
-- because of ON DELETE CASCADE.

-- Test ON DELETE RESTRICT for e-commerce product
DELETE FROM products WHERE product_id = 1;
-- Because it is referenced in order_details (ON DELETE RESTRICT prevents deletion).