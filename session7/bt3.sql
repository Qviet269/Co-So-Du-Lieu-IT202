-- not exists nó sẽ chạy subquery và tìm xem có payment nào của học viên này trong năm 2024 không 
-- nếu có thì nó sẽ ngay lập tức dừng luôn , kết luận là học viên này đã mua và loại khỏi kết quả 
-- nó không quyets toàn bộ các dữ liệu

-- còn not in là nó sẽ chạy subquery và quét toàn bộ dữ liệu gây tốn tài nguyên và giảm hiệu năng

SELECT s.email
FROM Students s
WHERE NOT EXISTS (
    SELECT 1
    FROM Payments p
    WHERE p.student_id = s.student_id
      AND YEAR(p.payment_date) = 2024
);