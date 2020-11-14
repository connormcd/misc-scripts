undefine fsource
set termout off
col file_source new_value fsource
select 'dba_data_files' file_source from dual;
select '( select FILE_NAME,FILE_ID,TABLESPACE_NAME,BYTES,BLOCKS,STATUS,RELATIVE_FNO,AUTOEXTENSIBLE,MAXBYTES,MAXBLOCKS,INCREMENT_BY,USER_BYTES,USER_BLOCKS from dba_data_files union all select * from dba_temp_files )' file_source from dual
where exists ( 
  select 1
  from v$fixed_view_definition
  where view_name = 'V$TEMPFILE' );
set termout on

set verify off
set lines 120
set trimspool on
col tablespace_name format a24
col file_name format a54
col bytes format a10
col auto format a8
select f.tablespace_name, t.status, lpad(round(sum(f.bytes)/1024/1024)||'m',10) bytes
from &fsource f,
     dba_tablespaces t
where f.tablespace_name like upper(nvl('&tablespace_name'||'%',f.tablespace_name))
and f.tablespace_name = t.tablespace_name
group by f.tablespace_name, t.status
order by 1,2
/

col bytes clear
