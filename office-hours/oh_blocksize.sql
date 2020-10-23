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
conn USER/PASSWORD
@drop t
@clean
set echo on
set termout on

select tablespace_name, block_size
from   dba_tablespaces;
pause

sho parameters db_16k_cache_size
pause


select owner, segment_name, segment_type 
from   dba_segments
where  tablespace_name = 'USERS'
and    segment_name not like '%$%'

pause
/

pause


drop table t purge;
clear screen
create table t ( x int, y int );
insert into t 
select rownum, rownum
from dual
 connect by level < 100;
pause
alter table t add constraint t_pk primary key ( x ) ;
create index t_ix on t ( y );
pause
clear screen
select segment_name, tablespace_name
from   user_segments
where  segment_name in ('T','T_PK','T_IX');
pause
alter table t move tablespace demo16k online;
pause

select segment_name, tablespace_name
from   user_segments
where  segment_name in ('T','T_PK','T_IX');

pause
clear screen
alter table t move tablespace demo16k 
update indexes 
(
  t_pk tablespace demo16k,
  t_ix tablespace demo16k
 )
online;
pause

select segment_name, tablespace_name
from   user_segments
where  segment_name in ('T','T_PK','T_IX');

pause
drop table t purge;
clear screen

create table t ( x int, y clob );

insert into t 
select rownum, rpad(rownum, 8000) from dual
 connect by level < 100;

select segment_name, index_name from user_lobs
where table_name = 'T';
pause
clear screen
alter table t move tablespace demo16k online;

select segment_name, tablespace_name
from   user_segments
where  segment_name in 
(  select segment_name
   from   user_lobs
   where  table_name = 'T'
   union all
   select index_name
   from   user_lobs
   where  table_name = 'T'
);
pause
clear screen
alter table t move tablespace demo16k 
lob ( y ) store as ( tablespace demo16k) online;

pause

select segment_name, tablespace_name
from   user_segments
where  segment_name in 
(  select segment_name
   from   user_lobs
   where  table_name = 'T'
   union all
   select index_name
   from   user_lobs
   where  table_name = 'T'
);
pause


drop table t purge;
clear screen

create table t ( x int, y int )
partition by list (x)
subpartition by list (y)
( 
  partition p1 values (1)
    ( subpartition p1s1 values (1),
      subpartition p1s2 values (2)
    ),
  partition p2 values (2)
    ( subpartition p2s1 values (1),
      subpartition p2s2 values (2)
    )
);    
pause    
alter table t move tablespace demo16k online;
pause
alter table t move partition p1 tablespace demo16k online;
pause
alter table t move subpartition p1s1 tablespace demo16k online;
