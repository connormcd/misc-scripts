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
   
variable sid number
variable sql_id varchar2(20)

declare
   x varchar2(100) := '&1';
begin
  :sid := null;
  :sql_id := null;
  
  begin
      :sid := to_number(x);
      select sql_id into :sql_id 
      from  v$session where sid = :sid;
  exception
    when others then
      :sql_id  := x;
  end;
end;
/
set termout on

set verify off
set long 32767
select child_number, sql_fulltext
from v$sql -- v$sqltext
where sql_id = :sql_id
/

select o.owner, o.object_name, s.program_line#
from   dba_objects o,
       v$sql s
where s.sql_id = :sql_id
and   o.object_id = s.program_id
/
