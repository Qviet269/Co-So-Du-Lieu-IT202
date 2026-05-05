-- Câu lệnh SQL chuẩn xác để vá lỗi
select restaurant_name, address, rating
from Restaurants
where (district = 'Quận 1' or district = 'Quận 3') 
and rating > 4.0;

/* 
1. Nguyên nhân: Trong SQL, AND có độ ưu tiên cao hơn OR.
2. Lỗi code cũ: Máy hiểu là "Lấy tất cả Q1" HOẶC "Q3 có rating > 4.0"
   nên quán tệ ở Q1 vẫn xuất hiện.
3. Khắc phục: Dùng ngoặc () để ép SQL xử lý OR trước, đảm bảo 
   điều kiện rating được áp dụng cho cả 2 quận.
*/