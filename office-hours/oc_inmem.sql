REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
@clean
set termout off
alter system set inmemory_virtual_columns = manual;
@drop t
@clean
set echo on
set termout on
create table t (
       owner varchar2(30),
       object_type varchar2(80),
       object_id number,
       object_details generated always as ( sqrt(sqrt(sqrt(sqrt(object_id))))));
pause       
insert /*+ APPEND */ into t (owner,object_type,object_id)
    select owner,object_type,object_id
    from dba_objects, ( select 1 from dual connect by level <= 20 );
commit;
pause
clear screen
set timing on
select max(object_details)
from t;
set timing off

pause
alter table t inmemory;
select count(*) from t;
col owner format a10
col segment_name format a10
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause

clear screen
set timing on
select max(object_details)
from t;
set timing off
pause
select * from dbms_xplan.display_cursor();
pause
clear screen
show parameter inmemory_virtual_columns
pause

alter table t inmemory(object_details);
pause
select count(*) from t;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause

set timing on
select max(object_details)
from t;
set timing off
pause

clear screen
alter table t no inmemory;
pause
alter table t inmemory;
pause
alter table t inmemory(object_details);
pause
select count(*) from t;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause

clear screen
set timing on
select max(object_details)
from t

pause
/
set timing off

--
-- On to detection
--
pause

clear screen
alter table t no inmemory;
alter table t inmemory;
pause
select count(*) from t;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
clear screen
select table_name, column_name, inmemory_compression 
from v$im_column_level
where table_name = 'T';
pause
alter table t inmemory(object_details);
pause
clear screen
select table_name, column_name, inmemory_compression 
from v$im_column_level
where table_name = 'T';
pause

select count(*) from v$imeu_header;
pause

clear screen

alter table t no inmemory;
alter table t inmemory;
alter table t inmemory(object_details);
select count(*) from t;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select count(*) from v$imeu_header;

--
-- Onto non virtual column example
--
pause
set termout off
clear screen
@drop t
@clean
set echo on
set termout on

create table t
    as
    select d.*
    from dba_objects d, ( select 1 from dual connect by level <= 20 );
pause

alter table t
       inmemory memcompress for query( owner,object_id )
       inmemory memcompress for dml ( object_type)
       inmemory memcompress for query high( object_name )
       inmemory memcompress for capacity low( created )
       inmemory memcompress for capacity high( status )
       no inmemory( duplicated, sharded ) ;
pause
clear screen
select count(*) from t;
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause

select  owner,segment_column_id,column_name, inmemory_compression
from v$im_column_level
order by 2 ;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause

clear screen

alter table t inmemory;
select count(*) from t;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select owner,segment_name,bytes,bytes_not_populated,populate_status from v$im_segments;
pause
select  owner,segment_column_id,column_name, inmemory_compression
from v$im_column_level
order by 2 ;



