undefine object_name
undefine owner

set long 100000
set longchunksize 100000
variable c clob

set feedback off

declare

function ddl(p_sql clob) return clob is
  
  in_double   boolean := false;
  in_string   boolean := false;
  need_quotes boolean := false;
  
  ddl         clob;
  idx         int := 0;
  res         clob;
  res2         clob;
  thischar    varchar2(1);
  prevchar    varchar2(1);
  nextchar    varchar2(1);
  sqt         varchar2(1) := '''';
  dqt         varchar2(1) := '"';
  last_dqt    int;

  prev_txt varchar2(1999);
  this_line varchar2(1999);
  last_space number;
  sql_text varchar2(200);
   
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
  dbms_lob.createtemporary(res2,true);
  dbms_lob.createtemporary(ddl,true);

  res2 := '';
  dbms_utility.expand_sql_text(p_sql,ddl);

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

  for i in 0 .. 9999 loop
    sql_text := dbms_lob.substr(res,100,i*100+1);

    exit when sql_text is null;
    
    if instr(prev_txt||sql_text,' from',-1) between 1 and 60 then
        last_space := instr(prev_txt||sql_text,' from',-1);
    elsif instr(prev_txt||sql_text,',',-1) > 60 then
        last_space := instr(prev_txt||sql_text,',',-1);
        for w in 2 .. 20 loop 
           if instr(prev_txt||sql_text,',',-1,w) > 60 then
              last_space := instr(prev_txt||sql_text,',',-1,w);
--              dbms_output.put_line(w||'w-'||last_space);
           else
             exit;
           end if;
        end loop;
    elsif instr(prev_txt||sql_text,' ',-1) > 60 then
        last_space := instr(prev_txt||sql_text,' ',-1);
        for w in 2 .. 20 loop 
           if instr(prev_txt||sql_text,' ',-1,w) > 60 then
              last_space := instr(prev_txt||sql_text,' ',-1,w);
--              dbms_output.put_line(w||'w-'||last_space);
           else
             exit;
           end if;
        end loop;
    else
      last_space := 0;
    end if;
--    dbms_output.put_line(i||'-'||last_space);
    if last_space > 0 then
      this_line := substr(prev_txt||sql_text,1,last_space);
      res2 := res2 || this_line ||chr(10);
      prev_txt := substr(prev_txt||sql_text,last_space+1);
    else
      prev_txt := prev_txt||sql_text;
    end if;
  end loop;    
  res2 := res2 || prev_txt ||chr(10);

  return res2;
end;

begin
 :c := ddl('&1') ;
end;
/
print c
set feedback on


