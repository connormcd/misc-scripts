REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

conn /@YOURDB as sysdba
drop user ogb cascade;
create user ogb identified by ogb;
grant resource, connect, unlimited tablespace to ogb;
grant select on v_$session_event to ogb;
grant select on v_$sesstat to ogb;
grant select on v_$statname to ogb;
grant select on v_$session to ogb;

conn ogb/ogb@YOURDB
