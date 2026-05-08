-- Giải thích:
-- NOT IN sẽ bị lỗi nếu subquery chứa NULL.
-- Ví dụ:
-- id NOT IN (1,2,NULL)
-- tương đương:
-- id != 1 AND id != 2 AND id != NULL
-- mà "id != NULL" cho kết quả UNKNOWN
-- => toàn bộ điều kiện bị FALSE/UNKNOWN
-- => query trả về rỗng.

-- Cách chống lỗi:
-- Loại NULL ngay trong subquery

SELECT *
FROM Courses
WHERE id NOT IN (
    SELECT course_id
    FROM Enrollments
    WHERE course_id IS NOT NULL
);

-- Cách tốt hơn và an toàn tuyệt đối:
-- dùng NOT EXISTS vì EXISTS chỉ kiểm tra có dòng tồn tại hay không,
-- không so sánh trực tiếp với NULL nên không bị lỗi logic.

SELECT *
FROM Courses c
WHERE NOT EXISTS (
    SELECT course_id
    FROM Enrollments e
    WHERE e.course_id = c.id
);