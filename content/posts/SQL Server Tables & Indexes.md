---
title: "SQL Server Tables & Indexes"
date: 2019-04-16T07:48:35-04:00
draft: true
series: tech
---

SQL Server stores data in tables, with the data stored in a unsorted
or sorted arrangement on disk depending upon index definitions.  By
default, data is stored in an unsorted arrangement using a heap table,
and only stored in a sorted manner when a clustered index is defined.

Generally tables with a clustered index will outperform heap tables.
Having a clustered index defined allows for faster query operations in
general, and in many cases is dramatically faster than not having an
index.  In addition to the performance benefits when querying data,
indexes also help prevent deadlocks and reduce the locks SQL Server
needs to acquire in many instances due to the reduced need to scan the
entire table.

Indexes are defined on a column or set of columns.  In the case of a
clustered index this causes the table data to be stored in a sorted
order on disk using a B-Tree.  Nonclustered indexes maintain a
seperate sorted data structure, however, instead of maintaining the
table data in order, the nonclustered index maintains pointers to the
row-id of the data.  Like clustered indexes, nonclustered indexex also
use a B-Tree sorted based on the specifid column(s).

The row-id of a nonclustered indexes reference either the actual
location of the rows in the data file in the case of a heap table, or
reference the clustered index key in the case of a clusterd index
being defined.

When a nonclustered index is used SQL Server must perform either a key
lookup or RID lookup to find the data in either the clustered or heap
table.  These reads take place from different places in the data file,
and can generate a lot of random I/O activity.  When SQL Server
determines that a large number of lookups will need to be performed,
it may not use the nonclustered index, and instead choose to perform a
scan.

SQL Server access data in a heap table through the IAM pages,
accessing the data the order the pages were allocated.

SQL Server can read data from an index in three different ways.

An ordered scan is when SQL server accesses the data based upon the
order of the index key.  This is displayed in the execution plan
properties window as a clustered index scan with the ordered property
set to true.  It is not necessary for an order by clause to be used to
trigger this type of scan.

Also available, although typically only used on large tables and when
the data is read in READ UNCOMMITTED or SERIALIZABLE
transaction-isolation levels, is an allocation order scan.  Here, SQL
Server accesses the data through the IAM pages, similar to a heap
table.  This type of scan can be faster for larger tables, however it
can produce inconsistent results, as rows can be skipped or read
multiple times due to page splits.







