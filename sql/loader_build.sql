-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
REM BUILD_CTL.SQL
set echo off
set verify off
set feedback off
set sqlcase mixed
REM
REM Define SQLPLUS columnsso that we can use a SELECT statement to assign
REM default values to parameters that were not entered.
REM
col control_file 	new_value 	control_file 		noprint
col dump_script_file 	new_value 	dump_script_file 	noprint
col dump_data_file 	new_value 	dump_data_file		noprint
col max_record_length 	new_value 	max_record_length 	noprint
col view_prefix 	new_value 	view_prefix 		noprint
col t_owner 		new_value 	t_owner 		noprint
col t_name 		new_value 	t_name			noprint
col date_format 	new_value 	date_format 		noprint
col n_width 		new_value 	n_width 		noprint
col long_width 		new_value 	long_width		noprint
col spaces 		new_value 	spaces			noprint

select user t_owner from dual;

accept view_prefix -
       prompt 'Enter the TAB_COLUMNS view to use (ALL): '
accept t_owner -
       prompt 'Enter the table or view owner (&t_owner): '
accept t_name -
       prompt 'Enter the table or view name: '
accept control_file -
       prompt 'Enter the control file name (&t_name..ctl): '
accept dump_script_file -
       prompt 'Enter the dump script file name (&t_name._dump.sql): '
accept dump_data_file -
       prompt 'Enter the dump data file name (&t_name..dat): '
accept max_record_length -
       prompt 'Enter the maximum record length for the dump file (0):'
accept date_format -
       prompt 'Enter the date format (DD-MON-YY HH24:MI:SS): '
accept n_width -
       prompt 'Enter the numeric width (10): '
accept long_width -
      prompt 'Enter the long width (200): '
accept spaces -
       prompt 'Enter the number of spaces between fields (0): '

REM
REM Set defaults for the fields that were not entered.
REM
select	nvl('&view_prefix','ALL') 			view_prefix,
	nvl('&t_owner',user) 				t_owner,
	nvl('&control_file','&t_name..ctl') 		control_file,
	nvl('&dump_script_file','&t_name._dump.sql')	dump_script_file,
	nvl('&dump_data_file','&t_name..dat') 		dump_data_file,
	nvl('&max_record_length','0') 			max_record_length,
	nvl('&date_format','DD-MON-YY HH24:MI:SS') 	date_format,
	nvl('&n_width','10') 				n_width,
	nvl('&long_width','200') 			long_width,
	nvl('&spaces','0') 				spaces
	from dual;
REM
REM Set the file names to lower case
REM
select	lower('&control_file')		control_file,
	lower('&dump_script_file')	dump_script_file,
	lower('&dump_data_file') 	dump_data_file
	from dual;
REM
REM Table1 will have one row for each column in the table. It will the
REM column definition for both the dump script and for control file.
REM
set termout off
drop sequence ctl_temp_insert_seq;
create sequence ctl_temp_insert_seq;
REM
drop table ctl_temp_table1;
create table ctl_temp_table1
	(column_id 	number,
	  column_select varchar2(200),
	  column_def 	varchar2(200),
	  comma_field 	varchar2(1),
	  comma_field2 	varchar2(1));
REM
REM This table will hold the contents of the dump script file.
REM
drop table ctl_temp_table2;
create table ctl_temp_table2
	( column_id	number,
	  column_name 	varchar2(200));
REM
REM This table will be used to build the SQLLOADER control file.
REM
drop table ctl_temp_table3;
create table ctl_temp_table3
	( column_id	number,
	  column_name 	varchar2(200));
REM Here is the PL/SQL block that drives the whole process.
declare
  date_width 		number;
  date_format 		varchar2(50) 	:= '&date_format';
  n_width 		number 		:= &n_width;
  long_width 		number 		:= &long_width;
  spaces		number 		:= &spaces;
  start_pos 		number 		:= 1;
  end_pos 		number;
  column_select 	varchar2 (200);
  column_def 		varchar2 (200);
  comma_field		varchar2 (1);
  datestuff 		varchar2 (100);
  datestuff2 		varchar2 (100);
  t_name 		varchar2(30) 	:= upper('&t_name');
  t_owner 		varchar2(30) 	:= upper('&t_owner');
  test_date 		date;
  temp_id		number;
  concat_num 		number;
  max_record_length 	number 		:= &max_record_length;
  cursor tmp_cursor (towner varchar2, tname varchar2) is
	 select column_id, column_name, data_type, data_length
	 from &view_prefix._tab_columns
	 where owner = towner and
	       table_name = tname
	 order by column_id;
