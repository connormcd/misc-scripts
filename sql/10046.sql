undefine level
alter session set events = '10046 trace name context forever, level &&level';
set serverout on
set feedback off
set verify off
begin
  if '&&level' in ('8','12') then
     execute immediate 'alter session set statistics_level = all';
     dbms_output.put_line('statistics_level has been set to ALL');
  end if;
end;
/
set feedback on
set verify on

