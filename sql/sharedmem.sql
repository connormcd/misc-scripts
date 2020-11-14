-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serveroutput on
declare
  x number := 0;
  cursor y is
    select sum(value) totmem
    from v$sesstat s, v$statname n
    where s.statistic# = n.statistic#
    and n.name = 'session uga memory max'
    union
    select sum(sharable_mem) from v$sqlarea
    union
    select sum(sharable_mem) from v$db_object_cache;
begin
  for each in y loop
     x := x + each.totmem;
  end loop;
  dbms_output.put_line('Megabytes: '||to_char(round((x+(x/0.7*0.3))/1000000,1)));
end;
/
