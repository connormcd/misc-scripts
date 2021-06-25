create or replace
procedure dmpfile_to_script(
                    p_dumpfile varchar2,
                    p_dumpdir  varchar2,
                    p_jobname  varchar2,
                    p_schema   varchar2,
                    p_new_schema varchar2 default null) is
  
  l_jobid     number;
  l_job_state varchar2(30);
  l_sts       ku$_Status;
 
  --
  -- list of object types we'd allow from the dump
  --
  l_obj_nt    sys.odcivarchar2list :=
                 sys.odcivarchar2list(
                    'ANALYTIC_VIEW',
                    'ATTRIBUTE_DIMENSION',
                    'CLUSTER',
                    'DIMENSION',
                    'FUNCTION',
                    'HIERARCHY',
                    'MATERIALIZED_VIEW',
                    'PACKAGE',
                    'PROCEDURE',
                    'REFRESH_GROUP',
                    'SEQUENCE',
                    'TABLE',
                    'TYPE',
                    'VIEW');
 
  l_obj_types varchar2(4000);
begin
  l_jobid := dbms_datapump.open(
    operation   => 'SQL_FILE',
    job_mode    => 'SCHEMA',
    job_name    => upper(p_jobname)
    );
 
  dbms_datapump.add_file(
    handle    => l_jobid,
    filename  => p_dumpfile,
    directory => p_dumpdir);
 
  dbms_datapump.add_file(
    handle    => l_jobid,
    filename  => p_dumpfile||'.log',
    directory => p_dumpdir,
    filetype  => dbms_datapump.ku$_file_type_log_file);
 
  dbms_datapump.add_file(
    handle    => l_jobid,
    filename  => p_dumpfile||'.sql',
    directory => p_dumpdir,
    filetype  => dbms_datapump.ku$_file_type_sql_file);
 
  -- just in case they give us multiple schemas or a full
 
  dbms_datapump.metadata_filter(
    handle => l_jobid,
    name   => 'SCHEMA_EXPR',
    value  => '= '''||p_schema||'''');
 
  dbms_datapump.metadata_remap(l_jobid,
                               'REMAP_SCHEMA',
                               p_schema,
                               p_new_schema);
 
  -- don't need storage params
 
  dbms_datapump.metadata_transform(
    handle      => l_jobid,
    name        => 'STORAGE',
    value       => 0);
 
  -- don't need tablespace
 
  dbms_datapump.metadata_transform(
    handle      => l_jobid,
    name        => 'SEGMENT_ATTRIBUTES',
    value       => 0);
 
  -- filter the list of valid object types we'll permit
 
  l_obj_types := 'IN ('''||l_obj_nt(1)||'''';
  for i in 2 .. l_obj_nt.count
  loop
    l_obj_types := l_obj_types || ','''||l_obj_nt(i)||'''';
  end loop;
  l_obj_types := l_obj_types || ')';
 
  dbms_datapump.metadata_filter(
    handle => l_jobid,
    name => 'INCLUDE_PATH_EXPR',
    value => l_obj_types
  );
 
  dbms_datapump.start_job(l_jobid);

  dbms_datapump.wait_for_job(
     handle => l_jobid,
     job_state => l_job_state);

  dbms_datapump.detach(l_jobid);
end;
/
