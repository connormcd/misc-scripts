col object_name format a40
set lines 150
set verify off
select owner, object_name, object_type, status, created, to_char(last_ddl_time,'dd/mm/yyyy hh24:mi:ss') ddl
from dba_objects
where object_name like upper(nvl('&object_name',object_name))||'%'
and object_type like upper(nvl('&object_type',object_type))||'%'
and status like upper(nvl('&status',status))||'%';
