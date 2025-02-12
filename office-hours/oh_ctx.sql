REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
col namespace format a12
col client_identifier format a12
drop context my_globctx;
drop procedure my_ctxproc;
drop package my_ctxpkg;

set termout on
clear screen
set echo on

create or replace 
context my_globctx using my_ctxpkg
accessed globally;
pause
create or replace
package my_ctxpkg is
  procedure set_ctx(p_client varchar2);
  procedure clear_ctx(p_client varchar2);
end;
/
pause

create or replace
package body my_ctxpkg is
  procedure set_ctx(p_client varchar2) is
  begin
    for i in 1 .. 20 
    loop
      sys.dbms_session.set_context (
           namespace => 'MY_GLOBCTX'
          ,attribute => 'ATTRIBUTE_'||i
          ,value     => rpad(i,100,'x')
          ,client_id => p_client );
    end loop;
  end;
#pause
  procedure clear_ctx(p_client varchar2) is
  begin
    for i in 1 .. 20 
    loop
      sys.dbms_session.clear_context(
           namespace => 'MY_GLOBCTX'
          ,attribute => 'ATTRIBUTE_'||i
          ,client_id => p_client );
    end loop;          
  end;
end;
/
pause
exec my_ctxpkg.set_ctx('CONNOR')
exec dbms_session.set_identifier('CONNOR');
select sys_context('MY_GLOBCTX','ATTRIBUTE_12') from dual;
pause
select namespace, client_identifier, count(*)
from  v$globalcontext
group by namespace, client_identifier;

exec my_ctxpkg.set_ctx('CONNOR1')
exec my_ctxpkg.set_ctx('CONNOR2')
exec my_ctxpkg.set_ctx('CONNOR3')

select namespace, client_identifier, count(*)
from  v$globalcontext
group by namespace, client_identifier;

select name, bytes 
from v$sgastat
where pool = 'shared pool' 
and name = 'Global Context';
pause
conn / as sysdba
select name, bytes 
from v$sgastat
where pool = 'shared pool' 
and name = 'Global Context';
conn USER/PASSWORD@MY_PDB
  
exec my_ctxpkg.clear_ctx('CONNOR')
exec my_ctxpkg.clear_ctx('CONNOR1')
exec my_ctxpkg.clear_ctx('CONNOR2')
exec my_ctxpkg.clear_ctx('CONNOR3')
pause
 
select namespace, client_identifier, count(*)
from  v$globalcontext
group by namespace, client_identifier;
pause

conn / as sysdba
select name, bytes 
from v$sgastat
where pool = 'shared pool' 
and name = 'Global Context';
conn USER/PASSWORD@MY_PDB

exec my_ctxpkg.set_ctx('CONNOR5')
exec my_ctxpkg.set_ctx('CONNOR6')
exec my_ctxpkg.set_ctx('CONNOR7')
exec my_ctxpkg.set_ctx('CONNOR8')
exec my_ctxpkg.set_ctx('CONNOR9')

conn / as sysdba
select name, bytes 
from v$sgastat
where pool = 'shared pool' 
and name = 'Global Context';
pause
conn USER/PASSWORD@MY_PDB

create or replace
package my_ctxpkg is
  procedure set_ctx(p_client varchar2);
  procedure clear_ctx(p_client varchar2);
  procedure clear_all(p_client varchar2);
end;
/
pause

create or replace
package body my_ctxpkg is
  procedure set_ctx(p_client varchar2) is
  begin
    for i in 1 .. 20 
    loop
      sys.dbms_session.set_context (
           namespace => 'MY_GLOBCTX'
          ,attribute => 'ATTRIBUTE_'||i
          ,value     => rpad(i,100,'x')
          ,client_id => p_client );
    end loop;
  end;

  procedure clear_ctx(p_client varchar2) is
  begin
    for i in 1 .. 20 
    loop
      sys.dbms_session.clear_context(
           namespace => 'MY_GLOBCTX'
          ,attribute => 'ATTRIBUTE_'||i
          ,client_id => p_client );
    end loop;          
  end;

  procedure clear_all(p_client varchar2) is
  begin
      sys.dbms_session.clear_context(
           namespace => 'MY_GLOBCTX'
          ,client_id => p_client );
  end;
end;
/
pause

exec my_ctxpkg.clear_all('CONNOR')
exec my_ctxpkg.clear_all('CONNOR1')
exec my_ctxpkg.clear_all('CONNOR2')
exec my_ctxpkg.clear_all('CONNOR3')

exec my_ctxpkg.clear_all('CONNOR5')
exec my_ctxpkg.clear_all('CONNOR6')
exec my_ctxpkg.clear_all('CONNOR7')
exec my_ctxpkg.clear_all('CONNOR8')
exec my_ctxpkg.clear_all('CONNOR9')
pause



conn / as sysdba
select name, bytes 
from v$sgastat
where pool = 'shared pool' 
and name = 'Global Context';
conn USER/PASSWORD@MY_PDB
