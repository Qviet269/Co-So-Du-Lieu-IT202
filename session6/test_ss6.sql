create database ss06_cntt6;

use ss06_cntt6;

create table categories (
	cate_id varchar(20) primary key,
    cate_name varchar(30) not null unique,
    status bit(1) default 1
)engine=InnoDB default charset=utf8mb4;

create table products (
	pro_id varchar(20) primary key,
    pro_name varchar(30) not null,
    pro_price decimal (10,2) not null check (pro_price >= 0),
    quantity int unsigned default 0,
    pro_day date default (current_date),
    cate_id varchar(20),
    
   
    foreign key (cate_id) references categories(cate_id)
)engine=InnoDB default charset=utf8mb4;

INSERT INTO categories (cate_id, cate_name, status)
VALUES
('P001', 'Điện tử', 1),
('P002', 'Gia dụng', 1),
('P003', 'Thiết bị văn phòng', 1),
('P004', 'Phụ kiện', 0),
('P005', 'Hàng cũ', 0);

INSERT INTO products (pro_id, pro_name, pro_price, quantity, pro_day, cate_id)
VALUES
('h001', 'Tivi Samsung 55 inch', 20000000, 3, '2026-05-01', 'P001'),
('h002', 'Tivi LG OLED', 50000000, 3, '2026-05-01', 'P001'),
('h003', 'Máy giặt Panasonic', 15000000, 3, '2026-05-02', 'P002'),
('h004', 'Máy in Canon', 25000000, 3, '2026-05-02', 'P003'),
('h005', 'Tủ lạnh Toshiba', 30000000, 3, '2026-05-03', 'P002'),
('h006', 'Laptop Dell', 26000000, 3,'2026-05-06' , 'P005'),
('h007', 'Điện thoại iPhone', 36000000, 3,'2026-05-04' , 'P005'),
('h008', 'Tai nghe Bluetooth', 49000000, 3, '2026-05-05', 'P004'),
('h009', 'Máy chiếu Epson', 30000000, 3, '2026-05-03', 'P003'),
('h010', 'Loa JBL', 10000000, 3, '2026-05-01', 'P004');

select c.cate_name as 'Danh mục', p.pro_name as 'Sản phẩm'
from categories c
inner join products p
on c.cate_id = p.cate_id;

-- tìm sản phẩm có giá tiền là 49000000 nằm ở danh mục nào

select c.cate_name as 'Danh mục', p.pro_name as 'Sản phẩm'
from categories c
inner join products p
on c.cate_id = p.cate_id
where p.pro_price = 40000000;

-- tìm tên những sản phẩm có danh mục là điện tử

select p.pro_name from products p
inner join categories c
on p.cate_id = c.cate_id
where c.cate_name = 'Điện tử';


-- hiển thị số lượng sp của từng danh mục
select c.cate_name as 'Danh mục', count(p.pro_id) as 'số lượng sản phẩm'
from categories c
inner join products p
on c.cate_id = p.cate_id
group by c.cate_name;

-- having
-- lấy ra những danh mục có 2 sản phẩm trở lên

select c.cate_name as 'Danh mục', count(p.pro_id) as 'số lượng sản phẩm'
from categories c
inner join products p
on c.cate_id = p.cate_id
group by c.cate_name
having count(p.pro_id) >= 2;

-- lấy ra những danh mục có giá của từng sản phẩm lớn hơn 2000000

select c.cate_name, p.pro_price 
from categories c
inner join products p
on p.cate_id = c.cate_id
group by c.cate_name
having p.pro_price > 2000000;