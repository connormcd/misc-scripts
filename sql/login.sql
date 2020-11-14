set termout off
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
set tab off
define gname = 'SQL'
define container = NONE
column global_name new_value gname
col cname new_value container
select lower(user) || '@'||lower(instance_name) global_name
from v$instance;
select lower(sys_context('USERENV','CON_NAME')) cname from dual;
set secureliterals off
undefine me
undefine x
col x new_value me
select 'mcdonac@//localhost:1519/'||sys_context('userenv','service_name') x
from dual;
undefine db
undefine x
col x new_value db
select '//localhost:1519/'||sys_context('userenv','service_name') x
from dual;
set sqlprompt 'SQL> '
set exitcommit OFF
host title &&gname &&container
set termout on
