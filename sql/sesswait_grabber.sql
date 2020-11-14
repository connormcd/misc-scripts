-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serverout on size 999999
declare
  type numlist is table of number;
  type charlist is table of varchar2(100);
  s numlist;
  e charlist;
  x1 numlist;
  x2 numlist;
  x3 numlist;
  v varchar2(300);
  t number := 0;
begin
  for i in 1 .. 360 loop
    select sid, substr(event,1,24), p1, p2, p3 
    bulk collect into s, e, x1, x2, x3
    from v$session_wait
    where event not in (
      'SQL*Net message from client',
      'SQL*Net message to client',
      'lock manager wait for remote message',
      'pipe get',
      'pmon timer',
      'rdbms ipc message',
      'smon timer') 
    and sid >= 9;
    for j in 1 .. s.count loop
      v := lpad(s(j),3,'0')||': '||
           rpad(e(j),24)||
           lpad(x1(j),10)||
           lpad(x2(j),10)||
           lpad(x2(j),10);
      dbms_output.put_line(v); 
      t := t + length(v);
    end loop;
    exit when t > 900000;
    sys.dbms_lock.sleep(10);
  end loop;
end;
/



