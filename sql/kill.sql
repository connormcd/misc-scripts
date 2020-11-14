set serverout on
declare
  l_serial number;
  l_my_session number;
  l_status varchar2(30);
begin
  select sid 
  into   l_my_session
  from sys.v_$mystat 
  where rownum = 1;

  if l_my_session = &1 then
     raise_application_error(-20001, ' You''ve chosen the session you''re currently in - you can''t kill that');
  end if;

  select serial#, status
  into l_serial, l_status
  from sys.v_$session vs
  where sid = &1;

--  if l_status = 'KILLED' then

--      select p.SPID
--      into l_serial
--      from v$session s, v$process p
--      where s.PADDR = p.ADDR
--      and s.SID = &1;

--       rc('/usr/bin/kill -9 '||l_serial);
--       dbms_output.put_line('OS kill used to kill previously status=KILLED session');
--  else

    execute immediate
      'alter system kill session '''||&1||','||l_serial||''' immediate';

    dbms_output.put_line('Alter system command used to kill session');
--  end if;
--exception
--  when others then
--    if sqlcode = -31 then
--
--      select p.SPID
--      into l_serial
--      from v$session s, v$process p
--      where s.PADDR = p.ADDR
--      and s.SID = &1;
--
--       rc('/usr/bin/kill -9 '||l_serial);
--       dbms_output.put_line('Alter system + OS kill used to kill session');
--   end if;
end;
/

