

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT, IN p_new_bed_id INT)
BEGIN

        UPDATE Beds 
        SET patient_id = NULL 
        WHERE patient_id = p_patient_id;


        UPDATE Beds 
        SET patient_id = p_patient_id 
        WHERE bed_id = p_new_bed_id;

    COMMIT;
END //

DELIMITER ;

/*
cấy ni vi phạm Tính nguyên tử (Atomicity) 
vì nguyên lý này bắt buộc quy trình chuyển giường phải thành công trọn vẹn cả 2 bước (All), 
nếu xảy ra lỗi giữa chừng thì phải hủy bỏ toàn bộ (Nothing) để dữ liệu không bị dở dang
*/

DROP PROCEDURE IF EXISTS TransferBed;

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT, IN p_new_bed_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

        UPDATE Beds 
        SET patient_id = NULL 
        WHERE patient_id = p_patient_id;

        UPDATE Beds 
        SET patient_id = p_patient_id 
        WHERE bed_id = p_new_bed_id;

    COMMIT;
END //

DELIMITER ;

SELECT * FROM Beds WHERE patient_id = 1 OR bed_id = 5;

CALL TransferBed(1, 5);

SELECT * FROM Beds WHERE patient_id = 1 OR bed_id = 5;

SELECT * FROM Beds WHERE patient_id = 1;