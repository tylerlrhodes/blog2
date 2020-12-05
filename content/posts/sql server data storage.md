---
title: "SQL Server Data Storage"
date: 2019-04-14T06:35:44-04:00
draft: false
series: tech
tags: [
      "SQL Server",
      "TSQL"
]      
---

This post goes into a little bit of detail about how SQL Server stores
data on disk.  Quite a bit of it is drawn from the book 'Pro SQL
Server Internals' by Dmitri Korotkevitch, with other notes from
Microsoft's documentation and various internet sources.

It's primary purpose is to help me remember stuff and provide an
overview of how it works.  I'm using SQL Server 2017 running on a
Linux Docker container to test this out, but it should work on Windows
or older versions as well.

You can use this as a starting point and overview but it should be
supplemented with additional information.  It doesn't cover best
practices, how to optimize storage, etc.

## Database Files and Filegroups

SQL Server stores data in files which are organized into filegroups.
A filegroup is a logical grouping for database files and can be
organized according to administrative, data allocation, and placement
purposes.  Each database has a primary file group which contains the
primary data file and any secondary files not placed in a user-defined
filegroup.

Data files in SQL server include the primary data file, secondary data
files, and log files.  Each database has at a minimum a primary data
file and a log file.

By utilizing filegroups and secondary data files it's possible to
optimize disk access patterns for database objects depending upon the
storage subsystem of the server.  When you create tables in the
database, you specify which filegroup the table is to be created in,
not the specific file to use.  This makes it possible to spread IO
across multiple disks to improve performance when practical.

Unlike data files, log files do not benefit from multiple files, as
they are accessed sequentially.  Transaction log files are not part of
any filegroups.

Filegroups also make it possible for the underlying physical storage
of database objects to be specified as needed at the administrative
level, allowing for developers to worry about the logical structure
when creating tables and queries, while the actual physical location
and storage optimization can take place later depending upon the
circumstances.


Below is an example of creating a database and adding files and
filegroups:

```tsql
use master
go

drop database if exists BlogDemo

create database [BlogDemo] on
primary
(name = N'BlogDemo', filename = N'/var/opt/mssql/data/blogdemo.mdf'),
filegroup [Secondary]
(name = N'secondary1', filename = N'/var/opt/mssql/data/secondary1.ndf'),
(name = N'secondary2', filename = N'/var/opt/mssql/data/secondary2.ndf')
log on
(name = N'BlogDemoLog', filename = N'/var/opt/mssql/data/blogdemo_log.ldf')
go

use BlogDemo
go
```


## Data Pages and Data Rows

The next level of depth brings us to how data is actually stored in
the data files.

I highly recommend purchasing and reading 'Pro SQL Server Internals'
which I'm working through, as the books goes into much greater depth
than I'm going to.

Data is stored in 8KB chunks called pages, which are continuously
numbered starting from zero.  Each page is made up of a header, the
data rows, free space, and a slot array.

Each row can be made up of both fixed-length data (non var* columns)
and variable length data (in addition to attributes).  The
fixed-length data is stored before the variable length data in the
row, and when combined with the size of it's attributes, must fit into
the 8,060 bytes available on the single data page.  Variable length
data can be stored on different data pages.  SQL Server will not let
you create a table where this isn't the case.

There are two undocumented methods to view how objects keep data in different pages:

* DBCC IND
* sys.dm_db_database_page_allocations - a data management function

In addition to the commands to display information on the pages, there
is an additional command, DBCC PAGE, which shows what is stored on a
page.  These commands can be used for analysing corruption issues, and
as one Microsoft blog put it, explaining things in blog posts.

Below I list some TSQL that can be used with the previously created
database to create and populate a table, and view the pages and one
page's data using the commands.


```tsql
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

select * from sys.dm_db_database_page_allocations(db_id(),
object_id('dbo.coffee', 'U'), null, null, null)


dbcc traceon(3604) -- output to console
dbcc page
(
	'BlogDemo',
	3, -- PageFID,
	8, -- PagePID,
	3 -- Output Mode: displays page header and row details
)

```

There's more information and analysis of the output from these
commands in 'Pro SQL Server Internals.'

One tip mentioned in the book is that you can reduce the size of data
rows by creating tables where variable length columns, which generally
store null values, are the last ones defined in the CREATE TABLE
statement.

When the size of the variable length data exceeds what can be stored
on a single page, SQL Server uses row-overflow pages to store the
data.  The variable length data that doesn't fit on the data page is
placed on another page, and a pointer to this page and the data's
location is stored.

