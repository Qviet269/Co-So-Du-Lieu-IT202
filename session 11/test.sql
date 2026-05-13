use social_network_pro;

delimiter //
	CREATE PROCEDURE getAllUser()
    -- YEU CAU 1;  LẤY DANH SÁCH USER  CÓ ĐĂNG BÀI VÀ NAM SỐNG Ở THÀNH PHỐ HCM
    -- YÊU CẦU 2: GOM NHÓM VÀ HIỂN THỊ CỘT SỐ LƯỢNG BÀI ĐĂNG
    BEGIN
		SELECT U.user_id, U.username, COUNT(U.user_id) AS SO_LUONG
        FROM users U
        JOIN posts P
        ON U.user_id = P.user_id
        WHERE U.gender = 'Nam' AND hometown = 'TP.HCM'
        GROUP BY U.user_id, U.username;
	END //
delimiter ;
-- GỌI THỦ TỤC
CALL getAllUser();

-- HÀM CÓ THAM SỐ (IN ,OUT, INOUT)
-- TẠO THỦ TỤC VÀ LẤY RA DANH SÁCH NGƯỜI DÙNG CÓ ID LỚN HƠN
-- ID DO NGƯỜI DÙNG NHẬP VÀO (VÍ DỤ NGƯỜI DÙNG NHẬP ID = 5)
-- THÌ LẤY RA DANH SÁCH USER CÓ ID LỚN HƠN 5

DELIMITER //
CREATE PROCEDURE get_users (IN id_min INT)
	BEGIN 
		SELECT * FROM users
        WHERE user_id > id_min;
    END //
DELIMITER ;

CALL get_users(5);

-- THAM SỐ OUT 
-- YÊU CẦU3 : TẠO THỦ TỤC VÀ TRẢ VỀ GIÁ TRỊ TỔNG SỐ LƯỢNG USER
DELIMITER //
CREATE PROCEDURE get_quantity (out total_id INT)
	BEGIN 
		SET total_id = (SELECT COUNT(user_id) FROM users);
    END //
DELIMITER ;


CALL get_quantity(@total_id);
SELECT @total_id;

-- YÊU CẦU 4: TẠO THỦ TỤC TRUYỀN VÀO 2 THAM SÓO IN VÀ OUT
-- THAM SỐ IN LÀ SINH CỦA NGƯỜI DÙNG, OUT LÀ THAM SỐ TRẢ VỀ GIÁ TRỊ TUỔI

DELIMITER //
CREATE PROCEDURE number_age_your(IN birth_day INT, out age_Number INT)
	BEGIN 
		SET age_Number = YEAR(CURDATE()) - birth_day;
    END //
DELIMITER ;

CALL number_age_your (2007, @age_Number);
SELECT @age_Number
-- YÊU CẦU 5: DÙNG THAM SỐ INOUT ĐỂ LÀ BÀI TRÊN


DELIMITER //
CREATE PROCEDURE number_age_your(INOUT birth_day INT )
	BEGIN 
		SET birth_day = YEAR(CURDATE()) - birth_day;
    END //
DELIMITER ;

SET @birth_day = 2007;
CALL number_age_your (@birth_day);
SELECT @birth_day;


DELIMITER //
CREATE PROCEDURE getCountUser ( )
-- yêu cầu 7: tạo thủ tục nếu như tổng số lượng user > 15 thì chỉ hiện thị
-- các user có id là số chắno sql
-- ngược lại thì hiển thị toàn bộ 
	BEGIN 
		declare total_user  int default 0;
        select count(user_id) into total_user from users;
        if total_user > 15 then
        select  * from users
        where user_id % 2 = 0;
        else  select  * from users;
        end if;
    END //
DELIMITER ;
CALL getCountUser ();



