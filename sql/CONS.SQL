-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serverout on
declare
  h varchar2(32767);
  c varchar2(32767);
begin
for i in (
select  constraint_name,table_name,r_owner,r_constraint_name, search_condition, constraint_type
from  all_constraints
where   table_name = upper('&table_name_req')
order by constraint_name
) loop
  c := i.search_condition;
  h := replace(case 
                 when i.r_owner is not null then i.r_owner || '.'||i.r_constraint_name 
                 when i.constraint_type = 'C' and i.constraint_name like 'SYS_C%' then replace(lower('- '||c),'is not null')
                 else ltrim(c) end,'"');
  
  dbms_output.put_line(
     rpad(i.constraint_name,30)||
     rpad(i.table_name,30)||
     h);
  
end loop;
end;
/

  