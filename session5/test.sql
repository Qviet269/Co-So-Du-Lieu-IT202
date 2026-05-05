create database ss05_cntt6;

use ss05_cntt6;


-- Tạo 1 bảng 
create table products (
	prodcut_id varchar(20) primary key,
    product_name varchar(50) not null,
    price decimal(10,2) not null check(price >= 0),
    quantity int default 0,
    product_day date default (current_date),
    note text
)engine=InnoDB default charset=utf8mb4;

insert into products (prodcut_id, product_name, price, quantity, product_day, note)
values
('P001', 'Ti vi', 15000000, 10, default, 'balabala'),
('P002', 'Máy giặt', 10000000, 4, '2026-05-06', 'balabala'),
('P003', 'Tu lanh', 30000000, 10, default, 'balabala'),
('P004', 'Phich nước nóng', 10000000, 4, '2026-05-06', 'balabala'),
('P005', 'Máy rửa chén', 3000000, 4, default, 'balabala');


select * from products;

select product_name as 'tên của mày', price as 'số tiền mày mua' from products p;

select product_name, price,
		case
			when price > 2000000 then 'gia cao'
            when price between 1500000 and 2000000 then 'Trung bình'
            else 'Thap'
		end as price_level
from products;

select product_name, price,
		case price
			when 3000000 then 'gia cao'
            when 2000000 then 'Trung bình'
            else 'Thap'
		end as price_level
from products;

-- lấy ra danh sách sản phấm có giá tiền lớn hơn 15000000
-- lấy ra danh sách sản phẩm khôn có mô tả

select * from products 
where price > 15000000;

select * from products
where note is null;

select * from products
where (price between 15000000 and 30000000) and quantity = 10;

select * from products
where product_day = current_date() and note is not null;

select * from products
where product_name like 'T%';

select * from products
where product_name like 'may%';

select * from products
where product_name like ('%nh') or product_name like ('%n');

select * from products
where price > 2000000 and quantity < 20
order by price asc, quantity asc;

/*
	Cửa hàng 15 sản phẩm, chủ shop muốn hiển thị 1 trang có 5 sản phầm 
    vậy cần bao nhiêu trang để hiển thị hết sản phẩm
    
    curent_page = trang hiện tại 
    total_page = tổng số trang
	page_number = số lượng sản phẩm trên 1 trang
    start = vị trí bắt đầu của trang
    end = vị trị kết thúcache index
    => đang ở trang thứ 2, thì start = 3, end = 5 là bao nhiêu 
    start = (curent_page - 1) * page_number 
    end = start + page_number - 1
*/
select * from products
limit 
