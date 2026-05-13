/*
1. Định nghĩa I/O (Tham số)

Tham số đầu vào (IN):
p_patient_id (INT): Lưu mã bệnh nhân tra cứu.
p_phone (VARCHAR): Lưu số điện thoại tra cứu.

Tham số đầu ra (OUT):
p_total_debt (DECIMAL): Trả về con số tổng nợ cụ thể.
p_status_message (VARCHAR): Trả về câu thông báo trạng thái (thành công/lỗi).
*/

/*
2. Đề xuất 2 giải pháp logic
Giải pháp 1 (Cấu trúc rẽ nhánh): Sử dụng IF...ELSEIF để kiểm tra lần lượt: 
Nếu có ID thì tìm theo ID, nếu ID trống thì mới xét đến Phone, 
nếu cả hai trống thì báo lỗi ngay lập tức.
Giải pháp 2 (Mệnh đề linh hoạt): Sử dụng một câu lệnh SELECT duy nhất với điều kiện WHERE (id = p_id OR phone = p_phone).
 Cách này dựa vào toán học logic để tìm dòng dữ liệu thỏa mãn một trong hai điều kiện.
*/

/*
PHÂN TÍCH LỰA CHỌN GIẢI PHÁP:
-----------------------------------------------------------------------------
| Tiêu chí       | Giải pháp 1: IF...ELSE (Chọn) | Giải pháp 2: WHERE (OR)     |
|----------------|-------------------------------|-----------------------------|
| Độ rõ ràng     | Cao, kiểm soát chặt lỗi nhập  | Trung bình                  |
| Hiệu suất      | Tốt (Tận dụng tối đa Index)   | Có thể chậm khi data lớn    |
| Độ phức tạp    | Code dài hơn một chút         | Code rất ngắn gọn           |
-----------------------------------------------------------------------------
*/





DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),
    OUT p_total_debt DECIMAL(15,2),
    OUT p_status_message VARCHAR(100)
)
BEGIN
    
    DECLARE v_found_debt DECIMAL(15,2) DEFAULT NULL;

   
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET p_total_debt = 0;
        SET p_status_message = 'Lỗi: Vui lòng nhập ID hoặc Số điện thoại để tra cứu!';
    
    ELSE
        
        IF p_patient_id IS NOT NULL THEN
            SELECT total_debt INTO v_found_debt FROM Patients WHERE patient_id = p_patient_id LIMIT 1;
        ELSE
            SELECT total_debt INTO v_found_debt FROM Patients WHERE phone = p_phone LIMIT 1;
        END IF;

     
        IF v_found_debt IS NOT NULL THEN
            SET p_total_debt = v_found_debt;
            SET p_status_message = 'Tra cứu thành công.';
        ELSE
            SET p_total_debt = 0;
            SET p_status_message = 'Thông báo: Không tìm thấy thông tin bệnh nhân này.';
        END IF;
    END IF;
END //

DELIMITER ;

CALL GetPatientDebt(10, NULL, @debt1, @msg1);
SELECT @debt1 AS No, @msg1 AS ThongBao;


CALL GetPatientDebt(NULL, '0901234567', @debt2, @msg2);
SELECT @debt2 AS No, @msg2 AS ThongBao;


CALL GetPatientDebt(NULL, NULL, @debt3, @msg3);
SELECT @debt3 AS No, @msg3 AS ThongBao;

CALL GetPatientDebt(9999, '0000000000', @debt4, @msg4);
SELECT @debt4 AS No, @msg4 AS ThongBao;