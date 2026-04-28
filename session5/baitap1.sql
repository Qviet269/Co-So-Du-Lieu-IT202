create database baitap1;

use baitap1;

create table Restaurants(
	id int unsigned primary key auto_increment,
    restaurant_name char(50) not null,
    address varchar(100) not null,
    rating tinyint unsigned not null
);

insert into 