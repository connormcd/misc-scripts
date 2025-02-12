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
set statusbar off
set sqlformat default
col role format a40
col banner format a58 trunc
col owner format a30
col table_name format a30
col index_name format a30
col segment_name format a30
col prpfile format a30
col column_name format a30
col profile format a30
col column_name format a30
col sql_text format a64
col segment_name format a40 trunc
col object_name format a40 trunc
col tablespace_name format a20 trunc
col username format a20 trunc
col program format a30 trunc
set lines 130
set pages 99
col partition_name format a30
col subpartition_name format a30
set trimspool on
column what format a50 word_wrapped
column plan_plus_exp format a100
col owner format a30
col table_name format a30
col index_name format a30
col segment_name format a30
col prpfile format a30
col column_name format a30
col constraint_name format a40
set errordetails off
set tab off
set sqlprompt 'SQL> '
set exitcommit OFF
set termout on
set echo on
pause
clear screen
select resource_consumer_group
from   v$session
where  sid = sys_context('USERENV','SID');
pause
drop table t purge;
create table t ( x int );
pause
explain plan for
insert into t values (1);
pause
select * from dbms_xplan.display();
pause
clear screen
explain plan for
insert into t select 1 from dual;
pause
select * from dbms_xplan.display();
pause
exit
