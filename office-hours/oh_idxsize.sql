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
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
@drop bigtab
clear screen
set termout on
set echo on
create table bigtab as 
select d.* from dba_objects d,
 ( select 1 from dual 
   connect by level <= 30 );
pause   
create index big_ix1 on bigtab ( object_id );
create index big_ix2 on bigtab ( owner );
pause
clear screen
select index_name, leaf_blocks*8192/1024/1024 mb
from   user_indexes
where  table_name = 'BIGTAB';
pause
select segment_name, bytes/1024/1024 mb
from   user_segments
where  segment_name like 'BIG_IX_';
pause
clear screen
explain plan for create index myidx on bigtab ( object_id);
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for create index myidx on bigtab ( owner);
pause
select * from dbms_xplan.display();
pause
clear screen
create index big_ix3 on bigtab (default_collation);
pause
select index_name, leaf_blocks*8192/1024/1024 mb
from   user_indexes
where  table_name = 'BIGTAB';
pause
select segment_name, bytes/1024/1024 mb
from   user_segments
where  segment_name like 'BIG_IX_';
pause
select column_name, num_nulls
from user_tab_columns
where table_name = 'BIGTAB'
and column_name = 'DEFAULT_COLLATION';
pause
clear screen
explain plan for create index myidx on bigtab ( default_collation);
pause
select * from dbms_xplan.display();
pause
clear screen



set serverout on
clear screen
declare 
  l_used int;
  l_alloc int;
begin 
 dbms_space.create_index_cost (
    'create index myidx on bigtab ( default_collation)',
    l_used,
    l_alloc);
 dbms_output.put_line('l_used =' || (l_used/1024/1024)); 
end; 
.
pause
/ 
pause
clear screen
declare 
  l_used int;
  l_alloc int;
begin 
 dbms_space.create_index_cost (
    'create index myidx on bigtab ( object_id)',
    l_used,
    l_alloc);
 dbms_output.put_line('l_used =' || (l_used/1024/1024)); 
end; 
.
pause
/ 
pause
declare 
  l_used int;
  l_alloc int;
begin 
 dbms_space.create_index_cost (
    'create index myidx on bigtab ( owner)',
    l_used,
    l_alloc);
 dbms_output.put_line('l_used =' || (l_used/1024/1024)); 
end; 
/ 
pause


clear screen
select num_rows 
from user_tables
where table_name = 'BIGTAB';
pause
select column_name, num_nulls, avg_col_len
from user_tab_columns
where table_name = 'BIGTAB'
and column_name in ('OWNER','OBJECT_ID');
pause
clear screen
select c.column_name, 
      ((1/0.9 + 0.04) * (t.num_rows - c.num_nulls) * ( c.avg_col_len + 6 + 2 + 1))/1024/1024 mb
from user_tab_columns c,
     user_tables t
where c.table_name = 'BIGTAB'
and   c.column_name in ('OWNER','OBJECT_ID')
and   t.table_name = 'BIGTAB'

pause
/
pause


clear screen
select index_name, blevel, leaf_blocks, leaf_blocks*8192/1024/1024 mb
from   user_indexes
where  table_name = 'BIGTAB';
pause
select c.column_name, 
      ((1/0.9 + 0.04) * (t.num_rows - c.num_nulls) * ( c.avg_col_len + 6 + 2 + 1))/1024/1024 mb
from user_tab_columns c,
     user_tables t
where c.table_name = 'BIGTAB'
and   c.column_name in ('OWNER','OBJECT_ID','DEFAULT_COLLATION')
and   t.table_name = 'BIGTAB';
pause
clear screen

select avg_col_len
from user_tab_columns
where table_name = 'BIGTAB'
and column_name = 'DEFAULT_COLLATION';
pause
select avg(length(default_collation)) from bigtab;
pause
select c.column_name, 
      ((1/0.9 + 0.04) * (t.num_rows - c.num_nulls) * ( 14 + 6 + 2 + 1))/1024/1024 mb
from user_tab_columns c,
     user_tables t
where c.table_name = 'BIGTAB'
and   c.column_name = 'DEFAULT_COLLATION'
and   t.table_name = 'BIGTAB';

