REM 
REM HR sample schema wrapper.
REM
REM This script tries to be a "one and done" script to load the HR schema
REM by guiding the novice as best as possible to ensure a sucessfull installation
REM of the schema.  Things it will endeavour to do:
REM
REM  - not let you install into a root container by mistake
REM  - make sure you are connected correctly
REM  - if you are connected as HR, we'll try reload the schema objects and keep the user
REM  - if you are connected not as HR, we'll try drop/recreate the HR schema
REM  - we check for required privs in the HR schema
REM  - we check for required privs for an admin to build the HR schema from scratch
REM  - we check for appropriate tablespace quotas
REM  - we check for default tablespaces
REM  - we check for existing sessions as HR which would block a drop
REM  - we check for OS file writability for spool files
REM
REM In all cases, we try to provide guidance on remedial action to follow if 
REM the installation fails or cannot proceed.
REM
REM Like anything, you could come up with a bizarre set of circumstances in which
REM this can be broken, but it should work for most. If you do you break it, please
REM get in touch so I can make it even more carefree for beginners.
REM 
REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 


set echo off
set lines 200
set termout off
set markup csv off
set markup html off
set autotrace off
set timing off
set sqlprompt 'SQL> '
set echo off
set feedback on
set heading on
set define '&'
set tab off
set long 50000
set longchunksize 500
set pages 999
set verify off
undefine 1
undefine 2
undefine 3
undefine 4
set termout on
whenever sqlerror continue
clear screen


pro | 1) Preliminary checks
pro | =====================
pro |
pro | You should be connected to the database at this point.
pro | If you are, then you will see the following:
pro |
pro |  >>> Connected as: YOUR_USER <<<
pro |
pro | If you are not, you're will see the following
pro |
pro |  >>>> SP2-0640: Not connected <<<<
pro |
pro | If you get this error, press Ctrl-C to exit this script and 
pro | connect first before running it again. 
pro | 
pro | Tip: For Express Edition, the command to connect is *probably*
pro |
pro | SQL> connect system/yourpassword@//localhost/XEPDB1
pro |
pro | Once you are connected OK, then press Enter to proceed
pro |
set pages 0
set feedback off
select 'Connected as: '||user from dual;
pro
set pages 999

accept dummy prompt 'Enter to proceed, Ctrl-C to stop'

pro |
pro | Checking that we can write a file to the current directory
pro | If we can't, then this script will exit here. Please make
pro | you are running the script from the directory you saved it to
pro | and this directory is writable
pro |
whenever oserror exit
spool file_write_test.out
spool off
whenever oserror continue
pro File test passed!
pro |

pro |
pro | Now checking database details. If any of these fail,
pro | the script will exit with the error that you need
pro | to resolve.
pro |
whenever sqlerror exit
set serverout on
begin
  if sys_context('USERENV','CON_ID') = '0' then
     dbms_output.put_line('Non-container database. No pluggable check needed...proceeding');
  elsif sys_context('USERENV','CON_ID') = '1' then
     dbms_output.put_line('---------------------------------------------------------');
     dbms_output.put_line('ERROR TEXT:');
     dbms_output.put_line('Sample data should not be loaded into the root container.');
     dbms_output.put_line('You should always connect to a pluggable database.');
     dbms_output.put_line('eg. connect system/yourpassword@//localhost/XEPDB1 for Express Edition.');
     dbms_output.put_line('---------------------------------------------------------');
     raise_application_error(-20000,'Script exiting with error');
  else
     dbms_output.put_line('Container database. PDB '||sys_context('USERENV','CON_NAME')||' will be used for installation...proceeding');
  end if;
end;
/
whenever sqlerror continue

pro |
pro | Checking current user details
pro |

begin
   if user = 'HR' then
     dbms_output.put_line('You are connected as HR so assuming this is a re-install.');
     dbms_output.put_line('This installation will drop any existing objects in this');
     dbms_output.put_line('schema. If this was not what you wanted, then press Ctrl-C');
     dbms_output.put_line('the installation, otherwise press Enter to continue');
   else
     --
     -- this user needs DBA privs
     --
     dbms_output.put_line('You are connected as '||user||', ie, not the HR schema.');
     dbms_output.put_line('Hence this installation will drop the HR schema entirely');
     dbms_output.put_line('and recreate it. If this was not what you wanted, then press Ctrl-C');
     dbms_output.put_line('the installation, otherwise press Enter to continue');
   end if;    
end;
/

pro
accept dummy prompt 'Enter to proceed, Ctrl-C to stop'

pro |
pro | Checking required privileges
pro |
whenever sqlerror exit
set serverout on
declare
  l_priv sys.odcivarchar2list := 
      sys.odcivarchar2list (
      'CREATE MATERIALIZED VIEW',
      'CREATE PROCEDURE',
      'CREATE SEQUENCE',
      'CREATE SESSION',
      'CREATE SYNONYM',
      'CREATE TABLE',
      'CREATE TRIGGER',
      'CREATE TYPE',
      'CREATE VIEW'
      );
  l_fail boolean := false;        
begin
  if user = 'HR' then
    for i in ( select p.column_value, s.privilege
               from   table(l_priv) p,
                      session_privs s
               where  p.column_value = s.privilege(+)
               order by 1
             )
    loop
      if i.privilege is not null then
        dbms_output.put_line('Privilege '||rpad(i.column_value,20,'.')||'...OK');
      else       
        dbms_output.put_line('Privilege '||rpad(i.column_value,20,'.')||'...FAIL');
        l_fail := true;
      end if;
    end loop;
    if l_fail then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('One or more privileges for the HR schema are missing.');
       dbms_output.put_line('We need these to successfully create/load the schema.');
       dbms_output.put_line('For each missing privilege, an admin account (eg SYSTEM) needs');
       dbms_output.put_line('to issue: GRANT <privilege name> TO HR');
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
    end if;
  end if;
end;
/
whenever sqlerror continue

whenever sqlerror exit
set serverout on
declare
  l_priv sys.odcivarchar2list := 
      sys.odcivarchar2list (
         'DROP USER'
        ,'CREATE USER'
        ,'ALTER SESSION'
        ,'CREATE ANY TABLE'
        ,'CREATE ANY CLUSTER'
        ,'CREATE ANY SYNONYM'
        ,'CREATE ANY VIEW'
        ,'CREATE ANY SEQUENCE'
        ,'CREATE ANY PROCEDURE'
        ,'CREATE ANY TRIGGER'
        ,'CREATE ANY TYPE'
        ,'CREATE ANY OPERATOR'
        ,'CREATE ANY INDEXTYPE'
        ,'CREATE ANY INDEX'
        ,'ALTER USER'
        ,'COMMENT ANY TABLE'
        ,'GRANT ANY OBJECT PRIVILEGE'
        ,'GRANT ANY PRIVILEGE'
        ,'CREATE SESSION'
        ,'ALTER ANY TABLE'
        ,'SELECT ANY TABLE'
        ,'INSERT ANY TABLE'
        ,'UPDATE ANY TABLE'
        ,'DELETE ANY TABLE'
        ,'ALTER ANY TRIGGER'
        ,'ANALYZE ANY'
        );
        
  l_fail boolean := false;      
  l_sess int;
  l_priv_cnt int;
