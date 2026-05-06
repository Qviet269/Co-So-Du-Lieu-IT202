


/*
LUỒNG LOGIC:
1. Gom nhóm dữ liệu theo từng khách hàng (GROUP BY user_id).
2. Dùng SUM(CASE WHEN...) để gán giá trị 1 cho đơn 'CANCELLED' và 0 cho loại khác, 
   sau đó cộng dồn để đếm riêng số đơn hủy mà không ảnh hưởng đến tổng đơn.
3. Dùng HAVING để lọc đồng thời: Tổng đơn >= 10 VÀ Tổng đơn hủy > 5.
*/
select user_id, count(*) as total_bookings, 
	   sum(
			case
				when status = 'CANCELLED' then 1
				else 0
			end
       )
from bookings
group by user_id
having count(*) >= 10
and sum(
			case
				when status = 'CANCELLED' then 1
				else 0
			end
       ) > 5;

