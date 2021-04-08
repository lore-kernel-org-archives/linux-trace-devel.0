Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A988CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 16:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64B856112F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 16:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDHQiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 12:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhDHQiR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 12:38:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD000610D1
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 16:38:05 +0000 (UTC)
Date:   Thu, 8 Apr 2021 12:38:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Use tracefs_filter_function() for
 function filtering
Message-ID: <20210408123804.1f3e0f2d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

By having the implementation for -l and -n use tracefs_function_filter()
and tracefs_function_notrace() it extends the filtering capability to use
full regex expressions.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-record.1.txt          |  9 +--
 tracecmd/trace-record.c                       | 58 ++++++++++++++++++-
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index d992002e..55a8891b 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -134,10 +134,11 @@ OPTIONS
 *-l* 'function-name'::
     This will limit the 'function' and 'function_graph' tracers to only trace
     the given function name. More than one *-l* may be specified on the
-    command line to trace more than one function. The limited use of glob
-    expressions are also allowed. These are 'match\*' to only filter functions
-    that start with 'match'. '\*match' to only filter functions that end with
-    'match'. '\*match\*' to only filter on functions that contain 'match'.
+    command line to trace more than one function. This supports both full
+    regex(3) parsing, or basic glob parsing. If the filter has only alphanumeric,
+    '_', '*', '?' and '.' characters, then it will be parsed as a basic glob.
+    to force it to be a regex, prefix the filter with '^' or append it with '$'
+    and it will then be parsed as a regex.
 
 *-g* 'function-name'::
     This option is for the function_graph plugin. It will graph the given
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6b608ad5..fd03a605 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4351,6 +4351,58 @@ static void record_data(struct common_record_context *ctx)
 	tracecmd_output_close(handle);
 }
 
+enum filter_type {
+	FUNC_FILTER,
+	FUNC_NOTRACE,
+};
+
+static int write_func_filter(enum filter_type type, struct buffer_instance *instance,
+			     struct func_list **list)
+{
+	struct func_list *item;
+	const char *file;
+	int ret = -1;
+	int (*filter_function)(struct tracefs_instance *instance, const char *filter,
+			       const char *module, unsigned int flags);
+
+	if (!*list)
+		return 0;
+
+	switch (type) {
+	case FUNC_FILTER:
+		filter_function = tracefs_function_filter;
+		file = "set_ftrace_filter";
+		break;
+	case FUNC_NOTRACE:
+		filter_function = tracefs_function_notrace;
+		file = "set_ftrace_notrace";
+		break;
+	}
+
+	ret = filter_function(instance->tracefs, NULL, NULL,
+			      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+	if (ret < 0)
+		return ret;
+
+	while (*list) {
+		item = *list;
+		*list = item->next;
+		ret = filter_function(instance->tracefs, item->func, item->mod,
+				      TRACEFS_FL_CONTINUE);
+		if (ret < 0)
+			goto failed;
+		free(item);
+	}
+	ret = filter_function(instance->tracefs, NULL, NULL, 0);
+	return ret;
+ failed:
+	die("Failed to write %s to %s.\n"
+	    "Perhaps this function is not available for tracing.\n"
+	    "run 'trace-cmd list -f %s' to see if it is.",
+	    item->func, file, item->func);
+	return ret;
+}
+
 static int write_func_file(struct buffer_instance *instance,
 			    const char *file, struct func_list **list)
 {
@@ -4439,7 +4491,7 @@ static void set_funcs(struct buffer_instance *instance)
 	if (is_guest(instance))
 		return;
 
-	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
+	ret = write_func_filter(FUNC_FILTER, instance, &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
 
@@ -4455,13 +4507,13 @@ static void set_funcs(struct buffer_instance *instance)
 				set_notrace = 1;
 		}
 		if (!set_notrace) {
-			ret = write_func_file(instance, "set_ftrace_notrace",
+			ret = write_func_filter(FUNC_NOTRACE, instance,
 					      &instance->notrace_funcs);
 			if (ret < 0)
 				die("set_ftrace_notrace does not exist. Can not filter functions");
 		}
 	} else
-		write_func_file(instance, "set_ftrace_notrace", &instance->notrace_funcs);
+		write_func_filter(FUNC_NOTRACE, instance, &instance->notrace_funcs);
 
 	/* make sure we are filtering functions */
 	if (func_stack && is_top_instance(instance)) {
-- 
2.29.2

