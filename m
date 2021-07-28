Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC50BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B356B60F5E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhG1DkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 23:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhG1DkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 23:40:01 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D01C60FA0;
        Wed, 28 Jul 2021 03:40:00 +0000 (UTC)
Date:   Tue, 27 Jul 2021 23:39:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH v2] libtracefs: Add "precedence" to
 tracefs_synth_add_start/end_filter()
Message-ID: <20210727233953.2c1638b3@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While implementing the sqlhist, I found that the
tracefs_synth_add_start/end_filter() was not sufficient in adding the
possible filters that the kernel accepts. That is, we could not implement:

  A && (B || C) && D

as it only allowed appending operators, and the kernel sets && as a higher
precedence than ||. That is, if we try to do the above with just:

  A && B || C && D

The kernel will interpret it as:

  (A && B) || (C && D)

To fix this, add a "precedence" that will allow the user to add
"parenthesis" to the logic:

  #define AND 0
  #define OR 1

 1. tracefs_synth_add_start( A, 0, AND);
 2. tracefs_synth_add_start( B, 1, AND);
 3. tracefs_synth_add_start( C, 1, OR);
 4. tracefs_synth_add_start( D, 0, AND);

Will produce the A && (B || C) && D

Because 1, will add A (AND is ignored) and save precedence '0'
        2, will add B, but precedence is 1, so 1 '(' is added
        3, will add C, with same precedence as step 2.
        4, will add D, but since the precedence dropped, it adds
            a ')' before the "&&"

The "neg" is given a precedence too, to state where to add the "!"

(note, the original code had "-" for negative, which was wrong)

To produce: (A || !(B && !C)) && D

   This time with (compare, neg, precedence, do_or)

 1. tracefs_synth_add_start( A, 0, 1, AND);
 2. tracefs_synth_add_start( B, 2, 2, OR);
 3. tracefs_synth_add_start( C, 1, 2, AND);
 4. tracefs_synth_add_start( D, 0, 0, AND);

Also, rename the parameter in tracefs from "or" to "or_conj" as "or" is a
keyword in C++ as reported by Yordan Karadzhov:

  Link: https://lore.kernel.org/linux-trace-devel/20210727135030.25914-1-y.karadz@gmail.com/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:

  - Fixed the return of add_synth_filter()

 include/tracefs.h  |   8 +-
 src/tracefs-hist.c | 206 +++++++++++++++++++++++++--------------------
 2 files changed, 117 insertions(+), 97 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 9cfd257..25d99f8 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -354,13 +354,13 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
 				   const char *field,
 				   enum tracefs_synth_compare compare,
-				   const char *val,
-				   bool neg, bool or);
+				   const char *val, unsigned int neg,
+				   unsigned int precedence, bool or_conj);
 int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
 				 const char *field,
 				 enum tracefs_synth_compare compare,
-				 const char *val,
-				 bool neg, bool or);
+				 const char *val, unsigned int neg,
+				 unsigned int precedence, bool or_conj);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8b90787..969944a 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -559,7 +559,8 @@ struct tracefs_synth {
 	char			**end_vars;
 	char			*start_filter;
 	char			*end_filter;
-
+	int			start_precedence;
+	int			end_precedence;
 	int			arg_cnt;
 };
 
