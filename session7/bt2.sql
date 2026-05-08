-- code cũ:
SELECT SUM(total_spent)
FROM (
SELECT student_id, SUM(amount) as total_spent
FROM Payments
GROUP BY student_id
HAVING SUM(amount) > 10000000
);

-- hiển thị lỗi "Every derived table must have its own alias". có nghĩa là 
-- mỗi bảng dẫn xuất phải có thêm tên bí danh của nó 

-- "Derived Table" (Bảng dẫn xuất) là hàm con dùng để xuất điều kiện , một điều kiện tổng hợp ví dụ như sum(amount) phải đặt AS bí danh cho nó 

-- sửa lại
SELECT SUM(total_spent) 
FROM (
SELECT student_id, SUM(amount) as total_spent
FROM Payments
GROUP BY student_id
HAVING SUM(amount) > 10000000
)AS temp ;