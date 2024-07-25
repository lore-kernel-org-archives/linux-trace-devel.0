Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5B055896
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2024 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721936515; cv=none; b=rgq2cx6YZ0vFtsjV7G6JByTvSmhnTvWe27bih643QH+vKvzZ2QEfGRov5z/bseQbtwQz7pq6iosKxo62bwA0crIZBqdVLh9HaiuMDTkX5MfudaK+Cp2fAmznXQyjrP2f7Jju8+hjc/3F4aVUEk/twDfHdCGe4wfRPW8vxUs86U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721936515; c=relaxed/simple;
	bh=pDjKAXikc3E1Nbw7KDeUr1qEiuMcRQ89RCLUEkf0xDw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=M04ZqBABCkH6FX0+cc82xzVsxN2DYXgjnpN8gFSv4cyseDKmRBiW8srJq2iGinN3Cxs6PRfo0tw6AljlqAnGC6ewqbL3LgJ0CZ/gUDRR8WeOuX0Dg7nPuM+DLq/M83HuFPp9oVb1Ik58p6dKcgdfAEbEnUxfGcDiMF7haoaQnvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E1C116B1;
	Thu, 25 Jul 2024 19:41:54 +0000 (UTC)
Date: Thu, 25 Jul 2024 15:42:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Subject: [PATCH] trace-cmd Documentation: Update the trace-cmd report output
Message-ID: <20240725154215.4ab1b205@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The output of trace-cmd report has changed. It now shows the latency data
column by default. Reflect this update in the man pages.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-report.1.txt          | 248 +++++++++++++-----
 1 file changed, 182 insertions(+), 66 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 62fba1e5b381..41f23b2d5cab 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -387,116 +387,232 @@ The default report shows:
 [source,shell]
 ----
  # trace-cmd report
-       trace-cmd-16129 [002] 158126.498411: function: __mutex_unlock_slowpath <-- mutex_unlock
-       trace-cmd-16131 [000] 158126.498411: kmem_cache_alloc: call_site=811223c5 ptr=0xffff88003ecf2b40 bytes_req=272 bytes_alloc=320 gfp_flags=GFP_KERNEL|GFP_ZERO
-       trace-cmd-16130 [003] 158126.498411: function:             do_splice_to <-- sys_splice
-           sleep-16133 [001] 158126.498412: function: inotify_inode_queue_event <-- vfs_write
-       trace-cmd-16129 [002] 158126.498420: lock_release: 0xffff88003f1fa4f8 &sb->s_type->i_mutex_key
-       trace-cmd-16131 [000] 158126.498421: function: security_file_alloc <-- get_empty_filp
-           sleep-16133 [001] 158126.498422: function: __fsnotify_parent <-- vfs_write
-       trace-cmd-16130 [003] 158126.498422: function: rw_verify_area <-- do_splice_to
-       trace-cmd-16131 [000] 158126.498424: function: cap_file_alloc_security <-- security_file_alloc
-       trace-cmd-16129 [002] 158126.498425: function: syscall_trace_leave <-- int_check_syscall_exit_work
-           sleep-16133 [001] 158126.498426: function: inotify_dentry_parent_queue_event <-- vfs_write
-       trace-cmd-16130 [003] 158126.498426: function: security_file_permission <-- rw_verify_area
-       trace-cmd-16129 [002] 158126.498428: function: audit_syscall_exit <-- syscall_trace_leave
+cpus=8
+           sleep-89142 [001] ...1. 162573.215752: function:             mutex_unlock
+           sleep-89142 [001] ...1. 162573.215754: function:             __mutex_unlock_slowpath
+           sleep-89142 [001] ..... 162573.215755: lock_release:         0xffffffff855e7448 trace_types_lock
+           sleep-89142 [001] ..... 162573.215757: lock_release:         0xffff892a01b54420 sb_writers
+           sleep-89142 [001] ...1. 162573.215757: function:             preempt_count_add
+           sleep-89142 [001] ...1. 162573.215758: preempt_disable:      caller=vfs_write+0x147 parent=vfs_write+0x147
+           sleep-89142 [001] ...2. 162573.215758: function:             rcu_read_lock_any_held
+           sleep-89142 [001] ...2. 162573.215759: function:                rcu_lockdep_current_cpu_online
+           sleep-89142 [001] ...2. 162573.215759: function:             preempt_count_sub
+           sleep-89142 [001] ...1. 162573.215760: preempt_enable:       caller=vfs_write+0x176 parent=vfs_write+0x176
+           sleep-89142 [001] ...1. 162573.215761: function:             __f_unlock_pos
+           sleep-89142 [001] ...1. 162573.215761: function:             mutex_unlock
 [...]
 ----
 
