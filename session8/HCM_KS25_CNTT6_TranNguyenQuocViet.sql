CREATE DATABASE BookStore_DB;

USE BookStore_DB;

CREATE TABLE  categorys (
	category_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) 
);

CREATE TABLE books (
	book_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(10,2),
    category_id INT,
    
    FOREIGN KEY (category_id) REFERENCES categorys(category_id)
);

CREATE TABLE book_orders (
	order_id INT  PRIMARY KEY AUTO_INCREMENT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    order_date DATE DEFAULT  (CURRENT_DATE),
    delivery_date DATE,
    
    FOREIGN KEY (book_id) REFERENCES books(book_id)
    ON DELETE CASCADE
);

ALTER TABLE books
ADD  author_name VARCHAR(100) NOT NULL;

ALTER TABLE book_orders
MODIFY customer_name VARCHAR(200);

ALTER TABLE book_orders
ADD CONSTRAINT chk_delivery_date
CHECK (delivery_date >= order_date);

INSERT INTO categorys(category_name, description)
VALUES
('IT & Tech', 'Sách lập trình'),
('Business', 'Sách kinh doanh'),
('Novel', 'Tiểu thuyết');

select * FROM categorys;

INSERT INTO books(title, status, publish_date, price, category_id, author_name)
VALUES
('Clean Code', 1, '2020-05-10', 500000, 1, 'Robert C. Martin'),
('Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
('JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
('Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

INSERT INTO book_orders(customer_name, book_id, order_date, delivery_date)
VALUES
('Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
('Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
('Le Hoang Yen', 4, '2025-03-12', NULL);

UPDATE books
SET price = price  + 50000
WHERE category_id IN (
		SELECT category_id FROM categorys
        WHERE category_name = 'IT & Tech'
);

select * FROM books;

UPDATE book_orders
SET delivery_date = '2025-12-31' 
WHERE  delivery_date IS NULL;


DELETE FROM book_orders
WHERE order_date < '2025-02-01';

-- CÂU 4

SELECT title, author_name,
CASE
	WHEN status = 1 THEN 'Còn hàng'
    WHEN status = 0 THEN 'Không Còn hàng'
    ELSE 'Không Xác đinh'
END AS status_name
FROM books;

SELECT upper(title) AS VIET_HOA,
TIMESTAMPDIFF(YEAR, publish_date, CURDATE()) AS NAM_XUAT_BAN
FROM books;

SELECT b.title, b.price, c.category_name
FROM books b
INNER JOIN categorys c
ON c.category_id = b.category_id;

SELECT title, price
FROM books
ORDER BY price DESC
LIMIT 2;

SELECT c.category_name, COUNT(book_id) AS SO_LUONG
FROM  books b
INNER JOIN categorys c
ON c.category_id = b.category_id
GROUP BY c.category_name
HAVING COUNT(book_id) >= 2;

SELECT * FROM books B
WHERE B.price > (SELECT AVG(price) FROM books);

SELECT * FROM books
WHERE book_id IN (
		SELECT book_id FROM book_orders
);

SELECT * FROM books B
WHERE B.price IN (
		SELECT MAX(price) FROM books
        WHERE category_id = B.category_id
);




