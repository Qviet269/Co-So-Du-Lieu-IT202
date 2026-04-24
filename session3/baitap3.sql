create database baitap3;

use baitap3;

create table customers (
	customerId int primary key auto_increment,
    fullName char(50) not null,
    email char(50) not null unique,
    city varchar(50),
    lastPurchaseDate date,
    status varchar(20),
    gender varchar(10),
    dateOfBirth date,
    points int,
    address varchar(255)
)engine = InnoDB default charset = utf8mb4;

insert into customers (fullName, email, city, lastPurchaseDate, status)
values
('Nguyễn Văn A', 'anv@gmail.com','Hà Nội', '2025-05-20', 'Active'),
('Trần Thị B', 'btt@gmail.com','Hà Nội', '2026-02-10', 'Active'),
('Lê văn C', 'null','Hà Nội', '2025-01-15', 'Active'),
('Phạm Minh D', 'dpm@gmail.com','Hà Nội', '2024-12-01', 'Locked'),
('Hoàng An E', 'eha@gmail.com','TP HCM', '2025-03-01', 'Active');

select fullName, email -- đây là đoạn cần trả ra I/O  tối ưu hơn lấy ra thông tin cần thiết
from customers
where email is not null
and status = 'Active'
and city = 'Hà nội'
and lastPurchaseDate <= '2025-01-15';

-- Sai lầm của SELECT *: Bảng CUSTOMERS chứa hàng triệu bản ghi với hàng chục cột. Việc dùng SELECT * sẽ kéo theo một lượng dữ liệu rác khổng lồ (Ngày sinh, Điểm thưởng, Địa chỉ...) không cần thiết, làm tiêu tốn RAM, nghẽn băng thông mạng và sập hệ thống gửi mail.
-- Thiết kế giải pháp lọc: Mệnh đề WHERE cần 4 điều kiện ràng buộc đồng thời (dùng AND). Lọc khách ở Hà Nội, thời gian mua hàng cuối cùng từ 01/10/2025 trở về trước (hơn 6 tháng so với 01/04/2026), loại bỏ bẫy thiếu email (Email IS NOT NULL) và bẫy tài khoản bị khóa (Status = 'Active').
-- theo yêu cầu triển khai code thì chỉ cần lọc tài khoản bị khóa để tối ưu hơn
