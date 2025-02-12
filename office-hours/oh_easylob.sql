REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
@drop t
@drop t1
@drop seq
set pages 999
set termout on
clear screen
set echo on
create sequence seq;
create table t ( b blob );
pause
host start c:\tmp\bailey.jpg
pause
declare
  l_bfile   bfile;
  l_blob    blob;
  l_tgt_idx int := 1;
  l_src_idx int := 1;
begin
  dbms_lob.createtemporary(l_blob,true);
  l_bfile := bfilename('TEMP', 'bailey.jpg');
  dbms_lob.fileopen(l_bfile, dbms_lob.file_readonly);
  dbms_lob.loadblobfromfile (
    dest_lob    => l_blob,
    src_bfile   => l_bfile,
    amount      => dbms_lob.lobmaxsize,
    dest_offset => l_tgt_idx,
    src_offset  => l_src_idx);
  dbms_lob.fileclose(l_bfile);
  insert into t values (l_blob);
  commit;
  dbms_lob.freetemporary(l_blob);
end;
/
pause
clear screen
create or replace
procedure multimedia_engine(
             p_blob in out nocopy blob, 
             p_parms varchar2, 
             p_new_blob out blob, 
             p_extension varchar2 default 'jpg') is
  l_chunk     raw(32767);
  l_chunksize int := 32767;
  l_file      utl_file.file_type;
  l_offset    int := 1;
  l_bsize     int;
  l_seq       int;
  l_bfile     bfile;
  
  l_parms     varchar2(512) := p_parms;
  l_new_file  varchar2(256);

  l_tgt_idx   int := 1;
  l_src_idx   int := 1;
  l_new_blob  blob;
#pause
begin
  l_seq   := seq.nextval;    
  l_bsize := dbms_lob.getlength(p_blob);
  l_file  := utl_file.fopen('TEMP','tmp'||l_seq||'.'||p_extension,'wb', 32767);
  while l_offset <= l_bsize loop
    dbms_lob.read(p_blob, l_chunksize, l_offset, l_chunk);
    utl_file.put_raw(l_file, l_chunk, true);
    l_offset := l_offset + l_chunksize;
  end loop;
  utl_file.fclose(l_file);

  l_file := utl_file.fopen('TEMP','tmp'||l_seq||'.txt','w');
  utl_file.put_line(l_file,'tmp'||l_seq||'.'||p_extension||';'||l_parms);
  utl_file.fclose(l_file);
#pause

  execute immediate replace(q'{
    select ffmpeg_name
    from   external (
             ( ffmpeg_name varchar2(512) )
             type oracle_loader
             default directory "TEMP"
             access parameters
             ( records delimited by newline
               preprocessor  bin:'run_ffmpeg.bat'
               nobadfile 
               nologfile 
               nodiscardfile 
              )  
              location ( '@@@' )
       reject limit unlimited ) ext
    }','@@@','tmp'||l_seq||'.txt') into l_new_file;
#pause
#host cat x:\temp\run_ffmpeg.bat
#pause

  dbms_lob.createtemporary(l_new_blob,true);
  l_bfile := bfilename('TEMP', l_new_file);
  dbms_lob.fileopen(l_bfile, dbms_lob.file_readonly);
  dbms_lob.loadblobfromfile(
    dest_lob=>l_new_blob,
    src_bfile=>l_bfile,
    amount=>dbms_lob.lobmaxsize,
    dest_offset=>l_tgt_idx,
    src_offset =>l_src_idx
    );
  dbms_lob.fileclose(l_bfile);
  p_new_blob := l_new_blob;
  dbms_lob.freetemporary(l_new_blob);

#pause
  utl_file.fremove('TEMP','tmp'||l_seq||'.txt');
  utl_file.fremove('TEMP','tmp'||l_seq||'.'||p_extension);
  utl_file.fremove('TEMP','ffmpeg-tmp'||l_seq||'.'||p_extension);
exception
  when others then
    if utl_file.is_open(l_file) then
      utl_file.fclose(l_file);
    end if;
    raise;
end;
/
pause
clear screen
create table t1 ( b blob );
pause
declare  
  b_before blob;
  b_after  blob;
begin
  select b into b_before from t;
  insert into t1 values ( empty_blob() ) 
  returning b into b_after;
  
  multimedia_engine(b_before,'-filter:v "hflip,vflip"',b_after);
  
  update t1 set b = b_after;
  commit;
end;
/
pause
clear screen
select dbms_lob.getlength(b) from t1;
pause
declare
  l_blob      blob;
  l_chunk     raw(32767);
  l_chunksize int := 32767;
  l_file      utl_file.file_type;
  l_offset    int := 1;
  l_bsize     int;
  l_bfile     bfile;
begin
  select b into l_blob from t1;
  l_bsize := dbms_lob.getlength(l_blob);
  l_file  := utl_file.fopen('TEMP','bailey_flipped.jpg','wb', 32767);
  while l_offset <= l_bsize loop
    dbms_lob.read(l_blob, l_chunksize, l_offset, l_chunk);
    utl_file.put_raw(l_file, l_chunk, true);
    l_offset := l_offset + l_chunksize;
  end loop;
  utl_file.fclose(l_file);
end;
/
pause
host start c:\tmp\bailey_flipped.jpg
pause
clear screen
--  dbms_lob.createtemporary(l_new_blob,true);
--  p_new_blob := to_blob(bfilename('TEMP', l_new_file));
--  
--  l_bfile := bfilename('TEMP', l_new_file);
--  dbms_lob.fileopen(l_bfile, dbms_lob.file_readonly);
--  dbms_lob.loadblobfromfile(
--    dest_lob=>l_new_blob,
--    src_bfile=>l_bfile,
--    amount=>dbms_lob.lobmaxsize,
--    dest_offset=>l_tgt_idx,
--    src_offset =>l_src_idx
--    );
--  dbms_lob.fileclose(l_bfile);
--  p_new_blob := l_new_blob;
--  dbms_lob.freetemporary(l_new_blob);
pause
--
-- "What the hell?"
--
pause
delete t;
pause
insert into t
values ( to_blob(bfilename('TEMP','bailey.jpg')));
commit;
pause;
select dbms_lob.getlength(b) from t;
