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
cursor c1 is
        select /*+ ordered */ x.statistic#,
               x.name,
               x.value - stats_pre.value delta
        from   ( select   /*+ ordered */
                   sn.statistic#,
                   sn.name,
                   sn.class,
                   ms.value
                 from  v$mystat    ms,
                       v$statname  sn
                 where sn.statistic# = ms.statistic# ) x,
               stats_pre
        where  x.statistic# = stats_pre.statistic# 
        and x.value - stats_pre.value != 0;

  type t is table of c1%rowtype;
  r t;

begin
        dbms_output.put_line('---------------------------------');
        dbms_output.put_line(
               rpad('Name',60) ||
               lpad('Value',18) );

        dbms_output.put_line(
               rpad('----',60) ||
               lpad('-----',18) );
  
        open c1; fetch c1 bulk collect into r; close c1;
        for i in 1 .. r.count loop
                       dbms_output.put(rpad(r(i).name,60));
                       dbms_output.put_line(to_char(r(i).delta,'9,999,999,999,990'));
        end loop;
end;
/
drop table stats_pre;

