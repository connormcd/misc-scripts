exec dbms_random.seed(0)
commit;
@drop gtt
@drop gtt1

declare
  type tensor is table of int index by varchar2(2);
  t tensor;
  idx varchar2(2);
begin
  for i in ( 
    select '~'||keyword||'~' term, length(keyword)+1 len
    from   v$reserved_words
    where  keyword is not null)
  loop
    for j in 1 .. i.len 
    loop null;
      idx := substr(i.term,j,2);
      if t.exists(idx) then
        t(idx) := t(idx)+ 1;
      else
        t(idx) := 1;
      end if;
    end loop;
  end loop;
end;
/

create table gtt ( key varchar2(2), cnt int);

set serverout on  
declare
  type tensor is table of int index by varchar2(2);
  t tensor;
  idx varchar2(2);
begin
  for i in ( 
    select '~'||keyword||'~' term, length(keyword)+1 len
    from   v$reserved_words
    where  keyword is not null)
  loop
    for j in 1 .. i.len 
    loop null;
      idx := substr(i.term,j,2);
      if t.exists(idx) then
        t(idx) := t(idx)+ 1;
      else
        t(idx) := 1;
      end if;
    end loop;
  end loop;

  for x,y in pairs of t loop
    insert into gtt values (x,y);
  end loop;

end;
/
select *
from gtt
order by cnt desc
fetch first 10 rows only;

select *
from gtt
where key like '~%'
order by cnt desc
fetch first 10 rows only;

select key, ratio_to_report(cnt) over () as prob
from gtt
where key like '~%'
order by cnt desc
fetch first 10 rows only;

@drop gtt1

create table gtt1 as
select key, 
     nvl(sum(prob) over ( order by prob desc rows between unbounded preceding and 1 preceding),0) as cum_prob_lo,
     sum(prob) over ( order by prob desc ) as cum_prob_hi
from (
  select key, ratio_to_report(cnt) over () as prob
  from gtt
  where key like '~%'
);

with samples as
 ( select dbms_random.value() s from dual
   connect by level <= 10 
   )
select *
from gtt1, samples
where s between cum_prob_lo and cum_prob_hi;

with samples as
 ( select dbms_random.value() s from dual
   connect by level <= 1000 
   )
select key, count(*)
from gtt1, samples
where s between cum_prob_lo and cum_prob_hi
group by key
order by 2 desc;

@drop gtt1

create table gtt1 as
select substr(key,1,1) prefix, key, ratio_to_report(cnt) over ( partition by substr(key,1,1)) as prob
from gtt;

select * from gtt1
order by 1,3 desc;

@drop gtt1

create table gtt1 as
select prefix,
     key, 
     nvl(sum(prob) over ( partition by prefix order by prob desc rows between unbounded preceding and 1 preceding),0) as cum_prob_lo,
     sum(prob) over ( partition by prefix order by prob desc ) as cum_prob_hi
from (
  select substr(key,1,1) prefix, key, ratio_to_report(cnt) over ( partition by substr(key,1,1)) as prob
  from gtt
);

with samples as
 ( select dbms_random.value() s from dual
 ),
generator(pfx,ky,rnd)
as (
select prefix, key, s
from gtt1, samples
where s between cum_prob_lo and cum_prob_hi
and prefix = '~'
union all
select prefix, key, next_s
from gtt1, generator, ( select dbms_random.value next_s from dual )
where prefix =  generator.pfx
and next_s between cum_prob_lo and cum_prob_hi
and key not like '%~'
)
select * from generator;


create or replace
procedure next_term(p_name in out varchar2,pfx varchar2 default '~') is
  l_rnd number := dbms_random.value();
  l_key varchar2(2);
  l_prefix varchar2(1);
begin

  p_name := nvl(p_name,'~');

  select prefix, key
  into l_prefix, l_key
  from gtt1
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

set serverout on
variable name varchar2(1000);
exec next_term(:name);

exec :name := null
exec next_term(:name);

