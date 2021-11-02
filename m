Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384F4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13319611AE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKBUOd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhKBUOc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:14:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B676B610FD;
        Tue,  2 Nov 2021 20:11:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mi08S-001jIt-RR;
        Tue, 02 Nov 2021 16:11:56 -0400
Message-ID: <20211102201156.678148671@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Nov 2021 16:11:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [for-next][PATCH 01/14] tracing/osnoise: Do not follow tracing_cpumask
References: <20211102201126.559641540@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

In preparation to support multiple instances, decouple the
osnoise/timelat workload from instance-specific tracing_cpumask.

Different instances can have conflicting cpumasks, making osnoise
workload management needlessly complex. Osnoise already has its
global cpumask.

I also thought about using the first instance mask, but the
"first" instance could be removed before the others.

This also fixes the problem that changing the tracing_mask was not
re-starting the trace.

Link: https://lkml.kernel.org/r/169a71bcc919ce3ab53ae6f9ca5cde57fffaf9c6.1635702894.git.bristot@kernel.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index d11b41784fac..ceff407655a5 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1554,13 +1554,9 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 
 	cpus_read_lock();
 	/*
-	 * Run only on CPUs in which trace and osnoise are allowed to run.
+	 * Run only on online CPUs in which osnoise is allowed to run.
 	 */
-	cpumask_and(current_mask, tr->tracing_cpumask, &osnoise_cpumask);
-	/*
-	 * And the CPU is online.
-	 */
-	cpumask_and(current_mask, cpu_online_mask, current_mask);
+	cpumask_and(current_mask, cpu_online_mask, &osnoise_cpumask);
 
 	for_each_possible_cpu(cpu)
 		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
@@ -1581,10 +1577,8 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 #ifdef CONFIG_HOTPLUG_CPU
 static void osnoise_hotplug_workfn(struct work_struct *dummy)
 {
-	struct trace_array *tr = osnoise_trace;
 	unsigned int cpu = smp_processor_id();
 
-
 	mutex_lock(&trace_types_lock);
 
 	if (!osnoise_busy)
@@ -1596,9 +1590,6 @@ static void osnoise_hotplug_workfn(struct work_struct *dummy)
 	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
 		goto out_unlock;
 
-	if (!cpumask_test_cpu(cpu, tr->tracing_cpumask))
-		goto out_unlock;
-
 	start_kthread(cpu);
 
 out_unlock:
@@ -1701,13 +1692,10 @@ static void osnoise_tracer_stop(struct trace_array *tr);
  * interface to the osnoise trace. By default, it lists all  CPUs,
  * in this way, allowing osnoise threads to run on any online CPU
  * of the system. It serves to restrict the execution of osnoise to the
- * set of CPUs writing via this interface. Note that osnoise also
- * respects the "tracing_cpumask." Hence, osnoise threads will run only
- * on the set of CPUs allowed here AND on "tracing_cpumask." Why not
- * have just "tracing_cpumask?" Because the user might be interested
- * in tracing what is running on other CPUs. For instance, one might
- * run osnoise in one HT CPU while observing what is running on the
- * sibling HT CPU.
+ * set of CPUs writing via this interface. Why not use "tracing_cpumask"?
+ * Because the user might be interested in tracing what is running on
+ * other CPUs. For instance, one might run osnoise in one HT CPU
+ * while observing what is running on the sibling HT CPU.
  */
 static ssize_t
 osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
-- 
2.33.0
