set echo off
define basedir = X:\dbdemo_package
variable cxxx clob
conn dbdemo/dbdemo@db23
set long 1200
set describe annotation off
set echo off
set define on
clear screen
undefine option
undefine zzx1
undefine zzy1
undefine zzx2
undefine zzy2
exec select c into :cxxx from tmenu; 
print cxxx
accept option char prompt 'Demo ? '
col zzx1 new_value zzy1
col zzx2 new_value zzy2
select 'sh_'||lpad('&option',2,'0') zzx1, lpad('&option',2,'0') zzx2 from dual;
@&zzy1
set echo off
conn dbdemo/dbdemo@db23
update tmenu
set c = replace(c,'&zzy2'||') ','&zzy2'||')*')
where '&zzy2' is not null;
commit;
