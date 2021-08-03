Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38ADC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A042C6104F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhHCC7e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233478AbhHCC7e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 22:59:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C895D600CD;
        Tue,  3 Aug 2021 02:59:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAkeI-002qG8-NH; Mon, 02 Aug 2021 22:59:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/7] libtracefs: Add API tracefs_hist_show()
Date:   Mon,  2 Aug 2021 22:59:18 -0400
Message-Id: <20210803025921.677469-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803025921.677469-1-rostedt@goodmis.org>
References: <20210803025921.677469-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add tracefs_hist_show() that will display the commands that would be
executed in order to create the given histogram.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt |   8 +++
 include/tracefs.h                 |   2 +
 src/tracefs-hist.c                | 102 ++++++++++++++++++++++--------
 3 files changed, 85 insertions(+), 27 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 9bf13ac03af7..03ac07743d1c 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -30,6 +30,9 @@ int tracefs_hist_append_filter(struct tracefs_hist pass:[*]hist,
 			       const char pass:[*]field,
 			       enum tracefs_compare compare,
 			       const char pass:[*]val);
+int tracefs_hist_show(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
+			 struct tracefs_hist pass:[*]hist,
+			 enum tracefs_hist_command command);
 int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
@@ -121,6 +124,11 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 
 *TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
 
+*trace_hist_show*() prints the commands needed to create the given histogram
+in the given _instance_, or NULL for the top level, into the _seq_.
+The command that is printed is described by _command_ and shows the functionality
+that would be done by *tracefs_hist_command*(3).
+
 *tracefs_hist_command*() is called to process a command on the histogram
 _hist_ for its event in the given _instance_, or NULL for the top level.
 The _cmd_ can be one of:
diff --git a/include/tracefs.h b/include/tracefs.h
index 0be6e907d29b..ab781764b0ed 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -327,6 +327,8 @@ int tracefs_hist_append_filter(struct tracefs_hist *hist,
 			       const char *field,
 			       enum tracefs_compare compare,
 			       const char *val);
+int tracefs_hist_show(struct trace_seq *seq,  struct tracefs_instance *instance,
+		      struct tracefs_hist *hist, enum tracefs_hist_command command);
 int tracefs_hist_command(struct tracefs_instance *instance,
 			 struct tracefs_hist *hist, enum tracefs_hist_command cmd);
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 1be14362f407..7c84e942d58b 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -50,6 +50,79 @@ static void add_list(struct trace_seq *seq, const char *start,
 	}
 }
 
+static void add_hist_commands(struct trace_seq *seq, struct tracefs_hist *hist,
+			     enum tracefs_hist_command command)
+{
+	if (command == TRACEFS_HIST_CMD_DESTROY)
+		trace_seq_putc(seq, '!');
+
+	add_list(seq, "hist:keys=", hist->keys);
+
+	if (hist->values)
+		add_list(seq, ":vals=", hist->values);
+
+	if (hist->sort)
+		add_list(seq, ":sort=", hist->sort);
+
+	if (hist->size)
+		trace_seq_printf(seq, ":size=%d", hist->size);
+
+	switch(command) {
+	case TRACEFS_HIST_CMD_START: break;
+	case TRACEFS_HIST_CMD_PAUSE: trace_seq_puts(seq, ":pause"); break;
+	case TRACEFS_HIST_CMD_CONT: trace_seq_puts(seq, ":cont"); break;
+	case TRACEFS_HIST_CMD_CLEAR: trace_seq_puts(seq, ":clear"); break;
+	default: break;
+	}
+
+	if (hist->name)
+		trace_seq_printf(seq, ":name=%s", hist->name);
+
+	if (hist->filter)
+		trace_seq_printf(seq, " if %s", hist->filter);
+
+}
+
+/*
+ * trace_hist_show - show how to start the histogram
+ * @seq: A trace_seq to store the commands to create
+ * @hist: The histogram to write into the trigger file
+ * @command: If not zero, can pause, continue or clear the histogram
+ *
+ * This shows the commands to create the histogram for an event
+ * with the given fields.
+ *
+ * Returns 0 on succes -1 on error.
+ */
+int
+tracefs_hist_show(struct trace_seq *seq, struct tracefs_instance *instance,
+		  struct tracefs_hist *hist,
+		  enum tracefs_hist_command command)
+{
+	const char *system = hist->system;
+	const char *event = hist->event_name;
+	char *path;
+
+	if (!hist->keys) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	path = tracefs_event_get_file(instance, system, event, "trigger");
+	if (!path)
+		return -1;
+
+	trace_seq_puts(seq, "echo '");
+
+	add_hist_commands(seq, hist, command);
+
+	trace_seq_printf(seq, "' > %s\n", path);
+
+	tracefs_put_tracing_file(path);
+
+	return 0;
+}
+
 /*
  * tracefs_hist_command - Create, start, pause, destroy a histogram for an event
  * @instance: The instance the histogram will be in (NULL for toplevel)
@@ -78,34 +151,9 @@ int tracefs_hist_command(struct tracefs_instance *instance,
 
 	trace_seq_init(&seq);
 
-	if (command == TRACEFS_HIST_CMD_DESTROY)
-		trace_seq_putc(&seq, '!');
-
-	add_list(&seq, "hist:keys=", hist->keys);
-
-	if (hist->values)
-		add_list(&seq, ":vals=", hist->values);
-
-	if (hist->sort)
-		add_list(&seq, ":sort=", hist->sort);
-
-	if (hist->size)
-		trace_seq_printf(&seq, ":size=%d", hist->size);
-
-	switch(command) {
-	case TRACEFS_HIST_CMD_START: break;
-	case TRACEFS_HIST_CMD_PAUSE: trace_seq_puts(&seq, ":pause"); break;
-	case TRACEFS_HIST_CMD_CONT: trace_seq_puts(&seq, ":cont"); break;
-	case TRACEFS_HIST_CMD_CLEAR: trace_seq_puts(&seq, ":clear"); break;
-	default: break;
-	}
-
-	if (hist->name)
-		trace_seq_printf(&seq, ":name=%s", hist->name);
-
-	if (hist->filter)
-		trace_seq_printf(&seq, " if %s\n", hist->filter);
+	add_hist_commands(&seq, hist, command);
 
+	trace_seq_putc(&seq, '\n');
 	trace_seq_terminate(&seq);
 
 	ret = -1;
-- 
2.30.2

