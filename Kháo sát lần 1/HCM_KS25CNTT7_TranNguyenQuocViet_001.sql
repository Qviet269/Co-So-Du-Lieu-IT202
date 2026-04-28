create database salesManagement;
use salesManagement;


create table Products (
    product_id varchar(10) primary key,
    name varchar(100) not null,
    NhaSanXuat varchar(100) not null,
    price decimal(15,2) not null,
    stock int
);

create table Customer (
    customer_id varchar(10) primary key,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(20) unique, 
    address varchar(255) not null
);

create table Orders (
    order_id varchar(10) primary key,
    order_date datetime default current_timestamp,
    total_amount decimal(15,2) not null,
    customer_id varchar(10) not null,
    foreign key (customer_id) references Customer(customer_id)
);

create table Order_Detail (
    order_id varchar(10) not null,
    product_id varchar(10) not null,
    quantity int not null,
    price_time decimal(15,2) not null,
    primary key (order_id, product_id),
    foreign key (order_id) references Orders(order_id),
    foreign key (product_id) references Products(product_id)
);


alter table Orders add note text;


insert into Products values
('P001', 'MacBook Air M2', 'Apple', 25000000, 10),
('P002', 'iPhone 14', 'Apple', 20000000, 15),
('P003', 'Dell XPS 13', 'Dell', 22000000, 8),
('P004', 'HP Tuf', 'HP', 15000000, 12),
('P005', 'Asus Vivobook', 'Asus', 30000000, 5);

insert into Customer values
('C001', 'Nguyen Van A', 'a@gmail.com', '0123456789', 'TP HCM'),
('C002', 'Tran Van B', 'b@gmail.com', '0911223344', 'Ha Noi'),
('C003', 'Vu Van C', 'c@gmail.com', '0987654321', 'Binh Dinh'),
('C004', 'Phan Van D', 'd@gmail.com', NULL, 'Son La'), 
('C005', 'Tan Van E', 'e@gmail.com', '0111222333', 'Thao Nguyen');

insert into Orders (order_id, order_date, total_amount, customer_id) values
('DH001', '2026-04-01', 45000000, 'C001'),
('DH002', '2026-04-02', 20000000, 'C003'),
('DH003', '2026-04-03', 30000000, 'C005'),
('DH004', '2026-04-04', 15000000, 'C001'),
('DH005', '2026-04-05', 22000000, 'C003');

insert into Order_Detail values
('DH001', 'P001', 1, 25000000),
('DH001', 'P002', 1, 20000000),
('DH002', 'P002', 1, 20000000),
('DH003', 'P005', 1, 30000000),
('DH004', 'P004', 1, 15000000);

set sql_safe_updates = 0;
update Products set price = price * 1.1 where NhaSanXuat = 'Apple';
set sql_safe_updates = 1;
delete from Customer where phone is null;


select * from Products where price between 10000000 and 20000000;

select * from Orders where order_id = 'DH001';

select order_id, order_date
from Orders
where customer_id in (
    select customer_id from Customer where address = 'TP HCM'
);