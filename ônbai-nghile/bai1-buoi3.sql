create database book_worm;

use book_worm;

create table authors(
	author_id int unsigned primary key auto_increment,
    full_name char(50) not null,
    birth_year year,
    nationality varchar(100) default null
);

create table books (
	book_id int unsigned primary key auto_increment,
    book_name varchar(100) not null unique,
    category varchar(100) null,
    author_id int unsigned not null,
    price decimal(18,4) not null default 0 check (price >= 0),
    publish_year year,
    foreign key (author_id) references authors(author_id)
);

create table customers (
	customer_id int unsigned primary key auto_increment,
    full_name char(50) not null,
    email char(50) not null unique,
    phone char(25) not null unique,
    registration_date datetime default current_timestamp
);
insert into authors(full_name, birth_year, nationality)
values 
('Nguyễn Văn A', 1999, 'Việt Nam'),   
('Trần QUốc B', 1989, 'Việt Kiều'),
('Dale Carnegie', 1990, 'Mỹ'),    
('Higashino Keigo', 1958, 'Nhật Bản'),
('Nguyễn Thị C', 2000, 'Việt Nam');

insert into books(book_name, category, author_id, price, publish_year)
values 
('Mắt Biếc', 'Văn học', 1, 360000, 1990), 
('Cho tôi xin một vé đi tuổi thơ', 'Văn học', 1, 850000, 2008), 
('Nhà Giả Kim', 'Văn học', 2, 790000, 1988), 
('Thú Tội', 'Trinh thám', 3, 37000, 2008), 
('Sherlock Holmes: Chiếc Nhẫn Tình Cờ', 'Trinh thám', 4, 15000, 1999), 
('Phía Sau Nghi Can X', 'Trinh thám', 4, 1250000, 2005), 
('Đắc Nhân Tâm', 'Kỹ năng', 5, 380000, 1936), 
('Quẳng Gánh Lo Đi Và Vui Sống', 'Kỹ năng', 5, 880000, 1948);

insert into customers(full_name, email, phone)
values
('Trần Nguyễn Quốc Việt', 'tqv@gmail.com', '0363636'),
('Đàm Ứng Viết', 'Un@gmail.com', '0373737'),
('Nguyễn Lê Minh G', 'Gg@gmail.com', '0383838');

insert into customers(full_name, email, phone)
values
('Trần Nguyễn Quốc Việt fake', 'tqv@gmail.com', '0393939');

-- khi tạo bảng yêu cầu trước đã cho là ràng buộc email là duy nhất nên đã thêm unique vào
-- ràng buộc unique ép buộc buộc dữ liệu trong cột là duy nhất không được phép lặp lại
-- nên mysql  thông báo lỗi 

select * from authors;

select * from books
where category = 'Trinh thám' and price < 100000;

select * from customers
where email like '%@gmail.com';

select * from books
order by price desc
limit 3;

set sql_safe_updates = 0;
update books
set price = price * 0.9
where publish_year < '2020';

