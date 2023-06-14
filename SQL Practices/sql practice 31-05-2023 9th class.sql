use master

go

create database InventoryDB --by writing this we can create the table

on -- where the file will store
(name='InventoryDB_Data',
filename='F:\Data\InventoryDb_data.mdf', --should create a folder 1st
size=20,
maxsize=40,
filegrowth=10%)

log on --all acticity of database
(name='InventoryDB_log',
filename='F:\Data\InventoryDb_log.ldf',--should create a folder 1st
size=20,
maxsize=40,
filegrowth=10%)

go

use InventoryDB

go

--1st create the table that has relation with other tables then create others table
create table Catagory(
CatagoryId int identity(1,1) primary key,
Catagoty nvarchar(50) not null)

go

create table Product(
ProductId int identity(1,1) primary key,
CatagoryId int foreign key references Catagory(CatagoryId),
ProductName nvarchar(50))

go

create table Customer(
CustomerId int identity primary key,
CustomerName nvarchar(50) not null,
CustomerAddress nvarchar(150),
CustomerPhone nvarchar(20),
CustomerMail nvarchar(30))

go

create table SalesMan(
SalesManId int identity primary key,
SalesManName nvarchar(50) not null,
SalesManAddress nvarchar(150),
SalesManPhone nvarchar(20),
SalesManMail nvarchar(30),
SalesManSalary float,
SalesManJoinDate datetime,
SalesManDOB datetime,
SalesManDesignation nvarchar(20))

go

create table Sales(
SalesId int primary key identity,
SalesDate datetime,
CustomerId int foreign key references Customer(CustomerId),
SalesManId int foreign key references SalesMan(SalesManId),
SalesDiscount float,
SalesTotal float,
SalesRemarks nvarchar(200))

go

create table SalesDetails(
SalesDetailsId int primary key identity,
SalesId int foreign key references Sales(SalesId),
ProductId int foreign key references Product(ProductId),
SalesDetailsPrice float,
SalesDetailsQuantity float)

go

create table Supplyer(
SupplyerId int identity primary key,
SupplyerName nvarchar(50) not null,
SupplyerAddress nvarchar(150),
SupplyerPhone nvarchar(20),
SupplyerMail nvarchar(30))

go

create table Purches(
PurchesId int primary key identity,
PurchesDate datetime,
SupplyerId int foreign key references Supplyer(SupplyerId),
PurchesDiscount float,
PurchesTotal float,
PurchesRemarks nvarchar(200))

go

create table PurchesDetails(
PurchesDetailsId int primary key identity,
PurchesId int foreign key references Purches(PurchesId),
ProductId int foreign key references Product(ProductId),
PurchesDetailsPrice float,
PurchesDetailsQuentity float)

go

insert into Catagory(Catagoty) values ('Freeze')
insert into Catagory(Catagoty) values ('TV')
insert into Catagory(Catagoty) values ('AC')
insert into Catagory(Catagoty) values ('Radio')
insert into Catagory(Catagoty) values ('Washing Machine')

go

insert into Product(CatagoryId,ProductName) values(1,'24SFT Walton'),(2,'32" WaltonTV'),(3,'2 tON wALTON ac'),(3,'1 Ton Walton AC')

go

insert into Customer(CustomerName,CustomerAddress,CustomerPhone,CustomerMail) values 
('Monaem Khan','Chapai Nawabgong','013xxxx','monaem@mail.com'),
('xxxx','xxx_dis','013xxxxx','xxxx@mail.com'),
('yyyy','yyy_dis','013xxxxy','yyyy@mail.com'),
('zzzz','zzz_dis','013xxxxz','zzzz@mail.com'),
('vvvv','vvv_dis','013xxxxv','vvvv@mail.com')

go

insert into SalesMan(SalesManName,SalesManAddress,SalesManPhone,SalesManMail,SalesManJoinDate,SalesManDOB,SalesManDesignation,SalesManSalary) values
('aaaa','aaa_dis','015_aaa','aaa@mail.com','2022-12-12','2022-12-12','salesman',20000),
('bbbb','bbb_dis','015_bbb','bbb@mail.com','2022-12-12','2022-12-12','salesman',20000),
('cccc','ccc_dis','015_ccc','ccc@mail.com','2022-12-12','2022-12-12','salesman',20000),
('dddd','ddd_dis','015_ddd','ddd@mail.com','2022-12-12','2022-12-12','salesman',20000)

go

insert into Sales([SalesDate], [CustomerId], [SalesManId], [SalesDiscount], [SalesTotal], [SalesRemarks]) values
('2023-05-25',1,1,20,100,'Good'),
('2023-05-25',2,2,25,200,'Average'),
('2023-05-25',2,2,10,300,'Good'),
('2023-05-25',3,3,5,400,'Good')

go

insert into SalesDetails ([SalesId], [ProductId], [SalesDetailsPrice], [SalesDetailsQuantity] ) values
(1,2,400,1),
(1,1,600,1),
(1,3,800,4),
(3,2,400,1),
(4,2,400,1)

go

insert into Supplyer ([SupplyerName], [SupplyerAddress], [SupplyerPhone], [SupplyerMail]) values 
('qqqq','qqqq_dis','013_qqqq','qqqq@mail.com'),
('pppp','pppp_dis','013_pppp','pppp@mail.com'),
('rrrr','rrrr_dis','013_rrrr','rrrr@mail.com')

go

insert into Purches ([PurchesDate], [SupplyerId], [PurchesDiscount], [PurchesTotal], [PurchesRemarks]) values
('2023-03-25',1,20,600,'nothing'),
('2023-03-25',2,20,1000,'nothing'),
('2023-03-25',3,30,800,'nothing'),
('2023-04-25',1,00,1200,'nothing')

go

insert into PurchesDetails ([PurchesId], [ProductId], [PurchesDetailsPrice], [PurchesDetailsQuentity]) values
(1,1,600,1),
(1,2,500,1),
(2,2,500,1),
(3,3,800,1),
(4,4,600,1)

go

select * from PurchesDetails