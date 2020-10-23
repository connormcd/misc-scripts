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
conn USER/PASSWORD@//HOST/MYDB
set termout off
@drop t1
@drop t2
set echo on
set termout on
clear screen

create table t1 
( x1 varchar2(2000),
  x2 varchar2(4000)
);
pause
create index t1x1 on t1 ( x1 );
create index t1x2 on t1 ( x2 );
pause
clear screen

create table t2 
( x1 varchar2(2000 char),
  x2 varchar2(4000 char)
);
pause
create index t2x1 on t2 ( x1 );
create index t2x2 on t2 ( x2 );
pause
clear screen
conn sys/SYS_PASSWD@//HOST/MYDB as sysdba
set echo on
pause
show parameter max_string_size
pause
alter system set max_string_size = EXTENDED scope=spfile;
pause
shutdown immediate
pause
conn sys/SYS_PASSWD@//HOST/MYDB as sysdba
set echo on
clear screen
startup
pause
shutdown immediate
pause
conn sys/SYS_PASSWD@//HOST/MYDB as sysdba
pause
set echo on
startup upgrade
pause
clear screen
--
-- Time to run @?/rdbms/admin/utl32k.sql
--
pause
@?/rdbms/admin/utl32k.sql
pause
shutdown immediate
pause
clear screen
conn sys/SYS_PASSWD@//HOST/MYDB as sysdba
set echo on
pause
startup 
pause
clear screen
select warning from sys.utl32k_warnings;
pause
col table_name format a20
col column_name format a20
set lines 200
select table_name, column_name, char_length, char_col_decl_length, data_length
from dba_tab_cols
where table_name in ('T1','T2');
pause
clear screen
create table t2 
( x1 varchar2(2000 char),
  x2 varchar2(4000 char)
);
pause
create index t2x1 on t2 ( x1 );
create index t2x2 on t2 ( x2 );
