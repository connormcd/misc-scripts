-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
rem Author:     RSANDERS.UK
rem Name:       ts_prod.sql
rem             Find and list TEMP segments and their owners
rem Note:       Totally unsupported and may not work on all platforms/versions
REM               ( edited by Xbui.fr and khailey.fr )
REM 
REM  to run in set port specific values and in sqlplus
REM     set serveroutput on
REM     execute dbms_output.enable(1000000)
REM 	execute find_sort_segment_owners 
REM  
REM intel ( SEQUENT)  and  Alpha
REM 	byte_swapped     boolean := true; 
REM Sun and others
REM 	byte_swapped     boolean := false; 
REM  
REM Alpha
REM     sga_word_size := 8;
REM others
REM     sga_word_size := 4;
REM  
REM 	The table x$ksmmem represents the SGA, each  element of this table 
REM represents sga_word_size bytes of the SGA. 
REM 	the view V$SESSION is based on X$KSUSE which contains structures 
REM in  the SGA. Each element of X$KSUSE describes a session of ORACLE. THe 
REM column ADDR gives an address in the SGA of structure KSSOB that describes  
REM an objet. The  structure KSSOB  contains two octets in the header that 
REM gives the state(kssobflg) of the session and the object type (kssobtyp). 
REM 	The structure KSSOB contains also a list of "children" created  by 
REM the session: a segment temporaire is a child of the session. 
REM 	The idea is  therefore  to scan the  list of sessions: 
REM 	For each session, find in X$KSUSE, the list of its children. 
REM 	For each child, if  type temporary then, this child is 
REM represented by the structure ktatl {struct kssob ktatlsob;kdba ktatldba;...}
REM 	ktatldba contains the DBA of the segment temporaire. CQFD 
REM  
create or replace procedure find_sort_segment_owners
as
-- ************ BEGIN PORT SPECIFIC VALUES ******************
sga_word_size    number  := 8    ; /* 8 for Alpha o/w 4 */ 
byte_swapped     boolean := true ; /* True for Sequent and DEC UNIX ow false */
debug            boolean := false;
-- ************ END  PORT SPECIFIC  VALUES *******************
-- determine byte ordering of multi-byte values
-- is machine little endian or big endian
-- low byte values first or high byte values first
-- a byte is 8 bits 
--       ie 00000000 to 11111111
--       or 0 to 31 in decimal 
--       or 0 to FF in hex
-- ascii character 'b' dumped in hex is the one byte value 62
-- ascii character 'y' dumped in hex is the one byte value 79
-- ascii character 't' dumped in hex is the one byte value 74
-- ascii character 'e' dumped in hex is the one byte value 65
-- dumping the string 'byte' ( echo 'byte'  | od -x ) gives
--     b y  t e
--    6279 7465 on "normal"      - big    endian bytes (most  significant) first
--     y b  e t
--    7962 6574 on  byte_swapped - little endian bytes (least significant) first
--  the word 'endian' seems to come from gullivers travels and the
--  endian wars - or the war between the two tribes over which
--  end of the egg to open fist
--  seems to have been used in "On Holy Wars and a Plea for Peace" 
--  by Danny Cohen in USC/ISI IEN 137, April 1st 1980. 
--
-- x$ tables are based on structs in the code
-- they contain the values 
--  ADDR    RAW(8)  -- shared memory address
--  INDX    NUMBER  -- offset in struct size from the begining ofstruct for row
--  OTHER_STUFF     --  the contents of the struct
--
-- V$SESSION is based on X$KSUSE
-- X$KSUSE is based on the structure 
--          struct   ksuse   { ksspa   ksusegen; ... lots of other stuff }
-- ksspa is 
--          struct   ksspa   { kssob   ksspaobj; kgglk   ksspachl; };
-- kssob is
--          struct   kssob  {        unsigned long         :0;
--                                   ub1             kssobtyp;
--                                   ub1             kssobflg;
--                                   KSSOINIT 0x01 state object initialized
--                                   KSSOFLST 0x02 state object is on free list
--                                   KSSOFCLN 0x04 state object freed by PMON 
--                                                          (for debugging)
--                           struct  kssob          *kssobown; 
--                                   kgglk           kssoblnk; };
-- kgglk is
--          struct   kgglk   {struct kgglk  *kgglknxt;struct kgglk *kgglkprv;};
--
-- so for a user
--
--      ( questions - what does the first [---kgglk---] point to ? )
--      ( how do we know that the kgglk* is the child objects )
--      ( how do we know that the flag for a temp segment has given value)
--      ( how do we know that a temp struct is of ktatl )
--
--      ksuse
--     +---------------------------------------------------...
--     |  ksppa
--     | ------------------------------------------+ +-------
--     | | kssob       [---kgglk---]  kgglk*       | |   
--     | | +-----------------------+ +-----------+ | |
--     | | | flg | own | nxt | prv | | nxt  prv  | | | ...
--     | | +-----------------------+ +-||--------+ | |
--     | +---------------------------^-||----------+ +-------
--     +-----------------------------|-||------------------...
--                                   | ||
--           +-----------------------+ ||
--           |                _________||
-- child     |   kssob's     ||
-- objects   |               \/          
--           |              +--kgglk---+   if flag is temp then
--           |  +----------------------+   we find dba of temp seg
--           |  |flg | own | nxt | prv |                           
--           |  +------------||--------+ +----ktatl--------------+
--           |  +------------\/-----------------------------------
--           |  |flg | own | nxt | prv |  dba  | ...
--           |  +------------||-----------------------------------
--           |  +------------\/--------+
--           |  |flg | own | nxt | prv |
--           |  +------------||--------+
--           |               ||
--           +----------------+
-- 
--  so we the idea is to scan the kssob's off of kgglk* 
--  this represents a list of the child objects  
--  of the user. If the flg is a type temporary then the user is the
--  owner of a temporary segment
--  if the kssob is a temporary type then it is part of the structure
--    struct ktatl
--    {
--      kssob          ktatlsob;
--      kdba           ktatldba;
--      ksqlk          ktatllok;
--      ub1            ktatlflg;
--    };
--
-- desc x$ksmmem
--   ADDR      RAW(8)
--   INDX      NUMBER
--   KSMMMVAL  RAW(8) -- contents of SGA at this address/index
--
-- x$ksmmem -- based on structure "struct ksmmm { struct ksmmm *ksmmmval; };"
-- ( how does it work !? )
-- ksmmmval - contains the SGA memory contents at that value
-- x$ksmmem represents the SGA, each element represents sga_word_size bytes
-- ind = 0 address SGA+0 to SGA+sga_word_size
-- size (*ksmmmval) on alpha is 8 other unixs 4
--
-- on                          Alpha other
-- typedef unsigned char  ub1;
-- size of (kssob)               32   16
-- struct   kssob   {
--          unsigned long :0;    +8   +4 
--          ub1     kssobtyp;    +0   +0   stored in the long 
--          ub1     kssobflg;    +0   +0   stored in the long
-- struct   kssob  *kssobown;    +8   +4 
--          kgglk   kssoblnk;    +16  +8 
--          };
-- size of (kssob)               16    8
-- struct   kgglk   {
-- struct   kgglk  *kgglknxt;    +8   +4 
-- struct   kgglk  *kgglkprv;    +8   +4 
--         };
--sizeof(kgglk) which is the offset_to_next_link, 16 on alpha o/w 8
  offset_to_next_link          number := 2*sga_word_size ;   
  offset_to_temp_table_dba     number := 0 ;   
