create database baitap4;

use baitap4;

-- giai phap 1
select oder_id, name, reason
where reason = 'KHACH_HUY' 
   or reason = 'QUAN_DONG_CUA' 
   or reason = 'KHONG_CO_TAI_XE' 
   or reason = 'BOM_HANG';
   
-- giải phap 2
select oder_id, name, reason
where reason in ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');

/*
BẢNG SO SÁNH CÁC GIẢI PHÁP:
+-------------------+-----------------------------------+-----------------------------------------+
| Tiêu chí          | Giải pháp 1 (Dùng OR)             | Giải pháp 2 (Dùng IN)                   |
+-------------------+-----------------------------------+-----------------------------------------+
| Mức độ code sạch  | Thấp (Rườm rà, lặp lại tên cột)   | Cao (Gọn gàng, dễ đọc danh sách)        |
+-------------------+-----------------------------------+-----------------------------------------+
| Khả năng mở rộng  | Kém(Khó quản lý khi danh sách dài)| Rất tốt (Chỉ cần thêm giá trị vào ngoặc)|
+-------------------+-----------------------------------+-----------------------------------------+
| Hiệu năng (Engine)| Thấp (Duyệt từng biểu thức con)   | Cao (Tối ưu bằng Hash/Tree Search)      |
+-------------------+-----------------------------------+-----------------------------------------+

XỬ LÝ BẪY MẢNG RỖNG (EMPTY ARRAY):
- Vấn đề: Nếu mảng rỗng, SQL sẽ lỗi Syntax: WHERE reason IN ().
- Cách chặn ở Backend JS:
  if (reasonList == null || reasonList.isEmpty()) {
      return emptyList();  Trả về kết quả rỗng ngay, không gọi Database để tối ưu tài nguyên.
*/

-- Truy vấn tốt nhất
select oder_id, name, reason, created_at
where reason in ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG')
order by created_at desc;