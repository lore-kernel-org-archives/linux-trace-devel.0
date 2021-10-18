Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B776C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B0561263
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhJRQvO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:51:14 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:32964 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233775AbhJRQvN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:51:13 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-UU5z9B0iM1GK1ePJvz38qQ-1; Mon, 18 Oct 2021 12:48:58 -0400
X-MC-Unique: UU5z9B0iM1GK1ePJvz38qQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57EAC18125C5;
        Mon, 18 Oct 2021 16:48:57 +0000 (UTC)
Received: from x1.com (unknown [10.22.18.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49DB210016F4;
        Mon, 18 Oct 2021 16:48:54 +0000 (UTC)
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
Subject: [PATCH V3 03/19] trace/osnoise: Use start/stop_per_cpu_kthreads() on osnoise_cpus_write()
Date:   Mon, 18 Oct 2021 18:48:16 +0200
Message-Id: <a20b07bf844f2d77ae31bddac060cb035a1a6e82.1634574261.git.bristot@kernel.org>
In-Reply-To: <cover.1634574261.git.bristot@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
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

When writing a new CPU mask via osnoise/cpus, if the tracer is running,
the workload is restarted to follow the new cpumask. The restart is
currently done using osnoise_workload_start/stop(), which disables the
workload *and* the instrumentation. However, disabling the
instrumentation is not necessary.

Calling start/stop_per_cpu_kthreads() is enough to apply the new
osnoise/cpus config.

No functional change.

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
index 0a04a9a4c85a..9b9e6bc889e9 100644
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

