CREATE DATABASE products_management;
use products_management;

create table products(
	pro_id char(5) primary key,
    pro_name varchar(100) not null,
    pro_price decimal(10, 2) not null,
    pro_stock int default 0
);

create table orders(
	or_id int primary key auto_increment,
    or_quantity int,
    or_date datetime default current_timestamp,
    pro_id char(5),
    foreign key (pro_id) references products(pro_id)
);

insert into products
values('p001', 'Ao so mi', 10000, 5),
('p002', 'Ao thun', 17000, 7),
('p003', 'Ao khoac', 15000, 10),
('p004', 'Quan tay', 30000, 8),
('p005', 'Quan short', 20000, 12);

-- ÁP DỤNG TRIGGER VÀO BÀI, TẠO TRIGGER ĐỂ XỬ LÝ VIỆC SAU
-- YÊU CẦU 1: TRƯỚC KHI THÊM 1 SẢN PHẨM MỚI HÃY IN HOA TÊN SẢN PHẨM VÀ LƯU VÀO BẢNG

DELIMITER //
	CREATE TRIGGER trigger_before_insert_products
    BEFORE INSERT ON products
    FOR  EACH ROW -- ÁP DỤNG CHO TỪNG BẢN GHI 
    BEGIN
		-- LOGIC: IN HOA TÊN SẢN PHẨM
        SET NEW.pro_name = UPPER(NEW.pro_name);
    END //
DELIMITER ;

insert into products
values('p006', 'Ao dài', 13000, 8);

-- yêu cầu 2: trước khi tao đơn hàng phải kiếm tra số lương tồn kho có 
-- lớn hơn số lượng được mua hay không

DELIMITER //
	CREATE TRIGGER trigger_before_insert_orders
    BEFORE INSERT ON orders
    FOR EACH ROW
    BEGIN
		-- B1: TRUY CẬP VÀO BẢNG PRODUCTS ĐỂ LẤY RA SỐ LƯỢNG TỒN KHO
        -- B2: LƯU SỐ LƯỢNG TỒN KHO VÀO MỘT BIẾN
		DECLARE v_stock INT;
        SET v_stock = (SELECT pro_stock FROM products WHERE pro_id = NEW.pro_id);
        -- B3: KIẾM TRA XEM SỐ LƯỢNG MUA CÓ LỚN HƠN SỐ LƯỢNG TỒN KHO KHÔNG
        IF NEW.or_quantity > v_stock THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'không đủ hàng  trong kho';
		END IF;
    END //
DELIMITER ;

insert into orders
values(NULL, 5, default, 'p002');

-- yêu cầu 3: sau khi tạo đơn hàng thành công, giảm đi số lượng tồn kho

DELIMITER //
	CREATE TRIGGER trigger_after_insert_orders
    AFTER INSERT ON orders
    FOR EACH ROW
    BEGIN
		UPDATE products
        SET pro_stock = pro_stock - NEW.or_quantity
        WHERE pro_id = NEW.pro_id;
    END //
DELIMITER ;
INSERT INTO orders(or_id, or_quantity, pro_id) 
VALUES (10, 2, 'p001');
insert into orders
values(NULL, 5, default, 'p002');

-- YÊU CẦU 4: TRƯỚC KHI CẬP NHẬT SỐ LƯỢNG ĐƠN HÀNG, YÊU CẦU
-- SỐ LƯỢNG MỚI KHÔNG ĐƯỢC PHÉP NHỎ HƠN SỐ LƯỢNG BAN ĐẦU

DELIMITER //
	CREATE TRIGGER trigger_before_insert_orders
    BEFORE INSERT ON orders
    FOR EACH ROW
    BEGIN
		IF NEW.or_quantity < OLD.or_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SỐ LƯỢNG MỚI KHÔNG ĐƯỢC LỚN HƠN';
        END IF;
    END //
DELIMITER ;

-- YÊU CẦU 5: SAU KHI XÓA ĐƠN HÀNG, HÃY LƯU THÔNG TIN ĐƠN HÀNG VÙA XÓA VÀO BẢNG HISTORY _

create table history_logs (
	id_log int primary key auto_increment,
    event_log varchar(100) not null,
    descripstion text,
    date_log datetime default current_timestamp
);

DELIMITER //
CREATE TRIGGER tg_after_delete_order
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
	INSERT INTO history_logs (event_log, descripstion)
    VALUES (
        'XÓA ĐƠN HÀNG', 
        CONCAT('Đã xóa đơn hàng mã: ', OLD.or_id, ', Mã SP: ', OLD.pro_id)
    );

    
    UPDATE products 
    SET pro_stock = pro_stock + OLD.or_quantity 
    WHERE pro_id = OLD.pro_id;
END //
DELIMITER ;

DELETE FROM orders WHERE or_id = 10 ;

SELECT * FROM history_logs;

