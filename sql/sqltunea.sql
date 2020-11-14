undefine sid
undefine sql_id

set termout off
COLUMN inputpar01 NEW_VALUE 1 NOPRINT
  COLUMN inputpar02 NEW_VALUE 2 NOPRINT
  COLUMN inputpar03 NEW_VALUE 3 NOPRINT
  COLUMN inputpar04 NEW_VALUE 4 NOPRINT
  select 1 inputpar01
       , 2 inputpar02
       , 3 inputpar03
       , 4 inputpar04
    from dual
   where 1=2;
set termout on
   
set pagesize 0 echo off timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off

variable sid number
variable sql_id varchar2(20)

declare
   x varchar2(100) := '&1';
begin
  :sid := null;
  :sql_id := null;
  
   if x is null then
     select sql_id
     into   :sql_id
     from
     ( select sql_id
       from   v$session
       where  status = 'ACTIVE'
       and    last_call_et > 2
       and    username = user
       order by last_call_et desc
     )
     where rownum = 1;
   else
     begin
         :sid := to_number(x);
     exception
         when others then
            :sql_id  := x;
     end;
   end if;
end;
/


set termout off
select DBMS_SQLTUNE.REPORT_SQL_MONITOR(
  sql_id=>case when :sql_id is null and :sid is null then 'x' else :sql_id end,
  session_id=>case when :sql_id is null and :sid is null then -1 else :sid end,
  type=>'ACTIVE',
  report_level=>'ALL')
from dual

spool x:\temp\sqltune_active.htm
/
spool off
set termout on

undefine sql_id
undefine sid
set pagesize 999 echo off timing on linesize 100 feedback on

undefine 1
undefine 2
undefine 3
undefine 4

