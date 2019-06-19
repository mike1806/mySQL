create database muzy
use muzy;

Create table Customer(
LoginID varchar(255) not null,
FirstName varchar(255),
SecondName varchar(255),
dob date,
Address varchar(90),
Phone int(10),
PremiumCustomer boolean,
primary key (LoginID)
);
LoginID varchar(255) not null,
FirstName varchar(255),
SecondName varchar(255),
dob date,
Address varchar(90),
Phone int(10),
PremiumCustomer boolean,
primary key (LoginID)
);
Create table Stock(
ProductNo varchar(10) not null,
Item varchar(20),
Price int,
PremiumPrice int,
Style varchar(50),
AgeLimit boolean,
primary key (ProductNo)
);

Create table Orders(
OrderID varchar(10) not null,
LoginID varchar(10), 
ProductNo varchar(10),
Quantity int,
ShipDate datetime,
OrderDate date,
Premium boolean,
foreign key (LoginID) references Customer(LoginID) on update cascade,
foreign key (ProductNo) references Stock(ProductNo) on update cascade,
primary key (OrderID)
);

Create table Supply(
Supplier varchar(10) not null,
ProductNo varchar(10) not null,
email varchar(50) not null,
Branch varchar(50) not null,
ContractType varchar (10),
foreign key (ProductNo) references Stock(ProductNo) on update cascade
);

Create table Cancellations(
CancelReason varchar(10) not null,
OrderID varchar(10),
ReturnDate date,
TotalAmount int,
Delay time,
foreign key (OrderID) references Orders(OrderID) on update cascade
);

INSERT INTO Customer (LoginID, FirstName, SecondName, dob, Address, Phone, PremiumCustomer)
VALUES 
('C0023898', 'Michal', 'Lesniewski', '1987-12-03', 'Liliowa 123, 62-200 Gniezno', 384958379, True),
('C0012224', 'Hubert', 'Wieprz', '1960-06-18', 'Akacjowa 21, 61-698 Poznan', 358393539, False),
('C0032532', 'Seba', 'Nosacz', '1986-02-06', 'Dresiarska 6 20-200 Karków', 834759384, False),
('C0023455', 'Jagoda', 'Wielka', '2004-02-22', 'Gruszkowa 345, 00-254 Warszawa', 948582938, False),
('C0032213', 'Damain', 'Matusz', '2000-12-12', 'Becka 21, 23-100 Gdansk', 948593049, False),
('C0031324', 'Jadwiga', 'Fujara', '1978-10-03', 'Stalowego 34 11-020 Sandomierz', 848493038, True);

INSERT INTO Stock (ProductNo, Item, Price, PremiumPrice, Style, AgeLimit)
VALUES
('P11938', 'CD', 13.99, 10.99, 'rock', False),
('P11394', 'vinyl', 35.99, 29.99, 'blues', False),
('P11392', 'tape', 6.59, 4.50, 'rap', True),
('P11333', 'DVD', 7.99, 6.20, 'jazz', False),
('P11983', 'BluRay', 23.50, 17.99, 'metal', True);

INSERT INTO Orders (OrderID, LoginID, ProductNo, Quantity, ShipDate, OrderDate, Premium)
VALUES 
('O6629483', 'C0032532', 'P11938', 3, '2019-03-29 12:43:45', '2019-03-12', False),
('O6675648', 'C0031324', 'P11938', 1, '2019-01-12 10:03:22', '2019-01-02', True),
('O6633333', 'C0032213', 'P11333', 1, '2018-12-13 20:42:11', '2018-05-05', False),
('O6603459', 'C0031324', 'P11333', 12, '2019-01-25 07:12:09', '2019-01-20', False),
('O6685740', 'C0023455', 'P11392', 2, '2018-12-21 22:23:00', '2018-12-20', False);

INSERT INTO Cancellations (CancelReason, OrderID, ReturnDate, TotalAmount, Delay)
VALUES 
('AgeLimit', 'O6685740', '2018-12-21', 13.18, '12:43:10'),
('Complaint', 'O6675648', '2019-02-01', 13.99, '09:11:02'),
('Complaint', 'O6633333', '2018-12-20', 7.99, '02:56:22');