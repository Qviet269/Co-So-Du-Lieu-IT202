USE RikkeiClinicDB;


UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;


DROP TRIGGER IF EXISTS PreventStatusRevert;

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Khong duoc thay doi lich kham da Completed';

    END IF;

END //

DELIMITER ;



-- Hợp lệ: Pending -> Completed
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;


-- Bị chặn: Completed -> Cancelled
UPDATE Appointments
SET status = 'Cancelled'
WHERE appointment_id = 105;



/*
Để kiểm tra lịch khám đã hoàn thành trước đó hay chưa
phải dùng OLD.status vì đây là giá trị cũ đang tồn tại trong database.

NEW.status là trạng thái mới người dùng muốn cập nhật vào.
*/