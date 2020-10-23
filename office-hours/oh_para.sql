REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
set pages 999
set termout off
REM
REM to get multiple files for this demo
REM
REM alter tablespace demo add datafile ...
REM alter tablespace demo add datafile ...
REM alter tablespace demo add datafile ...
REM alter tablespace demo add datafile ...
drop table t;
drop table t1;
drop table rowid_list;
exec dbms_parallel_execute.drop_task('CHUNK_TASK');

set verify off
clear screen
col file_name format a60
set termout on
set echo on
select file_id, file_name
from   dba_data_files
where  tablespace_name = 'DEMO';
pause
clear screen

create table t tablespace demo
as select d.* from dba_objects d;

create table t1 tablespace demo
as select d.* from dba_objects d;
pause
clear screen
begin
 for i in 1 .. 3 loop
    insert into t 
    select d.* from dba_objects d,
     ( select 1 from dual connect by level <= 6 );

    insert into t1 
    select d.* from dba_objects d,
     ( select 1 from dual connect by level <= 6 );
 end loop;
end;
/
commit;
pause
clear screen
exec dbms_parallel_execute.create_task (task_name => 'CHUNK_TASK');
pause
begin
  dbms_parallel_execute.create_chunks_by_rowid
    (task_name   => 'CHUNK_TASK',
     table_owner => user,
     table_name  => 'T',
     by_row      => false,
     chunk_size  => 4000);
end;
/
pause
select chunk_id, status, start_rowid, end_rowid
from   user_parallel_execute_chunks
where  task_name = 'CHUNK_TASK'
order by chunk_id;
pause
clear screen

select 
  chunk_id,
  dbms_rowid.rowid_block_number(start_rowid) s_block,
  dbms_rowid.rowid_relative_fno(start_rowid) s_file,
  dbms_rowid.rowid_block_number(end_rowid) e_block,
  dbms_rowid.rowid_relative_fno(end_rowid) e_file
from   user_parallel_execute_chunks
where  task_name = 'CHUNK_TASK'
order by chunk_id;
pause
exec dbms_parallel_execute.drop_task('CHUNK_TASK');
pause
clear screen
select o.data_object_id, e.relative_fno, e.block_id, e.blocks,
           case 
             when e.block_id != 
                  nvl(lag( e.block_id + e.blocks ) 
                     over ( partition by o.data_object_id, e.relative_fno 
                        order by e.block_id ), -1)
             then row_number() 
                      over (  partition by o.data_object_id, e.relative_fno 
                        order by e.block_id )
           end contig
    from dba_extents e 
       , dba_objects o 
    where e.owner = o.owner 
    and e.segment_name = o.object_name 
    and nvl(e.partition_name, '"') = nvl(o.subobject_name, '"') 
    and e.segment_type = o.object_type 
    and e.segment_type in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
    and e.owner = user
    and e.segment_name = 'T'

pause
/
pause
clear screen

  select data_object_id, 
         relative_fno, 
         block_id, 
         blocks,
         nvl(contig,lag(contig ignore nulls) 
            over ( partition by data_object_id, relative_fno 
             order by block_id )) grp
  from
#pause
  (
    select o.data_object_id, e.relative_fno, e.block_id, e.blocks,
           case 
             when e.block_id != 
                  nvl(lag( e.block_id + e.blocks ) 
                     over ( partition by o.data_object_id, e.relative_fno 
                       order by e.block_id ), -1)
             then row_number() over (  
                       partition by o.data_object_id, e.relative_fno 
                       order by e.block_id )
           end contig
    from dba_extents e 
       , dba_objects o 
    where e.owner = o.owner 
    and e.segment_name = o.object_name 
    and nvl(e.partition_name, '"') = nvl(o.subobject_name, '"') 
    and e.segment_type = o.object_type 
    and e.segment_type in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
    and e.owner = user
    and e.segment_name = 'T'
  )

pause
/
pause
clear screen

select data_object_id,
       relative_fno, 
       min(block_id) start_block_id,
       max(block_id+blocks-1) end_block_id
#pause
from       
(  
  select data_object_id, 
         relative_fno, 
         block_id, 
         blocks,
         nvl(contig,lag(contig ignore nulls) 
            over ( partition by data_object_id, relative_fno 
              order by block_id )) grp
  from
  (
    select o.data_object_id, e.relative_fno, e.block_id, e.blocks,
           case 
             when e.block_id != 
                  nvl(lag( e.block_id + e.blocks ) 
                     over ( partition by o.data_object_id, e.relative_fno 
                        order by e.block_id ), -1)
             then row_number() over (  
                partition by o.data_object_id, e.relative_fno 
                   order by e.block_id )
           end contig
    from dba_extents e 
       , dba_objects o 
    where e.owner = o.owner 
    and e.segment_name = o.object_name 
    and nvl(e.partition_name, '"') = nvl(o.subobject_name, '"') 
    and e.segment_type = o.object_type 
    and e.segment_type in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
    and e.owner = user
    and e.segment_name = 'T'
  )
)
group by 
  data_object_id,
  relative_fno,
  grp
