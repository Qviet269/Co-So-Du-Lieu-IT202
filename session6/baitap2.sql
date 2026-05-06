SELECT hotel_id, MIN(price_per_night) AS min_price
FROM Rooms
GROUP BY hotel_id;

/*
- Nguyên nhân: Việc nhét 'room_name' vào SELECT vi phạm tính duy nhất của dữ liệu khi gom nhóm.
- Bản chất: Khi GROUP BY hotel_id, SQL nén nhiều dòng về 1 dòng. Vì 1 khách sạn có nhiều tên phòng khác nhau, 
  máy tính không thể tự quyết định chọn tên nào để đại diện nếu không có hàm tính toán đi kèm.
-  SQL chặn lỗi này để đảm bảo dữ liệu hiển thị không bị sai lệch hoặc ngẫu nhiên.
*/