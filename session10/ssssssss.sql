CREATE DATABASE IF NOT EXISTS final_review;
USE final_review;

-- ==========================================
-- PHẦN 1: TẠO BẢNG (DDL)
-- ==========================================

CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    hq_country VARCHAR(50) NOT NULL, -- Đã sửa lỗi chính tả
    budget_cap DECIMAL(15,2) NOT NULL,
    current_rank INT DEFAULT 0 
);

CREATE TABLE drivers(
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    driver_number INT UNIQUE NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    annual_salary DECIMAL(12,2) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE constructors_championship( -- Đã thêm 's' để khớp với câu INSERT
    championship_id INT AUTO_INCREMENT PRIMARY KEY, -- Đã sửa lỗi chính tả
    season_year YEAR NOT NULL,
    team_id INT,
    total_points DECIMAL(5,1) DEFAULT 0.0,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE races(
    race_id INT AUTO_INCREMENT PRIMARY KEY,
    race_name VARCHAR(100) NOT NULL,
    circuit_name VARCHAR(100) NOT NULL,
    race_date DATETIME NOT NULL,
    race_status VARCHAR(30) DEFAULT 'Scheduled'
);

CREATE TABLE race_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT,
    race_id INT,
    grid_position INT NOT NULL,
    finish_position INT,
    points_earned DECIMAL(4,1) DEFAULT 0.0,
    fastest_lap_speed DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (race_id) REFERENCES races(race_id)
);

-- ==========================================
-- CÂU 1 – INSERT: CHÈN DỮ LIỆU MẪU
-- ==========================================

INSERT INTO teams (team_name, hq_country, budget_cap, current_rank) 
VALUES 
('Red Bull Racing', 'Austria', 140000000.00, 1),
('Mercedes', 'Germany', 135000000.00, 2),
('Ferrari', 'Italy', 138000000.00, 3),
('McLaren', 'Great Britain', 130000000.00, 4),
('Aston Martin', 'Great Britain', 125000000.00, 5);

INSERT INTO drivers (full_name, driver_number, nationality, annual_salary, team_id) 
VALUES 
('Max Verstappen', 1, 'Dutch', 55000000.00, 1),
('Lewis Hamilton', 44, 'British', 45000000.00, 2),
('Charles Leclerc', 16, 'Monegasque', 34000000.00, 3),
('Lando Norris', 4, 'British', 20000000.00, 4),
('Fernando Alonso', 14, 'Spanish', 18000000.00, 5);

INSERT INTO constructors_championship (season_year, team_id, total_points) 
VALUES 
(2026, 1, 450.5), 
(2026, 2, 380.0), 
(2026, 3, 350.0), 
(2026, 4, 280.5), 
(2026, 5, 120.0);

INSERT INTO races (race_name, circuit_name, race_date, race_status) 
VALUES 
('Bahrain GP', 'Sakhir', '2026-03-02 18:00:00', 'Finished'),
('Monaco GP', 'Monte Carlo', '2026-05-24 15:00:00', 'Finished'),
('Silverstone GP', 'Silverstone', '2026-07-05 14:00:00', 'Scheduled'),
('Suzuka GP', 'Suzuka', '2026-04-05 13:00:00', 'Finished'),
('Monza GP', 'Monza', '2026-09-06 15:00:00', 'Scheduled');

INSERT INTO race_results (driver_id, race_id, grid_position, finish_position, points_earned, fastest_lap_speed) 
VALUES 
(1, 1, 1, 1, 26.0, 245.50), 
(2, 1, 3, 2, 18.0, 238.20),
(4, 2, 4, 1, 25.0, 210.40), 
(3, 2, 2, 21, 0.0, 205.10),  
(5, 4, 5, 3, 15.0, 241.30);

-- ==========================================
-- CÂU 2 - UPDATE & DELETE
-- ==========================================

SET SQL_SAFE_UPDATES = 0;

UPDATE drivers
SET annual_salary = annual_salary * 1.1
WHERE nationality = 'British' AND driver_id IN (
    SELECT driver_id 
    FROM race_results 
    GROUP BY driver_id 
    HAVING AVG(points_earned) > 15.0
);

DELETE 
FROM race_results 
WHERE finish_position > 20; 

SET SQL_SAFE_UPDATES = 1;

-- ==========================================
-- PHẦN 3: TRUY VẤN (SELECT)
-- ==========================================

-- Câu 1
SELECT full_name, driver_number, nationality
FROM drivers
WHERE annual_salary > 20000000 AND nationality = 'Dutch';

-- Câu 2
SELECT team_name, hq_country
FROM teams
WHERE (current_rank BETWEEN 1 AND 3) AND (hq_country LIKE 'M%' OR hq_country LIKE 'G%');

-- Câu 3 
SELECT race_id, race_name, race_date
FROM races
ORDER BY race_date DESC 
LIMIT 2 OFFSET 2;
-- phan 4
-- cau 1
SELECT 
    d.full_name, 
    t.team_name, 
    SUM(r.points_earned) AS total_points, 
    MAX(r.fastest_lap_speed) AS max_speed
FROM drivers d
LEFT JOIN teams t ON d.team_id = t.team_id
LEFT JOIN race_results r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.full_name, t.team_name;
-- cau 2
SELECT 
    t.team_name, 
    SUM(r.points_earned) AS team_total_points
FROM teams t
JOIN drivers d ON t.team_id = d.team_id
JOIN race_results r ON d.driver_id = r.driver_id
GROUP BY t.team_id, t.team_name
HAVING SUM(r.points_earned) > 50;
-- cau 3
SELECT 
    driver_id, 
    full_name, 
    annual_salary
FROM drivers
WHERE annual_salary = (SELECT MAX(annual_salary) FROM drivers);

-- phan 5
-- cau 1
CREATE INDEX idx_driver_perf 
ON race_results (finish_position, points_earned);
-- cau 2 
CREATE VIEW view_team_financials AS
SELECT 
    t.team_name AS ten_doi_dua, 
    COUNT(d.driver_id) AS tong_so_tay_dua, 
    SUM(d.annual_salary) AS tong_quy_luong
FROM teams t
JOIN drivers d ON t.team_id = d.team_id
WHERE d.annual_salary > 0
GROUP BY t.team_id, t.team_name;

-- phan 6
-- cau 1
DELIMITER //

CREATE TRIGGER trg_bonus_salary
AFTER INSERT ON race_results
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu số điểm kiếm được trong trận lớn hơn 25
    IF NEW.points_earned > 25 THEN
        UPDATE drivers
        SET annual_salary = annual_salary + 50000
        WHERE driver_id = NEW.driver_id;
    END IF;
END //

DELIMITER ;

-- cau 2 
DELIMITER //

CREATE TRIGGER trg_update_constructor_points
AFTER UPDATE ON races
FOR EACH ROW
BEGIN
    DECLARE v_team_id INT;

    -- Kiểm tra nếu trạng thái chuyển sang 'Finished'
    IF NEW.race_status = 'Finished' AND OLD.race_status != 'Finished' THEN
        
        -- Tìm team_id của tay đua vô địch chặng đó (finish_position = 1)
        SELECT d.team_id INTO v_team_id
        FROM race_results r
        JOIN drivers d ON r.driver_id = d.driver_id
        WHERE r.race_id = NEW.race_id AND r.finish_position = 1
        LIMIT 1;

        -- Nếu tìm thấy đội vô địch, cộng thêm 10 điểm vào bảng constructors_championship
        IF v_team_id IS NOT NULL THEN
            UPDATE constructors_championship
            SET total_points = total_points + 10
            WHERE team_id = v_team_id;
        END IF;
        
    END IF;
END //

DELIMITER ;

