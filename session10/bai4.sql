-- 1. Khởi tạo Database và Bảng
CREATE DATABASE IF NOT EXISTS bait4;
USE bait4;

CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Drug_Name VARCHAR(255),
    Batch_Number VARCHAR(50),
    Expiry_Date DATE,
    Quantity INT
);


CREATE INDEX idx_name ON Pharmacy_Inventory(Drug_Name);
CREATE INDEX idx_expiry ON Pharmacy_Inventory(Expiry_Date);

EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol' AND Expiry_Date = '2026-12-31';


DROP INDEX idx_name ON Pharmacy_Inventory;
DROP INDEX idx_expiry ON Pharmacy_Inventory;

CREATE INDEX idx_name_expiry ON Pharmacy_Inventory(Drug_Name, Expiry_Date);

EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol' AND Expiry_Date = '2026-12-31';


EXPLAIN SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE '%cetamol%';


EXPLAIN SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE 'Para%';


ALTER TABLE Pharmacy_Inventory ADD FULLTEXT(idx_fulltext_name);

EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE MATCH(Drug_Name) AGAINST('cetamol');

/*
1. Composite Index (Index hỗn hợp):
Tìm cùng lúc Tên + Hạn dùng thì gộp chung vào 1 Index là nhanh nhất. 
Dùng Index rời rạc máy tính phải tốn công xử lý kết nối giữa 2 danh sách, 
dễ gây treo máy khi có 2 triệu dòng.

2. Lỗi LIKE '%keyword%':
Index sắp xếp theo thứ tự chữ cái (A-Z). 
Dấu % nằm ở đầu làm mất chữ cái đầu tiên, 
khiến máy tính không biết lật trang nào trong "từ điển" nên phải quét tay toàn bộ bảng.

3. Giải pháp:
Dùng Full-text Search (chuyên để tìm từ khóa ở bất kỳ vị trí nào).
Hoặc chỉ dùng LIKE 'keyword%' (bỏ dấu % ở đầu) để máy tính biết điểm bắt đầu và lật mục lục được ngay.
*/