begin
  if user != 'HR' then
    for i in ( select p.column_value, s.privilege
               from   table(l_priv) p,
                      session_privs s
               where  p.column_value = s.privilege(+)
               order by 1
             )
    loop
      if i.privilege is not null then
        dbms_output.put_line('Privilege '||rpad(i.column_value,30,'.')||'...OK');
      else       
        --
        -- we might be able to get away with less here (we'll try)
        --
        if i.column_value = 'GRANT ANY PRIVILEGE' then
          begin
            execute immediate q'{
                with role_list as (
                  select distinct granted_role 
                  from dba_role_privs
                  start with grantee = user
                  connect by prior granted_role = grantee
                  union all 
                  select user from dual
                  union all
                  select 'PUBLIC' from dual
                )
                select count(distinct p.privilege)
                from role_list r, dba_sys_privs p
                where p.grantee = r.granted_role
                and p.admin_option = 'YES'
                and p.privilege in (
      'CREATE MATERIALIZED VIEW',
      'CREATE PROCEDURE',
      'CREATE SEQUENCE',
      'CREATE SESSION',
      'CREATE SYNONYM',
      'CREATE TABLE',
      'CREATE TRIGGER',
      'CREATE TYPE',
      'CREATE VIEW'
                )
                }' into l_priv_cnt;
              if l_priv_cnt = 12 then
                dbms_output.put_line('Privilege '||rpad(i.column_value,30,'.')||'...OK (NOT NEEDED)');
              else
                dbms_output.put_line('Privilege '||rpad(i.column_value,30,'.')||'...FAIL');
                l_fail := true;
              end if;
            exception
              when others then
                dbms_output.put_line('Privilege '||rpad(i.column_value,30,'.')||'...FAIL');
                l_fail := true;
            end;
        else
          dbms_output.put_line('Privilege '||rpad(i.column_value,30,'.')||'...FAIL');
          l_fail := true;
        end if;
      end if;
    end loop;
    --
    -- we also need v$session
    --
    begin
      execute immediate 'select 1 from v$session where rownum = 1' into l_sess;
      dbms_output.put_line('Privilege '||rpad('SELECT ON GV$SESSION',30,'.')||'...OK');
    exception
      when others then
         dbms_output.put_line('Privilege '||rpad('SELECT ON GV$SESSION',30,'.')||'...FAIL');
         l_fail := true;
    end;
    if l_fail then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('One or more privileges for the admin account you are using');
       dbms_output.put_line('to build the HR schema are missing.');
       dbms_output.put_line('We need these to successfully create/load the schema.');
       dbms_output.put_line('For each missing privilege, an admin account (eg SYSTEM) needs');
       dbms_output.put_line('to issue: GRANT <privilege name> TO '||user);
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
    end if;
  end if;  
end;
/
whenever sqlerror continue


pro |
pro | Checking tablespaces
pro |
whenever sqlerror exit
set serverout on
declare
  l_fail boolean := false;      
  l_ts  int;
  l_unlim int;
  l_ts_name varchar2(100);
begin
  if user != 'HR' then
    select count(trim(property_value))
    into   l_ts
    from   database_properties
    where  property_name in ('DEFAULT_PERMANENT_TABLESPACE','DEFAULT_TEMP_TABLESPACE' );

    if l_ts < 2 then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('The HR schema builds into the default tablespace for this');
       dbms_output.put_line('database so this database property needs to be set.'); 
       dbms_output.put_line('You need to issue:');
       dbms_output.put_line('SQL> alter database default tablespace <tspace>');
       dbms_output.put_line('SQL> alter database default temporary tablespace <temp_tspace>');
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
    end if;
  else
    select count(*)
    into   l_unlim
    from   session_privs
    where  privilege = 'UNLIMITED TABLESPACE';
    
    if l_unlim = 0 then
      select default_tablespace
      into   l_ts_name
      from   user_users;
      
      select sum(decode(max_bytes,-1,1e10,max_bytes))
      into   l_unlim
      from   user_ts_quotas
      where  tablespace_name = l_ts_name;
      
      if  l_unlim < 30*1024*1024 then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('The HR schema needs to have a tablespace quota set to that');
       dbms_output.put_line('can obtain space in the database.'); 
       dbms_output.put_line('You need to issue:');
       dbms_output.put_line('SQL> alter user HR quota 50m on '||l_ts_name);
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
      end if;
    end if;
  end if;
  dbms_output.put_line('Checks .......OK');
end;
/
whenever sqlerror continue

pro |
pro | Checking existing HR details
pro |
whenever sqlerror exit
set serverout on
declare
  l_fail boolean := false;      
  l_sess int;
begin
  if user != 'HR' then
    execute immediate 'select count(*) from   v$session  where  username = ''HR''' 
        into   l_sess;

    if l_sess > 0 then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('Someone is currently logged onto the database as user HR');
       dbms_output.put_line('which means we cannot drop and replace the schema.'); 
       dbms_output.put_line('Please get this person to log out and re-run the install.');
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
    end if;
  end if;
  dbms_output.put_line('Checks .......OK');
end;
/
whenever sqlerror continue

set termout off
undefine default_ts
undefine temp_ts
undefine pass
col PROPERTY_VALUE new_value default_ts
select PROPERTY_VALUE
from   database_properties
where  PROPERTY_NAME = 'DEFAULT_PERMANENT_TABLESPACE';

col    PROPERTY_VALUE new_value temp_ts
select PROPERTY_VALUE
from   database_properties
where  PROPERTY_NAME = 'DEFAULT_TEMP_TABLESPACE';

col rndstr new_value pass
select dbms_random.string('A',10)||'$$'||trunc(dbms_random.value(100,999)) rndstr from dual;
set termout on

set termout off
set serverout on
spool nonhr_create.sql
declare
  l_need_drop int;
begin
   if user != 'HR' then
      dbms_output.put_line('pro |');
      dbms_output.put_line('pro | The new/replaced HR schema will be created now.');
      dbms_output.put_line('pro | ');
      dbms_output.put_line('pro | Note down this password for the HR schema. You will need it to connect');
      dbms_output.put_line('pro |');
      dbms_output.put_line('pro | Password (case-sensitive): &&pass');
      dbms_output.put_line('pro |');
      dbms_output.put_line('pro | The script will exit on any error encountered, because it should run');
      dbms_output.put_line('pro | to completion with no errors at all');
      dbms_output.put_line('pro | ');
      dbms_output.put_line('accept dummy prompt ''Press Enter to start''');

      select count(*)
      into   l_need_drop
      from   all_users
      where  username = 'HR';
      
      if l_need_drop > 0 then
        dbms_output.put_line('DROP USER HR CASCADE;');
      end if;
      dbms_output.put_line('CREATE USER hr IDENTIFIED BY &&pass;');
      dbms_output.put_line('ALTER USER hr DEFAULT TABLESPACE &&default_ts QUOTA UNLIMITED ON &&default_ts;');
      dbms_output.put_line('ALTER USER hr TEMPORARY TABLESPACE &&temp_ts;');
      dbms_output.put_line('grant CREATE SESSION to hr;');
      dbms_output.put_line('grant ALTER SESSION to hr;');
      dbms_output.put_line('grant UNLIMITED TABLESPACE to hr;');
      dbms_output.put_line('GRANT CREATE MATERIALIZED VIEW to hr;');
      dbms_output.put_line('GRANT CREATE PROCEDURE to hr;');
      dbms_output.put_line('GRANT CREATE SEQUENCE to hr;');
      dbms_output.put_line('GRANT CREATE SESSION to hr;');
      dbms_output.put_line('GRANT CREATE SYNONYM to hr;');
      dbms_output.put_line('GRANT CREATE TABLE to hr;');
      dbms_output.put_line('GRANT CREATE TRIGGER to hr;');
      dbms_output.put_line('GRANT CREATE TYPE to hr;');
      dbms_output.put_line('GRANT CREATE VIEW to hr;');
      dbms_output.put_line('alter session set current_schema = hr;');
   else      
      dbms_output.put_line('pro |');
      dbms_output.put_line('pro | The existing HR objects will now be dropped and the fresh objects created');
      dbms_output.put_line('pro | ');
      dbms_output.put_line('pro | The script will exit on any error encountered, because it should run');
      dbms_output.put_line('pro | to completion with no errors at all');
      dbms_output.put_line('pro | ');
      dbms_output.put_line('accept dummy prompt ''Press Enter to start''');
   end if;    
end;
/
spool off
set termout on
whenever sqlerror exit
@nonhr_create.sql


whenever sqlerror exit
set serverout on
declare
  l_cnt int;
begin
  if user = 'HR' then
    for iter in 1 .. 10 loop
      for i in ( select object_type, object_name
                 from   user_objects
                 order by decode(mod(iter,2),0,-1,1)*object_id
               )
      loop
        begin
          execute immediate 'drop '||i.object_type||' '||i.object_name||case when i.object_type = 'TABLE' then ' cascade constraints purge' end;
        exception
          when others then null;
        end;
      end loop;
      select count(*) 
      into   l_cnt
      from   user_objects;
      exit when l_cnt = 0;
    end loop;
    
    if l_cnt > 0 then
       dbms_output.put_line('---------------------------------------------------------');
       dbms_output.put_line('ERROR TEXT:');
       dbms_output.put_line('Something went wrong dropping the objects - it could be  ');
       dbms_output.put_line('that someone has an uncomitted transaction on one of the '); 
       dbms_output.put_line('tables which means we cannot drop it.'); 
       dbms_output.put_line('Please check on this and then re-run the install.');
       dbms_output.put_line('---------------------------------------------------------');
       raise_application_error(-20000,'Script exiting with error');
    end if;
  end if;
