-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col blocking_session format a20 trunc
col obj format a24 trunc
select 
  s.sid, s.serial#, s.username  || ' ('||s.last_call_et||')' username,
  case when s.lockwait is null then
       case when s.username is null then
          'ACTIVE'
       else
          s.status
       end
  else 'BLOCKED'
  end status,
  nvl(s.sql_id,s.prev_sql_id) sql_id,
  l.ctime dur,
  DECODE(L.LMODE, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 'RX', 4, 'S', 5, 'SRX', 6, 'X', '?')||','||
    DECODE(L.REQUEST, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 'RX', 4, 'S', 5, 'SRX', 6, 'X', '?')||':'||
    o.name obj,
  case when s.program is not null then
         ( case when s.program like 'oracle%(%)%' then regexp_substr(s.program,'^oracle.*\((.*)\).*$',1, 1, 'i', 1)
                else s.program
                end )
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end || '-' || s.osuser program ,
       blocking_session||' '||
       case
         when blocking_session is null then cast(null as varchar2(1))
         else
          cast(( select substr(s1.osuser||'-'||s1.program,1,60)
            from   v$session s1
            where s1.sid = s.blocking_session
          ) as varchar2(60))
       end blocking_session
from v$session s,
     v$transaction t,
     v$lock l,
     sys.obj$ o
where t.addr = s.taddr
and   s.sid  = l.sid
and   l.type = 'TM'
and   l.id1 = o.obj#
order by s.sid
/
