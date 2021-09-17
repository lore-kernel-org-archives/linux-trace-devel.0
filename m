Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6968C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98E061246
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbhIQPrC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:47:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:36811 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244207AbhIQPqz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:46:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-EKbK5HaGPRyRQKMMs0VBKw-1; Fri, 17 Sep 2021 11:45:29 -0400
X-MC-Unique: EKbK5HaGPRyRQKMMs0VBKw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 911F319200C0;
        Fri, 17 Sep 2021 15:45:27 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B219A5D9C6;
        Fri, 17 Sep 2021 15:45:24 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
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
Subject: [RFC 02/19] trace/osnoise: Split workload start from the tracer start
Date:   Fri, 17 Sep 2021 17:43:45 +0200
Message-Id: <b6660c3d80e76bdd07c6bb6d2b358d92183e8034.1631889858.git.bristot@kernel.org>
In-Reply-To: <cover.1631889858.git.bristot@kernel.org>
References: <cover.1631889858.git.bristot@kernel.org>
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

In preparation from supporting multiple trace instances, create
workload start/stop specific functions.

No functional change.

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
 kernel/trace/trace_osnoise.c | 53 ++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 7b1f8187764c..0a04a9a4c85a 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1545,7 +1545,7 @@ static int start_kthread(unsigned int cpu)
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
 
@@ -1936,7 +1938,7 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 	barrier();
 	trace_osnoise_callback_enabled = true;
 
-	retval = start_per_cpu_kthreads(tr);
+	retval = start_per_cpu_kthreads();
 	if (retval) {
 		unhook_irq_events();
 		return retval;
@@ -1947,6 +1949,26 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 	return 0;
 }
 
+/*
+ * osnoise_workload_stop - stop the workload and unhook the events
+ */
+static void osnoise_workload_stop(void)
+{
+	if (!osnoise_busy)
+		return;
+
+	trace_osnoise_callback_enabled = false;
+	barrier();
+
+	stop_per_cpu_kthreads();
+
+	unhook_irq_events();
+	unhook_softirq_events();
+	unhook_thread_events();
+
+	osnoise_busy = false;
+}
+
 static void osnoise_tracer_start(struct trace_array *tr)
 {
 	int retval;
@@ -1954,7 +1976,7 @@ static void osnoise_tracer_start(struct trace_array *tr)
 	if (osnoise_busy)
 		return;
 
-	retval = __osnoise_tracer_start(tr);
+	retval = osnoise_workload_start();
 	if (retval)
 		pr_err(BANNER "Error starting osnoise tracer\n");
 
@@ -1965,16 +1987,7 @@ static void osnoise_tracer_stop(struct trace_array *tr)
 	if (!osnoise_busy)
 		return;
 
-	trace_osnoise_callback_enabled = false;
-	barrier();
-
-	stop_per_cpu_kthreads();
-
-	unhook_irq_events();
-	unhook_softirq_events();
-	unhook_thread_events();
-
-	osnoise_busy = false;
+	osnoise_workload_stop();
 }
 
 static int osnoise_tracer_init(struct trace_array *tr)
@@ -2017,7 +2030,7 @@ static void timerlat_tracer_start(struct trace_array *tr)
 
 	osnoise_data.timerlat_tracer = 1;
 
-	retval = __osnoise_tracer_start(tr);
+	retval = osnoise_workload_start();
 	if (retval)
 		goto out_err;
 
-- 
2.31.1

