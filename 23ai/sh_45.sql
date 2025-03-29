clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system reset txn_auto_rollback_high_priority_wait_target;
@drop flight_booking
alter system reset priority_txns_high_wait_target;
drop user jane_doe cascade;
drop domain amex ;
@drop t1
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
drop trigger SCOTT.BAD_TRIG;
@drop t
@drop person
alter table products modify total_sold not reservable;
@drop products
@drop seq
@drop myemp
@drop customer
@drop dept_doc
@drop orders
@drop orderitems
@drop t1
@drop t2
col journal new_value journal_table
col journal format a30
set verify off
drop view orders_ov;
@dropc order_items
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
col first_name format a20
col last_name format a20
drop user lazy_joe cascade;
drop user daily_pay_run cascade;
create table flight_booking
( flight_num    varchar2(10),
  seat          varchar2(10),
  allocated_to  varchar2(40)
);
insert into flight_booking 
values ('QF654', '42A', null );
commit;
col allocated_to format a24
clear screen
set termout on
set echo off
prompt |
prompt | 
prompt |    _____ ______  _____ _____ _____ ____  _   _ _      ______  _____ _____     _________   ___   _ 
prompt |   / ____|  ____|/ ____/ ____|_   _/ __ \| \ | | |    |  ____|/ ____/ ____|   |__   __\ \ / / \ | |
prompt |  | (___ | |__  | (___| (___   | || |  | |  \| | |    | |__  | (___| (___        | |   \ V /|  \| |
prompt |   \___ \|  __|  \___ \\___ \  | || |  | | . ` | |    |  __|  \___ \\___ \       | |    > < | . ` |
prompt |   ____) | |____ ____) |___) |_| || |__| | |\  | |____| |____ ____) |___) |      | |   / . \| |\  |
prompt |  |_____/|______|_____/_____/|_____\____/|_| \_|______|______|_____/_____/       |_|  /_/ \_\_| \_|
prompt |                                                                                                   
prompt |                                                                                                   
prompt |
pause
clear screen
set termout on
set echo on
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A'
and   allocated_to is null
for update;
pause
update flight_booking
set   allocated_to = 'Connor McDonald'
where flight_num = 'QF654'
and   seat = '42A';
pause
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
roll;
pause
clear screen
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A'
and   allocated_to is null
for update;
pause
-- call American Airlines service
pause
-- call Emirates service
pause
-- call Qatar service
pause
-- call Frequent Flyer micro-service
pause
-- call Payments service
pause
-- etc etc etc
pause
roll;
set echo off
clear screen
pro |
pro |  Connection Pool 
pro |
pro |  Session      Status
pro |  =======      ==========
pro |  01           In-Use
pro |  02           Available
pro |  03           Available
pro |  04           Available
pro |
pause
clear screen
pro |
pro |  Connection Pool 
pro |
pro |  Session      Status
pro |  =======      ==========
pro |  01           In-Use
pro |  02           In-Use
pro |  03           In-Use
pro |  04           In-Use
pro |
pause
set echo on
clear screen
alter table flight_booking
  add txn_status varchar2(10);
pause
alter table flight_booking
  add txn_timeout date;
pause  
clear screen
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A'
and   allocated_to is null
for update;
pause
update flight_booking
set   allocated_to = 'Connor McDonald',
      txn_status = 'PENDING',
      txn_timeout = sysdate + 180/86400
where flight_num = 'QF654'
and   seat = '42A';
pause
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
COMMIT;
pause
-- call American Airlines service
-- call Emirates service
-- call Qater service
-- call Frequent Flyer micro-service
-- call Payments service
-- etc etc etc
pause
clear screen
update flight_booking
set   allocated_to = 'Connor McDonald',
      txn_status = 'CONFIRMED',
      txn_timeout = null
where flight_num = 'QF654'
and   seat = '42A'
and   txn_timeout > sysdate;
pause
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
commit;
pause
clear screen
update flight_booking
set allocated_to = null;
pause
alter table flight_booking drop column txn_status;
alter table flight_booking drop column txn_timeout;
pause
clear screen
set serveroutput on
declare
  gtrid varchar2(128);
begin
  gtrid := 
     dbms_transaction.start_transaction
       ( utl_raw.cast_to_raw('FLIGHT_QF654_SEAT_42A')
        ,dbms_transaction.transaction_type_sessionless
        ,180
        ,dbms_transaction.transaction_new
       );
  dbms_output.put_line(utl_raw.cast_to_varchar2(gtrid));
end;
/
pause
update flight_booking
set   allocated_to = 'Connor McDonald'
where flight_num = 'QF654'
and   seat = '42A';
pause
clear screen
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
exec dbms_transaction.suspend_transaction;
rem
rem over to session 2 (45a)
rem
pause 
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause Done

