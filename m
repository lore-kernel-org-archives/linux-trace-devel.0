Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BE5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB6260E54
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhJaSKF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Oct 2021 14:10:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:56150 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230248AbhJaSKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 14:10:03 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-KhhkKOWEMq6puXTC2CpiOQ-1; Sun, 31 Oct 2021 14:07:27 -0400
X-MC-Unique: KhhkKOWEMq6puXTC2CpiOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 339E13630B;
        Sun, 31 Oct 2021 18:07:26 +0000 (UTC)
Received: from x1.com (unknown [10.22.8.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C960060C17;
        Sun, 31 Oct 2021 18:07:00 +0000 (UTC)
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
Subject: [PATCH V9 8/9] tracing/osnoise: Remove STACKTRACE ifdefs from inside functions
Date:   Sun, 31 Oct 2021 19:05:03 +0100
Message-Id: <3465cca2f28e1ba602a1fc8bdb28d12950b5226e.1635702894.git.bristot@kernel.org>
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
index eb617ccb81f1..a7dadf4bfc5f 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -646,13 +646,19 @@ __timerlat_dump_stack(struct trace_buffer *buffer, struct trace_stack *fstack, u
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
@@ -666,8 +672,8 @@ static void timerlat_dump_stack(void)
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
@@ -1632,11 +1638,7 @@ static int timerlat_main(void *data)
 
 		trace_timerlat_sample(&s);
 
-#ifdef CONFIG_STACKTRACE
-		if (osnoise_data.print_stack)
-			if (osnoise_data.print_stack <= time_to_us(diff))
-				timerlat_dump_stack();
-#endif /* CONFIG_STACKTRACE */
+		timerlat_dump_stack(time_to_us(diff));
 
 		tlat->tracing_thread = false;
 		if (osnoise_data.stop_tracing_total)
@@ -1997,26 +1999,38 @@ static const struct file_operations cpus_fops = {
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
 	tmp = tracefs_create_file("print_stack", TRACE_MODE_WRITE, top_dir,
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
 
 	tmp = tracefs_create_file("timerlat_period_us", TRACE_MODE_WRITE, top_dir,
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

