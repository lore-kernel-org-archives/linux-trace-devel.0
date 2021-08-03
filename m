Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D9AC19F31
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C30636104F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhHCQs1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 244EE60F94;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaO-002uUc-Vy; Tue, 03 Aug 2021 12:48:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/7] libtracefs: Expose tracefs_hist_command() as an API
Date:   Tue,  3 Aug 2021 12:48:06 -0400
Message-Id: <20210803164811.693731-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803164811.693731-1-rostedt@goodmis.org>
References: <20210803164811.693731-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Expose trace_hist_start() as tracefs_hist_command() and make the following
functions wrappers that call this function:

 tracefs_hist_start()
 tracefs_hist_pause()
 tracefs_hist_reset()
 tracefs_hist_destroy()

Exposing the enum for the above commands can make it easier for
applications to run them depending on the input from the user.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt |  20 ++++++
 include/tracefs.h                 |  93 ++++++++++++++++++++++++--
 src/tracefs-hist.c                | 104 ++++--------------------------
 3 files changed, 120 insertions(+), 97 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 28b4c3d65cde..e5861f2f0842 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -25,6 +25,9 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
+int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
+			 struct tracefs_hist pass:[*]hist,
+			 enum tracefs_hist_command command);
 int tracefs_hist_start(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
 int tracefs_hist_destory(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
 --
@@ -81,6 +84,23 @@ compatible keys, the multiple histograms with the same name will be merged
 into a single histogram (shown by either event's hist file). The _hist_
 is the histogram to name, and the _name_ is the name to give it.
 
+*tracefs_hist_command*() is called to process a command on the histogram
+_hist_ for its event in the given _instance_, or NULL for the top level.
+The _cmd_ can be one of:
+
+*TRACEFS_HIST_CMD_START* or zero to start execution of the histogram.
+
+*TRACEFS_HIST_CMD_PAUSE* to pause the given histogram.
+
+*TRACEFS_HIST_CMD_CONT* to continue a paused histogram.
+
+*TRACEFS_HIST_CMD_CLEAR* to reset the values of a histogram.
+
+*TRACEFS_HIST_CMD_DESTROY* to destroy the histogram (undo a START).
+
+The below functions are wrappers to tracefs_hist_command() to make the
+calling conventions a bit easier to understand what is happening.
+
 *tracefs_hist_start* is called to actually start the histogram _hist_.
 The _instance_ is the instance to start the histogram in, NULL if it
 should start at the top level.
diff --git a/include/tracefs.h b/include/tracefs.h
index ff115d6ce01d..302833722a99 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -279,6 +279,14 @@ enum tracefs_hist_sort_direction {
 
 struct tracefs_hist;
 
+enum tracefs_hist_command {
+	TRACEFS_HIST_CMD_START = 0,
+	TRACEFS_HIST_CMD_PAUSE,
+	TRACEFS_HIST_CMD_CONT,
+	TRACEFS_HIST_CMD_CLEAR,
+	TRACEFS_HIST_CMD_DESTROY,
+};
+
 void tracefs_hist_free
 (struct tracefs_hist *hist);
 struct tracefs_hist *
@@ -294,11 +302,86 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name);
-int tracefs_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist);
-int tracefs_hist_pause(struct tracefs_instance *instance,struct tracefs_hist *hist);
-int tracefs_hist_continue(struct tracefs_instance *instance,struct tracefs_hist *hist);
-int tracefs_hist_reset(struct tracefs_instance *instance,struct tracefs_hist *hist);
-int tracefs_hist_destroy(struct tracefs_instance *instance,struct tracefs_hist *hist);
+int tracefs_hist_command(struct tracefs_instance *instance,
+			 struct tracefs_hist *hist, enum tracefs_hist_command cmd);
+
+/**
+ * tracefs_hist_start - enable a histogram
+ * @instance: The instance the histogram will be in (NULL for toplevel)
+ * @hist: The histogram to start
+ *
+ * Starts executing a histogram.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static inline int tracefs_hist_start(struct tracefs_instance *instance,
+				     struct tracefs_hist *hist)
+{
+	return tracefs_hist_command(instance, hist, 0);
+}
+
+/**
+ * tracefs_hist_pause - pause a histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
+ * @hist: The histogram to pause
+ *
+ * Pause a histogram.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static inline int tracefs_hist_pause(struct tracefs_instance *instance,
+				     struct tracefs_hist *hist)
+{
+	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_PAUSE);
+}
+
+/**
+ * tracefs_hist_continue - continue a paused histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
+ * @hist: The histogram to continue
+ *
+ * Continue a histogram.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static inline int tracefs_hist_continue(struct tracefs_instance *instance,
+					struct tracefs_hist *hist)
+{
+	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_CONT);
+}
+
+/**
+ * tracefs_hist_reset - clear a histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
+ * @hist: The histogram to reset
+ *
+ * Resets a histogram.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static inline int tracefs_hist_reset(struct tracefs_instance *instance,
+				     struct tracefs_hist *hist)
+{
+	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_CLEAR);
+}
+
+/**
+ * tracefs_hist_destroy - deletes a histogram (needs to be enabled again)
+ * @instance: The instance the histogram is in (NULL for toplevel)
+ * @hist: The histogram to delete
+ *
+ * Deletes (removes) a running histogram. This is different than
+ * clear, as clear only clears the data but the histogram still exists.
+ * This deletes the histogram and should be called before
+ * tracefs_hist_free() to clean up properly.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+static inline int tracefs_hist_destroy(struct tracefs_instance *instance,
+				       struct tracefs_hist *hist)
+{
+	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_DESTROY);
+}
 
 struct tracefs_synth;
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index b72171af9577..ccd331c1f52d 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -35,14 +35,6 @@ struct tracefs_hist {
 	int			size;
 };
 
-enum tracefs_hist_command {
-	HIST_CMD_NONE = 0,
-	HIST_CMD_PAUSE,
-	HIST_CMD_CONT,
-	HIST_CMD_CLEAR,
-	HIST_CMD_DESTROY,
-};
-
 static void add_list(struct trace_seq *seq, const char *start,
 		     char **list)
 {
@@ -57,17 +49,18 @@ static void add_list(struct trace_seq *seq, const char *start,
 }
 
 /*
- * trace_hist_start - Create and start a histogram for an event
+ * tracefs_hist_command - Create, start, pause, destroy a histogram for an event
+ * @instance: The instance the histogram will be in (NULL for toplevel)
  * @hist: The histogram to write into the trigger file
- * @command: If not zero, can pause, continue or clear the histogram
+ * @command: Command to perform on a histogram.
  *
- * This creates a histogram for an event with the given fields.
+ * Creates, pause, continue, clears, or destroys a histogram.
  *
  * Returns 0 on succes -1 on error.
  */
-static int
-trace_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist,
-		 enum tracefs_hist_command command)
+int tracefs_hist_command(struct tracefs_instance *instance,
+			 struct tracefs_hist *hist,
+			 enum tracefs_hist_command command)
 {
 	const char *system = hist->system;
 	const char *event = hist->event_name;
@@ -83,7 +76,7 @@ trace_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist,
 
 	trace_seq_init(&seq);
 
-	if (command == HIST_CMD_DESTROY)
+	if (command == TRACEFS_HIST_CMD_DESTROY)
 		trace_seq_putc(&seq, '!');
 
 	add_list(&seq, "hist:keys=", hist->keys);
@@ -98,10 +91,10 @@ trace_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist,
 		trace_seq_printf(&seq, ":size=%d", hist->size);
 
 	switch(command) {
-	case HIST_CMD_NONE: break;
-	case HIST_CMD_PAUSE: trace_seq_puts(&seq, ":pause"); break;
-	case HIST_CMD_CONT: trace_seq_puts(&seq, ":cont"); break;
-	case HIST_CMD_CLEAR: trace_seq_puts(&seq, ":clear"); break;
+	case TRACEFS_HIST_CMD_START: break;
+	case TRACEFS_HIST_CMD_PAUSE: trace_seq_puts(&seq, ":pause"); break;
+	case TRACEFS_HIST_CMD_CONT: trace_seq_puts(&seq, ":cont"); break;
+	case TRACEFS_HIST_CMD_CLEAR: trace_seq_puts(&seq, ":clear"); break;
 	default: break;
 	}
 
@@ -301,79 +294,6 @@ int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name)
 	return hist->name ? 0 : -1;
 }
 
