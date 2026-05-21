CREATE DATABASE monitoring_system;

USE monitoring_system;

-- trạm phát sóng
CREATE TABLE telecom_towers(
	tower_id INT PRIMARY KEY AUTO_INCREMENT,
    tower_name VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100) UNIQUE,
    location_zone VARCHAR(100) NOT NULL,
    commission_date DATE  
);

-- Kỹ sư vận hành
CREATE TABLE engineers (
	engineer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    skill_level VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    safety_rating DECIMAL(3, 1) DEFAULT 5.0 CHECK (safety_rating >= 0.0 AND safety_rating <= 5.0)
);

-- lệnh báo trì
CREATE TABLE maintenance_orders (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    tower_id INT,
    engineer_id INT,
    scheduled_time DATETIME NOT NULL,
    operation_cost DOUBLE UNSIGNED,
    order_status VARCHAR(50) CHECK (order_status IN ('Assigned', 'Executed', 'Aborted')),
    
   
    FOREIGN KEY (tower_id) REFERENCES telecom_towers(tower_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
); 

-- Nhật ký kỹ thuật
CREATE TABLE technical_logs (
	log_id INT PRIMARY KEY,
    order_id INT,
    hardware_status VARCHAR(100) NOT NULL,
    bandwidth_cap VARCHAR(100) NOT NULL,
    action_taken TEXT,
    created_at DATE DEFAULT (CURDATE()),
    FOREIGN KEY (order_id) REFERENCES maintenance_orders(order_id)
);

-- lịch sử sung đột thiết bị
CREATE TABLE incident_reports (
	incident_id INT PRIMARY KEY AUTO_INCREMENT,
    log_id INT,
    engineer_id INT,
    reported_time DATETIME NOT NULL,
    root_cause TEXT,
    
  
    FOREIGN KEY (log_id) REFERENCES technical_logs(log_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);

-- telecom_towers  (Trạm phát sóng)
INSERT INTO telecom_towers 
(tower_id, tower_name, serial_number, location_zone, commission_date) VALUES
(1, 'Trạm Đông Đô', 'SN-9901-X', 'Zone A', '1999-12-03'),
(2, 'Trạm Tây Sơn', 'SN-9902-Y', 'Zone B', '1996-11-25'),
(3, 'Trạm Nam Hải', 'SN-9903-Z', 'Zone C', '2001-07-08'),
(4, 'Trạm Bắc Bình', 'SN-9904-W', 'Zone A', '1998-01-19'),
(5, 'Trạm Trung Trung', 'SN-9905-V', 'Zone D', '2000-09-30');

--  Thêm dữ liệu bảng ENGINEERS (Kỹ sư vận hành)
INSERT INTO engineers (engineer_id, full_name, skill_level, phone_number, safety_rating) VALUES
(1, 'KS. Nguyễn Văn Hải', 'Bậc 5', '0931112223', 4.8),
(2, 'KS. Trần Thu Hà', 'Bậc 4', '0932223334', 5.0),
(3, 'KS. Lê Quốc Tuấn', 'Bậc 6', '0933334445', 4.6),
(4, 'KS. Phạm Minh Châu', 'Bậc 3', '0934445556', 4.9),
(5, 'KS. Hoàng Gia Bảo', 'Bậc 5', '0935556667', 4.7);

--  Thêm dữ liệu bảng MAINTENANCE_ORDERS (Lệnh bảo trì)
INSERT INTO maintenance_orders 
(order_id, tower_id, engineer_id, scheduled_time, operation_cost, order_status) VALUES
(7001, 1, 1, '2024-05-20 08:00:00', 200000, 'Assigned'),
(7002, 2, 2, '2024-05-20 09:30:00', 250000, 'Executed'),
(7003, 3, 3, '2024-05-20 10:15:00', 300000, 'Assigned'),
(7004, 4, 5, '2024-05-21 07:00:00', 350000, 'Executed'),
(7005, 5, 4, '2024-05-21 08:45:00', 220000, 'Aborted');

--  Thêm dữ liệu bảng TECHNICAL_LOGS (Nhật ký kỹ thuật)
INSERT INTO technical_logs (log_id, order_id, hardware_status, bandwidth_cap, action_taken, created_at) VALUES
(8001, 7002, 'Nhiệt độ cao', '150 Mbps', 'Xả tải, tra keo tản nhiệt', '2024-05-20 10:00:00'),
(8002, 7004, 'Sụt nguồn nhẹ', '300 Mbps', 'Đấu nối lại lốc nguồn phụ', '2024-05-21 08:00:00'),
(8003, 7001, 'Nhiễu tần số', '100 Mbps', 'Cấu hình lại bộ lọc sóng', '2024-05-20 09:00:00'),
(8004, 7003, 'Suy hao quang', '200 Mbps', 'Thay mới dây nhảy quang', '2024-05-20 11:00:00'),
(8005, 7005, 'Lỗi cổng chào', '0 Mbps', 'Không xử lý do lệnh hủy', '2024-05-21 09:00:00');

--  Thêm dữ liệu bảng INCIDENT_REPORTS (Lịch sử xung đột thiết bị)
INSERT INTO incident_reports (incident_id, log_id, engineer_id, reported_time, root_cause) VALUES
(1, 8003, 1, '2024-05-20 09:05:00', 'Đã kiểm tra xung đột tần số'),
(2, 8001, 2, '2024-05-20 10:05:00', 'Hoàn tất cấu hình phần cứng'),
(3, 8004, 3, '2024-05-20 11:10:00', 'Phát hiện đứt cáp ngầm nhẹ'),
(4, 8002, 5, '2024-05-21 08:10:00', 'Đạt độ ổn định công suất'),
(5, 8005, 4, '2024-05-21 09:05:00', 'Trạm dừng hoạt động ngoại cảnh');

-- phần 2
-- câu 2
UPDATE maintenance_orders
SET operation_cost = operation_cost * 1.10
WHERE order_status = 'Executed'
AND tower_id IN (
	SELECT tower_id FROM telecom_towers
    WHERE YEAR(commission_date) < 2000
);

SELECT * FROM maintenance_orders;

DELETE FROM incident_reports
WHERE reported_time <  '2024-05-20';
SELECT * FROM incident_reports;

-- PHẦN 3
-- CÂU 1
SELECT full_name, skill_level, safety_rating  FROM engineers
WHERE safety_rating > 4.7 OR skill_level = 'Bậc 4';

-- CAU 2
SELECT tower_name, serial_number FROM telecom_towers
WHERE commission_date BETWEEN '1998-01-01' AND '2001-12-31' 
AND serial_number LIKE 'SN-990%';

-- CAU 3
SELECT order_id, scheduled_time, operation_cost FROM maintenance_orders
ORDER BY operation_cost DESC
LIMIT 2 OFFSET 2;

-- PHAN 4
-- CAU 1
SELECT T.tower_name, E.full_name, E.skill_level, M.operation_cost, M.scheduled_time 
FROM maintenance_orders M
JOIN telecom_towers T
ON T.tower_id = M.tower_id
JOIN engineers E 
ON E.engineer_id = M.engineer_id;

-- CAU 2
SELECT E.full_name, SUM(M.operation_cost) AS total_cost
FROM maintenance_orders M
JOIN engineers E
ON E.engineer_id = M.engineer_id
WHERE M.order_status = 'Executed'
GROUP BY E.full_name
HAVING SUM(M.operation_cost) > 500000;

-- CAU 3 
SELECT  engineer_id, full_name, safety_rating 
FROM engineers
WHERE safety_rating = (SELECT MAX(safety_rating) FROM engineers);

-- PHAN 5
CREATE  INDEX  idx_order
ON maintenance_orders (order_status, operation_cost);

DROP VIEW view_engineers ;
CREATE VIEW view_engineers AS
SELECT E.full_name, COUNT(M.order_id) AS total_soluong, SUM(M.operation_cost) AS total_cost
FROM maintenance_orders M
JOIN engineers E
ON E.engineer_id = M.engineer_id
WHERE M.order_status <> 'Aborted'
GROUP BY E.full_name;
SELECT * FROM view_engineers;

-- PHẦN 6
-- CAU 1
DELIMITER //
	CREATE TRIGGER trigger_after_update_maintenance
	AFTER UPDATE ON maintenance_orders
    FOR EACH ROW
	BEGIN
		IF NEW.order_status = 'Executed' THEN
			INSERT INTO incident_reports(log_id, engineer_id, root_cause, reported_time)
			VALUES ((SELECT log_id FROM technical_logs WHERE order_id = NEW.order_id),
			NEW.engineer_id, 'System check completed', NOW()
        );
        END IF;
    END//
DELIMITER ;


DELIMITER //
	CREATE TRIGGER trigger_after_update_maintenance
	AFTER INSERT ON maintenance_orders
    FOR EACH ROW
    BEGIN
		IF NEW.order_status = 'Executed' THEN
			UPDATE engineers
            SET safety_rating = CASE
									WHEN (safety_rating + 0.1) > 5.0 THEN 5.0
                                    ELSE safety_rating + 0.1
                                    END
			WHERE engineer_id = NEW.engineer_id;
		END IF;
    END//
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE pr_stored_engineer (
			IN p_engineer_id INT, 
            OUT p_message VARCHAR(50)
            )
    BEGIN
		DECLARE v_total_cost DECIMAL(18,2);
        SELECT SUM(operation_cost) INTO v_total_cost FROM maintenance_orders 
        WHERE order_status = 'Executed';
        
        IF v_total_cost > 1000000 THEN
			SET p_message =  'High budget management';
		ELSEIF v_total_cost = 1000000 THEN
			SET p_message =  'Target budget met';
		ELSE SET p_message =  'Normal status';
        END IF;
    END //
DELIMITER ;
-- CÂU 2
DROP PROCEDURE IF EXISTS sp_reassign_engineer;

DELIMITER //
CREATE PROCEDURE sp_reassign_engineer(
    IN p_order_id INT,        
    IN p_new_engineer_id INT   
)
BEGIN
    
END//
DELIMITER ;