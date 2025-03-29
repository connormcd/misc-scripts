set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set termout on
set echo on
create or replace
package body mypkg is
   my_global int := 0;

   procedure p is
   begin  
     my_global := my_global + 2;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
--
-- back to session 1
--
pause
create or replace
package body mypkg is
   my_global int := 20;

   procedure p is
   begin  
     my_global := my_global + 3;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
--
-- back to session 1
--
pause
clear screen
create or replace
package body mypkg is
   my_global int := 20;

   procedure p is
   begin  
     my_global := my_global + 3;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
--
-- back to session 1
--
pause
create or replace
package body mypkg is
   my_global int := 50;

   procedure p is
   begin  
     my_global := my_global + 21;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
--
-- back to session 1
--
