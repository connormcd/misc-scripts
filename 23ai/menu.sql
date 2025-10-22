set echo off
define basedir = X:\dbdemo_package
variable menu clob
conn dbdemo/dbdemo@db23
select chr(27)||'[0m' from dual;
clear screen
set long 20000
set longchunksize 20000
set pages 999
set lines 120
set describe annotation off
set echo off
set define on
undefine option
undefine zzx1
undefine zzy1
undefine zzx2
undefine zzy2
undefine opt
undefine choice
exec select c into :menu from tmenu; 
clear screen
print menu
accept option char prompt 'Demo ? '
col zzx1 new_value zzy1
col zzx2 new_value zzy2
col opt new_value choice
with
  function get_choice(m clob) return varchar2 is
    r varchar2(5);
    c int;
  begin
    if lower('&option') = 'r' then
      select regexp_count(c,'\)') into c from tmenu;
      for i in 1 .. 5000 loop
        r := trunc(dbms_random.value(1,c+.9999999));
        exit when instr(m,lpad(r,2,'0')||')*') = 0 ;
      end loop;
      return r;
    else
      return '&option';
    end if;
  end;
select get_choice(:menu) opt
from dual
/

select 'sh_'||lpad('&choice',2,'0') zzx1, lpad('&choice',2,'0') zzx2 from dual;
@&zzy1
set echo off
conn dbdemo/dbdemo@db23
update tmenu
set c = replace(c,'&zzy2'||') ','&zzy2'||')*')
where '&zzy2' is not null;
commit;

