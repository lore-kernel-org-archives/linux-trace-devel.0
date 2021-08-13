Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FED3C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F328610FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhHMCRx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237397AbhHMCRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34704610A8;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wVu-Re; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/7] libtracefs: Add logic to apply actions to synthetic events
Date:   Thu, 12 Aug 2021 22:16:50 -0400
Message-Id: <20210813021655.939819-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an actions list to tracefs_synth, that if it is not empty then it will
be used to apply the handlers and actions to be taken. Otherwise the
default of "onmatch" and "trace" is used.

Currently nothing adds any actions and only the default is supported, but
this will allow for new handlers (onmax and onchange) as well as new
actions (snapshot and save).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h  |  7 +++++
 src/tracefs-hist.c | 76 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 90994de97dda..d83c4e33c69a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -435,6 +435,13 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
+enum tracefs_synth_handler {
+	TRACEFS_SYNTH_HANDLE_NONE	= 0,
+	TRACEFS_SYNTH_HANDLE_MATCH,
+	TRACEFS_SYNTH_HANDLE_MAX,
+	TRACEFS_SYNTH_HANDLE_CHANGE,
+};
+
 struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
 					 const char *name,
 					 const char *start_system,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 7fffa6cc653d..262db7fbb925 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -521,12 +521,25 @@ int tracefs_hist_append_filter(struct tracefs_hist *hist,
 				   type, field, compare, val);
 }
 
+enum action_type {
+	ACTION_NONE,
+	ACTION_TRACE,
+};
+
+struct action {
+	struct action			*next;
+	enum action_type		type;
+	enum tracefs_synth_handler	handler;
+	char				*handle_field;
+};
+
 /*
  * @name: name of the synthetic event
  * @start_system: system of the starting event
  * @start_event: the starting event
  * @end_system: system of the ending event
  * @end_event: the ending event
+ * @actions: List of actions to take
  * @match_names: If a match set is to be a synthetic field, it has a name
  * @start_match: list of keys in the start event that matches end event
  * @end_match: list of keys in the end event that matches the start event
@@ -545,6 +558,8 @@ struct tracefs_synth {
 	struct tep_handle	*tep;
 	struct tep_event	*start_event;
 	struct tep_event	*end_event;
+	struct action		*actions;
+	struct action		**next_action;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -575,6 +590,8 @@ struct tracefs_synth {
  */
 void tracefs_synth_free(struct tracefs_synth *synth)
 {
+	struct action *action;
+
 	if (!synth)
 		return;
 
@@ -590,6 +607,12 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 
 	tep_unref(synth->tep);
 
+	while ((action = synth->actions)) {
+		synth->actions = action->next;
+		free(action->handle_field);
+		free(action);
+	}
+
 	free(synth);
 }
 
@@ -750,6 +773,7 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
 		return NULL;
 
 	synth->start_event = start_event;
+	synth->next_action = &synth->actions;
 
 	/* Hold onto a reference to this handler */
 	tep_ref(tep);
@@ -1405,13 +1429,61 @@ static char *create_trace(char *hist, struct tracefs_synth *synth)
 	return append_string(hist, NULL, ")");
 }
 
+static char *create_max(char *hist, struct tracefs_synth *synth, char *field)
+{
+	hist = append_string(hist, NULL, ":onmax(");
+	hist = append_string(hist, NULL, field);
+	return append_string(hist, NULL, ")");
+}
+
+static char *create_change(char *hist, struct tracefs_synth *synth, char *field)
+{
+	hist = append_string(hist, NULL, ":onchange(");
+	hist = append_string(hist, NULL, field);
+	return append_string(hist, NULL, ")");
+}
+
+static char *create_actions(char *hist, struct tracefs_synth *synth)
+{
+	struct action *action;
+
+	if (!synth->actions) {
+		/* Default is "onmatch" and "trace" */
+		hist = create_onmatch(hist, synth);
+		return create_trace(hist, synth);
+	}
+
+	for (action = synth->actions; action; action = action->next) {
+		switch (action->handler) {
+		case TRACEFS_SYNTH_HANDLE_MATCH:
+			hist = create_onmatch(hist, synth);
+			break;
+		case TRACEFS_SYNTH_HANDLE_MAX:
+			hist = create_max(hist, synth, action->handle_field);
+			break;
+		case TRACEFS_SYNTH_HANDLE_CHANGE:
+			hist = create_change(hist, synth, action->handle_field);
+			break;
+		default:
+			continue;
+		}
+		switch (action->type) {
+		case ACTION_TRACE:
+			hist = create_trace(hist, synth);
+			break;
+		default:
+			continue;
+		}
+	}
+	return hist;
+}
+
 static char *create_end_hist(struct tracefs_synth *synth)
 {
 	char *end_hist;
 
 	end_hist = create_hist(synth->end_keys, synth->end_vars);
-	end_hist = create_onmatch(end_hist, synth);
-	return create_trace(end_hist, synth);
+	return create_actions(end_hist, synth);
 }
 
 static char *append_filter(char *hist, char *filter, unsigned int parens)
-- 
2.30.2

