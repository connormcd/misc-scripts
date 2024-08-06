REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM You'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

define ADMIN_USER=clone_util
define ADMIN_PASS=my_random_password
--define CONNECT=mydb
define CONNECT=pdb21a
define LOGFILE_DIR=DATA_PUMP_DIR

create user &&ADMIN_USER identified by &&ADMIN_PASS;
alter user &&ADMIN_USER quota 100m on users;

--
-- for on prem the roles are different
--

grant 
  drop user,
  create table,
  create session,
  PDB_DBA,     -- possibly overkill, depends on import objects needed
  DATAPUMP_EXP_FULL_DATABASE,
  DATAPUMP_IMP_FULL_DATABASE
to &&ADMIN_USER;

--
-- cloud
--
grant 
  drop user,
  create table,
  create session,
  PDB_DBA,     -- possibly overkill, depends on import objects needed
  DATAPUMP_CLOUD_EXP,
  DATAPUMP_CLOUD_IMP
to &&ADMIN_USER;


grant read, write on directory &&LOGFILE_DIR to &&ADMIN_USER;

-- =======================================================================
--
-- Now build the utility in the BROOM schema
--
connect &&ADMIN_USER/&&ADMIN_PASS@&&CONNECT

drop table schema_util_log purge;

create table schema_util_log
( tstamp timestamp default on null localtimestamp not null,
  job    varchar2(60),
  msg    varchar2(4000)
);  

create or replace
package schema_util AUTHID CURRENT_USER is

  procedure sanity_check;

  procedure clone(
              p_old varchar2, 
              p_new varchar2, 
              p_drop_new boolean default true,
              p_asynch boolean default false);
              
  procedure clone_status(p_job varchar2,p_log_file varchar2);
  
end;
/

create or replace
package body schema_util is

procedure info(m varchar2,j varchar2) is
  pragma autonomous_transaction;
begin
  dbms_application_info.set_client_info(m);
  dbms_output.put_line(m);
  insert into schema_util_log (msg,job) values (m,j);
  commit;
end;

procedure sanity_check is
  l_role_count   int;
  l_file utl_file.file_type;
  l_quota int;
begin
  execute immediate 'set role all';
  select count(*) 
  into l_role_count 
  from session_roles 
  where ( sys_context('USERENV','SERVICE_NAME') like '%oraclecloud%' and ( role in ('DATAPUMP_CLOUD_EXP','DATAPUMP_CLOUD_IMP') ) )
   or ( sys_context('USERENV','SERVICE_NAME') not like '%oraclecloud%' and ( role in ('DATAPUMP_EXP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE') ) )    ;
  
  if l_role_count != 2 then
    if sys_context('USERENV','SERVICE_NAME') like '%oraclecloud%' then
      raise_application_error(-20999,'Roles DATAPUMP_CLOUD_EXP, DATAPUMP_CLOUD_IMP must be granted to this user');
    else
      raise_application_error(-20999,'Roles DATAPUMP_EXP_FULL_DATABASE, DATAPUMP_IMP_FULL_DATABASE must be granted to this user');
    end if;
  end if;

  select count(*) 
  into l_role_count 
  from session_privs
  where privilege in ('CREATE TABLE','DROP USER');
  
  if l_role_count != 2 then
    raise_application_error(-20999,'CREATE TABLE and DROP USER privileges must be granted to this user');
  end if;

  begin
    select max_bytes
    into   l_quota
    from   user_ts_quotas ts,
           user_users u
    where  u.default_tablespace = ts.tablespace_name;     
    if nvl(l_quota,0) between 0 and 50*1024*1024 then
      raise_application_error(-20999,'Insufficent quota on default tablespace for this user account, please increase to 50M or more');
    end if;
  exception
    when no_data_found then
      raise_application_error(-20999,'Insufficent quota on default tablespace for this user account, please increase to 50M or more');
  end;
  
  begin
    l_file := utl_file.fopen ('&&LOGFILE_DIR', 'tmp_sanity_check.txt', 'w');
    utl_file.put_line(l_file, 'test write');
    utl_file.fclose(l_file);
    utl_file.fremove('&&LOGFILE_DIR', 'tmp_sanity_check.txt');
  exception
    when others then
       raise_application_error(-20999,'Could not successfully do a file write test to directory &&LOGFILE_DIR, check READ,WRITE privs');
  end;
end;

procedure clone(
              p_old varchar2, 
              p_new varchar2, 
              p_drop_new boolean default true,
              p_asynch boolean default false
              )  is
  l_handle       number;
  l_status       ku$_status; 
  l_state        varchar2(30);
  l_link         varchar2(128);
  l_job_name     varchar2(128) := upper(p_old)||'_SCHEMA_IMP_'||to_char(sysdate,'YYYYMMDDHH24MISS');
  l_log_file     varchar2(128) := lower(p_old)||'_import_'||to_char(sysdate,'YYYYMMDDHH24MISS')||'.log';
  l_default_dir  varchar2(128) := '&&LOGFILE_DIR';
  rc             sys_refcursor;
  l_msg          varchar2(4000);
