-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------

undefine object_name
undefine owner

set long 100000
set longchunksize 100000
col x new_value typ
col y new_value own
select owner y, object_type x
from dba_objects
where object_name = upper('&&object_name')
and  owner = nvl(upper('&&owner'),owner)
and object_type not like '%PARTITION%' 
and object_type not like '%SYNONYM%' 
and owner != 'PUBLIC'
and rownum = 1;

variable c clob

set feedback off

begin
           dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
           dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
           dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SEGMENT_ATTRIBUTES', false);
           dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'STORAGE', false);
end;
/

declare

function ddl(p_type varchar2, p_name varchar2, p_owner varchar2 default user) return clob is
  
  in_double   boolean := false;
  in_string   boolean := false;
  need_quotes boolean := false;
  
  ddl         clob;
  idx         int := 0;
  res         clob;
  thischar    varchar2(1);
  prevchar    varchar2(1);
  nextchar    varchar2(1);
  sqt         varchar2(1) := '''';
  dqt         varchar2(1) := '"';
  last_dqt    int;
   
  procedure append is
  begin
    if not need_quotes and not in_string and not in_double then
      res := res || lower(thischar);
    else
      res := res || thischar;
    end if;
  end;
begin
  dbms_lob.createtemporary(res,true);
  dbms_lob.createtemporary(ddl,true);

  select ltrim(dbms_metadata.get_ddl(upper(p_type),p_name,upper(p_owner)),chr(10)||chr(13)||' ')
  into   ddl
  from   dual;
  
  loop
    idx := idx + 1;
    if idx > 1 then prevchar := thischar; end if;
    thischar := substr(ddl,idx,1);
    exit when thischar is null;
    nextchar := substr(ddl,idx+1,1);

    if thischar not in (dqt,sqt) then
      append;
      if in_double then
        if thischar not between 'A' and 'Z' and thischar not between '0' and '9' and thischar not in ('$','#','_') or
           ( prevchar = dqt  and ( thischar in ('$','#','_') or thischar between '0' and '9' ) )
        then
          need_quotes := true;
        end if;
      end if;
    elsif thischar = dqt and not in_double and not in_string then
      append;
      in_double := true;
      need_quotes := false;
    elsif thischar = dqt and in_double and not in_string then
      last_dqt := instr(res,dqt,-1);
      if last_dqt = 0 then
        raise_application_error(-20000,'last_dqt died');
      else
        if not need_quotes then
          res := substr(res,1,last_dqt-1)||lower(substr(res,last_dqt+1));
        else
          append;
        end if;
        need_quotes := false;
      end if;    
      in_double := false;
    elsif thischar = sqt then
      append;
      if not in_double then
        if not in_string then
          in_string := true;
        else
          if nextchar = sqt then
            in_string := true;
            res := res ||  nextchar;
            idx := idx + 1;
          else
            in_string := false;
          end if;
        end if;
      end if;
    else
      append;
    end if;
    
  end loop;
  return res;
end;

begin
 :c := ddl(upper('&typ'),upper('&&object_name'),upper('&&owner')) ;
end;
/
print c
set feedback on
