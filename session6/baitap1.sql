select city, sum(total_price) as revenue
from Bookings
where status = 'COMPLETED' -- Lọc các đơn thành công trước khi nhóm
group by city
having sum(total_price) > 0; -- Lọc tổng doanh thu sau khi đã nhóm theo thành phố

/* 
- WHERE: Dùng để loại bỏ các đơn hàng chưa hoàn tất ngay từ đầu để giảm tải cho máy.
- HAVING: Chỉ thực thi sau khi GROUP BY đã gom xong doanh thu cho từng thành phố.
- Thứ tự đúng: Nhặt đơn 'COMPLETED' -> Gom nhóm theo 'city' -> Tính tổng -> Kiểm tra xem tổng có > 0 không.
*/