order by 1,2,3

pause
/
pause
clear screen


with ext as
(
select data_object_id,
       relative_fno, 
       min(block_id) start_block_id,
       max(block_id+blocks-1) end_block_id
from       
(  
  select data_object_id, 
         relative_fno, 
         block_id, 
         blocks,
         nvl(contig,lag(contig ignore nulls) 
            over ( partition by data_object_id, relative_fno 
               order by block_id )) grp
  from
  (
    select o.data_object_id, e.relative_fno, e.block_id, e.blocks,
           case 
             when e.block_id != 
                  nvl(lag( e.block_id + e.blocks )
                    over ( partition by o.data_object_id, e.relative_fno
                      order by e.block_id ), -1)
             then row_number() over (  
               partition by o.data_object_id, e.relative_fno 
                 order by e.block_id )
           end contig
    from dba_extents e 
       , dba_objects o 
    where e.owner = o.owner 
    and e.segment_name = o.object_name 
    and nvl(e.partition_name, '"') = nvl(o.subobject_name, '"') 
    and e.segment_type = o.object_type 
    and e.segment_type in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
    and e.owner = user
    and e.segment_name = 'T'
  )
)
group by 
  data_object_id,
  relative_fno,
  grp
)
select 
 dbms_rowid.rowid_create(
      rowid_type=>1
     ,object_number=>data_object_id
     ,relative_fno=>relative_fno
     ,block_number=>start_block_id
     ,row_number=>0
  ) start_rowid,
 dbms_rowid.rowid_create(
      rowid_type=>1
     ,object_number=>data_object_id
     ,relative_fno=>relative_fno
     ,block_number=>end_block_id
     ,row_number=>32767
  ) end_rowid
from ext

pause
/
pause

set termout off
clear screen
create table rowid_list as
with ext as
(
select data_object_id,
       relative_fno, 
       min(block_id) start_block_id,
       max(block_id+blocks-1) end_block_id
from       
(  
  select data_object_id, 
         relative_fno, 
         block_id, 
         blocks,
         nvl(contig,lag(contig ignore nulls) 
            over ( partition by data_object_id, relative_fno 
               order by block_id )) grp
  from
  (
    select o.data_object_id, e.relative_fno, e.block_id, e.blocks,
           case 
             when e.block_id != 
                  nvl(lag( e.block_id + e.blocks )
                    over ( partition by o.data_object_id, e.relative_fno
                      order by e.block_id ), -1)
             then row_number() over (  
               partition by o.data_object_id, e.relative_fno 
                 order by e.block_id )
           end contig
    from dba_extents e 
       , dba_objects o 
    where e.owner = o.owner 
    and e.segment_name = o.object_name 
    and nvl(e.partition_name, '"') = nvl(o.subobject_name, '"') 
    and e.segment_type = o.object_type 
    and e.segment_type in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
    and e.owner = user
    and e.segment_name = 'T'
  )
)
group by 
  data_object_id,
  relative_fno,
  grp
)
select 
 dbms_rowid.rowid_create(
      rowid_type=>1
     ,object_number=>data_object_id
     ,relative_fno=>relative_fno
     ,block_number=>start_block_id
     ,row_number=>0
  ) start_rowid,
 dbms_rowid.rowid_create(
      rowid_type=>1
     ,object_number=>data_object_id
     ,relative_fno=>relative_fno
     ,block_number=>end_block_id
     ,row_number=>32767
  ) end_rowid
from ext;
set termout on

--
-- create table ROWID_LIST as
-- select ...
--  (the previous big select)
--

set lines 60
desc rowid_list
pause

set lines 100
clear screen
exec dbms_parallel_execute.create_task (task_name => 'CHUNK_TASK');
pause

declare
  l_rowids clob;
begin
  l_rowids := 'select start_rowid, end_rowid from rowid_list';

  dbms_parallel_execute.create_chunks_by_sql
    (task_name => 'CHUNK_TASK',
     sql_stmt  => l_rowids,
     by_rowid  => true);
end;
/
pause
clear screen

select chunk_id, status, start_rowid, end_rowid
from   user_parallel_execute_chunks
where  task_name = 'CHUNK_TASK'
order by chunk_id

pause
/