--sizeof(kssob) which is the size_of_generic_state_object, 32 on alpha o/w 16
  size_of_generic_state_object number := 4*sga_word_size; 
  max_scan_count   constant    number := 200;   /* Max. no of so. to scan */

  type temp_seg_number_array
       is table of number index by binary_integer;
  temp_seg_file_no  temp_seg_number_array;
  temp_seg_block_no temp_seg_number_array;
  temp_seg_owner    temp_seg_number_array;
  no_of_temp_segments number := 0;
  sga_base_address number;
  sga_base_address_hex varchar2(50);
  loop_cnt number;
  temp_table_state_object number;
  temp_table_dba  number;
  temp_table_file_no    number;
  temp_table_block_no   number;
  sess_id    number;
  sess_addr  varchar2(50);
  sga_addr   varchar2(50);
  kssob_type_flag varchar2(50);
  kssob_own_ptr   varchar2(50);
  kssob_nxt_link  varchar2(50);
  kssob_prv_link  varchar2(50);
  parent_head     number;
  cursor c1 is select sid,rawtohex(saddr)
                 from v$session ;

function  to_decimal (hex_str_in in varchar2) return number as
   hex_str varchar2(50) :=hex_str_in;
   result   number;
   hex_char number;
   begin
   if ( sga_word_size = 8 ) then
      hex_str := lpad(upper(nvl(ltrim(hex_str,'0'),'0')),16,'0');
      result := 0;
      for i in 1..16 loop
          hex_char := ascii(substr(hex_str,i,1));
          if (hex_char - 64 > 0 ) then
              hex_char := hex_char - 64 + 9;
          else
             hex_char := hex_char - 48 ;
          end if;
      result := result + ( hex_char * power(2, ( 64 - (i*4) ) ) );
