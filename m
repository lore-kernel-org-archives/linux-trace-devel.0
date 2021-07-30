Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D69C432BE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C18960EB5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhG3DD1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhG3DDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716BF6103A;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PQx-3P; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/6] libtracefs: Append the synth filter with parens and conjunctions
Date:   Thu, 29 Jul 2021 23:03:04 -0400
Message-Id: <20210730030307.574270-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

I tried to fix this with a precedence, showing different levels of
precedence between options and it too wasn't sufficient to handle all the
cases that the kernel can.

Instead, go with the KISS approach, and do it with just letting the user
append the parenthesis, nots and conjunctions. Keeping the state of the
last update makes sure that an invalid append does not go through.

For example, to produce:

  A || (!(B && !C) && !(D)

 tracefs_synth_append_start_field( TRACEFS_FILTER_COMPARE, A );
 tracefs_synth_append_start_field( TRACEFS_FILTER_OR, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_OPEN_PAREN, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_NOT, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_OPEN_PAREN, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_COMPARE, B );
 tracefs_synth_append_start_field( TRACEFS_FILTER_AND, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_NOT, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_COMPARE, C );
 tracefs_synth_append_start_field( TRACEFS_FILTER_CLOSE_PAREN, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_AND, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_NOT, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_OPEN_PAREN, NULL );
 tracefs_synth_append_start_field( TRACEFS_FILTER_COMPARE, D );

The number of left over open parenthesis is kept track of and on printing or
executing the synth, it will close all the parenthesis that are left open.

(note, the original code had "-" for negative, which was wrong)

Also, rename the parameter in tracefs from "or" to "or_conj" as "or" is a
keyword in C++ as reported by Yordan Karadzhov:

  Link: https://lore.kernel.org/linux-trace-devel/20210727135030.25914-1-y.karadz@gmail.com/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth.txt |  74 +++---
 include/tracefs.h                  |  29 ++-
 src/tracefs-hist.c                 | 366 ++++++++++++++++++-----------
 3 files changed, 293 insertions(+), 176 deletions(-)

diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index b20b4a7eb911..47e93bd42674 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_synth_init, tracefs_synth_add_match_field, tracefs_synth_add_compare_field, tracefs_synth_add_start_field,
-tracefs_synth_add_end_field, tracefs_synth_add_start_filter, tracefs_synth_add_end_filter, tracefs_synth_create,
+tracefs_synth_add_end_field, tracefs_synth_append_start_filter, tracefs_synth_append_end_filter, tracefs_synth_create,
 tracefs_synth_destroy, tracefs_synth_free, tracefs_synth_show - Creation of synthetic events
 
 SYNOPSIS
@@ -37,16 +37,16 @@ int tracefs_synth_add_start_field(struct tracefs_synth pass:[*]synth,
 int tracefs_synth_add_end_field(struct tracefs_synth pass:[*]synth,
 				const char pass:[*]end_field,
 				const char pass:[*]name);
-int tracefs_synth_add_start_filter(struct tracefs_synth pass:[*]synth,
-				   const char pass:[*]field,
-				   enum tracefs_synth_compare compare,
-				   const char pass:[*]val,
-				   bool neg, bool or);
-int tracefs_synth_add_end_filter(struct tracefs_synth pass:[*]synth,
-				 const char pass:[*]field,
-				 enum tracefs_synth_compare compare,
-				 const char pass:[*]val,
-				 bool neg, bool or);
+int tracefs_synth_append_start_filter(struct tracefs_synth pass:[*]synth,
+				      struct tracefs_filter type,
+				      const char pass:[*]field,
+				      enum tracefs_synth_compare compare,
+				      const char pass:[*]val);
+int tracefs_synth_append_end_filter(struct tracefs_synth pass:[*]synth,
+				    struct tracefs_filter type,
+				    const char pass:[*]field,
+				    enum tracefs_synth_compare compare,
+				    const char pass:[*]val);
 int tracefs_synth_create(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_synth pass:[*]synth);
 int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
@@ -127,13 +127,21 @@ will be the same as _start_field_.
 event as _name_ in the synthetic event. If _name_ is NULL, then the name used
 will be the same as _end_field_.
 
-*tracefs_synth_add_start_filter*() adds a filter to the starting event
-comparing the content of the starting event's _field_ to _val_ based
-on _compare_. If _neg_ is set, then the compare is wrapped in parenthesis
-and negated. The _or_ field only is used if more than one call to
-*tracefs_synth_add_start_filter*() is done, and if _or_ is set, the
-next compare is "or'd" (||), otherwise it is "and'd" (&&). _compare_
-may be one of:
+*tracefs_synth_append_start_filter*() creates a filter or appends to it for the
+starting event. Depending on _type_, it will build a string of tokens for
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
 
 *TRACEFS_COMPARE_EQ* - _field_ == _val_
 
@@ -151,7 +159,7 @@ may be one of:
 
 *TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
 
-*tracefs_synth_add_end_filter*() is the same as *tracefs_synth_add_start_filter* but
+*tracefs_synth_append_end_filter*() is the same as *tracefs_synth_append_start_filter* but
 filters on the ending event.
 
 *tracefs_synth_create*() creates the synthetic event in the system in the system
@@ -249,20 +257,28 @@ static void make_event(void)
 					TRACEFS_SYNTH_DELTA_END, "delta");
 
 	/* Only record if start event "prio" is less than 100 */
-	tracefs_synth_add_start_filter(synth, "prio",
-				       TRACEFS_COMPARE_LT, "100",
-				       false, false);
+	tracefs_synth_append_start_filter(synth, TRACEFS_FILTER_COMPARE,
+					  "prio", TRACEFS_COMPARE_LT, "100");
 
 	/*
 	 * Only record if end event "next_prio" is less than 50
-	 * or the previous task's prio was less than 100.
+	 * or the previous task's prio was not greater than or equal to 100.
+	 *   next_prio < 50 || !(prev_prio >= 100)
+	 */
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_COMPARE,
+					"next_prio", TRACEFS_COMPARE_LT, "50");
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_OR, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_NOT, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_OPEN_PAREN, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_COMPARE,
+					"prev_prio", TRACEFS_COMPARE_GE, "100");
+	/*
+	 * Note, the above only added: "next_prio < 50 || !(prev_prio >= 100"
+	 * That's because, when the synth is executed, the remaining close parenthesis
+	 * will be added. That is, the string will end up being:
+	 * "next_prio < 50 || !(prev_prio >= 100)" when one of tracefs_sync_create()
+	 * or tracefs_sync_show() is run.
 	 */
