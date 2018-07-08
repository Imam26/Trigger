/*1.	Чтобы при взятии определенной книги, ее кол-во уменьшалось на 1. 
2.	Чтобы при возврате определенной книги, ее кол-во увеличивалось на 1. 
3.	Чтобы нельзя было выдать книгу, которой уже нет в библиотеке (по кол-ву). 
4.	Чтобы нельзя было выдать более трех книг одному студенту. 
5.	Чтобы при удалении книги, данные о ней копировались в таблицу Удаленные. 
6.	Если книга добавляется в базу, она должна быть удалена из таблицы Удаленные.
*/

--1) при выдачи книги в таблицу Lending(выдача) заносятся данные
use Library
go
create trigger Decrease 
on dbo.Lending
for insert
as
Declare @b_id int
select @b_id = id_book from inserted
update dbo.books set book_count -=1 where id = @b_id 
go
--insert into dbo.books values('Book1', 'Author1', '1992-12-12', 5)
--insert into dbo.books values('Book2', 'Author2', '1992-12-12', 7)
--go
--insert into dbo.Lending values('Student1', '2018-12-12', 1)
--insert into dbo.Lending values('Student2', '2018-12-12', 2)
--go 
--select * from dbo.books
--2) при возврате книги удаляется данные с таблицы Lending(выдача)
create trigger Increase
on dbo.Lending
for delete
as
Declare @b_id int
select @b_id = id_book from deleted
update dbo.books set book_count +=1 where id = @b_id 
go
--delete from dbo.Lending where id = 2
--go
--select * from dbo.books
--3) 
create trigger ControlBook
on dbo.Lending
instead of insert
as
Declare @b_id int
select @b_id = id_book from inserted
Declare @count int
select @count = book_count from dbo.books where id = @b_id 
if(@count = 0)raiserror('Книги нет в библиотеке',0,1)
else 
begin 
insert into dbo.Lending select i.student_name, i.date_of_issue, i.id_book from inserted i where @b_id = id_book
end
go 
--insert into dbo.Lending values('Student2', '2018-12-12', 2)
--insert into dbo.Lending values('Student3', '2018-12-12', 2)
--insert into dbo.Lending values('Student4', '2018-12-12', 2)
--insert into dbo.Lending values('Student5', '2018-12-12', 2)
--insert into dbo.Lending values('Student6', '2018-12-12', 2)
--insert into dbo.Lending values('Student7', '2018-12-12', 2)
--insert into dbo.Lending values('Student8', '2018-12-12', 2)
--insert into dbo.Lending values('Student9', '2018-12-12', 2)
--insert into dbo.Lending values('Student10', '2018-12-12', 2)

--select * from books
--4)
create trigger ControlBookCount
on dbo.Lending
for insert
as
Declare @name nvarchar(100)
select @name = student_name from inserted 
Declare @counts int
select @counts =  count(id) from dbo.Lending
where @name = student_name
if(@counts > 3) begin
raiserror('Нельзя выдать более трех книг одному студенту',0,1)
rollback transaction
end

--insert into dbo.Lending values('Student2', '2018-12-12', 2)
--insert into dbo.Lending values('Student2', '2018-12-12', 2)
--insert into dbo.Lending values('Student2', '2018-12-12', 2)
--insert into dbo.Lending values('Student2', '2018-12-12', 2)

--select * from Lending

--5)
create trigger CopyToTable
on dbo.books
for delete
as
Declare @id int
select @id = id from deleted 
insert dbo.DeletedBook values(@id)

--delete from dbo.books where id = 1 
--delete from dbo.books where id = 2 
--select * from DeletedBook

--6)
create trigger InsertToTable
on dbo.books
for insert
as
Declare @id int
select @id = id from inserted 
delete from dbo.DeletedBook where @id = id_book




