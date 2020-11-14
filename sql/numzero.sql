-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set termout off
@drop t
drop index ix1;
drop index ix2;
drop index ix3;
drop index ix4;
drop index ix5;
drop index ix6;
drop index ix7;
@clean
set echo on
set termout on

create table t as
select 
  rownum w,
  case when rownum <= 70 then rownum end x,
  case when rownum <= 20 then rownum end y,
  case when 1=0 then rownum end z
from dual
connect by level <= 100;

alter table T add constraint PK primary key ( w ) 
/

pause
clear screen
select count(*) from t;
pause
exec dbms_stats.gather_table_stats('','T')
select num_rows
from   user_tables
where  table_name = 'T';
pause
select index_name, num_rows 
from   user_indexes 
where  table_name = 'T'
order by 1;

pause
clear screen

select 
  count(*),
  count(x),
  count(y),
  count(z)
from t;
pause
clear screen
create index ix2 on t ( x )  -- 70 non-nulls
/ 
create index ix3 on t ( y )  -- 20 non-nulls
/
create index ix4 on t ( z )  -- all null column
/
pause
clear screen
exec dbms_stats.gather_table_stats('','T')
select index_name, num_rows 
from   user_indexes 
where  table_name = 'T'
order by 1;
pause

clear screen
alter table t add new_col int;
create index ix5 on t ( new_col )
/

exec dbms_stats.gather_table_stats('','T')
select index_name, num_rows 
from   user_indexes 
where  table_name = 'T'
order by 1;
pause

clear screen
create index ix6 on t ( z,x,y )
/

exec dbms_stats.gather_table_stats('','T')
select index_name, num_rows 
from   user_indexes 
where  table_name = 'T'
order by 1;
