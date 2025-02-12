REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo off
conn SYSTEM_USER/PASSWORD@DB_SERVICE
set echo off
set define on
clear screen
variable c clob
undefine option
undefine zzx1
undefine zzy1
undefine zzx2
undefine zzy2
exec select c into :c from t; 
print c
accept option char prompt 'Demo ? '
col zzx1 new_value zzy1
col zzx2 new_value zzy2
select 'sh_'||lpad('&option',2,'0') zzx1, lpad('&option',2,'0') zzx2 from dual;
@&zzy1
set echo off

update t
set c = replace(c,'&zzy2'||') ','&zzy2'||')*');
commit;