-	tracefs_synth_add_end_filter(synth, "next_prio",
-				       TRACEFS_COMPARE_LT, "50",
-				       false, false);
-	tracefs_synth_add_end_filter(synth, "prev_prio",
-				       TRACEFS_COMPARE_LT, "100",
-				       false, true);
 }
 
 /* Display how to create the synthetic event */
diff --git a/include/tracefs.h b/include/tracefs.h
index 03a16bbffdc7..386ad2c1678f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -324,6 +324,15 @@ enum tracefs_synth_compare {
 	TRACEFS_COMPARE_AND,
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
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
@@ -351,16 +360,16 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 				const char *end_field,
 				const char *name);
-int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
-				   const char *field,
-				   enum tracefs_synth_compare compare,
-				   const char *val,
-				   bool neg, bool or);
-int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
-				 const char *field,
-				 enum tracefs_synth_compare compare,
-				 const char *val,
-				 bool neg, bool or);
+int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
+				      enum tracefs_filter type,
+				      const char *field,
+				      enum tracefs_synth_compare compare,
+				      const char *val);
+int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
+				    enum tracefs_filter type,
+				    const char *field,
+				    enum tracefs_synth_compare compare,
+				    const char *val);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_instance *instance,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 11355e648692..d518ae77fe72 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -545,6 +545,8 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
  * @end_names: The fields in the end event to record
  * @start_filters: The fields in the end event to record
  * @end_filters: The fields in the end event to record
+ * @start_parens: Current parenthesis level for start event
+ * @end_parens: Current parenthesis level for end event
  */
 struct tracefs_synth {
 	struct tep_handle	*tep;
@@ -559,7 +561,10 @@ struct tracefs_synth {
 	char			**end_vars;
 	char			*start_filter;
 	char			*end_filter;
-
+	unsigned int		start_parens;
+	unsigned int		start_state;
+	unsigned int		end_parens;
+	unsigned int		end_state;
 	int			arg_cnt;
 };
 
@@ -1163,152 +1168,214 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	return ret;
 }
 
