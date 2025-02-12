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
clear screen
col parameters format a50
set timing off
set long 5000
@drop t
begin
  ctxsys.ctx_ddl.drop_preference('SIMPLE_STORAGE');
end;
/
set timing off
set pages 999
set termout on
clear screen
set echo on
create table t as select * from dba_objects;
pause
begin
  ctxsys.ctx_ddl.create_preference('SIMPLE_STORAGE','BASIC_STORAGE');
  ctx_ddl.set_attribute('SIMPLE_STORAGE','i_table_clause','tablespace largets');
  ctx_ddl.set_attribute('SIMPLE_STORAGE','i_index_clause','tablespace largets');
end;
/
pause
create index tmp_ix on t (object_name)
indextype is ctxsys.context
parameters ('storage simple_storage sync (on commit)');
pause
clear screen
select parameters 
from dba_indexes 
where index_name = 'TMP_IX';
pause
select dbms_metadata.get_ddl(object_type => 'INDEX',
                             NAME        => 'TMP_IX',
                             SCHEMA      => user)
from dual;
pause
clear screen
alter index tmp_ix rebuild;
pause
select parameters 
from dba_indexes 
where index_name = 'TMP_IX';
pause
select dbms_metadata.get_ddl(object_type => 'INDEX',
                             NAME        => 'TMP_IX',
                             SCHEMA      => user)
from dual;
pause
select table_name, tablespace_name
from   user_tables
where  table_name like 'DR$TMP%'
union all
select index_name, tablespace_name
from   user_indexes
where  index_name like 'DR$TMP%';
pause
set long 500000
clear screen
variable c clob
begin
  dbms_lob.createtemporary(:c,true);
  ctx_report.create_index_script('TMP_IX',:c);
end;
/
pause
clear screen
pause
print c
