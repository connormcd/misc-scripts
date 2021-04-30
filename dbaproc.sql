set serverout on
declare
  cursor c is select * from dba_objects where object_type in ('PROCEDURE','PACKAGE','FUNCTION');
  type clist is table of c%rowtype;
  r clist;
  s timestamp;
  a varchar2(20);
begin
  open c; 
  fetch c bulk collect into r;
  close c;
  
  s := localtimestamp;
  for i in 1 .. r.count loop
    begin
      SELECT AUTHID into a
      FROM  SYS.DBA_PROCEDURES WHERE OWNER = r(i).owner AND OBJECT_NAME = r(i).OBJECT_NAME AND ROWNUM = 1;
    exception
      when no_data_found then null;
    end;
  end loop;
  dbms_output.put_line(r.count);
  dbms_output.put_line(localtimestamp-s);
end;
/

variable sid number
exec :sid := sys_context('USERENV','SID') 
set pages 999
set lines 200
col event format a44
select EVENT
,TOTAL_WAITS
,TOTAL_TIMEOUTS
,SECS
,rpad(to_char(100 * ratio_to_report(secs) over (), 'FM00.00') || '%',8)  pct
,max_wait
from (
select EVENT
,TOTAL_WAITS
,TOTAL_TIMEOUTS
,TIME_WAITED/100 SECS
from v$session_event
where sid = :sid
and event not like 'SQL*Net%'
union all
select 'CPU', null, null, value/100 , 0 from v$sesstat 
where statistic# = ( select statistic# from v$statname where name = 'CPU used by this session') 
and sid = :sid
order by 4
)
/


  