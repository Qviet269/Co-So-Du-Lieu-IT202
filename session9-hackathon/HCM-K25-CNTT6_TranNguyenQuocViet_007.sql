CREATE DATABASE Hackathon_sql;

USE Hackathon_sql;

CREATE TABLE customers (
	customer_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);


CREATE TABLE brands (
	brand_id VARCHAR(5) PRIMARY KEY NOT NULL,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE products (
	product_id VARCHAR(5) PRIMARY KEY NOT NULL,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    brand_id VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    stock INT NOT NULL  CHECK(stock > 0),
    
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

CREATE TABLE orders (
	oder_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    customer_id VARCHAR(5)NOT NULL,
    product_id VARCHAR(5) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    order_date DATE NOT NULL,
    
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers
VALUES
('C01', 'Nguyễn Văn An', 'an.vn@gmail.com', '091111111'),
('C02', 'Nguyễn Thị Mai', 'mai.nt@gmail.com', '092222222'),
('C03', 'Trần Quang Hải', 'hai.tq@gmail.com', '093333333'),
('C04', 'Phạm Bảo Ngọc', 'ngoc.pb@gmail.com', '094444444'),
('C05', 'Vũ Đức Nam', 'dam.vd@gmail.com', '09555555');

INSERT INTO brands
VALUES
('B01', 'Apple'),
('B02', 'Samsung'),
('B03', 'Sony'),
('B04', 'Dell');


INSERT INTO products
VALUES
('P01', 'iphone 15 Pro Max', 'B01', 30000000, 10),
('P02', 'MacBook Pro M3', 'B01', 45000000, 5),
('P03', 'Galaxy S24 Ultra', 'B02', 25000000, 20),
('P04', 'PlayStation 5', 'B03', 15000000, 8),
('P05', 'Dell XPS 15', 'B04', 35000000, 15);


INSERT INTO orders
VALUES
(1,'C01', 'P01', 'Pending', '2025-10-01'),
(2,'C02', 'P03', 'Completed', '2025-10-02'),
(3,'C01', 'P02', 'Completed', '2025-10-03'),
(4,'C04', 'P05', 'Cancelled', '2025-10-04'),
(5,'C05', 'P01', 'Pending', '2025-10-05');

UPDATE products
SET stock = stock + 10,
price = price * 1.05
WHERE product_name = 'Dell XPS 15';

UPDATE customers
SET phone = '0999999999'
WHERE customer_id = 'C03';

SET SQL_SAFE_UPDATES = 0;
DELETE FROM orders
WHERE status = 'Completed' AND order_date = '2025-10-03';

SELECT product_id, product_name, price FROM products
WHERE price BETWEEN 15000000 AND 30000000 AND stock > 0;

SELECT full_name, email FROM customers
WHERE full_name LIKE 'Nguyễn%';

SELECT oder_id, customer_id, order_date
FROM orders 
ORDER BY order_date DESC;

SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

SELECT product_name, stock 
FROM products
LIMIT 2 OFFSET 2;

SELECT O.oder_id, C.full_name, P.product_name, O.order_date 
FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
INNER JOIN products P
ON P.product_id = O.product_id
WHERE status = 'Pending'; --

SELECT B.*, P.product_name 
FROM products P
LEFT JOIN brands B
ON B.brand_id = P.brand_id;


SELECT status, COUNT(oder_id) AS total_orders
FROM orders
GROUP BY status;

SELECT C.full_name, COUNT(P.product_id) AS SO_LUONG
FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
JOIN products P
ON P.product_id = O.product_id
GROUP BY C.full_name
HAVING COUNT(P.product_id) >= 2;

SELECT product_id, product_name, price 
FROM products
WHERE price < (SELECT AVG(price) FROM products);

SELECT C.full_name, C.phone 
FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
JOIN products P
ON P.product_id = O.product_id
WHERE product_name = 'iphone 15 Pro Max';