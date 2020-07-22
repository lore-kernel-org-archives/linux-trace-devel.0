Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CE9C433EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B21207DD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbgGVBSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731633AbgGVBRz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DC5208E4;
        Wed, 22 Jul 2020 01:17:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OL-005sCU-UU; Tue, 21 Jul 2020 21:17:53 -0400
Message-ID: <20200722011753.827936853@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 10/23 v3] tools lib traceevent: Add offset option for function plugin
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the offset option is set for the function plugin enabled, it will
display the offset of the functions along with their names.  This helps in
finding exactly where a function was called by its parent.

 trace-cmd report -O parent -O offset
[..]
        rcuc/163-1330  [163]   740.653251: function: _raw_spin_lock+0x0  <-- rcu_cpu_kthread+0x4d8

Link: http://lore.kernel.org/linux-trace-devel/20200702174950.123454-2-tz.stoyanov@gmail.com

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[ Ported from trace-cmd.git ]
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../lib/traceevent/plugins/plugin_function.c  | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/plugins/plugin_function.c b/tools/lib/traceevent/plugins/plugin_function.c
index 7770fcb78e0f..cafddd6be983 100644
--- a/tools/lib/traceevent/plugins/plugin_function.c
+++ b/tools/lib/traceevent/plugins/plugin_function.c
@@ -49,6 +49,13 @@ struct tep_plugin_option plugin_options[] =
 		"Try to show function call indents, based on parents",
 		.set = 1,
 	},
+	{
+		.name = "offset",
+		.plugin_alias = "ftrace",
+		.description =
+		"Show function names as well as their offsets",
+		.set = 0,
+	},
 	{
 		.name = NULL,
 	}
@@ -56,6 +63,7 @@ struct tep_plugin_option plugin_options[] =
 
 static struct tep_plugin_option *ftrace_parent = &plugin_options[0];
 static struct tep_plugin_option *ftrace_indent = &plugin_options[1];
+static struct tep_plugin_option *ftrace_offset = &plugin_options[2];
 
 static void add_child(struct func_stack *stack, const char *child, int pos)
 {
@@ -123,6 +131,18 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 	return 0;
 }
 
+static void show_function(struct trace_seq *s, struct tep_handle *tep,
+			  const char *func, unsigned long long function)
+{
+	unsigned long long offset;
+
+	trace_seq_printf(s, "%s", func);
+	if (ftrace_offset->set) {
+		offset = tep_find_function_address(tep, function);
+		trace_seq_printf(s, "+0x%x ", (int)(function - offset));
+	}
+}
+
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
@@ -149,14 +169,14 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	trace_seq_printf(s, "%*s", index*3, "");
 
 	if (func)
-		trace_seq_printf(s, "%s", func);
+		show_function(s, tep, func, function);
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
 	if (ftrace_parent->set) {
 		trace_seq_printf(s, " <-- ");
 		if (parent)
-			trace_seq_printf(s, "%s", parent);
+			show_function(s, tep, parent, pfunction);
 		else
 			trace_seq_printf(s, "0x%llx", pfunction);
 	}
-- 
2.26.2


