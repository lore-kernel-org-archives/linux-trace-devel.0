Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1433BC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343548AbiFHQsj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343717AbiFHQsi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:48:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB35748304
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61062B828C1
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB512C34116
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:48:33 +0000 (UTC)
Date:   Wed, 8 Jun 2022 12:48:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix man page examples formatting
Message-ID: <20220608124832.12526bc3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page example code is only surrounded by dashes, which worked in
the early days but now it shows:

	.ft c

around the example if not the right packages are installed. Add the
"[source,<lang>]" attribute around them, and shorten the dashes to just
four. This allows the parsing to be better and the man page to be proper.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-dump.1.txt  | 17 +++-
 .../trace-cmd/trace-cmd-record.1.txt          | 31 ++++---
 .../trace-cmd/trace-cmd-report.1.txt          | 80 ++++++++++---------
 Documentation/trace-cmd/trace-cmd-set.1.txt   | 15 ++--
 4 files changed, 79 insertions(+), 64 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
index 9c95244b9734..318a0fe70179 100644
--- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
@@ -65,6 +65,8 @@ OPTIONS
 EXAMPLES
 --------
 
+[source,shell]
+----
 # trace-cmd dump --summary -i trace.dat
 
  Tracing meta data in file trace.dat:
@@ -83,8 +85,10 @@ EXAMPLES
 	8 [CPUs with tracing data]
 	[12 options]
 	[Flyrecord tracing data]
-------------------------------------------
+----
 
+[source,shell]
+----
 # trace-cmd dump --flyrecord -i trace.dat
 	[Flyrecord tracing data]
 		 7176192 0	[offset, size of cpu 0]
@@ -95,8 +99,10 @@ EXAMPLES
 		 7184384 0	[offset, size of cpu 5]
 		 7184384 0	[offset, size of cpu 6]
 		 7184384 0	[offset, size of cpu 7]
-------------------------------------------
+----
 
+[source,shell]
+----
 # trace-cmd dump --summary --systems -i trace.dat
 
  Tracing meta data in file trace.dat:
@@ -118,11 +124,14 @@ EXAMPLES
 	8 [CPUs with tracing data]
 	[11 options]
 	[Flyrecord tracing data]
-------------------------------------------
+----
 
+[source,shell]
+----
 # trace-cmd dump --summary --systems -i trace.dat
 File trace.dat is a valid trace-cmd file
-------------------------------------------
+----
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd.dat(1)
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 6b8e3b4ad364..75e241c53222 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -77,9 +77,10 @@ OPTIONS
     may depend on what version of the kernel you have. Basically, it will
     let you use C notation to check if an event should be processed or not.
 
-----------------------------------------
+[source,bison]
+----
     ==, >=, <=, >, <, &, |, && and ||
-----------------------------------------
+----
 
     The above are usually safe to use to compare fields.
 
@@ -408,22 +409,22 @@ EXAMPLES
 
 The basic way to trace all events:
 
-------------------------------
+[source,shell]
+----
  # trace-cmd record -e all ls > /dev/null
  # trace-cmd report
        trace-cmd-13541 [003] 106260.693809: filemap_fault: address=0x128122 offset=0xce
        trace-cmd-13543 [001] 106260.693809: kmalloc: call_site=81128dd4 ptr=0xffff88003dd83800 bytes_req=768 bytes_alloc=1024 gfp_flags=GFP_KERNEL|GFP_ZERO
               ls-13545 [002] 106260.693809: kfree: call_site=810a7abb ptr=0x0
               ls-13545 [002] 106260.693818: sys_exit_write:       0x1
-
-
-------------------------------
+----
 
 
 
 To use the function tracer with sched switch tracing:
 
-------------------------------
+[source,shell]
+----
  # trace-cmd record -p function -e sched_switch ls > /dev/null
  # trace-cmd report
               ls-13587 [002] 106467.860310: function: hrtick_start_fair <-- pick_next_task_fair
@@ -434,12 +435,11 @@ To use the function tracer with sched switch tracing:
        trace-cmd-13585 [001] 106467.860318: function: _raw_spin_unlock <-- __do_fault
               ls-13587 [002] 106467.860320: function: native_load_sp0 <-- __switch_to
        trace-cmd-13586 [003] 106467.860322: function: down_read_trylock <-- do_page_fault
-
-
-------------------------------
+----
 
 Here is a nice way to find what interrupts have the highest latency:
