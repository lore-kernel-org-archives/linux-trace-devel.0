Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5683C43216
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93EEE61101
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhHMCR7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237705AbhHMCRx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA46610E9;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wVy-TV; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/7] libtracefs: Add API tracefs_synth_snapshot()
Date:   Thu, 12 Aug 2021 22:16:52 -0400
Message-Id: <20210813021655.939819-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add new API tracefs_synth_snapshot()

Where this will add "actions" to the synthetic event descriptor and also
add other features besides "onmatch()" such that the output can be:

  onmax($lat).trace(latency,$lat):onmax($lat).snapshot

That will trace the latency when it hits a maximum, and also take a
snapshot of the buffer.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt | 11 +++++++++-
 include/tracefs.h                   |  2 ++
 src/tracefs-hist.c                  | 34 +++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index a74e88ec0eda..194a4e021f62 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_show,tracefs_synth_complete,
-tracefs_synth_get_start_hist,tracefs_synth_trace - Creation of synthetic events
+tracefs_synth_get_start_hist,tracefs_synth_trace,tracefs_synth_snapshot - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -23,6 +23,8 @@ struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pa
 
 int tracefs_synth_trace(struct tracefs_synth pass:[*]synth,
 			enum tracefs_synth_handler type, const char pass:[*]var);
+int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
+			   enum tracefs_synth_handler type, const char pass:[*]var);
 --
 
 DESCRIPTION
@@ -75,6 +77,13 @@ when the given variable _var_ hits a new max for the matching keys. Or
 *TRACEFS_SYNTH_HANDLE_CHANGE* for when the _var_ changes. _var_ must be one of
 the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
+*tracefs_synth_snapshot*() When the given variable _var_ is either a new max if
+_handler_ is TRACEFS_SYNTH_HANDLE_MAX_ or simpy changed if TRACEFS_SYNTH_HANDLE_CHANGE_
+then take a "snapshot" of the buffer. The snapshot moves the normal "trace" buffer
+into a "snapshot" buffer, that can be accessed via the "snapshot" file in the
+top level tracefs directory, or one of the instances.  _var_ changes. _var_ must be one of
+the _name_ elements used in *tracefs_synth_add_end_field*(3).
+
 RETURN VALUE
 ------------
 Returns zero on success or -1 on error.
diff --git a/include/tracefs.h b/include/tracefs.h
index 2faa564a860f..45a5bb2df2de 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -478,6 +478,8 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    const char *val);
 int tracefs_synth_trace(struct tracefs_synth *synth,
 			enum tracefs_synth_handler type, const char *field);
+int tracefs_synth_snapshot(struct tracefs_synth *synth,
+			   enum tracefs_synth_handler type, const char *field);
 bool tracefs_synth_complete(struct tracefs_synth *synth);
 struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 562ec65088a9..2c9c37b8ec23 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -524,6 +524,7 @@ int tracefs_hist_append_filter(struct tracefs_hist *hist,
 enum action_type {
 	ACTION_NONE,
 	ACTION_TRACE,
+	ACTION_SNAPSHOT,
 };
 
 struct action {
@@ -1414,6 +1415,36 @@ int tracefs_synth_trace(struct tracefs_synth *synth,
 	return 0;
 }
 
+/**
+ * tracefs_synth_snapshot - create a snapshot command to the histogram
+ * @synth: The tracefs_synth descriptor
+ * @type: The type of handler to attach the snapshot action with
+ * @field: The field for handlers onmax and onchange
+ *
+ * Add the action to do a snapshot for handlers onmax and onchange.
+ *
+ * Returns 0 on succes, -1 on error.
+ */
+int tracefs_synth_snapshot(struct tracefs_synth *synth,
+			   enum tracefs_synth_handler type, const char *field)
+{
+	struct action *action;
+
+	if (!synth || !field || (type == TRACEFS_SYNTH_HANDLE_MATCH)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	action = create_action(type, synth, field);
+	if (!action)
+		return -1;
+
+	action->type = ACTION_SNAPSHOT;
+	action->handler = type;
+	add_action(synth, action);
+	return 0;
+}
+
 static char *create_synthetic_event(struct tracefs_synth *synth)
 {
 	char *synthetic_event;
@@ -1562,6 +1593,9 @@ static char *create_actions(char *hist, struct tracefs_synth *synth)
 		case ACTION_TRACE:
 			hist = create_trace(hist, synth);
 			break;
+		case ACTION_SNAPSHOT:
+			hist = append_string(hist, NULL, ".snapshot()");
+			break;
 		default:
 			continue;
 		}
-- 
2.30.2

