REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 


create or replace
function utl_file_dir(p_file_or_dir varchar2, 
                      p_create_dir boolean default true, 
                      p_add_hash boolean default true) return varchar2 is
  pragma autonomous_transaction;

  l_default_dir varchar2(128) := 'TEMP';
  l_delim       varchar2(1)   := '/';   -- change for Windows

  l_last_delim  int           := instr(p_file_or_dir,l_delim,-1);
  l_file        varchar2(255); 
  l_dir_path    varchar2(255);
  l_dir_object  varchar2(255);
  l_exists      int;
  l_clash       int;
begin
  if l_last_delim = 0 then
     --
     -- If no presence of a directory delimiter, then we assume the entire
     -- string is a file if it contains a '.' (ie, a file extension)
     -- and return a default directory object name (l_default_dir)
     -- otherwise we assume the string is a directory in its own right
     --
     if p_file_or_dir like '%.%' then
       l_dir_object := l_default_dir;
     else
       l_dir_path   := p_file_or_dir;
     end if;
  else
     --
     -- We have a delimiter. The directory is the contents up to
     -- the last delimiter, unless there is no file extension past
     -- that last delimiter. In that latter case, we assume the entire
     -- string is a directory in its own right
     --
     l_file      := substr(p_file_or_dir,l_last_delim+1);
     if l_file like '%.%' then
       l_dir_path     := substr(p_file_or_dir,1,l_last_delim-1);
     else
       l_dir_path     := p_file_or_dir;
     end if;
  end if;

  --
  -- Now we make a clean directory object name from the path. We could
  -- of course use any random string, but this is designed to make things
  -- a little more intuitive. 
  -- 
  -- For example '/u01/app/oracle' will become U01_APP_ORACLE
  --
  -- You have a choice here in terms of the risk element of collisions depending 
  -- on how loose your folder structure is.  For example, the two paths:
  --
  --   /u01/app/oracle/
  --   /u01/app/"oracle-"/
  --
  -- by default will map to the same clean name of U01_APP_ORACLE and we will   
  -- report an error in this instance.
  -- 
  -- Alternatively (and the default) is that we take our directory path and 
  -- grab the last few bytes from a MD5 hash on it, to greatly increase the likelihood
  -- of a non-clashing directory name.  In the above example, the clean directory names become
  --
  --   U01_APP_ORACLE_25B9C47A
  --   U01_APP_ORACLE_7D51D324
  -- 
  -- So what you lose in intuitive readability you gain in reduced chance of collision.
  -- This is controlled with "p_add_hash"
  --
  if l_dir_object is null then
     l_dir_object := regexp_replace(replace(replace(l_dir_path,l_delim,'_'),'-','_'),'[^[:alnum:] _]');
     l_dir_object := regexp_replace(trim('_' from upper(regexp_replace(l_dir_object,'  *','_'))),'__*','_');
     if p_add_hash then
       select substr(l_dir_object,1,119)||'_'||substr(standard_hash(l_dir_path,'MD5'),1,8)
       into   l_dir_object
       from   dual;
     else
       l_dir_object := substr(l_dir_object,1,128);
     end if;
  end if;

  -- Now we go ahead and create that directory on the database.
  -- The user running this function must have CREATE ANY DIRECTORY privilege granted
  -- explicitly, which means of course, you should protect this routine and perhaps add
  -- some sanity checking to make sure that no-one creates a directory to reference (say) 
  -- the objects in V$DATAFILE !
  
  if p_create_dir then
    select count(*),
           count(case when directory_path != l_dir_path then 1 end) 
    into   l_exists,
           l_clash
    from   all_directories
    where  directory_name = l_dir_object;

    if l_exists = 0 then
      execute immediate 'create directory "'||l_dir_object||'" as q''{'||l_dir_path||'}''';
    else
      --
      -- If (hash or not) we enter the nasty situation where the same clean name would
      -- map to 2 path names, we give up and go home.
      --
      if l_clash > 0 then
        raise_application_error(-20000,'Found matching directory object '||l_dir_object||' with different path from >'||l_dir_path||'<');
      end if;
    end if;
  end if;
  
  commit;
  return l_dir_object;
end;
/
sho err


-- Examples

variable dirname varchar2(128)
-- standard file
exec :dirname := utl_file_dir('/u01/app/oracle/test.dat',p_create_dir=>false)
print dirname

-- quoted/spaces etc
exec :dirname :=  utl_file_dir('/u01/"asd app"/oracle/test.dat',p_create_dir=>false)
print dirname

-- trailing delimiter. 
exec :dirname :=  utl_file_dir('/u01/app/oracle/',p_create_dir=>false)
print dirname
exec :dirname :=  utl_file_dir('/u01/app/oracle--/',p_create_dir=>false)
print dirname

-- no file 
exec :dirname :=  utl_file_dir('/u01/app/oracle',p_create_dir=>false)
print dirname

-- no delimiter
exec :dirname :=  utl_file_dir('mydir',p_create_dir=>false)
print dirname

-- no delimiter but probably a file
exec :dirname :=  utl_file_dir('mydir.txt',p_create_dir=>false)
print dirname

