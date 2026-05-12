CREATE DATABASE BAITAP_TONGHOP;

USE BAITAP_TONGHOP;


CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(20),
    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patient
        FOREIGN KEY (Patient_ID)
        REFERENCES Patients(Patient_ID)
);

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES
('BN001', 'Nguyen Van A'),
('BN002', 'Tran Thi B'),
('BN003', 'Le Van C');

INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure)
VALUES
('BN001', 72, '120/80'),
('BN001', 75, '118/79'),
('BN002', 90, '130/85'),
('BN003', 68, '110/70'),
('BN003', 80, '125/82');


CREATE INDEX idx_patient_record
ON Vitals_Logs(Patient_ID, Record_Time DESC);

CREATE OR REPLACE VIEW ER_Dashboard_View AS
SELECT P.Patient_ID, P.Full_Name, COALESCE(V.Heart_Rate, 'Pending'), 
CASE
	WHEN V.Heart_Rate > 120 OR V.Heart_Rate < 50 THEN 'CRITICAL'
    ELSE 'STABLE'
END AS Urgency_Level
FROM Patients P
JOIN Vitals_Logs  V
ON V.Patient_ID = P.Patient_ID;

SELECT * FROM ER_Dashboard_View;