-static int add_synth_filter(char **filter, const char *field,
-			    enum tracefs_synth_compare compare,
-			    const char *val, bool is_string,
-			    bool neg, bool or)
-{
-	const char *minus = "";
-	const char *op;
-	char *str = NULL;
-	int ret;
-
-	switch (compare) {
-	case TRACEFS_COMPARE_EQ:
-		op = "==";
-		break;
+enum {
+	S_START,
+	S_COMPARE,
+	S_NOT,
+	S_CONJUNCTION,
+	S_OPEN_PAREN,
+	S_CLOSE_PAREN,
+};
 
-	case TRACEFS_COMPARE_NE:
-		op = "!=";
-		break;
+static int append_synth_filter(char **filter, unsigned int *state,
+			       unsigned int *open_parens,
+			       struct tep_event *event,
+			       enum tracefs_filter type,
+			       const char *field_name,
+			       enum tracefs_synth_compare compare,
+			       const char *val)
+{
+	const struct tep_format_field *field;
+	bool is_string;
+	char *conj = "||";
+	char *tmp;
 
-	case TRACEFS_COMPARE_GT:
-		op = ">";
-		if (is_string)
+	switch (type) {
+	case TRACEFS_FILTER_COMPARE:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_CONJUNCTION:
+		case S_NOT:
+			break;
+		default:
 			goto inval;
+		}
 		break;
 
-	case TRACEFS_COMPARE_GE:
-		op = ">=";
-		if (is_string)
+	case TRACEFS_FILTER_AND:
+		conj = "&&";
+		/* Fall through */
+	case TRACEFS_FILTER_OR:
+		switch (*state) {
+		case S_COMPARE:
+		case S_CLOSE_PAREN:
+			break;
+		default:
 			goto inval;
-		break;
+		}
+		/* Don't lose old filter on failure */
+		tmp = strdup(*filter);
+		if (!tmp)
+			return -1;
+		tmp = append_string(tmp, NULL, conj);
+		if (!tmp)
+			return -1;
+		free(*filter);
+		*filter = tmp;
+		*state = S_CONJUNCTION;
+		return 0;
 
-	case TRACEFS_COMPARE_LT:
-		op = "<";
-		if (is_string)
+	case TRACEFS_FILTER_NOT:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_CONJUNCTION:
+		case S_NOT:
+			break;
+		default:
 			goto inval;
-		break;
+		}
+		if (*filter) {
+			tmp = strdup(*filter);
+			tmp = append_string(tmp, NULL, "!");
+		} else {
+			tmp = strdup("!");
+		}
+		if (!tmp)
+			return -1;
+		free(*filter);
+		*filter = tmp;
+		*state = S_NOT;
+		return 0;
 
-	case TRACEFS_COMPARE_LE:
-		op = "<=";
-		if (is_string)
+	case TRACEFS_FILTER_OPEN_PAREN:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_NOT:
+		case S_CONJUNCTION:
+			break;
+		default:
 			goto inval;
-		break;
+		}
+		if (*filter) {
+			tmp = strdup(*filter);
+			tmp = append_string(tmp, NULL, "(");
+		} else {
+			tmp = strdup("(");
+		}
+		if (!tmp)
+			return -1;
+		free(*filter);
+		*filter = tmp;
+		*state = S_OPEN_PAREN;
+		(*open_parens)++;
+		return 0;
 
-	case TRACEFS_COMPARE_RE:
-		op = "~";
-		if (!is_string)
+	case TRACEFS_FILTER_CLOSE_PAREN:
+		switch (*state) {
+		case S_CLOSE_PAREN:
+		case S_COMPARE:
+			break;
+		default:
 			goto inval;
-		break;
-
-	case TRACEFS_COMPARE_AND:
-		op = "&";
-		if (is_string)
+		}
+		if (!*open_parens)
 			goto inval;
-		break;
-	}
 
-	if (neg)
-		minus = "-";
+		tmp = strdup(*filter);
+		if (!tmp)
+			return -1;
+		tmp = append_string(tmp, NULL, ")");
+		if (!tmp)
+			return -1;
+		free(*filter);
+		*filter = tmp;
+		*state = S_CLOSE_PAREN;
+		(*open_parens)--;
+		return 0;
+	}
 
