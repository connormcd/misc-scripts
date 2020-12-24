set lines 350
clear screen
select replace(replace(replace(r,'X',chr(27)||'[42m'||chr(27)||'[1;'||to_char(32)||'m'||'X'||chr(27)||'[0m'),
    'T',chr(27)||'[43m'||chr(27)||'[1;'||to_char(33)||'m'||'T'||chr(27)||'[0m'),
    '@',chr(27)||'[33m'||chr(27)||'[1;'||to_char(31)||'m'||'@'||chr(27)||'[0m')
from ( select lpad(' ',20-e-i)|| case when dbms_random.value < 0.3 then substr(s,1,e*2-3+i*2) 
       else substr(substr(s,1,dbms_random.value(1,e*2-3+i*2-1))||'@'||s,1,e*2-3+i*2) end r
from ( select rpad('X',40,'X') s,rpad('T',40,'T') t from dual ) , 
( select level i, level+2 hop from dual connect by level <= 4 ) , lateral
( select level e from dual connect by level <= hop ) union all select lpad(' ',17)||substr(t,1,3)
from ( select rpad('X',40,'X') s,rpad('T',40,'T') t from dual ) connect by level <= 5 );