BEGIN
  info('Clone task called by '||user,l_job_name);
  
  info('Performing sanity checks',l_job_name);
  sanity_check;
  
  if p_drop_new then
    begin
      info('Dropping schema '||p_new,l_job_name);
      --
      -- you might want to add some rules here about what users can be dropped etc
      --
      execute immediate 'drop user '||p_new||' cascade';
    exception
      when others then
        if sqlcode != -1918 then raise; end if;
    end;
  end if;
  select global_name into l_link from global_name;
  
  info('This job is: '||l_job_name,l_job_name);
  info('Log file is: '||l_log_file,l_job_name);

  l_handle := dbms_datapump.open(
    operation   => 'IMPORT',
    job_mode    => 'SCHEMA',
    remote_link => l_link,
    job_name    => l_job_name);

  dbms_datapump.add_file(
    handle    => l_handle,
    filename  => l_log_file,
    directory => l_default_dir,
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);

  dbms_datapump.metadata_filter(
    handle => l_handle,
    name   => 'SCHEMA_EXPR',
    value  => '= '''||p_old||'''');

  dbms_datapump.metadata_remap(
    handle    => l_handle,
    name      => 'REMAP_SCHEMA',
    old_value => p_old,
    value     => p_new);

  info('Starting job',l_job_name);
  dbms_datapump.start_job(l_handle);

  if p_asynch then
    info('Job submitted, use SCHEMA_UTIL.CLONE_STATUS('''||l_job_name||''','''||l_log_file||''') to check on job',l_job_name);
  else
    loop
      begin
        dbms_session.sleep(5);
        dbms_datapump.get_status(
          handle    => l_handle,
          mask      => dbms_datapump.ku$_status_job_status,
          job_state => l_state,
          status    => l_status);
          info(to_char(sysdate,'HH24:MI:SS')||':Job state ='||l_state,l_job_name);
      exception
        when others then
          if sqlcode = -31626 then
             l_state := 'COMPLETED';
          else
             raise;
          end if;
      end;
      exit when (l_state = 'COMPLETED') or (l_state = 'STOPPED');
    end loop;
    info('Job completed, final state:'||l_state,l_job_name);
  end if;
   
  dbms_datapump.detach(l_handle);

  if not p_asynch then
    -- give the logfile a few seconds to be flushed
    dbms_session.sleep(5);
    open rc for 'select col from external ( ( col varchar2(4000) )
                 type oracle_loader default directory &&LOGFILE_DIR
                 access parameters ( records delimited by newline nobadfile nologfile nodiscardfile )
                 location ( '''||l_log_file||''' ) reject limit unlimited ) ext';
    loop
      fetch rc into l_msg;
      exit when rc%notfound;
      info(l_msg,l_job_name);
    end loop;
    close rc;
  end if;
    
end;

procedure clone_status(p_job varchar2,p_log_file varchar2) is
  l_handle       number;
  l_status       ku$_status; 
  l_state        varchar2(30);
  l_default_dir  varchar2(128) := '&&LOGFILE_DIR';
  rc             sys_refcursor;
  l_msg          varchar2(4000);

begin
  info('Attaching to job',p_job);
  begin
    l_handle := dbms_datapump.attach(p_job);

      dbms_datapump.get_status(
        handle    => l_handle,
        mask      => dbms_datapump.ku$_status_job_status,
        job_state => l_state,
        status    => l_status);
        info('Current job state ='||l_state,p_job);
  exception
    when others then
      if sqlcode = -31626 then
         info('Job no longer found, so presumed completed',p_job);
      else
         raise;
      end if;
  end;

  info('Logfile contents:',p_job);
  open rc for 'select col from external ( ( col varchar2(4000) )
               type oracle_loader default directory &&LOGFILE_DIR
               access parameters ( records delimited by newline nobadfile nologfile nodiscardfile )
               location ( '''||p_log_file||''' ) reject limit unlimited ) ext';
  loop
    fetch rc into l_msg;
    exit when rc%notfound;
    info(l_msg,p_job);
  end loop;
  close rc;
  
end;

end;
/
sho err

-- ====================================================================
--
-- Examples of use
--
-- set serverout on
-- exec schema_util.clone('SCOTT','SCOTT2',p_asynch=>false)
-- 
-- set serverout on
-- exec schema_util.CLONE_STATUS('SCOTT_SCHEMA_IMP_20240805023122','scott_import_20240805023122.log')
-- 



