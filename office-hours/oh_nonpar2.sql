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
clear screen
set timing off
set time off
@drop t
@drop t1
@drop seq
drop view par_view;
begin
for i in ( select table_name from user_tables
            where table_name like 'PVIEW%' )
loop
 execute immediate 'drop table '||i.table_name||' purge';
end loop;
end;
/
col partition_name format a20
col high_value format a30
set autotrace off
set pages 999
set termout on
clear screen
set echo on
create table t
partition by list ( owner) automatic
( partition p1 values ('SYS' ))
as select * from dba_objects
where owner in ('SYS','SYSTEM','SCOTT','HR');
pause
select partition_name, high_value
from   user_tab_partitions
where  table_name = 'T';
pause
set serverout on format wrap
clear screen
declare
  l_new_tname varchar2(100);
  
  procedure ddl(d varchar2) is
  begin
    dbms_output.put_line(d);
    execute immediate d;
    dbms_output.new_line;
  end;
begin
  for i in (
    select partition_name, high_value, partition_position
    from   user_tab_partitions
    where  table_name = 'T' 
    order by 3
  )
  loop  
    l_new_tname := i.high_value;
    l_new_tname := 'PVIEW_'||replace(l_new_tname,'''');
    ddl('create table '||l_new_tname||chr(10)||
        ' for exchange with table t');

    ddl('alter table t exchange partition '||
        i.partition_name||chr(10)||
        ' with table '||l_new_tname);
        
  end loop;
end;
.

pause
/
pause
clear screen
select table_name 
from   user_tables
where  table_name like 'PVIEW%' ;
pause
clear screen
set serverout on format wrap
declare
  l_new_tname varchar2(100);
  l_high_val varchar2(100);
  l_view_ddl  clob := 
   'create or replace view par_view as '||chr(10);
  
  procedure ddl(d varchar2) is
  begin
    dbms_output.put_line(d);
    execute immediate d;
    dbms_output.new_line;
  end;
begin
  for i in (
    select partition_name, high_value, partition_position
    from   user_tab_partitions
    where  table_name = 'T' 
    order by 3
  )
  loop  
    l_high_val := i.high_value;
    l_new_tname := 'PVIEW_'||replace(l_high_val,'''');
    ddl('alter table '||l_new_tname||chr(10)||
        ' add constraint '||l_new_tname||'_chk'||chr(10)||
        ' check ( owner = '||l_high_val||')'
        );

    l_view_ddl := l_view_ddl||
       case when i.partition_position > 1 then ' union all ' end||
      'select * from '||l_new_tname||chr(10);
  end loop;
  ddl(l_view_ddl);
end;
.
pause
/
pause
clear screen
set lines 60
desc par_view
pause
set lines 120
set autotrace traceonly explain
select *
from par_view
where owner = 'HR';
set autotrace off