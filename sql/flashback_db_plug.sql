set echo on
alter session set container = pdb2;
alter pluggable database close abort;
flashback pluggable database to restore point &1;
alter pluggable database open resetlogs;
exit
