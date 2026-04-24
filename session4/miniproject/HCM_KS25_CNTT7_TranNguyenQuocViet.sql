create database baitapthuchanh;

use baitapthuchanh;


create table categories(
	categorry_id int primary key auto_increment,
    category_name char(50) not null
)engine=InnoDB default charset=utf8mb4;

create table products(
	product_id int primary key auto_increment,
    product_name char(50) not null,
    price decimal(18,4) not null,
    stock varchar(100) null,
    category_id int not null,
    foreign key (category_id) references categories(category_id)
)engine=InnoDB default charset=utf8mb4;

insert into categories(category_name)
values ('Điện tử'), ('Thời trang');

insert into products(product_name, price, stock, category_id)
values 
('iphone 15', '25000000', '10', 1),
('Samsung S23', '20000000', '5', 1),
('Áo sơ mi nam', '5000000', '50', 2),
('Giày thể thao', '1200000', '20', 2);

update products
set price = '26000000'
where product_name = 'iphone 15';

update products
set stock = stock + 10
where catagory_id = 1;

delete from products 
where product_id = 4
and price < 1000000;

select  * from products;

select * from products
where stock > 15;

select * from products
where price between 1000000 and 25000000;

select * from products
where product_name != 'iphone 15' 
and stock > 0;

select* from products
where category_id != 1
and price > 500000;


