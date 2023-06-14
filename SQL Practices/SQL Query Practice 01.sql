create database DemoDB
go
use DemoDB
go
create table student (
StudentId int identity(1,1),
StudentName nvarchar(250),
StudentEmail nvarchar(250),
StudentPhone nvarchar(250)
)
go
insert into student (StudentName,StudentEmail,StudentPhone) values
('M.A. Monaem Khan','mona@mail.com','013xxxxxx'),
('Md. Abu Sama','sama@mail.com','014xxxxxx'),
('U Mong Sing Marma','mong@mail.com','015xxxxxx')
go
select * from student