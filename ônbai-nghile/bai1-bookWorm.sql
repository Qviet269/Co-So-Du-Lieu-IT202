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
    on delete cascade -- cái này em mới tìm hiểu được là nếu xa thk cha thì thk con cũng đi theo
);

create table customers (
	customer_id int unsigned primary key auto_increment,
    full_name char(50) not null,
    email char(50) not null unique,
    phone char(25) not null unique,
    registration_date datetime default current_timestamp
);

select * from authors;
select * from books;
select * from customers;