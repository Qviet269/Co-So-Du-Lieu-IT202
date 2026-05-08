-- Giải thích:
-- AVG(price) bình thường sẽ gộp toàn bộ bảng thành 1 dòng,
-- không thể hiển thị từng khóa học.
--
-- Scalar Subquery trong SELECT sẽ trả về 1 giá trị duy nhất:
-- giá trung bình của toàn bộ khóa học.
--
-- Sau đó MySQL gắn giá trị trung bình đó vào từng dòng,
-- giúp vừa xem chi tiết từng khóa học,
-- vừa so sánh với mức trung bình toàn hệ thống.

SELECT 
    title,
    price,
    price - (
        SELECT AVG(price)
        FROM Courses
    ) AS Price_Difference
FROM Courses;