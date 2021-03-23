REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
@clean
set termout off
@drop emp
@drop dept
create table dept as select * from scott.dept;
create table emp as select * from scott.emp;
drop function combine;
clear screen
set serverout on
set echo on
set termout on
select dname||'-'||loc concat_dept from dept;
pause
select dname||'~'||loc concat_dept from dept;
pause
clear screen

create or replace
function combine(p_separator varchar2 default '-')
                     return varchar2 SQL_MACRO is
  l_sep_in_quotes varchar2(200) := chr(39)||p_separator||chr(39);
  l_sql           varchar2(200);
begin
  l_sql := 
     'select dname ||' ||
     l_sep_in_quotes   || 
     '||loc concat_dept from dept';
  dbms_output.put_line('RETURNED SQL='||l_sql);
  return l_sql;
end;
/
pause
clear screen
select * from combine();
pause
set echo off
clear screen
pro
pro SQL> select * from combine(' from dept union all select username from all_users union all ... ');
pro 
set echo on
pause
select * from combine();
pause
select * from combine('~');
pause
select * from combine('CONNOR');
pause
clear screen
create or replace
function combine(p_separator varchar2 default '-')
       return varchar2 SQL_Macro is
  l_sql           varchar2(200);
begin
  l_sql := 'select dname || p_separator || loc concat_dept from dept';
  dbms_output.put_line('RETURNED SQL='||l_sql);
  return l_sql;
end;
/
pause
clear screen
set serverout on
select * from combine();
pause
select * from combine('~');
pause
select * from combine('|');
pause
clear screen
create or replace
function no_change(p_table dbms_tf.table_t)
  return varchar2 SQL_Macro is
begin
  return 'select * from p_table';
end;
/
pause
select * from no_change(dept);
pause
select * from no_change(emp);
pause
clear screen
select * from combine('xxx');
pause
select * from combine('xxx');

