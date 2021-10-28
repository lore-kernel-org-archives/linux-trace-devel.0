Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BD2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6299610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhJ1Vd7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:33:59 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:44795 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231476AbhJ1Vdn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 17:33:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-oVqn8P78NXq7hJH7--7TVQ-1; Thu, 28 Oct 2021 17:31:14 -0400
X-MC-Unique: oVqn8P78NXq7hJH7--7TVQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E08B918414A3;
        Thu, 28 Oct 2021 21:31:12 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 341C1100EBBE;
        Thu, 28 Oct 2021 21:31:09 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V7 6/9] trace/osnoise: Remove TIMERLAT ifdefs from inside functions
Date:   Thu, 28 Oct 2021 23:29:34 +0200
Message-Id: <4e332a1792a0b7999f410fb7910ed438997daa18.1635452903.git.bristot@kernel.org>
In-Reply-To: <cover.1635452903.git.bristot@kernel.org>
References: <cover.1635452903.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove CONFIG_TIMERLAT_TRACER from inside functions, avoiding
compilation problems in the future.

Cc: Steven Rostedt <rostedt@goodmis.org>
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
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 kernel/trace/trace_osnoise.c | 142 +++++++++++++++++++++++------------
 1 file changed, 96 insertions(+), 46 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 3db506f49a90..4ee6ff6a483b 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -321,6 +321,47 @@ static struct osnoise_data {
 #endif
 };
 
+#ifdef CONFIG_TIMERLAT_TRACER
+static inline bool timerlat_enabled(void)
+{
+	return osnoise_data.timerlat_tracer;
+}
+
+static inline void timerlat_softirq_exit(struct osnoise_variables *osn_var)
+{
+	struct timerlat_variables *tlat_var = this_cpu_tmr_var();
+	/*
+	 * If the timerlat is enabled, but the irq handler did
+	 * not run yet enabling timerlat_tracer, do not trace.
+	 */
+	if (!tlat_var->tracing_thread) {
+		osn_var->softirq.arrival_time = 0;
+		osn_var->softirq.delta_start = 0;
+	}
+}
+
+static inline void timerlat_thread_exit(struct osnoise_variables *osn_var)
+{
+	struct timerlat_variables *tlat_var = this_cpu_tmr_var();
+	/*
+	 * If the timerlat is enabled, but the irq handler did
+	 * not run yet enabling timerlat_tracer, do not trace.
+	 */
+	if (!tlat_var->tracing_thread) {
+		osn_var->thread.delta_start = 0;
+		osn_var->thread.arrival_time = 0;
+	}
+}
+#else /* CONFIG_TIMERLAT_TRACER */
+static inline bool timerlat_enabled(void)
+{
+	return false;
+}
+
+static inline void timerlat_softirq_exit(struct osnoise_variables *osn_var) {}
+static inline void timerlat_thread_exit(struct osnoise_variables *osn_var) {}
+#endif
+
 #ifdef CONFIG_PREEMPT_RT
 /*
  * Print the osnoise header info.
@@ -977,21 +1018,8 @@ static void trace_softirq_exit_callback(void *data, unsigned int vec_nr)
 	if (!osn_var->sampling)
 		return;
 
-#ifdef CONFIG_TIMERLAT_TRACER
-	/*
-	 * If the timerlat is enabled, but the irq handler did
-	 * not run yet enabling timerlat_tracer, do not trace.
-	 */
-	if (unlikely(osnoise_data.timerlat_tracer)) {
-		struct timerlat_variables *tlat_var;
-		tlat_var = this_cpu_tmr_var();
-		if (!tlat_var->tracing_thread) {
-			osn_var->softirq.arrival_time = 0;
-			osn_var->softirq.delta_start = 0;
-			return;
-		}
-	}
-#endif
+	if (unlikely(timerlat_enabled()))
+		timerlat_softirq_exit(osn_var);
 
 	duration = get_int_safe_duration(osn_var, &osn_var->softirq.delta_start);
 	trace_softirq_noise(vec_nr, osn_var->softirq.arrival_time, duration);
@@ -1085,17 +1113,8 @@ thread_exit(struct osnoise_variables *osn_var, struct task_struct *t)
 	if (!osn_var->sampling)
 		return;
 
-#ifdef CONFIG_TIMERLAT_TRACER
-	if (osnoise_data.timerlat_tracer) {
-		struct timerlat_variables *tlat_var;
-		tlat_var = this_cpu_tmr_var();
-		if (!tlat_var->tracing_thread) {
-			osn_var->thread.delta_start = 0;
-			osn_var->thread.arrival_time = 0;
-			return;
-		}
-	}
-#endif
+	if (unlikely(timerlat_enabled()))
+		timerlat_thread_exit(osn_var);
 
 	duration = get_int_safe_duration(osn_var, &osn_var->thread.delta_start);
 