--    dbms_output.put_line('.  to_decimal result'||result);
      end loop;
      return (trunc(result));
   else
--    sga_word_size = 4
      hex_str := lpad(upper(nvl(ltrim(hex_str,'0'),'0')),8,'0');
      result := 0;
      for i in 1..8 loop
          hex_char := ascii(substr(hex_str,i,1));
          if (hex_char - 64 > 0 ) then
              hex_char := hex_char - 64 + 9;
          else
             hex_char := hex_char - 48 ;
          end if;
      result := result + ( hex_char * power(2, ( 32 - (i*4) ) ) );
      end loop;
      return (trunc(result));
    end if;
end;


procedure get_base_address as
      hex_address       varchar2(40);
   begin
      select rawtohex(addr)
        into hex_address
        from x$ksmmem
       where indx = 0;
--  get adress of the SGA ( address of byte 0)
      sga_base_address := to_decimal(hex_address);
      sga_base_address_hex := hex_address;
end;

-- get the offset in sga_word_size from start of the sga
-- which corresponds to indx in x$ksmmem
function get_sga_index(sga_address in varchar2) return number as
begin
-- dbms_output.put_line('.  get_sga_index '||sga_address);
   return trunc((to_decimal(sga_address)-sga_base_address)/sga_word_size );
end;

function get_sga_value (hex_address in varchar2,adjustment in number default 0)
                                          return varchar2 as
     sga_index   number;
     local_value varchar2(50);
   begin
--   adjustment is used to get values out of structures at the given 
--   address. 
     sga_index := get_sga_index(hex_address) + adjustment;
     if (debug) then
       dbms_output.put_line('.  get_sga_value '||hex_address||' '||
                                               to_char(adjustment));
       dbms_output.put_line('.  get_sga_value get_sga_index '||sga_index);
     end if;
     select rawtohex(ksmmmval) into local_value from x$ksmmem
                where indx = sga_index;
     return local_value;
end;

procedure get_temp_table_state_object as
     hex_str varchar2(50);
     state_object_address varchar2(50);
     state_object_offset  number;
     sga_structure        boolean;
     sga_col_count        number;
     c1                   integer;
     rc                   integer;
     sql_stmt             varchar2(255);
begin
-- decide if the table x$ksmfsv has the column KSMFSOFF
-- if not then we have the column KSMFSADR
     select count(*) into sga_col_count from x$kqfta a, x$kqfco b
      where a.kqftanam = 'X$KSMFSV' and a.indx = b.KQFCOTAB
        and b.KQFCONAM = 'KSMFSADR';
     if ( sga_col_count = 1 ) then
        sga_structure := false;
     else
        sga_structure := true;
   end if;
-- determine the address of the temporary lock table structure table 
-- and get size(int) bytes at this address to stock in  temp_table_state_object 
   if ( sga_structure ) then
--   dbms_output.put_line('sga_structure true');
     c1 := dbms_sql.open_cursor;
     sql_stmt := 'select KSMFSOFF from x$ksmfsv
                 where KSMFSNAM like ''%ktatlt%'' ';
     dbms_sql.parse(c1,sql_stmt,dbms_sql.native);
     dbms_sql.define_column(c1,1,state_object_offset);
     rc := dbms_sql.execute(c1);
     rc := dbms_sql.fetch_rows(c1);
     dbms_sql.column_value(c1,1,state_object_offset);
     dbms_sql.close_cursor(c1);
     temp_table_state_object := to_decimal(
                               get_sga_value(sga_base_address_hex,
                                       state_object_offset/sga_word_size));
  else