end;
/
whenever sqlerror continue


---------------




SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

rem ********************************************************************
rem Create the REGIONS table to hold region information for locations
rem HR.LOCATIONS table has a foreign key to this table.

Prompt ******  Creating REGIONS table ....

CREATE TABLE regions
    ( region_id      NUMBER 
       CONSTRAINT  region_id_nn NOT NULL 
    , region_name    VARCHAR2(25) 
    );

CREATE UNIQUE INDEX reg_id_pk
ON regions (region_id);

ALTER TABLE regions
ADD ( CONSTRAINT reg_id_pk
           PRIMARY KEY (region_id)
    ) ;

rem ********************************************************************
rem Create the COUNTRIES table to hold country information for customers
rem and company locations.
rem OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

CREATE TABLE countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR2(60) 
    , region_id       NUMBER 
    , CONSTRAINT     country_c_id_pk 
               PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 

ALTER TABLE countries
ADD ( CONSTRAINT countr_reg_fk
           FOREIGN KEY (region_id)
              REFERENCES regions(region_id) 
    ) ;

rem ********************************************************************
rem Create the LOCATIONS table to hold address information for company departments.
rem HR.DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

CREATE TABLE locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
  CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    ) ;

CREATE UNIQUE INDEX loc_id_pk
ON locations (location_id) ;

ALTER TABLE locations
ADD ( CONSTRAINT loc_id_pk
           PRIMARY KEY (location_id)
    , CONSTRAINT loc_c_id_fk
           FOREIGN KEY (country_id)
            REFERENCES countries(country_id) 
    ) ;

Rem   Useful for any subsequent addition of rows to locations table
Rem   Starts with 3300

CREATE SEQUENCE locations_seq
 START WITH     3300
 INCREMENT BY   100
 MAXVALUE       9900
 NOCACHE
 NOCYCLE;

rem ********************************************************************
rem Create the DEPARTMENTS table to hold company department information.
rem HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
  CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;

CREATE UNIQUE INDEX dept_id_pk
ON departments (department_id) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_id_pk
           PRIMARY KEY (department_id)
    , CONSTRAINT dept_loc_fk
           FOREIGN KEY (location_id)
            REFERENCES locations (location_id)
     ) ;

Rem   Useful for any subsequent addition of rows to departments table
Rem   Starts with 280 

CREATE SEQUENCE departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;

rem ********************************************************************
rem Create the JOBS table to hold the different names of job roles within the company.
rem HR.EMPLOYEES has a foreign key to this table.

Prompt ******  Creating JOBS table ....

CREATE TABLE jobs
    ( job_id         VARCHAR2(10)
    , job_title      VARCHAR2(35)
  CONSTRAINT     job_title_nn  NOT NULL
    , min_salary     NUMBER(6)
    , max_salary     NUMBER(6)
    ) ;

CREATE UNIQUE INDEX job_id_pk 
ON jobs (job_id) ;

ALTER TABLE jobs
ADD ( CONSTRAINT job_id_pk
           PRIMARY KEY(job_id)
    ) ;

rem ********************************************************************
rem Create the EMPLOYEES table to hold the employee personnel
rem information for the company.
rem HR.EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
   CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
  CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
  CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
  CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk
ON employees (employee_id) ;


ALTER TABLE employees
ADD ( CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES departments
    , CONSTRAINT     emp_job_fk
                     FOREIGN KEY (job_id)
                      REFERENCES jobs (job_id)
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees
    ) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
           FOREIGN KEY (manager_id)
            REFERENCES employees (employee_id)
    ) ;


Rem   Useful for any subsequent addition of rows to employees table
Rem   Starts with 207 


CREATE SEQUENCE employees_seq
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

rem ********************************************************************
rem Create the JOB_HISTORY table to hold the history of jobs that
rem employees have held in the past.
rem HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE job_history
    ( employee_id   NUMBER(6)
   CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
  CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
  CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
  CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date) ;

ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     jhist_job_fk
                     FOREIGN KEY (job_id)
                     REFERENCES jobs
    , CONSTRAINT     jhist_emp_fk
                     FOREIGN KEY (employee_id)
                     REFERENCES employees
    , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments
    ) ;

rem ********************************************************************
rem Create the EMP_DETAILS_VIEW that joins the employees, jobs,
rem departments, jobs, countries, and locations table to provide details
rem about employees.

Prompt ******  Creating EMP_DETAILS_VIEW view ...

CREATE OR REPLACE VIEW emp_details_view
  (employee_id,
   job_id,
   manager_id,
   department_id,
   location_id,
   country_id,
   first_name,
   last_name,
   salary,
   commission_pct,
   department_name,
   job_title,
   city,
   state_province,
   country_name,
   region_name)
AS SELECT
  e.employee_id, 
  e.job_id, 
  e.manager_id, 
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  employees e,
  departments d,
  jobs j,
  locations l,
  countries c,
  regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id 
WITH READ ONLY;

rem ********************************************************************
rem Create indexes

Prompt ******  Creating indexes ...

CREATE INDEX emp_department_ix
       ON employees (department_id);

CREATE INDEX emp_job_ix
       ON employees (job_id);

CREATE INDEX emp_manager_ix
       ON employees (manager_id);

CREATE INDEX emp_name_ix
       ON employees (last_name, first_name);

CREATE INDEX dept_location_ix
       ON departments (location_id);

CREATE INDEX jhist_job_ix
       ON job_history (job_id);

CREATE INDEX jhist_employee_ix
       ON job_history (employee_id);

CREATE INDEX jhist_department_ix
       ON job_history (department_id);

CREATE INDEX loc_city_ix
       ON locations (city);

CREATE INDEX loc_state_province_ix  
       ON locations (state_province);

CREATE INDEX loc_country_ix
       ON locations (country_id);


rem ********************************************************************
rem Add table column comments

Prompt ******  Adding table column comments ...

COMMENT ON TABLE regions 
IS 'Regions table that contains region numbers and names. references with the Countries table.';

COMMENT ON COLUMN regions.region_id
IS 'Primary key of regions table.';

COMMENT ON COLUMN regions.region_name
IS 'Names of regions. Locations are in the countries of these regions.';

COMMENT ON TABLE locations
IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. references with the departments and countries tables. ';

COMMENT ON COLUMN locations.location_id
IS 'Primary key of locations table';

COMMENT ON COLUMN locations.street_address
IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN locations.postal_code
IS 'Postal code of the location of an office, warehouse, or production site 
of a company. ';

COMMENT ON COLUMN locations.city
IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

COMMENT ON COLUMN locations.state_province
IS 'State or Province where an office, warehouse, or production site of a 
company is located.';

COMMENT ON COLUMN locations.country_id
IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';


rem *********************************************

COMMENT ON TABLE departments
IS 'Departments table that shows details of departments where employees 
work. references with locations, employees, and job_history tables.';

COMMENT ON COLUMN departments.department_id
IS 'Primary key column of departments table.';

COMMENT ON COLUMN departments.department_name
IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN departments.manager_id
IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN departments.location_id
IS 'Location id where a department is located. Foreign key to location_id column of locations table.';


rem *********************************************

COMMENT ON TABLE job_history
IS 'Table that stores job history of the employees. If an employee 
changes departments within the job or changes jobs within the department, 
new rows get inserted into this table with old job information of the 
employee. Contains a complex primary key: employee_id+start_date.
References with jobs, employees, and departments tables.';

COMMENT ON COLUMN job_history.employee_id
  IS 'A not null column in the complex primary key employee_id+start_date. 
Foreign key to employee_id column of the employee table';

COMMENT ON COLUMN job_history.start_date
  IS 'A not null column in the complex primary key employee_id+start_date. 
Must be less than the end_date of the job_history table. (enforced by 
constraint jhist_date_interval)';

COMMENT ON COLUMN job_history.end_date
  IS 'Last day of the employee in this job role. A not null column. Must be 
greater than the start_date of the job_history table. 
(enforced by constraint jhist_date_interval)';

COMMENT ON COLUMN job_history.job_id
  IS 'Job role in which the employee worked in the past; foreign key to 
job_id column in the jobs table. A not null column.';

COMMENT ON COLUMN job_history.department_id
  IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';

rem *********************************************

COMMENT ON TABLE countries
  IS 'country table. References with locations table.';

COMMENT ON COLUMN countries.country_id
  IS 'Primary key of countries table.';

COMMENT ON COLUMN countries.country_name
  IS 'Country name';

