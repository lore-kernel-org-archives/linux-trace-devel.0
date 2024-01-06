Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7631872
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104F9C433C8;
	Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLyEY-00000001An8-0TZg;
	Fri, 05 Jan 2024 23:24:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd sqlhist: Add 'sqlhist' command
Date: Fri,  5 Jan 2024 23:22:28 -0500
Message-ID: <20240106042428.279706-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240106042428.279706-1-rostedt@goodmis.org>
References: <20240106042428.279706-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the 'sqlhist' command that uses tracefs_sql to create histograms or
synthetic event. This is taken from the libtracefs tracefs_sql() sample that
does basically the same thing.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-sqlhist.1.txt         | 339 ++++++++++++++++++
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-sqlhist.c                      | 246 +++++++++++++
 tracecmd/trace-usage.c                        |  20 +-
 6 files changed, 608 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-sqlhist.1.txt
 create mode 100644 tracecmd/trace-sqlhist.c

diff --git a/Documentation/trace-cmd/trace-cmd-sqlhist.1.txt b/Documentation/trace-cmd/trace-cmd-sqlhist.1.txt
new file mode 100644
index 000000000000..f2b1ce47ad69
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd-sqlhist.1.txt
@@ -0,0 +1,339 @@
+TRACE-CMD-SQLHIST(1)
+====================
+
+NAME
+----
+trace-cmd-sqlhist - Use SQL language to create / show creation of tracefs histograms and synthetic events
+
+SYNOPSIS
+--------
+*trace-cmd sqlhist* ['OPTIONS'] ['SQL-select-command']
+
+DESCRIPTION
+-----------
+The trace-cmd sqlhist(1) will take an SQL like statement to create tracefs histograms and
+synthetic events that can perform various actions for various handling of the
+data.
+
+The tracefs file system interfaces with the Linux tracing infrastructure that
+has various dynamic and static events through out the kernel. Each of these
+events can have a "histogram" attached to it, where the fields of the event
+will define the buckets of the histogram.
+
+A synthetic event is a way to attach two separate events and use the fields
+and time stamps of those events to create a new dynamic event. This new
+dynamic event is call a synthetic event. The fields of each event can have
+simple calculations done on them where, for example, the delta between
+a field of one event to a field of the other event can be taken. This also
+works for the time stamps of the events where the time delta between the
+two events can also be extracted and placed into the synthetic event.
+
+Other actions can be done from the fields of the events. A snapshot can
+be taken of the kernel ring buffer a variable used in the synthetic
+event creating hits a max, or simply changes.
+
+The commands to create histograms and synthetic events are complex and
+not easy to remember. *trace-cmd sqlhist* is used to convert SQL syntax into the
+commands needed to create the histogram or synthetic event.
+
+The *SQL-select-command* is a SQL string defined by *tracefs_sqlhist*(3).
+
+Note, this must be run as root (or sudo) as interacting with the tracefs
+directory requires root privilege, unless the *-t* option is given with
+a copy of the _tracefs_ directory and its events.
+
+OPTIONS
+-------
+*-n* 'name'::
+    The name of the synthetic event to create. This event can then be
+    used like any other event, and enabled via *trace-cmd record*(1).
+
+*-t* 'tracefs-dir'::
+    In order to test this out as non root user, a copy of the tracefs directory
+    can be used, and passing that directory with this option will allow
+    the program to work. Obviously, *-e* will not work as non-root because
+    it will not be able to execute.
+
+    # mkdir /tmp/tracing
+    # cp -r /sys/kernel/tracing/events /tmp/tracing
+    # exit
+    $ trace-cmd sqlhist -t /tmp/tracing ...
+
+*-e*::
+    Not only display the commands to create the histogram, but also execute them.
+    This requires root privilege.
+
+*-f* 'file'::
+    Instead of reading the SQL commands from the command line, read them from
+    _file_. If _file_ is '-' then read from standard input.
+
+*-m* 'var'::
+    Do the given action when the variable _var_ hits a new maximum. This can
+    not be used with *-c*. The _var_ must be defined in the *SQL-select-command*.
+
+*-c* 'var'::
+    Do the given action when the variable _var_ changes its value. This can
+    not be used with *-m*. The _var_ must be defined in the *SQL-select-command*.
+
+*-s*::
+    Perform a snapshot instead of calling the synthetic event.
+
+*-T*::
+    Perform both a snapshot and trace the synthetic event.
+
+*-S* 'fields[,fields]'::
+    Save the given fields. The fields must be fields of the "end" event given
+    in the *SQL-select-command*
+
+*-B* 'instance'::
+    For simple statements that only produce a histogram, the instance given here
+    will be where the histogram will be created. This is ignored for full synthetic
+    event creation, as sythetic events have a global affect on all tracing instances,
+    where as, histograms only affect a single instance.
+
+EXAMPLES
+--------
+
+As described above, for testing purposes, make a copy of the event directory:
+[source, c]
+--
+   $ mkdir /tmp/tracing
+   $ sudo cp -r /sys/kernel/tracing/events /tmp/tracing/
+   $ sudo chmod -R 0644 /tmp/tracing/
+--
+
+For an example of simple histogram output using the copy of the tracefs directory.
+[source, c]
+--
+   $ trace-cmd sqlhist -t /tmp/tracing/ 'SELECT CAST(call_site as SYM-OFFSET), bytes_req, CAST(bytes_alloc AS _COUNTER_) FROM kmalloc'
+--
+
+Produces the output:
+[source, c]
+--
+   echo 'hist:keys=call_site.sym-offset,bytes_req:vals=bytes_alloc' > /sys/kernel/tracing/events/kmem/kmalloc/trigger
+--
+
+Which could be used by root:
+[source, c]
+--
+   # echo 'hist:keys=call_site.sym-offset,bytes_req:vals=bytes_alloc' > /sys/kernel/tracing/events/kmem/kmalloc/trigger
+   # cat /sys/kernel/tracing/events/kmem/kmalloc/hist
+# event histogram
+#
+# trigger info: hist:keys=call_site.sym-offset,bytes_req:vals=hitcount,bytes_alloc:sort=hitcount:size=2048 [active]
+#
+
+{ call_site: [ffffffff813f8d8a] load_elf_phdrs+0x4a/0xb0                               , bytes_req:        728 } hitcount:          1  bytes_alloc:       1024
+{ call_site: [ffffffffc0c69e74] nf_ct_ext_add+0xd4/0x1d0 [nf_conntrack]                , bytes_req:        128 } hitcount:          1  bytes_alloc:        128
+{ call_site: [ffffffff818355e6] dma_resv_get_fences+0xf6/0x440                         , bytes_req:          8 } hitcount:          1  bytes_alloc:          8
+{ call_site: [ffffffffc06dc73f] intel_gt_get_buffer_pool+0x15f/0x290 [i915]            , bytes_req:        424 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffff813f8d8a] load_elf_phdrs+0x4a/0xb0                               , bytes_req:        616 } hitcount:          1  bytes_alloc:       1024
+{ call_site: [ffffffff8161a44c] __sg_alloc_table+0x11c/0x180                           , bytes_req:         32 } hitcount:          1  bytes_alloc:         32
+{ call_site: [ffffffffc070749d] shmem_get_pages+0xad/0x5d0 [i915]                      , bytes_req:         16 } hitcount:          1  bytes_alloc:         16
+{ call_site: [ffffffffc07507f5] intel_framebuffer_create+0x25/0x60 [i915]              , bytes_req:        408 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffffc06fc20f] eb_parse+0x34f/0x910 [i915]                            , bytes_req:        408 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffffc0700ebd] i915_gem_object_get_pages_internal+0x5d/0x270 [i915]   , bytes_req:         16 } hitcount:          1  bytes_alloc:         16
+{ call_site: [ffffffffc0771188] intel_frontbuffer_get+0x38/0x220 [i915]                , bytes_req:        400 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffff8161a44c] __sg_alloc_table+0x11c/0x180                           , bytes_req:        128 } hitcount:          1  bytes_alloc:        128
+{ call_site: [ffffffff813f8f45] load_elf_binary+0x155/0x1680                           , bytes_req:         28 } hitcount:          1  bytes_alloc:         32
+{ call_site: [ffffffffc07038c8] __assign_mmap_offset+0x208/0x3d0 [i915]                , bytes_req:        288 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffff813737b2] alloc_bprm+0x32/0x2f0                                  , bytes_req:        416 } hitcount:          1  bytes_alloc:        512
+{ call_site: [ffffffff813f9027] load_elf_binary+0x237/0x1680                           , bytes_req:         64 } hitcount:          1  bytes_alloc:         64
+{ call_site: [ffffffff8161a44c] __sg_alloc_table+0x11c/0x180                           , bytes_req:         64 } hitcount:          1  bytes_alloc:         64
+{ call_site: [ffffffffc040ffe7] drm_vma_node_allow+0x27/0xe0 [drm]                     , bytes_req:         40 } hitcount:          2  bytes_alloc:        128
+{ call_site: [ffffffff813cda98] __do_sys_timerfd_create+0x58/0x1c0                     , bytes_req:        336 } hitcount:          2  bytes_alloc:       1024
+{ call_site: [ffffffff818355e6] dma_resv_get_fences+0xf6/0x440                         , bytes_req:         40 } hitcount:          2  bytes_alloc:        128
+{ call_site: [ffffffff8139b75a] single_open+0x2a/0xa0                                  , bytes_req:         32 } hitcount:          2  bytes_alloc:         64
+{ call_site: [ffffffff815df715] bio_kmalloc+0x25/0x80                                  , bytes_req:        136 } hitcount:          2  bytes_alloc:        384
+{ call_site: [ffffffffc071e5cd] i915_vma_work+0x1d/0x50 [i915]                         , bytes_req:        416 } hitcount:          3  bytes_alloc:       1536
+{ call_site: [ffffffff81390d0d] alloc_fdtable+0x4d/0x100                               , bytes_req:         56 } hitcount:          3  bytes_alloc:        192
+{ call_site: [ffffffffc06ff65f] i915_gem_do_execbuffer+0x158f/0x2440 [i915]            , bytes_req:         16 } hitcount:          4  bytes_alloc:         64
+{ call_site: [ffffffff8137713c] alloc_pipe_info+0x5c/0x230                             , bytes_req:        384 } hitcount:          5  bytes_alloc:       2560
+{ call_site: [ffffffff813771b4] alloc_pipe_info+0xd4/0x230                             , bytes_req:        640 } hitcount:          5  bytes_alloc:       5120
+{ call_site: [ffffffff81834cdb] dma_resv_list_alloc+0x1b/0x40                          , bytes_req:         40 } hitcount:          6  bytes_alloc:        384
+{ call_site: [ffffffff81834cdb] dma_resv_list_alloc+0x1b/0x40                          , bytes_req:         56 } hitcount:          9  bytes_alloc:        576
+{ call_site: [ffffffff8120086e] tracing_map_sort_entries+0x9e/0x3e0                    , bytes_req:         24 } hitcount:         60  bytes_alloc:       1920
+
+Totals:
+    Hits: 122
+    Entries: 30
+    Dropped: 0
+--
+
+Note, although the examples use uppercase for the SQL keywords, they do not have
+to be. 'SELECT' could also be 'select' or even 'sElEcT'.
+
+By using the full SQL language, synthetic events can be made and processed.
+For example, using *trace-cmd sqlhist* along with *trace-cmd record*(1), wake up latency can
+be recorded by creating a synthetic event by attaching the _sched_waking_
+and the _sched_switch_ events.
+
+[source, c]
+--
+  # trace-cmd sqlhist -n wakeup_lat -e -T -m lat 'SELECT end.next_comm AS comm, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat FROM ' \
+    'sched_waking AS start JOIN sched_switch AS end ON start.pid = end.next_pid WHERE end.next_prio < 100 && end.next_comm == "cyclictest"'
+  # trace-cmd start -e all -e wakeup_lat -R stacktrace
+  # cyclictest -l 1000 -p80 -i250  -a -t -q -m -d 0 -b 1000 --tracemark
+  # trace-cmd show -s | tail -30
+          <idle>-0       [002] dNh4 23454.902246: sched_wakeup: comm=cyclictest pid=12272 prio=120 target_cpu=002
+          <idle>-0       [005] ...1 23454.902246: cpu_idle: state=4294967295 cpu_id=5
+          <idle>-0       [007] d..1 23454.902246: cpu_idle: state=0 cpu_id=7
+          <idle>-0       [002] dNh1 23454.902247: hrtimer_expire_exit: hrtimer=0000000037956dc2
+          <idle>-0       [005] d..1 23454.902248: cpu_idle: state=0 cpu_id=5
+          <idle>-0       [002] dNh1 23454.902248: write_msr: 6e0, value 4866ce957272
+          <idle>-0       [006] ...1 23454.902248: cpu_idle: state=4294967295 cpu_id=6
+          <idle>-0       [002] dNh1 23454.902249: local_timer_exit: vector=236
+          <idle>-0       [006] d..1 23454.902250: cpu_idle: state=0 cpu_id=6
+          <idle>-0       [002] .N.1 23454.902250: cpu_idle: state=4294967295 cpu_id=2
+          <idle>-0       [002] dN.1 23454.902251: rcu_utilization: Start context switch
+          <idle>-0       [002] dN.1 23454.902252: rcu_utilization: End context switch
+          <idle>-0       [001] ...1 23454.902252: cpu_idle: state=4294967295 cpu_id=1
+          <idle>-0       [002] dN.3 23454.902253: prandom_u32: ret=3692516021
+          <idle>-0       [001] d..1 23454.902254: cpu_idle: state=0 cpu_id=1
+          <idle>-0       [002] d..2 23454.902254: sched_switch: prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=cyclictest next_pid=12275 next_prio=19
+          <idle>-0       [002] d..4 23454.902256: wakeup_lat: next_comm=cyclictest lat=17
+          <idle>-0       [002] d..5 23454.902258: <stack trace>
+ => trace_event_raw_event_synth
+ => action_trace
+ => event_hist_trigger
+ => event_triggers_call
+ => trace_event_buffer_commit
+ => trace_event_raw_event_sched_switch
+ => __traceiter_sched_switch
+ => __schedule
+ => schedule_idle
+ => do_idle
+ => cpu_startup_entry
+ => secondary_startup_64_no_verify
+--
+
+Here's the options for above example explained:
+
+ *-n wakeup_lat* ::
+     Name the synthetic event to use *wakeup_lat*.
+
+ *-e*::
+     Execute the commands that are printed.
+
+ *-T*::
+     Perform both a trace action and then a snapshot action (swap the buffer into the static 'snapshot' buffer).
+
+ *-m lat*::
+     Trigger the actions whenever 'lat' hits a new maximum value.
+
+Now a breakdown of the SQL statement:
+[source, c]
+--
+ 'SELECT end.next_comm AS comm, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat FROM ' \
+    'sched_waking AS start JOIN sched_switch AS end ON start.pid = end.next_pid WHERE end.next_prio < 100 && end.next_comm == "cyclictest"'
+--
+ *end.next_comm AS comm*::
+   Save the 'sched_switch' field *next_comm* and place it into the *comm* field of the 'wakeup_lat' synthetic event.
+
+ *(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat*::
+   Take the delta of the time stamps from the 'sched_switch' event and the 'sched_waking' event.
+   As time stamps are usually recorded in nanoseconds, *TIMESTAMP* would give the full nanosecond time stamp,
+   but here, the *TIMESTAMP_USECS* will truncate it into microseconds. The value is saved in the
+   variable *lat*, which will also be recorded in the synthetic event.
+
+ *FROM 'sched_waking' AS start JOIN sched_switch AS end ON start.pid = end.next_pid*::
+   Create the synthetic event by joining _sched_waking_ to _sched_switch_, matching
+   the _sched_waking_ 'pid' field with the _sched_switch_ 'next_pid' field.
+   Also make *start* an alias for _sched_waking_ and *end* an alias for _sched_switch_
+   which then an use *start* and *end* as a subsitute for _sched_waking_ and _sched_switch_
+   respectively through out the rest of the SQL statement.
+
+ *WHERE end.next_prio < 100 && end.next_comm == "cyclictest"*::
+   Filter the logic where it executes only if _sched_waking_ 'next_prio' field
+   is less than 100. (Note, in the Kernel, priorities are inverse, and the real-time
+   priorities are represented from 0-100 where 0 is the highest priority).
+   Also only trace when the 'next_comm' (the task scheduling in) of the _sched_switch_
+   event has the name "cyclictest".
+
+For the *trace-cmd*(3) command:
+[source, c]
+--
+   trace-cmd start -e all -e wakeup_lat -R stacktrace
+--
+
+ *trace-cmd start*::
+   Enables tracing (does not record to a file).
+
+ *-e all*::
+   Enable all events
+
+ *-e wakeup_lat -R stacktrace*::
+   have the "wakeup_lat" event (our synthetic event) enable the *stacktrace* trigger, were
+   for every instance of the "wakeup_lat" event, a kernel stack trace will be recorded
+   in the ring buffer.
+
+After calling *cyclictest* (a real-time tool to measure wakeup latency), read the snapshot
+buffer.
+
+ *trace-cmd show -s*::
+   *trace-cmd show* reads the kernel ring buffer, and the *-s* option will read the *snapshot*
+   buffer instead of the normal one.
+
+[source, c]
+--
+ <idle>-0       [002] d..4 23454.902256: wakeup_lat: next_comm=cyclictest lat=17
+--
+  We see on the "wakeup_lat" event happened on CPU 2, with a wake up latency 17 microseconds.
+
+This can be extracted into a *trace.dat* file that *trace-cmd*(3) can read and do further
+analysis, as well as *kernelshark*.
+
+[source, c]
+--
+    # trace-cmd extract -s
+    # trace-cmd report --cpu 2 | tail -30
+          <idle>-0     [002] 23454.902238: prandom_u32:          ret=1633425088
+          <idle>-0     [002] 23454.902239: sched_wakeup:         cyclictest:12275 [19] CPU:002
+          <idle>-0     [002] 23454.902241: hrtimer_expire_exit:  hrtimer=0xffffbbd68286fe60
+          <idle>-0     [002] 23454.902241: hrtimer_cancel:       hrtimer=0xffffbbd6826efe70
+          <idle>-0     [002] 23454.902242: hrtimer_expire_entry: hrtimer=0xffffbbd6826efe70 now=23455294430750 function=hrtimer_wakeup/0x0
+          <idle>-0     [002] 23454.902243: sched_waking:         comm=cyclictest pid=12272 prio=120 target_cpu=002
+          <idle>-0     [002] 23454.902244: prandom_u32:          ret=1102749734
+          <idle>-0     [002] 23454.902246: sched_wakeup:         cyclictest:12272 [120] CPU:002
+          <idle>-0     [002] 23454.902247: hrtimer_expire_exit:  hrtimer=0xffffbbd6826efe70
+          <idle>-0     [002] 23454.902248: write_msr:            6e0, value 4866ce957272
+          <idle>-0     [002] 23454.902249: local_timer_exit:     vector=236
+          <idle>-0     [002] 23454.902250: cpu_idle:             state=4294967295 cpu_id=2
+          <idle>-0     [002] 23454.902251: rcu_utilization:      Start context switch
+          <idle>-0     [002] 23454.902252: rcu_utilization:      End context switch
+          <idle>-0     [002] 23454.902253: prandom_u32:          ret=3692516021
+          <idle>-0     [002] 23454.902254: sched_switch:         swapper/2:0 [120] R ==> cyclictest:12275 [19]
+          <idle>-0     [002] 23454.902256: wakeup_lat:           next_comm=cyclictest lat=17
+          <idle>-0     [002] 23454.902258: kernel_stack:         <stack trace >
+=> trace_event_raw_event_synth (ffffffff8121a0db)
+=> action_trace (ffffffff8121e9fb)
+=> event_hist_trigger (ffffffff8121ca8d)
+=> event_triggers_call (ffffffff81216c72)
+=> trace_event_buffer_commit (ffffffff811f7618)
+=> trace_event_raw_event_sched_switch (ffffffff8110fda4)
+=> __traceiter_sched_switch (ffffffff8110d449)
+=> __schedule (ffffffff81c02002)
+=> schedule_idle (ffffffff81c02c86)
+=> do_idle (ffffffff8111e898)
+=> cpu_startup_entry (ffffffff8111eba9)
+=> secondary_startup_64_no_verify (ffffffff81000107)
+--
+
+SEE ALSO
+--------
+trace-cmd(1), tracefs_sqlhist(3)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2021 , Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index eb9d2f62428d..d56d7a5a86c4 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -41,6 +41,7 @@ TRACE_CMD_OBJS += trace-attach.o
 TRACE_CMD_OBJS += trace-agent.o
 TRACE_CMD_OBJS += trace-tsync.o
 TRACE_CMD_OBJS += trace-setup-guest.o
+TRACE_CMD_OBJS += trace-sqlhist.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-vsock.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 33397b1ec70b..557b2eb0fb07 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -122,6 +122,8 @@ void trace_attach(int argc, char **argv);
 
 void trace_convert(int argc, char **argv);
 
+void trace_sqlhist (int argc, char **argv);
+
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index df0b626f9b34..21309f0ec2ce 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -179,6 +179,7 @@ struct command commands[] = {
 	{"dump", trace_dump},
 	{"attach", trace_attach},
 	{"convert", trace_convert},
+	{"sqlhist", trace_sqlhist},
 	{"-h", trace_usage},
 };
 
diff --git a/tracecmd/trace-sqlhist.c b/tracecmd/trace-sqlhist.c
new file mode 100644
index 000000000000..f53feb243035
--- /dev/null
+++ b/tracecmd/trace-sqlhist.c
@@ -0,0 +1,246 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+#include "trace-local.h"
+
+enum action {
+	ACTION_DEFAULT	= 0,
+	ACTION_SNAPSHOT	= (1 << 0),
+	ACTION_TRACE	= (1 << 1),
+	ACTION_SAVE	= (1 << 2),
+	ACTION_MAX	= (1 << 3),
+	ACTION_CHANGE	= (1 << 4),
+};
+
+#define ACTIONS ((ACTION_MAX - 1))
+
+static int do_sql(const char *instance_name,
+		  const char *buffer, const char *name, const char *var,
+		  const char *trace_dir, bool execute, int action,
+		  char **save_fields)
+{
+	struct tracefs_synth *synth;
+	struct tep_handle *tep;
+	struct trace_seq seq;
+	enum tracefs_synth_handler handler;
+	char *err;
+	int ret;
+
+	if ((action & ACTIONS) && !var)
+		die("Error: -s, -S and -T not supported without -m or -c");
+
+	if (!name)
+		name = "Anonymous";
+
+	trace_seq_init(&seq);
+	tep = tracefs_local_events(trace_dir);
+	if (!tep)
+		die("Could not read %s", trace_dir ? trace_dir : "tracefs directory");
+
+	synth = tracefs_sql(tep, name, buffer, &err);
+	if (!synth)
+		die("Failed creating synthetic event!\n%s", err ? err : "");
+
+	if (tracefs_synth_complete(synth)) {
+		if (var) {
+			if (action & ACTION_MAX)
+				handler = TRACEFS_SYNTH_HANDLE_MAX;
+			else
+				handler = TRACEFS_SYNTH_HANDLE_CHANGE;
+
+			/* Default to trace if other actions are not set */
+			if (!(action & (ACTION_SAVE | ACTION_SNAPSHOT)))
+				action |= ACTION_TRACE;
+
+			if (action & ACTION_SAVE) {
+				ret = tracefs_synth_save(synth, handler, var, save_fields);
+				if (ret < 0) {
+					err = "adding save";
+					goto failed_action;
+				}
+			}
+			if (action & ACTION_TRACE) {
+				/*
+				 * By doing the trace before snapshot, it will be included
+				 * in the snapshot.
+				 */
+				ret = tracefs_synth_trace(synth, handler, var);
+				if (ret < 0) {
+					err = "adding trace";
+					goto failed_action;
+				}
+			}
+			if (action & ACTION_SNAPSHOT) {
+				ret = tracefs_synth_snapshot(synth, handler, var);
+				if (ret < 0) {
+					err = "adding snapshot";
+ failed_action:
+					perror(err);
+					if (errno == ENODEV)
+						fprintf(stderr, "ERROR: '%s' is not a variable\n",
+							var);
+					exit(-1);
+				}
+			}
+		}
+		tracefs_synth_echo_cmd(&seq, synth);
+		if (execute) {
+			ret = tracefs_synth_create(synth);
+			if (ret < 0)
+				die("%s\n", tracefs_error_last(NULL));
+		}
+	} else {
+		struct tracefs_instance *instance = NULL;
+		struct tracefs_hist *hist;
+
+		hist = tracefs_synth_get_start_hist(synth);
+		if (!hist)
+			die("get_start_hist");
+
+		if (instance_name) {
+			if (execute)
+				instance = tracefs_instance_create(instance_name);
+			else
+				instance = tracefs_instance_alloc(trace_dir,
+								  instance_name);
+			if (!instance)
+				die("Failed to create instance");
+		}
+		tracefs_hist_echo_cmd(&seq, instance, hist, 0);
+		if (execute) {
+			ret = tracefs_hist_start(instance, hist);
+			if (ret < 0)
+				die("%s\n", tracefs_error_last(instance));
+		}
+	}
+
+	tracefs_synth_free(synth);
+
+	trace_seq_do_printf(&seq);
+	trace_seq_destroy(&seq);
+	return 0;
+}
+
+void trace_sqlhist (int argc, char **argv)
+{
+	char *trace_dir = NULL;
+	char *buffer = NULL;
+	char buf[BUFSIZ];
+	int buffer_size = 0;
+	const char *file = NULL;
+	const char *instance = NULL;
+	bool execute = false;
+	char **save_fields = NULL;
+	const char *name;
+	const char *var;
+	char **save_argv;
+	int action = 0;
+	char *tok;
+	FILE *fp;
+	size_t r;
+	int c;
+	int i;
+
+	/* Remove 'trace-cmd' */
+	save_argv = argv;
+	argc -= 1;
+	argv += 1;
+
+	if (argc < 2)
+		usage(save_argv);
+
+	for (;;) {
+		c = getopt(argc, argv, "ht:f:en:m:c:sS:TB:");
+		if (c == -1)
+			break;
+
+		switch(c) {
+		case 'h':
+			usage(save_argv);
+		case 't':
+			trace_dir = optarg;
+			break;
+		case 'f':
+			file = optarg;
+			break;
+		case 'e':
+			execute = true;
+			break;
+		case 'm':
+			action |= ACTION_MAX;
+			var = optarg;
+			break;
+		case 'c':
+			action |= ACTION_CHANGE;
+			var = optarg;
+			break;
+		case 's':
+			action |= ACTION_SNAPSHOT;
+			break;
+		case 'S':
+			action |= ACTION_SAVE;
+			tok = strtok(optarg, ",");
+			while (tok) {
+				save_fields = tracefs_list_add(save_fields, tok);
+				tok = strtok(NULL, ",");
+			}
+			if (!save_fields) {
+				perror(optarg);
+				exit(-1);
+			}
+			break;
+		case 'T':
+			action |= ACTION_TRACE | ACTION_SNAPSHOT;
+			break;
+		case 'B':
+			instance = optarg;
+			break;
+		case 'n':
+			name = optarg;
+			break;
+		}
+	}
+
+	if ((action & (ACTION_MAX|ACTION_CHANGE)) == (ACTION_MAX|ACTION_CHANGE)) {
+		fprintf(stderr, "Can not use both -m and -c together\n");
+		exit(-1);
+	}
+	if (file) {
+		if (!strcmp(file, "-"))
+			fp = stdin;
+		else
+			fp = fopen(file, "r");
+		if (!fp) {
+			perror(file);
+			exit(-1);
+		}
+		while ((r = fread(buf, 1, BUFSIZ, fp)) > 0) {
+			buffer = realloc(buffer, buffer_size + r + 1);
+			strncpy(buffer + buffer_size, buf, r);
+			buffer_size += r;
+		}
+		fclose(fp);
+		if (buffer_size)
+			buffer[buffer_size] = '\0';
+	} else if (argc == optind) {
+		usage(save_argv);
+	} else {
+		for (i = optind; i < argc; i++) {
+			r = strlen(argv[i]);
+			buffer = realloc(buffer, buffer_size + r + 2);
+			if (i != optind)
+				buffer[buffer_size++] = ' ';
+			strcpy(buffer + buffer_size, argv[i]);
+			buffer_size += r;
+		}
+	}
+
+	do_sql(instance, buffer, name, var, trace_dir, execute, action, save_fields);
+	free(buffer);
+}
+
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3e5456d27e3d..61acce5f18d2 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -455,7 +455,25 @@ static struct usage_help usage_help[] = {
 		"                            any  - auto select the best available compression algorithm\n"
 		"                            none - do not compress the trace file\n"
 		"                            name - the name of the desired compression algorithms\n"
-		"                        available algorithms can be listed with trace-cmd list -c\n"	},
+		"                        available algorithms can be listed with trace-cmd list -c\n"
+	},
+	{
+		"sqlhist",
+		"Run a SQL like query to create histogram or synthetic events (see man tracefs_sql(3))\n",
+		"%s sql [-n name][-e][-s][-S fields][-m var][-c var][-T][-t dir][-f file | 'sql-command-line']\n"
+		"  -n name - name of synthetic event 'Anonymous' if left off\n"
+		"  -t dir - use dir instead of /sys/kernel/tracing\n"
+		"  -e - execute the commands to create the synthetic event\n"
+		"  -m - trigger the action when var is a new max.\n"
+		"  -c - trigger the action when var changes.\n"
+		"  -s - used with -m or -c to do a snapshot of the tracing buffer\n"
+		"  -S - used with -m or -c to save fields of the end event (comma deliminated)\n"
+		"  -T - used with -m or -c to do both a snapshot and a trace\n"
+		"  -f file - read sql lines from file otherwise from the command line\n"
+		"	    if file is '-' then read from standard input.\n\n"
+		" See man tracefs_sql(3) for sql-command-line\n"
+	},
+
 	{
 		NULL, NULL, NULL
 	}
-- 
2.42.0

