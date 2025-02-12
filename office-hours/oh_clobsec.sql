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
drop table clob_test purge;
alter session set db_securefile = preferred;
set termout on
clear screen
set echo on
show parameter db_secure
pause
create table clob_test
(
sale_id number,
product_id number,
price number,
clb1 clob
);
pause
alter table clob_test add clb2 clob;
pause
select column_name, securefile 
from user_lobs 
where table_name = 'CLOB_TEST';
pause
clear screen
drop table clob_test purge;
pause
create table clob_test
(
sale_id number,
product_id number,
price number,
clb1 clob
)
partition by range(sale_id) (
partition s1 values less than (10),
partition s2 values less than (20),
partition s3 values less than (MAXVALUE)
);
pause
clear screen
alter table clob_test add clb2 clob;
pause
select column_name, securefile 
from user_lobs 
where table_name = 'CLOB_TEST';
pause
clear screen
drop table clob_test purge;
pause
show parameter db_secure
pause
alter session set db_securefile = always;
pause
show parameter db_secure
pause
clear screen
create table clob_test
(
sale_id number,
product_id number,
price number,
clb1 clob
)
partition by range(sale_id) (
partition s1 values less than (10),
partition s2 values less than (20),
partition s3 values less than (MAXVALUE)
);
pause
alter table clob_test add clb2 clob;
pause
select column_name, securefile 
from user_lobs 
where table_name = 'CLOB_TEST';
pause
clear screen
drop table clob_test purge;
pause
alter session set db_securefile = force;
pause
show parameter db_secure
pause
clear screen
create table clob_test
(
sale_id number,
product_id number,
price number,
clb1 clob
)
partition by range(sale_id) (
partition s1 values less than (10),
partition s2 values less than (20),
partition s3 values less than (MAXVALUE)
);
pause
alter table clob_test add clb2 clob;
pause
select column_name, securefile 
from user_lobs 
where table_name = 'CLOB_TEST';
