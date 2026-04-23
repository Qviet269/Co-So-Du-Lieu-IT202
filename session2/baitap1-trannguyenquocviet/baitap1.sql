CREATE DATABASE commerce;
    
use commerce;
  
CREATE TABLE PRODUCTS(
	ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL, -- bắt buộc không để trống tên khi điền thì độ sài chữ bao nhiêu lấy bấy nhiêu 
    Price DECIMAL(18,4) NOT NULL, -- khi vị trí 2 thì làm tròn quá sớm dễ dẫn đến làm tròn sai sót khi tính tiền 
    Description VARCHAR(600) null  -- không có mô tả thì để null
);

select * from PRODUCTS;