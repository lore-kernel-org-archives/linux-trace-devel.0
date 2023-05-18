Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A52C7EE23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 May 2023 14:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjEROYb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 May 2023 10:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjEROYa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 May 2023 10:24:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F751E69
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 May 2023 07:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11BF647AC
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 May 2023 14:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2604C4339B;
        Thu, 18 May 2023 14:24:27 +0000 (UTC)
Date:   Thu, 18 May 2023 10:24:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2] libtracefs: Add stacktrace to tracefs_sql()
Message-ID: <20230518102421.0dadbe26@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the kernel can pass stacktraces from the start to end of a
synthetic event, update the tracefs_sql() (and by doing so sqlhist) to
handle stacktrace.

A new keyword STACKTRACE is added, so the following will now work:

  sqlhist -e -n block_lat 'SELECT (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS delta,start.STACKTRACE AS stack
     FROM sched_switch AS start JOIN sched_switch AS end ON end.next_pid = start.prev_pid
     WHERE start.prev_state == 1 && start.prev_prio < 100'

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230117113545.5effb1dc@gandalf.local.home
 - The kernel is switching to use common_stacktrace instead of stacktrace
   Use that instead.

 Documentation/libtracefs-sql.txt | 13 +++++++++++++
 include/tracefs-local.h          |  2 ++
 include/tracefs.h                |  3 +++
 src/tracefs-filter.c             | 10 ++++++++++
 src/tracefs-hist.c               | 18 +++++++++++++++++-
 src/tracefs-sqlhist.c            |  5 ++++-
 6 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 6d606db..62fd771 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -162,6 +162,19 @@ select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sche
    WHERE start.prio < 100 || end.prev_prio < 100
 --
 
+If the kernel supports it, you can pass around a stacktrace between events.
+
+[source, c]
+--
+select start.prev_pid as pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta, start.STACKTRACE as stack
+   FROM sched_switch as start JOIN sched_switch as end ON start.prev_pid = end.next_pid
+   WHERE start.prev_state == 2
+--
+
+The above will record a stacktrace when a task is in the UNINTERRUPTIBLE (blocked) state, and trigger
+the synthetic event when it is scheduled back in, recording the time delta that it was blocked for.
+It will record the stacktrace of where it was when it scheduled out along with the delta.
+
 
 KEYWORDS AS EVENT FIELDS
 ------------------------
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index da99a30..9e5a568 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -51,6 +51,8 @@ struct tracefs_instance {
 	bool				iterate_keep_going;
 };
 
+extern const struct tep_format_field common_stacktrace;
+
 extern pthread_mutex_t toplevel_lock;
 
 static inline pthread_mutex_t *trace_get_lock(struct tracefs_instance *instance)
diff --git a/include/tracefs.h b/include/tracefs.h
index 5e9d84b..5410d00 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -335,6 +335,7 @@ enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_LOG,
 	TRACEFS_HIST_KEY_USECS,
 	TRACEFS_HIST_KEY_BUCKETS,
+	TRACEFS_HIST_KEY_STACKTRACE,
 	TRACEFS_HIST_KEY_MAX
 };
 
@@ -554,6 +555,8 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
+#define TRACEFS_STACKTRACE "common_stacktrace"
+
 enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_NONE	= 0,
 	TRACEFS_SYNTH_HANDLE_MATCH,
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index a3dd77b..3628eae 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -41,6 +41,13 @@ static const struct tep_format_field common_comm = {
 	.size			= 16,
 };
 
+const struct tep_format_field common_stacktrace __hidden = {
+	.type			= "unsigned long[]",
+	.name			= "stacktrace",
+	.size			= 4,
+	.flags			= TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC,
+};
+
 /*
  * This also must be able to accept fields that are OK via the histograms,
  * such as common_timestamp.
@@ -56,6 +63,9 @@ static const struct tep_format_field *get_event_field(struct tep_event *event,
 	if (!strcmp(field_name, TRACEFS_TIMESTAMP_USECS))
 		return &common_timestamp_usecs;
 
+	if (!strcmp(field_name, TRACEFS_STACKTRACE))
+		return &common_stacktrace;
+
 	field = tep_find_any_field(event, field_name);
 	if (!field && (!strcmp(field_name, "COMM") || !strcmp(field_name, "comm")))
 		return &common_comm;
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index fb6231e..e8d984b 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -416,6 +416,9 @@ int tracefs_hist_add_key_cnt(struct tracefs_hist *hist, const char *key,
 	case TRACEFS_HIST_KEY_BUCKETS:
 		ret = asprintf(&key_type, "%s.buckets=%d", key, cnt);
 		break;
+	case TRACEFS_HIST_KEY_STACKTRACE:
+		ret = asprintf(&key_type, "%s.stacktrace", key);
+		break;
 	case TRACEFS_HIST_KEY_MAX:
 		/* error */
 		break;
@@ -500,14 +503,23 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 {
 	char **key_list = hist->keys;
 	char **val_list = hist->values;
+	char *dot;
+	int len;
 	int i;
 
 	if (strcmp(sort_key, TRACEFS_HIST_HITCOUNT) == 0)
 		goto out;
 
+	len = strlen(sort_key);
+
 	for (i = 0; key_list[i]; i++) {
 		if (strcmp(key_list[i], sort_key) == 0)
 			break;
+		dot = strchr(key_list[i], '.');
+		if (!dot || dot - key_list[i] != len)
+			continue;
+		if (strncmp(key_list[i], sort_key, len) == 0)
+			break;
 	}
 
 	if (!key_list[i] && val_list) {
@@ -915,7 +927,8 @@ static char *add_synth_field(const struct tep_format_field *field,
 	bool sign;
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
-		str = strdup("char");
+		str = strdup(field->type);
+		str = strtok(str, "[");
 		str = append_string(str, " ", name);
 		str = append_string(str, NULL, "[");
 
@@ -967,6 +980,9 @@ static char *add_synth_field(const struct tep_format_field *field,
 		return NULL;
 	}
 
+	if (field == &common_stacktrace)
+		type = field->type;
+
 	str = strdup(type);
 	str = append_string(str, " ", name);
 	return append_string(str, NULL, ";");
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 3f571b7..0035922 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -566,7 +566,8 @@ static int test_field_exists(struct tep_handle *tep,
 		return -1;
 
 	if (!strcmp(field_name, TRACEFS_TIMESTAMP) ||
-	    !strcmp(field->field, TRACEFS_TIMESTAMP_USECS))
+	    !strcmp(field->field, TRACEFS_TIMESTAMP_USECS) ||
+	    !strcmp(field->field, TRACEFS_STACKTRACE))
 		tfield = (void *)1L;
 	else
 		tfield = tep_find_any_field(field->event, field_name);
@@ -695,6 +696,8 @@ static int update_vars(struct tep_handle *tep,
 			field->field = store_str(sb, TRACEFS_TIMESTAMP);
 		if (!strcmp(field->field, "TIMESTAMP_USECS"))
 			field->field = store_str(sb, TRACEFS_TIMESTAMP_USECS);
+		if (!strcmp(field->field, "STACKTRACE"))
+			field->field = store_str(sb, TRACEFS_STACKTRACE);
 		if (test_field_exists(tep, sb, expr))
 			return -1;
 	}
-- 
2.39.2

