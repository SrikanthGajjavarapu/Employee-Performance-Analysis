CREATE DATABASE employee_performance_project;
USE employee_performance_project;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE,
    country VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);

CREATE TABLE Performance_Reviews (
    review_id INT PRIMARY KEY,
    employee_id INT,
    review_date DATE,
    performance_score INT,
    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id)
);

INSERT INTO Departments VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales');

INSERT INTO Employees VALUES
(101, 'Rahul', 'Male', '1995-04-12', 'India', 1, 65000, 5000, '2021-03-15'),
(102, 'Priya', 'Female', '1997-08-20', 'India', 2, 48000, 3000, '2022-06-10'),
(103, 'Amit', 'Male', '1993-02-14', 'India', 1, 80000, 8000, '2020-01-20'),
(104, 'Sneha', 'Female', '1996-11-05', 'New Zealand', 3, 72000, 6000, '2021-07-12'),
(105, 'Kiran', 'Male', '1998-06-18', 'India', 4, 42000, NULL, '2023-02-01'),
(106, 'Neha', 'Female', '1994-09-25', 'New Zealand', 2, 58000, 4000, '2020-09-15'),
(107, 'Arjun', 'Male', '1992-12-10', 'India', 1, 90000, 10000, '2019-05-22'),
(108, 'Divya', 'Female', '1999-03-30', 'India', 4, 46000, 2000, '2023-08-14'),
(109, 'Vikram', 'Male', '1991-07-16', 'New Zealand', 3, 85000, 9000, '2018-04-10'),
(110, 'Ananya', 'Female', '1995-01-08', 'India', 2, 52000, NULL, '2022-11-05'),
(111, 'Rohit', 'Male', '1997-05-19', 'New Zealand', 4, 55000, 3500, '2021-12-01'),
(112, 'Meera', 'Female', '1993-10-22', 'India', 1, 75000, 7000, '2020-06-18');

INSERT INTO Performance_Reviews VALUES
(1, 101, '2024-06-30', 75),
(2, 101, '2025-06-30', 85),
(3, 102, '2024-06-30', 80),
(4, 102, '2025-06-30', 82),
(5, 103, '2024-06-30', 88),
(6, 103, '2025-06-30', 92),
(7, 104, '2024-06-30', 70),
(8, 104, '2025-06-30', 78),
(9, 105, '2024-06-30', 65),
(10, 105, '2025-06-30', 72),
(11, 106, '2024-06-30', 90),
(12, 106, '2025-06-30', 86),
(13, 107, '2024-06-30', 92),
(14, 107, '2025-06-30', 95),
(15, 108, '2024-06-30', 68),
(16, 108, '2025-06-30', 75),
(17, 109, '2024-06-30', 85),
(18, 109, '2025-06-30', 89),
(19, 110, '2024-06-30', 78),
(20, 110, '2025-06-30', 80),
(21, 111, '2024-06-30', 72),
(22, 111, '2025-06-30', 79),
(23, 112, '2024-06-30', 82),
(24, 112, '2025-06-30', 90);