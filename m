Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF07C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4591F60E8F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhJaSJt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Oct 2021 14:09:49 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:53617 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231214AbhJaSJe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 14:09:34 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-tYwSfzVnPp-Y0w07geSFXg-1; Sun, 31 Oct 2021 14:06:58 -0400
X-MC-Unique: tYwSfzVnPp-Y0w07geSFXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40F5E8030A0;
        Sun, 31 Oct 2021 18:06:57 +0000 (UTC)
Received: from x1.com (unknown [10.22.8.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F87260C17;
        Sun, 31 Oct 2021 18:06:54 +0000 (UTC)
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
Subject: [PATCH V9 6/9] tracing/osnoise: Remove TIMERLAT ifdefs from inside functions
Date:   Sun, 31 Oct 2021 19:05:01 +0100
Message-Id: <8245abb5a112d249f5da6c1df499244ad9e647bc.1635702894.git.bristot@kernel.org>
In-Reply-To: <cover.1635702894.git.bristot@kernel.org>
References: <cover.1635702894.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 kernel/trace/trace_osnoise.c | 150 +++++++++++++++++++++++++----------
 1 file changed, 106 insertions(+), 44 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 490615f6d721..5e832e3edf1f 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -321,6 +321,57 @@ static struct osnoise_data {
 #endif
 };
 
+#ifdef CONFIG_TIMERLAT_TRACER
+static inline bool timerlat_enabled(void)
+{
+	return osnoise_data.timerlat_tracer;
+}
+
+static inline int timerlat_softirq_exit(struct osnoise_variables *osn_var)
+{
+	struct timerlat_variables *tlat_var = this_cpu_tmr_var();
+	/*
+	 * If the timerlat is enabled, but the irq handler did
+	 * not run yet enabling timerlat_tracer, do not trace.
+	 */
+	if (!tlat_var->tracing_thread) {
+		osn_var->softirq.arrival_time = 0;
+		osn_var->softirq.delta_start = 0;
+		return 0;
+	}
+	return 1;
+}
+
+static inline int timerlat_thread_exit(struct osnoise_variables *osn_var)
+{
+	struct timerlat_variables *tlat_var = this_cpu_tmr_var();
+	/*
+	 * If the timerlat is enabled, but the irq handler did
+	 * not run yet enabling timerlat_tracer, do not trace.
+	 */
+	if (!tlat_var->tracing_thread) {
+		osn_var->thread.delta_start = 0;
+		osn_var->thread.arrival_time = 0;
+		return 0;
+	}
+	return 1;
+}
+#else /* CONFIG_TIMERLAT_TRACER */
+static inline bool timerlat_enabled(void)
+{
+	return false;
+}
+
+static inline int timerlat_softirq_exit(struct osnoise_variables *osn_var)
+{
+	return 1;
+}
+static inline int timerlat_thread_exit(struct osnoise_variables *osn_var)
+{
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_PREEMPT_RT
 /*
  * Print the osnoise header info.
@@ -978,21 +1029,9 @@ static void trace_softirq_exit_callback(void *data, unsigned int vec_nr)
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
+	if (unlikely(timerlat_enabled()))
+		if (!timerlat_softirq_exit(osn_var))
 			return;
-		}
-	}
-#endif
 
 	duration = get_int_safe_duration(osn_var, &osn_var->softirq.delta_start);
 	trace_softirq_noise(vec_nr, osn_var->softirq.arrival_time, duration);
@@ -1086,17 +1125,9 @@ thread_exit(struct osnoise_variables *osn_var, struct task_struct *t)
 	if (!osn_var->sampling)
 		return;
 
-#ifdef CONFIG_TIMERLAT_TRACER
-	if (osnoise_data.timerlat_tracer) {
-		struct timerlat_variables *tlat_var;
-		tlat_var = this_cpu_tmr_var();
-		if (!tlat_var->tracing_thread) {
-			osn_var->thread.delta_start = 0;
-			osn_var->thread.arrival_time = 0;
+	if (unlikely(timerlat_enabled()))
+		if (!timerlat_thread_exit(osn_var))
 			return;
-		}
-	}
-#endif
 
 	duration = get_int_safe_duration(osn_var, &osn_var->thread.delta_start);
 
@@ -1600,6 +1631,11 @@ static int timerlat_main(void *data)
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
@@ -1642,16 +1678,13 @@ static int start_kthread(unsigned int cpu)
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
@@ -1945,6 +1978,35 @@ static const struct file_operations cpus_fops = {
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
+	tmp = tracefs_create_file("print_stack", TRACE_MODE_WRITE, top_dir,
+				  &osnoise_print_stack, &trace_min_max_fops);
+	if (!tmp)
+		return -ENOMEM;
+#endif
+
+	tmp = tracefs_create_file("timerlat_period_us", TRACE_MODE_WRITE, top_dir,
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
@@ -1989,19 +2051,10 @@ static int init_tracefs(void)
 	tmp = trace_create_file("cpus", TRACE_MODE_WRITE, top_dir, NULL, &cpus_fops);
 	if (!tmp)
 		goto err;
-#ifdef CONFIG_TIMERLAT_TRACER
-#ifdef CONFIG_STACKTRACE
-	tmp = tracefs_create_file("print_stack", TRACE_MODE_WRITE, top_dir,
-				  &osnoise_print_stack, &trace_min_max_fops);
-	if (!tmp)
-		goto err;
-#endif
 
-	tmp = tracefs_create_file("timerlat_period_us", TRACE_MODE_WRITE, top_dir,
-				  &timerlat_period, &trace_min_max_fops);
-	if (!tmp)
+	ret = init_timerlat_tracefs(top_dir);
+	if (ret)
 		goto err;
-#endif
 
 	return 0;
 
@@ -2207,6 +2260,16 @@ static struct tracer timerlat_tracer __read_mostly = {
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
@@ -2223,13 +2286,12 @@ __init static int init_osnoise_tracer(void)
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

