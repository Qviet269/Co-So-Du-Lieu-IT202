USE RikkeiClinicDB;

DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    -- Cập nhật trạng thái lịch khám thành "Đã hủy"
    UPDATE appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id;
END //
DELIMITER ;

CALL CancelAppointment(105);
SELECT * FROM Appointments WHERE appointment_id = 105;
/*
Lỗi xảy ra do câu lệnh UPDATE trong mã nguồn chỉ tìm kiếm dựa trên appointment_id mà thiếu điều kiện kiểm tra trạng thái hiện tại. Do đó, hệ thống sẽ tự động chuyển trạng thái của mọi lịch khám được truyền vào thành 'Cancelled',
 bất kể lịch đó đã hoàn tất hay chưa.
*/
DROP PROCEDURE IF EXISTS CancelAppointment;
DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    -- Cập nhật trạng thái lịch khám thành "Đã hủy"
    UPDATE appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id AND status = 'Pending';
END //
DELIMITER ;