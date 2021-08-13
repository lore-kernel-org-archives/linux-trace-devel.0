Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70ADEC4320A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F796113C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhHMCRz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237630AbhHMCRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37778610CF;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wW0-UQ; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5/7] libtracefs: Add API tracefs_synth_save()
Date:   Thu, 12 Aug 2021 22:16:53 -0400
Message-Id: <20210813021655.939819-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an API tracefs_synth_save() that will save fields when onmax() or
onchange() handlers are executed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt |  9 ++++
 include/tracefs.h                   |  3 ++
 src/tracefs-hist.c                  | 73 ++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 194a4e021f62..cfcae7411f58 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -25,6 +25,9 @@ int tracefs_synth_trace(struct tracefs_synth pass:[*]synth,
 			enum tracefs_synth_handler type, const char pass:[*]var);
 int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
 			   enum tracefs_synth_handler type, const char pass:[*]var);
+int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
+		       enum tracefs_synth_handler type, const char pass:[*]var,
+		       char pass:[**]save_fields);
 --
 
 DESCRIPTION
@@ -84,6 +87,12 @@ into a "snapshot" buffer, that can be accessed via the "snapshot" file in the
 top level tracefs directory, or one of the instances.  _var_ changes. _var_ must be one of
 the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
+*tracefs_synth_save*() When the given variable _var_ is either a new max if
+_handler_ is TRACEFS_SYNTH_HANDLE_MAX_ or simpy changed if TRACEFS_SYNTH_HANDLE_CHANGE_
+then saven the given _save_fields_ list. The fields will be stored in the histogram
+"hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
+_var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
+
 RETURN VALUE
 ------------
 Returns zero on success or -1 on error.
diff --git a/include/tracefs.h b/include/tracefs.h
index 45a5bb2df2de..25abbdc10ebf 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -480,6 +480,9 @@ int tracefs_synth_trace(struct tracefs_synth *synth,
 			enum tracefs_synth_handler type, const char *field);
 int tracefs_synth_snapshot(struct tracefs_synth *synth,
 			   enum tracefs_synth_handler type, const char *field);
+int tracefs_synth_save(struct tracefs_synth *synth,
+		       enum tracefs_synth_handler type, const char *field,
+		       char **save_fields);
 bool tracefs_synth_complete(struct tracefs_synth *synth);
 struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 2c9c37b8ec23..003715fa693c 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -525,6 +525,7 @@ enum action_type {
 	ACTION_NONE,
 	ACTION_TRACE,
 	ACTION_SNAPSHOT,
+	ACTION_SAVE,
 };
 
 struct action {
@@ -532,6 +533,7 @@ struct action {
 	enum action_type		type;
 	enum tracefs_synth_handler	handler;
 	char				*handle_field;
+	char				*save;
 };
 
 /*
@@ -580,6 +582,13 @@ struct tracefs_synth {
 	int			arg_cnt;
 };
 
+static void action_free(struct action *action)
+{
+	free(action->handle_field);
+	free(action->save);
+	free(action);
+}
+
 /**
  * tracefs_synth_free - free the resources alloced to a synth
  * @synth: The tracefs_synth descriptor
@@ -610,8 +619,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 
 	while ((action = synth->actions)) {
 		synth->actions = action->next;
-		free(action->handle_field);
-		free(action);
+		action_free(action);
 	}
 
 	free(synth);
@@ -1445,6 +1453,64 @@ int tracefs_synth_snapshot(struct tracefs_synth *synth,
 	return 0;
 }
 
+/**
+ * tracefs_synth_save - create a save command to the histogram
+ * @synth: The tracefs_synth descriptor
+ * @type: The type of handler to attach the save action
+ * @max_field: The field for handlers onmax and onchange
+ * @fields: The fields to save for the end variable
+ *
+ * Add the action to save fields for handlers onmax and onchange.
+ *
+ * Returns 0 on succes, -1 on error.
+ */
+int tracefs_synth_save(struct tracefs_synth *synth,
+		       enum tracefs_synth_handler type, const char *max_field,
+		       char **fields)
+{
+	struct action *action;
+	char *save;
+	int i;
+
+	if (!synth || !max_field || (type == TRACEFS_SYNTH_HANDLE_MATCH)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	action = create_action(type, synth, max_field);
+	if (!action)
+		return -1;
+
+	action->type = ACTION_SAVE;
+	action->handler = type;
+	*synth->next_action = action;
+	synth->next_action = &action->next;
+
+	save = strdup(".save(");
+	if (!save)
+		goto error;
+
+	for (i = 0; fields[i]; i++) {
+		char *delim = i ? "," : NULL;
+
+		if (!trace_verify_event_field(synth->end_event, fields[i], NULL))
+			goto error;
+		save = append_string(save, delim, fields[i]);
+	}
+	save = append_string(save, NULL, ")");
+	if (!save)
+		goto error;
+
+	action->save = save;
+	add_action(synth, action);
+	return 0;
+ error:
+	action_free(action);
+	free(save);
+	return -1;
+	return 0;
+}
+
 static char *create_synthetic_event(struct tracefs_synth *synth)
 {
 	char *synthetic_event;
@@ -1596,6 +1662,9 @@ static char *create_actions(char *hist, struct tracefs_synth *synth)
 		case ACTION_SNAPSHOT:
 			hist = append_string(hist, NULL, ".snapshot()");
 			break;
+		case ACTION_SAVE:
+			hist = append_string(hist, NULL, action->save);
+			break;
 		default:
 			continue;
 		}
-- 
2.30.2

