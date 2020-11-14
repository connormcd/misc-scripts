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
set verify off
accept owner char prompt 'Owner '
accept table_name char prompt 'Table '
accept reads_to_perform number prompt 'Number of reads '

declare
  type t is table of rowid index by binary_integer;
  r t;
  d number;
  tot number := 0;
  idx number;
  max_reads number := &&reads_to_perform;
  per_iteration number := 5000;
  dummy &&owner..&&table_name%rowtype;
  t1 number;
  suc number := 0;
  fail number := 0;
  tim number := 0;
begin
  dbms_random.seed(1);

  select data_object_id into d from dba_objects
  where owner = upper('&&owner')
  and   object_name = upper('&&table_name') and rownum = 1;

  for i in ( select relative_fno, block_id, blocks
             from dba_extents
             where owner = upper('&&owner')
             and   segment_name = upper('&&table_name') 
             order by 2,1) loop
    for j in 1 .. i.blocks loop
      r(trunc(dbms_random.value(0,100000))) :=  dbms_rowid.rowid_create(1,d,i.relative_fno,i.block_id+j-1,1);  
    end loop;    

    if r.count > per_iteration then
      idx := r.first;
      t1 := dbms_utility.get_time;
      loop
         begin
            select * into dummy from &&owner..&&table_name where rowid = r(idx);
            suc := suc + 1;
         exception
            when others then fail := fail + 1;
         end;         
         tot := tot + 1;
         dbms_application_info.set_client_info(tot);
         idx := r.next(idx);
         exit when tot > max_reads or idx is null;
      end loop;
      tim := tim + dbms_utility.get_time - t1;
      r.delete; 
--      exit;
    end if;
  end loop;
  dbms_output.put_line('Attempts         '||tot);
  dbms_output.put_line('Successful reads '||suc);
  dbms_output.put_line('Failures         '||fail);
  dbms_output.put_line('Elapsed(ms)      '||tim*10);
  dbms_output.put_line('Avg(ms)          '||(tim*10/suc));
end;
/

