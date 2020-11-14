select to_char(min(logon_time),'DD/MM/YYYY HH24:MI:SS') started,
  round(sysdate-min(logon_time),2) days
 from v$session;