-	if (is_string && val[0] != '"')
-		ret = asprintf(&str, "%s(%s %s \"%s\")",
-			       minus, field, op, val);
-	else
-		ret = asprintf(&str, "%s(%s %s %s)",
-			       minus, field, op, val);
+	if (!field_name || !val)
+		goto inval;
 
-	if (ret < 0)
+	if (!verify_event_fields(event, NULL, field_name, NULL, &field))
 		return -1;
 
-	if (*filter) {
-		char *new;
-		char *conjunction = or ? "||" : "&&";
+	is_string = field->flags & TEP_FIELD_IS_STRING;
 
-		ret = asprintf(&new, "%s %s %s", *filter,
-			       conjunction, str);
-		free(str);
-		if (ret < 0)
+	if (!is_string && (field->flags & TEP_FIELD_IS_ARRAY))
+		goto inval;
+
+	if (*filter) {
+		tmp = strdup(*filter);
+		if (!tmp)
 			return -1;
-		free(*filter);
-		*filter = new;
+		tmp = append_string(tmp, NULL, field_name);
 	} else {
-		*filter = str;
+		tmp = strdup(field_name);
 	}
 
-	return 0;
-inval:
-	errno = -EINVAL;
-	return -1;
-}
+	switch (compare) {
+	case TRACEFS_COMPARE_EQ: tmp = append_string(tmp, NULL, " == "); break;
+	case TRACEFS_COMPARE_NE: tmp = append_string(tmp, NULL, " != "); break;
+	case TRACEFS_COMPARE_RE:
+		if (!is_string)
+			goto inval;
+		tmp = append_string(tmp, NULL, "~");
+		break;
+	default:
+		if (is_string)
+			goto inval;
+	}
 
-int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
-				   const char *field,
-				   enum tracefs_synth_compare compare,
-				   const char *val,
-				   bool neg, bool or)
-{
-	const struct tep_format_field *start_field;
-	bool is_string;
+	switch (compare) {
+	case TRACEFS_COMPARE_GT: tmp = append_string(tmp, NULL, " > "); break;
+	case TRACEFS_COMPARE_GE: tmp = append_string(tmp, NULL, " >= "); break;
+	case TRACEFS_COMPARE_LT: tmp = append_string(tmp, NULL, " < "); break;
+	case TRACEFS_COMPARE_LE: tmp = append_string(tmp, NULL, " <= "); break;
+	case TRACEFS_COMPARE_AND: tmp = append_string(tmp, NULL, " & "); break;
+	default: break;
+	}
 
-	if (!field || !val)
-		goto inval;
+	tmp = append_string(tmp, NULL, val);
 
-	if (!verify_event_fields(synth->start_event, NULL,
-				 field, NULL, &start_field))
+	if (!tmp)
 		return -1;
 
-	is_string = start_field->flags & TEP_FIELD_IS_STRING;
+	free(*filter);
+	*filter = tmp;
+	*state = S_COMPARE;
 
-	if (!is_string && (start_field->flags & TEP_FIELD_IS_ARRAY))
-		goto inval;
-
-	return add_synth_filter(&synth->start_filter,
-				field, compare, val, is_string,
-				neg, or);
+	return 0;
 inval:
-	errno = -EINVAL;
+	errno = EINVAL;
 	return -1;
 }
 
-int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
-				 const char *field,
-				 enum tracefs_synth_compare compare,
-				 const char *val,
-				 bool neg, bool or)
+int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
+				      enum tracefs_filter type,
+				      const char *field,
+				      enum tracefs_synth_compare compare,
+				      const char *val)
 {
-	const struct tep_format_field *end_field;
-	bool is_string;
-
-	if (!field || !val)
-		goto inval;
-
-	if (!verify_event_fields(synth->end_event, NULL,
-				 field, NULL, &end_field))
-		return -1;
-
-	is_string = end_field->flags & TEP_FIELD_IS_STRING;
-
-	if (!is_string && (end_field->flags & TEP_FIELD_IS_ARRAY))
-		goto inval;
+	return append_synth_filter(&synth->start_filter, &synth->start_state,
+				   &synth->start_parens,
+				   synth->start_event,
+				   type, field, compare, val);
+}
 