-/**
- * tracefs_hist_start - enable a histogram
- * @instance: The instance the histogram will be in (NULL for toplevel)
- * @hist: The histogram to start
- *
- * Starts executing a histogram.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist)
-{
-	return trace_hist_start(instance, hist, 0);
-}
-
-/**
- * tracefs_hist_pause - pause a histogram
- * @instance: The instance the histogram is in (NULL for toplevel)
- * @hist: The histogram to pause
- *
- * Pause a histogram.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_pause(struct tracefs_instance *instance, struct tracefs_hist *hist)
-{
-	return trace_hist_start(instance, hist, HIST_CMD_PAUSE);
-}
-
-/**
- * tracefs_hist_continue - continue a paused histogram
- * @instance: The instance the histogram is in (NULL for toplevel)
- * @hist: The histogram to continue
- *
- * Continue a histogram.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_continue(struct tracefs_instance *instance, struct tracefs_hist *hist)
-{
-	return trace_hist_start(instance, hist, HIST_CMD_CONT);
-}
-
-/**
- * tracefs_hist_reset - clear a histogram
- * @instance: The instance the histogram is in (NULL for toplevel)
- * @hist: The histogram to reset
- *
- * Resets a histogram.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_reset(struct tracefs_instance *instance, struct tracefs_hist *hist)
-{
-	return trace_hist_start(instance, hist, HIST_CMD_CLEAR);
-}
-
-/**
- * tracefs_hist_destroy - deletes a histogram (needs to be enabled again)
- * @instance: The instance the histogram is in (NULL for toplevel)
- * @hist: The histogram to delete
- *
- * Deletes (removes) a running histogram. This is different than
- * clear, as clear only clears the data but the histogram still exists.
- * This deletes the histogram and should be called before
- * tracefs_hist_free() to clean up properly.
- *
- * Returns 0 on success, -1 on error.
- */
-int tracefs_hist_destroy(struct tracefs_instance *instance, struct tracefs_hist *hist)
-{
-	return trace_hist_start(instance, hist, HIST_CMD_DESTROY);
-}
-
 static char **
 add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 {
-- 
2.30.2

