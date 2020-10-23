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
conn /@MY_PDB as sysdba
drop trigger ddl_grabber;
drop table ddl_log purge;
delete aud$;
commit;
conn USER/PASSWORD@MY_PDB
drop table t purge;
set termout on
set echo on
clear screen
audit create table by access;
pause
create table t ( x int );
pause
select * from dba_audit_trail order by timestamp desc fetch first row only
@pr
pause

set termout off
set echo on
drop table ddl_log purge;
noaudit ddl;
clear screen

set termout on
create table ddl_log
(
  tstamp       timestamp(6) default localtimestamp not null,
  sqltext      clob
)
/
pause

create or replace 
trigger ddl_grabber
after create or alter or drop on database
declare
  l_string   varchar2(32000);
  l_sql_text ora_name_list_t;
  l_n        number;
begin
  l_n := ora_sql_txt(l_sql_text);
  for i in 1 .. l_n
  loop
    l_string := l_string || l_sql_text(i);
  end loop;
  insert into ddl_log (sqltext) values (l_string);
end;
/
pause
clear screen
drop table t purge;
create table t ( x int );
pause
select * from ddl_log;
pause
drop trigger ddl_grabber;
drop table ddl_log purge;
clear screen
conn /@MY_PDB as sysdba
pause
create table ddl_log
(
  tstamp       timestamp(6) default localtimestamp not null,
  host         varchar2(100),
  ip_address   varchar2(100),
  module       varchar2(100),
  os_user      varchar2(100),
  terminal     varchar2(100),
  operation    varchar2(100),
  owner        varchar2(50),
  object_name  varchar2(50),
  object_type  varchar2(50),
  sqltext      clob
) tablespace users
/
pause
clear screen
create or replace trigger ddl_grabber
after create or alter or drop on database
disable
declare
  l_string   varchar2(32000);
  l_sql_text ora_name_list_t;
  l_n        number;
begin
  if ora_dict_obj_owner in ('SCOTT','MY_USER','....')
    and  dbms_utility.format_call_stack not like '%NIGHTLY_BATCH%' 
    and  nvl(sys_context('USERENV','MODULE'),'x') != 'DBMS_SCHEDULER'
  then
    l_n := ora_sql_txt(l_sql_text);
    for i in 1 .. l_n
    loop
      l_string := l_string || l_sql_text(i);
    end loop;

    insert into ddl_log
    values (localtimestamp,
            sys_context('USERENV','HOST'),
            sys_context('USERENV','IP_ADDRESS'),
            sys_context('USERENV','MODULE'),
            sys_context('USERENV','OS_USER'),
            sys_context('USERENV','TERMINAL'),
            ora_sysevent,
            ora_dict_obj_owner,
            ora_dict_obj_name,
            ora_dict_obj_type,
            case when ora_dict_obj_type not in ('PACKAGE','PROCEDURE','FUNCTION','PACKAGE BODY') then
              l_string
            end
           );
     commit;
  end if;
exception
  when others then 
    DBMS_System.ksdwrt(2, 'DDL_GRABBER '||sqlerrm);
end;
/
pause
alter trigger ddl_grabber enable;
pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout on
show user
pause
drop table t purge;
create table t ( x int );
pause
alter table t add ( y int );
pause
select * from sys.ddl_log
@pr
pause
set termout off
conn /@MY_PDB as sysdba
drop trigger ddl_grabber;
conn USER/PASSWORD@MY_PDB
set termout on
