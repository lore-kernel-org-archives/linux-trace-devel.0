Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1968C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 21:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA946121E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 21:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346600AbhDMVIS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344575AbhDMVIR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 17:08:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9C161155;
        Tue, 13 Apr 2021 21:07:57 +0000 (UTC)
Date:   Tue, 13 Apr 2021 17:07:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] libtraceevent: Add reading func_repeats events to function
 plugin
Message-ID: <20210413170756.3c4638f9@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From:  Steven Rostedt (VMware) <rostedt@goodmis.org>

With the new ftrace event func_repeats coming to the kernel, add processing
the output of it so it fits right in with the function tracer.

Since it uses the same event fields as the function trace, it can call the
function handler first, which will process the func_repeats event just like
a function, and then print the count and convert the delta to display the
actual timestamp of the last function that repeated.

Add a weak variable called "tep_func_repeat_format" to allow applications
to override how the timestamp of the last function is displayed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 93bdcc2..7777569 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -10,6 +10,11 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
+#define __weak __attribute__((weak))
+
+/* Export this for applications to override it */
+__weak const char *tep_func_repeat_format = "%6.1000d";
+
 static struct func_stack {
 	int size;
 	char **stack;
@@ -169,6 +174,36 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+static int trace_func_repeat_handler(struct trace_seq *s, struct tep_record *record,
+				    struct tep_event *event, void *context)
+{
+	struct tep_handle *tep = event->tep;
+	unsigned long long count, top_delta, bottom_delta;
+	struct tep_record dummy;
+
+	function_handler(s, record, event, context);
+
+	if (tep_get_field_val(s, event, "count", record, &count, 1))
+		return trace_seq_putc(s, '!');
+
+	if (tep_get_field_val(s, event, "top_delta_ts", record, &top_delta, 1))
+		return trace_seq_putc(s, '!');
+
+	if (tep_get_field_val(s, event, "bottom_delta_ts", record, &bottom_delta, 1))
+		return trace_seq_putc(s, '!');
+
+	trace_seq_printf(s, " (count: %lld  last_ts: ", count);
+
+	memcpy(&dummy, record, sizeof(dummy));
+	dummy.ts -= (top_delta << 32) | bottom_delta;
+
+	tep_print_event(tep, s, &dummy, tep_func_repeat_format, TEP_PRINT_TIME);
+
+	trace_seq_puts(s, ")");
+
+	return 0;
+}
+
 static int
 trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 		    struct tep_event *event, void *context)
@@ -256,6 +291,9 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	tep_register_event_handler(tep, -1, "ftrace", "raw_data",
 				      trace_raw_data_handler, NULL);
 
+	tep_register_event_handler(tep, -1, "ftrace", "func_repeats",
+				      trace_func_repeat_handler, NULL);
+
 	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
