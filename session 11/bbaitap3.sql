USE RikkeiClinicDB;

DELIMITER //

CREATE PROCEDURE CalculateFinalFee(
    IN p_total_cost DECIMAL(15,2),
    IN p_patient_type VARCHAR(20),
    OUT p_final_amount DECIMAL(15,2),
    OUT p_status_message VARCHAR(100)
)
BEGIN
    -- Kiểm tra lỗi chi phí âm (Validate Input)
    IF p_total_cost < 0 THEN
        SET p_final_amount = 0;
        SET p_status_message = 'Lỗi: Chi phí không hợp lệ';
    ELSE
        -- Nếu chi phí hợp lệ, tiến hành tính toán
        IF p_patient_type = 'BHYT' THEN
            SET p_final_amount = p_total_cost * 0.2;
        ELSEIF p_patient_type = 'VIP' THEN
            SET p_final_amount = p_total_cost * 0.9;
        ELSEIF p_patient_type = 'THUONG' THEN
            SET p_final_amount = p_total_cost;
        ELSE
            -- Dự phòng trường hợp nhập sai mã diện bệnh nhân
            SET p_final_amount = p_total_cost; 
        END IF;

        -- Gán thông báo thành công
        SET p_status_message = 'Đã tính toán xong';
    END IF;
END //

DELIMITER ;

CALL CalculateFinalFee(1000000, 'BHYT', @amount_1, @msg_1);
SELECT 'BHYT' AS DienBenhNhan, @amount_1 AS SoTienPhaiThu, @msg_1 AS ThongBao;

CALL CalculateFinalFee(1000000, 'VIP', @amount_2, @msg_2);
SELECT 'VIP' AS DienBenhNhan, @amount_2 AS SoTienPhaiThu, @msg_2 AS ThongBao;

CALL CalculateFinalFee(1000000, 'THUONG', @amount_3, @msg_3);
SELECT 'THUONG' AS DienBenhNhan, @amount_3 AS SoTienPhaiThu, @msg_3 AS ThongBao;

CALL CalculateFinalFee(-500000, 'THUONG', @amount_4, @msg_4);
SELECT 'Test Lỗi' AS DienBenhNhan, @amount_4 AS SoTienPhaiThu, @msg_4 AS ThongBao;