begin
/*                             */
/* we need to find out the maximum length of a date field using the supplied 
*/
/* date format. Hopefully this date is a good test. 
*/
/* 
*/
  test_date := to_date ('28-SEP-3777 23:00','DD-MON-YYYY HH24:MI');
  date_width := length(to_char(test_date,date_format));
  for tmp_record in tmp_cursor(t_owner,t_name) LOOP
        -- By default, use the column name in the SELECT inside the dump file 
      column_select := tmp_record.column_name;
	-- Enclose the column name in double quotes in the control file
      column_def := '"' || tmp_record.column_name || '"';
      comma_field := ',';
      datestuff  := ' ';
      datestuff2 := ' ';
      if tmp_record.data_type = 'DATE' then
         end_pos := start_pos + date_width - 1;

	-- specify the DATE format and the NULLIF clause for DATE fields
        -- DATE "date_format" NULLIF "column_name" = BLANKS
	 comma_field := ' ';
         datestuff := ' DATE "' || date_format || '"';
	 datestuff2 := '    NULLIF "' || tmp_record.column_name || '" = BLANKS';
	-- Have to use TO_CHAR in the dump file to get the proper date format
        -- substr(to_char(column_name,'date_format'),1,date_width)
         column_select := 'substr(to_char(' ||
                          tmp_record.column_name || ',''' || date_format || 
                          '''),1,' || date_width || ')';
      elsif tmp_record.data_type = 'NUMBER' then
            end_pos := start_pos + n_width - 1;

            -- need to set column heading in the dump file
insert into ctl_temp_table2 values
                   (	ctl_temp_insert_seq.nextval,
			'column "'||tmp_record.column_name||'" heading a');
      elsif tmp_record.data_type = 'LONG' then
            end_pos := start_pos + long_width - 1;
     else  end_pos := start_pos + tmp_record.data_length - 1;
      end if;

      -- build the rest of the control file column definition
      column_def := column_def || ' POSITION (' || start_pos || ':' ||
                    end_pos || ')' || datestuff;
      insert into ctl_temp_table1 values (	ctl_temp_insert_seq.nextval,
						column_select,
						column_def,
						comma_field,
						',');
      if tmp_record.data_type = 'DATE' then
         insert into ctl_temp_table1 values
                (ctl_temp_insert_seq.nextval, null, datestuff2, ',', ',');
      end if;
      start_pos := end_pos + spaces + 1; -- get ready for the next column
  end LOOP;
/* 
*/
/* We're getting ready to build the dump file script, so the last column's 
*/
/* comma needs to be changed to a space. 
*/
/* 
*/
  update ctl_temp_table1 set comma_field = ' ', comma_field2 = ' '
         where column_id = (select max(column_id) from ctl_temp_table1);
/*                                                         */
/* If they did not enter a maximum record length, set it to the end_pos. 
*/
/* 
*/
  if max_record_length <= 0 then
     max_record_length := end_pos;
  end if;
/* 
*/
/* Build the dump file script 
*/
/*                                                       */
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set space &spaces');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set linesize ' || max_record_length); 
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set pagesize 0');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set feedback off');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set termout off');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set numwidth &n_width');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set long &long_width');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'spool &dump_data_file');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'select');
  select ctl_temp_insert_seq.nextval into temp_id from dual;
  insert into ctl_temp_table2
         select temp_id + column_id/10000,
		column_select || comma_field2
                from ctl_temp_table1
		where column_select is not null;
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,
	  'from ' || t_owner || '.' || t_name || ';');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'spool off');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set feedback on');
  insert into ctl_temp_table2 values
         (ctl_temp_insert_seq.nextval,'set termout on');
/*                            */
/* Build the first part of the control file. 
*/
/* 
*/
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'load data');
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'infile &dump_data_file');
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'badfile '|| lower(t_name) || '.bad'); 
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'discardfile '|| lower(t_name) ||
'.dis');
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'insert');
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,
	  'concatenate '||ceil(end_pos/max_record_length));
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,
	  'into table ' || t_owner || '.' || t_name);
  insert into ctl_temp_table3 values
         (ctl_temp_insert_seq.nextval,'(');
/* 
*/
/* Now the last column should be followed with a ')' 
*/
/*                                                                      */
  update ctl_temp_table1 set comma_field = ')'
         where column_id = (select max(column_id) from ctl_temp_table1);
end;
/
