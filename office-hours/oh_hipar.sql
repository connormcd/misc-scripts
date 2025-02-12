REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
undefine todrop
alter session set "_partition_large_extents" = false;
@drop t
set termout on
clear screen
set echo on

create table t ( x date , y int ) tablespace demo 
partition by range ( x )
interval ( numtodsinterval(30,'MINUTE') )
( partition p1 values less than ( date '2020-01-01' ));
insert into t
select date '2020-01-01' + rownum/86400, rownum
from
( select 1 from dual connect by level <= 86400 ),
( select 1 from dual connect by level <= 60 );
commit;
pause
select min(x), max(x)
from   t;
pause
clear screen
select count(*)
from   user_tab_partitions
where  table_name = 'T';
pause
set timing on
begin
for i in ( 
  select partition_name
  from   user_tab_partitions
  where  table_name = 'T'
  and    partition_position <= 2*24
  )
loop
  execute immediate 'alter table t drop partition '||i.partition_name;
end loop;
end;
.

pause
/
pause
set timing off
clear screen
select partition_name, interval
from   user_tab_partitions
where  table_name = 'T'
and partition_position <= 5
order by partition_position;
pause
select partition_name, interval
from   user_tab_partitions
where  table_name = 'T'
order by partition_position;
pause
set echo off
clear screen
pro |
pro | BACK TO SLIDES
pro |
pause
set echo on 
clear screen
alter table T set interval ( numtodsinterval(30,'MINUTE') );
pause
select partition_name, interval
from   user_tab_partitions
where  table_name = 'T'
order by partition_position;
pause
clear screen
set timing on
begin
for i in ( 
  select partition_name
  from   user_tab_partitions
  where  table_name = 'T'
  and    partition_position <= 2*24
  )
loop
  execute immediate 'alter table t drop partition '||i.partition_name;
end loop;
end;
.

pause
/

drop table t purge;
