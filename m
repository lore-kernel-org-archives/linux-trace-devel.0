Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A95C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 17:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C0360F9D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 17:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhJYRns convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 13:43:48 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:25802 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233805AbhJYRnn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 13:43:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-RaSjjN-gMOuXjorm32phLg-1; Mon, 25 Oct 2021 13:41:14 -0400
X-MC-Unique: RaSjjN-gMOuXjorm32phLg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5333A802682;
        Mon, 25 Oct 2021 17:41:13 +0000 (UTC)
Received: from x1.com (unknown [10.22.9.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 573F75C1A1;
        Mon, 25 Oct 2021 17:41:04 +0000 (UTC)
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
Subject: [PATCH V5 04/20] trace/osnoise: Use start/stop_per_cpu_kthreads() on osnoise_cpus_write()
Date:   Mon, 25 Oct 2021 19:40:29 +0200
Message-Id: <2b4ea45b1802844cffd98b6a208b22bc4664c795.1635181938.git.bristot@kernel.org>
In-Reply-To: <cover.1635181938.git.bristot@kernel.org>
References: <cover.1635181938.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 4381a06af916..7453b96c548b 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1677,9 +1677,6 @@ osnoise_cpus_read(struct file *filp, char __user *ubuf, size_t count,
 	return count;
 }
 
-static int osnoise_workload_start(void);
-static void osnoise_workload_stop(void);
-
 /*
  * osnoise_cpus_write - Write function for "cpus" entry
  * @filp: The active open file structure
@@ -1724,7 +1721,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_lock(&trace_types_lock);
 	running = osnoise_busy;
 	if (running)
-		osnoise_workload_stop();
+		stop_per_cpu_kthreads();
 
 	mutex_lock(&interface_lock);
 	/*
@@ -1738,7 +1735,7 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	mutex_unlock(&interface_lock);
 
 	if (running)
-		osnoise_workload_start();
+		start_per_cpu_kthreads();
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(osnoise_cpumask_new);
-- 
2.31.1