-To see everything but the function traces:
+The note on the third column:
 
 [source,shell]
 ----
- # trace-cmd report -v -F 'function'
-       trace-cmd-16131 [000] 158126.498411: kmem_cache_alloc: call_site=811223c5 ptr=0xffff88003ecf2b40 bytes_req=272 bytes_alloc=320 gfp_flags=GFP_KERNEL|GFP_ZERO
-       trace-cmd-16129 [002] 158126.498420: lock_release: 0xffff88003f1fa4f8 &sb->s_type->i_mutex_key
-       trace-cmd-16130 [003] 158126.498436: lock_acquire: 0xffffffff8166bf78 read all_cpu_access_lock
-       trace-cmd-16131 [000] 158126.498438: lock_acquire: 0xffff88003df5b520 read &fs->lock
-       trace-cmd-16129 [002] 158126.498446: kfree: call_site=810a7abb ptr=0x0
-       trace-cmd-16130 [003] 158126.498448: lock_acquire: 0xffff880002250a80 &per_cpu(cpu_access_lock, cpu)
-       trace-cmd-16129 [002] 158126.498450: sys_exit_splice:      0xfffffff5
-       trace-cmd-16131 [000] 158126.498454: lock_release: 0xffff88003df5b520 &fs->lock
-           sleep-16133 [001] 158126.498456: kfree: call_site=810a7abb ptr=0x0
-           sleep-16133 [001] 158126.498460: sys_exit_write:       0x1
-       trace-cmd-16130 [003] 158126.498462: kmalloc: call_site=810bf95b ptr=0xffff88003dedc040 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL|GFP_ZERO
+           sleep-89998 [002] ...1. 223087.004011: lock_acquire:         0xffff892b7cf32c20 lock
+           sleep-89998 [002] ...1. 223087.004011: lock_acquire:         0xffffffff85517f00 read rcu_read_lock
+          <idle>-0     [005] dNh2. 223087.004012: sched_wakeup:         trace-cmd:89992 [120] CPU:005
+           sleep-89998 [002] ...1. 223087.004012: lock_acquire:         0xffffffff85517f00 read rcu_read_lock
+           sleep-89998 [002] ...1. 223087.004013: lock_release:         0xffffffff85517f00 rcu_read_lock
+----
 
+It follows the same as shown in the Linux kernel `/sys/kernel/tracing/trace` file.
 
+[source,shell]
+----
+# cat /sys/kernel/tracing/trace
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 0/0   #P:8
+#
+#                                _-----=> irqs-off/BH-disabled
+#                               / _----=> need-resched
+#                              | / _---=> hardirq/softirq
+#                              || / _--=> preempt-depth
+#                              ||| / _-=> migrate-disable
+#                              |||| /     delay
+#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
+#              | |         |   |||||     |         |
 ----
 
-To see only the kmalloc calls that were greater than 1000 bytes:
+Is the same as explained in the *-l* option.
+Where the first position is:
+
+  '.' - means interrupts and bottom halves enabled
+  'd' - means interrupts and bottom halves are disabled
+
+The second position:
+
+   'N' - means that the "NEED_RESCHED" flag is set and the kernel should try to
+         schedule as soon as possible.
+
+The third position:
+
+   '.' - In normal/schedulable context
+   's' - In soft interrupt context
+   'h' - In hard interrupt context
+   'H' - in hard interrupt context that interrupted a soft interrupt
+
+The forth position is the preempt count depth:
+
+   'pass:[.]' - preemption is enabled
+   '#' - the depth of preemption disabled (nested)
+
+The fifth column is the migration disabled counter:
+
+   '.' - migration is enabled
+   '#' - the depth of migration being disabled (nested)
+
+
+To see everything but the function traces:
 
 [source,shell]
 ----
