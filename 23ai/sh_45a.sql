clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set termout on
set echo on
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
clear screen
set serveroutput on
declare
  gtrid varchar2(128);
begin
  gtrid := dbms_transaction.start_transaction
  ( utl_raw.cast_to_raw('FLIGHT_QF654_SEAT_42A')
  , dbms_transaction.transaction_type_sessionless
  , 20
  , dbms_transaction.transaction_resume
  );
  dbms_output.put_line(utl_raw.cast_to_varchar2(gtrid));
end;
/
pause
clear screen
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
pause
select xidusn,xidslot,xidsqn
from v$transaction;
pause
commit;
pause
select *
from  flight_booking
where flight_num = 'QF654'
and   seat = '42A';
rem
rem back to session 1
rem
