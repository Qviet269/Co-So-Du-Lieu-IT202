create database  borrow_books;

use borrow_books;

create table book (
	bookId char(5) primary key,
    bookName varchar(200) not null,
    quantity INT check(quantity >= 0),
    price decimal (10,2) default 5000
);

alter table book
add column day_input date;

create table borrow_books(
	borrow_id int auto_increment primary key,
    bookId char(5),
    borrow_day date default(current_date),
    constraint foreign key (bookId) references book(bookId)
);

select * 