-	return add_synth_filter(&synth->end_filter,
-				field, compare, val, is_string,
-				neg, or);
-inval:
-	errno = -EINVAL;
-	return -1;
+int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
+				    enum tracefs_filter type,
+				    const char *field,
+				    enum tracefs_synth_compare compare,
+				    const char *val)
+{
+	return append_synth_filter(&synth->end_filter, &synth->end_state,
+				   &synth->end_parens,
+				   synth->end_event,
+				   type, field, compare, val);
 }
 
 static char *create_synthetic_event(struct tracefs_synth *synth)
@@ -1414,6 +1481,41 @@ static char *create_end_hist(struct tracefs_synth *synth)
 	return append_string(end_hist, NULL, ")");
 }
 
+static char *append_filter(char *hist, char *filter, unsigned int parens)
+{
+	int i;
+
+	if (!filter)
+		return hist;
+
+	hist = append_string(hist, NULL, " if ");
+	hist = append_string(hist, NULL, filter);
+	for (i = 0; i < parens; i++)
+		hist = append_string(hist, NULL, ")");
+	return hist;
+}
+
+static int test_state(int state)
+{
+	switch (state) {
+	case S_START:
+	case S_CLOSE_PAREN:
+	case S_COMPARE:
+		return 0;
+	}
+
+	errno = EBADE;
+	return -1;
+}
+
+static int verify_state(struct tracefs_synth *synth)
+{
+	if (test_state(synth->start_state) < 0 ||
+	    test_state(synth->end_state) < 0)
+		return -1;
+	return 0;
+}
+
 /**
  * tracefs_synth_create - creates the synthetic event on the system
  * @instance: The instance to modify the start and end events
@@ -1441,6 +1543,9 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 		return -1;
 	}
 
+	if (verify_state(synth) < 0)
+		return -1;
+
 	synthetic_event = create_synthetic_event(synth);
 	if (!synthetic_event)
 		return -1;
@@ -1451,18 +1556,14 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 		goto free_synthetic;
 
 	start_hist = create_hist(synth->start_keys, synth->start_vars);
-	if (synth->start_filter) {
-		start_hist = append_string(start_hist, NULL, " if ");
-		start_hist = append_string(start_hist, NULL, synth->start_filter);
-	}
+	start_hist = append_filter(start_hist, synth->start_filter,
+				   synth->start_parens);
 	if (!start_hist)
 		goto remove_synthetic;
 
 	end_hist = create_end_hist(synth);
-	if (synth->end_filter) {
-		end_hist = append_string(end_hist, NULL, " if ");
-		end_hist = append_string(end_hist, NULL, synth->end_filter);
-	}
+	end_hist = append_filter(end_hist, synth->end_filter,
+				   synth->end_parens);
 	if (!end_hist)
 		goto remove_synthetic;
 
@@ -1528,20 +1629,16 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	tracefs_event_disable(instance, "synthetic", synth->name);
 
 	hist = create_end_hist(synth);
-	if (synth->end_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->end_filter);
-	}
+	hist = append_filter(hist, synth->end_filter,
+			     synth->end_parens);
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
+			     synth->start_parens);
 	if (!hist)
 		return -1;
 
@@ -1599,10 +1696,8 @@ int tracefs_synth_show(struct trace_seq *seq,
 	path = tracefs_instance_get_dir(instance);
 
 	hist = create_hist(synth->start_keys, synth->start_vars);
-	if (synth->start_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->start_filter);
-	}
+	hist = append_filter(hist, synth->start_filter,
+			     synth->start_parens);
 	if (!hist)
 		goto out_free;
 
@@ -1611,11 +1706,8 @@ int tracefs_synth_show(struct trace_seq *seq,
 			 synth->start_event->name);
 	free(hist);
 	hist = create_end_hist(synth);
-
-	if (synth->end_filter) {
-		hist = append_string(hist, NULL, " if ");
-		hist = append_string(hist, NULL, synth->end_filter);
-	}
+	hist = append_filter(hist, synth->end_filter,
+			     synth->end_parens);
 	if (!hist)
 		goto out_free;
 
-- 
2.30.2

