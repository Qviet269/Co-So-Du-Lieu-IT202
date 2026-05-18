
DELIMITER //
	CREATE PROCEDURE PayHospitalFee(IN p_patient_id INT, IN p_amount DECIMAL(18,2))
		BEGIN
  
			UPDATE Wallets SET balance = balance - p_amount WHERE patient_id = p_patient_id;
    

			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Hệ thống gặp sự cố mạng đột ngột!';
    
  
			UPDATE Patient_Invoices SET total_due = total_due - p_amount WHERE patient_id = p_patient_id;
		END //
DELIMITER ;

CALL PayHospitalFee(1, 500000);
SELECT * FROM Wallets WHERE patient_id = 1;
SELECT * FROM Patient_Invoices WHERE patient_id = 1;

/*
Giải thích vi phạm nguyên lý ACID:

Sự cố "tiền đã trừ nhưng nợ không giảm" đang vi phạm đặc tính Atomicity (Tính nguyên tử) 
trong nguyên lý ACID.
Đặc tính này bắt buộc một giao dịch phải theo quy tắc "All or Nothing" 
– nghĩa là toàn bộ các thao tác (trừ tiền ví và giảm nợ hóa đơn) 
phải cùng thành công trọn vẹn, hoặc nếu có lỗi giữa chừng thì phải bị hủy bỏ hoàn 
toàn (Rollback) để không làm dở dang dữ liệu hệ thống.
*/

DROP PROCEDURE IF EXISTS PayHospitalFee;



DELIMITER //

CREATE PROCEDURE PayHospitalFee(IN p_patient_id INT, IN p_amount DECIMAL(18,2))
BEGIN
   
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

  
    START TRANSACTION;

    UPDATE Wallets 
    SET balance = balance - p_amount 
    WHERE patient_id = p_patient_id;
    
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Hệ thống gặp sự cố mạng đột ngột!';
    
    UPDATE Patient_Invoices 
    SET total_due = total_due - p_amount 
    WHERE patient_id = p_patient_id;

    COMMIT;
END //

DELIMITER ;