COMMENT ON COLUMN countries.region_id
  IS 'Region ID for the country. Foreign key to region_id column in the departments table.';

rem *********************************************

COMMENT ON TABLE jobs
  IS 'jobs table with job titles and salary ranges.
References with employees and job_history table.';

COMMENT ON COLUMN jobs.job_id
  IS 'Primary key of jobs table.';

COMMENT ON COLUMN jobs.job_title
  IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

COMMENT ON COLUMN jobs.min_salary
  IS 'Minimum salary for a job title.';

COMMENT ON COLUMN jobs.max_salary
  IS 'Maximum salary for a job title';

rem *********************************************

COMMENT ON TABLE employees
  IS 'employees table. References with departments,
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN employees.employee_id
  IS 'Primary key of employees table.';

COMMENT ON COLUMN employees.first_name
  IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN employees.last_name
  IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN employees.email
  IS 'Email id of the employee';

COMMENT ON COLUMN employees.phone_number
  IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN employees.hire_date
  IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN employees.job_id
  IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

COMMENT ON COLUMN employees.salary
  IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN employees.commission_pct
  IS 'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

COMMENT ON COLUMN employees.manager_id
  IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table. 
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN employees.department_id
  IS 'Department id where employee works; foreign key to department_id 
column of the departments table';

SET VERIFY OFF
ALTER SESSION SET NLS_LANGUAGE=American;

REM *************************** insert data into the REGIONS table

Prompt ****** Populating REGIONS table ....

BEGIN
  INSERT INTO regions VALUES
      ( 10
      , 'Europe'
      );

  INSERT INTO regions VALUES
      ( 20
      , 'Americas'
      );

  INSERT INTO regions VALUES
      ( 30
      , 'Asia'
      );

  INSERT INTO regions VALUES
      ( 40
      , 'Oceania'
      );

  INSERT INTO regions VALUES
      ( 50
      , 'Africa'
      );
END;
/

REM *************************** insert data into the COUNTRIES table

Prompt ****** Populating COUNTRIES table ....

BEGIN
  INSERT INTO countries VALUES
      ( 'IT'
      , 'Italy'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'JP'
      , 'Japan'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'US'
      , 'United States of America'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'CA'
      , 'Canada'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'CN'
      , 'China'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'IN'
      , 'India'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'AU'
      , 'Australia'
      , 40
      );

  INSERT INTO countries VALUES
      ( 'ZW'
      , 'Zimbabwe'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'SG'
      , 'Singapore'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'GB'
      , 'United Kingdom of Great Britain and Northern Ireland'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'FR'
      , 'France'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'DE'
      , 'Germany'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'ZM'
      , 'Zambia'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'EG'
      , 'Egypt'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'BR'
      , 'Brazil'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'CH'
      , 'Switzerland'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'NL'
      , 'Netherlands'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'MX'
      , 'Mexico'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'KW'
      , 'Kuwait'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'IL'
      , 'Israel'
      , 30
      );

  INSERT INTO countries VALUES
      ( 'DK'
      , 'Denmark'
      , 10
      );

  INSERT INTO countries VALUES
      ( 'ML'
      , 'Malaysia'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'NG'
      , 'Nigeria'
      , 50
      );

  INSERT INTO countries VALUES
      ( 'AR'
      , 'Argentina'
      , 20
      );

  INSERT INTO countries VALUES
      ( 'BE'
      , 'Belgium'
      , 10
      );
END;
/


REM *************************** insert data into the LOCATIONS table

Prompt ****** Populating LOCATIONS table ....

BEGIN
  INSERT INTO locations VALUES
      ( 1000
      , '1297 Via Cola di Rie'
      , '00989'
      , 'Roma'
      , NULL
      , 'IT'
      );

  INSERT INTO locations VALUES
      ( 1100
      , '93091 Calle della Testa'
      , '10934'
      , 'Venice'
      , NULL
      , 'IT'
      );

  INSERT INTO locations VALUES
      ( 1200
      , '2017 Shinjuku-ku'
      , '1689'
      , 'Tokyo'
      , 'Tokyo Prefecture'
      , 'JP'
      );

  INSERT INTO locations VALUES
      ( 1300
      , '9450 Kamiya-cho'
      , '6823'
      , 'Hiroshima'
      , NULL
      , 'JP'
      );

  INSERT INTO locations VALUES
      ( 1400
      , '2014 Jabberwocky Rd'
      , '26192'
      , 'Southlake'
      , 'Texas'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1500
      , '2011 Interiors Blvd'
      , '99236'
      , 'South San Francisco'
      , 'California'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1600
      , '2007 Zagora St'
      , '50090'
      , 'South Brunswick'
      , 'New Jersey'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1700
      , '2004 Charade Rd'
      , '98199'
      , 'Seattle'
      , 'Washington'
      , 'US'
      );

  INSERT INTO locations VALUES
      ( 1800
      , '147 Spadina Ave'
      , 'M5V 2L7'
      , 'Toronto'
      , 'Ontario'
      , 'CA'
      );

  INSERT INTO locations VALUES
      ( 1900
      , '6092 Boxwood St'
      , 'YSW 9T2'
      , 'Whitehorse'
      , 'Yukon'
      , 'CA'
      );

  INSERT INTO locations VALUES
      ( 2000
      , '40-5-12 Laogianggen'
      , '190518'
      , 'Beijing'
      , NULL
      , 'CN'
      );

  INSERT INTO locations VALUES
      ( 2100
      , '1298 Vileparle (E)'
      , '490231'
      , 'Bombay'
      , 'Maharashtra'
      , 'IN'
      );

  INSERT INTO locations VALUES
      ( 2200
      , '12-98 Victoria Street'
      , '2901'
      , 'Sydney'
      , 'New South Wales'
      , 'AU'
      );

  INSERT INTO locations VALUES
      ( 2300
      , '198 Clementi North'
      , '540198'
      , 'Singapore'
      , NULL
      , 'SG'
      );

  INSERT INTO locations VALUES
      ( 2400
      , '8204 Arthur St'
      , NULL
      , 'London'
      , NULL
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2500
      , 'Magdalen Centre, The Oxford Science Park'
      , 'OX9 9ZB'
      , 'Oxford'
      , 'Oxford'
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2600
      , '9702 Chester Road'
      , '09629850293'
      , 'Stretford'
      , 'Manchester'
      , 'GB'
      );

  INSERT INTO locations VALUES
      ( 2700
      , 'Schwanthalerstr. 7031'
      , '80925'
      , 'Munich'
      , 'Bavaria'
      , 'DE'
      );

  INSERT INTO locations VALUES
      ( 2800
      , 'Rua Frei Caneca 1360 '
      , '01307-002'
      , 'Sao Paulo'
      , 'Sao Paulo'
      , 'BR'
      );

  INSERT INTO locations VALUES
      ( 2900
      , '20 Rue des Corps-Saints'
      , '1730'
      , 'Geneva'
      , 'Geneve'
      , 'CH'
      );

  INSERT INTO locations VALUES
      ( 3000
      , 'Murtenstrasse 921'
      , '3095'
      , 'Bern'
      , 'BE'
      , 'CH'
      );

  INSERT INTO locations VALUES
      ( 3100
      , 'Pieter Breughelstraat 837'
      , '3029SK'
      , 'Utrecht'
      , 'Utrecht'
      , 'NL'
      );

  INSERT INTO locations VALUES
      ( 3200
      , 'Mariano Escobedo 9991'
      , '11932'
      , 'Mexico City'
      , 'Distrito Federal'
      , 'MX'
      );
END;
/


REM **************************** insert data into the DEPARTMENTS table

Prompt ****** Populating DEPARTMENTS table ....

REM disable integrity constraint to EMPLOYEES to load data

ALTER TABLE departments
  DISABLE CONSTRAINT dept_mgr_fk;

