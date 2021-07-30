Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE2EC43216
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF2060EE6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhG3DD0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhG3DDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A7361040;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PR1-5b; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 5/6] libtracefs: Add filter creating and verify API
Date:   Thu, 29 Jul 2021 23:03:06 -0400
Message-Id: <20210730030307.574270-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the following API:

  tracefs_event_append_filter()
  tracefs_event_verify_filter()

Pull out the filter logic from trace-hist.c and place it into its own
file: tracefs-filter.c, that allows users to use these filters directly
for individual events.

Suggested-by: Yordan Karadzhov <y.karadz@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h |  14 +
 include/tracefs.h       |  13 +-
 src/Makefile            |   1 +
 src/tracefs-filter.c    | 747 ++++++++++++++++++++++++++++++++++++++++
 src/tracefs-hist.c      | 258 +-------------
 5 files changed, 787 insertions(+), 246 deletions(-)
 create mode 100644 src/tracefs-filter.c

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 2324dec9d076..41fbcc0faa95 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -71,4 +71,18 @@ struct tracefs_options_mask *
 enabled_opts_mask(struct tracefs_instance *instance);
 
 char **trace_list_create_empty(void);
+
+char *append_string(char *str, const char *delim, const char *add);
+int trace_test_state(int state);
+bool trace_verify_event_field(struct tep_event *event,
+			      const char *field_name,
+			      const struct tep_format_field **ptr_field);
+int trace_append_filter(char **filter, unsigned int *state,
+			unsigned int *open_parens,
+			struct tep_event *event,
+			enum tracefs_filter type,
+			const char *field_name,
+			enum tracefs_compare compare,
+			 const char *val);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 386ad2c1678f..246647f6496d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -313,7 +313,7 @@ enum tracefs_synth_calc {
 	TRACEFS_SYNTH_ADD,
 };
 
-enum tracefs_synth_compare {
+enum tracefs_compare {
 	TRACEFS_COMPARE_EQ,
 	TRACEFS_COMPARE_NE,
 	TRACEFS_COMPARE_GT,
@@ -333,6 +333,13 @@ enum tracefs_filter {
 	TRACEFS_FILTER_CLOSE_PAREN,
 };
 
+int tracefs_event_append_filter(struct tep_event *event, char **filter,
+				enum tracefs_filter type,
+				const char *field, enum tracefs_compare compare,
+				const char *val);
+int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
+				char **err);
+
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
@@ -363,12 +370,12 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 				      enum tracefs_filter type,
 				      const char *field,
-				      enum tracefs_synth_compare compare,
+				      enum tracefs_compare compare,
 				      const char *val);
 int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    enum tracefs_filter type,
 				    const char *field,
-				    enum tracefs_synth_compare compare,
+				    enum tracefs_compare compare,
 				    const char *val);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
diff --git a/src/Makefile b/src/Makefile
index c7f7c1cc1680..767af49034ee 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,6 +10,7 @@ OBJS += tracefs-tools.o
 OBJS += tracefs-marker.o
 OBJS += tracefs-kprobes.o
 OBJS += tracefs-hist.o
