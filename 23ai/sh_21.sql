clear screen
@clean
set termout off
conn sys/SYS_PASSWORD@db23 as sysdba
set termout off
exec dbms_sql_firewall.enable;
exec dbms_sql_firewall.disable_allow_list ('SCOTT');
exec  dbms_sql_firewall.drop_allow_list ('SCOTT');
exec  dbms_sql_firewall.drop_capture ('SCOTT');
revoke sql_firewall_admin from system;
exec dbms_sql_firewall.disable;
conn dbdemo/dbdemo@db23
set termout off
set termout on
set echo off
clear screen
prompt |
prompt |  ______ _____ _____  ________          __     _      _      
prompt | |  ____|_   _|  __ \|  ____\ \        / /\   | |    | |     
prompt | | |__    | | | |__) | |__   \ \  /\  / /  \  | |    | |     
prompt | |  __|   | | |  _  /|  __|   \ \/  \/ / /\ \ | |    | |     
prompt | | |     _| |_| | \ \| |____   \  /\  / ____ \| |____| |____ 
prompt | |_|    |_____|_|  \_\______|   \/  \/_/    \_\______|______|
prompt |
pause
clear screen
set echo on
conn sys/SYSTEM_PASSWORD@db23
pause
exec dbms_sql_firewall.enable;
pause
grant sql_firewall_admin to system;
pause
clear screen
conn sys/SYSTEM_PASSWORD@db23
pause
exec dbms_sql_firewall.enable;
pause
begin
  dbms_sql_firewall.create_capture (
    username=>'SCOTT',
    top_level_only=>true);
end;
/
pause
clear screen
conn scott/tiger@db23
pause
select empno, ename from emp;
pause
select * from dept;
pause
select deptno, max(hiredate)
from emp
group by deptno;
pause
clear screen
conn sys/SYSTEM_PASSWORD@db23
pause
exec dbms_sql_firewall.stop_capture('SCOTT');
pause
clear screen
set echo off
--select sql_text
--from   dba_sql_firewall_capture_logs
--where  username = 'SCOTT';
--pause
column username format a20
col ip_address format a30
column os_program format a20
column os_user format a10
column sql_text format A50
set echo on
clear screen
exec dbms_sql_firewall.generate_allow_list ('SCOTT');
pause                                                             
select *
from   dba_sql_firewall_allowed_ip_addr
where  username = 'SCOTT';
pause
select *
from   dba_sql_firewall_allowed_os_prog
where  username = 'SCOTT';
pause
select *
from   dba_sql_firewall_allowed_os_user
where  username = 'SCOTT';
pause
clear screen
select sql_text
from   dba_sql_firewall_allowed_sql
where  username = 'SCOTT';
pause
exec  dbms_sql_firewall.enable_allow_list (username=>'SCOTT',block=>true);
pause
clear screen
conn scott/tiger@db23
pause
select empno, ename from emp;
pause
select * from dept;
pause
select max(sal) from emp;
pause
conn sys/SYS_PASSWORD@db23 as sysdba
exec dbms_sql_firewall.disable_allow_list ('SCOTT');
exec  dbms_sql_firewall.drop_allow_list ('SCOTT');
exec dbms_sql_firewall.disable;


pause Done
