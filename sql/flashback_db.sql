set echo on
shutdown immediate
startup mount
flashback database to restore point &1;
alter database open resetlogs;
exit
