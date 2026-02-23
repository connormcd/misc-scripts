clear screen
@clean
set termout off
conn sys/admin@db23 as sysdba
@drop t
set termout off
clear screen
col full_name format a22
set lines 200
set pages 999
set verify off
set termout on
set echo off
prompt |
prompt |           
prompt |   
prompt |     _____  ____ _______ _____ __  __ ______ __________  _   _ ______ 
prompt |    |  __ \|  _ \__   __|_   _|  \/  |  ____|___  / __ \| \ | |  ____|
prompt |    | |  | | |_) | | |    | | | \  / | |__     / / |  | |  \| | |__   
prompt |    | |  | |  _ <  | |    | | | |\/| |  __|   / /| |  | | . ` |  __|  
prompt |    | |__| | |_) | | |   _| |_| |  | | |____ / /_| |__| | |\  | |____ 
prompt |    |_____/|____/  |_|  |_____|_|  |_|______/_____\____/|_| \_|______|
prompt |                                                                      
prompt |                                                                      
prompt |   
prompt |                                                          
prompt |   
pause
set echo on
clear screen
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
pause
select sysdate;
pause
select systimestamp;
pause
select dbtimezone;
pause
clear screen
show parameter time_at_dbtimezone
pause
alter system set time_at_dbtimezone = USER_SQL scope=spfile;
pause
shutdown immediate
startup
pause
select sysdate;
pause
select systimestamp;
pause
alter system set time_at_dbtimezone = off scope=spfile;
shutdown immediate
startup

pause Done
