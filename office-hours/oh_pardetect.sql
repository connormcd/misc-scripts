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
set pages 999
@drop t
@drop t1
@drop prev_part_tables
@drop prev_tab_partitions
@drop sales
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t
partition by list ( owner) automatic
( partition p1 values ('SYS' ))
as select * from dba_objects
where owner in ('SYS','SYSTEM','SCOTT','MDDATA','HR','XDB');
pause
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
create table prev_part_tables as
select owner, table_name, partition_count
from  dba_part_tables
where owner = 'MYUSER';
pause
insert into t ( owner, object_name) values ('2','a');
pause
select partition_name, num_rows
from   user_tab_partitions
where  table_name = 'T'
order by partition_position;
pause
create table t1
partition by list ( owner) automatic
( partition p1 values ('SYS' ))
as select * from dba_objects
where owner in ('SYS','SYSTEM');
pause
exec dbms_stats.gather_table_stats('','T1');
pause
clear screen
create or replace
procedure check_for_new_partitions is
  l_prev_par varchar2(128);
  l_prev_rows int;
begin  
  for i in 
    (select cur.owner,
            cur.table_name,
            cur.partition_count,
            prev.partition_count prev_count
     from   prev_part_tables prev,
            ( select owner, table_name, partition_count
              from   dba_part_tables
              where  owner = 'MYUSER'
            ) cur
     where  cur.owner      = prev.owner(+)
     and    cur.table_name = prev.table_name(+)
    )    
#pause    
  loop
    if i.prev_count is null then -- new table
       dbms_output.put_line(
          'new table '||i.owner||'.'||i.table_name);
       insert into prev_part_tables 
          (owner,table_name,partition_count)
       values 
          (i.owner,i.table_name,i.partition_count);
#pause    
    else
      for j in ( 
         select p.table_name,
                p.partition_name , 
                o.created, 
                p.partition_position
         from   dba_tab_partitions p,
                dba_objects o
         where  p.table_owner        = i.owner
         and    p.table_name         = i.table_name
         and    p.table_owner        = o.owner
         and    p.table_name         = o.object_name
         and    p.partition_name     = o.subobject_name
         and    p.partition_position > 1
         and    p.num_rows           is null
         and    o.created            > sysdate - 1/24 
         order by p.partition_position
       )
#pause    
      loop 
         dbms_output.put_line(
           j.table_name||'.'||j.partition_name||' created at '||
           to_char(j.created,'dd/mm-hh24mi'));
        
         select partition_name, num_rows
         into   l_prev_par, l_prev_rows
         from   dba_tab_partitions
         where  table_owner        = i.owner
         and    table_name         = i.table_name
         and    partition_position = j.partition_position - 1;

#pause    
         if l_prev_rows > 0 then
           dbms_output.put_line(
             'Copy stats to '||j.partition_name||
             ' from '||l_prev_par);

           dbms_stats.copy_table_stats (
              ownname=>i.owner,
              tabname=>i.table_name,
              srcpartname=>l_prev_par,
              dstpartname=>j.partition_name);
         else
           dbms_output.put_line(
             'Previous '||l_prev_par||
             ' also null stats');
         end if;
#pause    
         
      end loop;
      update prev_part_tables
      set    partition_count = i.partition_count
      where  owner = i.owner
      and    table_name = i.table_name;
    end if;
  end loop;
end;
.
pause
/
pause
clear screen
set serverout on
exec check_for_new_partitions
pause
exec check_for_new_partitions