+OBJS += tracefs-filter.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
new file mode 100644
index 000000000000..def8f68cb52a
--- /dev/null
+++ b/src/tracefs-filter.c
@@ -0,0 +1,747 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ * Updates:
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <trace-seq.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+enum {
+	S_START,
+	S_COMPARE,
+	S_NOT,
+	S_CONJUNCTION,
+	S_OPEN_PAREN,
+	S_CLOSE_PAREN,
+};
+
+static const struct tep_format_field common_timestamp = {
+	.type			= "u64",
+	.name			= "common_timestamp",
+	.size			= 8,
+};
+
+static const struct tep_format_field common_timestamp_usecs = {
+	.type			= "u64",
+	.name			= "common_timestamp.usecs",
+	.size			= 8,
+};
+
+/*
+ * This also must be able to accept fields that are OK via the histograms,
+ * such as common_timestamp.
+ */
+static const struct tep_format_field *get_event_field(struct tep_event *event,
+					 const char *field_name)
+{
+	if (!strcmp(field_name, TRACEFS_TIMESTAMP))
+		return &common_timestamp;
+
+	if (!strcmp(field_name, TRACEFS_TIMESTAMP_USECS))
+		return &common_timestamp_usecs;
+
+	return tep_find_any_field(event, field_name);
+}
+
+__hidden bool
+trace_verify_event_field(struct tep_event *event,
+			 const char *field_name,
+			 const struct tep_format_field **ptr_field)
+{
+	const struct tep_format_field *field;
+
+	field = get_event_field(event, field_name);
+	if (!field) {
+		errno = ENODEV;
+		return false;
+	}
+
+	if (ptr_field)
+		*ptr_field = field;
+
+	return true;
+}
+
+__hidden int trace_test_state(int state)
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
+static int append_filter(char **filter, unsigned int *state,
+			 unsigned int *open_parens,
+			 struct tep_event *event,
+			 enum tracefs_filter type,
+			 const char *field_name,
+			 enum tracefs_compare compare,
+			 const char *val)
+{
+	const struct tep_format_field *field;
+	bool is_string;
+	char *conj = "||";
+	char *tmp;
+
+	switch (type) {
+	case TRACEFS_FILTER_COMPARE:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_CONJUNCTION:
+		case S_NOT:
+			break;
+		default:
+			goto inval;
+		}
+		break;
+
+	case TRACEFS_FILTER_AND:
+		conj = "&&";
+		/* Fall through */
+	case TRACEFS_FILTER_OR:
+		switch (*state) {
+		case S_COMPARE:
+		case S_CLOSE_PAREN:
+			break;
+		default:
+			goto inval;
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
+
+	case TRACEFS_FILTER_NOT:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_CONJUNCTION:
+		case S_NOT:
+			break;
+		default:
+			goto inval;
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
+
+	case TRACEFS_FILTER_OPEN_PAREN:
+		switch (*state) {
+		case S_START:
+		case S_OPEN_PAREN:
+		case S_NOT:
+		case S_CONJUNCTION:
+			break;
+		default:
+			goto inval;
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
+
+	case TRACEFS_FILTER_CLOSE_PAREN:
+		switch (*state) {
+		case S_CLOSE_PAREN:
+		case S_COMPARE:
+			break;
+		default:
+			goto inval;
+		}
+		if (!*open_parens)
+			goto inval;
+
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
+
+	if (!field_name || !val)
+		goto inval;
+
+	if (!trace_verify_event_field(event, field_name, &field))
+		return -1;
+
+	is_string = field->flags & TEP_FIELD_IS_STRING;
+
+	if (!is_string && (field->flags & TEP_FIELD_IS_ARRAY))
+		goto inval;
+
+	if (*filter) {
+		tmp = strdup(*filter);
+		if (!tmp)
+			return -1;
+		tmp = append_string(tmp, NULL, field_name);
+	} else {
+		tmp = strdup(field_name);
+	}
+
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
+
+	switch (compare) {
+	case TRACEFS_COMPARE_GT: tmp = append_string(tmp, NULL, " > "); break;
+	case TRACEFS_COMPARE_GE: tmp = append_string(tmp, NULL, " >= "); break;
+	case TRACEFS_COMPARE_LT: tmp = append_string(tmp, NULL, " < "); break;
+	case TRACEFS_COMPARE_LE: tmp = append_string(tmp, NULL, " <= "); break;
+	case TRACEFS_COMPARE_AND: tmp = append_string(tmp, NULL, " & "); break;
+	default: break;
+	}
+
+	tmp = append_string(tmp, NULL, val);
+
+	if (!tmp)
+		return -1;
+
+	free(*filter);
+	*filter = tmp;
+	*state = S_COMPARE;
+
+	return 0;
+inval:
+	errno = EINVAL;
+	return -1;
+}
+
+static int count_parens(char *filter, unsigned int *state)
+{
+	bool backslash = false;
+	int quote = 0;
+	int open = 0;
+	int i;
+
+	if (!filter)
+		return 0;
+
+	for (i = 0; filter[i]; i++) {
+		if (quote) {
+			if (backslash)
+				backslash = false;
+			else if (filter[i] == '\\')
+				backslash = true;
+			else if (quote == filter[i])
+				quote = 0;
+			continue;
+		}
+
+		switch (filter[i]) {
+		case '(':
+			*state = S_OPEN_PAREN;
+			open++;
+			break;
+		case ')':
+			*state = S_CLOSE_PAREN;
+			open--;
+			break;
+		case '\'':
+		case '"':
+			*state = S_COMPARE;
+			quote = filter[i];
+			break;
+		case '!':
+			switch (filter[i+1]) {
+			case '=':
+			case '~':
+				*state = S_COMPARE;
+				i++;
+				break;
+			default:
+				*state = S_NOT;
+			}
+			break;
+		case '&':
+		case '|':
+			if (filter[i] == filter[i+1]) {
+				*state = S_CONJUNCTION;
+				i++;
+				break;
+			}
+			/* Fall through */
+		case '0' ... '9':
+		case 'a' ... 'z':
+		case 'A' ... 'Z':
+		case '_': case '+': case '-': case '*': case '/':
+			*state = S_COMPARE;
+			break;
+		}
+	}
+	return open;
+}
+
+__hidden int trace_append_filter(char **filter, unsigned int *state,
+			 unsigned int *open_parens,
+			 struct tep_event *event,
+			 enum tracefs_filter type,
+			 const char *field_name,
+			 enum tracefs_compare compare,
+			 const char *val)
+{
+	return append_filter(filter, state, open_parens, event, type,
+			     field_name, compare, val);
+}
+
+/**
+ * tracefs_event_append_filter - create or append a filter for an event
+ * @event: tep_event to create / append a filter for
+ * @filter: Pointer to string to append to (pointer to NULL to create)
+ * @type: The type of element to add to the filter
+ * @field: For @type == TRACEFS_FILTER_COMPARE, the field to compare
+ * @compare: For @type == TRACEFS_FILTER_COMPARE, how to compare @field to @val
+ * @val: For @type == TRACEFS_FILTER_COMPARE, what value @field is to be
+ *
+ * This will put together a filter string for the starting event
+ * of @synth. It check to make sure that what is added is correct compared
+ * to the filter that is already built.
+ *
+ * @type can be:
+ *     TRACEFS_FILTER_COMPARE:        See below
+ *     TRACEFS_FILTER_AND:            Append "&&" to the filter
+ *     TRACEFS_FILTER_OR:             Append "||" to the filter
+ *     TRACEFS_FILTER_NOT:            Append "!" to the filter
+ *     TRACEFS_FILTER_OPEN_PAREN:     Append "(" to the filter
+ *     TRACEFS_FILTER_CLOSE_PAREN:    Append ")" to the filter
+ *
+ * For all types except TRACEFS_FILTER_COMPARE, the @field, @compare,
+ * and @val are ignored.
+ *
+ * For @type == TRACEFS_FILTER_COMPARE.
+ *
+ *  @field is the name of the field for the start event to compare.
+ *         If it is not a field for the start event, this return an
+ *         error.
+ *
+ *  @compare can be one of:
+ *     TRACEFS_COMPARE_EQ:       Test @field == @val
+ *     TRACEFS_COMPARE_NE:       Test @field != @val
+ *     TRACEFS_COMPARE_GT:       Test @field > @val
+ *     TRACEFS_COMPARE_GE:       Test @field >= @val
+ *     TRACEFS_COMPARE_LT:       Test @field < @val
+ *     TRACEFS_COMPARE_LE:       Test @field <= @val
+ *     TRACEFS_COMPARE_RE:       Test @field ~ @val
+ *     TRACEFS_COMPARE_AND:      Test @field & @val
+ *
+ * If the @field is of type string, and @compare is not
+ *   TRACEFS_COMPARE_EQ, TRACEFS_COMPARE_NE or TRACEFS_COMPARE_RE,
+ *   then this will return an error.
+ *
+ * Various other checks are made, for instance, if more CLOSE_PARENs
+ * are added than existing OPEN_PARENs. Or if AND is added after an
+ * OPEN_PAREN or another AND or an OR or a NOT.
+ *
+ * Returns 0 on success and -1 on failure.
+ */
+int tracefs_event_append_filter(struct tep_event *event, char **filter,
+				enum tracefs_filter type,
+				const char *field, enum tracefs_compare compare,
+				const char *val)
+{
+	unsigned int open_parens;
+	unsigned int state = 0;
+	char *str = NULL;
+	int open;
+	int ret;
+
+	if (!filter) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	open = count_parens(*filter, &state);
+	if (open < 0) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (*filter) {
+		/* append_filter() will free filter on error */
+		str = strdup(*filter);
+		if (!str)
+			return -1;
+	}
+	open_parens = open;
+
+	ret = append_filter(&str, &state, &open_parens,
+			    event, type, field, compare, val);
+	if (!ret) {
+		free(*filter);
+		*filter = str;
+	}
+	return 0;
+}
+
+static int error_msg(char **err, char *str,
+		     const char *filter, int i, const char *msg)
+{
+	char ws[i+2];
+	char *errmsg;
+
+	free(str);
+
+	/* msg is NULL for parsing append_filter failing */
+	if (!msg) {
+		switch(errno) {
+		case ENODEV:
+			msg = "field not valid";
+			break;
+		default:
+			msg = "Invalid filter";
+
+		}
+	} else
+		errno = EINVAL;
+
+	if (!err)
+		return -1;
+
+	if (!filter) {
+		*err = strdup(msg);
+		return -1;
+	}
+
+	memset(ws, ' ', i);
+	ws[i] = '^';
+	ws[i+1] = '\0';
+
+	errmsg = strdup(filter);
+	errmsg = append_string(errmsg, "\n", ws);
+	errmsg = append_string(errmsg, "\n", msg);
+	errmsg = append_string(errmsg, NULL, "\n");
+
+	*err = errmsg;
+	return -1;
+}
+
+static int get_field_end(const char *filter, int i, int *end)
+{
+	int start_i = i;
+
+	for (; filter[i]; i++) {
+		switch(filter[i]) {
+		case '0' ... '9':
+			if (i == start_i)
+				return 0;
+			/* Fall through */
+		case 'a' ... 'z':
+		case 'A' ... 'Z':
+		case '_':
+			continue;
+		default:
+			*end = i;
+			return i - start_i;
+		}
+	}
+	*end = i;
+	return i - start_i;
+}
+
+static int get_compare(const char *filter, int i, enum tracefs_compare *cmp)
+{
+	int start_i = i;
+
+	for (; filter[i]; i++) {
+		if (!isspace(filter[i]))
+			break;
+	}
+
+	switch(filter[i]) {
+	case '=':
+		if (filter[i+1] != '=')
+			goto err;
+		*cmp = TRACEFS_COMPARE_EQ;
+		i++;
+		break;
+	case '!':
+		if (filter[i+1] == '=') {
+			*cmp = TRACEFS_COMPARE_NE;
+			i++;
+			break;
+		}
+		if (filter[i+1] == '~') {
+			/* todo! */
+		}
+		goto err;
+	case '>':
+		if (filter[i+1] == '=') {
+			*cmp = TRACEFS_COMPARE_GE;
+			i++;
+			break;
+		}
+		*cmp = TRACEFS_COMPARE_GT;
+		break;
+	case '<':
+		if (filter[i+1] == '=') {
+			*cmp = TRACEFS_COMPARE_LE;
+			i++;
+			break;
+		}
+		*cmp = TRACEFS_COMPARE_LT;
+		break;
+	case '~':
+		*cmp = TRACEFS_COMPARE_RE;
+		break;
+	case '&':
+		*cmp = TRACEFS_COMPARE_AND;
+		break;
+	default:
+		goto err;
+	}
+	i++;
+
+	for (; filter[i]; i++) {
+		if (!isspace(filter[i]))
+			break;
+	}
+	return i - start_i;
+ err:
+	return start_i - i; /* negative or zero */
+}
+
+static int get_val_end(const char *filter, int i, int *end)
+{
+	bool backslash = false;
+	int start_i = i;
+	int quote;
+
+	switch (filter[i]) {
+	case '0':
+		i++;
+		if (tolower(filter[i+1]) != 'x' &&
+		    !isdigit(filter[i+1]))
+			break;
+		/* fall through */
+	case '1' ... '9':
+		switch (tolower(filter[i])) {
+		case 'x':
+			for (i++; filter[i]; i++) {
+				if (!isxdigit(filter[i]))
+					break;
+			}
+			break;
+		case '0':
+			for (i++; filter[i]; i++) {
+				if (filter[i] < '0' ||
+				    filter[i] > '7')
+					break;
+			}
+			break;
+		default:
+			for (i++; filter[i]; i++) {
+				if (!isdigit(filter[i]))
+					break;
+			}
+			break;
+		}
+		break;
+	case '"':
+	case '\'':
+		quote = filter[i];
+		for (i++; filter[i]; i++) {
+			if (backslash) {
+				backslash = false;
+				continue;
+			}
+			switch (filter[i]) {
+			case '\\':
+				backslash = true;
+				continue;
+			case '"':
+			case '\'':
+				if (filter[i] == quote)
+					break;
+				continue;
+			default:
+				continue;
+			}
+			break;
+		}
+		if (filter[i])
+			i++;
+		break;
+	default:
+		break;
+	}
+
+	*end = i;
+	return i - start_i;
+}
+
+/**
+ * tracefs_event_verify_filter - verify a given filter works for an event
+ * @event: The event to test the given filter for
+ * @filter: The filter to test
+ * @err: Error message for syntax errors (NULL to ignore)
+ *
+ * Parse the @filter to verify that it is valid for the given @event.
+ *
+ * Returns 0 on succes and -1 on error, and except for memory allocation
+ * errors, @err will be allocated with an error message. It must
+ * be freed with free().
+ */
+int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
+				char **err)
+{
+	enum tracefs_filter filter_type;
+	enum tracefs_compare compare;
+	char *str = NULL;
+	char buf[(filter ? strlen(filter) : 0) + 1];
+	char *field;
+	char *val;
+	unsigned int state = 0;
+	unsigned int open = 0;
+	int len;
+	int end;
+	int n;
+	int i;
+
+	if (!filter)
+		return error_msg(err, str, NULL, 0, "No filter given");
+
+	len = strlen(filter);
+
+	for (i = 0; i < len; i++) {
+		field = NULL;
+		val = NULL;
+		compare = 0;
+
+		switch (filter[i]) {
+		case '(':
+			filter_type = TRACEFS_FILTER_OPEN_PAREN;
+			break;
+		case ')':
+			filter_type = TRACEFS_FILTER_CLOSE_PAREN;
+			break;
+		case '!':
+			filter_type = TRACEFS_FILTER_NOT;
+			break;
+		case '&':
+		case '|':
+
+			if (filter[i] == filter[i+1]) {
+				i++;
+				if (filter[i] == '&')
+					filter_type = TRACEFS_FILTER_AND;
+				else
+					filter_type = TRACEFS_FILTER_OR;
+				break;
+			}
+			if (filter[i] == '|')
+				return error_msg(err, str, filter, i,
+						 "Invalid op");
+
+			return error_msg(err, str, filter, i,
+					 "Invalid location for '&'");
+		default:
+			if (isspace(filter[i]))
+				continue;
+
+			field = buf;
+
+			n = get_field_end(filter, i, &end);
+			if (!n)
+				return error_msg(err, str, filter, i,
+						 "Invalid field name");
+
+			strncpy(field, filter+i, n);
+
+			i += n;
+			field[n++] = '\0';
+
+			val = field + n;
+
+			n = get_compare(filter, i, &compare);
+			if (n <= 0)
+				return error_msg(err, str, filter, i - n,
+						 "Invalid compare");
+
+			i += n;
+			get_val_end(filter, i, &end);
+			n = end - i;
+			if (!n)
+				return error_msg(err, str, filter, i,
+						 "Invalid value");
+			strncpy(val, filter + i, n);
+			val[n] = '\0';
+			i += n - 1;
+
+			filter_type = TRACEFS_FILTER_COMPARE;
+			break;
+		}
+		n = append_filter(&str, &state, &open,
+				    event, filter_type, field, compare, val);
+
+		if (n < 0)
+			return error_msg(err, str, filter, i, NULL);
+	}
+
+	if (open)
+		return error_msg(err, str, filter, i,
+				 "Not enough closed parenthesis");
+	switch (state) {
+	case S_COMPARE:
+	case S_CLOSE_PAREN:
+		break;
+	default:
+		return error_msg(err, str, filter, i,
+				 "Unfinished filter");
+	}
+
+	free(str);
+	return 0;
+}
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8a0d43fafb7e..7292f89457c9 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -568,18 +568,6 @@ struct tracefs_synth {
 	int			arg_cnt;
 };
 
-static const struct tep_format_field common_timestamp = {
-	.type			= "u64",
-	.name			= "common_timestamp",
-	.size			= 8,
-};
-
-static const struct tep_format_field common_timestamp_usecs = {
-	.type			= "u64",
-	.name			= "common_timestamp.usecs",
-	.size			= 8,
-};
-
 /**
  * tracefs_synth_free - free the resources alloced to a synth
  * @synth: The tracefs_synth descriptor
@@ -609,18 +597,6 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 	free(synth);
 }
 
-static const struct tep_format_field *get_event_field(struct tep_event *event,
-					 const char *field_name)
-{
-	if (!strcmp(field_name, TRACEFS_TIMESTAMP))
-		return &common_timestamp;
-
-	if (!strcmp(field_name, TRACEFS_TIMESTAMP_USECS))
-		return &common_timestamp_usecs;
-
-	return tep_find_any_field(event, field_name);
-}
-
 static bool verify_event_fields(struct tep_event *start_event,
 				struct tep_event *end_event,
 				const char *start_field_name,
@@ -630,14 +606,14 @@ static bool verify_event_fields(struct tep_event *start_event,
 	const struct tep_format_field *start_field;
 	const struct tep_format_field *end_field;
 
-	start_field = get_event_field(start_event, start_field_name);
-	if (!start_field)
-		goto nodev;
+	if (!trace_verify_event_field(start_event, start_field_name,
+				      &start_field))
+		return false;
 
 	if (end_event) {
-		end_field = get_event_field(end_event, end_field_name);
-		if (!start_field)
-			goto nodev;
+		if (!trace_verify_event_field(end_event, end_field_name,
+					      &end_field))
+			return false;
 
 		if (start_field->flags != end_field->flags ||
 		    start_field->size != end_field->size) {
@@ -650,12 +626,9 @@ static bool verify_event_fields(struct tep_event *start_event,
 		*ptr_start_field = start_field;
 
 	return true;
- nodev:
-	errno = ENODEV;
-	return false;
 }
 
-static char *append_string(char *str, const char *space, const char *add)
+__hidden char *append_string(char *str, const char *space, const char *add)
 {
 	char *new;
 	int len;
@@ -1110,8 +1083,7 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 	if (!name)
 		name = start_field;
 
-	if (!verify_event_fields(synth->start_event, NULL,
-				 start_field, NULL, &field))
+	if (!trace_verify_event_field(synth->start_event, start_field, &field))
 		return -1;
 
 	start_arg = new_arg(synth);
@@ -1163,8 +1135,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	if (!name)
 		name = end_field;
 
-	if (!verify_event_fields(synth->end_event, NULL,
-				 end_field, NULL, &field))
+	if (!trace_verify_event_field(synth->end_event, end_field, &field))
 		return -1;
 
 	ret = add_var(&synth->end_vars, name, end_field, false);
@@ -1177,192 +1148,6 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	return ret;
 }
 
-enum {
-	S_START,
-	S_COMPARE,
-	S_NOT,
-	S_CONJUNCTION,
-	S_OPEN_PAREN,
-	S_CLOSE_PAREN,
-};
-
-static int append_synth_filter(char **filter, unsigned int *state,
-			       unsigned int *open_parens,
-			       struct tep_event *event,
-			       enum tracefs_filter type,
-			       const char *field_name,
-			       enum tracefs_synth_compare compare,
-			       const char *val)
-{
-	const struct tep_format_field *field;
-	bool is_string;
-	char *conj = "||";
-	char *tmp;
-
-	switch (type) {
-	case TRACEFS_FILTER_COMPARE:
-		switch (*state) {
-		case S_START:
-		case S_OPEN_PAREN:
-		case S_CONJUNCTION:
-		case S_NOT:
-			break;
-		default:
-			goto inval;
-		}
-		break;
-
-	case TRACEFS_FILTER_AND:
-		conj = "&&";
-		/* Fall through */
-	case TRACEFS_FILTER_OR:
-		switch (*state) {
-		case S_COMPARE:
-		case S_CLOSE_PAREN:
-			break;
-		default:
-			goto inval;
-		}
-		/* Don't lose old filter on failure */
-		tmp = strdup(*filter);
-		if (!tmp)
-			return -1;
-		tmp = append_string(tmp, NULL, conj);
-		if (!tmp)
-			return -1;
-		free(*filter);
-		*filter = tmp;
-		*state = S_CONJUNCTION;
-		return 0;
-
-	case TRACEFS_FILTER_NOT:
-		switch (*state) {
-		case S_START:
-		case S_OPEN_PAREN:
-		case S_CONJUNCTION:
-		case S_NOT:
-			break;
-		default:
-			goto inval;
-		}
-		if (*filter) {
-			tmp = strdup(*filter);
-			tmp = append_string(tmp, NULL, "!");
-		} else {
-			tmp = strdup("!");
-		}
-		if (!tmp)
-			return -1;
-		free(*filter);
-		*filter = tmp;
-		*state = S_NOT;
-		return 0;
-
-	case TRACEFS_FILTER_OPEN_PAREN:
-		switch (*state) {
-		case S_START:
-		case S_OPEN_PAREN:
-		case S_NOT:
-		case S_CONJUNCTION:
-			break;
-		default:
-			goto inval;
-		}
-		if (*filter) {
-			tmp = strdup(*filter);
-			tmp = append_string(tmp, NULL, "(");
-		} else {
-			tmp = strdup("(");
-		}
-		if (!tmp)
-			return -1;
-		free(*filter);
-		*filter = tmp;
-		*state = S_OPEN_PAREN;
-		(*open_parens)++;
-		return 0;
-
-	case TRACEFS_FILTER_CLOSE_PAREN:
-		switch (*state) {
-		case S_CLOSE_PAREN:
-		case S_COMPARE:
-			break;
-		default:
-			goto inval;
-		}
-		if (!*open_parens)
-			goto inval;
-
-		tmp = strdup(*filter);
-		if (!tmp)
-			return -1;
-		tmp = append_string(tmp, NULL, ")");
-		if (!tmp)
-			return -1;
-		free(*filter);
-		*filter = tmp;
-		*state = S_CLOSE_PAREN;
-		(*open_parens)--;
-		return 0;
-	}
-
-	if (!field_name || !val)
-		goto inval;
-
-	if (!verify_event_fields(event, NULL, field_name, NULL, &field))
-		return -1;
-
-	is_string = field->flags & TEP_FIELD_IS_STRING;
-
-	if (!is_string && (field->flags & TEP_FIELD_IS_ARRAY))
-		goto inval;
-
-	if (*filter) {
-		tmp = strdup(*filter);
-		if (!tmp)
-			return -1;
-		tmp = append_string(tmp, NULL, field_name);
-	} else {
-		tmp = strdup(field_name);
-	}
-
-	switch (compare) {
-	case TRACEFS_COMPARE_EQ: tmp = append_string(tmp, NULL, " == "); break;
-	case TRACEFS_COMPARE_NE: tmp = append_string(tmp, NULL, " != "); break;
-	case TRACEFS_COMPARE_RE:
-		if (!is_string)
-			goto inval;
-		tmp = append_string(tmp, NULL, "~");
-		break;
-	default:
-		if (is_string)
-			goto inval;
-	}
-
-	switch (compare) {
-	case TRACEFS_COMPARE_GT: tmp = append_string(tmp, NULL, " > "); break;
-	case TRACEFS_COMPARE_GE: tmp = append_string(tmp, NULL, " >= "); break;
-	case TRACEFS_COMPARE_LT: tmp = append_string(tmp, NULL, " < "); break;
-	case TRACEFS_COMPARE_LE: tmp = append_string(tmp, NULL, " <= "); break;
-	case TRACEFS_COMPARE_AND: tmp = append_string(tmp, NULL, " & "); break;
-	default: break;
-	}
-
-	tmp = append_string(tmp, NULL, val);
-
-	if (!tmp)
-		return -1;
-
-	free(*filter);
-	*filter = tmp;
-	*state = S_COMPARE;
-
-	return 0;
-inval:
-	errno = EINVAL;
-	return -1;
-}
-
 /**
  * tracefs_synth_append_start_filter - create or append a filter
  * @synth: The tracefs_synth descriptor
@@ -1415,10 +1200,10 @@ inval:
 int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 				      enum tracefs_filter type,
 				      const char *field,
-				      enum tracefs_synth_compare compare,
+				      enum tracefs_compare compare,
 				      const char *val)
 {
-	return append_synth_filter(&synth->start_filter, &synth->start_state,
+	return trace_append_filter(&synth->start_filter, &synth->start_state,
 				   &synth->start_parens,
 				   synth->start_event,
 				   type, field, compare, val);
@@ -1438,10 +1223,10 @@ int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    enum tracefs_filter type,
 				    const char *field,
-				    enum tracefs_synth_compare compare,
+				    enum tracefs_compare compare,
 				    const char *val)
 {
-	return append_synth_filter(&synth->end_filter, &synth->end_state,
+	return trace_append_filter(&synth->end_filter, &synth->end_state,
 				   &synth->end_parens,
 				   synth->end_event,
 				   type, field, compare, val);
@@ -1564,23 +1349,10 @@ static char *append_filter(char *hist, char *filter, unsigned int parens)
 	return hist;
 }
 
-static int test_state(int state)
-{
-	switch (state) {
-	case S_START:
-	case S_CLOSE_PAREN:
-	case S_COMPARE:
-		return 0;
-	}
-
-	errno = EBADE;
-	return -1;
-}
-
 static int verify_state(struct tracefs_synth *synth)
 {
-	if (test_state(synth->start_state) < 0 ||
-	    test_state(synth->end_state) < 0)
+	if (trace_test_state(synth->start_state) < 0 ||
+	    trace_test_state(synth->end_state) < 0)
 		return -1;
 	return 0;
 }
-- 
2.30.2

