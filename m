Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866B7C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A3D6023D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhHLOUJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:20:09 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.219]:43731 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237386AbhHLOUJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:20:09 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id D04BE2693
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 08:57:44 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id EBDMmVDxpMGeEEBDMmVXNO; Thu, 12 Aug 2021 08:57:44 -0500
X-Authority-Reason: nr=8
Received: from host-79-56-204-120.retail.telecomitalia.it ([79.56.204.120]:54910 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mEBDM-004IPl-1O; Thu, 12 Aug 2021 08:57:44 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] trace/osnoise: Allow multiple instances of the same tracer
Date:   Thu, 12 Aug 2021 15:57:24 +0200
Message-Id: <b2772fa3455fb4ed7ce82af3525975943439e6e7.1628775552.git.bristot@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628775552.git.bristot@kernel.org>
References: <cover.1628775552.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.56.204.120
X-Source-L: No
X-Exim-ID: 1mEBDM-004IPl-1O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-56-204-120.retail.telecomitalia.it (f34.bristot.me) [79.56.204.120]:54910
X-Source-Auth: kernel@bristot.me
X-Email-Count: 36
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
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
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira (Red Hat) <bristot@kernel.org>
---
 kernel/trace/trace_osnoise.c | 106 ++++++++++++++++++++++++++---------
 1 file changed, 80 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 9193c256377e..5f09fb55b359 100644
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