- #trace-cmd report -F 'kmalloc: bytes_req > 1000'
-          <idle>-0     [000] 158128.126641: kmalloc: call_site=81330635 ptr=0xffff88003c2fd000 bytes_req=2096 bytes_alloc=4096 gfp_flags=GFP_ATOMIC
+ # trace-cmd report -v -F 'function'
+cpus=8
+           sleep-89142 [001] ..... 162573.215755: lock_release:         0xffffffff855e7448 trace_types_lock
+           sleep-89142 [001] ..... 162573.215757: lock_release:         0xffff892a01b54420 sb_writers
+           sleep-89142 [001] ...1. 162573.215758: preempt_disable:      caller=vfs_write+0x147 parent=vfs_write+0x147
+           sleep-89142 [001] ...1. 162573.215760: preempt_enable:       caller=vfs_write+0x176 parent=vfs_write+0x176
+           sleep-89142 [001] ..... 162573.215762: lock_release:         0xffff892a19601ac8 &f->f_pos_lock
+           sleep-89142 [001] ..... 162573.215764: sys_exit:             NR 1 = 1
+           sleep-89142 [001] ..... 162573.215766: sys_exit_write:       0x1
+           sleep-89142 [001] d.... 162573.215767: irq_disable:          caller=syscall_exit_to_user_mode+0x15 parent=0x0
+           sleep-89142 [001] d.... 162573.215768: irq_enable:           caller=syscall_exit_to_user_mode+0xed parent=0x0
+           sleep-89142 [001] ..... 162573.215773: lock_acquire:         0xffff892a4ad29318 read &mm->mmap_lock
+           sleep-89142 [001] ..... 162573.215775: lock_release:         0xffff892a4ad29318 &mm->mmap_lock
+           sleep-89142 [001] ..... 162573.215778: lock_acquire:         0xffff892a4ad29318 read &mm->mmap_lock
+[...]
+----
 
+To see only the kmalloc calls that were greater than 1000 bytes:
 
+[source,shell]
+----
+ # trace-cmd report -F 'kmalloc: bytes_req > 1000'
+cpus=8
+           sleep-89142 [001] ..... 162573.219401: kmalloc:              (tomoyo_find_next_domain+0x84) call_site=tomoyo_find_next_domain+0x84 ptr=0xffff892a176c0000 bytes_req=4096 bytes_alloc=4096 gfp_flags=0xd40 node=-1 accounted=false
+           sleep-89142 [001] ..... 162573.219511: kmalloc:              (tomoyo_realpath_from_path+0x42) call_site=tomoyo_realpath_from_path+0x42 ptr=0xffff892a176c6000 bytes_req=4096 bytes_alloc=4096 gfp_flags=0xc40 node=-1 accounted=false
+       trace-cmd-89135 [000] ..... 162573.244301: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a63f84000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89135 [000] ..... 162573.244471: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a63f84000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89134 [007] ..... 162573.267148: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a628d4000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89134 [007] ..... 162573.267403: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a628d4000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89141 [002] ..... 162573.290583: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a12d3c000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89141 [002] ..... 162573.290754: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a12d3c000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+       trace-cmd-89139 [004] ..... 162573.784636: kmalloc:              (kvmalloc_node_noprof+0x43) call_site=kvmalloc_node_noprof+0x43 ptr=0xffff892a63d70000 bytes_req=8193 bytes_alloc=16384 gfp_flags=0x12dc0 node=-1 accounted=false
+[...]
 ----
 
 To see wakeups and sched switches that left the previous task in the running
 state:
 [source,shell]
 ----
