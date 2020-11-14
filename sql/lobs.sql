 select s.sid, s.serial#,
        decode(s.username,null,to_char(null),
              decode(s.USERNAME,'IMS',nvl2(module||action,action||','||module,'IMS'), s.username)
              ||' ('||s.last_call_et||')') username,
        t.CACHE_LOBS,  t.NOCACHE_LOBS
 from v$session s, v$temporary_lobs t
 where s.sid = nvl(to_number('&sid'),s.sid)
 and t.sid = s.sid;
