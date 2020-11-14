set pagesize 999
set lines 200
set newpage 0
set trimspool on
set verify off

accept username prompt 'Username: '

clear computes

column  username        format           a12    heading "Name"
column  start_time      format           a13    heading "Logon"
column  end_time        format            a6    heading "Logoff"
column  logoff_lread    format   999,999,990    heading "Logicals"
column  logoff_pread    format   999,999,990    heading "Physicals"
column  logoff_lwrite   format   999,999,990    heading "Writes"

break on username skip 1 on report 

REM compute sum label '' of logoff_lread on username
REM compute sum label '' of logoff_pread on username
REM compute sum label '' of logoff_lwrite on username

REM compute sum label TOTAL of logoff_lwrite on report
REM compute sum label TOTAL of logoff_pread on report
REM compute sum label TOTAL of logoff_lwrite on report

select
        username,
        to_char(timestamp,'dd-Mon: hh24:mi')    start_time,
        to_char(logoff_time,'hh24:mi')  end_time,
        logoff_lread,
        logoff_pread,
        logoff_lwrite
  from  dba_audit_session
where username = nvl('&username',username)
order by
        username,
        logoff_lread,
        logoff_pread;

undefine username
undefine thedate
clear computes
