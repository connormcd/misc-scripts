REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
DROP TABLE SYSTEM.DDL_LOG CASCADE CONSTRAINTS
/

CREATE TABLE SYSTEM.DDL_LOG
(
  TSTAMP       TIMESTAMP(6)   NOT NULL,
  HOST         VARCHAR2(100),
  IP_ADDRESS   VARCHAR2(100),
  MODULE       VARCHAR2(100),
  OS_USER      VARCHAR2(100),
  TERMINAL     VARCHAR2(100),
  OPERATION    VARCHAR2(100),
  OWNER        VARCHAR2(50),
  OBJECT_NAME  VARCHAR2(50),
  OBJECT_TYPE  VARCHAR2(50),
  SQLTEXT      CLOB,
  PREVSQLTEXT  CLOB
)
/


DROP TRIGGER SYSTEM.capture_all_ddl
/

CREATE OR REPLACE TRIGGER SYSTEM.CAPTURE_ALL_DDL
after create or alter or drop on database
begin
  --
  -- lots of flexibility here in choosing what you want to log
  -- and when etc etc.
  --
  if ora_dict_obj_owner in ('....')
    and  dbms_utility.format_call_stack not like '%NIGHTLY%'  -- not the nightly maint jobs
    and  nvl(sys_context('USERENV','MODULE'),'x') != 'DBMS_SCHEDULER'  -- not jobs
  then
    --
    -- and we can capture all the usual sys_context values
    --
    insert into SYSTEM.ddl_log
    values (systimestamp,
                sys_context('USERENV','HOST'),
                sys_context('USERENV','IP_ADDRESS'),
                sys_context('USERENV','MODULE'),
                sys_context('USERENV','OS_USER'),
                sys_context('USERENV','TERMINAL'),
                ora_sysevent,
                ora_dict_obj_owner,
                ora_dict_obj_name,
                ora_dict_obj_type,
                --
                -- In my case I choose to not log PL/SQL source, just the fact that it had been changed
                -- but you can do whatever you like here.
                --
                case when ora_dict_obj_type not in ('PACKAGE','PROCEDURE','FUNCTION','PACKAGE BODY') and ora_sysevent != 'DROP' then
                  ( select sql_fulltext from v$sql
                    where sql_id = ( select sql_id from v$session where sid = sys_context('USERENV','SID') ) 
                    and rownum = 1 
                  )
                end,
                case when ora_dict_obj_type not in ('PACKAGE','PROCEDURE','FUNCTION','PACKAGE BODY') and ora_sysevent != 'DROP' then
                  ( select sql_fulltext from v$sql
                    where sql_id = ( select prev_sql_id from v$session where sid = sys_context('USERENV','SID') ) 
                    and rownum = 1 
                  )
                end
           );
     
  end if;
exception
  when others then null;  -- we wil not STOP the ddl if we fail to track it
end;
/