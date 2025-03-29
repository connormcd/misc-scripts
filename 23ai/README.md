# 23ai scripts
Scripts for 23ai demos.

Standard disclaimer - anything in here can be used at your own risk.

No warranty or liability etc etc etc. See the license.

Setup
=====

Assumes you have the following:

- A user called DBDEMO password DBDEMO with appropriate privileges (see create_user.sql)
- The TNS alias "db23" will connect to a running active 23ai database
- The TNS alias "db19" will connect to a running 19c or 21c database
- The HR sample schema is created in each database.
- The SH sample schema is created in each database.
- The SCOTT sample schema is created in each database.

Some of the demos are unlikely to work due to dependencies on external objects not present
in this git repo due to licensing restrictions, but most of them should be fine.

Usage
=====
Start SQL*Plus or SQLcl and run: @launch_23ai

