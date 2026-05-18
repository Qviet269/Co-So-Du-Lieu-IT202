DROP PROCEDURE IF EXISTS DispenseMedicine;

DELIMITER //

CREATE PROCEDURE DispenseMedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_status_message VARCHAR(255)
)
BEGIN
  
    DECLARE v_current_stock INT;
    DECLARE v_price DECIMAL(18,2);


    START TRANSACTION;
    
    SELECT stock, price INTO v_current_stock, v_price
    FROM Medicines
    WHERE medicine_id = p_medicine_id
    FOR UPDATE;

    IF p_quantity > v_current_stock THEN
        ROLLBACK;
        SET p_status_message = 'Lỗi: Số lượng tồn kho không đủ';
    ELSE

        UPDATE Medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;

        UPDATE Patient_Invoices
        SET total_due = total_due + (p_quantity * v_price)
        WHERE patient_id = p_patient_id;

        COMMIT;
        SET p_status_message = 'Đã cấp phát thành công';
    END IF;
END //
DELIMITER ;

CALL DispenseMedicine(1, 1, 2, @thongbao);

SELECT @thongbao AS 'Trạng thái hệ thống';
