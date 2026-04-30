create table cine_magic;

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
	showtime_Id int unsigned primary key,
    movie_Id int unsigned,
    room_Id int unsigned ,
    show_time datetime not null,
    ticket_price decimal(18,4) not null check(ticket_price > 0),
    
    foreign key (movie_Id) references movies(movie_Id),
    foreign key (room_Id) references rooms(room_Id)
);

create table bookings (
	booking_Id int unsigned primary key,
    showtime_Id int unsigned,
     customer_name varchar(50) not null,
     phone char(15) unique,
     booking_date datetime default current_timestamp,
     
     foreign key (showtime_Id) references showtimes(showtime_Id)
);