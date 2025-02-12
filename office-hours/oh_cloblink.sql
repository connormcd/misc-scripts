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
conn scott/tiger@DB_SERVICE
set termout off
drop database link getclob;
conn scott/tiger@remotedb
set termout off
drop database link getclob;
drop table gtt;
conn MYUSER/PASSWORD@//192.168.1.180/db11
set termout off
clear screen
drop table scott.t purge;
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
create table scott.t ( c clob );
pause
insert into scott.t 
values (rpad('x',32000,'x'));
pause
commit;
clear screen
conn scott/tiger@remotedb
pause
create database link getclob
connect to scott
identified by tiger
using '192.168.1.180/db11';
pause
set lines 60
desc t@getclob
pause
select *
from t@getclob;
pause
clear screen
create global temporary table gtt
( c clob );
pause
insert into gtt
select * from t@getclob;
pause
select * from gtt;
pause
commit;
pause
set echo off
clear screen
prompt |
prompt | The true problem ?
prompt |
pause
set echo on
select banner
from v$version@getclob
where rownum = 1;
pause
select banner
from v$version
where rownum = 1;
pause
clear screen
conn scott/tiger@DB_SERVICE
pause
select banner
from v$version
where rownum = 1;
pause
create database link getclob
connect to scott
identified by tiger
using '192.168.1.180/db11';
pause
select * from t@getclob;
pause
clear screen
conn scott/tiger@remotedb19
pause
select banner
from v$version
where rownum = 1;
pause
drop table t purge;
create table t ( c clob );
pause
insert into scott.t 
values (rpad('x',32000,'x'));
commit;
pause
conn scott/tiger@DB_SERVICE
pause
drop database link getclob;
create database link getclob
connect to scott
identified by tiger
using '192.168.1.184/pdb1';
pause
select * from t@getclob;
