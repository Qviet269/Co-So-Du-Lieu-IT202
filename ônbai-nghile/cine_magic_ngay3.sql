create database cine_magic;

use cine_magic;

create table movies (
	movie_Id int unsigned primary key auto_increment,
    title varchar(100) not null,
	duration__minutes smallint unsigned,
    age_restriction int default 0
);

create table rooms (
	room_Id int unsigned primary key auto_increment,
    room_name varchar(50) not null,
	max_seats tinyint unsigned not null check ( max_seats between 10 and 200),
    status varchar(50) not null default 'active'
);

create table showtimes (
	showtime_Id int unsigned primary key auto_increment,
    movie_Id int unsigned,
    room_Id int unsigned ,
    show_time datetime not null,
    ticket_price decimal(18,4) not null check(ticket_price > 0),
    
    foreign key (movie_Id) references movies(movie_Id),
    foreign key (room_Id) references rooms(room_Id)
);

create table bookings (
	booking_Id int unsigned primary key auto_increment,
    showtime_Id int unsigned,
     customer_name varchar(50) not null,
     phone char(15) unique,
     booking_date datetime default current_timestamp,
     
     foreign key (showtime_Id) references showtimes(showtime_Id)
);
insert into movies(title, duration__minutes, age_restriction) 
values
('Lật Mặt 8', 125, 13),
('Thám Tử Lừng Danh', 160 , 7),
('Ma Da', 180, 18),
('Lật Mặt 8', 125, 13);

insert into rooms(room_name, max_seats, status)
values
('Cinema 01', 150, 'active'),
('Cinema 02', 120, 'active'),
('Cinema 03', 100, 'maintenance');

insert into showtimes (movie_Id, room_Id, show_time, ticket_price)
values 
(1, 1, '2026-05-15 18:30:00', 85000),
(2, 2, '2026-05-15 20:00:00', 95000), 
(3, 1, '2026-05-16 14:00:00', 85000), 
(4, 2, '2026-05-16 09:00:00', 75000), 
(1, 2, '2026-05-16 21:00:00', 90000);

insert into bookings (showtime_Id, customer_name, phone, booking_date)
values 
(1, 'nguyen van a', '0901234561', '2026-05-01 08:30:00'),
(1, 'tran thi b', '0987654321', '2026-05-01 09:15:00'),
(2, 'le van c', '0901234563', '2026-05-01 10:00:00'),
(2, 'pham thi d', '0901234564', '2026-05-02 11:30:00'),
(3, 'hoang van e', '0901234565', '2026-05-02 14:20:00'),
(3, 'ngo thi f', '0901234566', '2026-05-02 15:45:00'),
(4, 'vu van g', '0901234567', '2026-05-03 08:00:00'),
(4, 'dang thi h', '0901234568', '2026-05-03 09:30:00'),
(5, 'bui van i', '0901234569', '2026-05-03 16:10:00'),
(5, 'ly thi k', '0901234570', '2026-05-03 20:00:00');


update rooms
set status = 'maintenance'
where room_Id = 1;


update showtimes
set room_Id = 2
where room_Id = 1;

delete from bookings
where phone = '0987654321';

delete from bookings
where showtime_Id in (
		select showtime_Id from showtimes
        where movie_Id = 3
);

delete from showtimes
where movie_Id = 3;

delete from movies
where movie_Id = 3;