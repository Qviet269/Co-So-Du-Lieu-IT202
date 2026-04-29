create database LibraryManagement;

use LibraryManagement;

create table book (
	book_Id int unsigned primary key auto_increment,
    book_name char(50) not null,
    author varchar(100) not null,
    publish_year year not null,
    quantity int unsigned
);

create table reader (
	reader_Id int unsigned primary key auto_increment,
    fullName char (50) not null,
    email char(50) not null unique,
    phone char(50) not null unique,
    date_of_birth date 
);

create table borrow_card (
	borrow_Id varchar(50) primary key,
    borrow_date date,
    due_date date not null,
    reader_Id int unsigned not null,
    
    foreign key (reader_Id) references reader(reader_Id)
);

create table borrow_detail (
	borrow_Id varchar(50) not null,
    book_Id int unsigned,
    book_condition varchar(100) default 'New',
    fee decimal(18,4) default 0,
    
    foreign key (borrow_Id) references borrow_card(borrow_Id),
    foreign key (book_Id) references book(book_Id)
);

insert into book(book_name, author, publish_year, quantity)
values
('Mắt Biếc','Nguyễn Nhật Ánh', 1990, 10),
('Dế Mèn Phiêu Lưu Ký','Tô Hoài', 1941, 8),
('Số đỏ', 'Jack London', 1936, 5),
('Lập trinh SQL căn bản','Ngô Tất Tố',1939, 7),
('Cho Tôi XIn Một Vé Đi Về Tuổi Thơ','Nguyễn Nhật Ánh', 2016, 6);

insert into reader(fullName, email, phone, date_of_birth)
values
('Nguyen Van A', 'a@gmail.com', '0900000001', '2000-01-01'),
('Tran Thi B', 'b@gmail.com', '0900000002', '2001-02-02'),
('Le Van C', 'c@gmail.com', '0900000003', '1999-03-03'),
('Pham Thi D', 'null', '0900000004', '2002-04-04'),
('Hoang Van E', 'e@gmail.com', '0900000005', '2000-05-05');

insert into borrow_card (borrow_Id, borrow_date, due_date, reader_Id)
values
('PM001', '2025-01-01', '2025-01-10', 1),
('PM002', '2025-01-02', '2025-01-11', 2),
('PM003', '2025-01-03', '2025-01-12', 3),
('PM004', '2025-01-04', '2025-01-13', 4),
('PM005', '2025-01-05', '2025-01-14', 5);

insert into borrow_detail(borrow_Id, book_Id, book_condition, fee)
values
('PM001', 1, 'New', 0),
('PM001', 2, 'Old', 5),
('PM002', 3, 'New', 0),
('PM003', 4, 'Old', 3),
('PM004', 5, 'New', 0);

set sql_safe_updates = 0;
update book
set quantity = quantity + 5
where author = 'Nguyễn Nhật Ánh';
set sql_safe_updates = 1;

delete from reader
where email is null;

select * from book
where publish_year between 2015 and 2023;

select fullName,
		(select borrow_Id from borrow_card
		where borrow_card.reader_Id = reader.reader_Id
        and borrow_date between '2026-04-01' and '2026-04-30') as 'Mã Phiếu Mượn'
from reader
where reader_Id in (
    select reader_Id 
    from borrow_card 
    where borrow_date >= '2026-04-01' and borrow_date <= '2026-04-30'
);

select book_name from book
where book_Id in (select book_Id from borrow_detail
				  where borrow_Id = 'PM001');
                  
select fullName, phone from reader
where reader_Id in (
		select reader_Id from borrow_card
        where borrow_Id in (
				select borrow_Id from borrow_detail
                where book_Id in (
						select book_Id from book
                        where book_name = 'Lập Trình SQL căn bản'
				)                 
		)
);

select 
    borrow_Id as 'Mã Phiếu', 
    (select book_name from book where book.book_Id = borrow_detail.book_Id) as 'Tên Sách',
    book_condition as 'Trạng Thái'
from borrow_detail
where book_Id in (
    select book_Id 
    from book 
    where author = 'Jack London'
);
