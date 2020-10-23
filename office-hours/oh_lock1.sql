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
@drop t
clear screen
set echo on
set termout on
create table t 
 ( pk   int primary key,
   name varchar2(100)
 );
insert into t
select rownum, rpad(rownum,50)
from   dual
connect by level <= 1000;

commit;
pause
clear screen
update t
set name = 'Connor'
where pk = 10;
pro *** over to session 2
pause

rollback;
pause

set termout off
@drop t
clear screen
set echo on
set termout on
create table t 
 ( pk   int primary key,
   name varchar2(100)
 );
insert into t
select rownum, rpad(rownum,50)
from   dual
connect by level <= 1000;
commit;

update t 
set name = rpad(rownum,100)
where pk between 1 and 17;
commit;
pause


update t
set name = 'Connor'
where pk = 10;
pro *** over to session 2
pause
