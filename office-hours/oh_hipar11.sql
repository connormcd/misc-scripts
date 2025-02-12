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
connect MYUSER/PASSWORD@//192.168.1.180/db11
set termout off
undefine todrop
@drop t
set termout on
clear screen
set echo on
select banner from v$version where rownum = 1;
pause
clear screen
create table t ( x date , y int )
partition by range ( x )
interval ( numtodsinterval(1,'DAY') )
( partition p1 values less than ( date '2020-01-01' ));
insert into t
select date '2020-01-01' + rownum, rownum
from dual connect by level <= 12;
commit;
pause
select min(x), max(x)
from   t;
pause
clear screen
select partition_name
from   user_tab_partitions
where  table_name = 'T'
order by partition_position;
pause
clear screen
col partition_name new_value todrop
select partition_name
from   user_tab_partitions
where  table_name = 'T'
and    partition_position = 5;
pause
alter table T drop partition &&todrop;

pause
clear screen
col partition_name new_value todrop
select partition_name
from   user_tab_partitions
where  table_name = 'T'
and    partition_position = 5;
pause
alter table T drop partition &&todrop;

pause
clear screen
select partition_name
from   user_tab_partitions
where  table_name = 'T'
order by partition_position;
pause
alter table T drop partition p1;

