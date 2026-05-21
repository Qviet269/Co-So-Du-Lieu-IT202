CREATE DATABASE office_staff_management;

USE office_staff_management;

CREATE TABLE employees (
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) UNIQUE,
    hire_date DATE DEFAULT (CURRENT_DATE),
    salary INT check (salary > 0)
);

CREATE TABLE employee_datails(
	detail_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT UNIQUE,
    citizen_id INT NOT NULL,
    address VARCHAR(100) NOT NULL,
    working_status VARCHAR(100) CHECK(working_status IN('Active', 'Inactive')),
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE departments (
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL
);

CREATE TABLE projects (
	project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    department_id INT,
    budget INT CHECK(budget > 0),
    project_status VARCHAR(20),
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE work_assignments (
	assignment_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    start_date DATE NOT NULL,
    deadline DATE NOT NULL,
    completed_date DATE NULL,
    
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
    
);

INSERT INTO employees
VALUES 
(1, 'Nguyen Van A', 'anv@gmail.com', '0901234567', '2022-01-15', 12000000),
(2, 'Tran Thi B', 'btt@gmail.com', '0901234568', '2022-05-20', 18000000),
(3, 'Le Van C', 'cle@gmail.com', '0922334455', '2022-02-10', 95000000),
(4, 'Pham Minh D', 'dpham@gmail.com', '0933445566', '2022-11-05', 22000000),
(5, 'Hoang Anh E', 'ehoang@gmail.com', '0944556677', '2022-01-12', 15000000);

INSERT INTO employee_datails
VALUES 
(1, 1, 123456789, 'Ha Noi', 'Active'),
(2, 2, 234567890, 'Hai Phong', 'Active'),
(3, 3, 345678901, 'Da Nang', 'Inactive'),
(4, 4, 456789012, 'Ho Chi Minh', 'Active'),
(5, 5, 567890123, 'Can tho', 'Active');

INSERT INTO departments
VALUES 
(1, 'IT', 'Phòng công nghệ thông tin'),
(2, 'HR', 'Phòng nhân sự'),
(3, 'Marketing', 'Phòng marketing'),
(4, 'Finance', 'Phòng tài chính'),
(5, 'Sales', 'Phòng kinh doanh');

INSERT INTO projects
VALUES 
(1, 'Website Company', 1, 50000000, 'Doing'),
(2, 'Reeruitment 2025', 2, 20000000, 'Pending'),
(3, 'Ads Campaign', 3, 30000000, 'Doing'),
(4, 'Accounting System', 4, 45000000, 'Done'),
(5, 'Customer Expansion', 5, 25000000, 'Pending');

INSERT INTO work_assignments
VALUES 
(101, 1, 1, '2024-01-10', '2024-02-10', Null),
(102, 2, 2, '2024-02-01', '2024-03-01', '2024-02-25'),
(103, 3, 3, '2024-03-05', '2024-04-05', Null),
(104, 4, 4, '2024-10-10', '2024-12-10', '2023-12-05'),
(105, 5, 5, '2024-04-01', '2024-05-01', Null);

-- cau 2
set SQL_SAFE_UPDATES = 0;
UPDATE projects
SET budget = budget + 5000000
WHERE department_id IN 
(SELECT department_id FROM departments WHERE department_name = 'IT') ;
set SQL_SAFE_UPDATES = 1;

DELETE FROM work_assignments
WHERE completed_date IS NOT NULL AND YEAR(start_date) < 2024;

-- PHAÀN 3

SELECT P.project_id, P.project_name, P.budget FROM projects AS P
JOIN departments AS D
ON D.department_id = P.department_id
WHERE D.department_name = 'IT' AND P.budget > 30000000;

-- CAU 2
SELECT employee_id, full_name, email FROM employees
WHERE hire_date BETWEEN '2022-01-01' AND '2022-12-31' AND email LIKE '%@gmail.com';

-- cau 3
SELECT employee_id, full_name, salary FROM employees
ORDER BY salary DESC
LIMIT 3 OFFSET 2;

-- PHAN 4
-- CAU 1
SELECT W.assignment_id, E.full_name, P.project_name, W.start_date, W.deadline 
FROM work_assignments AS W
JOIN employees AS E
ON E.employee_id = W.employee_id
JOIN projects AS P
ON P.project_id = W.project_id
WHERE completed_date  IS NULL;

-- CAU 2
SELECT D.department_name, SUM(P.budget) AS total_budget
FROM projects AS P
JOIN departments AS D
ON D.department_id = P.department_id
GROUP BY  D.department_name
HAVING SUM(P.budget) > 40000000;

-- CAU 3
SELECT em.employee_id, em.full_name, e.working_status FROM employee_datails AS e
JOIN employees AS em
ON em.employee_id = e.employee_id
WHERE e.working_status = 'Active';

-- PHAN 5
CREATE INDEX idx_assignment_dates
ON  work_assignments (start_date, completed_date);

DROP VIEW vw_overdue_assignments;
CREATE VIEW vw_overdue_assignments AS
SELECT W.assignment_id, E.full_name, P.project_name, W.start_date, W.deadline 
FROM work_assignments AS W
JOIN employees AS E
ON E.employee_id = W.employee_id
JOIN projects AS P
ON P.project_id = W.project_id
WHERE completed_date  IS NULL AND W.deadline > CURDATE();

SELECT * FROM vw_overdue_assignments;

-- Phan 6
DELIMITER //
	CREATE TRIGGER trg_after_assignment_insert
    AFTER INSERT ON work_assignments
    FOR EACH ROW
    BEGIN
		UPDATE projects
        SET project_status = 'Doing'
        WHERE project_id = NEW.project_id;
    END //
DELIMITER ;

-- CAU 2
DELIMITER //
	CREATE TRIGGER trg_prevent_delete_employee
    AFTER DELETE ON work_assignments
    FOR EACH ROW
    BEGIN
		IF completed_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LỖI: Nhân viên chưa hoàn thành công việc nên không thể xóa';
        END IF;
    END //
DELIMITER ;

-- PHAN 7
-- CAU 1
DELIMITER //
	CREATE PROCEDURE sp_check_project_budget(IN p_project_id INT, 
											OUT p_message VARCHAR(100))
    BEGIN
		DECLARE v_budget_pro INT;
        SELECT budget INTO v_budget_pro FROM projects WHERE project_id = p_project_id;
        
		IF v_budget_pro < 20000000 THEN 
			SET p_message = 'Ngân sách thấp';
        ELSEIF v_budget_pro >= 20000000 AND v_budget_pro <= 40000000 THEN
			SET p_message = 'Ngân sách trung bình';
        ELSE
			SET p_message = 'Ngân sách cao';
        END IF;
    END //
DELIMITER ;

-- CAU 2
DELIMITER //
	CREATE PROCEDURE sp_complete_assignment_transaction(IN p_assignment_id INT)
    BEGIN
		START TRANSACTION;
        IF completed_date IS NOT NULL THEN
			ROLLBACK;
      
		END IF;
    END //
DELIMITER ;