@@ -1166,100 +1167,112 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 static int add_synth_filter(char **filter, const char *field,
 			    enum tracefs_synth_compare compare,
 			    const char *val, bool is_string,
-			    bool neg, bool or)
+			    int neg, int precedence, bool or)
 {
-	const char *minus = "";
-	const char *op;
-	char *str = NULL;
-	int ret;
-
-	switch (compare) {
-	case TRACEFS_COMPARE_EQ:
-		op = "==";
-		break;
+	struct trace_seq seq;
+	int i;
 
-	case TRACEFS_COMPARE_NQ:
-		op = "!=";
-		break;
+	trace_seq_init(&seq);
 
-	case TRACEFS_COMPARE_GR:
-		op = ">";
-		if (is_string)
-			goto inval;
-		break;
+	if (*filter) {
+		trace_seq_puts(&seq, *filter);
+
+		if (precedence < 0) {
+			for (i = 0; i > precedence; i--)
+				trace_seq_putc(&seq, ')');
+			/* neg adds new parenthesis. */
+			if (neg)
+				precedence = 1;
+		}
 
-	case TRACEFS_COMPARE_GE:
-		op = ">=";
-		if (is_string)
-			goto inval;
-		break;
+		if (or)
+			trace_seq_puts(&seq, "||");
+		else
+			trace_seq_puts(&seq, "&&");
+	}
 
-	case TRACEFS_COMPARE_LT:
-		op = "<";
-		if (is_string)
-			goto inval;
-		break;
+	for (i = 0; i < precedence; i++) {
+		if (i + 1 == neg)
+			trace_seq_putc(&seq, '!');
+		trace_seq_putc(&seq, '(');
+	}
 
-	case TRACEFS_COMPARE_LE:
-		op = "<=";
-		if (is_string)
-			goto inval;
-		break;
+	trace_seq_puts(&seq, field);
 
+	switch (compare) {
+	case TRACEFS_COMPARE_EQ: trace_seq_puts(&seq, " == "); break;
+	case TRACEFS_COMPARE_NQ: trace_seq_puts(&seq, " != "); break;
 	case TRACEFS_COMPARE_RE:
-		op = "~";
 		if (!is_string)
 			goto inval;
+		trace_seq_putc(&seq, '~');
 		break;
-
-	case TRACEFS_COMPARE_AND:
-		op = "&";
+	default:
 		if (is_string)
 			goto inval;
-		break;
 	}
 
-	if (neg)
-		minus = "-";
+	switch (compare) {
+	case TRACEFS_COMPARE_GR: trace_seq_puts(&seq, " > "); break;
+	case TRACEFS_COMPARE_GE: trace_seq_puts(&seq, " >= "); break;
+	case TRACEFS_COMPARE_LT: trace_seq_puts(&seq, " < "); break;
+	case TRACEFS_COMPARE_LE: trace_seq_puts(&seq, " <= "); break;
+	case TRACEFS_COMPARE_AND: trace_seq_puts(&seq, " & "); break;
+	default: break;
+	}
 
-	if (is_string && val[0] != '"')
-		ret = asprintf(&str, "%s(%s %s \"%s\")",
-			       minus, field, op, val);
-	else
-		ret = asprintf(&str, "%s(%s %s %s)",
-			       minus, field, op, val);
+	trace_seq_puts(&seq, val);
 
-	if (ret < 0)
+	trace_seq_terminate(&seq);
+
+	if (seq.state != TRACE_SEQ__GOOD) {
+		errno = ENOMEM;
+		trace_seq_destroy(&seq);
 		return -1;
+	}
 
-	if (*filter) {
-		char *new;
-		char *conjunction = or ? "||" : "&&";
+	free(*filter);
 
-		ret = asprintf(&new, "%s %s %s", *filter,
-			       conjunction, str);
-		free(str);
-		if (ret < 0)
-			return -1;
-		free(*filter);
-		*filter = new;
-	} else {
-		*filter = str;
-	}
+	*filter = strdup(seq.buffer);
+	trace_seq_destroy(&seq);
 
-	return 0;
+	return *filter == NULL ? -1 : 0;
 inval:
 	errno = -EINVAL;
 	return -1;
 }
 
+static void update_precedence(int *saved, int *precedence, int *neg)
+{
+	int cur = *saved;
+
+	*saved = *precedence;
+
+	/*
+	 * neg only makes sense at precedence or between
+	 * cur and precedence.
+	 */
+	if (*neg && (*neg < cur || *neg > *precedence))
+		*neg = 1;
+	else if (*neg)
+		*neg -= cur;
+
+	*precedence -= cur;
+
+	/* A negative adds parenthesis around the compare */
+	if (*neg && *precedence <= 0)
+		(*precedence)++;
+}
+
 int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
 				   const char *field,
 				   enum tracefs_synth_compare compare,
-				   const char *val,
-				   bool neg, bool or)
+				   const char *val, unsigned int uneg,
+				   unsigned int uprecedence, bool or)
 {
 	const struct tep_format_field *start_field;
+	int precedence = uprecedence;
+	int neg = uneg;
 	bool is_string;
 
 	if (!field || !val)
@@ -1274,9 +1287,11 @@ int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
 	if (!is_string && (start_field->flags & TEP_FIELD_IS_ARRAY))
 		goto inval;
 
+	update_precedence(&synth->start_precedence, &precedence, &neg);
+
 	return add_synth_filter(&synth->start_filter,
 				field, compare, val, is_string,
-				neg, or);
+				neg, precedence, or);
 inval:
 	errno = -EINVAL;
 	return -1;
