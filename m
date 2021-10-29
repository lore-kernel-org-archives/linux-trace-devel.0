Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6EEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9276F60E98
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ2TEd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:04:33 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:50653 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231497AbhJ2TEX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 15:04:23 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-5Y0yUTR8NuCFYhK3Ydjsag-1; Fri, 29 Oct 2021 15:01:51 -0400
X-MC-Unique: 5Y0yUTR8NuCFYhK3Ydjsag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92B5218125C0;
        Fri, 29 Oct 2021 19:01:49 +0000 (UTC)
Received: from x1.com (unknown [10.22.10.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B8275D9CA;
        Fri, 29 Oct 2021 19:01:43 +0000 (UTC)
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
Subject: [PATCH V8 8/9] tracing/osnoise: Remove STACKTRACE ifdefs from inside functions
Date:   Fri, 29 Oct 2021 21:00:34 +0200
Message-Id: <07efa556c83cde06e01c4fe036fcc8b32011f4cd.1635533292.git.bristot@kernel.org>
In-Reply-To: <cover.1635533292.git.bristot@kernel.org>
References: <cover.1635533292.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove CONFIG_STACKTRACE from inside functions, avoiding
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
 kernel/trace/trace_osnoise.c | 44 ++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 91d7b4bc166c..2594193aa30e 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -645,13 +645,19 @@ __timerlat_dump_stack(struct trace_buffer *buffer, struct trace_stack *fstack, u
 /*
  * timerlat_dump_stack - dump a stack trace previously saved
  */
-static void timerlat_dump_stack(void)
+static void timerlat_dump_stack(u64 latency)
 {
 	struct osnoise_instance *inst;
 	struct trace_buffer *buffer;
 	struct trace_stack *fstack;
 	unsigned int size;
 
+	/*
+	 * trace only if latency > print_stack config, if enabled.
+	 */
+	if (!osnoise_data.print_stack || osnoise_data.print_stack > latency)
+		return;
+
 	preempt_disable_notrace();
 	fstack = this_cpu_ptr(&trace_stack);
 	size = fstack->stack_size;
@@ -665,8 +671,8 @@ static void timerlat_dump_stack(void)
 	rcu_read_unlock();
 	preempt_enable_notrace();
 }
-#else
-#define timerlat_dump_stack() do {} while (0)
+#else /* CONFIG_STACKTRACE */
+#define timerlat_dump_stack(u64 latency) do {} while (0)
 #define timerlat_save_stack(a) do {} while (0)
 #endif /* CONFIG_STACKTRACE */
 #endif /* CONFIG_TIMERLAT_TRACER */
@@ -1631,11 +1637,7 @@ static int timerlat_main(void *data)
 
 		trace_timerlat_sample(&s);
 
-#ifdef CONFIG_STACKTRACE
-		if (osnoise_data.print_stack)
-			if (osnoise_data.print_stack <= time_to_us(diff))
-				timerlat_dump_stack();
-#endif /* CONFIG_STACKTRACE */
+		timerlat_dump_stack(time_to_us(diff));
 
 		tlat->tracing_thread = false;
 		if (osnoise_data.stop_tracing_total)
@@ -1996,26 +1998,38 @@ static const struct file_operations cpus_fops = {
 };
 
 #ifdef CONFIG_TIMERLAT_TRACER
-/*
- * init_timerlat_tracefs - A function to initialize the timerlat interface files
- */
-static int init_timerlat_tracefs(struct dentry *top_dir)
+#ifdef CONFIG_STACKTRACE
+static int init_timerlat_stack_tracefs(struct dentry *top_dir)
 {
 	struct dentry *tmp;
 
-#ifdef CONFIG_STACKTRACE
 	tmp = tracefs_create_file("print_stack", 0640, top_dir,
 				  &osnoise_print_stack, &trace_min_max_fops);
 	if (!tmp)
 		return -ENOMEM;
-#endif
+
+	return 0;
+}
+#else /* CONFIG_STACKTRACE */
+static int init_timerlat_stack_tracefs(struct dentry *top_dir)
+{
+	return 0;
+}
+#endif /* CONFIG_STACKTRACE */
+
+/*
+ * init_timerlat_tracefs - A function to initialize the timerlat interface files
+ */
+static int init_timerlat_tracefs(struct dentry *top_dir)
+{
+	struct dentry *tmp;
 
 	tmp = tracefs_create_file("timerlat_period_us", 0640, top_dir,
 				  &timerlat_period, &trace_min_max_fops);
 	if (!tmp)
 		return -ENOMEM;
 
-	return 0;
+	return init_timerlat_stack_tracefs(top_dir);
 }
 #else /* CONFIG_TIMERLAT_TRACER */
 static int init_timerlat_tracefs(struct dentry *top_dir)
-- 
2.31.1

