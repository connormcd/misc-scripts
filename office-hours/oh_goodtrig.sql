REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
exec dbms_random.seed(0)
@drop customer
@drop customer_seq
set termout on
@clean
alter session set nls_date_format = 'DD-MON-YY HH24:MI:SS';
set echo on

create sequence customer_seq;

create table customer ( 
  id      int          default on null customer_seq.nextval primary key , 
  descr   varchar2(10) not null,
  status  int          default 0 not null,
  created date         default on null sysdate not null, 
  updated date
  );
pause
create or replace
trigger customer_trg_upd
before update
on customer
for each row
begin
  :new.updated := sysdate;
end;
/
pause
clear screen
insert into customer (descr) values ('customer');
pause
update customer
set descr = 'new data'
where id = 1;
commit;
select * from customer;
pause

clear screen

insert into customer (descr)
select 'cust'||rownum
from dual
connect by level <= 1000;
commit;

pause
begin
  for i in 1 .. 500
  loop
    update customer
    set    status = 2
    where  id = trunc(dbms_random.value(1,1000));
  end loop;
  commit;
end;
/
pause
select * from customer
where rownum <= 20;
pause
set echo off
clear screen

pro|           _____  _____  _____ _    _ _    _ _    _ _    _ 
pro|     /\   / ____|/ ____|/ ____| |  | | |  | | |  | | |  | |
pro|    /  \ | |  __| |  __| |  __| |__| | |__| | |__| | |__| |
pro|   / /\ \| | |_ | | |_ | | |_ |  __  |  __  |  __  |  __  |
pro|  / ____ \ |__| | |__| | |__| | |  | | |  | | |  | | |  | |
pro| /_/    \_\_____|\_____|\_____|_|  |_|_|  |_|_|  |_|_|  |_|
pro|                                                           
                                                           
pause
set echo on

update customer
set status = 1
where status = 2;
pause
select sysdate from dual;
select *
from (
  select * from customer
  order by updated desc nulls last
)
where rownum < 10;
pause
rollback;
pause
clear screen
alter trigger customer_trg_upd disable;
pause
update customer
set status = 1
where status = 2;
select * from customer
where status = 1
and rownum <= 10;
pause
rollback;
pause
clear screen
create or replace
package trigger_ctl is
  procedure maintenance_on(p_trigger varchar2);
  procedure maintenance_off(p_trigger varchar2);
  function  enabled(p_trigger varchar2) return boolean;
end;
/
pause
clear screen

create or replace
package body trigger_ctl is

  type trig_list is table of int
   index by varchar2(128);

  t trig_list;

  procedure maintenance_on(p_trigger varchar2) is
  begin
    t(p_trigger) := 1;
  end;
  
  procedure maintenance_off(p_trigger varchar2) is
  begin
    if t.exists(p_trigger) then
       t.delete(p_trigger);
    end if;
  end;
  
  function  enabled(p_trigger varchar2) return boolean is
  begin
    return not t.exists(p_trigger);
  end;

end;
/
pause
clear screen

create or replace
trigger customer_trg_upd
before update
on customer
for each row
begin
  if trigger_ctl.enabled('customer_trg_upd') then
    :new.updated := sysdate;
  end if;
end;
/
pause

exec trigger_ctl.maintenance_on('customer_trg_upd')
update customer
set status = 1
where status = 2;
exec trigger_ctl.maintenance_off('customer_trg_upd')
pause
select sysdate from dual;
select * from customer
where status = 1
and rownum <= 10;
pause

clear screen
create or replace
package trigger_ctl is
  procedure maintenance_on(p_trigger varchar2, p_expiry date default sysdate+1/24);
  procedure maintenance_off(p_trigger varchar2);
  function  enabled(p_trigger varchar2) return boolean;
end;
/
pause

clear screen

create or replace
package body trigger_ctl is

  type trig_list is table of date
   index by varchar2(128);

  t trig_list;

  procedure maintenance_on(p_trigger varchar2, p_expiry date default sysdate+1/24) is
  begin
    t(p_trigger) := p_expiry;
  end;
  
  procedure maintenance_off(p_trigger varchar2) is
  begin
    if t.exists(p_trigger) then
       t.delete(p_trigger);
    end if;
  end;
  
  function  enabled(p_trigger varchar2) return boolean is
  begin
    if not t.exists(p_trigger) then return true; end if;
    if t(p_trigger) < sysdate then return false; end if;
    t.delete(p_trigger); 
    -- raise_application_error(-20000,'TIME IS UP!!!!');
    return true; 
  end;

end;
/
