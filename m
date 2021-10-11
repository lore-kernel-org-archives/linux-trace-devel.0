Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D391C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F3A360EB6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbhJKOmL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:42:11 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:33885 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244304AbhJKOkq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:40:46 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-0_u4_U2LM2uk8Qz7o0uXIQ-1; Mon, 11 Oct 2021 10:38:45 -0400
X-MC-Unique: 0_u4_U2LM2uk8Qz7o0uXIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FA20801B3C;
        Mon, 11 Oct 2021 14:38:43 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDDC719C59;
        Mon, 11 Oct 2021 14:38:38 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 18/19] rtla: Add rtla timerlat top documentation
Date:   Mon, 11 Oct 2021 16:36:06 +0200
Message-Id: <b7cfe1d7600672434032e0cfca213dcf98cdaaf2.1633958325.git.bristot@kernel.org>
In-Reply-To: <cover.1633958325.git.bristot@kernel.org>
References: <cover.1633958325.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man page for rtla timerlat top mode.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 .../rtla/Documentation/rtla-timerlat-top.txt  | 181 ++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat-top.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-timerlat-top.txt b/tools/tracing/rtla/Documentation/rtla-timerlat-top.txt
new file mode 100644
index 000000000000..59bc8f2ea6cd
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-timerlat-top.txt
@@ -0,0 +1,181 @@
+rtla-timerlat-top(1)
+====================
+
+NAME
+----
+rtla-timerlat-top - Measures the operating system timer latency
+
+SYNOPSIS
+--------
+*rtla timerlat top* ['OPTIONS'] ...
+
+DESCRIPTION
+The rtla-timerlat-top(1) mode displays a summary of the periodic output
+from the timerlat tracer.
+
+The timerlat tracer dispatches a kernel thread per-cpu. These threads
+set a periodic timer to wake themselves up and go back to sleep. After
+the wakeup, they collect and generate useful information for the
+debugging of operating system timer latency.
+
+The timerlat tracer outputs information in two ways. It periodically
+prints the timer latency at the timer 'IRQ' handler and the 'Thread' handler.
+It also provides information for each noise via the osnoise tracepoints
+that can be seem with the option -T.
+
+OPTIONS
+-------
+*-h*, *--help*::
+Print help menu.
+*-p*, *--period* 'us'::
+Set the timerlat tracer period in microseconds.
+*-i*, *--irq* 'us'::
+Stop trace if the irq latency is higher than the argument in us.
+*-T*, *--thread* 'us'::
+Stop trace if the thread latency is higher than the argument in us.
+*-s*, *--stack* 'us'::
+Save the stack trace at the IRQ if a thread latency is higher than the
+argument in us.
+*-c*, *--cpus* 'cpu-list'::
+Set the timerlat tracer to run the sample threads in the cpu-list.
+*-d*, *--duration* 'time[s|m|h|d]'::
+Set the duration of the session.
+*-T*, *--trace*['=file']::
+Save the stopped trace to ['file|timerlat_trace.txt'].
+*-q*, *--quiet*::
+Print only a summary at the end of the session.
+*-P*, *--priority* 'o:prio|r:prio|f:prio|d:runtime:period'::
+Set scheduling parameters to the timerlat tracer threads, the format to set
+the priority are:
+  - 'o:prio' - use SCHED_OTHER with 'prio';
+  - 'r:prio' - use SCHED_RR with 'prio';
+  - 'f:prio' - use SCHED_FIFO with 'prio';
+  - 'd:runtime[us|ms|s]:period[us|ms|s]' - use SCHED_DEADLINE with 'runtime'
+and 'period' in nanoseconds.
+
+EXAMPLE
+-------
+
+In the example below, the timerlat tracer is set to capture the stack trace at
+the IRQ handler, printing it to the buffer if the *Thread Timer Latency* is
+higher than _30 us_. It is also set to stop the session if a *Thread Timer
+Latency* higher than _30 us_ is hit. Finally, it is set to save the trace
+buffer if the stop condition is hit.
+
+-------------------------------------------------------
+[root@alien ~]# rtla timerlat top -s 30 -t 30 -T
+                 Timer Latency
+  0 00:00:59   |          IRQ Timer Latency (us)        |         Thread Timer Latency (us)
+CPU COUNT      |      cur       min       avg       max |      cur       min       avg       max
+  0 #58634     |        1         0         1        10 |       11         2        10        23
+  1 #58634     |        1         0         1         9 |       12         2         9        23
+  2 #58634     |        0         0         1        11 |       10         2         9        23
+  3 #58634     |        1         0         1        11 |       11         2         9        24
+  4 #58634     |        1         0         1        10 |       11         2         9        26
+  5 #58634     |        1         0         1         8 |       10         2         9        25
+  6 #58634     |       12         0         1        12 |       30         2        10        30 <--- CPU with spike
+  7 #58634     |        1         0         1         9 |       11         2         9        23
+  8 #58633     |        1         0         1         9 |       11         2         9        26
+  9 #58633     |        1         0         1         9 |       10         2         9        26
+ 10 #58633     |        1         0         1        13 |       11         2         9        28
+ 11 #58633     |        1         0         1        13 |       12         2         9        24
+ 12 #58633     |        1         0         1         8 |       10         2         9        23
+ 13 #58633     |        1         0         1        10 |       10         2         9        22
+ 14 #58633     |        1         0         1        18 |       12         2         9        27
+ 15 #58633     |        1         0         1        10 |       11         2         9        28
+ 16 #58633     |        0         0         1        11 |        7         2         9        26
+ 17 #58633     |        1         0         1        13 |       10         2         9        24
+ 18 #58633     |        1         0         1         9 |       13         2         9        22
+ 19 #58633     |        1         0         1        10 |       11         2         9        23
+ 20 #58633     |        1         0         1        12 |       11         2         9        28
+ 21 #58633     |        1         0         1        14 |       11         2         9        24
+ 22 #58633     |        1         0         1         8 |       11         2         9        22
+ 23 #58633     |        1         0         1        10 |       11         2         9        27
+timerlat hit stop tracing
+saving trace to timerlat_trace.txt
+[root@alien bristot]# tail -60 timerlat_trace.txt
+[...]
+      timerlat/5-79755   [005] .......   426.271226: #58634 context thread timer_latency     10823 ns
+              sh-109404  [006] dnLh213   426.271247: #58634 context    irq timer_latency     12505 ns
+              sh-109404  [006] dNLh313   426.271258: irq_noise: local_timer:236 start 426.271245463 duration 12553 ns
+              sh-109404  [006] d...313   426.271263: thread_noise:       sh:109404 start 426.271245853 duration 4769 ns
+      timerlat/6-79756   [006] .......   426.271264: #58634 context thread timer_latency     30328 ns
+      timerlat/6-79756   [006] ....1..   426.271265: <stack trace>
+ => timerlat_irq
+ => __hrtimer_run_queues
+ => hrtimer_interrupt
+ => __sysvec_apic_timer_interrupt
+ => sysvec_apic_timer_interrupt
+ => asm_sysvec_apic_timer_interrupt
+ => _raw_spin_unlock_irqrestore			<---- spinlock that disabled interrupt.
+ => try_to_wake_up
+ => autoremove_wake_function
+ => __wake_up_common
+ => __wake_up_common_lock
+ => ep_poll_callback
+ => __wake_up_common
+ => __wake_up_common_lock
+ => fsnotify_add_event
+ => inotify_handle_inode_event
+ => fsnotify
+ => __fsnotify_parent
+ => __fput
+ => task_work_run
+ => exit_to_user_mode_prepare
+ => syscall_exit_to_user_mode
+ => do_syscall_64
+ => entry_SYSCALL_64_after_hwframe
+ => 0x7265000001378c
+ => 0x10000cea7
+ => 0x25a00000204a
+ => 0x12e302d00000000
+ => 0x19b51010901b6
+ => 0x283ce00726500
+ => 0x61ea308872
+ => 0x00000fe3
+            bash-109109  [007] d..h...   426.271265: #58634 context    irq timer_latency      1211 ns
+      timerlat/6-79756   [006] .......   426.271267: timerlat_main: stop tracing hit on cpu 6
+----------------------------------------
+
+In the trace, it is possible the notice that the *IRQ Timer Latency* was
+already high, accounting *12505 ns*. The IRQ delay was caused by the
+'bash-109109' process that disabled IRQs in the wake-up path
+('_try_to_wake_up()' function). The duration of the IRQ handler that woke
+up the timerlat thread, informed with the *irq_noise* event, was also high
+and added more *12553 ns* to the Thread latency. Finally, the *thread_noise*
+added by the currently running thread (including the scheduling overhead)
+added more *4769 ns*. Summing up these values, the *Thread Timer Latency*
+accounted for *30328 ns*.
+
+The primary reason for this high value is the wake-up path that was hit
+twice during this case: when the 'bash-109109' was waking up a thread
+and then when the 'timerlat' thread was awakened. This information can
+then be used as the starting point of a more fine-grained analysis.
+
+Note that timerlat was dispatched without changing timerlat threads' priority.
+That is generally not needed because the thread has priority FIFO:95 by
+default, which is a common priority used by real-time kernel developers to
+analyze scheduling delays.
+
+SEE ALSO
+--------
+_rtla-timerlat(1)_, _rtla-timerlat-hist(1)_
+
+Timerlat tracer documentation: <https://www.kernel.org/doc/html/latest/trace/timerlat-tracer.html>
+
+AUTHOR
+------
+Written by Daniel Bristot de Oliveira <bristot@kernel.org>
+
+REPORTING BUGS
+--------------
+Report bugs to <lkml@vger.kernel.org>
+
+LICENSE
+-------
+rtla is Free Software licensed under the GNU GPLv2
+
+COPYING
+-------
+Copyright \(C) 2021 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.31.1

