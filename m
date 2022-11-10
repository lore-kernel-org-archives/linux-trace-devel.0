Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FEAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 03:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKJDKb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiKJDK2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 22:10:28 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF952B251
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 19:10:27 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id s20so448098qkg.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Nov 2022 19:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Et1X+XM5fz2xtP+ITAFoJHCq9rWg7jnFKDCEn93tI0w=;
        b=uLTOuJdgpm7VCpgUb1KzXJiqiRpkTZkN+7ZQuWCqW7BgKW6KJLeeQxeQHzClq1udEY
         aJlDQFAMEs3ZxAX/NWqWJR8Ee8YZpRdIS9dkI5Dxe1xe3y8hYnPhk+EBMRm079DtIJp3
         bgWMCATBsYnBImshgR2199Jn5Ju9ENCEPB2V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Et1X+XM5fz2xtP+ITAFoJHCq9rWg7jnFKDCEn93tI0w=;
        b=ylFpCU2v30eczqGoSx3yP7pwgIzL9PhipOJyThlJdlLtdJn0Or4Z3DO+HG/chvWY2Y
         yRpTB6eJMtAnk2BMNwBNtqlpKAA1Wy6KNMXWQ6P28gk6cwu6WfIhtloLkKvV4nfy/Mpl
         QW1Yh3R8AiADujRNBtClQc02rbPAe8Yh2Qfur1jsMpsJ2r2X/Pr/b69VHM6jpCI1/Sd/
         SHBnemUlJdOnJrUyt/6M/BCenyWh9fCz1264JHxDzXgBAsHbg4rZBDn8RJptk6uVse0Z
         GOgyp76YGESlQefTHubmfERUeP7z/zLnZxoWVvPmxcjCmXC0pZb8nw+5W95dqft7Ldgu
         YHGw==
X-Gm-Message-State: ACrzQf0FBdXLZwZ7HDE36OMJjx/+vZth2KCoO9GwLf5/LxPyKoU1yFFe
        2ISXF0D4ee7PEvQZDfgmwEFCd3KDcy0TTQ==
X-Google-Smtp-Source: AMsMyM7jMWhyU4RzeNhEoWrcn/aSyoVEa2lAUr9aQMIWS00+nObC3r4i1USJbEo4eN+HVCUM6zd/Lw==
X-Received: by 2002:a37:407:0:b0:6f9:6a80:14b1 with SMTP id 7-20020a370407000000b006f96a8014b1mr45023399qke.198.1668049826009;
        Wed, 09 Nov 2022 19:10:26 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id h11-20020a05620a400b00b006eeb51bb33dsm12463352qko.78.2022.11.09.19.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 19:10:25 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2] tracing: Dump instance traces into dmesg on ftrace_dump_on_oops
Date:   Thu, 10 Nov 2022 03:10:19 +0000
Message-Id: <20221110031019.3005130-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.38.1.493.g58b659f92b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently ftrace only dumps the global trace buffer on an OOPs. For
debugging a production usecase, I'd like to dump instance traces as
well, into the kernel logs. The reason is we cannot use the global trace
buffer as it may be used for other purposes.

This patch adds support for dumping the trace buffer instances along
with the global trace buffer.

The instance traces are dumped first, and then the global trace buffer.

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/trace/trace.c | 67 ++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 47a44b055a1d..2cc75497d6d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9914,12 +9914,12 @@ trace_printk_seq(struct trace_seq *s)
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
+	iter->array_buffer = &tr->array_buffer;
 
 	if (iter->trace && iter->trace->open)
 		iter->trace->open(iter);
@@ -9939,36 +9939,14 @@ void trace_init_global_iter(struct trace_iterator *iter)
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
@@ -9993,7 +9971,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 		iter.cpu_file = RING_BUFFER_ALL_CPUS;
 	}
 
-	printk(KERN_TRACE "Dumping ftrace buffer:\n");
+	if (tr == &global_trace)
+		printk(KERN_TRACE "Dumping ftrace buffer:\n");
+	else
+		printk(KERN_TRACE "Dumping ftrace instance %s buffer:\n", tr->name);
 
 	/* Did function tracer already get disabled? */
 	if (ftrace_is_dead()) {
@@ -10041,6 +10022,36 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
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

