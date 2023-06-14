use master
go
create database InventoryDB
on(name='InventoryDB_data',
filename='F:\Data\InventoryDB_Data.mdf',
size=20,
maxsize=40,
filegrowth=10%)
log on(name='InventoryDB_Log',
filename='F:\Data\InventoryDB_Log.ldf',
size=20,
maxsize=40,
filegrowth=10%)
go
use InventoryDB
go

create schema product
go
create schema productsales
go
create schema productpurches
go
create schema persondetails
go

create table product.Catagory(
CatagoryId int primary key identity,
CatagoryName nvarchar(50))
go

create table product.Product(
ProductId int primary key identity,
CatagoryId int foreign key references product.Catagory(CatagoryId),
ProductName nvarchar(50))
go

create table persondetails.Customer(
CustomerId int primary key identity,
CustomerName nvarchar(50),
CustomerAddress nvarchar(150),
CustomerPhone nvarchar(14),
CustomerEmail nvarchar(20))
go
create table persondetails.SalesMan(
SalesManId int primary key identity,
SalesManName nvarchar(50),
SalesManAddress nvarchar(150),
SalesManPhone nvarchar(14),
SalesManEmail nvarchar(20),
SalesManDesignation nvarchar(50),
SalesManSalary float,
SalesManJoiningDate date,
SalesManDOB date)
go

create table productsales.Sales(
SalesId int primary key identity,
CustomerId int foreign key references [persondetails].[Customer]([CustomerId]),
SalesManId int foreign key references [persondetails].[SalesMan]([SalesManId]),
SalesDate date
)
go
create table productsales.SalesDetails(
SalesDetailsId int primary key identity,
SalesId int foreign key references productSales.Sales(SalesId),
ProductId int foreign key references [product].[Product](ProductId),
SalesDetailsPrice float,
SalesDetailsQty int
)
go

create table productpurches.Supplyer(
SupplyerId int primary key identity,
SupplyerName nvarchar(50),
SupplyerAddress nvarchar(150),
SupplyerPhone nvarchar(14)
)
go
create table productpurches.Purches(
PurchesId int primary key identity,
SupplyerId int foreign key references productpurches.Supplyer(SupplyerId),
PurchesDate date
)
go
create table productpurches.PurchesDetails(
PurchesDetailsId int primary key identity,
PurchesId int foreign key references productpurches.Purches(PurchesId),
ProductId int foreign key references product.Product(ProductId),
PurchesDetailsPrice float,
PurchesDetailsQty int
)
go
alter table [productsales].[SalesDetails]
drop column [SalesDetailsPrice]
go

insert into [product].[Catagory]([CatagoryName]) values
('TV'),
('Freeze'),
('AC')
go
--select * from product.Catagory
--go
--select * from product.Product
--go
--select * from persondetails.Customer

select * from [productpurches].[PurchesDetails] pd

create view vPurchesInfo
as
select pd.PurchesDetailsId,c.CatagoryId,c.CatagoryName,pr.ProductId,pr.ProductName,s.SupplyerId,s.SupplyerName,
p.PurchesId,p.PurchesDate,pd.PurchesDetailsPrice,pd.PurchesDetailsQty,
pd.PurchesDetailsPrice*pd.PurchesDetailsQty as TotalPuchesPrice
from [productpurches].[PurchesDetails] pd
inner join [productpurches].[Purches] p on pd.[PurchesId]=p.PurchesId
inner join [product].[Product] pr on pd.ProductId = pr.ProductId
inner join [product].[Catagory] c on c.CatagoryId=pr.CatagoryId
inner join [productpurches].[Supplyer] s on s.SupplyerId=p.SupplyerId

select * from vPurchesInfo

select s.SupplyerName,p.ProductPurches,p.IndividualPuches from [productpurches].[Supplyer] s
inner join (select vp.SupplyerId,sum(vp.PurchesDetailsQty) as ProductPurches,sum(vp.TotalPuchesPrice) as IndividualPuches 
from vPurchesInfo vp group by vp.SupplyerId) as p on p.SupplyerId=s.SupplyerId

