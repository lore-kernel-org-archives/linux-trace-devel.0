Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A6EC4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5395461038
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhHCC7e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhHCC7e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 22:59:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18CC60FA0;
        Tue,  3 Aug 2021 02:59:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAkeI-002qG5-MP; Mon, 02 Aug 2021 22:59:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/7] libtracefs: Add API tracefs_hist_append_filter()
Date:   Mon,  2 Aug 2021 22:59:17 -0400
Message-Id: <20210803025921.677469-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803025921.677469-1-rostedt@goodmis.org>
References: <20210803025921.677469-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an API that will append a filter to the histogram just like filters
can be added to the synthetic event's start and end events.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 37 +++++++++++++++++++++++++
 include/tracefs.h                 | 45 +++++++++++++++++--------------
 src/tracefs-hist.c                | 14 ++++++++++
 3 files changed, 76 insertions(+), 20 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index e5861f2f0842..9bf13ac03af7 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -25,6 +25,11 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
+int tracefs_hist_append_filter(struct tracefs_hist pass:[*]hist,
+			       enum tracefs_filter type,
+			       const char pass:[*]field,
+			       enum tracefs_compare compare,
+			       const char pass:[*]val);
 int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
@@ -84,6 +89,38 @@ compatible keys, the multiple histograms with the same name will be merged
 into a single histogram (shown by either event's hist file). The _hist_
 is the histogram to name, and the _name_ is the name to give it.
 
+*tracefs_hist_append_filter*() creates a filter or appends to it for the
+histogram  event. Depending on _type_, it will build a string of tokens for
+parenthesis or logic statemens, or it may add a comparison of _field_
+to _val_ based on _compare_.
+
+If _type_ is:
+*TRACEFS_FILTER_COMPARE*     -  See below
+*TRACEFS_FILTER_AND*         -  Append "&&" to the filter
+*TRACEFS_FILTER_OR*          -  Append "||" to the filter
+*TRACEFS_FILTER_NOT*         -  Append "!" to the filter
+*TRACEFS_FILTER_OPEN_PAREN*  -  Append "(" to the filter
+*TRACEFS_FILTER_CLOSE_PAREN* -  Append ")" to the filter
+
+_field_, _compare_, and _val_ are ignored unless _type_ is equal to
+*TRACEFS_FILTER_COMPARE*, then _compare will be used for the following:
+
+*TRACEFS_COMPARE_EQ* - _field_ == _val_
+
+*TRACEFS_COMPARE_NE* - _field_ != _val_
+
+*TRACEFS_COMPARE_GT* - _field_ > _val_
+
+*TRACEFS_COMPARE_GE* - _field_ >= _val_
+
+*TRACEFS_COMPARE_LT* - _field_ < _val_
+
+*TRACEFS_COMPARE_LE* - _field_ <pass:[=] _val_
+
+*TRACEFS_COMPARE_RE* - _field_ ~ "_val_" : where _field_ is a string.
+
+*TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
+
 *tracefs_hist_command*() is called to process a command on the histogram
 _hist_ for its event in the given _instance_, or NULL for the top level.
 The _cmd_ can be one of:
diff --git a/include/tracefs.h b/include/tracefs.h
index 302833722a99..0be6e907d29b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -287,6 +287,26 @@ enum tracefs_hist_command {
 	TRACEFS_HIST_CMD_DESTROY,
 };
 
+enum tracefs_filter {
+	TRACEFS_FILTER_COMPARE,
+	TRACEFS_FILTER_AND,
+	TRACEFS_FILTER_OR,
+	TRACEFS_FILTER_NOT,
+	TRACEFS_FILTER_OPEN_PAREN,
+	TRACEFS_FILTER_CLOSE_PAREN,
+};
+
+enum tracefs_compare {
+	TRACEFS_COMPARE_EQ,
+	TRACEFS_COMPARE_NE,
+	TRACEFS_COMPARE_GT,
+	TRACEFS_COMPARE_GE,
+	TRACEFS_COMPARE_LT,
+	TRACEFS_COMPARE_LE,
+	TRACEFS_COMPARE_RE,
+	TRACEFS_COMPARE_AND,
+};
+
 void tracefs_hist_free
 (struct tracefs_hist *hist);
 struct tracefs_hist *
@@ -302,6 +322,11 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 				    const char *sort_key,
 				    enum tracefs_hist_sort_direction dir);
 int tracefs_hist_add_name(struct tracefs_hist *hist, const char *name);
+int tracefs_hist_append_filter(struct tracefs_hist *hist,
+			       enum tracefs_filter type,
+			       const char *field,
+			       enum tracefs_compare compare,
+			       const char *val);
 int tracefs_hist_command(struct tracefs_instance *instance,
 			 struct tracefs_hist *hist, enum tracefs_hist_command cmd);
 
@@ -396,26 +421,6 @@ enum tracefs_synth_calc {
 	TRACEFS_SYNTH_ADD,
 };
 
-enum tracefs_compare {
-	TRACEFS_COMPARE_EQ,
-	TRACEFS_COMPARE_NE,
-	TRACEFS_COMPARE_GT,
-	TRACEFS_COMPARE_GE,
-	TRACEFS_COMPARE_LT,
-	TRACEFS_COMPARE_LE,
-	TRACEFS_COMPARE_RE,
-	TRACEFS_COMPARE_AND,
-};
-
-enum tracefs_filter {
-	TRACEFS_FILTER_COMPARE,
-	TRACEFS_FILTER_AND,
-	TRACEFS_FILTER_OR,
-	TRACEFS_FILTER_NOT,
-	TRACEFS_FILTER_OPEN_PAREN,
-	TRACEFS_FILTER_CLOSE_PAREN,
-};
-
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
 				const char *field, enum tracefs_compare compare,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ccd331c1f52d..1be14362f407 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -33,6 +33,8 @@ struct tracefs_hist {
 	char			**sort;
 	char			*filter;
 	int			size;
+	unsigned int		filter_parens;
+	unsigned int		filter_state;
 };
 
 static void add_list(struct trace_seq *seq, const char *start,
@@ -454,6 +456,18 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 	return 0;
 }
 
+int tracefs_hist_append_filter(struct tracefs_hist *hist,
+			       enum tracefs_filter type,
+			       const char *field,
+			       enum tracefs_compare compare,
+			       const char *val)
+{
+	return trace_append_filter(&hist->filter, &hist->filter_state,
+				   &hist->filter_parens,
+				   hist->event,
+				   type, field, compare, val);
+}
+
 /*
  * @name: name of the synthetic event
  * @start_system: system of the starting event
-- 
2.30.2

