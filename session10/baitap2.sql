CREATE DATABASE IF NOT EXISTS baitap2;
USE baitap2;


DROP TABLE IF EXISTS Patients;


CREATE TABLE Patients  (
    pat_id INT AUTO_INCREMENT PRIMARY KEY, 
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    age INT NOT NULL,
    address VARCHAR(255) NOT NULL
);

DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        
        INSERT INTO Patients (full_name, phone, age, address)
        VALUES (CONCAT('Patient ', i), CONCAT('090', i), FLOOR(RAND()*100), 'Ho Chi Minh City');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;


CALL SeedPatients();

SELECT * FROM Patients WHERE phone = '090450000';

EXPLAIN SELECT * FROM Patients WHERE phone = '090450000';

CREATE INDEX idx_phone ON Patients(phone);

-- YÊU CẦU 2
DELIMITER //
CREATE PROCEDURE TestInsertSpeed()
BEGIN
    DECLARE j INT DEFAULT 1;
    WHILE j <= 1000 DO
        INSERT INTO Patients (full_name, phone, age, address)
        VALUES (CONCAT('NewPatient ', j), CONCAT('091', j), 30, 'Hanoi');
        SET j = j + 1;
    END WHILE;
END //
DELIMITER ;

CALL TestInsertSpeed();


ALTER TABLE Patients DROP INDEX idx_phone;


DELETE FROM Patients WHERE full_name LIKE 'NewPatient%';

CALL TestInsertSpeed();

/*
- Tốc độ Đọc (SELECT): Tăng cực nhanh (từ vài giây xuống mili-giây) 
vì máy tính dùng Mục lục (B-Tree) phi thẳng đến đích, không phải quét toàn bộ bảng.

- Tốc độ Ghi (INSERT/UPDATE): Bị chậm lại một chút vì máy tính vừa phải ghi dữ liệu, 
vừa phải mất công sắp xếp lại "cuốn mục lục" Index cho đúng thứ tự.

- Tài nguyên: Tốn thêm dung lượng ổ cứng để lưu trữ file Index.
*/