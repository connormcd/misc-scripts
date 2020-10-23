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
set arraysize 15
@clean
set termout on
set echo on
--
-- allow SCOTT to query V$
--
conn / as sysdba
grant select any dictionary to scott;
pause 

clear screen
conn scott/tiger
drop table t purge;
create table t pctfree 0
as select owner, object_id, subobject_name
from all_objects,
     ( select 1 from dual connect by level <= 10 );
 
select count(*) from t;
pause
clear screen
--
-- reset session stats
--
conn scott/tiger
pause

set feedback only
select * from t

pause 
/
set feedback on
select * from v$mystat where statistic# = (
  select statistic# from  v$statname 
  where name = 'table scan rows gotten' );

pause

clear screen
--
-- reset session stats
--
conn scott/tiger
set feedback only
select owner, object_id,subobject_name from t

pause
/
set feedback on
select * from v$mystat where statistic# = (
  select statistic# from  v$statname 
  where name = 'table scan rows gotten' );
pause

clear screen
--
-- reset session stats
--
conn scott/tiger
set feedback only
select owner, object_id,subobject_name,'x' from t

pause
/
set feedback on
select * from v$mystat where statistic# = (
  select statistic# from  v$statname 
  where name = 'table scan rows gotten' );
 
pause 
clear screen
--
-- reset session stats
--
conn scott/tiger
set feedback only
select object_id, owner from t

pause
/
 
set feedback on
select * from v$mystat where statistic# = (
  select statistic# from  v$statname 
  where name = 'table scan rows gotten' );
 
pause
--
-- PAUSE HERE FOR WHERE 24 MILLION CAME FROM
--
pause
clear screen

select table_name, num_rows,blocks,empty_blocks,avg_row_len
from   user_tables
where  table_name = 'T';
pause

select 8100 / avg_row_len rows_per_blk
from   user_tables
where  table_name = 'T';
pause

select rownum r, 15 magic_number, 15*rownum rows_in_block
from   dual
connect by level <= (736/15)+1;
pause

show arraysize
pause

select sum(15*rownum) rows_plus_skipped_rows
from   dual
connect by level <= (736/15)+1;
pause

select 19125 * blocks
from   user_tables
where  table_name = 'T';
pause

--
-- reset session stats
--
conn scott/tiger
set arraysize 100
set feedback only
select object_id, owner from t

pause
/
 
set feedback on
select * from v$mystat where statistic# = (
  select statistic# from  v$statname 
  where name = 'table scan rows gotten' );
