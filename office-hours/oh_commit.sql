REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

alter session enable commit in procedure;
@drop pkg
@drop prc
@dropc t

create table t ( x int );
insert into t values (1);

create or replace
procedure PRC 
authid current_user is
begin
  update t set x = x + 1;
  commit;
end;
/

alter session disable commit in procedure;
exec prc

create or replace
package pkg is
  procedure noop;
end;
/

create or replace
package body pkg is
  procedure noop is begin null; end;
end;
/

create or replace
procedure PRC 
authid current_user is
begin
  pkg.noop;
  update t set x = x + 1;
  commit;
end;
/
  
alter session enable commit in procedure;
exec prc
alter session disable commit in procedure;
exec prc







New podcast episode! To finish off this 3-part series with Oracle Intern Layla Massey, we discuss the challenges facing women in IT, even at the college level, the role of exercise for work/life balance, how to exploit a social media presence to get ahead in the IT industry, and how to build a personal brand by remaining authentic.

Enjoy! #community #podcast #sql #database

https://open.spotify.com/show/5dqVVftZhw0lu1fnX20TiP