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
conn SYS_USER/PASSWORD@MY_PDB
set termout off
clear screen
@drop t
@drop par
set timing off
set time off
set pages 999
set lines 200
set termout on
set serverout on
clear screen
set feedback on
set echo on
create table t 
as select 99 key, s.* 
from scott.emp s;
pause
select bytes
from user_segments
where segment_name = 'T';
pause
clear screen
create table par 
partition by list ( key )
( partition p1 values ( 99 ) )
as select * from t;
pause
select partition_name
from user_tab_partitions
where table_name = 'PAR';
pause
select bytes
from user_segments
where segment_name = 'PAR';
pause
clear screen
drop table t purge;
drop table par purge;
pause
clear screen
create table t (
  c1 int,
  c2 int,
  c3 clob,
  c4 clob,
  c5 blob);
pause
insert into t
select rownum, rownum, rpad(rownum,4000), rpad(rownum,4000), hextoraw(rpad('F',4000,'F'))
from dual
connect by level <= 20;
commit;
pause
select sum(bytes)/1024/1024 mb
from user_segments
where segment_name = 'T' or segment_name in ( 
  select segment_name from user_lobs
  where table_name = 'T'
  union all
  select index_name from user_lobs
  where table_name = 'T'
);  
pause
select segment_name,  bytes
from user_segments
where segment_name = 'T' or segment_name in (
  select segment_name from user_lobs
  where table_name = 'T'
  union all
  select index_name from user_lobs
  where table_name = 'T'
);
pause
clear screen
create table par 
partition by list ( c1 ) automatic
( partition p1 values ( 1 ) )
as select * from t;
pause
select sum(bytes)/1024/1024 mb
from user_segments
where segment_name = 'PAR' or segment_name in ( 
  select segment_name from user_lobs
  where table_name = 'PAR'
  union all
  select index_name from user_lobs
  where table_name = 'PAR'
);  
pause
select segment_name, partition_name, bytes
from user_segments
where segment_name = 'PAR' or segment_name in ( 
  select segment_name from user_lobs
  where table_name = 'PAR'
  union all
  select index_name from user_lobs
  where table_name = 'PAR'
)

pause
/
pause
clear screen
conn SYS_USER/PASSWORD@MY_PDB as sysdba
pause
col name format a40
col value format a30
select x.ksppinm  name,
       y.kspftctxvl  value
from   sys.x$ksppi  x,
       sys.x$ksppcv2  y
where  x.ksppinm like '%partition_large%'
and    x.indx+1 = y.kspftctxpn;

