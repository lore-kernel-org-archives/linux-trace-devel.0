Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1827FC4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0151361078
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhHCQs0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237224AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E78D6103C;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaP-002uUp-3M; Tue, 03 Aug 2021 12:48:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 6/7] libtracefs: Add API tracefs_synth_get_start_hist()
Date:   Tue,  3 Aug 2021 12:48:10 -0400
Message-Id: <20210803164811.693731-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803164811.693731-1-rostedt@goodmis.org>
References: <20210803164811.693731-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the API tracefs_synth_get_start_hist() that returns a tracefs_hist
descriptor describing the start event of a tracefs_synth.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt |  4 ++
 include/tracefs.h                   |  1 +
 src/tracefs-hist.c                  | 73 +++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 41680d5b9cba..5d34c4f60469 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -17,6 +17,7 @@ int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
 			  struct tracefs_synth pass:[*]synth);
 int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pass:[*]instance,
 		       struct tracefs_synth pass:[*]synth);
+struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
 
 --
 
@@ -52,6 +53,9 @@ this may fail as busy.
 the synthetic event in the given _instance_, it will write the echo commands to
 manually create it in the _seq_ given.
 
+*tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
+the histogram used to create the synthetic event.
+
 RETURN VALUE
 ------------
 Returns zero on success or -1 on error.
diff --git a/include/tracefs.h b/include/tracefs.h
index ab781764b0ed..8148bd57224b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -467,6 +467,7 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    const char *field,
 				    enum tracefs_compare compare,
 				    const char *val);
+struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 7c84e942d58b..379f75c7de24 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -543,6 +543,7 @@ struct tracefs_synth {
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
+	char			**start_selection;
 	char			**start_keys;
 	char			**end_keys;
 	char			**start_vars;
@@ -1061,6 +1062,7 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 {
 	const struct tep_format_field *field;
 	char *start_arg;
+	char **tmp;
 	int ret;
 
 	if (!synth || !start_field) {
@@ -1087,7 +1089,14 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 		goto out_free;
 
 	ret = add_synth_fields(synth, field, name);
+	if (ret)
+		goto out_free;
 
+	tmp = tracefs_list_add(synth->start_selection, start_field);
+	if (tmp)
+		synth->start_selection = tmp;
+	else
+		ret = -1;
  out_free:
 	free(start_arg);
 	return ret;
@@ -1345,6 +1354,70 @@ static int verify_state(struct tracefs_synth *synth)
 	return 0;
 }
 
+/**
+ * tracefs_synth_get_start_hist - Return the histogram of the start event
+ * @synth: The synthetic event to get the start hist from.
+ *
+ * On success, returns a tracefs_hist descriptor that holds the
+ * histogram information of the start_event of the synthetic event
+ * structure. Returns NULL on failure.
+ */
+struct tracefs_hist *
+tracefs_synth_get_start_hist(struct tracefs_synth *synth)
+{
+	struct tracefs_hist *hist = NULL;
+	struct tep_handle *tep;
+	const char *system;
+	const char *event;
+	const char *key;
+	char **keys;
+	int ret;
+	int i;
+
+	if (!synth) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	system = synth->start_event->system;
+	event = synth->start_event->name;
+	keys = synth->start_keys;
+	tep = synth->tep;
+
+	if (!keys)
+		keys = synth->start_selection;
+
+	if (!keys)
+		return NULL;
+
+	for (i = 0; keys[i]; i++) {
+		key = keys[i];
+
+		if (i) {
+			ret = tracefs_hist_add_key(hist, key, 0);
+			if (ret < 0) {
+				tracefs_hist_free(hist);
+				return NULL;
+			}
+		} else {
+			hist = tracefs_hist_alloc(tep, system, event,
+						  key, 0);
+			if (!hist)
+				return NULL;
+		}
+	}
+
+	if (synth->start_filter) {
+		hist->filter = strdup(synth->start_filter);
+		if (!hist->filter) {
+			tracefs_hist_free(hist);
+			return NULL;
+		}
+	}
+
+	return hist;
+}
+
 /**
  * tracefs_synth_create - creates the synthetic event on the system
  * @instance: The instance to modify the start and end events
-- 
2.30.2

