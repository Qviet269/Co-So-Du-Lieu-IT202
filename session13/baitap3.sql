/*
PHÂN TÍCH:

- Nên tạo bảng Price_Changes_Log gồm:
  medicine_id, old_price, new_price, status_change, difference_amount, changed_at
  để lưu lịch sử thay đổi giá thuốc.

- Trigger nên dùng BEFORE UPDATE để:
  + Chặn giá <= 0 trước khi cập nhật
  + Dùng OLD.price và NEW.price để xác định tăng/giảm giá
  + Chỉ INSERT log khi giá thật sự thay đổi
*/
USE RikkeiClinicDB;


CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(18,2),
    new_price DECIMAL(18,2),
    status_change VARCHAR(20),
    difference_amount DECIMAL(18,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (medicine_id)
    REFERENCES Medicines(medicine_id)
);


DROP TRIGGER IF EXISTS trg_LogMedicinePriceChanges;

DELIMITER //

CREATE TRIGGER trg_LogMedicinePriceChanges
BEFORE UPDATE ON Medicines
FOR EACH ROW
BEGIN

    -- Chặn giá âm hoặc bằng 0
    IF NEW.price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Gia thuoc moi khong hop le';

    END IF;


    -- Chỉ xử lý khi giá thay đổi
    IF NEW.price <> OLD.price THEN

        -- Trường hợp tăng giá
        IF NEW.price > OLD.price THEN

            INSERT INTO Price_Changes_Log(
                medicine_id,
                old_price,
                new_price,
                status_change,
                difference_amount
            )
            VALUES(
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'TANG GIA',
                NEW.price - OLD.price
            );

        END IF;

        IF NEW.price < OLD.price THEN

            INSERT INTO Price_Changes_Log(
                medicine_id,
                old_price,
                new_price,
                status_change,
                difference_amount
            )
            VALUES(
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'GIAM GIA',
                OLD.price - NEW.price
            );

        END IF;

    END IF;

END //

DELIMITER ;



UPDATE Medicines
SET price = 20000
WHERE medicine_id = 1;



UPDATE Medicines
SET price = 12000
WHERE medicine_id = 1;


UPDATE Medicines
SET stock = 300
WHERE medicine_id = 1;


-- 4. Giá âm -> bị chặn
UPDATE Medicines
SET price = -5000
WHERE medicine_id = 1;