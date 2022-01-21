REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

create or replace
package pkg is
  c int := 1;
  wd varchar2(5);
  guesses sys.odcivarchar2list := sys.odcivarchar2list();
  pos_correct sys.odcivarchar2list := sys.odcivarchar2list();
  correct     sys.odcivarchar2list := sys.odcivarchar2list();
  incorrect   sys.odcivarchar2list := sys.odcivarchar2list();
  dist        sys.odcinumberlist  := sys.odcinumberlist();
  bad_guesses sys.odcivarchar2list := sys.odcivarchar2list();
  
  procedure new_game;
  function guess(g varchar2 default null) return sys.odcivarchar2list pipelined;
  function strength(str varchar2) return number;
  
end;
/

create or replace
package body pkg is 

procedure new_game is
begin
  c := 1;
  guesses := sys.odcivarchar2list();
  pos_correct := sys.odcivarchar2list();
  correct     := sys.odcivarchar2list();
  incorrect   := sys.odcivarchar2list();
  bad_guesses := sys.odcivarchar2list();
  
  select w
  into   wd
  from ( select w from wordle order by dbms_random.value ) 
  where rownum = 1;
end;  

function guess(g varchar2 default null) return sys.odcivarchar2list pipelined is
  l_guess  varchar2(5) := lower(g);
  l_result varchar2(100);
  l_char   varchar2(1);
  
  l_yellow varchar2(10) := chr(27)||'[43m';
  l_green  varchar2(10) := chr(27)||'[42m';
  l_grey   varchar2(10) := chr(27)||'[47m';
  l_reset  varchar2(10) := chr(27)||'[0m';
  l_sql    varchar2(32767);
  
begin
  if g is null and c = 1 then l_guess := 'raise'; end if;
  if g is null and c = 2 then l_guess := 'count'; end if;
  
  if l_guess is null then
    l_sql := 'select w from ( select w from wordle where 1=1 ';

    for i in 1 .. pos_correct.count loop
       l_sql := l_sql|| pos_correct(i);
    end loop;
    for i in 1 .. correct.count loop
       l_sql := l_sql|| correct(i);
    end loop;
    for i in 1 .. incorrect.count loop
       l_sql := l_sql|| incorrect(i);
    end loop;
    
    for i in 1 .. bad_guesses.count loop
       l_sql := l_sql|| bad_guesses(i);
    end loop;
    
    l_sql := l_sql||' order by pkg.strength(w) desc ) where rownum = 1';
    --dbms_output.put_line(l_sql);
    execute immediate l_sql into l_guess;
  end if;
  
  for i in 1 .. 5
  loop
    l_char := substr(l_guess,i,1);
    if substr(wd,i,1) = l_char then
      l_result := l_result|| l_green||l_char||l_reset||' ';
      pos_correct.extend;
      pos_correct(pos_correct.count) := chr(10)||' and w like '''||rpad('_',i-1,'_')||l_char||rpad('_',5-i,'_')||'''';
    elsif wd like '%'||l_char||'%' then
      l_result := l_result|| l_yellow ||l_char||l_reset||' ';
      correct.extend;
      correct(correct.count) := chr(10)||' and w like ''%'||l_char||'%''';
      correct.extend;
      correct(correct.count) := chr(10)||' and w not like '''||rpad('_',i-1,'_')||l_char||rpad('_',5-i,'_')||'''';
    else 
      l_result := l_result|| l_grey||l_char||l_reset||' ';
      incorrect.extend;
      incorrect(incorrect.count) := chr(10)||' and w not like ''%'||l_char||'%''';
    end if;
  end loop;
  guesses.extend;
  guesses(c) := l_result;
  
  c := c + 1;
  
  for i in 1 .. guesses.count
  loop 
    pipe row ( guesses(i));
  end loop;

  if l_guess != wd then
      bad_guesses.extend;
      bad_guesses(bad_guesses.count) := chr(10)||' and w != '''||l_guess||'''';
  else
      pipe row ('COMPLETED!!!');
  end if;

  return;
end;

--procedure dbg is
--begin
--  for i in 1 .. pos_correct.count loop
--     dbms_output.put_line(pos_correct(i));
--  end loop;
--  for i in 1 .. correct.count loop
--     dbms_output.put_line(correct(i));
--  end loop;
--  for i in 1 .. incorrect.count loop
--     dbms_output.put_line(incorrect(i));
--  end loop;
--  for i in 1 .. bad_guesses.count loop
--     dbms_output.put_line(bad_guesses(i));
--  end loop;
-- end;

function strength(str varchar2) return number is
  l_strength int := 0;
begin
  for i in 1 .. 5 loop
    l_strength :=   l_strength + dist(ascii(substr(str,i,1))-ascii('a')+1);
  end loop;
  return l_strength;
end;

begin
  select 100*ratio_to_report(c) over ()
  bulk collect into dist
  from (
    select x, count(*) c
    from (
      select substr(w,1,1) x from wordle
      union all
      select substr(w,2,1) from wordle
      union all
      select substr(w,3,1) from wordle
      union all
      select substr(w,4,1) from wordle
      union all
      select substr(w,5,1) from wordle
      )
    group by x
  )
  order by x;

end;
/
sho err

REM exec pkg.new_game;
REM select * from pkg.guess('raise');
REM select * from pkg.guess('count');
REM select * from pkg.guess();
