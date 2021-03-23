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
set pages 999
@drop test_pkg
drop type my_list;
drop type my_rec;

clear screen
set serverout on
set echo on
set termout on

create or replace 
type my_rec as object (
   col1     varchar2(10)
  ,col2     varchar2(10)
  ,col3     varchar2(10)
  ,col4     varchar2(10)
  ,col5     varchar2(10)
  ,col6     varchar2(10)
  ,col7     varchar2(10)
  ,col8     varchar2(10)
  ,col9     varchar2(10)
  ,col10    varchar2(10)
    ); 
/
pause
create or replace 
type my_list as table of my_rec; 
/
pause
clear screen

create or replace 
package test_pkg as

  function pipe_function return my_list pipelined;
end;
/
pause
clear screen
create or replace
package body test_pkg as
function pipe_function return my_list pipelined as
    cursor dummy_cur is
      select my_rec(null
                    ,null
                    ,null
                    ,null
                    ,null
                    ,null
                    ,null
                    ,null
                    ,null
                    ,null
        ) from dual;
    l_row my_rec;
  begin
    open dummy_cur;
    fetch dummy_cur into l_row;
    close dummy_cur;
    pipe row(l_row);
    return;
  end pipe_function;
end;
/
pause
clear screen
set feedback only
set timing on
select * from test_pkg.pipe_function()

pause
/
pause
clear screen

declare
  l_type_spec clob;
  l_pkg_spec clob;
  l_pkg_body clob;
begin

  l_type_spec := q'{
create or replace
type wide_rec as object (
   col1     varchar2(10)
}';

  l_pkg_spec := q'{
create or replace 
package test_pkg as
  function pipe_function return wide_list pipelined;
end;
}';
#pause
  l_pkg_body := q'{
create or replace 
package body test_pkg as 
function pipe_function return wide_list pipelined as  
    cursor dummy_cur is 
      select wide_rec(null  
}';

  for i in 2 .. 100
  loop
    l_type_spec := l_type_spec || ',col'||i||'     varchar2(10)'||chr(10);
    l_pkg_body  := l_pkg_body || ',null'||chr(10);    
  end loop;

  l_type_spec := l_type_spec || ' ); ';
#pause

  l_pkg_body := l_pkg_body || q'{
        ) from dual;
    l_row wide_rec; 
  begin 
    open dummy_cur; 
    fetch dummy_cur into l_row; 
    close dummy_cur;   
    pipe row(l_row);
    return; 
  end pipe_function;
end;
}';
#pause

  begin 
    execute immediate 'drop type wide_list';
  exception
    when others then null;
  end;

  execute immediate l_type_spec;
  execute immediate 'create or replace type wide_list is table of wide_rec';
  
  execute immediate l_pkg_spec;
  execute immediate l_pkg_body;
  
end;
.
pause
/
pause
clear screen
set feedback only
set timing on
select * from test_pkg.pipe_function()

pause
/
pause
clear screen

delete timings;
pause
declare
  l_type_spec clob;
  l_pkg_spec clob;
  l_pkg_body clob;
  s1 timestamp;
begin

for iteration in 1 .. 10
loop
  l_type_spec := q'{
create or replace
type wide_rec as object (
   col1     varchar2(10)
}';
#pause
  l_pkg_spec := q'{
create or replace 
package test_pkg as
  function pipe_function return wide_list pipelined;
end;
}';

  l_pkg_body := q'{
create or replace 
package body test_pkg as 
function pipe_function return wide_list pipelined as  
    cursor dummy_cur is 
      select wide_rec(null  
}';

  for i in 2 .. iteration*40
  loop
    l_type_spec := l_type_spec || ',col'||i||'     varchar2(10)'||chr(10);
    l_pkg_body  := l_pkg_body || ',null'||chr(10);    
  end loop;
#pause
  l_type_spec := l_type_spec || ' ); ';

  l_pkg_body := l_pkg_body || q'{
        ) from dual;
    l_row wide_rec; 
  begin 
    open dummy_cur; 
    fetch dummy_cur into l_row; 
    close dummy_cur;   
    pipe row(l_row);
    return; 
  end pipe_function;
end;
}';

  begin 
    execute immediate 'drop type wide_list';
  exception
    when others then null;
  end;

  execute immediate l_type_spec;
  execute immediate 'create or replace type wide_list is table of wide_rec';
  
  execute immediate l_pkg_spec;
  execute immediate l_pkg_body;
  
  s1 := localtimestamp;
  
  execute immediate 
  'begin
  for fetch_test in ( select * from test_pkg.pipe_function() ) 
  loop
    null;
  end loop;
  end;';
  
  insert into timings values (iteration*40, localtimestamp-s1); commit;
end loop;

end;
.
pause
/
pause
clear screen
set feedback on
select * from timings
order by iter;
