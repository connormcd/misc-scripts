# 23ai / 26ai scripts
Scripts for 23ai / 26ai demos.

STANDARD DISCLAIMER - ANYTHING IN HERE IS USED AT YOUR OWN RISK.

NO WARRANTY OR LIABILITY ETC ETC ETC. SEE THE LICENSE.

Setup
=====

Assumes you have the following:

- A user called DBDEMO password DBDEMO with appropriate privileges (see create_user.sql)
- The TNS alias "db23" will connect to a running active 23ai database
- The TNS alias "db19" will connect to a running 19c or 21c database
- The HR sample schema is created in each database  (See https://github.com/oracle-samples/db-sample-schemas)
- The SH sample schema is created in each database.  (See https://github.com/oracle-samples/db-sample-schemas)
- The SCOTT sample schema is created in each database. (You can run demobld.sql from this repo)

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