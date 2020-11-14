set pages 0
set lines 300
!rm -f /tmp/admin.lst
spool /tmp/admin   
PROMPT ===============================
select 'create tablespace '||dt.tablespace_name||' datafile '''||file_name
   ||''' size  '||bytes/1024/1024||'M default storage ( initial '||initial_extent||
   ' next  '||next_extent||' pctincrease '||pct_increase||
   ' minextents '||min_extents||' maxextents '||max_extents||');' line
   from dba_data_files ddf,dba_tablespaces dt
   where ddf.tablespace_name=dt.tablespace_name;

PROMPT ===============================
   select 'create rollback segment '||segment_name||' tablespace "'||tablespace_name||
   '" storage (initial '||initial_extent||' next  '||next_extent||
   ' minextents '||min_extents|| ' maxextents '||max_extents||');' rbs
   from dba_rollback_segs;

PROMPT ===============================
   select 'alter rollback segment '||segment_name||' online;' arbs from dba_rollback_segs;
 
PROMPT ===============================
   select 'create user '||username||' identified by values '||password
   ||' default tablespace "'||default_tablespace||'" temporary tablespace "'||
   temporary_tablespace||'";' usr
   from dba_users
   where username not in ('SYSTEM','SYS');
 
PROMPT ===============================
   select 'create role '||role||';'  crr from dba_roles
   where role not in ('CONNECT','RESOURCE','DBA','EXP_FULL_DATABASE','IMP_FULL_DATABASE');
 
PROMPT ===============================
   select 'grant '||privilege||' to '||grantee||' '||decode(admin_option,'NO',';','YES','WITH ADMIN OPTION;') adr
   from dba_sys_privs
   where grantee not in ('CONNECT','RESOURCE','DBA','EXP_FULL_DATABASE','IMP_FULL_DATABASE');

PROMPT ===============================
   select 'grant "'||granted_role||'" to '||grantee||';' rle
   from dba_role_privs
   where grantee not in ('CONNECT','RESOURCE','DBA','EXP_FULL_DATABASE','IMP_FULL_DATABASE');
 
PROMPT ===============================
set serveroutput on size 200000
declare
  prev varchar2(200) := '*';
  the_line varchar2(200);
  cursor x is
   select grantee,granted_role
   from dba_role_privs where grantee not in ('SYS','SYSTEM','DBA')
   and DEFAULT_ROLE = 'YES' order by grantee;
begin
  for each in x loop
   if each.grantee != prev then
     dbms_output.put_line(the_line);
     the_line := 'alter user '||each.grantee||' default role '||each.granted_role||',';
  else
    the_line := the_line || each.granted_role||',';
  end if;
  prev := each.grantee;
  end loop;
end;
/ 
   
PROMPT ===============================
   select 'alter user '||username||' quota '||to_char(max_bytes/1024/1024)||'M on
"'||tablespace_name||'";' qut
   from dba_ts_quotas;
spool off
