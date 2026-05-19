CREATE DATABASE  StudentManagement;

USE  StudentManagement;


CREATE TABLE students  (
	student_id	VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
	total_debt DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE subjects (
    subject_id VARCHAR(5) PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL,
    credits INT CHECK (credits > 0)
);

CREATE TABLE  grades  (
	student_id VARCHAR(5),
    subject_id VARCHAR(5) ,
    score DECIMAL(4,2) CHECK (score BETWEEN 0 AND 10),
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE grade_log (
	log_id INT PRIMARY KEY AUTO_INCREMENT ,
    student_id VARCHAR(5),
    old_score DECIMAL(4,2),
    new_score DECIMAL(4,2),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- CAU 1
DELIMITER //
	CREATE TRIGGER tg_check_score 
	BEFORE INSERT ON grades
    FOR EACH ROW
    BEGIN
		IF NEW.score < 0 THEN 
			SET NEW.score = 0;
        ELSEIF NEW.score > 10 THEN 
			SET NEW.score = 10;
        END IF;
    END //
DELIMITER ;

INSERT INTO students (student_id, full_name) VALUES (1, 'Nguyễn Văn A');
INSERT INTO grades (student_id, score) VALUES (SV01, -5);
SELECT score FROM grades;

-- CAU 2
START TRANSACTION;
INSERT INTO students (student_id , full_name)
VALUES 
('SV02', 'Ha Bich Ngoc' );
UPDATE students
SET total_debt = 5000000
WHERE student_id = 'SV02';
COMMIT;

-- CAU 3
DELIMITER //
	CREATE TRIGGER tg_log_grade_update  
    AFTER UPDATE ON grades
    FOR EACH ROW
    BEGIN
		IF NEW.score != OLD.score THEN
			INSERT grade_log  (student_id, old_score , new_score, change_date)
            VALUES (OLD.student_id,  OLD.score, NEW.score, NOW());
		END IF;
    END //
DELIMITER ;

-- CAU 4

DELIMITER //
CREATE PROCEDURE sp_pay_tuition()
BEGIN
    DECLARE current_debt INT;

    START TRANSACTION;

    UPDATE students
    SET total_debt = total_debt - 2000000
    WHERE student_id = 'SV01';


    SELECT total_debt INTO current_debt
    FROM students
    WHERE student_id = 'SV01';


    IF current_debt < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;

END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_prevent_pass_update
BEFORE UPDATE
ON grades
FOR EACH ROW
BEGIN
    IF OLD.score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sinh vien da qua mon, khong duoc phep sua diem';
    END IF;
END //

DELIMITER ;
