create database baitap2;

use baitap2;

create table shippers (
	shipperId int primary key auto_increment,
    shipperName varchar(255),
    phone varchar(20)
);

insert into shippers (shipperName, phone)
values ('giao hàng nhanh', '0901234567'); -- lúc đầu phần giá trị 1 dã bị thiếu mất một dấu nhảy đóng và đã sửa lại
--  còn ở dòng lệnh lỗi 2 thì gặp vẫn đề là thiếu thông tin
-- khi viết  viettel post ở cột đầu sẽ bị nhầm vào ô đầu tiên là phần ID dẫn đến bị kẹt
-- null phần phone vì trường hợp điền chưa đầy đủ và thứ tự chưa hợp lệ

insert into shippers (shipperName, phone) -- mình muốn thêm giá trị nào vào thì cần chỉ rõ tới để tránh trường hợp bị lỗi 
values ('viettel post', '0777732323');