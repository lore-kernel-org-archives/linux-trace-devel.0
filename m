Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1076C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71ED61075
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Oct 2021 18:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJaSJ3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Oct 2021 14:09:29 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46281 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230478AbhJaSJ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 14:09:28 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-daoxd4EkM8u3WEBX0k8lCA-1; Sun, 31 Oct 2021 14:06:52 -0400
X-MC-Unique: daoxd4EkM8u3WEBX0k8lCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDDA10A8E08;
        Sun, 31 Oct 2021 18:06:49 +0000 (UTC)
Received: from x1.com (unknown [10.22.8.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B305B60C17;
        Sun, 31 Oct 2021 18:06:46 +0000 (UTC)
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
Subject: [PATCH V9 4/9] tracing/osnoise: Use start/stop_per_cpu_kthreads() on osnoise_cpus_write()
Date:   Sun, 31 Oct 2021 19:04:59 +0100
Message-Id: <ee633e82867c5b88851aa6040522a799c0034486.1635702894.git.bristot@kernel.org>
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

When writing a new CPU mask via osnoise/cpus, if the tracer is running,
the workload is restarted to follow the new cpumask. The restart is
currently done using osnoise_workload_start/stop(), which disables the
workload *and* the instrumentation. However, disabling the
instrumentation is not necessary.

Calling start/stop_per_cpu_kthreads() is enough to apply the new
osnoise/cpus config.

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
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 kernel/trace/trace_osnoise.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 5279a4990493..cacc11b7d5ae 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1678,9 +1678,6 @@ osnoise_cpus_read(struct file *filp, char __user *ubuf, size_t count,
 	return count;
 }
 
-static int osnoise_workload_start(void);
-static void osnoise_workload_stop(void);
-
 /*
  * osnoise_cpus_write - Write function for "cpus" entry
  * @filp: The active open file structure
@@ -1725,7 +1722,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_lock(&trace_types_lock);
 	running = osnoise_busy;
 	if (running)
-		osnoise_workload_stop();
+		stop_per_cpu_kthreads();
 
 	mutex_lock(&interface_lock);
 	/*
@@ -1739,7 +1736,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_unlock(&interface_lock);
 
 	if (running)
-		osnoise_workload_start();
+		start_per_cpu_kthreads();
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(osnoise_cpumask_new);
-- 
2.31.1

