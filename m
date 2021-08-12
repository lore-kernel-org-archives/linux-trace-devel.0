Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7692C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4439610A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhHLOUk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:20:40 -0400
Received: from gateway30.websitewelcome.com ([192.185.144.21]:27857 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237341AbhHLOUj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:20:39 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id D292911F19
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 08:57:36 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id EBDEmBXkmK61iEBDEm9bX7; Thu, 12 Aug 2021 08:57:36 -0500
X-Authority-Reason: nr=8
Received: from host-79-56-204-120.retail.telecomitalia.it ([79.56.204.120]:54910 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mEBDD-004IPl-Vw; Thu, 12 Aug 2021 08:57:36 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace/osnoise: Do not follow tracing_cpumask
Date:   Thu, 12 Aug 2021 15:57:20 +0200
Message-Id: <db14a8eef9af9b9de665251b729361bee75a70a4.1628775552.git.bristot@kernel.org>
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
X-Exim-ID: 1mEBDD-004IPl-Vw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-56-204-120.retail.telecomitalia.it (f34.bristot.me) [79.56.204.120]:54910
X-Source-Auth: kernel@bristot.me
X-Email-Count: 8
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In preparation to support multiple instances, decople the
osnoise/timelat workload from instance specific tracing_cpumask.

Different instances can have conflicing cpumasks, making osnoise
workload management needlessly complex. Osnoise already have its
global cpu mask.

I also thought about using the first instance mask, but the
"first" instance could be removed before the others.

This also fixes the problem that changing the tracing_mask was not
re-starting the trace.


Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira (Red Hat) <bristot@kernel.org>
---
 kernel/trace/trace_osnoise.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index b576e96d9741..aadb0d110155 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1553,13 +1553,10 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 
 	get_online_cpus();
 	/*
-	 * Run only on CPUs in which trace and osnoise are allowed to run.
+	 * Run only on online CPUs in which trace and osnoise are allowed to
+	 * run.
 	 */
-	cpumask_and(current_mask, tr->tracing_cpumask, &osnoise_cpumask);
-	/*
-	 * And the CPU is online.
-	 */
-	cpumask_and(current_mask, cpu_online_mask, current_mask);
+	cpumask_and(current_mask, cpu_online_mask, &osnoise_cpumask);
 
 	for_each_possible_cpu(cpu)
 		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
@@ -1580,10 +1577,8 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 #ifdef CONFIG_HOTPLUG_CPU
 static void osnoise_hotplug_workfn(struct work_struct *dummy)
 {
-	struct trace_array *tr = osnoise_trace;
 	unsigned int cpu = smp_processor_id();
 
-
 	mutex_lock(&trace_types_lock);
 
 	if (!osnoise_busy)
@@ -1595,9 +1590,6 @@ static void osnoise_hotplug_workfn(struct work_struct *dummy)
 	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
 		goto out_unlock;
 
-	if (!cpumask_test_cpu(cpu, tr->tracing_cpumask))
-		goto out_unlock;
-
 	start_kthread(cpu);
 
 out_unlock:
@@ -1700,13 +1692,10 @@ static void osnoise_tracer_stop(struct trace_array *tr);
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
2.31.1

