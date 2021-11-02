Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0861FC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F356117A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhKBUOe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhKBUOd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:14:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F7C61167;
        Tue,  2 Nov 2021 20:11:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mi08T-001jJz-78;
        Tue, 02 Nov 2021 16:11:57 -0400
Message-ID: <20211102201157.055451990@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Nov 2021 16:11:29 -0400
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
Subject: [for-next][PATCH 03/14] tracing/osnoise: Split workload start from the tracer start
References: <20211102201126.559641540@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

In preparation from supporting multiple trace instances, create
workload start/stop specific functions.

No functional change.

Link: https://lkml.kernel.org/r/74b090971e9acdd13625be1c28ef3270d2275e77.1635702894.git.bristot@kernel.org

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
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 59 ++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 7d6be609d3dd..5279a4990493 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1546,7 +1546,7 @@ static int start_kthread(unsigned int cpu)
  * This starts the kernel thread that will look for osnoise on many
  * cpus.
  */
-static int start_per_cpu_kthreads(struct trace_array *tr)
+static int start_per_cpu_kthreads(void)
 {
 	struct cpumask *current_mask = &save_cpumask;
 	int retval = 0;
@@ -1678,8 +1678,8 @@ osnoise_cpus_read(struct file *filp, char __user *ubuf, size_t count,
 	return count;
 }
 
-static void osnoise_tracer_start(struct trace_array *tr);
-static void osnoise_tracer_stop(struct trace_array *tr);
+static int osnoise_workload_start(void);
+static void osnoise_workload_stop(void);
 
 /*
  * osnoise_cpus_write - Write function for "cpus" entry
@@ -1701,7 +1701,6 @@ static ssize_t
 osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 		   loff_t *ppos)
 {
-	struct trace_array *tr = osnoise_trace;
 	cpumask_var_t osnoise_cpumask_new;
 	int running, err;
 	char buf[256];
@@ -1726,7 +1725,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_lock(&trace_types_lock);
 	running = osnoise_busy;
 	if (running)
-		osnoise_tracer_stop(tr);
+		osnoise_workload_stop();
 
 	mutex_lock(&interface_lock);
 	/*
@@ -1740,7 +1739,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_unlock(&interface_lock);
 
 	if (running)
-		osnoise_tracer_start(tr);
+		osnoise_workload_start();
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(osnoise_cpumask_new);
@@ -1921,7 +1920,10 @@ static int osnoise_hook_events(void)
 	return -EINVAL;
 }
 
-static int __osnoise_tracer_start(struct trace_array *tr)
+/*
+ * osnoise_workload_start - start the workload and hook to events
+ */
+static int osnoise_workload_start(void)
 {
 	int retval;
 
@@ -1938,7 +1940,7 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 	barrier();
 	trace_osnoise_callback_enabled = true;
 
-	retval = start_per_cpu_kthreads(tr);
+	retval = start_per_cpu_kthreads();
 	if (retval) {
 		unhook_irq_events();
 		return retval;
@@ -1949,20 +1951,10 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 	return 0;
 }
 
-static void osnoise_tracer_start(struct trace_array *tr)
-{
-	int retval;
-
-	if (osnoise_busy)
-		return;
-
-	retval = __osnoise_tracer_start(tr);
-	if (retval)
-		pr_err(BANNER "Error starting osnoise tracer\n");
-
-}
-
-static void osnoise_tracer_stop(struct trace_array *tr)
+/*
+ * osnoise_workload_stop - stop the workload and unhook the events
+ */
+static void osnoise_workload_stop(void)
 {
 	if (!osnoise_busy)
 		return;
@@ -1983,6 +1975,27 @@ static void osnoise_tracer_stop(struct trace_array *tr)
 	osnoise_busy = false;
 }
 
+static void osnoise_tracer_start(struct trace_array *tr)
+{
+	int retval;
+
+	if (osnoise_busy)
+		return;
+
+	retval = osnoise_workload_start();
+	if (retval)
+		pr_err(BANNER "Error starting osnoise tracer\n");
+
+}
+
+static void osnoise_tracer_stop(struct trace_array *tr)
+{
+	if (!osnoise_busy)
+		return;
+
+	osnoise_workload_stop();
+}
+
 static int osnoise_tracer_init(struct trace_array *tr)
 {
 
@@ -2023,7 +2036,7 @@ static void timerlat_tracer_start(struct trace_array *tr)
 
 	osnoise_data.timerlat_tracer = 1;
 
-	retval = __osnoise_tracer_start(tr);
+	retval = osnoise_workload_start();
 	if (retval)
 		goto out_err;
 
-- 
2.33.0