create view vSalesInfo
as
select sd.SalesDetailsId,s.SalesId,c.CustomerId,c.CustomerName,sm.SalesManId,sm.SalesManName,s.SalesDate,pr.ProductId,pr.ProductName,
pd.PurchesDetailsId,pd.PurchesDetailsPrice,sd.SalesDetailsQty,pd.PurchesDetailsPrice*sd.SalesDetailsQty as TotalSalesPrice
from [productsales].[SalesDetails] sd
inner join [productsales].[Sales] s on sd.SalesId=s.SalesId
inner join [persondetails].[Customer] c on c.CustomerId=s.CustomerId
inner join [persondetails].[SalesMan] sm on sm.SalesManId=s.SalesManId
inner join [product].[Product] pr on pr.ProductId=sd.ProductId
inner join [productpurches].[PurchesDetails] as pd on pd.ProductId=pr.ProductId

select * from vSalesInfo

create view vOverallInfo
as
select vp.CatagoryId,vp.CatagoryName,vp.ProductId,vp.ProductName,vp.PurchesDetailsQty,vp.TotalPuchesPrice,
vs.SalesDetailsQty,vs.TotalSalesPrice
from vPurchesInfo vp
left outer join vSalesInfo vs on vp.ProductId=vs.ProductId

select * from vOverallInfo

--stock
create view vStock
as
select vo.CatagoryId,vo.CatagoryName,vo.ProductId,vo.ProductName,
vo.PurchesDetailsQty,case when vo.SalesDetailsQty is null then 0 else vo.SalesDetailsQty end as SalesDetailsQty,
(vo.PurchesDetailsQty-isnull(vo.SalesDetailsQty,0)) as StockAvailable
from vOverallInfo vo

select * from vStock

create view vStock2
as
select p.ProductId,pr.ProductName,p.PurchesDetailsQty,p.SalesDetailsQty,p.StockAvailable
from (select vStock.ProductId,avg(vStock.PurchesDetailsQty) as PurchesDetailsQty,sum(vStock.SalesDetailsQty) as SalesDetailsQty,
(avg(vStock.PurchesDetailsQty)-sum(vStock.SalesDetailsQty)) as StockAvailable
from vStock group by vStock.ProductId) as p
inner join [product].[Product] pr on pr.ProductId=p.ProductId

select * from vStock2

--profit
create view vProfit
as
select vo.CatagoryId,vo.CatagoryName,vo.ProductId,vo.ProductName,
vo.TotalPuchesPrice,case when vo.TotalSalesPrice is null then 0 else vo.TotalSalesPrice end as TotalSalesPrice,
case when (vo.TotalSalesPrice-vo.TotalPuchesPrice) is null then 0 else (vo.TotalSalesPrice-vo.TotalPuchesPrice) end as Profit
from vOverallInfo vo

select * from vProfit

create proc sp_SalesInsert
@salesId int,
@ProductId int,
@ProductQty int
as
declare @sqty int
set @sqty = (select vStock2.StockAvailable from vStock2 where vStock2.ProductId=@ProductId)
begin
if @sqty>0
begin
insert into [productsales].[SalesDetails] ([SalesId], [ProductId], [SalesDetailsQty]) values (@salesId,@ProductId,@ProductQty)
select * from vStock2
end
else
print('Sorry Stock Out')
end


exec sp_SalesInsert 1,1,8

select p.ProductId,pr.ProductName,p.PurchesDetailsQty,p.SalesDetailsQty,p.StockAvailable
from (select vStock.ProductId,avg(vStock.PurchesDetailsQty) as PurchesDetailsQty,sum(vStock.SalesDetailsQty) as SalesDetailsQty,
(avg(vStock.PurchesDetailsQty)-sum(vStock.SalesDetailsQty)) as StockAvailable
from vStock group by vStock.ProductId) as p
inner join [product].[Product] pr on pr.ProductId=p.ProductId

select vProfit.ProductId,avg(vProfit.TotalPuchesPrice),sum(vProfit.TotalSalesPrice),
(sum(vProfit.TotalSalesPrice)-avg(vProfit.TotalPuchesPrice)) as profit 
from vProfit group by vProfit.ProductId
