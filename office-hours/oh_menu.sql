REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo on
REM set echo off
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
REM set echo off
pause
set define on
pause
REM clear screen
pause
undefine option
undefine zzx1
undefine zzy1
undefine zzx2
undefine zzy2
pause
variable c clob
exec select c into :c from t; 
pause
print c
pause
accept option char prompt 'Demo ? '
pause
col zzx1 new_value zzy1
col zzx2 new_value zzy2
pause
select 'sh_'||lpad('&option',2,'0') zzx1, lpad('&option',2,'0') zzx2 from dual;
pause

REM @&zzy1
REM set echo off

update t
set c = replace(c,'&zzy2'||') ','&zzy2'||')*');
commit;
pause  End of oh_menu.sql
