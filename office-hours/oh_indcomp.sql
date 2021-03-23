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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
undefine dobj
drop table t purge;
col subobject_name format a20
set verify off
set termout on
set echo on
clear screen

create table t as
select a.* 
from dba_objects a,
 ( select 1 from dual connect by level <= 5 );
pause

create index t_idx on t( owner,object_type,object_id );               
pause
clear screen
select compression, leaf_blocks
from user_indexes
where index_name ='T_IDX';
pause
alter index t_idx rebuild compress advanced low;
pause
select compression, leaf_blocks
from user_indexes
where index_name ='T_IDX';
pause

clear screen
drop table t purge;
pause
create table t 
partition by range( object_id)
( 
  partition p1 values less than ( 10000 ),
  partition p2 values less than ( 40000 ),
  partition p3 values less than ( 300000 )
) 
as
select a.* 
from dba_objects a,
 ( select 1 from dual connect by level <= 5 )
where object_id is not null;
pause                
create index t_idx on t( owner,object_type,object_id ) local;               
pause
clear screen
select partition_name,compression,leaf_blocks
from user_ind_partitions
where index_name ='T_IDX';
pause
alter index t_idx modify partition p2 compress advanced low;
pause
select partition_name,compression,leaf_blocks
from user_ind_partitions
where index_name ='T_IDX';
pause
alter index t_idx rebuild partition p2;
pause
select partition_name,compression,leaf_blocks
from user_ind_partitions
where index_name ='T_IDX';
pause
clear screen
select object_id, data_object_id, subobject_name
from   user_objects
where  object_name = 'T_IDX';
pause
col object_id new_value dobj
select object_id
from   user_objects
where  object_name = 'T_IDX'
and    subobject_name is null;
pause
clear screen
with leaf_blks as (
select /*+ materialize index(t t_idx) */ object_id,
  sys_op_lbid( &&dobj ,'L',t.rowid) as blk
from t 
)
select blk, count(*)
from   leaf_blks
where object_id < 10000
group by blk

pause
/
pause
clear screen
with leaf_blks as (
select /*+ materialize index(t t_idx) */ object_id,
  sys_op_lbid( &&dobj ,'L',t.rowid) as blk
from t 
)
select c, count(*)
from (
  select blk, count(*) c
  from   leaf_blks
  where object_id < 10000
  group by blk
)
group by c
order by 1

pause
/
pause
clear screen
select avg_col_len
from   user_tab_cols
where  table_name = 'T'
and    column_name in ('OWNER','OBJECT_TYPE','OBJECT_ID' );
pause
select 8192/(10+sum(avg_col_len))
from   user_tab_cols
where  table_name = 'T'
and    column_name in ('OWNER','OBJECT_TYPE','OBJECT_ID' );
pause
clear screen
alter index t_idx rebuild partition p1 compress advanced low;
pause
with leaf_blks as (
select /*+ materialize index(t t_idx) */ object_id,
  sys_op_lbid( &&dobj ,'L',t.rowid) as blk
from t 
)
select c, count(*)
from (
  select blk, count(*) c
  from   leaf_blks
  where object_id < 10000
  group by blk
)
group by c
order by 1;
pause
clear screen
select partition_name,compression,leaf_blocks
from user_ind_partitions
where index_name ='T_IDX';
pause
clear screen

analyze index t_idx partition (p3) validate structure;
pause
select lf_cmp_blks, lf_uncmp_blks from index_stats;
pause
alter index t_idx rebuild partition p3 compress advanced low;
pause
analyze index t_idx partition (p3) validate structure;
pause
select lf_cmp_blks, lf_uncmp_blks from index_stats;
pause
set termout off
clear screen 
conn USERNAME/PASSWORD@DATABASE_SERVICE
analyze index t_idx partition (p3) validate structure online;
pause
select * from index_stats;