If you create a table with a variable length column of great enough
size and populate it with data large enough to spill over, and then
use the prior commands to examine the pages, you will see row-overflow
data pages listed in the output.  These have a different page type
than in-row data pages.

For text, ntext, or image columns, SQL Server stores the data in
another type of pages called LOB data pages.  Again, 'Pro SQL Server
Internals' covers these in some detail.

SQL Server always stores rows that fit into a single page using in-row
allocations, and will allocate a new page for such a row instead of
using row-overflow pages.  The allocation of LOB pages can be
controlled to some extent depending upon the size of the data, but the
default is to store LOB data on LOB data pages.

## Extents and Allocation Map Pages

An extent is a logical grouping of eight pages and can be either mixed
or uniform.  By default, when a new object is created it's first eight
pages are stored in mixed extents, and afterwards in uniform extents.

Though mixed extents can save space, they can become a source of
contention on the system, especially tempdb databases, and SQL Server
allows you to configure their allocation.  Korotkevitch, in 'Pro SQL
Server Internals' recommends disabling their use, especially on busy
OLTP servers.

Allocation Maps are used to track extent and page usage in a file, and
there are several types of these.

* Global Allocation Map (GAM) - tracks if extents have been allocated
  by any objects. Each GAM tracks 64k extents.
* Shared Global Allocation Map (SGAM) - tracks information on mixed
  extents. Each SGAM tracks 64k extents.
* Index Allocation Map (IAM) - tracks the pages and extents used by
  different types of pages that belong to an object.  Every
  table/index has its own set of IAM pages, and these are combined
  into seperate linked lists to form IAM chains.
* Page Free Space (PFS) - Tracks free space in pages, each PFS page
  tracks 8,088 pages.
* Differential Changed Map (DCM) - tracks extents which have been
  modified since the last full database backup.
* Bulk Changed Map (BCM) - indicates extents that have been modified
  in minimally logged operations since the last transaction log
  backup.

The first GAM page is always the third page in the data file, the SGAM
is the fourth, and they repeat in the file every 511,230 pages,
allowing SQL Server to navigate them quickly.

The PFS is the second page in a file and every 8,088 pages
thereafter.  The DCM is the seventh page, and the BCM is the eighth.

## Practical Notes

When SQL Server performs DML queries it always loads the data into a
memory cache, called the buffer pool.  Modifications are logged
synchronously to the transaction log, and the modified pages are saved
to data files asynchronously in the background along with a special
record entered into the transaction log known as a checkpoint.

Another process called the lazy writer works to remove pages from the
buffer pool and can also save dirty pages on disk.  While the
checkpoint keeps the pages in the buffer pool, the lazy writer
processes the least recently used data pages and writes them to disk
if they are dirty before removing them from the pool.

SQL Server can generate a lot of I/O, and the size of the data rows
needs to be considered.  Larger data rows increase the number of data
pages required, increasing the number of I/O operations required, and
the amount of memory used by the buffer pool.  Using the smallest data
type possible to store information can make a big difference here when
considering a large number of rows.  Also, variable length data types
can reduce the necessary storage when appropriate.

It is also wise to specify the required columns when performing
queries and to avoid 'SELECT * ..' type operations in code.  These
types of queries can increase I/O and network traffic when unknowingly
returning data that isn't directly needed.  The use of ORMs needs to
be done carefully, as models may result in queries containing
unneccesary columns, which depending upon the column type can
significantly impact performance.

Altering tables requires SQL Server to take a schema modification lock
on the table, and depending upon the modification performed can
potentially be expensive.  In order for table alterations which
decrease the size of rows to be realized, the heap table or clustered
index must be rebuilt.

## End Notes

This post has mostly been my attempt to summarize the first chapter of
'Pro SQL Server Internals.'  I've left most detail out that the books
goes into.

While it is interesting to understand the low level mechanisms used by
SQL Server to store data, quite a bit of it may not be of use to a
developer, with the exception of awareness of the impact I/O has on
system performance.

For more information on these topics you can view the links below, and
read 'Pro SQL Server Internals.'

[Database Files and Filegroups](https://docs.microsoft.com/en-us/sql/relational-databases/databases/database-files-and-filegroups?view=sql-server-2017)

[Pages and Extents Architecture Guide](https://docs.microsoft.com/en-us/sql/relational-databases/pages-and-extents-architecture-guide?view=sql-server-2017)

[Pro SQL Server Internals](https://www.amazon.com/Pro-Server-Internals-Dmitri-Korotkevitch/dp/1484219635/ref=sr_1_fkmrnull_1?keywords=pro+sql+server+internals&qid=1554376620&s=gateway&sr=8-1-fkmrnull)

