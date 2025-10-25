# 23ai / 26ai scripts
Scripts for 23ai / 26ai demos.

STANDARD DISCLAIMER - ANYTHING IN HERE IS USED AT YOUR OWN RISK.

NO WARRANTY OR LIABILITY ETC ETC ETC. SEE THE LICENSE.

Setup
=====

Assumes you have the following:

1) A running version 23ai / 26ai database with full privs to it (SYS, SYSTEM access)
2) A running version 19c / 21c database with full privs to it (SYS, SYSTEM access)

In each database, you need

- A user called DBDEMO password DBDEMO with appropriate privileges (see create_user.sql)
- The HR sample schema is created in each database  (See https://github.com/oracle-samples/db-sample-schemas)
- The SH sample schema is created in each database.  (See https://github.com/oracle-samples/db-sample-schemas)
- The SCOTT sample schema is created in each database. (You can run demobld.sql from this repo)

Connectivity
============

You need an instantclient or similar with tnsnames.ora support. Throughout the scripts
- the TNS alias "db23" will connect to the correct pdb in the running active 23ai database
- the TNS alias "db23root" will connect to the root container in the running active 23ai database
- the TNS alias "db19" will connect to the running 19c or 21c database (can be pluggable or old-style)

With the scripts, connections as admin level accounts are done as:

- sys/SYS_PASSWORD as sysdba
- sys/SYSTEM_PASSWORD as sysdba

so you can (case-sensitive) search for those 2 password strings to edit to match your environment


Note
====

Some of the demos are unlikely to work due to dependencies on external objects not present
in this git repo due to licensing restrictions, but most of them should be fine.

Similarly, some demos have been omitted because they have not officially been released into
the current production release of Oracle 23ai / 26ai. They will be marked as "missing" when the
menu is launched

Usage
=====
Start SQL*Plus or SQLcl and run: @launch_23ai

To exit the menu, enter option "98"