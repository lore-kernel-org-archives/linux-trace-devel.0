Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5777C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 02:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiKJCzY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 21:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiKJCzY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 21:55:24 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144D9233BC
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 18:55:20 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id w10so605272qvr.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Nov 2022 18:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qd3oNhh6awReCXaudeyjdbsLhpze3PHW0oaDmHD9hvs=;
        b=UtwIWGSNcsaFYd2w14KVS3uYmkvA38Ci8ODQfepdC5RJvEulUskr1iPeftGkxGos97
         zHxJlzV9CAiqAKxc9RyJZPhnRbLVBaFgsA5qGaVpunrmsLxf96VEQGl8BaTn955ATY/H
         4En1sseMCC+8DpiiYaeyI3y4vnx6jZrNDt43M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd3oNhh6awReCXaudeyjdbsLhpze3PHW0oaDmHD9hvs=;
        b=65wdTwMTlTZOs0r/s626gB5aMrDAEnhsZLHdbgtBNIzWm8bpevhaIEsGjx2xsHUQuz
         Q0P8cJDERjnEy/qTmsVFNs2a0BMjOKFtrX09pPThx0vmulzssv3BGkR1tU6hSU4t5N41
         n6TXuazNVvrTD14L3ow2SmecT8nohINwGHkMKNwTM9G0hNwmtcAZvipwOL9zKI7+HyD/
         kkeijcBBd/pDwOmN6RaEB7ItZrmw60TxW9xmg1AqE6hz8SeuG0qkVo3ReSeef1oE/U+O
         QLSAbU+6MP8t4ejOTPUHpQuW+k4xfJaAcXwLa9fFpQOYkYGsSxVZKKgQw4hB4rUXxDvj
         3+ng==
X-Gm-Message-State: ACrzQf0wIho8sGgZLCV5wEmPk/cBNwcgrCZ4aE1j2bcODAK/ef5RNqSI
        h/0H6jFWuIdyLjNMCW8mKL/GqpQuLP7IXQ==
X-Google-Smtp-Source: AMsMyM5wQXGEkjwRbLgnvM23MHQdtqVtrl99m0UIiWosSHwrBlONGFJXYvwwh0s1dKiJz1eWXz0Kew==
X-Received: by 2002:a0c:8dc5:0:b0:4bc:15a0:140 with SMTP id u5-20020a0c8dc5000000b004bc15a00140mr42903846qvb.21.1668048918779;
        Wed, 09 Nov 2022 18:55:18 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id o14-20020a05620a0d4e00b006eef13ef4c8sm11892535qkl.94.2022.11.09.18.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 18:55:18 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH] tracing: Dump instance traces into oops with ftrace_dump_on_oops
Date:   Thu, 10 Nov 2022 02:55:14 +0000
Message-Id: <20221110025514.2989642-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.38.1.493.g58b659f92b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently ftrace only dumps the current trace buffer on OOPS. For
debugging a production usecase, I'd like to dump instance traces as
well, into the kernel logs. The reason is we cannot use the global trace
buffer as it may be used for other purposes.

This patch adds support for dumping the trace buffer instances along
with the global trace buffer.

The instance traces are dumped first, and then the global trace buffer.

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/trace/trace.c | 70 ++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 47a44b055a1d..15ddee31cc23 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9914,15 +9914,12 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
-void trace_init_global_iter(struct trace_iterator *iter)
+void trace_init_iter_with_tr(struct trace_iterator *iter, struct trace_array *tr)
 {
-	iter->tr = &global_trace;
+	iter->tr = tr;
 	iter->trace = iter->tr->current_trace;
 	iter->cpu_file = RING_BUFFER_ALL_CPUS;
-	iter->array_buffer = &global_trace.array_buffer;
-
-	if (iter->trace && iter->trace->open)
-		iter->trace->open(iter);
+	iter->array_buffer = &iter->tr->array_buffer;
 
 	/* Annotate start of buffers if we had overruns */
 	if (ring_buffer_overruns(iter->array_buffer->buffer))
@@ -9939,36 +9936,14 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->fmt_size = STATIC_FMT_BUF_SIZE;
 }
 
-void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
+void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode oops_dump_mode)
 {
-	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
-	static atomic_t dump_running;
-	struct trace_array *tr = &global_trace;
 	unsigned int old_userobj;
-	unsigned long flags;
 	int cnt = 0, cpu;
 
-	/* Only allow one dump user at a time. */
-	if (atomic_inc_return(&dump_running) != 1) {
-		atomic_dec(&dump_running);
-		return;
-	}
-
-	/*
-	 * Always turn off tracing when we dump.
-	 * We don't need to show trace output of what happens
-	 * between multiple crashes.
-	 *
-	 * If the user does a sysrq-z, then they can re-enable
-	 * tracing with echo 1 > tracing_on.
-	 */
-	tracing_off();
-
-	local_irq_save(flags);
-
 	/* Simulate the iterator */
-	trace_init_global_iter(&iter);
+	trace_init_iter_with_tr(&iter, tr);
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
@@ -9993,7 +9968,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 		iter.cpu_file = RING_BUFFER_ALL_CPUS;
 	}
 
-	printk(KERN_TRACE "Dumping ftrace buffer:\n");
+	if (tr == &global_trace)
+		printk(KERN_TRACE "Dumping ftrace buffer:\n");
+	else
+		printk(KERN_TRACE "Dumping ftrace instance %s buffer:\n", tr->name);
 
 	/* Did function tracer already get disabled? */
 	if (ftrace_is_dead()) {
@@ -10041,6 +10019,36 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 	for_each_tracing_cpu(cpu) {
 		atomic_dec(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
 	}
+}
+
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
+{
+	/* use static because iter can be a bit big for the stack */
+	static atomic_t dump_running;
+	struct trace_array *tr;
+	unsigned long flags;
+
+	/* Only allow one dump user at a time. */
+	if (atomic_inc_return(&dump_running) != 1) {
+		atomic_dec(&dump_running);
+		return;
+	}
+
+	/*
+	 * Always turn off tracing when we dump.
+	 * We don't need to show trace output of what happens
+	 * between multiple crashes.
+	 *
+	 * If the user does a sysrq-z, then they can re-enable
+	 * tracing with echo 1 > tracing_on.
+	 */
+	tracing_off();
+	local_irq_save(flags);
+
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		ftrace_dump_one(tr, oops_dump_mode);
+	}
+
 	atomic_dec(&dump_running);
 	local_irq_restore(flags);
 }
-- 
2.38.1.493.g58b659f92b-goog

