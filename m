Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437EAC2D0D1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196F824679
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSVtA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 16:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfLSVs7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 16:48:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CE92467B
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 21:48:59 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ii3fG-000Uqj-Dj
        for linux-trace-devel@vger.kernel.org; Thu, 19 Dec 2019 16:48:58 -0500
Message-Id: <20191219214858.297560793@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Dec 2019 16:48:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] tools lib traceevent: Add builtin handler for trace_marker_raw
References: <20191219214805.821145530@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When something is written into trace_marker_raw, it goes in as a binary. But
the printk_fmt() of the event that is created (raw_data)'s format file only
prints the first byte of data:

  print fmt: "id:%04x %08x", REC->id, (int)REC->buf[0]

This is no very useful if we want to see the full data output.

Implement the processing of the raw_data event like it is in the kernel.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/plugins/plugin_function.c | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/lib/traceevent/plugins/plugin_function.c b/lib/traceevent/plugins/plugin_function.c
index 80fdfc3aa2a9..938b7410776a 100644
--- a/lib/traceevent/plugins/plugin_function.c
+++ b/lib/traceevent/plugins/plugin_function.c
@@ -207,6 +207,44 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+static int
+trace_raw_data_handler(struct trace_seq *s, struct tep_record *record,
+		    struct tep_event *event, void *context)
+{
+	struct tep_format_field *field;
+	unsigned long long id;
+	int long_size;
+	void *data = record->data;
+
+	if (tep_get_field_val(s, event, "id", record, &id, 1))
+		return trace_seq_putc(s, '!');
+
+	trace_seq_printf(s, "# %llx", id);
+
+	field = tep_find_any_field(event, "buf");
+	if (!field) {
+		trace_seq_printf(s, "<CANT FIND FIELD %s>", "buf");
+		return 0;
+	}
+
+	long_size = tep_get_long_size(event->tep);
+
+	for (data += field->offset; data < record->data + record->size;
+	     data += long_size) {
+		int size = sizeof(long);
+		int left = (record->data + record->size) - data;
+		int i;
+
+		if (size > left)
+			size = left;
+
+		for (i = 0; i < size; i++)
+			trace_seq_printf(s, " %02x", *(unsigned char *)(data + i));
+	}
+
+	return 0;
+}
+
 int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
 	tep_register_event_handler(tep, -1, "ftrace", "function",
@@ -215,6 +253,9 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	tep_register_event_handler(tep, -1, "ftrace", "kernel_stack",
 				      trace_stack_handler, NULL);
 
+	tep_register_event_handler(tep, -1, "ftrace", "raw_data",
+				      trace_raw_data_handler, NULL);
+
 	tep_plugin_add_options("ftrace", plugin_options);
 
 	return 0;
-- 
2.24.0


