Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38069C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 14:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED74861029
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 14:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhEEOUA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 10:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhEEOUA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 10:20:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63AC61075
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 May 2021 14:19:03 +0000 (UTC)
Date:   Wed, 5 May 2021 10:19:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Write set_ftrace_filter commands
 separately
Message-ID: <20210505101902.7c98de44@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Using tracefs_function_filter() to enable function filters allowed for
more flexibility on the command line for using regex to enable functions,
but it also broke setting commands like "stacktrace" and "traceoff".

If the filter contains ":" then write it directly into the file instead of
going through the tracefs_function_filter interface.

Fixes: f73378a7b ("trace-cmd record: Use tracefs_filter_function() for function filtering")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4636475f..9daf4b05 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4354,10 +4354,15 @@ enum filter_type {
 	FUNC_NOTRACE,
 };
 
+static int filter_command(struct tracefs_instance *instance, const char *cmd)
+{
+	return tracefs_instance_file_append(instance, "set_ftrace_filter", cmd);
+}
+
 static int write_func_filter(enum filter_type type, struct buffer_instance *instance,
 			     struct func_list **list)
 {
-	struct func_list *item;
+	struct func_list *item, *cmds = NULL;
 	const char *file;
 	int ret = -1;
 	int (*filter_function)(struct tracefs_instance *instance, const char *filter,
@@ -4385,6 +4390,12 @@ static int write_func_filter(enum filter_type type, struct buffer_instance *inst
 	while (*list) {
 		item = *list;
 		*list = item->next;
+		/* Do commands separately at the end */
+		if (type == FUNC_FILTER && strstr(item->func, ":")) {
+			item->next = cmds;
+			cmds = item;
+			continue;
+		}
 		ret = filter_function(instance->tracefs, item->func, item->mod,
 				      TRACEFS_FL_CONTINUE);
 		if (ret < 0)
@@ -4392,6 +4403,16 @@ static int write_func_filter(enum filter_type type, struct buffer_instance *inst
 		free(item);
 	}
 	ret = filter_function(instance->tracefs, NULL, NULL, 0);
+
+	/* Now add any commands */
+	while (cmds) {
+		item = cmds;
+		cmds = item->next;
+		ret = filter_command(instance->tracefs, item->func);
+		if (ret < 0)
+			goto failed;
+		free(item);
+	}
 	return ret;
  failed:
 	die("Failed to write %s to %s.\n"
-- 
2.29.2

