
USE RikkeiClinicDB;

UPDATE Appointments
SET appointment_date = '2026-01-01 08:00:00'
WHERE appointment_id = 104;

DROP TRIGGER IF EXISTS PreventPastAppointments;

DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.appointment_date < NOW() THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Khong duoc doi lich kham ve thoi diem trong qua khu';

    END IF;
END //
DELIMITER ;

-- TEST LẠI

-- Test lỗi: phải bị chặn
UPDATE Appointments
SET appointment_date = '2025-01-01 09:00:00'
WHERE appointment_id = 104;


-- Test hợp lệ: phải cập nhật thành công
UPDATE Appointments
SET appointment_date = '2027-07-20 10:30:00'
WHERE appointment_id = 104;



/*
OLD.appointment_date là ngày cũ đang có trong database,
còn NEW.appointment_date là ngày mới người dùng vừa cập nhật.

Trigger cũ kiểm tra OLD nên không phát hiện người dùng đổi lịch về quá khứ.
Muốn chặn đúng phải kiểm tra NEW.appointment_date.
*/