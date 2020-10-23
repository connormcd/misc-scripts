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
clear screen
@drop book
@drop trans
@drop audit_seq
@clean
set lines 120
set echo on
create sequence audit_seq;
pause
create table book 
 ( book_id    int,
   status     varchar2(10),
   close_seq  int,
   close_ts   timestamp );
pause

insert into book
values (1,'OPEN',null,null);
commit;
pause
clear screen

create table trans
 ( trans_seq int,
   book      int,
   trans_ts  timestamp
 );
pause
clear screen
create or replace
procedure new_trans(p_book int default 1,p_slow int default 0) is
  l_status varchar2(10);
begin
  select status
  into   l_status
  from   book
  where  book_id = p_book;
  
  if l_status = 'OPEN' then
    insert into trans
    values (audit_seq.nextval,p_book,localtimestamp);
    dbms_session.sleep(p_slow);
    commit;
 else 
    raise_application_error(-20000,'Book is closed');
 end if;
end;
/
pause
clear screen

create or replace
procedure close_book(p_book int default 1,p_slow int default 0) is
begin
  update book
  set    status = 'CLOSED',
         close_seq = audit_seq.nextval,
         close_ts = localtimestamp
  where  book_id = p_book;
  dbms_session.sleep(p_slow);
  
  commit;
end;
/
pause
set echo off
pro
pro Ensure session 2 ready
pro
set echo on
pause
clear screen
exec close_book(p_slow=>10);
pause
select close_seq, close_ts from book;
select trans_seq, trans_ts from trans;
pause
exec reset_to_empty
pause

clear screen
create or replace
procedure locker(p_book    int default 1,
                 p_timeout int default 10,
                 p_mode    varchar2) is

  l_status     pls_integer;
  l_lock_id    pls_integer := p_book;
  
begin
    l_status := dbms_lock.request(
       id=>l_lock_id,
       lockmode=>case 
          when p_mode = 'Shared' then dbms_lock.s_mode 
          else dbms_lock.x_mode end,
       timeout=>p_timeout,
       release_on_commit=>true);

  if l_status not in (0,4) then
        raise_application_error(-20000,'Time out');
  end if;
end;
/
pause
clear screen

create or replace
procedure new_trans(p_book int default 1,p_slow int default 0) is
  l_status varchar2(10);
begin
  locker(p_book=>p_book,p_mode=>'Shared');

  select status
  into   l_status
  from   book
  where  book_id = p_book;
  
  if l_status = 'OPEN' then
    insert into trans
    values (audit_seq.nextval,p_book,localtimestamp);
    dbms_session.sleep(p_slow);
    commit;
 else 
    raise_application_error(-20000,'Book is closed');
 end if;
end;
/
pause
clear screen

create or replace
procedure close_book(p_book int default 1,p_slow int default 0) is
begin
  locker(p_book=>p_book,p_mode=>'Exclusive');
 
  update book
  set    status    = 'CLOSED',
         close_seq = audit_seq.nextval,
         close_ts  = localtimestamp
  where  book_id   = p_book;
  dbms_session.sleep(p_slow);
  
  commit;
end;
/
pause
clear screen

exec new_trans;
exec new_trans;
exec new_trans;
select * from trans;
pause
set echo off
clear screen
pro
pro Make sure concurrency is still fine
pro
set echo on
pause
exec new_trans(p_slow=>10);
pause

set echo off
clear screen
pro
pro Now to prove serialisation
pro
set echo on
pause
exec close_book(p_slow=>10);
set echo off
pro
pro over to session 2
pro
