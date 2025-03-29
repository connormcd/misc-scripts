clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t1
@drop t2
@drop seq
col data_default format a30
col high_value format a88
col high_value_clob format a88
col high_value_json format a88
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |   _   _  ____        _      ____  _   _  _____        ______ _____  
prompt |  | \ | |/ __ \      | |    / __ \| \ | |/ ____|      |  ____|  __ \ 
prompt |  |  \| | |  | |     | |   | |  | |  \| | |  __ ______| |__  | |__) |
prompt |  | . ` | |  | |     | |   | |  | | . ` | | |_ |______|  __| |  _  / 
prompt |  | |\  | |__| |     | |___| |__| | |\  | |__| |      | |____| | \ \ 
prompt |  |_| \_|\____/      |______\____/|_| \_|\_____|      |______|_|  \_\
prompt |                                                                     
prompt |                                                                     
pause
set echo on
create sequence seq;
pause
create table t1
( pk            int,
  invoice_num   number default seq.nextval,
  customer_name varchar2(10)
  );
pause
select column_name, data_default
from   user_tab_cols
where  table_name = 'T1';
pause
select column_name, data_default
from   user_tab_cols
where  data_default like '%"SEQ"%';
pause
set lines 70
desc user_tab_cols
pause
set lines 200
select column_name, data_default
from   user_tab_cols
where  data_default_vc like '%"SEQ"%';
pause
clear screen
create table t2
partition by range ( created )
( partition p1 values less than ( date '2023-01-01' ),
  partition p2 values less than ( date '2024-01-01' ),
  partition p3 values less than ( date '2025-01-01' ),
  partition p4 values less than ( date '2026-01-01' ),
  partition p5 values less than ( date '2027-01-01' )
)
as select * from user_objects;
pause
select partition_name, high_value
from user_tab_partitions
where table_name = 'T2';
pause
select max(high_value)
from user_tab_partitions
where table_name = 'T2';
pause
set lines 70
desc user_tab_partitions
pause
set lines 200
select partition_name, high_value_clob
from user_tab_partitions
where table_name = 'T2';
pause
select partition_name, high_value_json
from user_tab_partitions
where table_name = 'T2';
pause
select partition_name, json_value(high_value_json, '$.high_value' returning date) as dte
from user_tab_partitions
where table_name = 'T2';

pause Done

