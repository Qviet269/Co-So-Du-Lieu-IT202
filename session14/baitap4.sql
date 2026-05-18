
/*
PHẦN A: PHÂN TÍCH & ĐỀ XUẤT GIẢI PHÁP
1. Định nghĩa Tham số I/O:
   - p_patient_id INT - IN: Mã bệnh nhân thực hiện giao dịch.
   - p_payment_amount DECIMAL(18,2) - IN: Số tiền yêu cầu thanh toán.
   - p_status_message VARCHAR(255) - OUT: Thông báo trạng thái trả về màn hình.

2. Đề xuất chiến lược xử lý:
   - Chiến lược 1 (Bị động): Mở giao dịch và cập nhật ngay. Đợi cấu trúc bảng văng 
     lỗi âm tiền rồi dùng SQLEXCEPTION để ROLLBACK.
   - Chiến lược 2 (Chủ động): Mở giao dịch, chủ động lấy số dư lên kiểm tra trước 
     bằng lệnh IF...ELSE. Nếu thiếu tiền thì tự động ROLLBACK ngay.

3. So sánh & Lựa chọn:
   - Chiến lược 1: Code ngắn nhưng khó tùy biến câu thông báo lỗi, dễ hiện chữ tiếng Anh.
   - Chiến lược 2: Kiểm soát luồng chặt chẽ, báo lỗi tiếng Việt thân thiện, an toàn tuyệt đối.
   => QUYẾT ĐỊNH: Chọn Chiến lược 2 (Chủ động đối chiếu).
*/

/*
PHẦN B: THIẾT KẾ LUỒNG XỬ LÝ TUẦN TỰ
   - Bước 1: Kiểm tra số tiền đầu vào (Nếu <= 0 thì chặn ngay từ vòng gửi xe).
   - Bước 2: Khởi tạo giao dịch an toàn (START TRANSACTION).
   - Bước 3: Đọc số dư ví hiện tại và khóa dòng dữ liệu lại (FOR UPDATE).
   - Bước 4: So sánh số dư với số tiền cần thanh toán (Nếu thiếu -> ROLLBACK).
   - Bước 5: Nếu đủ điều kiện -> Cập nhật đồng bộ trừ tiền ví và giảm nợ viện phí.
   - Bước 6: Xác nhận lưu dữ liệu vĩnh viễn (COMMIT) + Trả thông báo thành công.
*/
DROP PROCEDURE IF EXISTS ProcessPayment;

DELIMITER //

CREATE PROCEDURE ProcessPayment(
    IN p_patient_id INT,
    IN p_payment_amount DECIMAL(18,2),
    OUT p_status_message VARCHAR(255)
)
BEGIN

    DECLARE v_wallet_balance DECIMAL(18,2);


    IF p_payment_amount <= 0 THEN
        SET p_status_message = 'Lỗi: Số tiền thanh toán phải lớn hơn 0!';
    ELSE
        START TRANSACTION;

        SELECT balance INTO v_wallet_balance
        FROM Wallets
        WHERE patient_id = p_patient_id
        FOR UPDATE;

        IF v_wallet_balance < p_payment_amount THEN
            ROLLBACK;
            SET p_status_message = 'Lỗi: Số dư ví không đủ để thanh toán!';
        ELSE
            
            UPDATE Wallets
            SET balance = balance - p_payment_amount
            WHERE patient_id = p_patient_id;

            UPDATE Patient_Invoices
            SET total_due = total_due - p_payment_amount
            WHERE patient_id = p_patient_id;

            COMMIT;
            SET p_status_message = 'Đã thanh toán thành công!';
        END IF;
        
    END IF;
END //

CALL ProcessPayment(1, 200000, @thongbao);
SELECT @thongbao AS 'Kết quả Nghiệm thu 1';

CALL ProcessPayment(1, 900000, @thongbao);
SELECT @thongbao AS 'Kết quả Nghiệm thu 2';

CALL ProcessPayment(1, -50000, @thongbao);
SELECT @thongbao AS 'Kết quả Nghiệm thu 3';