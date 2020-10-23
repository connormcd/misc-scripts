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
@drop online_sales
@clean
set echo on
create table online_sales
( c1 int,
  c2 int,
  c3 int,
  c4 int,
  c5 int,
  c6 int,
  c7 int,
  state varchar2(10),
  invoice_num varchar2(20)
);
pause
clear screen
insert into online_sales 
select rownum,rownum,rownum,rownum,rownum,rownum,rownum,null,null
from dual
connect by level <= 100000;
commit;
pause
clear screen
analyze table online_sales compute statistics;
pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause
clear screen
update online_sales
set state = 'PROCESSED', invoice_num = 'MY_INVOICE_NUM';
commit;
pause
analyze table online_sales compute statistics;
pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause
clear screen
truncate table online_sales;
pause
alter table online_sales pctfree 50;
pause
insert into online_sales 
select rownum,rownum,rownum,rownum,rownum,rownum,rownum,null,null
from dual
connect by level <= 100000;
commit;
pause
clear screen
update online_sales
set state = 'PROCESSED', invoice_num = 'MY_INVOICE_NUM';
commit;
pause
clear screen
analyze table online_sales compute statistics;
pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause
alter table online_sales move;
pause
clear screen
analyze table online_sales compute statistics;
pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause
clear screen
truncate table online_sales;
pause
alter table online_sales pctfree 1;
pause
clear screen
insert into online_sales 
select 1234567,1234567,1234567,1234567,1234567,1234567,1234567,'PROCESSED','XXXXXMY_INVOICE_NUM'
from dual
connect by level <= 200;
commit;
pause
clear screen
alter table online_sales minimize records_per_block;
pause
truncate table online_sales;
commit;
pause
clear screen
insert into online_sales 
select rownum,rownum,rownum,rownum,rownum,rownum,rownum,null,null
from dual
connect by level <= 100000;
commit;
pause
clear screen
analyze table online_sales compute statistics;

pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause

clear screen
update online_sales
set state = 'PROCESSED', invoice_num = 'MY_INVOICE_NUM';
pause
clear screen
analyze table online_sales compute statistics;

pause
select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';
pause
clear screen
alter table online_sales move;
pause

analyze table online_sales compute statistics;
pause

select num_rows, blocks, chain_cnt
from user_tables
where table_name = 'ONLINE_SALES';

