-- Task 1.1: Database Creation with Parameters

CREATE DATABASE university_main
    WITH OWNER = myuser
         TEMPLATE = template0
         ENCODING = 'UTF8';

CREATE DATABASE university_archive
    WITH OWNER = myuser
         TEMPLATE = template0
         ENCODING = 'UTF8'
         CONNECTION LIMIT = 50;

CREATE DATABASE university_test
    WITH OWNER = myuser
         TEMPLATE = template0
         ENCODING = 'UTF8'
         CONNECTION LIMIT = 10;


-- Task 1.2: Tablespace Operations

CREATE TABLESPACE student_data LOCATION 'C:/PostgreSQL/data/students';

CREATE TABLESPACE course_data OWNER myuser LOCATION 'C:/PostgreSQL/data/courses';

CREATE DATABASE university_distributed
    WITH OWNER = myuser
         TEMPLATE = template0
         ENCODING = 'WIN1251'
         TABLESPACE = student_data;


-- Task 2.1: University Management System

CREATE TABLE students (
    student_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa numeric(3,2),
    is_active boolean,
    graduation_year smallint
);

CREATE TABLE professors (
    professor_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary numeric(12,2),
    is_tenured boolean,
    years_experience integer
);

CREATE TABLE courses (
    course_id serial PRIMARY KEY,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment integer,
    course_fee numeric(10,2),
    is_online boolean,
    created_at timestamp without time zone
);


-- Task 2.2: Time-based and Specialized Tables

CREATE TABLE class_schedule (
    schedule_id serial PRIMARY KEY,
    course_id integer,
    professor_id integer,
    classroom varchar(20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);

CREATE TABLE student_records (
    record_id serial PRIMARY KEY,
    student_id integer,
    course_id integer,
    semester varchar(20),
    year integer,
    grade char(2),
    attendance_percentage numeric(4,1),
    submission_timestamp timestamp with time zone,
    last_updated timestamp with time zone
);


-- Task 3.1: Modifying Existing Tables

ALTER TABLE students
    ADD COLUMN middle_name varchar(30),
    ADD COLUMN student_status varchar(20);

ALTER TABLE students
    ALTER COLUMN phone TYPE varchar(20);

ALTER TABLE students
    ALTER COLUMN student_status SET DEFAULT 'ACTIVE';

ALTER TABLE students
    ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
    ADD COLUMN department_code char(5),
    ADD COLUMN research_area text,
    ADD COLUMN last_promotion_date date;

ALTER TABLE professors
    ALTER COLUMN years_experience TYPE smallint USING years_experience::smallint;

ALTER TABLE professors
    ALTER COLUMN is_tenured SET DEFAULT false;

ALTER TABLE courses
    ADD COLUMN prerequisite_course_id integer,
    ADD COLUMN difficulty_level smallint;

ALTER TABLE courses
    ALTER COLUMN course_code TYPE varchar(10);

ALTER TABLE courses
    ALTER COLUMN credits SET DEFAULT 3;

ALTER TABLE courses
    ADD COLUMN lab_required boolean DEFAULT false;


-- Task 3.2: Column Management Operations

ALTER TABLE class_schedule
    ADD COLUMN room_capacity integer;

ALTER TABLE class_schedule
    DROP COLUMN IF EXISTS duration;

ALTER TABLE class_schedule
    ADD COLUMN session_type varchar(15);

ALTER TABLE class_schedule
    ALTER COLUMN classroom TYPE varchar(30);

ALTER TABLE class_schedule
    ADD COLUMN equipment_needed text;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points numeric(4,1);

ALTER TABLE student_records
    ALTER COLUMN grade TYPE varchar(5);

ALTER TABLE student_records
    ALTER COLUMN extra_credit_points SET DEFAULT 0.0;

ALTER TABLE student_records
    ADD COLUMN final_exam_date date;

ALTER TABLE student_records
    DROP COLUMN IF EXISTS last_updated;


-- Task 4.1: Additional Supporting Tables

CREATE TABLE departments (
    department_id serial PRIMARY KEY,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget numeric(14,2),
    established_year integer
);

CREATE TABLE library_books (
    book_id serial PRIMARY KEY,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price numeric(8,2),
    is_available boolean,
    acquisition_timestamp timestamp without time zone
);

CREATE TABLE student_book_loans (
    loan_id serial PRIMARY KEY,
    student_id integer,
    book_id integer,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount numeric(8,2),
    loan_status varchar(20)
);


-- Task 4.2: Table Modifications for Integration

ALTER TABLE professors ADD COLUMN department_id integer;
ALTER TABLE students ADD COLUMN advisor_id integer;
ALTER TABLE courses ADD COLUMN department_id integer;

CREATE TABLE grade_scale (
    grade_id serial PRIMARY KEY,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2)
);

CREATE TABLE semester_calendar (
    semester_id serial PRIMARY KEY,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);


-- Task 5.1: Conditional Table Operations

DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale (
    grade_id serial PRIMARY KEY,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2),
    description text
);

DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar (
    semester_id serial PRIMARY KEY,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);


-- Task 5.2: Database Cleanup

DROP DATABASE IF EXISTS university_test;

DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup
    WITH OWNER = myuser
         TEMPLATE = university_main
         ENCODING = 'UTF8';