@@ -1599,6 +1618,11 @@ static int timerlat_main(void *data)
 	hrtimer_cancel(&tlat->timer);
 	return 0;
 }
+#else /* CONFIG_TIMERLAT_TRACER */
+static int timerlat_main(void *data)
+{
+	return 0;
+}
 #endif /* CONFIG_TIMERLAT_TRACER */
 
 /*
@@ -1641,16 +1665,13 @@ static int start_kthread(unsigned int cpu)
 	void *main = osnoise_main;
 	char comm[24];
 
-#ifdef CONFIG_TIMERLAT_TRACER
-	if (osnoise_data.timerlat_tracer) {
+	if (timerlat_enabled()) {
 		snprintf(comm, 24, "timerlat/%d", cpu);
 		main = timerlat_main;
 	} else {
 		snprintf(comm, 24, "osnoise/%d", cpu);
 	}
-#else
-	snprintf(comm, 24, "osnoise/%d", cpu);
-#endif
+
 	kthread = kthread_create_on_cpu(main, NULL, cpu, comm);
 
 	if (IS_ERR(kthread)) {
@@ -1944,6 +1965,35 @@ static const struct file_operations cpus_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+#ifdef CONFIG_TIMERLAT_TRACER
+/*
+ * init_timerlat_tracefs - A function to initialize the timerlat interface files
+ */
+static int init_timerlat_tracefs(struct dentry *top_dir)
+{
+	struct dentry *tmp;
+
+#ifdef CONFIG_STACKTRACE
+	tmp = tracefs_create_file("print_stack", 0640, top_dir,
+				  &osnoise_print_stack, &trace_min_max_fops);
+	if (!tmp)
+		return -ENOMEM;
+#endif
+
+	tmp = tracefs_create_file("timerlat_period_us", 0640, top_dir,
+				  &timerlat_period, &trace_min_max_fops);
+	if (!tmp)
+		return -ENOMEM;
+
+	return 0;
+}
+#else /* CONFIG_TIMERLAT_TRACER */
+static int init_timerlat_tracefs(struct dentry *top_dir)
+{
+	return 0;
+}
+#endif /* CONFIG_TIMERLAT_TRACER */
+
 /*
  * init_tracefs - A function to initialize the tracefs interface files
  *
@@ -1988,19 +2038,10 @@ static int init_tracefs(void)
 	tmp = trace_create_file("cpus", 0644, top_dir, NULL, &cpus_fops);
 	if (!tmp)
 		goto err;
-#ifdef CONFIG_TIMERLAT_TRACER
-#ifdef CONFIG_STACKTRACE
-	tmp = tracefs_create_file("print_stack", 0640, top_dir,
-				  &osnoise_print_stack, &trace_min_max_fops);
-	if (!tmp)
-		goto err;
-#endif
 
-	tmp = tracefs_create_file("timerlat_period_us", 0640, top_dir,
-				  &timerlat_period, &trace_min_max_fops);
-	if (!tmp)
+	ret = init_timerlat_tracefs(top_dir);
+	if (ret)
 		goto err;
-#endif
 
 	return 0;
 
@@ -2206,6 +2247,16 @@ static struct tracer timerlat_tracer __read_mostly = {
 	.print_header	= print_timerlat_headers,
 	.allow_instances = true,
 };
+
+__init static int init_timerlat_tracer(void)
+{
+	return register_tracer(&timerlat_tracer);
+}
+#else /* CONFIG_TIMERLAT_TRACER */
+__init static int init_timerlat_tracer(void)
+{
+	return 0;
+}
 #endif /* CONFIG_TIMERLAT_TRACER */
 
 __init static int init_osnoise_tracer(void)
@@ -2222,13 +2273,12 @@ __init static int init_osnoise_tracer(void)
 		return ret;
 	}
 
-#ifdef CONFIG_TIMERLAT_TRACER
-	ret = register_tracer(&timerlat_tracer);
+	ret = init_timerlat_tracer();
 	if (ret) {
-		pr_err(BANNER "Error registering timerlat\n");
+		pr_err(BANNER "Error registering timerlat!\n");
 		return ret;
 	}
-#endif
+
 	osnoise_init_hotplug_support();
 
 	INIT_LIST_HEAD_RCU(&osnoise_instances);
-- 
2.31.1

