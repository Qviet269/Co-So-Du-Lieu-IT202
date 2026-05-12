CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

CREATE TABLE IF NOT EXISTS Records_North (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Diagnosis TEXT,
    Record_Date DATE
);

CREATE TABLE IF NOT EXISTS Records_South (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Diagnosis TEXT,
    Record_Date DATE
);

INSERT INTO Records_North
VALUES
(1, 'Nguyen Van A', 'Flu', '2026-04-28'),
(2, 'Tran Van B', 'Fever', '2026-04-29');

INSERT INTO Records_South
VALUES
(1, 'Le Thi C', 'Cold', '2026-04-28'),
(3, 'Pham Van D', 'Covid', '2026-04-30');

CREATE VIEW National_Record_View AS

SELECT
    Record_ID,
    Patient_Name,
    Diagnosis,
    Record_Date,
    'North' AS Branch_Name
FROM Records_North

UNION ALL

SELECT
    Record_ID,
    Patient_Name,
    Diagnosis,
    Record_Date,
    'South' AS Branch_Name
FROM Records_South;

SELECT *
FROM National_Record_View;

SELECT *
FROM National_Record_View
WHERE Diagnosis = 'Covid';



/*
=========================
PHÂN TÍCH LOGIC
=========================

1. UNION ALL được sử dụng để gộp dữ liệu từ nhiều chi nhánh mà không làm mất dữ liệu gốc.

2. UNION:
- Tự động loại bỏ dòng trùng nhau
- Tốn thêm tài nguyên để kiểm tra dữ liệu
- Chậm hơn khi dữ liệu lớn

3. UNION ALL:
- Giữ nguyên toàn bộ dữ liệu
- Không kiểm tra trùng
- Hiệu năng tốt hơn

4. Trong trường hợp Record_ID bị trùng giữa hai chi nhánh:
- Dữ liệu vẫn không bị mất
- Vì UNION ALL giữ lại toàn bộ bản ghi
- Cột Branch_Name giúp xác định dữ liệu thuộc chi nhánh nào

5. VIEW hoạt động như một bảng ảo:
- Không lưu dữ liệu vật lý
- Chỉ truy vấn dữ liệu khi được gọi
- Giúp tiết kiệm bộ nhớ và dễ quản lý hệ thống
*/