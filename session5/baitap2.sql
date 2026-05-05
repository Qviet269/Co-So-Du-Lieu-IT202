-- Câu lệnh SQL chuẩn xác để lấy đúng 5 quán mới nhất
SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY created_at DESC -- giảm dần khi lúc thêm để lấy quán mới nhất là mới thêm đưa lên đầu
LIMIT 5; -- Lấy đúng 5 bản ghi đầu tiên 

/* 
1. Nguyên nhân: Trong SQL, dữ liệu lưu trong bảng không có thứ tự cố định. 
   Nếu dùng LIMIT mà không có ORDER BY, máy sẽ bốc 5 dòng bất kỳ mà nó thấy tiện nhất.
2. Lỗi code cũ: Thiếu mệnh đề "neo giữ" thứ tự, dẫn đến kết quả bị ngẫu nhiên 
   mỗi khi truy vấn (Non-deterministic).
3. Khắc phục: Dùng ORDER BY created_at DESC để ép dữ liệu phải xếp hàng từ mới 
   đến cũ trước khi thực hiện lấy 5 dòng đầu tiên.
*/