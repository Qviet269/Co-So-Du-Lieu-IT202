create database CenterManagement;

use CenterManagement;


create table courses (
	course_id varchar(20) primary key ,
    course_name varchar(100) not null,
    lecturer varchar(50) not null,
    tuition decimal(18,4) default 0,
    duration int
);

create table students (
	student_id varchar(20) primary key ,
    fullName char(50) not null,
    email char(50) not null,
    phone char(15) not null,
    birth_of_day date
);

create table enrollments (
	enrollment_id varchar(20) primary key,
    date_of_receipt datetime default current_timestamp,
    payment_methos varchar(50) default 'Tiền mặt',
    student_id varchar(20),
    
    foreign key (student_id) references students(student_id)
);

create table enrollment_detail (
	enrollment_id varchar(20),
    course_id varchar(20),
    status varchar(50) default 'Đang học',
    final_score float ,
    
    foreign key (course_id) references courses(course_id),
    foreign key (enrollment_id) references enrollments(enrollment_id)
);

alter table enrollments
add note text;

alter table courses
rename column lecturer to Giao_Vien;

drop table enrollment_detail;
drop table enrollments;

insert into courses (course_id, course_name, Giao_Vien, tuition, duration) values
('PDK001', 'Lập trình Python cơ bản', 'Thầy Tuấn', 2500000, 40),
('PDK002', 'Thiết kế Web HTML/CSS', 'Cô Lan', 3000000, 45),
('PDK003', 'Quản trị SQL Server', 'Trần Anh', 3500000, 50),
('PDK004', 'Tiếng Anh giao tiếp', 'Cô Hana', 4000000, 60),
('PDK005', 'IELTS 6.5', 'Thầy James', 5500000, 80);

insert into students (student_id, fullName, email, phone, birth_of_day) values
('HV001', 'Nguyễn Văn An', 'an.nguyen@gmail.com', '0901234567', '2000-01-15'),
('HV002', 'Trần Thị Bình', 'binh.tran@gmail.com', '0912345678', '2001-05-20'),
('HV003', 'Lê Hoàng Cường', 'cuong.le@gmail.com', '0923456789', '1999-11-10'),
('HV004', 'Phạm Minh Đức', 'duc.pham@gmail.com', '0934567890', '2002-03-25'),
('HV005', 'Võ Mỹ Hạnh', 'hanh.vo@gmail.com', '0945678901', '2000-08-30');

insert into enrollments (enrollment_id, date_of_receipt, payment_methos, student_id, note) values
('P001', '2026-05-01 08:30:00', 'Tiền mặt', 'HV001', 'Học viên mới'),
('P002', '2026-05-01 10:15:00', 'Chuyển khoản', 'HV002', 'Đăng ký nhóm'),
('P003', '2026-05-02 14:00:00', 'Tiền mặt', 'HV003', NULL),
('P004', '2026-05-03 09:45:00', 'Chuyển khoản', 'HV004', 'Ưu đãi sinh viên'),
('P005', '2026-05-04 16:20:00', 'Tiền mặt', 'HV005', 'Đăng ký khóa nâng cao');

insert into enrollment_detail (enrollment_id, course_id, status, final_score) values
('P001', 'PDK001', 'Đang học', 0),
('P001', 'PDK001', 'Đang học', 0),
('P002', 'PDK002', 'Đang học', 0),
('P003', 'PDK003', 'Bảo lưu', NULL),
('P004', 'PDK004', 'Đang học', 0),
('P005', 'PDK005', 'Đang học', 0);

update courses 
set tuition = tuition * 0.1
where Giao_Vien = 'Tuấn Anh';

delete from students
where email is null;

select * from courses
where tuition between 1000000 and 3000000;

select fullname from students
where student_id in (
		select student_id from enrollments
        where date_of_receipt >= '2026-07-01' 
        and	  date_of_receipt <= '2026-07-31'
);

select course_name from courses
where course_id in (
		select course_id from enrollment_detail
        where course_id = 'PDK001'
);

-- nnnnnn
select fullName, phone, email from students
where student_id in (
		select student_id from  enrollments
        where enrollment_id in(
			select enrollment_id from enrollment_detail
            where course_id in (
					select course_id from courses
                    where course_name = 'IELTS 6.5'
            )
        )
);




