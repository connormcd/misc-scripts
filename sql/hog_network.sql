-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
declare
  cursor ses is
    select st.sid, sum(value) value, 
           se.USERNAME, se.OSUSER,se.MACHINE , se.PROGRAM
    from v$sesstat st, v$session se
    where st.STATISTIC# in ( 133, 134)
    and  st.sid = se.sid
    group by st.sid,se.USERNAME, se.OSUSER,se.MACHINE , se.PROGRAM
    order by 2 desc;
  v_avg number;
begin
  select round(avg(sum(value)),0)
  into v_avg
  from v$sesstat 
  where STATISTIC# in ( 133, 134)
  group by value;
  dbms_output.put_line('Average Use of Network: '||to_char(v_avg));
  for i in ses loop
    if ses%ROWCOUNT > 2 then
      exit;
    end if;
    dbms_output.put_line('SID:       '||to_char(i.sid));
    dbms_output.put_line('Bytes:     '||to_char(i.value));
    dbms_output.put_line('Connected: '||i.USERNAME);
    dbms_output.put_line('User:      '||i.OSUSER);
    dbms_output.put_line('Machine:   '||i.MACHINE);
    dbms_output.put_line('Program:   '||i.PROGRAM);
    dbms_output.put_line('---------------------------');
  end loop;
end;
/
