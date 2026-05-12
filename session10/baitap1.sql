CREATE DATABASE BAITAP1;

use BAITAP1;

CREATE TABLE patients (
	pat_id INT PRIMARY KEY,
    fullName VARCHAR(100),
    age INT,
    room_nameber INT,
    hiv_status VARCHAR(50),
    mental_health_history VARCHAR(255)
);

INSERT INTO patients (pat_id, fullName, age,room_nameber, hiv_status, mental_health_history)
VALUES
(1, 'Minh Thu', 30, 101, 'negative', 'None'),
(2, 'Hồng Vân', 40, 102, 'positive', 'Anxiety'),
(3, 'Cao Cường', 25, 103, 'negative', 'None');


CREATE VIEW Reception_Patient_View AS
SELECT pat_id, fullName, age, room_nameber
FROM patients
WHERE age >= 0
WITH CHECK OPTION;

SELECT * FROM Reception_Patient_View;


UPDATE Reception_Patient_View 
SET age = 31 
WHERE pat_id = 1;

SELECT * FROM Reception_Patient_View WHERE pat_id = 1;

UPDATE Reception_Patient_View 
SET age = -5 
WHERE pat_id = 1;
