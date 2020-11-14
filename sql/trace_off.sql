begin
for i in ( select sid, serial#
           from v$session
           where username in ('ACCTAPP','TOTEAPP')-- 'TOTEAPP','ACCTAPP')
           ) loop
       dbms_monitor.SESSION_TRACE_DISABLE(i.sid, i.serial#);
end loop;
end;
/