BEGIN
  INSERT INTO departments VALUES
      ( 10
      , 'Administration'
      , 200
      , 1700
      );

  INSERT INTO departments VALUES
      ( 20
      , 'Marketing'
      , 201
      , 1800
      );

  INSERT INTO departments VALUES
      ( 30
      , 'Purchasing'
      , 114
      , 1700
      );

  INSERT INTO departments VALUES
      ( 40
      , 'Human Resources'
      , 203
      , 2400
      );

  INSERT INTO departments VALUES
      ( 50
      , 'Shipping'
      , 121
      , 1500
      );

  INSERT INTO departments VALUES
      ( 60
      , 'IT'
      , 103
      , 1400
      );

  INSERT INTO departments VALUES
      ( 70
      , 'Public Relations'
      , 204
      , 2700
      );

  INSERT INTO departments VALUES
      ( 80
      , 'Sales'
      , 145
      , 2500
      );

  INSERT INTO departments VALUES
      ( 90
      , 'Executive'
      , 100
      , 1700
      );

  INSERT INTO departments VALUES
      ( 100
      , 'Finance'
      , 108
      , 1700
      );

  INSERT INTO departments VALUES
      ( 110
      , 'Accounting'
      , 205
      , 1700
      );

  INSERT INTO departments VALUES
      ( 120
      , 'Treasury'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 130
      , 'Corporate Tax'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 140
      , 'Control And Credit'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 150
      , 'Shareholder Services'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 160
      , 'Benefits'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 170
      , 'Manufacturing'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 180
      , 'Construction'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 190
      , 'Contracting'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 200
      , 'Operations'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 210
      , 'IT Support'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 220
      , 'NOC'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 230
      , 'IT Helpdesk'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 240
      , 'Government Sales'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 250
      , 'Retail Sales'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 260
      , 'Recruiting'
      , NULL
      , 1700
      );

  INSERT INTO departments VALUES
      ( 270
      , 'Payroll'
      , NULL
      , 1700
      );
END;
/

REM *************************** insert data into the JOBS table

Prompt ****** Populating JOBS table ....

BEGIN
  INSERT INTO jobs VALUES
      ( 'AD_PRES'
      , 'President'
      , 20080
      , 40000
      );
  INSERT INTO jobs VALUES
      ( 'AD_VP'
      , 'Administration Vice President'
      , 15000
      , 30000
      );

  INSERT INTO jobs VALUES
      ( 'AD_ASST'
      , 'Administration Assistant'
      , 3000
      , 6000
      );

  INSERT INTO jobs VALUES
      ( 'FI_MGR'
      , 'Finance Manager'
      , 8200
      , 16000
      );

  INSERT INTO jobs VALUES
      ( 'FI_ACCOUNT'
      , 'Accountant'
      , 4200
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'AC_MGR'
      , 'Accounting Manager'
      , 8200
      , 16000
      );

  INSERT INTO jobs VALUES
      ( 'AC_ACCOUNT'
      , 'Public Accountant'
      , 4200
      , 9000
      );
  INSERT INTO jobs VALUES
      ( 'SA_MAN'
      , 'Sales Manager'
      , 10000
      , 20080
      );

  INSERT INTO jobs VALUES
      ( 'SA_REP'
      , 'Sales Representative'
      , 6000
      , 12008
      );

  INSERT INTO jobs VALUES
      ( 'PU_MAN'
      , 'Purchasing Manager'
      , 8000
      , 15000
      );

  INSERT INTO jobs VALUES
      ( 'PU_CLERK'
      , 'Purchasing Clerk'
      , 2500
      , 5500
      );

  INSERT INTO jobs VALUES
      ( 'ST_MAN'
      , 'Stock Manager'
      , 5500
      , 8500
      );
  INSERT INTO jobs VALUES
      ( 'ST_CLERK'
      , 'Stock Clerk'
      , 2008
      , 5000
      );

  INSERT INTO jobs VALUES
      ( 'SH_CLERK'
      , 'Shipping Clerk'
      , 2500
      , 5500
      );

  INSERT INTO jobs VALUES
      ( 'IT_PROG'
      , 'Programmer'
      , 4000
      , 10000
      );

  INSERT INTO jobs VALUES
      ( 'MK_MAN'
      , 'Marketing Manager'
      , 9000
      , 15000
      );

  INSERT INTO jobs VALUES
      ( 'MK_REP'
      , 'Marketing Representative'
      , 4000
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'HR_REP'
      , 'Human Resources Representative'
      , 4000
      , 9000
      );

  INSERT INTO jobs VALUES
      ( 'PR_REP'
      , 'Public Relations Representative'
      , 4500
      , 10500
      );
END;
/


REM *************************** insert data into the EMPLOYEES table

Prompt ****** Populating EMPLOYEES table ....

