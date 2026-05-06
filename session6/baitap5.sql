
/*
PHÂN TÍCH BẪY NULL (TOÁN HỌC):
😀😀😀😀😀
- NOT IN thực chất là chuỗi phép so sánh đối lập kết hợp với AND (A <> 1 AND A <> 2...).
- Trong SQL, mọi phép so sánh với NULL đều trả về Unknown.
- Chỉ cần 1 dòng trong tập Subquery bị NULL, cả biểu thức WHERE sẽ bị Unknown, 
  dẫn đến kết quả trả về rỗng (Thảm họa logic).
😀😀😀😀😀
GIẢI PHÁP AN TOÀN: Dùng LEFT JOIN kết hợp IS NULL để loại bỏ hoàn toàn bẫy này.
*/


-- Câu lệnh SQL tìm "Phòng Chết"

select r.room_id, r.room_name
from rooms r
left join bookings b
on r.room_id = b.room_id
where b.room_id is null;

-- 😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀
-- ưu điểm: hiệu năng tốt, tuyệt đổi an toàn nhé như này sẽ loại bỏ được null ở bảng bookings 😀😀😀😀😀