--       dbms_output.put_line('sga_structure false');
    c1 := dbms_sql.open_cursor;
        sql_stmt := 'select rawtohex(KSMFSADR) from x$ksmfsv
                  where KSMFSNAM like ''%ktatlt%'' ' ;
--
-- select * from  x$ksmfsv where KSMFSNAM like '%ktatlt%'
--   KSMFSNAM            KSMFSTYP         KSMFSADR   KSMFSSIZ
--   ktatlt_             word     00000000008056B4          4
--
-- typedef         int  word;
-- sizeof(int) is 4 on Alpha
--
     dbms_sql.parse(c1,sql_stmt,dbms_sql.native);
     dbms_sql.define_column(c1,1,state_object_address,50);
     rc := dbms_sql.execute(c1);
     rc := dbms_sql.fetch_rows(c1);
     dbms_sql.column_value(c1,1,state_object_address);
     dbms_sql.close_cursor(c1);
         dbms_output.put_line('state_object_address '||
                               state_object_address);
     if ( sga_word_size = 8 ) then 
--     on Alpha
--     dump of x$ksmem gives a 64 bit value ( 8 bytes )
--     the value we are looking for is a word (int) or 4 bytes
--         |----------ksmmemval-------|
--         |-----obj----|
--         --  --  --  -- | -- -- -- --
--          1   2   3   4    5  6  7  8
--      
--     the temp object is stored at the 4th word 
       hex_str := get_sga_value(state_object_address);
       dbms_output.put_line('. temp flag value at address '||hex_str);
--     make sure the value is a full 16 characters
       hex_str := lpad(upper(nvl(ltrim(hex_str,'0'),'0')),16,'0');
       hex_str := substr(hex_str,1,8);
       temp_table_state_object := to_decimal(hex_str);
     else
       temp_table_state_object:=to_decimal(get_sga_value(state_object_address));
     end if;
   end if;
   dbms_output.put_line('. temp_table_state_object '||temp_table_state_object);
end;

function state_object_initialised(flags in varchar2) return boolean
   is
   begin
     if ( sga_word_size = 8 and byte_swapped ) then
--      dbms_output.put_line('.  state_object_initialised '||flags);
        if ( to_decimal(substr(flags,14,1)) = 1 ) then
             return true;
        else
             return false;
        end if;
     else
       if ( byte_swapped ) then
--       dbms_output.put_line('bs: state_object_initialised '||flags);
          if ( to_decimal(substr(flags,6,1)) = 1 ) then
             return true;
          else
             return false;
          end if;
       else
--       dbms_output.put_line('state_object_initialised '||flags);
          if ( to_decimal(substr(flags,4,1)) = 1 ) then
             return true;
          else
             return false;
          end if;
       end if;
     end if;
end;

function is_temp_table_state_object(flags in out varchar2) return boolean
   is
   begin
     if ( byte_swapped ) then
        if ( sga_word_size = 8 ) then
            flags:=lpad(upper(nvl(ltrim(flags,'0'),'0')),16,'0');
--          make sure the value is a a full 16 characters
--          the problem is the flag value comes from
--          get_sga_value which queries x$ksmmem which
--          contains 64 bit values with 8 byte words
--          flags:=substr(flags,9,8);
            if (debug) then
               dbms_output.put_line('.         '||
                                    to_decimal(substr(flags,15,2))||
                                    '?='||temp_table_state_object);
            end if;
            if ( to_decimal(substr(flags,15,2)) = temp_table_state_object ) then
               return  true;
            else
               return  false;
            end if;
        else
            if ( to_decimal(substr(flags,7,2)) = temp_table_state_object ) then
               return  true;
            else
               return  false;
            end if;
        end if;
     else
         if ( to_decimal(substr(flags,1,2)) = temp_table_state_object ) then
            return  true;
         else
            return  false;
         end if;
     end if;
end;

procedure build_active_temp_segments as
-- all the segments of type temporary
     cursor c1 is select file#,block# from seg$ where type=3;
     local_file_no  number;
     local_block_no number;
   begin
     open c1;
     no_of_temp_segments := 0 ;
     loop
       fetch c1 into local_file_no,local_block_no;
       exit when c1%notfound;
       no_of_temp_segments := no_of_temp_segments + 1;
       temp_seg_file_no(no_of_temp_segments) := local_file_no ;
       temp_seg_block_no(no_of_temp_segments) := local_block_no;
       temp_seg_owner(no_of_temp_segments)    := (-1);
     end loop;
     close c1;
