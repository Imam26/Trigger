create database Library
go
use Library 
go
create table books(
id int not null primary key identity(1,1),
name nvarchar(100) not null,
author nvarchar(100) not null,
publ_date date not null,
book_count int not null
)
go 
create table Lending(
id int not null primary key identity(1,1),
student_name nvarchar(100) not null,
date_of_issue date not null,
id_book int not null foreign key references books(id),
)
go 
create table DeletedBook(
id int not null primary key identity(1,1),
id_book int not null foreign key references books(id)
)