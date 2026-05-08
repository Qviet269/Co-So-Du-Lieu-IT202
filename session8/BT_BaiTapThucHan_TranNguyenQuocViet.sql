
-- PHẦN I: TẠO DATABASE & TABLE

CREATE DATABASE StoreManagement;
USE StoreManagement;

-- Bảng danh mục
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Bảng khách hàng
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender TINYINT NOT NULL, -- 1: Nam, 0: Nữ
    birth_date DATE NOT NULL,
    customer_type VARCHAR(20) DEFAULT 'Normal'
);

-- Bảng sản phẩm
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    stock INT NOT NULL CHECK(stock >= 0),
    category_id INT,

    FOREIGN KEY (category_id)
    REFERENCES Category(category_id)
);

-- Bảng đơn hàng
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Completed',

    FOREIGN KEY (customer_id)
    REFERENCES Customer(customer_id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE Order_Detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES Product(product_id)
);




-- PHẦN II: THÊM DỮ LIỆU


-- Category
INSERT INTO Category(category_name)
VALUES
('Điện tử'),
('Thời trang'),
('Gia dụng'),
('Sách'),
('Thể thao');

-- Customer
INSERT INTO Customer(full_name, email, gender, birth_date, customer_type)
VALUES
('Nguyen Van A', 'a@gmail.com', 1, '2000-05-10', 'VIP'),
('Tran Thi B', 'b@gmail.com', 0, '1998-07-21', 'Normal'),
('Le Van C', 'c@gmail.com', 1, '2005-01-15', 'VIP'),
('Pham Thi D', 'd@gmail.com', 0, '2003-11-20', 'Normal'),
('Hoang Van E', 'e@gmail.com', 1, '1995-09-09', 'VIP');

-- Product
INSERT INTO Product(product_name, price, stock, category_id)
VALUES
('iPhone 15', 25000000, 10, 1),
('Laptop Dell', 18000000, 8, 1),
('Ao Hoodie', 500000, 20, 2),
('May Giat', 7000000, 5, 3),
('Giay The Thao', 1200000, 15, 5);

-- Orders
INSERT INTO Orders(customer_id, order_date, status)
VALUES
(1, NOW(), 'Completed'),
(2, NOW(), 'Completed'),
(3, NOW(), 'Cancelled'),
(1, NOW(), 'Completed'),
(5, NOW(), 'Completed');

-- Order_Detail
INSERT INTO Order_Detail(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 25000000),
(1, 3, 2, 500000),
(2, 2, 1, 18000000),
(4, 5, 1, 1200000),
(5, 4, 1, 7000000);




-- PHẦN III: CẬP NHẬT DỮ LIỆU


-- Cập nhật giá sản phẩm
UPDATE Product
SET price = 26000000
WHERE product_name = 'iPhone 15';

-- Cập nhật email khách hàng
UPDATE Customer
SET email = 'newemail@gmail.com'
WHERE customer_id = 2;




-- PHẦN IV: XÓA DỮ LIỆU


-- Xóa chi tiết đơn hàng không hợp lệ
DELETE FROM Order_Detail
WHERE detail_id = 3;

-- Hoặc xóa đơn hàng bị hủy
DELETE FROM Orders
WHERE status = 'Cancelled';




-- PHẦN V: TRUY VẤN DỮ LIỆU

-- 1. Danh sách khách hàng + CASE
SELECT
    full_name AS 'Họ tên',
    email AS 'Email',
    CASE
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Giới tính'
FROM Customer;



-- 2. 3 khách hàng trẻ tuổi nhất
SELECT
    full_name,
    YEAR(NOW()) - YEAR(birth_date) AS age
FROM Customer
ORDER BY age ASC
LIMIT 3;



-- 3. Danh sách đơn hàng kèm tên khách hàng
SELECT
    Orders.order_id,
    Customer.full_name,
    Orders.order_date
FROM Orders
INNER JOIN Customer
ON Orders.customer_id = Customer.customer_id;



-- 4. Đếm số lượng sản phẩm theo danh mục
SELECT
    Category.category_name,
    COUNT(Product.product_id) AS total_product
FROM Product
INNER JOIN Category
ON Product.category_id = Category.category_id
GROUP BY Category.category_name
HAVING COUNT(Product.product_id) >= 2;



-- 5. Scalar Subquery
-- Sản phẩm có giá lớn hơn giá trung bình

SELECT *
FROM Product
WHERE price >
(
    SELECT AVG(price)
    FROM Product
);



-- 6. Column Subquery
-- Khách hàng chưa từng đặt hàng

SELECT *
FROM Customer
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM Orders
);



SELECT
    Category.category_name,
    SUM(Order_Detail.quantity * Order_Detail.unit_price) AS revenue
FROM Order_Detail
INNER JOIN Product
ON Order_Detail.product_id = Product.product_id
INNER JOIN Category
ON Product.category_id = Category.category_id
GROUP BY Category.category_name
HAVING revenue >
(
    SELECT AVG(total_revenue) * 1.2
    FROM
    (
        SELECT
            SUM(quantity * unit_price) AS total_revenue
        FROM Order_Detail
        GROUP BY order_id
    ) AS avg_table
);



SELECT *
FROM Product p1
WHERE price =
(
    SELECT MAX(price)
    FROM Product p2
    WHERE p1.category_id = p2.category_id
);



SELECT full_name
FROM Customer
WHERE customer_type = 'VIP'
AND customer_id IN
(
    SELECT customer_id
    FROM Orders
    WHERE order_id IN
    (
        SELECT order_id
        FROM Order_Detail
        WHERE product_id IN
        (
            SELECT product_id
            FROM Product
            WHERE category_id =
            (
                SELECT category_id
                FROM Category
                WHERE category_name = 'Điện tử'
            )
        )
    )
);