create database to_do_list;

use to_do_list;

create table tasks (
	id int primary key auto_increment,
    name char(50) not null,
    details text,
    status tinyint
);

insert into tasks
values 
(6, 'làm bài tap elearning', 'làm bài tập session2', 0),
(9, 'làm bài tap hệ từ xa', 'làm bài tập session3', 1);

delete from tasks
where id = 9;

update tasks
set status = 1
where id > 0;

select * from tasks;

select name, status from tasks;