- # trace-cmd report -F 'sched: prev_state == 0 || (success == 1)'
-       trace-cmd-16132 [002] 158126.499951: sched_wakeup: comm=trace-cmd pid=16129 prio=120 success=1 target_cpu=002
-       trace-cmd-16132 [002] 158126.500401: sched_switch: prev_comm=trace-cmd prev_pid=16132 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=16129 next_prio=120
-          <idle>-0     [003] 158126.500585: sched_wakeup: comm=trace-cmd pid=16130 prio=120 success=1 target_cpu=003
-          <idle>-0     [003] 158126.501241: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=16130 next_prio=120
-       trace-cmd-16132 [000] 158126.502475: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=000
-       trace-cmd-16131 [002] 158126.506516: sched_wakeup: comm=trace-cmd pid=16129 prio=120 success=1 target_cpu=002
-          <idle>-0     [003] 158126.550110: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=16130 next_prio=120
-       trace-cmd-16131 [003] 158126.570243: sched_wakeup: comm=trace-cmd pid=16129 prio=120 success=1 target_cpu=003
-       trace-cmd-16130 [002] 158126.618202: sched_switch: prev_comm=trace-cmd prev_pid=16130 prev_prio=120 prev_state=R ==> next_comm=yum-updatesd next_pid=3088 next_prio=1 20
-       trace-cmd-16129 [003] 158126.622379: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=003
-       trace-cmd-16129 [000] 158126.649287: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=000
+ # trace-cmd report -F 'sched: prev_state == 0' -F 'sched_waking'
+cpus=8
+           sleep-89142 [001] d.h6. 162573.215941: sched_waking:         comm=trace-cmd pid=89135 prio=120 target_cpu=000
+          <idle>-0     [000] dNh7. 162573.216219: sched_waking:         comm=trace-cmd pid=89134 prio=120 target_cpu=007
+          <idle>-0     [000] d..2. 162573.216423: sched_switch:         swapper/0:0 [120] R ==> trace-cmd:89135 [120]
+          <idle>-0     [007] dNh7. 162573.216511: sched_waking:         comm=trace-cmd pid=89141 prio=120 target_cpu=002
+          <idle>-0     [007] d..2. 162573.216698: sched_switch:         swapper/7:0 [120] R ==> trace-cmd:89134 [120]
+          <idle>-0     [002] dNh7. 162573.216776: sched_waking:         comm=trace-cmd pid=89136 prio=120 target_cpu=001
+          <idle>-0     [002] d..2. 162573.216951: sched_switch:         swapper/2:0 [120] R ==> trace-cmd:89141 [120]
+           sleep-89142 [001] d.s3. 162573.231260: sched_waking:         comm=rcu_preempt pid=17 prio=120 target_cpu=002
+          <idle>-0     [002] d..2. 162573.231568: sched_switch:         swapper/2:0 [120] R ==> rcu_preempt:17 [120]
+           sleep-89142 [001] d.s2. 162573.240425: sched_waking:         comm=rcu_preempt pid=17 prio=120 target_cpu=002
+          <idle>-0     [002] d..2. 162573.240719: sched_switch:         swapper/2:0 [120] R ==> rcu_preempt:17 [120]
+           sleep-89142 [001] d.h7. 162573.241983: sched_waking:         comm=trace-cmd pid=89135 prio=120 target_cpu=000
 ----
 
 The above needs a little explanation. The filter specifies the "sched"
-subsystem, which includes both sched_switch and sched_wakeup events. Any event
-that does not have the format field "prev_state" or "success", will evaluate
-those expressions as FALSE, and will not produce a match. Using "||" will have
-the "prev_state" test happen for the "sched_switch" event and the "success"
-test happen for the "sched_wakeup" event.
+subsystem, which includes all scheduling events. Any event
+that does not have the format field "prev_state", will evaluate
+those expressions as FALSE, and will not produce a match. Only the sched_switch
+event will match that. The second "-F" will include the sched_waking event.
 
 
 [source,shell]
 ----
   # trace-cmd report -w -F 'sched_switch, sched_wakeup.*'
 [...]
