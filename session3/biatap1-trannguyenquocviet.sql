create database baitap1;

use baitap1;

create table products(
	productId int unsigned auto_increment primary key,
    productName char(30) not null,
    category varchar(50) not null,
    originalPrice decimal(18,4) null unique
);

insert into products(productId, productName, category, originalPrice)
values
(1,'iphone 15', 'Electronics', 20000000),
(2,'Samsung Refrigerator', 'Electronics', 15000000),
(3,'Water spinach', 'Food', 10000),
(4,'Filtered fresh milk 4', 'Food', 28000);

SET SQL_SAFE_UPDATES = 0;
update products
set originalPrice = originalPrice * 0.9 -- khi cập nhật dữ liệu mới mà thực tập viễn thiếu mất mệnh đề where bỏ qua sẽ bị hư hỏng mất dữ liệu 
where category = 'Electronics'; -- chỉ định đúng số sản phẩm cụ thể cần được giảm giá để tranh thất thoát 



