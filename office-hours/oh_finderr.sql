REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
clear screen
@clean
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
drop table scott.ANYTHING_I_WANT;
set termout on
col owner format a12
col table_name format a24
set lines 60
set echo on
clear screen

desc emp
pause
set lines 100
clear screen
begin
  dbms_errlog.create_error_log('EMP',
      err_log_table_name =>'ANYTHING_I_WANT',  -- different name
      err_log_table_owner=>'SCOTT');           -- different schema
end;
/
pause
select owner, table_name
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    column_name = 'ORA_ERR_NUMBER$';
pause
clear screen
select owner, table_name, sum(ora_hash(column_name)) col_hash
from   all_tab_columns
where  owner in ('SCOTT','HR')
group by owner, table_name
order by 1,2

pause
/
pause
clear screen
with
err_log_tables as
 ( select owner, table_name
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    column_name = 'ORA_ERR_NUMBER$'
 )
select owner, table_name, sum(ora_hash(column_name)) col_hash
from   all_tab_columns
where  owner in ('SCOTT','HR')
and    (owner,table_name) not in
     ( select owner, table_name
       from   err_log_tables
     )
group by owner, table_name
order by 1,2

pause
/
pause
clear screen

with
err_log_tables as
 ( select owner, table_name
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    column_name = 'ORA_ERR_NUMBER$'
 )
select owner, table_name, sum(ora_hash(column_name)) col_hash
from   all_tab_columns
where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
and    column_id > 5
and    (owner,table_name) in
   ( select owner, table_name
     from   err_log_tables
   )
group by owner, table_name
order by 1,2

pause
/
pause
clear screen
with
err_log_tables as
 ( select owner, table_name
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    column_name = 'ORA_ERR_NUMBER$'
 ),
tab_col_hash as
 ( select owner, table_name, sum(ora_hash(column_name)) col_hash
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    (owner,table_name) not in
     ( select owner, table_name
       from   err_log_tables
     )
  group by owner, table_name
),
err_log_tab_col_hash as
( select owner, table_name, sum(ora_hash(column_name)) col_hash
  from   all_tab_columns
  where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
  and    column_id > 5
  and    (owner,table_name) in
     ( select owner, table_name
       from   err_log_tables
     )
  group by owner, table_name
)
select t.owner, t.table_name, e.owner, e.table_name
from tab_col_hash t,
     err_log_tab_col_hash e
where t.col_hash = e.col_hash
order by 1,2,3,4

pause
/
pause

clear screen

with
err_log_tables as
 ( select owner, table_name
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    column_name = 'ORA_ERR_NUMBER$'
 ),
tab_col_hash as
 ( select owner, table_name, listagg(column_name,',') within group ( order by column_id ) col_str
   from   all_tab_columns
   where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
   and    (owner,table_name) not in
     ( select owner, table_name
       from   err_log_tables
     )
  group by owner, table_name
),
err_log_tab_col_hash as
( select owner, table_name, listagg(column_name,',') within group ( order by column_id ) col_str
  from   all_tab_columns
  where  owner in ('USERNAME','SCOTT','ASKTOM','HR')
  and    column_id > 5
  and    (owner,table_name) in
     ( select owner, table_name
       from   err_log_tables
     )
  group by owner, table_name
)
select t.owner, t.table_name, e.owner, e.table_name
from tab_col_hash t,
     err_log_tab_col_hash e
where e.col_str like t.col_str||'%'
order by 1,2,3,4

pause
/
pause
set lines 60
clear screen
desc USERNAME.my_data
desc USERNAME.err$_emp;

