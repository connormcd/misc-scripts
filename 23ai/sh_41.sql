clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set long 1000
clear screen
@drop tmp_data
drop table sh.external_feed purge;
create table sh.external_feed as select * from sh.sales where rownum <= 10000;
purge recyclebin;
set termout on
set echo off
prompt | 
prompt | 
prompt |    _____ _______       _____ _____ _   _  _____ 
prompt |   / ____|__   __|/\   / ____|_   _| \ | |/ ____|
prompt |  | (___    | |  /  \ | |  __  | | |  \| | |  __ 
prompt |   \___ \   | | / /\ \| | |_ | | | | . ` | | |_ |
prompt |   ____) |  | |/ ____ \ |__| |_| |_| |\  | |__| |
prompt |  |_____/   |_/_/    \_\_____|_____|_| \_|\_____|
prompt |                                                 
prompt |                                                                                              
pause
set echo on
clear screen
create table tmp_data
as select * from sh.external_feed;
pause
insert /*+ APPEND */ into sh.sales
select * from tmp_data;
pause
roll;
pause
clear screen
drop table tmp_data purge;
pause
create table tmp_data FOR STAGING
as select * from sh.external_feed;
pause
exec dbms_stats.gather_table_stats('','TMP_DATA');
pause
alter table tmp_data move compress;
pause
show parameter recyclebin
pause
drop table tmp_data;
pause
show recyclebin
pause
set echo off
clear screen
prompt |
prompt | "Dude...I'm not going compress it anyway
prompt |
set echo on  
pause
select tablespace_name, def_tab_compression
from   dba_tablespaces;
pause
sho parameter db_index_compression

pause Done
