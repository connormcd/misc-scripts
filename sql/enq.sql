column resource format a24
column sid format 9999 justify right
col obj format a30 trunc
break on resource
set lines 200


with s as ( select /*+ materialize */ * from gv$session ),
 l as ( select /*+ materialize */ * from gv$lock )
select /*+ leading(l s) full(l) full(s) */
  s.sid, 
  s.serial#,
  s.program,
  l.type || '-' || l.id1 || '-' || l.id2  "RESOURCE",
  decode(
    l.lmode,
    1, '      N',
    2, '     SS',
    3, '     SX',
    4, '      S',
    5, '    SSX',
    6, '      X'
  )  holding,
  decode(
    l.request,
    1, '      N',
    2, '     SS',
    3, '     SX',
    4, '      S',
    5, '    SSX',
    6, '      X'
  )  wanting,
  l.ctime  seconds,
decode(l.type,
'BL',' Buffer Cache Management',
'BR',' Backup/Restore',
'CF',' Controlfile Transaction',
'CI',' Cross-instance Call Invocation',
'CU',' Bind Enqueue',
'DF',' Datafile',
'DL',' Direct Loader Index Creation',
'DM',' Database Mount',
'DR',' Distributed Recovery Process',
'DX',' Distributed Transaction',
'FP',' File Object',
'FS',' File Set',
'HW',' High-Water Lock',
'IN',' Instance Number',
'IR',' Instance Recovery',
'IS',' Instance State',
'IV',' Library Cache Invalidation',
'JI',' Enqueue used during AJV snapshot refresh',
'JQ',' Job Queue',
'KK',' Redo Log "Kick"',
'KO',' Multiple Object Checkpoint',
'KP',' contention in Oracle Data Pump startup and shutdown processes',
'LS',' Log Start or Switch',
'MM',' Mount Definition',
'MR',' Media Recovery',
'PE',' ALTER SYSTEM SET PARAMETER = VALUE',
'PF',' Password File',
'PI',' Parallel Slaves',
'PR',' Process Startup',
'PS',' Parallel Slave Synchronization',
'RO',' Object Reuse',
'RT',' Redo Thread',
'RW',' Row Wait',
'SC',' System Commit Number',
'SM',' SMON',
'SN',' Sequence Number',
'SQ',' Sequence Number Enqueue',
'SR',' Synchronized Replication',
'SS',' Sort Segment',
'ST',' Space Management Transaction',
'SV',' Sequence Number Value',
'TA',' Transaction Recovery',
'TC',' Thread Checkpoint',
'TE',' Extend Table',
'TM',' DML Enqueue',
'TO',' Temporary Table Object Enqueue',
'TS',' Temporary Segment (also TableSpace)',
'TT',' Temporary Table',
'TX',' Transaction',
'UL',' User-defined Locks',
'UN',' User Name',
'US',' Undo Segment',
'WL',' Being Written Redo Log',
'XA',' Instance Attribute Lock',
'XI',' Instance Registration Lock',
'<unknown>') ldesc
from
--  sys.gv_$lock l,  sys.gv_$session s
l ,s
where l.type not in ('MR','TO','AE','CF','RT','CO','DM','JS','PS','RD','RS','KD','KT','PW','XR','TS')
--and   l.ctime > 0 
--and   l.request > 0
and s.sid = l.sid 
and   s.inst_id = l.inst_id
order by
  l.type || '-' || l.id1 || '-' || l.id2,
  sign(l.request),
  l.ctime desc
/

col sid clear

