drop user dbdemo cascade;
create user dbdemo identified by dbdemo;
grant dba, select any table, select any dictionary, execute any procedure to dbdemo;
