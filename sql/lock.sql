-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
prompt Sorting options:
prompt 1 - by Oracle ID
prompt 2 - by Operating System Process
prompt 3 - by Username
prompt 4 - by Machine Name
prompt 5 - by NT Login ID
prompt 6 - by CPU Used to date
accept orderby char prompt 'Option: '
col username format a8 trunc
col machine format a20 trunc
col "Process" format a9
col login format a20 trunc
col "Locked?" format a8
set verify off
set pages 99
set lines 100
select 	s.SID "ID",
        p.SPID "Process",
	s.USERNAME,
	nvl(s.MACHINE,'Unknown') MACHINE,
	case when s.osuser like 'ims%' then module else osuser end login,
        st.value "CPU Used",
	decode(s.LOCKWAIT,null,'No','Yes') "Locked?"
from v$session s, v$process p, v$sesstat st
where s.username is not null
and  s.PADDR = p.ADDR
and  s.sid = st.sid
and  st.STATISTIC# = 12
order by &orderby;
set verify on
