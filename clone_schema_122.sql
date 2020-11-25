REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 


-- PLSQL api to clone a schema, for Oracle Database 18c

-- Note: If you want to run this on a version of the database below 18c, 
-- you can simply break the dynamic external table alteration into an ALTER statement to change the location, 
-- and then just query the external table as per normal. All of the rest of the code should work without alteration.

--
-- if you want to allow the drop user option, then the 
-- the owning schema will need the following privilege
--
-- Needless to say, you might want to wrap this within a procedure
-- within its own rights to ensure people don't drop the WRONG user
--
-- For example:
--
-- create or replace
-- procedure customised_drop_user(p_user varchar2) is
-- begin
--   if .... then
--      execute immediate 'drop user '||p_user||' cascade';
--   else
--      raise_application_error(-20000,'What the hell?!?!?');
--   end if;
-- end;
--

--
-- change MY_USER to the appropriate name for your database
--
grant drop user to MY_USER;

drop table MY_USER.datapump_clone_log;

--
-- the initial file in the definition (dummy.log) must
-- exist, and the directory you are using (TEMP) must match
-- the declaration in the PLSQL proc which follows
--
create table MY_USER.datapump_clone_log (
     msg varchar2(4000)
)
organization external
( type oracle_loader
  default directory TEMP
  access parameters
  ( records delimited by newline
    fields terminated by ','
    missing field values are null
   ( msg )
   )
   location ('dummy.log')
) reject limit unlimited;

--
-- p_old    = existing schema
-- p_new    = target schema
-- p_drop   = whether we drop the target schema first
-- p_asynch = whether we wait or simply launch the import and return
--
-- I'd recommend p_asynch as false, because in that way, you'll get the
-- import log returned right back to your screen
--
create or replace
procedure MY_USER.clone_schema(
              p_old varchar2, 
              p_new varchar2, 
              p_drop_new boolean default true,
              p_asynch boolean default false
              ) is
  l_handle       number;
  l_status       ku$_status; 
  l_state        varchar2(30);
  l_link         varchar2(128);
  l_job_name     varchar2(128) := upper(p_old)||'_SCHEMA_IMP';
  l_log_file     varchar2(128) := lower(p_old)||'_import.log';
  l_default_dir  varchar2(128) := 'TEMP';
  rc             sys_refcursor;
  l_msg          varchar2(4000);
  
  procedure info(m varchar2,p_dbms_out boolean default false) is
  begin
    dbms_application_info.set_client_info(to_char(sysdate,'hh24miss')||':'||m);
    if p_dbms_out then
      dbms_output.put_line(to_char(sysdate,'hh24miss')||':'||m);
    end if;
  end;
BEGIN
  if p_drop_new then
    begin
      info('Dropping '||p_new,p_dbms_out=>true);
      --
      -- See notes about potentially wrapping this for safety
      --
      execute immediate 'drop user '||p_new||' cascade';
    exception
      when others then
        if sqlcode != -1918 then raise; end if;
    end;
  end if;
  select global_name into l_link from global_name;
  
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

  info('Starting job',p_dbms_out=>true);
  dbms_datapump.start_job(l_handle);

  if not p_asynch then
    loop
      begin
        dbms_lock.sleep(3);
        dbms_datapump.get_status(
          handle    => l_handle,
          mask      => dbms_datapump.ku$_status_job_status,
          job_state => l_state,
          status    => l_status);
          info('l_state='||l_state);
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
    info('Final state:'||l_state,p_dbms_out=>true);
  end if;
   
  dbms_datapump.detach(l_handle);

  if not p_asynch then
    execute immediate 'alter table datapump_clone_log location ( '''||l_log_file||''' )';
    open rc for 'select msg from datapump_clone_log';
    loop
      fetch rc into l_msg;
      exit when rc%notfound;
      dbms_output.put_line(l_msg);
    end loop;
    close rc;
  end if;
    
end;
/
sho err

--
-- sample use
--
-- set serverout on
-- exec MY_USER.clone_schema('SCOTT','SCOTT2');
