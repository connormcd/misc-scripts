clear screen
@clean
set termout off
conn dbdemo/dbdemo@db19
set termout off
exec dbms_random.seed(0)
commit;
@drop bigrams
@drop probabilities
set echo on
clear screen
set termout on
select *
from hamlet
where rownum < = 10;
pause
clear screen
select replace('~'||replace(text,' ','~')||'~','~~','~') term
from   hamlet
where rownum <= 10;
pause
clear screen
create table bigrams ( key varchar2(2), cnt int);
pause
set serverout on  
declare
  type tensor is table of int index by varchar2(2);
  t tensor;
  idx varchar2(2);
  len int;
begin
  for i in ( 
    select replace('~'||replace(text,' ','~')||'~','~~','~') term
    from   hamlet)
  loop
    len := length(i.term)-1;
    for j in 1 .. len loop 
      idx := substr(i.term,j,2);
      t(idx) := case when not t.exists(idx) then 1 else t(idx)+ 1 end;
    end loop;
  end loop;

  for x,y in pairs of t loop
    insert into bigrams values (x,y);
  end loop;
end;
/
pause
clear screen
select *
from bigrams
order by cnt desc
fetch first 12 rows only;
pause
clear screen
select *
from bigrams
where key like '~%'
order by cnt desc
fetch first 10 rows only;
pause
clear screen
select key, ratio_to_report(cnt) over () as prob
from bigrams
where key like '~%'
order by cnt desc
fetch first 10 rows only;
pause
clear screen
create table probabilities as
select key, 
     nvl(sum(prob) over ( 
        order by prob desc 
        rows between unbounded preceding and 1 preceding),0) as cum_prob_lo,
     sum(prob) over ( order by prob desc ) as cum_prob_hi
from (
  select key, ratio_to_report(cnt) over () as prob
  from bigrams
  where key like '~%'
);
pause
clear screen
select *
from probabilities
order by cum_prob_lo 
fetch first 10 rows only;
pause
clear screen
drop table probabilities purge;
pause
create table probabilities as
select prefix,
     key, 
     nvl(sum(prob) over ( 
       partition by prefix 
       order by prob desc 
       rows between unbounded preceding and 1 preceding),0) as cum_prob_lo,
     sum(prob) over ( 
       partition by prefix 
       order by prob desc ) as cum_prob_hi
from (
  select substr(key,1,1) prefix, key, 
         ratio_to_report(cnt) over ( partition by substr(key,1,1)) as prob
  from bigrams
  -- where key like '~%'
);
pause
clear screen
create or replace
procedure next_term(p_name in out varchar2,pfx varchar2 default '~') is
  l_rnd    number := dbms_random.value();
  l_key    varchar2(2);
  l_prefix varchar2(1);
begin
  select prefix, key
  into l_prefix, l_key
  from probabilities
  where l_rnd between cum_prob_lo and cum_prob_hi
  and prefix = pfx
  and rownum = 1;

  p_name := p_name || substr(l_key,2,1);
  dbms_output.put_line(p_name);
  if l_key like '%~' then
    return;
  else
    next_term(p_name,substr(l_key,2,1));
  end if;
end;
/
pause
set serverout on
clear screen
variable name varchar2(1000);
pause
exec :name := '~'
pause
exec next_term(:name);
pause
exec :name := '~'
exec next_term(:name);
pause
clear screen
set serverout off
exec :name := '~'
exec next_term(:name);
print name
pause
clear screen
create or replace
procedure next_term(p_name in out varchar2,pfx varchar2 default '~') is
  l_rnd number := dbms_random.value();
  l_key varchar2(2);
  l_prefix varchar2(1);
begin
  select prefix, key
  into l_prefix, l_key
  from probabilities
  where l_rnd between cum_prob_lo and cum_prob_hi
  and prefix = pfx
  and rownum = 1;

  p_name := p_name || substr(l_key,2,1);
  if l_key like '%~' then
    return;
  else
    next_term(p_name,substr(l_key,2,1));
  end if;
end;
/
pause
clear screen
set serverout on
declare
  phrase varchar2(1000);
  name   varchar2(1000);
begin
  for i in 1 .. 20 loop
    name := '~';
    next_term(name);
    name := trim('~' from name);
    phrase := phrase||' '||replace(name,'~',' ');
  end loop;
  dbms_output.put_line(phrase);
end;
/
