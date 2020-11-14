begin
  for rec in (select
    regexp_substr( dbms_metadata.get_ddl('USER', username), '''[^'']+''') pw,
    username from dba_users where username IN ('&1')) loop
    execute immediate 'alter user ' || rec.username || ' account unlock';
    execute immediate 'alter user ' || rec.username || 
      ' identified by values ' || rec.pw;
  end loop;
end;
/


