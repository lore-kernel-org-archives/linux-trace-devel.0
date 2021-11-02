Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64103C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB486120D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhKBUOe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbhKBUOe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:14:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D2561152;
        Tue,  2 Nov 2021 20:11:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mi08T-001jMD-Vo;
        Tue, 02 Nov 2021 16:11:57 -0400
Message-ID: <20211102201157.820811423@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Nov 2021 16:11:33 -0400
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
Subject: [for-next][PATCH 07/14] tracing/osnoise: Allow multiple instances of the same tracer
References: <20211102201126.559641540@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

Currently, the user can start only one instance of timerlat/osnoise
tracers and the tracers cannot run in parallel.

As starting point to add more flexibility, let's allow the same tracer to
run on different trace instances. The workload will start when the first
trace_array (instance) is registered and stop when the last instance
is unregistered.

So, while this patch allows the same tracer to run in multiple
instances (e.g., two instances running osnoise), it still does not allow
instances of timerlat and osnoise in parallel (e.g., one timerlat and
osnoise). That is because the osnoise: events have different behavior
depending on which tracer is enabled (osnoise or timerlat). Enabling
the parallel usage of these two tracers is in my TODO list.

Link: https://lkml.kernel.org/r/38c8f14b613492a4f3f938d9d3bf0b063b72f0f0.1635702894.git.bristot@kernel.org

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
 kernel/trace/trace_osnoise.c | 101 +++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 5e832e3edf1f..eb617ccb81f1 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -64,6 +64,24 @@ static bool osnoise_has_registered_instances(void)
 					list);
 }
 
+/*
+ * osnoise_instance_registered - check if a tr is already registered
+ */
+static int osnoise_instance_registered(struct trace_array *tr)
+{
+	struct osnoise_instance *inst;
+	int found = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
+		if (inst->tr == tr)
+			found = 1;
+	}
+	rcu_read_unlock();
+
+	return found;
+}
+
 /*
  * osnoise_register_instance - register a new trace instance
  *
@@ -2102,6 +2120,16 @@ static int osnoise_workload_start(void)
 {
 	int retval;
 
+	/*
+	 * Instances need to be registered after calling workload
+	 * start. Hence, if there is already an instance, the
+	 * workload was already registered. Otherwise, this
+	 * code is on the way to register the first instance,
+	 * and the workload will start.
+	 */
+	if (osnoise_has_registered_instances())
+		return 0;
+
 	osn_var_reset_all();
 
 	retval = osnoise_hook_events();
@@ -2129,6 +2157,13 @@ static int osnoise_workload_start(void)
  */
 static void osnoise_workload_stop(void)
 {
+	/*
+	 * Instances need to be unregistered before calling
+	 * stop. Hence, if there is a registered instance, more
+	 * than one instance is running, and the workload will not
+	 * yet stop. Otherwise, this code is on the way to disable
+	 * the last instance, and the workload can stop.
+	 */
 	if (osnoise_has_registered_instances())
 		return;
 
@@ -2150,7 +2185,11 @@ static void osnoise_tracer_start(struct trace_array *tr)
 {
 	int retval;
 
-	if (osnoise_has_registered_instances())
+	/*
+	 * If the instance is already registered, there is no need to
+	 * register it again.
+	 */
+	if (osnoise_instance_registered(tr))
 		return;
 
 	retval = osnoise_workload_start();
@@ -2162,18 +2201,17 @@ static void osnoise_tracer_start(struct trace_array *tr)
 
 static void osnoise_tracer_stop(struct trace_array *tr)
 {
-	if (!osnoise_has_registered_instances())
-		return;
-
 	osnoise_unregister_instance(tr);
 	osnoise_workload_stop();
 }
 
 static int osnoise_tracer_init(struct trace_array *tr)
 {
-
-	/* Only allow one instance to enable this */
-	if (osnoise_has_registered_instances())
+	/*
+	 * Only allow osnoise tracer if timerlat tracer is not running
+	 * already.
+	 */
+	if (timerlat_enabled())
 		return -EBUSY;
 
 	tr->max_latency = 0;
@@ -2202,45 +2240,55 @@ static void timerlat_tracer_start(struct trace_array *tr)
 {
 	int retval;
 
-	if (osnoise_has_registered_instances())
+	/*
+	 * If the instance is already registered, there is no need to
+	 * register it again.
+	 */
+	if (osnoise_instance_registered(tr))
 		return;
 
-	osnoise_data.timerlat_tracer = 1;
-
 	retval = osnoise_workload_start();
 	if (retval)
-		goto out_err;
+		pr_err(BANNER "Error starting timerlat tracer\n");
 
 	osnoise_register_instance(tr);
 
 	return;
-out_err:
-	pr_err(BANNER "Error starting timerlat tracer\n");
 }
 
 static void timerlat_tracer_stop(struct trace_array *tr)
 {
 	int cpu;
 
-	if (!osnoise_has_registered_instances())
-		return;
-
-	for_each_online_cpu(cpu)
-		per_cpu(per_cpu_osnoise_var, cpu).sampling = 0;
+	osnoise_unregister_instance(tr);
 
-	osnoise_tracer_stop(tr);
+	/*
+	 * Instruct the threads to stop only if this is the last instance.
+	 */
+	if (!osnoise_has_registered_instances()) {
+		for_each_online_cpu(cpu)
+			per_cpu(per_cpu_osnoise_var, cpu).sampling = 0;
+	}
 
-	osnoise_data.timerlat_tracer = 0;
+	osnoise_workload_stop();
 }
 
 static int timerlat_tracer_init(struct trace_array *tr)
 {
-	/* Only allow one instance to enable this */
-	if (osnoise_has_registered_instances())
+	/*
+	 * Only allow timerlat tracer if osnoise tracer is not running already.
+	 */
+	if (osnoise_has_registered_instances() && !osnoise_data.timerlat_tracer)
 		return -EBUSY;
 
-	tr->max_latency = 0;
+	/*
+	 * If this is the first instance, set timerlat_tracer to block
+	 * osnoise tracer start.
+	 */
+	if (!osnoise_has_registered_instances())
+		osnoise_data.timerlat_tracer = 1;
 
+	tr->max_latency = 0;
 	timerlat_tracer_start(tr);
 
 	return 0;
@@ -2249,6 +2297,13 @@ static int timerlat_tracer_init(struct trace_array *tr)
 static void timerlat_tracer_reset(struct trace_array *tr)
 {
 	timerlat_tracer_stop(tr);
+
+	/*
+	 * If this is the last instance, reset timerlat_tracer allowing
+	 * osnoise to be started.
+	 */
+	if (!osnoise_has_registered_instances())
+		osnoise_data.timerlat_tracer = 0;
 }
 
 static struct tracer timerlat_tracer __read_mostly = {
-- 
2.33.0
