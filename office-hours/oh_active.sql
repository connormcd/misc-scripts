REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

select sid,
       status,
       sql_id,
       last_call_et,
       program
from (
select s.sid, s.serial#,
  s.username, s.last_call_et,
       decode(s.lockwait, null, s.status, 'BLOCKED') status, s.sql_id,
  case when s.program is not null then
  ( case when s.program like 'oracle%(%)%' then regexp_substr(s.program,'^oracle.*\((.*)\).*$',1, 1, 'i', 1)||
case when s.action is not null then '-'||s.action end
                else s.program
                end )
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end||case when s.osuser not in ('SYSTEM','oracle') then ':'||s.osuser end program,
     s.event, s.seconds_in_wait
from v$session s
where s.status = 'ACTIVE'
and s.username = 'MYUSER'
and s.sid != sys_context('userenv','sid')
);