-- Hệ thống học trực tuyến
CREATE DATABASE course_online;

USE course_online;
-- Sinh viên (Student) 
CREATE TABLE student(
	student_id int primary key auto_increment,
    fullname varchar(255) not null,
    birthday date,
    email varchar(255) not null unique
);
-- Giảng viên (Teacher)
CREATE TABLE teacher(
	teacher_id int primary key auto_increment,
    fullname varchar(255) not null,
    email varchar(255) not null unique
   -- Một giảng viên có thể dạy nhiều khóa học
);
-- Khóa học (Course)
CREATE TABLE course(
	course_id int primary key auto_increment,
    course_name varchar(100) not null,
    description varchar(255) not null,
    number_of_lesson int not null,
    teacher_id int,
    foreign key(teacher_id) references teacher(teacher_id)
);
-- Đăng ký học (Enrollment)
CREATE TABLE enrollment(
	enrollment_id int primary key auto_increment,
    student_id int, 
    course_id int,
    created_at timestamp default current_timestamp,
    unique(student_id, course_id),
	foreign key(student_id) references student(student_id),
    foreign key(course_id) references course(course_id)
);
-- Kết quả học tập (Score)
CREATE TABLE score(
	score_id int primary key auto_increment,
    student_id int, 
    course_id int,
    middle_score int check(middle_score >= 0 AND middle_score <= 10) not null,
    final_score int check(final_score >= 0 AND final_score <= 10) not null,
	unique(student_id, course_id),
    foreign key(student_id) references student(student_id),
    foreign key(course_id) references course(course_id)
);

INSERT INTO student (fullname, birthday, email) VALUES
('Nguyen Van A', '2004-05-10', 'a@gmail.com'),
('Tran Thi B', '2003-09-21', 'b@gmail.com'),
('Le Van C', '2004-12-01', 'c@gmail.com'),
('Pham Thi D', '2005-03-15', 'd@gmail.com'),
('Hoang Van E', '2003-07-07', 'e@gmail.com');

INSERT INTO teacher (fullname, email) VALUES
('Thay Minh', 'minh@gmail.com'),
('Co Lan', 'lan@gmail.com'),
('Thay Hung', 'hung@gmail.com'),
('Co Hoa', 'hoa@gmail.com'),
('Thay Nam', 'nam@gmail.com');

INSERT INTO course (course_name, description, number_of_lesson, teacher_id) VALUES
('Lap trinh C', 'Co ban C', 20, 1),
('Lap trinh Java', 'Java co ban', 25, 2),
('Co so du lieu', 'SQL va thiet ke DB', 30, 3),
('Web HTML CSS', 'Frontend co ban', 15, 4),
('JavaScript', 'JS nang cao', 22, 5);

INSERT INTO enrollment (student_id, course_id) VALUES
(1,1),
(1,2),
(2,3),
(3,1),
(4,4),
(5,5),
(2,1),
(3,2);

INSERT INTO score (student_id, course_id, middle_score, final_score) VALUES
(1,1,8,9),
(1,2,7,8),
(2,3,6,7),
(3,1,9,9),
(4,4,5,6),
(5,5,8,8),
(2,1,7,7),
(3,2,6,8);

UPDATE student
SET email = 'newemail@gmail.com'
WHERE student_id = 1;

UPDATE course
SET description = 'Khoa hoc cap nhat moi'
WHERE course_id = 1;

UPDATE score
SET final_score = 10
WHERE student_id = 1 AND course_id = 1;

DELETE FROM enrollment
WHERE student_id = 5 AND course_id = 5;

DELETE FROM score
WHERE student_id = 5 AND course_id = 5;

select * from student;

select * from teacher;

select * from course;

select * from enrollment;

select * from score;