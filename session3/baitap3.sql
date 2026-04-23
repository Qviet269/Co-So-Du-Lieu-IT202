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
and email <> 'null' -- xóa đi giá trị null tự nhập 
and status = 'Active';

-- theo yêu cầu triển khai code thì chỉ cần lọc tài khoản bị khóa để tối ưu hơn
