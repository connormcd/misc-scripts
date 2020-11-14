column major      format a8
column wait_event format a40 trunc
column seconds    format 9999999
column pct        justify right
break on major skip 1 on minor

select
  substr(n_major, 3)  major,
  substr(n_minor, 3)  minor,
  wait_event,
  round(time/100)  seconds
from
  (
    select /*+ ordered use_hash(b) */
      '1 CPU time'  n_major,
      decode(t.ksusdnam,
	'redo size', '2 reloads',
	'parse time cpu', '1 parsing',
	'3 execution'
      )  n_minor,
      'n/a'  wait_event,
      decode(t.ksusdnam,
	'redo size', nvl(r.time, 0),
	'parse time cpu', t.ksusgstv - nvl(b.time, 0),
	t.ksusgstv - nvl(b.time, 0) - nvl(r.time, 0)
      )  time
    from
      sys.x_$ksusgsta  t,
      (
	select /*+ ordered use_nl(s) */		-- star query: few rows from d and b
	  s.ksusestn,				-- statistic#
	  sum(s.ksusestv)  time			-- time used by backgrounds
	from
	  sys.x_$ksusd  d,			-- statname
	  sys.x_$ksuse  b,			-- session
	  sys.x_$ksusesta  s			-- sesstat
	where
	  d.ksusdnam in (
	    'parse time cpu',
	    'CPU used by this session') and
	  bitand(b.ksuseflg,19) = 17 and	-- background
	  s.ksusestn = d.indx and
	  s.indx = b.indx
	group by
	  s.ksusestn
      )  b,
      (
	select /*+ no_merge */
	  ksusgstv *				-- parse cpu time *
	  kglstrld /				-- SQL AREA reloads /
	  (1 + kglstget - kglstght)		-- SQL AREA misses
	    time
	from
	  sys.x_$kglst  k,
	  sys.x_$ksusgsta  g
	where
	  k.indx = 0 and
	  g.ksusdnam = 'parse time cpu'
      )  r
    where
      t.ksusdnam in (
	'redo size',				-- arbitrary: to get a row to replace
	'parse time cpu',			--   with the 'reload cpu time'
	'CPU used by this session') and
      b.ksusestn (+) = t.indx
    union all
    select
      decode(n_minor,
	'1 normal I/O',		'2 disk I/O',
	'2 full scans',		'2 disk I/O',
	'3 direct I/O',		'2 disk I/O',
	'4 BFILE reads',	'2 disk I/O',
	'5 other I/O',		'2 disk I/O',
	'1 DBWn writes',	'3 waits',
	'2 LGWR writes',	'3 waits',
	'3 ARCn writes',	'3 waits',
	'4 enqueue locks',	'3 waits',
	'5 PCM locks',		'3 waits',
	'6 other locks',	'3 waits',
	'1 commits',		'4 latency',
	'2 network',		'4 latency',
	'3 file ops',		'4 latency',
	'4 process ctl',	'4 latency',
	'5 global locks',	'4 latency',
	'6 misc',		'4 latency'
      )  n_major,
      n_minor,
      wait_event,
      time
    from
      (
	select /*+ ordered use_hash(b) use_nl(d) */
	  decode(
	    d.kslednam,
	    					-- disk I/O
	    'db file sequential read',			'1 normal I/O',
	    'db file scattered read',			'2 full scans',
	    'BFILE read',				'4 BFILE reads',
	    'KOLF: Register LFI read',			'4 BFILE reads',
	    'log file sequential read',			'5 other I/O',
	    'log file single write',			'5 other I/O',
						-- resource waits
	    'checkpoint completed',			'1 DBWn writes',
	    'free buffer waits',			'1 DBWn writes',
	    'write complete waits',			'1 DBWn writes',
	    'local write wait',				'1 DBWn writes',
	    'log file switch (checkpoint incomplete)',	'1 DBWn writes',
	    'rdbms ipc reply',				'1 DBWn writes',
	    'log file switch (archiving needed)',	'3 ARCn writes',
	    'enqueue',					'4 enqueue locks',
	    'buffer busy due to global cache',		'5 PCM locks',
	    'global cache cr request',			'5 PCM locks',
	    'global cache lock cleanup',		'5 PCM locks',
	    'global cache lock null to s',		'5 PCM locks',
	    'global cache lock null to x',		'5 PCM locks',
	    'global cache lock s to x',			'5 PCM locks',
	    'lock element cleanup',			'5 PCM locks',
	    'checkpoint range buffer not saved',	'6 other locks',
	    'dupl. cluster key',			'6 other locks',
	    'PX Deq Credit: free buffer',		'6 other locks',
	    'PX Deq Credit: need buffer',		'6 other locks',
	    'PX Deq Credit: send blkd',			'6 other locks',
	    'PX qref latch',				'6 other locks',
	    'Wait for credit - free buffer',		'6 other locks',
	    'Wait for credit - need buffer to send',	'6 other locks',
	    'Wait for credit - send blocked',		'6 other locks',
	    'global cache freelist wait',		'6 other locks',
	    'global cache lock busy',			'6 other locks',
	    'index block split',			'6 other locks',
	    'lock element waits',			'6 other locks',
	    'parallel query qref latch',		'6 other locks',
	    'pipe put',					'6 other locks',
	    'rdbms ipc message block',			'6 other locks',
	    'row cache lock',				'6 other locks',
	    'sort segment request',			'6 other locks',
	    'transaction',				'6 other locks',
	    'unbound tx',				'6 other locks',
						-- routine waits
	    'log file sync',				'1 commits',
	    'name-service call wait',			'2 network',
	    'Test if message present',			'4 process ctl',
	    'process startup',				'4 process ctl',
	    'read SCN lock',				'5 global locks',
	    decode(substr(d.kslednam, 1, instr(d.kslednam, ' ')),
						-- disk I/O
	      'direct ',				'3 direct I/O',
	      'control ',				'5 other I/O',
	      'db ',					'5 other I/O',
						-- resource waits
	      'log ',					'2 LGWR writes',
	      'buffer ',				'6 other locks',
	      'free ',					'6 other locks',
	      'latch ',					'6 other locks',
	      'library ',				'6 other locks',
	      'undo ',					'6 other locks',
						-- routine waits
	      'SQL*Net ',				'2 network',
	      'BFILE ',					'3 file ops',
	      'KOLF: ',					'3 file ops',
	      'file ',					'3 file ops',
	      'KXFQ: ',					'4 process ctl',
	      'KXFX: ',					'4 process ctl',
	      'PX ',					'4 process ctl',
	      'Wait ',					'4 process ctl',
	      'inactive ',				'4 process ctl',
	      'multiple ',				'4 process ctl',
	      'parallel ',				'4 process ctl',
	      'DFS ',					'5 global locks',
	      'batched ',				'5 global locks',
	      'on-going ',				'5 global locks',
	      'global ',				'5 global locks',
	      'wait ',					'5 global locks',
	      'writes ',				'5 global locks',
	      						'6 misc'
	    )
	  )  n_minor,
	  d.kslednam  wait_event,		-- event name
	  i.kslestim - nvl(b.time, 0)  time	-- non-background time
	from
	  sys.x_$kslei  i,			-- system events
	  (
	    select /*+ ordered use_hash(e) */	-- no fixed index on e
	      e.kslesenm,			-- event number
	      sum(e.kslestim)  time		-- time waited by backgrounds
	    from
	      sys.x_$ksuse  s,			-- sessions
	      sys.x_$ksles  e			-- session events
	    where
	      bitand(s.ksuseflg,19) = 17 and	-- background session
	      e.kslessid = s.indx
	    group by
	      e.kslesenm
	    having
	      sum(e.kslestim) > 0
	  )  b,
	  sys.x_$ksled  d
	where
	  i.kslestim > 0 and
	  b.kslesenm (+) = i.indx and
	  nvl(b.time, 0) < i.kslestim and
	  d.indx = i.indx and
	  d.kslednam not in (
	    'Null event',
	    'KXFQ: Dequeue Range Keys - Slave',
	    'KXFQ: Dequeuing samples',
	    'KXFQ: kxfqdeq - dequeue from specific qref',
	    'KXFQ: kxfqdeq - normal deqeue',
	    'KXFX: Execution Message Dequeue - Slave',
	    'KXFX: Parse Reply Dequeue - Query Coord',
	    'KXFX: Reply Message Dequeue - Query Coord',
	    'PAR RECOV : Dequeue msg - Slave',
	    'PAR RECOV : Wait for reply - Query Coord',
	    'Parallel Query Idle Wait - Slaves',
	    'PL/SQL lock timer',
	    'PX Deq: Execute Reply',
	    'PX Deq: Execution Msg',
	    'PX Deq: Index Merge Execute',
	    'PX Deq: Index Merge Reply',
	    'PX Deq: Par Recov Change Vector',
	    'PX Deq: Par Recov Execute',
	    'PX Deq: Par Recov Reply',
	    'PX Deq: Parse Reply',
	    'PX Deq: Table Q Get Keys',
	    'PX Deq: Table Q Normal',
	    'PX Deq: Table Q Sample',
	    'PX Deq: Table Q qref',
	    'PX Deq: Txn Recovery Reply',
	    'PX Deq: Txn Recovery Start',
	    'PX Deque wait',
	    'PX Idle Wait',
	    'Replication Dequeue',
	    'Replication Dequeue ',
	    'SQL*Net message from client',
	    'SQL*Net message from dblink',
	    'debugger command',
	    'parallel query dequeue wait',
	    'pipe get',
	    'queue messages',
	    'secondary event',
	    'single-task message',
	    'slave wait'
	  ) and
	  d.kslednam not like 'resmgr:%'
      )
  )
order by
  n_major,
  n_minor,
  time desc
/

