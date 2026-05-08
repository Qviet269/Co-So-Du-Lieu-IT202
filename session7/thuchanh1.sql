create database employee_management;

use employee_management;

create table if not exists  departments (
	dept_id int primary key,
    dept_name varchar(50) not null,
    rating varchar(50)
);

CREATE TABLE IF NOT EXISTS  (
	emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    phone  CHAR(15) NOT NULL UNIQUE,
    kpiScore INT NOT NULL,
    dept_id INT NOT NULL,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_id, dept_name, rating )
VALUES 
(1, 'Sales', 'Excellent'),
(2, 'HR', 'Good');

INSERT INTO employees (emp_id, emp_name, phone, kpiScore, dept_id)
VALUES 
(101, 'Nguyễn Văn Tuấn', '0901112233', 85, 1),
(102, 'Trần Mai Phương', '0912223344', 92, 1),
(103, 'Lê Hoàng Phúc', '0923334455', 75, 2),
(104, 'Phạm Hải Yến', '0934445566', 88, 2);


SELECT emp_name, kpiScore FROM employees
WHERE kpiScore > ( SELECT AVG(kpiScore) FROM employees);

SELECT * FROM employees
WHERE dept_id IN (
	SELECT dept_id FROM  departments
    WHERE rating = 'Excellent'
);


SELECT * FROM (SELECT emp_name, phone FROM employees) AS EmployeeContacts

