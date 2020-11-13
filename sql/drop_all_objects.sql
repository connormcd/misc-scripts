-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serverout on
declare
  l_obj_count      int;
begin
  for iteration in 1 .. 4 loop
      l_obj_count := 0;
      for i in ( 
        select *
        from (
          select 20 seq, 
                 decode(d.object_type,
                        --
                        -- scheduler stuff
                        --
                        'CHAIN','begin dbms_scheduler.drop_chain(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'CREDENTIAL','begin dbms_scheduler.drop_credential(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'DESTINATION','begin dbms_scheduler.drop_database_destination(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'FILE WATCHER','begin dbms_scheduler.drop_file_watcher(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'SCHEDULER GROUP','begin dbms_scheduler.drop_group(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'JOB CLASS','begin dbms_scheduler.drop_job(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'JOB','begin dbms_scheduler.drop_job_class(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'PROGRAM','begin dbms_scheduler.drop_program(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'SCHEDULE','begin dbms_scheduler.drop_schedule(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        'WINDOW','begin dbms_scheduler.drop_window(''"'||owner||'"."'||object_name||'"'',force=>true); end;',
                        --
                        -- other specials
                        --
                        'CLUSTER','drop '||d.object_type||' "'||d.owner||'"."'||d.object_name||'" including tables cascade constraints',
                        'INDEXTYPE','drop '||d.object_type||' "'||d.owner||'"."'||d.object_name||'" force',
                        'OPERATOR','drop '||d.object_type||' "'||d.owner||'"."'||d.object_name||'" force',
                        'TYPE','drop '||d.object_type||' "'||d.owner||'"."'||d.object_name||'" force',
                        --
                        -- catch all for the rest
                        --
                        'drop '||d.object_type||' "'||d.owner||'"."'||d.object_name||'"') ddl
          from   dba_objects d,
                 all_users u
          where  d.owner = u.username
          and    u.common = 'NO'
          and    d.object_type in (
                     'ANALYTIC VIEW'
                    ,'ATTRIBUTE DIMENSION'
                    ,'CHAIN'
                    ,'CLUSTER'
                    ,'CREDENTIAL'
                    ,'DESTINATION'
                    ,'DIMENSION'
                    ,'FILE WATCHER'
                    ,'FUNCTION'
                    ,'HIERARCHY'
                    ,'INDEXTYPE'
                    ,'INMEMORY JOIN GROUP'
                    ,'JAVA CLASS'
                    ,'JAVA DATA'
                    ,'JAVA RESOURCE'
                    ,'JAVA SOURCE'
                    ,'JOB CLASS'
                    ,'JOB'
                    ,'MATERIALIZED VIEW'
                    ,'OPERATOR'
                    ,'PACKAGE'
                    ,'PROCEDURE'
                    ,'PROGRAM'
                    ,'SCHEDULE'
                    ,'SCHEDULER GROUP'
                    ,'SEQUENCE'
                    ,'SYNONYM'
                    ,'TYPE'
                    ,'VIEW'
                    ,'WINDOW')
          union all
          select 10 seq, 
                 'drop table "'||d.owner||'"."'||d.table_name||'" cascade constraints purge' ddl
          from   dba_tables d,
                 all_users u
          where  d.owner = u.username
          and    u.common = 'NO'
          and    d.secondary = 'N'
          and    d.nested = 'NO'
          union all
          select 30 seq, 
                 'drop trigger "'||d.owner||'"."'||d.trigger_name||'"' ddl
          from   dba_triggers d,
                 all_users u
          where  d.owner = u.username
          and    u.common = 'NO'
          and    d.table_name is null
        )
        order by 
           seq,
           case when mod(iteration,2) = 1 then ddl else reverse(ddl) end
      )
      loop
        l_obj_count := l_obj_count + 1;
        begin
          dbms_output.put_line(i.ddl);
          --
          -- COMMENT ME BACK IN IF YOU WANT REALLY DROP STUFF
          --
          --execute immediate i.ddl;
        exception
          when others then null;
        end;
      end loop;
      exit when l_obj_count = 0;
      dbms_output.put_line('Completed iteration #'||iteration||', objects = '||l_obj_count);
  end loop;      
end;
/

