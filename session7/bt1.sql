-- code cũ:
SELECT title, price
FROM Courses
WHERE price = (SELECT price FROM Courses WHERE instructor_id = 5);

-- mục đích của bài này là lấy ra các khóa học trên hệ thống có mức  giá bằng với mức giá của các khóa học do giảng viên 'Trần Văn A' (có instructor_id = 5) giảng dạy.
-- là phải hiển thị ra nhiều dữ liệu , nhưng '=' chỉ xuất ra 1 giá trị duy nhất thôi , nó chỉ hợp để áp dụng cho sum(), count(),... thôi
-- đối với bài toán hiển thị ra nhiều giá trị khác nhau thì sẽ thay thế "=" thành IN

SELECT title, price
FROM Courses
WHERE price IN (SELECT price FROM Courses WHERE instructor_id = 5);
-- IN có thể xét điều kiện và trả về nhiều giá trị