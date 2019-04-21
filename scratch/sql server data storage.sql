
use BlogDemo
go

drop table if exists [dbo].[coffee]
go
create table [dbo].[coffee]
(
	id int primary key,
	brand varchar(30) not null,
	roast varchar(30) null
)
on [Secondary]
go

;with entries(id, brand, roast) as
(
	select 0 as id, cast('aaaaa' as varchar(20)), cast('aaaaa' as varchar(20))
	union all
	select id + 1, 
	       replicate(convert(varchar(1), char(abs(checksum(newid()) % 26) + 65)), 20) as brand, 
		   replicate(convert(varchar(1), char(abs(checksum(newid()) % 26) + 65)), 20) as roast
	from entries where id < 30
)
insert into coffee (id, brand, roast) 
select id, brand, roast from entries

dbcc ind
(
	'BlogDemo',
	'dbo.coffee',
	-1
)

select * from sys.dm_db_database_page_allocations(db_id(), object_id('dbo.coffee', 'U'), null, null, null) 

dbcc traceon(3604) -- output to console
dbcc page
(
	'BlogDemo',
	3, -- PageFID,
	8, -- PagePID,
	3 -- Output Mode: displays page header and row details
)


