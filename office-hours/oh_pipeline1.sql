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
@drop timings

drop type my_list;
drop type my_rec;

clear screen
set serverout on
set echo on
set termout on

create or replace 
package test_pkg as

type my_rec is record( 
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
  type my_list is table of my_rec; 
  function pipe_function return my_list pipelined;
end;
/
pause
clear screen
create or replace 
package body test_pkg as 
function pipe_function return my_list pipelined as  
    cursor dummy_cur is 
      select null
             ,null
             ,null
             ,null
             ,null
             ,null
             ,null
             ,null
             ,null
             ,null
        from dual;
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
set feedback on
set timing off
pause
clear screen
create or replace
package test_pkg as

type my_rec is record(
     col1     varchar2(100)
    ,col2     varchar2(10)
    ,col3     varchar2(10)
    ,col4     varchar2(10)
    ,col5     varchar2(10)
    ,col6     varchar2(10)
    ,col7     varchar2(10)
    ,col8     varchar2(10)
    ,col9     varchar2(10)
    ,col10     varchar2(10)
    ,col11     varchar2(10)
    ,col12     varchar2(10)
    ,col13     varchar2(10)
    ,col14     varchar2(10)
    ,col15     varchar2(10)
    ,col16     varchar2(10)
    ,col17     varchar2(10)
    ,col18     varchar2(10)
    ,col19     varchar2(10)
    ,col20     varchar2(10)
    ,col21     varchar2(10)
    ,col22     varchar2(10)
    ,col23     varchar2(10)
    ,col24     varchar2(10)
    ,col25     varchar2(10)
    ,col26     varchar2(10)
    ,col27     varchar2(10)
    ,col28     varchar2(10)
    ,col29     varchar2(10)
    ,col30     varchar2(10)
    ,col31     varchar2(10)
    ,col32     varchar2(10)
    ,col33     varchar2(10)
    ,col34     varchar2(10)
    ,col35     varchar2(10)
    ,col36     varchar2(10)
    ,col37     varchar2(10)
    ,col38     varchar2(10)
    ,col39     varchar2(10)
    ,col40     varchar2(10)
    ,col41     varchar2(10)
    ,col42     varchar2(10)
    ,col43     varchar2(10)
    ,col44     varchar2(10)
    ,col45     varchar2(10)
    ,col46     varchar2(10)
    ,col47     varchar2(10)
    ,col48     varchar2(10)
    ,col49     varchar2(10)
    ,col50     varchar2(10)
    ,col51     varchar2(10)
    ,col52     varchar2(10)
    ,col53     varchar2(10)
    ,col54     varchar2(10)
    ,col55     varchar2(10)
    ,col56     varchar2(10)
    ,col57     varchar2(10)
    ,col58     varchar2(10)
    ,col59     varchar2(10)
    ,col60     varchar2(10)
    ,col61     varchar2(10)
    ,col62     varchar2(10)
    ,col63     varchar2(10)
    ,col64     varchar2(10)
    ,col65     varchar2(10)
    ,col66     varchar2(10)
    ,col67     varchar2(10)
    ,col68     varchar2(10)
    ,col69     varchar2(10)
    ,col70     varchar2(10)
    ,col71     varchar2(10)
    ,col72     varchar2(10)
    ,col73     varchar2(10)
    ,col74     varchar2(10)
    ,col75     varchar2(10)
    ,col76     varchar2(10)
    ,col77     varchar2(10)
    ,col78     varchar2(10)
    ,col79     varchar2(10)
    ,col80     varchar2(10)
    ,col81     varchar2(10)
    ,col82     varchar2(10)
    ,col83     varchar2(10)
    ,col84     varchar2(10)
    ,col85     varchar2(10)
    ,col86     varchar2(10)
    ,col87     varchar2(10)
    ,col88     varchar2(10)
    ,col89     varchar2(10)
    ,col90     varchar2(10)
    ,col91     varchar2(10)
    ,col92     varchar2(10)
    ,col93     varchar2(10)
    ,col94     varchar2(10)
    ,col95     varchar2(10)
    ,col96     varchar2(10)
    ,col97     varchar2(10)
    ,col98     varchar2(10)
    ,col99     varchar2(10)
    ,col100     varchar2(10)
    );
  type my_list is table of my_rec;
  function pipe_function return my_list pipelined;
end;
/
pause
create or replace
package body test_pkg as
function pipe_function return my_list pipelined as
    cursor dummy_cur is
      select null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
            ,null
        from dual;
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
set feedback on
set timing off
pause
clear screen
declare
  l_pkg_spec clob;
  l_pkg_body clob;
begin
  l_pkg_spec := q'{
create or replace 
package test_pkg as

type my_rec is record( 
   col1     varchar2(100)
}';

  l_pkg_body := q'{
create or replace 
package body test_pkg as 
function pipe_function return my_list pipelined as  
    cursor dummy_cur is 
      select null  
}';
#pause
  for i in 2 .. 150
  loop
    l_pkg_spec := l_pkg_spec || '   ,col'||i||'     varchar2(10)'||chr(10);
    l_pkg_body := l_pkg_body || '   ,null'||chr(10);    
  end loop;

  l_pkg_spec := l_pkg_spec || q'{
    ); 
  type my_list is table of my_rec; 
  function pipe_function return my_list pipelined;
end;

}';
#pause

  l_pkg_body := l_pkg_body || q'{
        from dual;
    l_row my_rec; 
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
  
  execute immediate l_pkg_spec;
  execute immediate l_pkg_body;
end;
/
pause
clear screen
select text
from   user_source
where  name = 'TEST_PKG'
and    type = 'PACKAGE'
order by line

pause
/
pause
clear screen
set feedback only
set timing on
select * from test_pkg.pipe_function();
set feedback on
set timing off

pause
clear screen
create table timings ( iter int, dur interval day to second);

declare
  l_pkg_spec clob;
  l_pkg_body clob;
  s1 timestamp;
begin

for iteration in 10 .. 40
loop
  

  l_pkg_spec := q'{
create or replace 
package test_pkg as
#pause
type my_rec is record( 
   col1     varchar2(100)
}';

  l_pkg_body := q'{
create or replace 
package body test_pkg as 
function pipe_function return my_list pipelined as  
    cursor dummy_cur is 
      select null  
}';

  for i in 2 .. iteration*10
  loop
    l_pkg_spec := l_pkg_spec || ',col'||i||'     varchar2(10)'||chr(10);
    l_pkg_body := l_pkg_body || ',null'||chr(10);    
  end loop;

  l_pkg_spec := l_pkg_spec || q'{
    ); 
  type my_list is table of my_rec; 
  function pipe_function return my_list pipelined;
end;

}';
#pause

  l_pkg_body := l_pkg_body || q'{
        from dual;
    l_row my_rec; 
  begin 
    open dummy_cur; 
    fetch dummy_cur into l_row; 
    close dummy_cur;   
    pipe row(l_row);
    return; 
  end pipe_function;
end;

}';
  
  execute immediate l_pkg_spec;
  execute immediate l_pkg_body;
#pause
  
  s1 := localtimestamp;
  
  execute immediate 
  'begin
  for fetch_test in ( select * from test_pkg.pipe_function() ) 
  loop
    null;
  end loop;
  end;';
  
  insert into timings values (iteration*10, localtimestamp-s1); commit;
end loop;

end;
.
set echo off
pro
pro Back to the slides
pro
