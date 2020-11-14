undefine userid
accept userid char prompt "User id "
set verify off
set heading off

set termout off
col x new_value y
select ltrim(to_char(ora_hash(to_char(sysdate,'hh24miss')))) x from dual;
set termout on
set echo on

alter user &userid account unlock;
alter user &userid identified by pass&y password expire;
set echo off
pro Your password has been reset to pass&y

set heading on
