Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0092C4320E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9043C61103
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhHMCRz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237331AbhHMCRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3093B60F35;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wVw-Sa; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/7] libtracefs: Add API tracefs_synth_trace()
Date:   Thu, 12 Aug 2021 22:16:51 -0400
Message-Id: <20210813021655.939819-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the API tracefs_synth_trace() that adds a "trace" action that can be
attached to the onmax or the onchange handler. Note, this still can be
used for onmatch, but that's the default anyway.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt | 17 +++++-
 include/tracefs.h                   |  2 +
 src/tracefs-hist.c                  | 91 +++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 44693b394f29..a74e88ec0eda 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_show - Creation of synthetic events
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_show,tracefs_synth_complete,
+tracefs_synth_get_start_hist,tracefs_synth_trace - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -20,6 +21,8 @@ int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pas
 bool tracefs_synth_complete(struct tracefs_synth pass:[*]synth);
 struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
 
+int tracefs_synth_trace(struct tracefs_synth pass:[*]synth,
+			enum tracefs_synth_handler type, const char pass:[*]var);
 --
 
 DESCRIPTION
@@ -60,6 +63,18 @@ a starting and ending event.
 *tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
 the histogram used to create the synthetic event.
 
+enum tracefs_synth_handler {
+	TRACEFS_SYNTH_HANDLE_MATCH,
+	TRACEFS_SYNTH_HANDLE_MAX,
+	TRACEFS_SYNTH_HANDLE_CHANGE,
+};
+
+*tracefs_synth_trace*() Instead of doing just a trace on matching of the start and
+end events, do the _type_ handler where *TRACEFS_SYNTH_HANDLE_MAX* will do a trace
+when the given variable _var_ hits a new max for the matching keys. Or
+*TRACEFS_SYNTH_HANDLE_CHANGE* for when the _var_ changes. _var_ must be one of
+the _name_ elements used in *tracefs_synth_add_end_field*(3).
+
 RETURN VALUE
 ------------
 Returns zero on success or -1 on error.
diff --git a/include/tracefs.h b/include/tracefs.h
index d83c4e33c69a..2faa564a860f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -476,6 +476,8 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    const char *field,
 				    enum tracefs_compare compare,
 				    const char *val);
+int tracefs_synth_trace(struct tracefs_synth *synth,
+			enum tracefs_synth_handler type, const char *field);
 bool tracefs_synth_complete(struct tracefs_synth *synth);
 struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 262db7fbb925..562ec65088a9 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1323,6 +1323,97 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				   type, field, compare, val);
 }
 
+static int test_max_var(struct tracefs_synth *synth, const char *var)
+{
+	char **vars = synth->end_vars;
+	char *p;
+	int len;
+	int i;
+
+	len = strlen(var);
+
+	/* Make sure the var is defined for the end event */
+	for (i = 0; vars[i]; i++) {
+		p = strchr(vars[i], '=');
+		if (!p)
+			continue;
+		if (p - vars[i] != len)
+			continue;
+		if (!strncmp(var, vars[i], len))
+			return 0;
+	}
+	errno = ENODEV;
+	return -1;
+}
+
+static struct action *create_action(enum tracefs_synth_handler type,
+				    struct tracefs_synth *synth,
+				    const char *var)
+{
+	struct action *action;
+	int ret;
+
+	switch (type) {
+	case TRACEFS_SYNTH_HANDLE_MAX:
+	case TRACEFS_SYNTH_HANDLE_CHANGE:
+		ret = test_max_var(synth, var);
+		if (ret < 0)
+			return NULL;
+		break;
+	default:
+		break;
+	}
+
+	action = calloc(1, sizeof(*action));
+	if (!action)
+		return NULL;
+
+	if (var) {
+		ret = asprintf(&action->handle_field, "$%s", var);
+		if (!action->handle_field) {
+			free(action);
+			return NULL;
+		}
+	}
+	return action;
+}
+
+static void add_action(struct tracefs_synth *synth, struct action *action)
+{
+	*synth->next_action = action;
+	synth->next_action = &action->next;
+}
+
+/**
+ * tracefs_synth_trace - Execute the trace option
+ * @synth: The tracefs_synth descriptor
+ * @type: The type of handler to attach the trace action with
+ * @field: The field for handlers onmax and onchange (ignored otherwise)
+ *
+ * Add the action 'trace' for handlers onmatch, onmax and onchange.
+ *
+ * Returns 0 on succes, -1 on error.
+ */
+int tracefs_synth_trace(struct tracefs_synth *synth,
+			enum tracefs_synth_handler type, const char *field)
+{
+	struct action *action;
+
+	if (!synth || (!field && (type != TRACEFS_SYNTH_HANDLE_MATCH))) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	action = create_action(type, synth, field);
+	if (!action)
+		return -1;
+
+	action->type = ACTION_TRACE;
+	action->handler = type;
+	add_action(synth, action);
+	return 0;
+}
+
 static char *create_synthetic_event(struct tracefs_synth *synth)
 {
 	char *synthetic_event;
-- 
2.30.2

