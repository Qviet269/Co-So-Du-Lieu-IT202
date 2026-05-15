/*
PHÂN TÍCH:

- Cần 2 trigger:
  + BEFORE INSERT để chặn tạo lịch mới bị trùng giờ
  + BEFORE UPDATE để chặn đổi lịch gây trùng giờ

- Điều kiện kiểm tra:
  + Chỉ kiểm tra các lịch có status <> 'Cancelled'
  + Trigger UPDATE phải bỏ qua chính appointment hiện tại
    bằng: appointment_id <> OLD.appointment_id
*/

USE RikkeiClinicDB;


DROP TRIGGER IF EXISTS trg_CheckDoctorSchedule_Insert;
DROP TRIGGER IF EXISTS trg_CheckDoctorSchedule_Update;


DELIMITER //

CREATE TRIGGER trg_CheckDoctorSchedule_Insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN

    DECLARE total_conflict INT;

    SELECT COUNT(*)
    INTO total_conflict
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled';

    IF total_conflict > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Bac si da co lich hen vao khung gio nay';

    END IF;

END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_CheckDoctorSchedule_Update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    DECLARE total_conflict INT;

    SELECT COUNT(*)
    INTO total_conflict
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled'
        AND appointment_id <> OLD.appointment_id;

    IF total_conflict > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Bac si da co lich hen vao khung gio nay';

    END IF;

END //

DELIMITER ;

-- Khung giờ trống -> Thành công
INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    200,
    1,
    101,
    '2027-08-01 09:00:00',
    'Pending'
);


-- rùng lịch Pending -> Bị chặn
INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    201,
    2,
    101,
    '2027-08-01 09:00:00',
    'Pending'
);


-- Trùng giờ nhưng lịch cũ đã Cancelled -> Thành công
INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    202,
    3,
    101,
    '2026-05-02 10:00:00',
    'Pending'
);

-- update trạng thái chính nó -> Thành công
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 200;