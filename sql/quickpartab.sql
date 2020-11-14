set echo on
set verify off
drop table &&1 cascade constraints purge;
create table &&1
partition by range ( object_id )
interval ( 20000 )
( 
  partition p1 values less than ( 20000 )
)
as select d.* from dba_objects d,
  ( select 1 from dual connect by level <= &&2 )
where object_id is not null;
  
create index &&1._ix1 on &&1 ( object_id ) local;

create index &&1._ix2 on &&1 ( object_name);

set echo off
set verify on