end;

function is_valid_temp_seg_dba (t_file_no number, t_block_no number,
                                   sess_id    number ) return boolean
   is
   begin
     for i in 1..no_of_temp_segments loop
       if ( temp_seg_file_no(i) = t_file_no    and
            temp_seg_block_no(i)= t_block_no ) then
            temp_seg_owner(i)   := sess_id ;
            return true;
       end if;
     end loop;
     return false;
end;


-- *********************  MAIN ********************************
begin
-- search the beginning of the sga
   get_base_address;
   dbms_output.put_line('SGA base '||sga_base_address);
-- get the status of the table of tempory locks 
   get_temp_table_state_object;
   dbms_output.put_line('temp state '||temp_table_state_object);
-- determine  all the  segments temporaires ( fileno,blkno)
   build_active_temp_segments;
-- loop over the session ids, and address
   open c1;
   loop
     fetch c1 into sess_id,sess_addr ;
     exit when c1%notfound;
     dbms_output.put_line('********** sess_id,sess_addr '||
                          to_char(sess_id)||' '||sess_addr||'  ***********');
     kssob_type_flag := get_sga_value(sess_addr);
     if (debug) then
         dbms_output.put_line('.  kssob_type_flag '||kssob_type_flag);
     end if;
--   head of list of children
     parent_head     := to_decimal(sess_addr) + size_of_generic_state_object; 
--   next
     kssob_nxt_link  := get_sga_value(sess_addr,
                           size_of_generic_state_object/sga_word_size);
     if (debug) then
         dbms_output.put_line('.  kssob_nxt_link '||kssob_nxt_link);
     end if;
     sga_addr        := parent_head ;
     loop_cnt := 0;
--   if object is initialized
--   if ( state_object_initialised(kssob_type_flag) and  ( sess_id=6)) then
     if ( state_object_initialised(kssob_type_flag) ) then
        loop
          exit when to_decimal(kssob_nxt_link) = parent_head;
          exit when loop_cnt > max_scan_count ;
          loop_cnt := loop_cnt + 1;
          sga_addr := kssob_nxt_link;
--        flag of child 
          kssob_type_flag := get_sga_value(sga_addr,
                                       - (offset_to_next_link/sga_word_size) );
          kssob_nxt_link  := get_sga_value(sga_addr,0);
          if (debug) then
               dbms_output.put_line('.     type flag '||kssob_type_flag);
          end if;
          if ( state_object_initialised(kssob_type_flag) and
             ( is_temp_table_state_object(kssob_type_flag) )) then
--           if the child is  a segment temporary then  child is of the 
--           structure ktatl { struct kssob ktatlsob; kdba ktatldba; ...}
--           ktatldba contains the number of the temporary segment 
             temp_table_dba  := to_decimal( get_sga_value(sga_addr,
                                    ( offset_to_next_link ) / sga_word_size 
                                      + offset_to_temp_table_dba ));
             temp_table_file_no
                        :=dbms_utility.data_block_address_file(temp_table_dba);
             temp_table_block_no
                        :=dbms_utility.data_block_address_block(temp_table_dba);
             if ( is_valid_temp_seg_dba(temp_table_file_no,temp_table_block_no,
                                        sess_id) ) then
                sys.dbms_output.put_line(
                 'Session '||rpad(to_char(sess_id),6,' ')||
                 ' TS : Id1 '||rpad(temp_table_dba,10,' ')||
                 ' File No '||rpad(temp_table_file_no,6,' ')||' Block No '||
                 rpad(temp_table_block_no,10,' '));
             end if;
          end if;
        end loop;
      end if;
  end loop;
  close c1;
  for i in 1..no_of_temp_segments loop
  if (temp_seg_owner(i) = (-1) ) then
    dbms_output.put_line('Unresolved Segment file:'||temp_seg_file_no(i)||
     ' block: '||temp_seg_block_no(i)||' owner: '||temp_seg_owner(i));
  end if;
  end loop;
end;
/
                                                              