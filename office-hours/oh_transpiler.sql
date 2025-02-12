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
conn SYS_USER/PASSWORD@MY_PDB
alter session set sql_transpiler = 'OFF';
set termout off
@drop person
col first_name format a20
col last_name format a20
set echo on
set termout on
clear screen
create table person
 ( pid int,
   first_name varchar2(20),
   last_name  varchar2(20)
 );
pause
insert into person values (1,'Mike','Hichwa');
pause
insert into person values (2,'Maria','Colgan');
pause
insert into person values (3,'LARRY','ELLISON');
pause
clear screen
select 
  initcap(first_name) first_name,
  initcap(last_name) last_name
from person
where initcap(first_name) is not null;
pause
clear screen
insert into person values (4,'Connor','McDonald');
pause
select 
  initcap(first_name) first_name,
  initcap(last_name) last_name
from person
where initcap(first_name) is not null;
pause
clear screen
create or replace
function my_initcap(p_string varchar2) return varchar2 is
begin
  return
      case
        when regexp_like(p_string,'(Mac[A-Z]|Mc[A-Z])') then p_string
        when p_string like '''%' then p_string
        when initcap(p_string) like '_''S%' then p_string
        else replace(initcap(p_string),'''S','''s')
      end;
end;
/
pause
select 
  my_initcap(first_name) first_name,
  my_initcap(last_name) last_name
from person
where my_initcap(first_name) is not null;
pause
clear screen
alter system flush shared_pool;
pause
alter session set sql_transpiler = 'ON';
pause
explain plan for
select 
  my_initcap(first_name) first_name,
  my_initcap(last_name) last_name
from person
where my_initcap(first_name) is not null;
pause
select * 
from dbms_xplan.display();
pause
clear screen
create or replace
function my_initcap(p_string varchar2) return varchar2 is
begin
  if 1=1 then
    return
      case
        when regexp_like(p_string,'(Mac[A-Z]|Mc[A-Z])') then p_string
        when p_string like '''%' then p_string
        when initcap(p_string) like '_''S%' then p_string
        else replace(initcap(p_string),'''S','''s')
      end;
  end if;
end;
/
pause
clear screen
explain plan for
select 
  my_initcap(first_name) first_name,
  my_initcap(last_name) last_name
from person
where my_initcap(first_name) is not null;
pause
select * 
from dbms_xplan.display();