-       trace-cmd-16130 [003] 158131.580616: sched_wakeup: comm=trace-cmd pid=16131 prio=120 success=1 target_cpu=003
-       trace-cmd-16129 [000] 158131.581502: sched_switch: prev_comm=trace-cmd prev_pid=16129 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=16131 next_prio=120 Latency: 885.901 usecs
-       trace-cmd-16131 [000] 158131.582414: sched_wakeup: comm=trace-cmd pid=16129 prio=120 success=1 target_cpu=000
-       trace-cmd-16132 [001] 158131.583219: sched_switch: prev_comm=trace-cmd prev_pid=16132 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=16129 next_prio=120 Latency: 804.809 usecs
-           sleep-16133 [002] 158131.584121: sched_wakeup: comm=trace-cmd pid=16120 prio=120 success=1 target_cpu=002
-       trace-cmd-16129 [001] 158131.584128: sched_wakeup: comm=trace-cmd pid=16132 prio=120 success=1 target_cpu=001
-           sleep-16133 [002] 158131.584275: sched_switch: prev_comm=sleep prev_pid=16133 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=16120 next_prio=120 Latency: 153.915 usecs
-       trace-cmd-16130 [003] 158131.585284: sched_switch: prev_comm=trace-cmd prev_pid=16130 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=16132 next_prio=120 Latency: 1155.677 usecs
-
-Average wakeup latency: 26626.656 usecs
+       trace-cmd-89141 [007] d..2. 162583.263060: sched_switch:         trace-cmd:89141 [120] R ==> trace-cmd:89135 [120]
+   kworker/u36:1-51219 [000] d..2. 162583.266957: sched_switch:         kworker/u36:1:51219 [120] R ==> kworker/u33:2:49692 [120] Latency: 4024.977 usecs
+       trace-cmd-89135 [007] d..2. 162583.267109: sched_switch:         trace-cmd:89135 [120] R ==> trace-cmd:89141 [120]
+       trace-cmd-89139 [001] d..2. 162583.267147: sched_switch:         trace-cmd:89139 [120] D ==> swapper/1:0 [120]
+   kworker/u36:2-88857 [002] d..2. 162583.267913: sched_switch:         kworker/u36:2:88857 [120] R ==> trace-cmd:89136 [120]
+   kworker/u33:2-49692 [000] d..2. 162583.268334: sched_switch:         kworker/u33:2:49692 [120] I ==> kworker/u36:1:51219 [120]
+          <idle>-0     [001] dNh4. 162583.268747: sched_wakeup:         sleep:89142 [120] CPU:001
+          <idle>-0     [001] d..2. 162583.268833: sched_switch:         swapper/1:0 [120] R ==> sleep:89142 [120] Latency: 85.751 usecs
+           sleep-89142 [001] d.h4. 162583.269022: sched_wakeup:         trace-cmd:89139 [120] CPU:001
+       trace-cmd-89141 [007] d..2. 162583.271009: sched_switch:         trace-cmd:89141 [120] R ==> trace-cmd:89135 [120]
+       trace-cmd-89136 [002] d..2. 162583.271020: sched_switch:         trace-cmd:89136 [120] R ==> kworker/u36:2:88857 [120]
+   kworker/u36:2-88857 [002] d..2. 162583.271079: sched_switch:         kworker/u36:2:88857 [120] I ==> trace-cmd:89136 [120]
+       trace-cmd-89137 [006] d.h2. 162583.273950: sched_wakeup:         trace-cmd:89133 [120] CPU:006
+           sleep-89142 [001] d..2. 162583.274064: sched_switch:         sleep:89142 [120] Z ==> trace-cmd:89139 [120] Latency: 5042.285 usecs
+       trace-cmd-89135 [007] d..2. 162583.275043: sched_switch:         trace-cmd:89135 [120] R ==> trace-cmd:89141 [120]
+       trace-cmd-89137 [006] d..2. 162583.275158: sched_switch:         trace-cmd:89137 [120] R ==> trace-cmd:89133 [120] Latency: 1207.327 usecs
+       trace-cmd-89136 [002] dNh3. 162583.275229: sched_wakeup:         rcu_preempt:17 [120] CPU:002
+       trace-cmd-89136 [002] d..2. 162583.275294: sched_switch:         trace-cmd:89136 [120] R ==> rcu_preempt:17 [120] Latency: 65.255 usecs
+     rcu_preempt-17    [002] d..2. 162583.275399: sched_switch:         rcu_preempt:17 [120] I ==> trace-cmd:89136 [120]
+
+Average wakeup latency: 20082.580 usecs
+Maximum Latency: 1032049.277 usecs at timestamp: 162574.787022
+Minimum Latency: 29.023 usecs at timestamp: 162583.189731
+
+RT task timings:
+
+Average wakeup latency: 139.568 usecs
+Maximum Latency: 220.583 usecs at timestamp: 162577.347038
+Minimum Latency: 75.902 usecs at timestamp: 162577.719121
 ----
 
 The above trace produces the wakeup latencies of the tasks. The "sched_switch"
 event reports each individual latency after writing the event information.
-At the end of the report, the average wakeup latency is reported.
+At the end of the report, the average wakeup latency is reported, as well
+as the maxim and minimum latency and the timestamp they happened at. It does
+this for both normal tasks as well as real-time tasks.
 
 [source,shell]
 ----
   # trace-cmd report -w -F 'sched_switch, sched_wakeup.*: prio < 100 || next_prio < 100'
