Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B790FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A406661078
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhJKOjC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:39:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:59446 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238864AbhJKOjB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:39:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-7B8wISHsPaC8UiLWm0lnYA-1; Mon, 11 Oct 2021 10:36:59 -0400
X-MC-Unique: 7B8wISHsPaC8UiLWm0lnYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B70611922962;
        Mon, 11 Oct 2021 14:36:57 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E855019C59;
        Mon, 11 Oct 2021 14:36:53 +0000 (UTC)
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
Subject: [PATCH V2 05/19] trace/osnoise: Allow multiple instances of the same tracer
Date:   Mon, 11 Oct 2021 16:35:53 +0200
Message-Id: <ee3a6ce53f82637e4e16e6489ee427fd23c5881b.1633958325.git.bristot@kernel.org>
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

Allow more than one instance of the same tracer. The workload will
start when the first trace_array (instance) is registered and will
stop when the last instance is unregistered.

Osnoise and timerlat are still mutually exclusive because of the
different behavior of the osnoise: tracepoints.

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
 kernel/trace/trace_osnoise.c | 106 ++++++++++++++++++++++++++---------
 1 file changed, 80 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index a6d8f514bd7c..f913964f6861 100644
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
@@ -106,10 +124,8 @@ static void osnoise_unregister_instance(struct trace_array *tr)
 	}
 	rcu_read_unlock();
 
-	if (!found) {
-		WARN("osnoise unregister did not find tr %s\n", tr->name);
+	if (!found)
 		return;
-	}
 
 	synchronize_rcu();
 	kfree(inst);
@@ -1190,6 +1206,7 @@ static __always_inline void osnoise_stop_tracing(void)
 				"stop tracing hit on cpu %d\n", smp_processor_id());
 
 		tracer_tracing_off(tr);
+
 	}
 	rcu_read_unlock();
 }
@@ -2041,6 +2058,16 @@ static int osnoise_workload_start(void)
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
@@ -2066,6 +2093,13 @@ static int osnoise_workload_start(void)
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
 
@@ -2083,7 +2117,11 @@ static void osnoise_tracer_start(struct trace_array *tr)
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
@@ -2095,18 +2133,17 @@ static void osnoise_tracer_start(struct trace_array *tr)
 
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
+	if (osnoise_data.timerlat_tracer)
 		return -EBUSY;
 
 	tr->max_latency = 0;
@@ -2135,45 +2172,55 @@ static void timerlat_tracer_start(struct trace_array *tr)
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
@@ -2182,6 +2229,13 @@ static int timerlat_tracer_init(struct trace_array *tr)
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
2.31.1