@@ -1285,10 +1300,12 @@ inval:
 int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
 				 const char *field,
 				 enum tracefs_synth_compare compare,
-				 const char *val,
-				 bool neg, bool or)
+				 const char *val, unsigned int uneg,
+				 unsigned int uprecedence, bool or)
 {
 	const struct tep_format_field *end_field;
+	int precedence = uprecedence;
+	int neg = uneg;
 	bool is_string;
 
 	if (!field || !val)
@@ -1303,9 +1320,11 @@ int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
 	if (!is_string && (end_field->flags & TEP_FIELD_IS_ARRAY))
 		goto inval;
 
+	update_precedence(&synth->end_precedence, &precedence, &neg);
+
 	return add_synth_filter(&synth->end_filter,
 				field, compare, val, is_string,
-				neg, or);
+				neg, precedence, or);
 inval:
 	errno = -EINVAL;
 	return -1;
@@ -1414,6 +1433,20 @@ static char *create_end_hist(struct tracefs_synth *synth)
 	return append_string(end_hist, NULL, ")");
 }
 
+static char *append_filter(char *hist, char *filter, int precedence)
+{
+	int i;
+
+	if (!filter)
+		return hist;
+
+	hist = append_string(hist, NULL, " if ");
+	hist = append_string(hist, NULL, filter);
+	for (i = 0; i < precedence; i++)
+		hist = append_string(hist, NULL, ")");
+	return hist;
+}
+
 /**
  * tracefs_synth_create - creates the synthetic event on the system
  * @instance: The instance to modify the start and end events
@@ -1451,18 +1484,14 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 		goto free_synthetic;
 
 	start_hist = create_hist(synth->start_keys, synth->start_vars);
-	if (synth->start_filter) {
-		start_hist = append_string(start_hist, NULL, " if ");
-		start_hist = append_string(start_hist, NULL, synth->start_filter);
-	}
+	start_hist = append_filter(start_hist, synth->start_filter,
+				   synth->start_precedence);
 	if (!start_hist)
 		goto remove_synthetic;
 
 	end_hist = create_end_hist(synth);
-	if (synth->end_filter) {
-		end_hist = append_string(end_hist, NULL, " if ");
-		end_hist = append_string(end_hist, NULL, synth->end_filter);
-	}
+	end_hist = append_filter(end_hist, synth->end_filter,
+				   synth->end_precedence);
 	if (!end_hist)
 		goto remove_synthetic;
 
@@ -1528,20 +1557,16 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	tracefs_event_disable(instance, "synthetic", synth->name);
 
 	hist = create_end_hist(synth);
-	if (synth->end_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->end_filter);
-	}
+	hist = append_filter(hist, synth->end_filter,
+			     synth->end_precedence);
 	if (!hist)
 		return -1;
 	ret = remove_hist(instance, synth->end_event, hist);
 	free(hist);
 
 	hist = create_hist(synth->start_keys, synth->start_vars);
-	if (synth->start_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->start_filter);
-	}
+	hist = append_filter(hist, synth->start_filter,
+			     synth->start_precedence);
 	if (!hist)
 		return -1;
 
@@ -1599,10 +1624,8 @@ int tracefs_synth_show(struct trace_seq *seq,
 	path = tracefs_instance_get_dir(instance);
 
 	hist = create_hist(synth->start_keys, synth->start_vars);
-	if (synth->start_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->start_filter);
-	}
+	hist = append_filter(hist, synth->start_filter,
+			     synth->start_precedence);
 	if (!hist)
 		goto out_free;
 
@@ -1611,11 +1634,8 @@ int tracefs_synth_show(struct trace_seq *seq,
 			 synth->start_event->name);
 	free(hist);
 	hist = create_end_hist(synth);
-
-	if (synth->end_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->end_filter);
-	}
+	hist = append_filter(hist, synth->end_filter,
+			     synth->end_precedence);
 	if (!hist)
 		goto out_free;
 
-- 
2.31.1