-          <idle>-0     [003] 158131.516753: sched_wakeup: comm=ksoftirqd/3 pid=13 prio=49 success=1 target_cpu=003
-          <idle>-0     [003] 158131.516855: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/3 next_pid=13 next_prio=49 Latency: 101.244 usecs
-          <idle>-0     [003] 158131.533781: sched_wakeup: comm=ksoftirqd/3 pid=13 prio=49 success=1 target_cpu=003
-          <idle>-0     [003] 158131.533897: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/3 next_pid=13 next_prio=49 Latency: 115.608 usecs
-          <idle>-0     [003] 158131.569730: sched_wakeup: comm=ksoftirqd/3 pid=13 prio=49 success=1 target_cpu=003
-          <idle>-0     [003] 158131.569851: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/3 next_pid=13 next_prio=49 Latency: 121.024 usecs
-
-Average wakeup latency: 110.021 usecs
+cpus=8
+          <idle>-0     [001] dNh5. 162573.291142: sched_wakeup:         migration/1:23 [0] CPU:001
+          <idle>-0     [001] d..2. 162573.291237: sched_switch:         swapper/1:0 [120] R ==> migration/1:23 [0] Latency: 94.643 usecs
+       trace-cmd-89141 [002] dNh6. 162573.346785: sched_wakeup:         migration/2:28 [0] CPU:002
+       trace-cmd-89141 [002] d..2. 162573.346929: sched_switch:         trace-cmd:89141 [120] R ==> migration/2:28 [0] Latency: 143.971 usecs
+       trace-cmd-89134 [003] dNh4. 162573.410852: sched_wakeup:         migration/3:33 [0] CPU:003
+       trace-cmd-89134 [003] d..2. 162573.411039: sched_switch:         trace-cmd:89134 [120] R ==> migration/3:33 [0] Latency: 187.640 usecs
+          <idle>-0     [004] dNh5. 162573.490944: sched_wakeup:         migration/4:38 [0] CPU:004
+          <idle>-0     [004] d..2. 162573.491098: sched_switch:         swapper/4:0 [120] R ==> migration/4:38 [0] Latency: 153.913 usecs
+          <idle>-0     [005] dNh5. 162573.574955: sched_wakeup:         migration/5:43 [0] CPU:005
+          <idle>-0     [005] d..2. 162573.575107: sched_switch:         swapper/5:0 [120] R ==> migration/5:43 [0] Latency: 152.875 usecs
+          <idle>-0     [006] dNh5. 162573.646878: sched_wakeup:         migration/6:48 [0] CPU:006
+          <idle>-0     [006] d..2. 162573.646992: sched_switch:         swapper/6:0 [120] R ==> migration/6:48 [0] Latency: 113.788 usecs
+       trace-cmd-89140 [002] dNh7. 162577.346818: sched_wakeup:         migration/2:28 [0] CPU:002
+       trace-cmd-89140 [002] d..2. 162577.347038: sched_switch:         trace-cmd:89140 [120] R ==> migration/2:28 [0] Latency: 220.583 usecs
+       trace-cmd-89134 [003] dNh5. 162577.410869: sched_wakeup:         migration/3:33 [0] CPU:003
+       trace-cmd-89141 [005] dNh6. 162577.574792: sched_wakeup:         migration/5:43 [0] CPU:005
+       trace-cmd-89141 [005] d..2. 162577.574915: sched_switch:         trace-cmd:89141 [120] R ==> migration/5:43 [0] Latency: 122.648 usecs
+       trace-cmd-89136 [007] dNh6. 162577.719045: sched_wakeup:         migration/7:53 [0] CPU:007
+       trace-cmd-89136 [007] d..2. 162577.719121: sched_switch:         trace-cmd:89136 [120] R ==> migration/7:53 [0] Latency: 75.902 usecs
+       trace-cmd-89140 [005] dNh4. 162581.574827: sched_wakeup:         migration/5:43 [0] CPU:005
+       trace-cmd-89140 [005] d..2. 162581.574957: sched_switch:         trace-cmd:89140 [120] R ==> migration/5:43 [0] Latency: 129.717 usecs
+   kworker/u46:1-51211 [006] dNh4. 162581.646809: sched_wakeup:         migration/6:48 [0] CPU:006
+
+Average wakeup latency: 139.568 usecs
+Maximum Latency: 220.583 usecs at timestamp: 162577.347038
+Minimum Latency: 75.902 usecs at timestamp: 162577.719121
+
+RT task timings:
+
+Average wakeup latency: 139.568 usecs
+Maximum Latency: 220.583 usecs at timestamp: 162577.347038
+Minimum Latency: 75.902 usecs at timestamp: 162577.719121
 ----
 
 The above version will only show the wakeups and context switches of Real Time
 tasks. The 'prio' used inside the kernel starts at 0 for highest priority.
 That is 'prio' 0 is equivalent to user space real time priority 99, and
 priority 98 is equivalent to user space real time priority 1.
-Prios less than 100 represent Real Time tasks.
+Prios less than 100 represent Real Time tasks. Notice that the total wake up timings
+are identical to the RT task timings.
 
 An example of the profile:
 [source,shell]
-- 
2.43.0