-------------------------------------------
+[source,shell]
+----
  # trace-cmd record -p function_graph -e irq_handler_entry  -l do_IRQ sleep 10
  # trace-cmd report
           <idle>-0     [000] 157412.933969: funcgraph_entry:                  |  do_IRQ() {
@@ -457,12 +457,11 @@ Here is a nice way to find what interrupts have the highest latency:
           <idle>-0     [000] 157417.888373: funcgraph_entry:                  |  do_IRQ() {
           <idle>-0     [000] 157417.888381: irq_handler_entry:    irq=48 name=eth0
           <idle>-0     [000] 157417.888398: funcgraph_exit:       + 25.943 us |  }
-
-
-------------------------------------------
+----
 
 An example of the profile:
-------------------------------------------
+[source,shell]
+----
  # trace-cmd record --profile sleep 1
  # trace-cmd report --profile --comm sleep
 task: sleep-21611
@@ -496,7 +495,7 @@ task: sleep-21611
        => ttwu_do_wakeup (0xffffffff810606eb)
        => ttwu_do_activate.constprop.124 (0xffffffff810607c8)
        => try_to_wake_up (0xffffffff8106340a)
-------------------------------------------
+----
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index aad8ab5125b0..df60dd87d979 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -72,7 +72,8 @@ OPTIONS
     Add a filter to limit what events are displayed. The format of the filter
     is:
 
-------------------------------------------
+[source,bison]
+----
     <events> ':' <filter>
     <events> = SYSTEM'/'EVENT  | SYSTEM | EVENT | <events> ',' <events>
     <filter> = EVENT_FIELD <op> <value> | <filter> '&&' <filter> |
@@ -80,7 +81,7 @@ OPTIONS
     <op> = '==' | '!=' | '>=' | '<=' | '>' | '<' | '&' | '|' | '^' |
            '+' | '-' | '*' | '/' | '%'
     <value> = NUM | STRING | EVENT_FIELD
-------------------------------------------
+----
 
     SYSTEM is the name of the system to filter on. If the EVENT is left out,
     then it applies to all events under the SYSTEM. If only one string is used
@@ -101,9 +102,10 @@ OPTIONS
     filtered. If the event does not contain the EVENT_FIELD, that part of the
     equation will be considered false.
 
-------------------------------------------
+[source,shell]
+----
     -F 'sched : bogus == 1 || common_pid == 2'
-------------------------------------------
+----
 
     The "bogus == 1" will always evaluate to FALSE because no event has a
     field called "bogus", but the "common_pid == 2" will still be evaluated
@@ -119,9 +121,10 @@ OPTIONS
     value displayed. For example, to filter on all tasks that were in the
     running state at a context switch:
 
-------------------------------------------
+[source,shell]
+----
     -F 'sched/sched_switch : prev_state==0'
-------------------------------------------
+----
 
     Although the output displays 'R', having 'prev_stat=="R"' will not work.
 
@@ -129,9 +132,10 @@ OPTIONS
     task name (or comm) of the record to compare. For example, to filter out
     all of the "trace-cmd" tasks:
 
-------------------------------------------
+[source,shell]
+----
     -F '.*:COMM != "trace-cmd"'
-------------------------------------------
+----
 
 *-I*::
     Do not print events where the HARDIRQ latency flag is set.
@@ -148,9 +152,10 @@ OPTIONS
     This causes the following filters of *-F* to filter out the matching
     events.
 
-------------------------------------------
+[source,shell]
+----
     -v -F 'sched/sched_switch : prev_state == 0'
-------------------------------------------
+----
 
     Will not display any sched_switch events that have a prev_state of 0.
     Removing the *-v* will only print out those events.
@@ -211,9 +216,10 @@ OPTIONS
     will set display this information with 6 characters. When one of the
     fields is zero or N/A a \'.\' is shown.
 
-------------------------------------------
+[source,shell]
+----
       <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
-------------------------------------------
+----
 
     The 0d.h1. denotes this information. The first character is never a '.'
     and represents what CPU the trace was recorded on (CPU 0). The 'd' denotes
@@ -336,15 +342,15 @@ EXAMPLES
 
 Using a trace.dat file that was created with:
 
-------------------------------------------
+[source,shell]
+----
     # trace-cmd record -p function -e all sleep 5
-
-
-------------------------------------------
+----
 
 The default report shows:
 
-------------------------------------------
+[source,shell]
+----
  # trace-cmd report
        trace-cmd-16129 [002] 158126.498411: function: __mutex_unlock_slowpath <-- mutex_unlock
        trace-cmd-16131 [000] 158126.498411: kmem_cache_alloc: call_site=811223c5 ptr=0xffff88003ecf2b40 bytes_req=272 bytes_alloc=320 gfp_flags=GFP_KERNEL|GFP_ZERO
@@ -360,13 +366,12 @@ The default report shows:
        trace-cmd-16130 [003] 158126.498426: function: security_file_permission <-- rw_verify_area
        trace-cmd-16129 [002] 158126.498428: function: audit_syscall_exit <-- syscall_trace_leave
 [...]
-
-
-------------------------------------------
+----
 
 To see everything but the function traces:
 
-------------------------------------------
+[source,shell]
+----
  # trace-cmd report -v -F 'function'
        trace-cmd-16131 [000] 158126.498411: kmem_cache_alloc: call_site=811223c5 ptr=0xffff88003ecf2b40 bytes_req=272 bytes_alloc=320 gfp_flags=GFP_KERNEL|GFP_ZERO
        trace-cmd-16129 [002] 158126.498420: lock_release: 0xffff88003f1fa4f8 &sb->s_type->i_mutex_key
@@ -381,20 +386,22 @@ To see everything but the function traces:
        trace-cmd-16130 [003] 158126.498462: kmalloc: call_site=810bf95b ptr=0xffff88003dedc040 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL|GFP_ZERO
 
 
-------------------------------------------
+----
 
 To see only the kmalloc calls that were greater than 1000 bytes:
 
-------------------------------------------
+[source,shell]
+----
  #trace-cmd report -F 'kmalloc: bytes_req > 1000'
           <idle>-0     [000] 158128.126641: kmalloc: call_site=81330635 ptr=0xffff88003c2fd000 bytes_req=2096 bytes_alloc=4096 gfp_flags=GFP_ATOMIC
 
 
-------------------------------------------
+----
 
 To see wakeups and sched switches that left the previous task in the running
 state:
-------------------------------------------
+[source,shell]
+----
  # trace-cmd report -F 'sched: prev_state == 0 || (success == 1)'
        trace-cmd-16132 [002] 158126.499951: sched_wakeup: comm=trace-cmd pid=16129 prio=120 success=1 target_cpu=002
        trace-cmd-16132 [002] 158126.500401: sched_switch: prev_comm=trace-cmd prev_pid=16132 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=16129 next_prio=120
@@ -407,9 +414,7 @@ state:
        trace-cmd-16130 [002] 158126.618202: sched_switch: prev_comm=trace-cmd prev_pid=16130 prev_prio=120 prev_state=R ==> next_comm=yum-updatesd next_pid=3088 next_prio=1 20
        trace-cmd-16129 [003] 158126.622379: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=003
        trace-cmd-16129 [000] 158126.649287: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=000
-
-
-------------------------------------------
+----
 
 The above needs a little explanation. The filter specifies the "sched"
 subsystem, which includes both sched_switch and sched_wakeup events. Any event
@@ -419,7 +424,8 @@ the "prev_state" test happen for the "sched_switch" event and the "success"
 test happen for the "sched_wakeup" event.
 
 
-------------------------------------------
+[source,shell]
+----
   # trace-cmd report -w -F 'sched_switch, sched_wakeup.*'
 [...]
        trace-cmd-16130 [003] 158131.580616: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=003
@@ -432,15 +438,14 @@ test happen for the "sched_wakeup" event.
        trace-cmd-16130 [003] 158131.585284: sched_switch: prev_comm=trace-cmd prev_pid=16130 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=16132 next_prio=120 Latency: 1155.677 usecs
 
 Average wakeup latency: 26626.656 usecs
-
-
-------------------------------------------
+----
 
 The above trace produces the wakeup latencies of the tasks. The "sched_switch"
 event reports each individual latency after writing the event information.
 At the end of the report, the average wakeup latency is reported.
 
-------------------------------------------
+[source,shell]
+----
   # trace-cmd report -w -F 'sched_switch, sched_wakeup.*: prio < 100 || next_prio < 100'
           <idle>-0     [003] 158131.516753: sched_wakeup: comm=ksoftirqd/3 pid=13 prio=49 success=1 target_cpu=003
           <idle>-0     [003] 158131.516855: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/3 next_pid=13 next_prio=49 Latency: 101.244 usecs
@@ -450,9 +455,7 @@ At the end of the report, the average wakeup latency is reported.
           <idle>-0     [003] 158131.569851: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/3 next_pid=13 next_prio=49 Latency: 121.024 usecs
 
 Average wakeup latency: 110.021 usecs
-
-
-------------------------------------------
+----
 
 The above version will only show the wakeups and context switches of Real Time
 tasks. The 'prio' used inside the kernel starts at 0 for highest priority.
@@ -461,7 +464,8 @@ priority 98 is equivalent to user space real time priority 1.
 Prios less than 100 represent Real Time tasks.
 
 An example of the profile:
-------------------------------------------
+[source,shell]
+----
  # trace-cmd record --profile sleep 1
  # trace-cmd report --profile --comm sleep
 task: sleep-21611
@@ -495,7 +499,7 @@ task: sleep-21611
        => ttwu_do_wakeup (0xffffffff810606eb)
        => ttwu_do_activate.constprop.124 (0xffffffff810607c8)
        => try_to_wake_up (0xffffffff8106340a)
-------------------------------------------
+----
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-set.1.txt b/Documentation/trace-cmd/trace-cmd-set.1.txt
index a182d1913074..141606f02d6e 100644
--- a/Documentation/trace-cmd/trace-cmd-set.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-set.1.txt
@@ -62,9 +62,10 @@ OPTIONS
     may depend on what version of the kernel you have. Basically, it will
     let you use C notation to check if an event should be processed or not.
 
-----------------------------------------
+[source,bison]
+----
     ==, >=, <=, >, <, &, |, && and ||
-----------------------------------------
+----
 
     The above are usually safe to use to compare fields.
 
@@ -242,15 +243,17 @@ EXAMPLES
 
 Enable all events for tracing:
 
-------------------------------
+[source,shell]
+----
  # trace-cmd set -e all
-------------------------------
+----
 
 Set the function tracer:
 
-------------------------------
+[source,shell]
+----
  # trace-cmd set -p function
-------------------------------
+----
 
 
 SEE ALSO
-- 
2.35.1

