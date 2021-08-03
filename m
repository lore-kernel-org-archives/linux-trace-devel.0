Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BD1C19F34
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC2FC6104F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbhHCQs1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237238AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC1F61040;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaO-002uUa-Up; Tue, 03 Aug 2021 12:48:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/7] libtracefs: Change the tracefs_hist API to not take an instance immediately
Date:   Tue,  3 Aug 2021 12:48:05 -0400
Message-Id: <20210803164811.693731-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803164811.693731-1-rostedt@goodmis.org>
References: <20210803164811.693731-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After implementing tracefs_sql(), it became apparent that passing the
instance into the tracefs_hist API to create the descriptor was the wrong
approach. It's better to just pass in a tep_handle for verification
purposes, and then have the user pass in the instance when creating the
histogram. This also allows to easily create the same histogram in
different instances if need be.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 40 +++++++++++-------
 include/tracefs.h                 | 16 ++++----
 src/tracefs-hist.c                | 68 +++++++++++++++++--------------
 3 files changed, 71 insertions(+), 53 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 0254c5faea82..28b4c3d65cde 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_instance pass:[*] instance,
+struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			const char pass:[*]key, enum tracefs_hist_key_type type);
 void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
@@ -25,8 +25,8 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
-int tracefs_hist_start(struct tracefs_hist pass:[*]hist);
-int tracefs_hist_destory(struct tracefs_hist pass:[*]hist);
+int tracefs_hist_start(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int tracefs_hist_destory(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
 --
 
 DESCRIPTION
@@ -38,10 +38,11 @@ See https://www.kernel.org/doc/html/latest/trace/histogram.html for more informa
 
 *tracefs_hist_alloc*() allocates a "struct tracefs_hist" descriptor and returns
 the address of it. This descriptor must be freed by *tracefs_hist_free*().
-The _instance_ is the instance that contains the event that the histogram will be
-attached to. The _system_ is the system or group of the event. The _event_ is the event
-to attach the histogram to. The _key_ is a field of the event that will be used as
-the key of the histogram. The _type_ is the type of the _key_. See KEY TYPES below.
+The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
+_system_ and _event_ that the histogram will be attached to. The _system_ is the
+system or group of the event. The _event_ is the event to attach the histogram to.
+The _key_ is a field of the event that will be used as the key of the histogram.
+The _type_ is the type of the _key_. See KEY TYPES below.
 
 *tracefs_hist_free*() frees the _tracefs_hist_ descriptor. Note, it does not stop
 or disable the running histogram if it was started. *tracefs_hist_destroy*() needs
@@ -81,15 +82,24 @@ into a single histogram (shown by either event's hist file). The _hist_
 is the histogram to name, and the _name_ is the name to give it.
 
 *tracefs_hist_start* is called to actually start the histogram _hist_.
+The _instance_ is the instance to start the histogram in, NULL if it
+should start at the top level.
 
 *tracefs_hist_pause* is called to pause the histogram _hist_.
+The _instance_ is the instance to pause the histogram in, NULL if it
+is in the top level.
 
 *tracefs_hist_continue* is called to continue a paused histogram _hist_.
+The _instance_ is the instance to continue the histogram, NULL if it
+is in the top level.
 
 *tracefs_hist_reset* is called to clear / reset the histogram _hist_.
+The _instance_ is the instance to clear the histogram, NULL if it
+is in the top level.
 
 *tracefs_hist_destory* is called to delete the histogram where it will no longer
-exist.
+exist.  The _instance_ is the instance to delete the histogram from, NULL if it
+is in the top level.
 
 
 KEY TYPES
@@ -152,6 +162,7 @@ int main (int argc, char **argv, char **env)
 {
 	struct tracefs_instance *instance;
 	struct tracefs_hist *hist;
+	struct tep_handle *tep;
 	enum commands cmd;
 	char *cmd_str;
 	int ret;
@@ -186,7 +197,8 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	hist = tracefs_hist_alloc(instance, "kmem", "kmalloc",
+	tep = tracefs_local_events(NULL);
+	hist = tracefs_hist_alloc(tep, "kmem", "kmalloc",
 				  "call_site", TRACEFS_HIST_KEY_SYM);
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
@@ -208,7 +220,7 @@ int main (int argc, char **argv, char **env)
 
 	switch (cmd) {
 	case START:
-		ret = tracefs_hist_start(hist);
+		ret = tracefs_hist_start(instance, hist);
 		if (ret) {
 			char *err = tracefs_error_last(instance);
 			if (err)
@@ -216,16 +228,16 @@ int main (int argc, char **argv, char **env)
 		}
 		break;
 	case PAUSE:
-		ret = tracefs_hist_pause(hist);
+		ret = tracefs_hist_pause(instance, hist);
 		break;
 	case CONT:
-		ret = tracefs_hist_continue(hist);
+		ret = tracefs_hist_continue(instance, hist);
 		break;
 	case RESET:
-		ret = tracefs_hist_reset(hist);
+		ret = tracefs_hist_reset(instance, hist);
 		break;
 	case DELETE:
-		ret = tracefs_hist_destroy(hist);
+		ret = tracefs_hist_destroy(instance, hist);
 		break;
 	case SHOW: {
 		char *content;
diff --git a/include/tracefs.h b/include/tracefs.h
index 246647f6496d..ff115d6ce01d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -282,9 +282,9 @@ struct tracefs_hist;
 void tracefs_hist_free
 (struct tracefs_hist *hist);
 struct tracefs_hist *
-tracefs_hist_alloc(struct tracefs_instance * instance,
-		       const char *system, const char *event,
-		       const char *key, enum tracefs_hist_key_type type);
+tracefs_hist_alloc(struct tep_handle *tep,
+		   const char *system, const char *event,
+		   const char *key, enum tracefs_hist_key_type type);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
@@ -294,11 +294,11 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name);
-int tracefs_hist_start(struct tracefs_hist *hist);
-int tracefs_hist_pause(struct tracefs_hist *hist);
-int tracefs_hist_continue(struct tracefs_hist *hist);
-int tracefs_hist_reset(struct tracefs_hist *hist);
-int tracefs_hist_destroy(struct tracefs_hist *hist);
+int tracefs_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist);
+int tracefs_hist_pause(struct tracefs_instance *instance,struct tracefs_hist *hist);
+int tracefs_hist_continue(struct tracefs_instance *instance,struct tracefs_hist *hist);
+int tracefs_hist_reset(struct tracefs_instance *instance,struct tracefs_hist *hist);
+int tracefs_hist_destroy(struct tracefs_instance *instance,struct tracefs_hist *hist);
 
 struct tracefs_synth;
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 7292f89457c9..b72171af9577 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -23,9 +23,10 @@
 #define DESCENDING ".descending"
 
 struct tracefs_hist {
-	struct tracefs_instance *instance;
+	struct tep_handle	*tep;
+	struct tep_event	*event;
 	char			*system;
-	char			*event;
+	char			*event_name;
 	char			*name;
 	char			**keys;
 	char			**values;
@@ -65,15 +66,17 @@ static void add_list(struct trace_seq *seq, const char *start,
  * Returns 0 on succes -1 on error.
  */
 static int
-trace_hist_start(struct tracefs_hist *hist,
+trace_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist,
 		 enum tracefs_hist_command command)
 {
-	struct tracefs_instance *instance = hist->instance;
 	const char *system = hist->system;
-	const char *event = hist->event;
+	const char *event = hist->event_name;
 	struct trace_seq seq;
 	int ret;
 
+	if (!tracefs_event_file_exists(instance, system, event, HIST_FILE))
+		return -1;
+
 	errno = -EINVAL;
 	if (!hist->keys)
 		return -1;
@@ -129,9 +132,9 @@ void tracefs_hist_free(struct tracefs_hist *hist)
 	if (!hist)
 		return;
 
-	trace_put_instance(hist->instance);
+	tep_unref(hist->tep);
 	free(hist->system);
-	free(hist->event);
+	free(hist->event_name);
 	free(hist->name);
 	free(hist->filter);
 	tracefs_list_free(hist->keys);
@@ -142,9 +145,9 @@ void tracefs_hist_free(struct tracefs_hist *hist)
 
 /**
  * tracefs_hist_alloc - Initialize a histogram
- * @instance: The instance the histogram will be in (NULL for toplevel)
+ * @tep: The tep handle that has the @system and @event.
  * @system: The system the histogram event is in.
- * @event: The event that the histogram will be attached to.
+ * @event_name: The name of the event that the histogram will be attached to.
  * @key: The primary key the histogram will use
  * @type: The format type of the key.
  *
@@ -157,33 +160,31 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  * NULL on failure.
  */
 struct tracefs_hist *
-tracefs_hist_alloc(struct tracefs_instance * instance,
-			const char *system, const char *event,
+tracefs_hist_alloc(struct tep_handle *tep,
+			const char *system, const char *event_name,
 			const char *key, enum tracefs_hist_key_type type)
 {
+	struct tep_event *event;
 	struct tracefs_hist *hist;
 	int ret;
 
-	if (!system || !event || !key)
+	if (!system || !event_name || !key)
 		return NULL;
 
-	if (!tracefs_event_file_exists(instance, system, event, HIST_FILE))
+	event = tep_find_event_by_name(tep, system, event_name);
+	if (!event)
 		return NULL;
 
 	hist = calloc(1, sizeof(*hist));
 	if (!hist)
 		return NULL;
 
-	ret = trace_get_instance(instance);
-	if (ret < 0) {
-		free(hist);
-		return NULL;
-	}
-
-	hist->instance = instance;
+	tep_ref(tep);
+	hist->tep = tep;
 
+	hist->event = event;
 	hist->system = strdup(system);
-	hist->event = strdup(event);
+	hist->event_name = strdup(event_name);
 
 	ret = tracefs_hist_add_key(hist, key, type);
 
@@ -302,58 +303,63 @@ int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name)
 
 /**
  * tracefs_hist_start - enable a histogram
+ * @instance: The instance the histogram will be in (NULL for toplevel)
  * @hist: The histogram to start
  *
  * Starts executing a histogram.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_start(struct tracefs_hist *hist)
+int tracefs_hist_start(struct tracefs_instance *instance, struct tracefs_hist *hist)
 {
-	return trace_hist_start(hist, 0);
+	return trace_hist_start(instance, hist, 0);
 }
 
 /**
  * tracefs_hist_pause - pause a histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
  * @hist: The histogram to pause
  *
  * Pause a histogram.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_pause(struct tracefs_hist *hist)
+int tracefs_hist_pause(struct tracefs_instance *instance, struct tracefs_hist *hist)
 {
-	return trace_hist_start(hist, HIST_CMD_PAUSE);
+	return trace_hist_start(instance, hist, HIST_CMD_PAUSE);
 }
 
 /**
  * tracefs_hist_continue - continue a paused histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
  * @hist: The histogram to continue
  *
  * Continue a histogram.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_continue(struct tracefs_hist *hist)
+int tracefs_hist_continue(struct tracefs_instance *instance, struct tracefs_hist *hist)
 {
-	return trace_hist_start(hist, HIST_CMD_CONT);
+	return trace_hist_start(instance, hist, HIST_CMD_CONT);
 }
 
 /**
  * tracefs_hist_reset - clear a histogram
+ * @instance: The instance the histogram is in (NULL for toplevel)
  * @hist: The histogram to reset
  *
  * Resets a histogram.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_reset(struct tracefs_hist *hist)
+int tracefs_hist_reset(struct tracefs_instance *instance, struct tracefs_hist *hist)
 {
-	return trace_hist_start(hist, HIST_CMD_CLEAR);
+	return trace_hist_start(instance, hist, HIST_CMD_CLEAR);
 }
 
 /**
  * tracefs_hist_destroy - deletes a histogram (needs to be enabled again)
+ * @instance: The instance the histogram is in (NULL for toplevel)
  * @hist: The histogram to delete
  *
  * Deletes (removes) a running histogram. This is different than
@@ -363,9 +369,9 @@ int tracefs_hist_reset(struct tracefs_hist *hist)
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_destroy(struct tracefs_hist *hist)
+int tracefs_hist_destroy(struct tracefs_instance *instance, struct tracefs_hist *hist)
 {
-	return trace_hist_start(hist, HIST_CMD_DESTROY);
+	return trace_hist_start(instance, hist, HIST_CMD_DESTROY);
 }
 
 static char **
-- 
2.30.2