BEGIN
  INSERT INTO employees VALUES
      ( 100
      , 'Steven'
      , 'King'
      , 'SKING'
      , '1.515.555.0100'
      , TO_DATE('17-06-2013', 'dd-MM-yyyy')
      , 'AD_PRES'
      , 24000
      , NULL
      , NULL
      , 90
      );

  INSERT INTO employees VALUES
      ( 101
      , 'Neena'
      , 'Yang'
      , 'NYANG'
      , '1.515.555.0101'
      , TO_DATE('21-09-2015', 'dd-MM-yyyy')
      , 'AD_VP'
      , 17000
      , NULL
      , 100
      , 90
      );

  INSERT INTO employees VALUES
      ( 102
      , 'Lex'
      , 'Garcia'
      , 'LGARCIA'
      , '1.515.555.0102'
      , TO_DATE('13-01-2011', 'dd-MM-yyyy')
      , 'AD_VP'
      , 17000
      , NULL
      , 100
      , 90
      );

  INSERT INTO employees VALUES
      ( 103
      , 'Alexander'
      , 'James'
      , 'AJAMES'
      , '1.590.555.0103'
      , TO_DATE('03-01-2016', 'dd-MM-yyyy')
      , 'IT_PROG'
      , 9000
      , NULL
      , 102
      , 60
      );

  INSERT INTO employees VALUES
      ( 104
      , 'Bruce'
      , 'Miller'
      , 'BMILLER'
      , '1.590.555.0104'
      , TO_DATE('21-05-2017', 'dd-MM-yyyy')
      , 'IT_PROG'
      , 6000
      , NULL
      , 103
      , 60
      );

  INSERT INTO employees VALUES
      ( 105
      , 'David'
      , 'Williams'
      , 'DWILLIAMS'
      , '1.590.555.0105'
      , TO_DATE('25-06-2015', 'dd-MM-yyyy')
      , 'IT_PROG'
      , 4800
      , NULL
      , 103
      , 60
      );

  INSERT INTO employees VALUES
      ( 106
      , 'Valli'
      , 'Jackson'
      , 'VJACKSON'
      , '1.590.555.0106'
      , TO_DATE('05-02-2016', 'dd-MM-yyyy')
      , 'IT_PROG'
      , 4800
      , NULL
      , 103
      , 60
      );

  INSERT INTO employees VALUES
      ( 107
      , 'Diana'
      , 'Nguyen'
      , 'DNGUYEN'
      , '1.590.555.0107'
      , TO_DATE('07-02-2017', 'dd-MM-yyyy')
      , 'IT_PROG'
      , 4200
      , NULL
      , 103
      , 60
      );

  INSERT INTO employees VALUES
      ( 108
      , 'Nancy'
      , 'Gruenberg'
      , 'NGRUENBE'
      , '1.515.555.0108'
      , TO_DATE('17-08-2012', 'dd-MM-yyyy')
      , 'FI_MGR'
      , 12008
      , NULL
      , 101
      , 100
      );

  INSERT INTO employees VALUES
      ( 109
      , 'Daniel'
      , 'Faviet'
      , 'DFAVIET'
      , '1.515.555.0109'
      , TO_DATE('16-08-2012', 'dd-MM-yyyy')
      , 'FI_ACCOUNT'
      , 9000
      , NULL
      , 108
      , 100
      );

  INSERT INTO employees VALUES
      ( 110
      , 'John'
      , 'Chen'
      , 'JCHEN'
      , '1.515.555.0110'
      , TO_DATE('28-09-2015', 'dd-MM-yyyy')
      , 'FI_ACCOUNT'
      , 8200
      , NULL
      , 108
      , 100
      );

  INSERT INTO employees VALUES
      ( 111
      , 'Ismael'
      , 'Sciarra'
      , 'ISCIARRA'
      , '1.515.555.0111'
      , TO_DATE('30-09-2015', 'dd-MM-yyyy')
      , 'FI_ACCOUNT'
      , 7700
      , NULL
      , 108
      , 100
      );

  INSERT INTO employees VALUES
      ( 112
      , 'Jose Manuel'
      , 'Urman'
      , 'JMURMAN'
      , '1.515.555.0112'
      , TO_DATE('07-03-2016', 'dd-MM-yyyy')
      , 'FI_ACCOUNT'
      , 7800
      , NULL
      , 108
      , 100
      );

  INSERT INTO employees VALUES
      ( 113
      , 'Luis'
      , 'Popp'
      , 'LPOPP'
      , '1.515.555.0113'
      , TO_DATE('07-12-2017', 'dd-MM-yyyy')
      , 'FI_ACCOUNT'
      , 6900
      , NULL
      , 108
      , 100
      );

  INSERT INTO employees VALUES
      ( 114
      , 'Den'
      , 'Li'
      , 'DLI'
      , '1.515.555.0114'
      , TO_DATE('07-12-2012', 'dd-MM-yyyy')
      , 'PU_MAN'
      , 11000
      , NULL
      , 100
      , 30
      );

  INSERT INTO employees VALUES
      ( 115
      , 'Alexander'
      , 'Khoo'
      , 'AKHOO'
      , '1.515.555.0115'
      , TO_DATE('18-05-2013', 'dd-MM-yyyy')
      , 'PU_CLERK'
      , 3100
      , NULL
      , 114
      , 30
      );

  INSERT INTO employees VALUES
      ( 116
      , 'Shelli'
      , 'Baida'
      , 'SBAIDA'
      , '1.515.555.0116'
      , TO_DATE('24-12-2015', 'dd-MM-yyyy')
      , 'PU_CLERK'
      , 2900
      , NULL
      , 114
      , 30
      );

  INSERT INTO employees VALUES
      ( 117
      , 'Sigal'
      , 'Tobias'
      , 'STOBIAS'
      , '1.515.555.0117'
      , TO_DATE('24-07-2015', 'dd-MM-yyyy')
      , 'PU_CLERK'
      , 2800
      , NULL
      , 114
      , 30
      );

  INSERT INTO employees VALUES
      ( 118
      , 'Guy'
      , 'Himuro'
      , 'GHIMURO'
      , '1.515.555.0118'
      , TO_DATE('15-11-2016', 'dd-MM-yyyy')
      , 'PU_CLERK'
      , 2600
      , NULL
      , 114
      , 30
      );

  INSERT INTO employees VALUES
      ( 119
      , 'Karen'
      , 'Colmenares'
      , 'KCOLMENA'
      , '1.515.555.0119'
      , TO_DATE('10-08-2017', 'dd-MM-yyyy')
      , 'PU_CLERK'
      , 2500
      , NULL
      , 114
      , 30
      );

  INSERT INTO employees VALUES
      ( 120
      , 'Matthew'
      , 'Weiss'
      , 'MWEISS'
      , '1.650.555.0120'
      , TO_DATE('18-07-2014', 'dd-MM-yyyy')
      , 'ST_MAN'
      , 8000
      , NULL
      , 100
      , 50
      );

  INSERT INTO employees VALUES
      ( 121
      , 'Adam'
      , 'Fripp'
      , 'AFRIPP'
      , '1.650.555.0121'
      , TO_DATE('10-04-2015', 'dd-MM-yyyy')
      , 'ST_MAN'
      , 8200
      , NULL
      , 100
      , 50
      );

  INSERT INTO employees VALUES
      ( 122
      , 'Payam'
      , 'Kaufling'
      , 'PKAUFLIN'
      , '1.650.555.0122'
      , TO_DATE('01-05-2013', 'dd-MM-yyyy')
      , 'ST_MAN'
      , 7900
      , NULL
      , 100
      , 50
      );

  INSERT INTO employees VALUES
      ( 123
      , 'Shanta'
      , 'Vollman'
      , 'SVOLLMAN'
      , '1.650.555.0123'
      , TO_DATE('10-10-2015', 'dd-MM-yyyy')
      , 'ST_MAN'
      , 6500
      , NULL
      , 100
      , 50
      );

  INSERT INTO employees VALUES
      ( 124
      , 'Kevin'
      , 'Mourgos'
      , 'KMOURGOS'
      , '1.650.555.0124'
      , TO_DATE('16-11-2017', 'dd-MM-yyyy')
      , 'ST_MAN'
      , 5800
      , NULL
      , 100
      , 50
      );

  INSERT INTO employees VALUES
      ( 125
      , 'Julia'
      , 'Nayer'
      , 'JNAYER'
      , '1.650.555.0125'
      , TO_DATE('16-07-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3200
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 126
      , 'Irene'
      , 'Mikkilineni'
      , 'IMIKKILI'
      , '1.650.555.0126'
      , TO_DATE('28-09-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2700
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 127
      , 'James'
      , 'Landry'
      , 'JLANDRY'
      , '1.650.555.0127'
      , TO_DATE('14-01-2017', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2400
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 128
      , 'Steven'
      , 'Markle'
      , 'SMARKLE'
      , '1.650.555.0128'
      , TO_DATE('08-03-2018', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2200
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 129
      , 'Laura'
      , 'Bissot'
      , 'LBISSOT'
      , '1.650.555.0129'
      , TO_DATE('20-08-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3300
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 130
      , 'Mozhe'
      , 'Atkinson'
      , 'MATKINSO'
      , '1.650.555.0130'
      , TO_DATE('30-10-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2800
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 131
      , 'James'
      , 'Marlow'
      , 'JAMRLOW'
      , '1.650.555.0131'
      , TO_DATE('16-02-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2500
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 132
      , 'TJ'
      , 'Olson'
      , 'TJOLSON'
      , '1.650.555.0132'
      , TO_DATE('10-04-2017', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2100
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 133
      , 'Jason'
      , 'Mallin'
      , 'JMALLIN'
      , '1.650.555.0133'
      , TO_DATE('14-06-2014', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3300
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 134
      , 'Michael'
      , 'Rogers'
      , 'MROGERS'
      , '1.650.555.0134'
      , TO_DATE('26-08-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2900
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 135
      , 'Ki'
      , 'Gee'
      , 'KGEE'
      , '1.650.555.0135'
      , TO_DATE('12-12-2017', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2400
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 136
      , 'Hazel'
      , 'Philtanker'
      , 'HPHILTAN'
      , '1.650.555.0136'
      , TO_DATE('06-02-2018', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2200
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 137
      , 'Renske'
      , 'Ladwig'
      , 'RLADWIG'
      , '1.650.555.0137'
      , TO_DATE('14-07-2013', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3600
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 138
      , 'Stephen'
      , 'Stiles'
      , 'SSTILES'
      , '1.650.555.0138'
      , TO_DATE('26-10-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3200
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 139
      , 'John'
      , 'Seo'
      , 'JSEO'
      , '1.650.555.0139'
      , TO_DATE('12-02-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2700
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 140
      , 'Joshua'
      , 'Patel'
      , 'JPATEL'
      , '1.650.555.0140'
      , TO_DATE('06-04-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2500
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 141
      , 'Trenna'
      , 'Rajs'
      , 'TRAJS'
      , '1.650.555.0141'
      , TO_DATE('17-10-2013', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3500
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 142
      , 'Curtis'
      , 'Davies'
      , 'CDAVIES'
      , '1.650.555.0142'
      , TO_DATE('29-01-2015', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 3100
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 143
      , 'Randall'
      , 'Matos'
      , 'RMATOS'
      , '1.650.555.0143'
      , TO_DATE('15-03-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2600
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 144
      , 'Peter'
      , 'Vargas'
      , 'PVARGAS'
      , '1.650.555.0144'
      , TO_DATE('09-07-2016', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 2500
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 145
      , 'John'
      , 'Singh'
      , 'JSINGH'
      , '44.1632.960000'
      , TO_DATE('01-10-2014', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 14000
      , .4
      , 100
      , 80
      );

  INSERT INTO employees VALUES
      ( 146
      , 'Karen'
      , 'Partners'
      , 'KPARTNER'
      , '44.1632.960001'
      , TO_DATE('05-01-2015', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 13500
      , .3
      , 100
      , 80
      );

  INSERT INTO employees VALUES
      ( 147
      , 'Alberto'
      , 'Errazuriz'
      , 'AERRAZUR'
      , '44.1632.960002'
      , TO_DATE('10-03-2015', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 12000
      , .3
      , 100
      , 80
      );

  INSERT INTO employees VALUES
      ( 148
      , 'Gerald'
      , 'Cambrault'
      , 'GCAMBRAU'
      , '44.1632.960003'
      , TO_DATE('15-10-2017', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 11000
      , .3
      , 100
      , 80
      );

  INSERT INTO employees VALUES
      ( 149
      , 'Eleni'
      , 'Zlotkey'
      , 'EZLOTKEY'
      , '44.1632.960004'
      , TO_DATE('29-01-2018', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 10500
      , .2
      , 100
      , 80
      );

  INSERT INTO employees VALUES
      ( 150
      , 'Sean'
      , 'Tucker'
      , 'STUCKER'
      , '44.1632.960005'
      , TO_DATE('30-01-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 10000
      , .3
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 151
      , 'David'
      , 'Bernstein'
      , 'DBERNSTE'
      , '44.1632.960006'
      , TO_DATE('24-03-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9500
      , .25
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 152
      , 'Peter'
      , 'Hall'
      , 'PHALL'
      , '44.1632.960007'
      , TO_DATE('20-08-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9000
      , .25
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 153
      , 'Christopher'
      , 'Olsen'
      , 'COLSEN'
      , '44.1632.960008'
      , TO_DATE('30-03-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 8000
      , .2
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 154
      , 'Nanette'
      , 'Cambrault'
      , 'NCAMBRAU'
      , '44.1632.960009'
      , TO_DATE('09-12-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7500
      , .2
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 155
      , 'Oliver'
      , 'Tuvault'
      , 'OTUVAULT'
      , '44.1632.960010'
      , TO_DATE('23-11-2017', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7000
      , .15
      , 145
      , 80
      );

  INSERT INTO employees VALUES
      ( 156
      , 'Janette'
      , 'King'
      , 'JKING'
      , '44.1632.960011'
      , TO_DATE('30-01-2014', 'dd-MM-yyyy')
      , 'SA_REP'
      , 10000
      , .35
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 157
      , 'Patrick'
      , 'Sully'
      , 'PSULLY'
      , '44.1632.960012'
      , TO_DATE('04-03-2014', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9500
      , .35
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 158
      , 'Allan'
      , 'McEwen'
      , 'AMCEWEN'
      , '44.1632.960013'
      , TO_DATE('01-08-2014', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9000
      , .35
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 159
      , 'Lindsey'
      , 'Smith'
      , 'LSMITH'
      , '44.1632.960014'
      , TO_DATE('10-03-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 8000
      , .3
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 160
      , 'Louise'
      , 'Doran'
      , 'LDORAN'
      , '44.1632.960015'
      , TO_DATE('15-12-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7500
      , .3
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 161
      , 'Sarath'
      , 'Sewall'
      , 'SSEWALL'
      , '44.1632.960016'
      , TO_DATE('03-11-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7000
      , .25
      , 146
      , 80
      );

  INSERT INTO employees VALUES
      ( 162
      , 'Clara'
      , 'Vishney'
      , 'CVISHNEY'
      , '44.1632.960017'
      , TO_DATE('11-11-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 10500
      , .25
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 163
      , 'Danielle'
      , 'Greene'
      , 'DGREENE'
      , '44.1632.960018'
      , TO_DATE('19-03-2017', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9500
      , .15
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 164
      , 'Mattea'
      , 'Marvins'
      , 'MMARVINS'
      , '44.1632.960019'
      , TO_DATE('24-01-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7200
      , .10
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 165
      , 'David'
      , 'Lee'
      , 'DLEE'
      , '44.1632.960020'
      , TO_DATE('23-02-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 6800
      , .1
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 166
      , 'Sundar'
      , 'Ande'
      , 'SANDE'
      , '44.1632.960021'
      , TO_DATE('24-03-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 6400
      , .10
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 167
      , 'Amit'
      , 'Banda'
      , 'ABANDA'
      , '44.1632.960022'
      , TO_DATE('21-04-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 6200
      , .10
      , 147
      , 80
      );

  INSERT INTO employees VALUES
      ( 168
      , 'Lisa'
      , 'Ozer'
      , 'LOZER'
      , '44.1632.960023'
      , TO_DATE('11-03-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 11500
      , .25
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 169
      , 'Harrison'
      , 'Bloom'
      , 'HBLOOM'
      , '44.1632.960024'
      , TO_DATE('23-03-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 10000
      , .20
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 170
      , 'Tayler'
      , 'Fox'
      , 'TFOX'
      , '44.1632.960025'
      , TO_DATE('24-01-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 9600
      , .20
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 171
      , 'William'
      , 'Smith'
      , 'WSMITH'
      , '44.1632.960026'
      , TO_DATE('23-02-2017', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7400
      , .15
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 172
      , 'Elizabeth'
      , 'Bates'
      , 'EBATES'
      , '44.1632.960027'
      , TO_DATE('24-03-2017', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7300
      , .15
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 173
      , 'Sundita'
      , 'Kumar'
      , 'SKUMAR'
      , '44.1632.960028'
      , TO_DATE('21-04-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 6100
      , .10
      , 148
      , 80
      );

  INSERT INTO employees VALUES
      ( 174
      , 'Ellen'
      , 'Abel'
      , 'EABEL'
      , '44.1632.960029'
      , TO_DATE('11-05-2014', 'dd-MM-yyyy')
      , 'SA_REP'
      , 11000
      , .30
      , 149
      , 80
      );

  INSERT INTO employees VALUES
      ( 175
      , 'Alyssa'
      , 'Hutton'
      , 'AHUTTON'
      , '44.1632.960030'
      , TO_DATE('19-03-2015', 'dd-MM-yyyy')
      , 'SA_REP'
      , 8800
      , .25
      , 149
      , 80
      );

  INSERT INTO employees VALUES
      ( 176
      , 'Jonathon'
      , 'Taylor'
      , 'JTAYLOR'
      , '44.1632.960031'
      , TO_DATE('24-03-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 8600
      , .20
      , 149
      , 80
      );

  INSERT INTO employees VALUES
      ( 177
      , 'Jack'
      , 'Livingston'
      , 'JLIVINGS'
      , '44.1632.960032'
      , TO_DATE('23-04-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 8400
      , .20
      , 149
      , 80
      );

  INSERT INTO employees VALUES
      ( 178
      , 'Kimberely'
      , 'Grant'
      , 'KGRANT'
      , '44.1632.960033'
      , TO_DATE('24-05-2017', 'dd-MM-yyyy')
      , 'SA_REP'
      , 7000
      , .15
      , 149
      , NULL
      );

  INSERT INTO employees VALUES
      ( 179
      , 'Charles'
      , 'Johnson'
      , 'CJOHNSON'
      , '44.1632.960034'
      , TO_DATE('04-01-2018', 'dd-MM-yyyy')
      , 'SA_REP'
      , 6200
      , .10
      , 149
      , 80
      );

  INSERT INTO employees VALUES
      ( 180
      , 'Winston'
      , 'Taylor'
      , 'WTAYLOR'
      , '1.650.555.0145'
      , TO_DATE('24-01-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3200
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 181
      , 'Jean'
      , 'Fleaur'
      , 'JFLEAUR'
      , '1.650.555.0146'
      , TO_DATE('23-02-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3100
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 182
      , 'Martha'
      , 'Sullivan'
      , 'MSULLIVA'
      , '1.650.555.0147'
      , TO_DATE('21-06-2017', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2500
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 183
      , 'Girard'
      , 'Geoni'
      , 'GGEONI'
      , '1.650.555.0148'
      , TO_DATE('03-02-2018', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2800
      , NULL
      , 120
      , 50
      );

  INSERT INTO employees VALUES
      ( 184
      , 'Nandita'
      , 'Sarchand'
      , 'NSARCHAN'
      , '1.650.555.0149'
      , TO_DATE('27-01-2014', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 4200
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 185
      , 'Alexis'
      , 'Bull'
      , 'ABULL'
      , '1.650.555.0150'
      , TO_DATE('20-02-2015', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 4100
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 186
      , 'Julia'
      , 'Dellinger'
      , 'JDELLING'
      , '1.650.555.0151'
      , TO_DATE('24-06-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3400
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 187
      , 'Anthony'
      , 'Cabrio'
      , 'ACABRIO'
      , '1.650.555.0152'
      , TO_DATE('07-02-2017', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3000
      , NULL
      , 121
      , 50
      );

  INSERT INTO employees VALUES
      ( 188
      , 'Kelly'
      , 'Chung'
      , 'KCHUNG'
      , '1.650.555.0153'
      , TO_DATE('14-06-2015', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3800
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 189
      , 'Jennifer'
      , 'Dilly'
      , 'JDILLY'
      , '1.650.555.0154'
      , TO_DATE('13-08-2015', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3600
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 190
      , 'Timothy'
      , 'Venzl'
      , 'TVENZL'
      , '1.650.555.0155'
      , TO_DATE('11-07-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2900
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 191
      , 'Randall'
      , 'Perkins'
      , 'RPERKINS'
      , '1.650.555.0156'
      , TO_DATE('19-12-2017', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2500
      , NULL
      , 122
      , 50
      );

  INSERT INTO employees VALUES
      ( 192
      , 'Sarah'
      , 'Bell'
      , 'SBELL'
      , '1.650.555.0157'
      , TO_DATE('04-02-2014', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 4000
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 193
      , 'Britney'
      , 'Everett'
      , 'BEVERETT'
      , '1.650.555.0158'
      , TO_DATE('03-03-2015', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3900
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 194
      , 'Samuel'
      , 'McLeod'
      , 'SMCLEOD'
      , '1.650.555.0159'
      , TO_DATE('01-07-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3200
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 195
      , 'Vance'
      , 'Jones'
      , 'VJONES'
      , '1.650.555.0160'
      , TO_DATE('17-03-2017', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2800
      , NULL
      , 123
      , 50
      );

  INSERT INTO employees VALUES
      ( 196
      , 'Alana'
      , 'Walsh'
      , 'AWALSH'
      , '1.650.555.0161'
      , TO_DATE('24-04-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3100
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 197
      , 'Kevin'
      , 'Feeney'
      , 'KFEENEY'
      , '1.650.555.0162'
      , TO_DATE('23-05-2016', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 3000
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 198
      , 'Donald'
      , 'OConnell'
      , 'DOCONNEL'
      , '1.650.555.0163'
      , TO_DATE('21-06-2017', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2600
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 199
      , 'Douglas'
      , 'Grant'
      , 'DGRANT'
      , '1.650.555.0164'
      , TO_DATE('13-01-2018', 'dd-MM-yyyy')
      , 'SH_CLERK'
      , 2600
      , NULL
      , 124
      , 50
      );

  INSERT INTO employees VALUES
      ( 200
      , 'Jennifer'
      , 'Whalen'
      , 'JWHALEN'
      , '1.515.555.0165'
      , TO_DATE('17-09-2013', 'dd-MM-yyyy')
      , 'AD_ASST'
      , 4400
      , NULL
      , 101
      , 10
      );

  INSERT INTO employees VALUES
      ( 201
      , 'Michael'
      , 'Martinez'
      , 'MMARTINE'
      , '1.515.555.0166'
      , TO_DATE('17-02-2014', 'dd-MM-yyyy')
      , 'MK_MAN'
      , 13000
      , NULL
      , 100
      , 20
      );

  INSERT INTO employees VALUES
      ( 202
      , 'Pat'
      , 'Davis'
      , 'PDAVIS'
      , '1.603.555.0167'
      , TO_DATE('17-08-2015', 'dd-MM-yyyy')
      , 'MK_REP'
      , 6000
      , NULL
      , 201
      , 20
      );

  INSERT INTO employees VALUES
      ( 203
      , 'Susan'
      , 'Jacobs'
      , 'SJACOBS'
      , '1.515.555.0168'
      , TO_DATE('07-06-2012', 'dd-MM-yyyy')
      , 'HR_REP'
      , 6500
      , NULL
      , 101
      , 40
      );

  INSERT INTO employees VALUES
      ( 204
      , 'Hermann'
      , 'Brown'
      , 'HBROWN'
      , '1.515.555.0169'
      , TO_DATE('07-06-2012', 'dd-MM-yyyy')
      , 'PR_REP'
      , 10000
      , NULL
      , 101
      , 70
      );

  INSERT INTO employees VALUES
      ( 205
      , 'Shelley'
      , 'Higgins'
      , 'SHIGGINS'
      , '1.515.555.0170'
      , TO_DATE('07-06-2012', 'dd-MM-yyyy')
      , 'AC_MGR'
      , 12008
      , NULL
      , 101
      , 110
      );

  INSERT INTO employees VALUES
      ( 206
      , 'William'
      , 'Gietz'
      , 'WGIETZ'
      , '1.515.555.0171'
      , TO_DATE('07-06-2012', 'dd-MM-yyyy')
      , 'AC_ACCOUNT'
      , 8300
      , NULL
      , 205
      , 110
      );
END;
/

REM ********* insert data into the JOB_HISTORY table

Prompt ****** Populating JOB_HISTORY table ....

BEGIN
  INSERT INTO job_history
  VALUES (102
       , TO_DATE('13-01-2011', 'dd-MM-yyyy')
       , TO_DATE('24-07-2016', 'dd-MM-yyyy')
       , 'IT_PROG'
       , 60);

  INSERT INTO job_history
  VALUES (101
       , TO_DATE('21-09-2007', 'dd-MM-yyyy')
       , TO_DATE('27-10-2011', 'dd-MM-yyyy')
       , 'AC_ACCOUNT'
       , 110);

  INSERT INTO job_history
  VALUES (101
       , TO_DATE('28-10-2011', 'dd-MM-yyyy')
       , TO_DATE('15-03-2015', 'dd-MM-yyyy')
       , 'AC_MGR'
       , 110);

  INSERT INTO job_history
  VALUES (201
       , TO_DATE('17-02-2014', 'dd-MM-yyyy')
       , TO_DATE('19-12-2017', 'dd-MM-yyyy')
       , 'MK_REP'
       , 20);

  INSERT INTO job_history
  VALUES  (114
      , TO_DATE('24-03-2016', 'dd-MM-yyyy')
      , TO_DATE('31-12-2017', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 50
      );

  INSERT INTO job_history
  VALUES  (122
      , TO_DATE('01-01-2017', 'dd-MM-yyyy')
      , TO_DATE('31-12-2017', 'dd-MM-yyyy')
      , 'ST_CLERK'
      , 50
      );

  INSERT INTO job_history
  VALUES  (200
      , TO_DATE('17-09-2005', 'dd-MM-yyyy')
      , TO_DATE('17-06-2011', 'dd-MM-yyyy')
      , 'AD_ASST'
      , 90
      );

  INSERT INTO job_history
  VALUES  (176
      , TO_DATE('24-03-2016', 'dd-MM-yyyy')
      , TO_DATE('31-12-2016', 'dd-MM-yyyy')
      , 'SA_REP'
      , 80
      );

  INSERT INTO job_history
  VALUES  (176
      , TO_DATE('01-01-2017', 'dd-MM-yyyy')
      , TO_DATE('31-12-2017', 'dd-MM-yyyy')
      , 'SA_MAN'
      , 80
      );

  INSERT INTO job_history
  VALUES  (200
      , TO_DATE('01-07-2012', 'dd-MM-yyyy')
      , TO_DATE('31-12-2016', 'dd-MM-yyyy')
      , 'AC_ACCOUNT'
      , 90
      );
END;
/

COMMIT;

REM enable integrity constraint to DEPARTMENTS

ALTER TABLE departments
  ENABLE CONSTRAINT dept_mgr_fk;

-------------------------------------------------------------------

rem --------------------------------------------------------------------------


SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

REM **************************************************************************

REM procedure and statement trigger to allow dmls during business hours:
CREATE OR REPLACE PROCEDURE secure_dml
IS
BEGIN
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
        OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
  RAISE_APPLICATION_ERROR (-20205, 
    'You may only make changes during normal office hours');
  END IF;
END secure_dml;
/

CREATE OR REPLACE TRIGGER secure_employees
  BEFORE INSERT OR UPDATE OR DELETE ON employees
BEGIN
  secure_dml;
END secure_employees;
/

ALTER TRIGGER secure_employees DISABLE;

REM **************************************************************************
REM procedure to add a row to the JOB_HISTORY table and row trigger 
REM to call the procedure when data is updated in the job_id or 
REM department_id columns in the EMPLOYEES table:

CREATE OR REPLACE PROCEDURE add_job_history
  (  p_emp_id          job_history.employee_id%type
   , p_start_date      job_history.start_date%type
   , p_end_date        job_history.end_date%type
   , p_job_id          job_history.job_id%type
   , p_department_id   job_history.department_id%type 
   )
IS
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date, 
                           job_id, department_id)
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;
/

CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate, 
                  :old.job_id, :old.department_id);
END;
/

COMMIT;

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

EXECUTE dbms_stats.gather_schema_stats('HR',granularity => 'ALL',cascade => TRUE);

set lines 100
set pages 99
col object_name format a40
col object_type format a40
select object_name, object_type
from   all_objects
where  owner = 'HR'
order by object_type, object_name;

pro **** INSTALLATION COMPLETE ****

whenever sqlerror continue

