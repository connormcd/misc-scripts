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
@drop par
rem @drop chd
set termout off
rem   create table chd nologging tablespace largets as
rem   select d.*, mod(rownum, 50000)+1 p
rem   from dba_objects d,
rem   ( select 1 from dual 
rem     connect by level <= 300 );
alter table chd noparallel;
alter table chd drop constraint chd_fk;
set timing off
set pages 999
set termout on
clear screen
set echo on
create table par as 
select rownum p, d.* 
from dba_objects d;
pause
alter table par add primary key (p );
pause
select num_rows, blocks
from   user_tables
where  table_name = 'CHD';
pause

--
-- prepare session 2
--
--   delete from chd where rownum = 1;
--
pause
set timing on
alter table chd add constraint chd_fk
  foreign key ( p ) 
  references par (p );
set timing off
--
-- leave session 2 transaction open
--
pause
alter table chd drop constraint chd_fk;
--
--  session 2: prepare to delete another and rollback
--
pause
alter table chd drop constraint chd_fk online;
pause
clear screen
alter table chd add constraint chd_fk
  foreign key ( p ) 
  references par (p ) enable novalidate;
pause
--
-- prepare session 2
--
--   delete from chd where rownum = 1;
--
pause
alter table chd modify constraint chd_fk enable validate;
pause
--
--  rollback session 2
--
pause
clear screen
alter table chd drop constraint chd_fk;
pause
--
-- run session 2
--
--   delete from chd where rownum = 1;
--
pause
alter table chd add constraint chd_fk
  foreign key ( p ) 
  references par (p ) enable novalidate;
pause
--
-- rollback session 2
--
pause
clear screen
alter table chd drop constraint chd_fk;
alter table chd parallel;
alter table par parallel;
pause
--
-- get oh_active ready in session 2
--
pause
set timing on
alter table chd add constraint chd_fk
  foreign key ( p ) 
  references par (p );
set timing off
pause
alter table chd drop constraint chd_fk;
pause
alter table chd add constraint chd_fk
  foreign key ( p ) 
  references par (p ) enable novalidate;
pause
set timing on
alter table chd modify constraint chd_fk enable validate;
set timing off
