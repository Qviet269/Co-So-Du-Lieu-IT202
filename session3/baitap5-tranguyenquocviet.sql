create database baitap5;

use baitap5;

create table cart_items(
	cartItemId int primary key auto_increment,
    userId int unsigned,
    productId int unsigned,
    quantity int,
    addedDate datetime default current_timestamp
)engine=InnoDB default charset=utf8mb4;

insert into cart_items(userId, productId, quantity) -- id tự tăng rồi và tgian cũng mặc định nên chỉ cần lấy các thông tin
values (3,6,1);

select * from cart_items
where userId > 0;

update cart_items
set quantity = 5
where userId = 3 and productId = 6;   -- 1 nhiều 

delete from cart_items
where userId = 3 and productId = 6;
SET SQL_SAFE_UPDATES = 0;

