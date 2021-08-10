Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC18C43216
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C635610A8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhHJUsw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232424AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4211C6056B;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hA5-2b; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/9] tracefs: Add API tracefs_hist_data_parse()
Date:   Tue, 10 Aug 2021 16:48:10 -0400
Message-Id: <20210810204818.880714-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a function tracefs_hist_data_parse() that will take the content of a
trace event's hist data file, and parse it into a "tracefs_hist_data"
descriptor that can be used to read the raw data from the file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h       |   7 +
 src/Makefile            |   7 +
 src/tracefs-hist-data.c | 861 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 875 insertions(+)
 create mode 100644 src/tracefs-hist-data.c

diff --git a/include/tracefs.h b/include/tracefs.h
index 17020de0108a..6bd40d72cb25 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -413,6 +413,13 @@ static inline int tracefs_hist_destroy(struct tracefs_instance *instance,
 	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_DESTROY);
 }
 
+struct tracefs_hist_data;
+
+struct tracefs_hist_data *tracefs_hist_data_parse(const char *buffer,
+						  const char **next_buffer,
+						  char **err);
+void tracefs_hist_data_free(struct tracefs_hist_data *hdata);
+
 struct tracefs_synth;
 
 /*
diff --git a/src/Makefile b/src/Makefile
index 9248efc5c7fd..1ab181416b82 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,6 +17,10 @@ OBJS += sqlhist-lex.o
 OBJS += sqlhist.tab.o
 OBJS += tracefs-sqlhist.o
 
+# Order matters for the the two below
+OBJS += hist-lex.o
+OBJS += tracefs-hist-data.o
+
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
@@ -45,6 +49,9 @@ sqlhist.tab.c: sqlhist.y sqlhist.tab.h
 sqlhist-lex.c: sqlhist.l sqlhist.tab.c
 	flex -o $@ $<
 
+hist-lex.c: hist.l
+	flex -P hist_ -o $@ $<
+
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
new file mode 100644
index 000000000000..497ab9ce97b4
--- /dev/null
+++ b/src/tracefs-hist-data.c
@@ -0,0 +1,861 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ * Updates:
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define HIST_FILE "hist"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <ctype.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+#include "hist.h"
+
+#define offset_of(type, field)	((unsigned long )(&((type *)0)->field))
+#define container_of(p, type, field) ((type *)((void *)(p) - offset_of(type, field)));
+
+extern int hist_lex_init_extra(void *data, void* ptr_yy_globals);
+extern int hist_lex_destroy(void *scanner);
+
+int hist_yyinput(void *extra, char *buf, int max)
+{
+	struct hist_data *data = extra;
+
+	if (!data || !data->buffer)
+		return -1;
+
+	if (data->buffer_idx + max > data->buffer_size)
+		max = data->buffer_size - data->buffer_idx;
+
+	if (max)
+		memcpy(buf, data->buffer + data->buffer_idx, max);
+
+	data->buffer_idx += max;
+
+	return max;
+}
+
+extern int hist_yylex(void *data, void *scanner);
+
+static char *name_token(enum yytokentype type)
+{
+	switch (type) {
+	case YYEMPTY:
+		return "YYEMPTY";
+	case YYEOF:
+		return "YYEOF";
+	case YYerror:
+		return "YYerror";
+	case YYUNDEF:
+		return "YYUNDEF";
+	case NUMBER:
+		return "NUMBER";
+	case HEX:
+		return "HEX";
+	case NEWLINE:
+		return "NEWLINE";
+	case STRING:
+		return "STRING";
+	case KEY_TYPE:
+		return "KEY_TYPE";
+	case KEY_VAL:
+		return "KEY_VAL";
+	case START_RANGE:
+		return "START_RANGE";
+	case RANGE_LINEAR:
+		return "RANGE_LINEAR";
+	case RANGE_EXPONENT:
+		return "RANGE_EXPONENT";
+	case RAW_VAL:
+		return "RAW_VAL";
+	case STACKTRACE:
+		return "STACKTRACE";
+	case STACK_ITEM:
+		return "STACK_ITEM";
+	case STACK_MOD:
+		return "STACK_MOD";
+	case VALUE:
+		return "VALUE";
+	case TOTALS:
+		return "TOTALS";
+	case HITS:
+		return "HITS";
+	case ENTRIES:
+		return "ENTRIES";
+	case DROPPED:
+		return "DROPPED";
+	case COMMENT:
+		return "COMMENT";
+	case COLON:
+		return "COLON";
+	case COMMA:
+		return "COMMA";
+	}
+	return NULL;
+}
+
+enum tracefs_bucket_key_type {
+	TRACEFS_BUCKET_KEY_UNDEF,
+	TRACEFS_BUCKET_KEY_SINGLE,
+	TRACEFS_BUCKET_KEY_RANGE,
+};
+
+struct tracefs_hist_bucket_key_single {
+	long long		val;
+	char			*sym;
+};
+
+struct tracefs_hist_bucket_key_range {
+	long long		start;
+	long long		end;
+};
+
+struct tracefs_hist_bucket_key {
+	struct tracefs_hist_bucket_key	*next;
+	enum tracefs_bucket_key_type	type;
+	union {
+		struct tracefs_hist_bucket_key_single	single;
+		struct tracefs_hist_bucket_key_range	range;
+	};
+};
+
+struct tracefs_hist_bucket_val {
+	struct tracefs_hist_bucket_val		*next;
+	long long				val;
+};
+
+struct tracefs_hist_bucket {
+	struct tracefs_hist_bucket		*next;
+	struct tracefs_hist_bucket_key		*keys;
+	struct tracefs_hist_bucket_key		**next_key;
+	struct tracefs_hist_bucket_val		*vals;
+	struct tracefs_hist_bucket_val		**next_val;
+};
+
+struct tracefs_hist_data {
+	char				**key_names;
+	char				**value_names;
+	struct tracefs_hist_bucket	*buckets;
+	struct tracefs_hist_bucket	**next_bucket;
+	unsigned long long		hits;
+	unsigned long long		entries;
+	unsigned long long		dropped;
+};
+
+static int do_comment(struct tracefs_hist_data *hdata, const char *comment)
+{
+	return 0;
+}
+
+static int do_key_type(struct tracefs_hist_data *hdata, const char *key)
+{
+	char **tmp;
+
+	tmp = tracefs_list_add(hdata->key_names, key);
+	if (!tmp)
+		return -1;
+	hdata->key_names = tmp;
+
+	return 0;
+}
+
+static int do_value_type(struct tracefs_hist_data *hdata, const char *key)
+{
+	char **tmp;
+
+	tmp = tracefs_list_add(hdata->value_names, key);
+	if (!tmp)
+		return -1;
+	hdata->value_names = tmp;
+
+	return 0;
+}
+
+static int start_new_row(struct tracefs_hist_data *hdata)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+
+	bucket = calloc(1, sizeof(*bucket));
+	if (!bucket)
+		return -1;
+
+	key = calloc(1, sizeof(*key));
+	if (!key) {
+		free(bucket);
+		return -1;
+	}
+
+	bucket->keys = key;
+	bucket->next_key = &key->next;
+
+	bucket->next_val = &bucket->vals;
+
+	*hdata->next_bucket = bucket;
+	hdata->next_bucket = &bucket->next;
+	return 0;
+}
+
+static int start_new_key(struct tracefs_hist_data *hdata)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+
+	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
+
+	key = calloc(1, sizeof(*key));
+	if (!key) {
+		free(bucket);
+		return -1;
+	}
+
+	*bucket->next_key = key;
+	bucket->next_key = &key->next;
+
+	return 0;
+}
+
+static char *chomp(char *text)
+{
+	char *p;
+	int len;
+
+	while (isspace(*text))
+		text++;
+
+	len = strlen(text);
+	p = text + len - 1;
+	while (p >= text && isspace(*p))
+		p--;
+
+	p[1] = '\0';
+
+	return text;
+}
+
+static int __do_key_val(struct tracefs_hist_data *hdata,
+			char *text, const char *delim, const char *end)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+	struct tracefs_hist_bucket_key_single *k;
+	char *val;
+	int len;
+
+	text = chomp(text);
+
+	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
+
+	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
+	if (!key->type)
+		key->type = TRACEFS_BUCKET_KEY_SINGLE;
+
+	if (key->type != TRACEFS_BUCKET_KEY_SINGLE)
+		return -1;
+
+	k = &key->single;
+
+	len = strlen(text);
+	len += k->sym ? strlen(k->sym) + strlen(delim) : 0;
+	if (end)
+		len += strlen(end);
+
+	val = realloc(k->sym, len + 1);
+	if (!val)
+		return -1;
+
+	if (k->sym)
+		strcat(val, delim);
+	else
+		val[0] = '\0';
+
+	strcat(val, text);
+	if (end)
+		strcat(val, end);
+
+	k->sym = val;
+
+	return 0;
+}
+
+static int do_key_val(struct tracefs_hist_data *hdata, char *text)
+{
+	return __do_key_val(hdata, text, " ", NULL);
+}
+
+static int do_key_stack(struct tracefs_hist_data *hdata, char *text)
+{
+	return __do_key_val(hdata, text, "\n", NULL);
+}
+
+static int do_key_stack_mod(struct tracefs_hist_data *hdata, char *text)
+{
+	return __do_key_val(hdata, text, " [", "]");
+}
+
+static int do_key_raw(struct tracefs_hist_data *hdata, char *text)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+	struct tracefs_hist_bucket_key_single *k;
+
+	text = chomp(text);
+
+	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
+
+	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
+	if (key->type != TRACEFS_BUCKET_KEY_SINGLE)
+		return -1;
+
+	k = &key->single;
+
+	if (k->val)
+		return -1;
+
+	k->val = strtoll(text, NULL, 0);
+
+	return 0;
+}
+
+static int do_key_range(struct tracefs_hist_data *hdata, long long start,
+			long long end)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+	struct tracefs_hist_bucket_key_range *k;
+
+	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
+
+	key = container_of(bucket->next_key, struct tracefs_hist_bucket_key, next);
+
+	if (!key->type)
+		key->type = TRACEFS_BUCKET_KEY_RANGE;
+
+	if (key->type != TRACEFS_BUCKET_KEY_RANGE)
+		return -1;
+
+	k = &key->range;
+
+	k->start = start;
+	k->end = end;
+
+	return 0;
+}
+
+static int do_value_num(struct tracefs_hist_data *hdata, long long num)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_val *val;
+
+	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
+	val = calloc(1, sizeof(*val));
+	if (!val)
+		return -1;
+
+	val->val = num;
+
+	*bucket->next_val = val;
+	bucket->next_val = &val->next;
+
+	return 0;
+}
+
+static long long expo(unsigned int e, long long exp)
+{
+	long long ret;
+
+	if (exp < 0)
+		exp = 0;
+
+	if (e == 2)
+		return 1LL << exp;
+
+	ret = 1;
+	for (; exp > 0; exp--)
+		ret *= e;
+	return e;
+}
+
+enum hist_state {
+	HIST_START,
+	HIST_KEYS_START,
+	HIST_KEYS,
+	HIST_KEY_VALS,
+	HIST_RANGE,
+	HIST_VALUES,
+	HIST_NEXT_KEY,
+	HIST_STACK,
+	HIST_ENTRIES,
+	HIST_DROPPED,
+	HIST_END,
+};
+
+static const char *find_buffer_line(const char *buffer, int line_no)
+{
+	int line = 0;
+	int i;
+
+	for (i = 0; buffer[i]; i++) {
+		if (buffer[i] == '\n') {
+			line++;
+			if (line >= line_no) {
+				i++;
+				break;
+			}
+		}
+	}
+	return buffer + i;
+}
+
+static void print_line(struct trace_seq *seq, struct hist_data *data)
+{
+	const char *buffer = data->buffer;
+	int i;
+
+	buffer = find_buffer_line(buffer, data->line_no);
+
+	for (i = 0; buffer[i]; i++) {
+		if (buffer[i] == '\n')
+			break;
+	}
+
+	trace_seq_printf(seq, "%.*s (line:%d idx:%d)\n", i, buffer,
+			 data->line_no, data->line_idx);
+	trace_seq_printf(seq, "%*s\n", data->line_idx, "^");
+}
+
+static void print_error(struct hist_data *data, char **err,
+			enum hist_state state, enum yytokentype type)
+{
+	struct trace_seq seq;
+	char *tname;
+
+	if (!err)
+		return;
+
+	trace_seq_init(&seq);
+
+	print_line(&seq, data);
+
+	trace_seq_printf(&seq, "Error in ");
+	switch (state) {
+	case HIST_START:
+		trace_seq_printf(&seq, "HIST_START");
+		break;
+	case HIST_KEYS_START:
+		trace_seq_printf(&seq, "HIST_KEYS_START");
+		break;
+	case HIST_KEYS:
+		trace_seq_printf(&seq, "HIST_KEYS");
+		break;
+	case HIST_KEY_VALS:
+		trace_seq_printf(&seq, "HIST_KEY_VALS");
+		break;
+	case HIST_RANGE:
+		trace_seq_printf(&seq, "HIST_RANGE");
+		break;
+	case HIST_VALUES:
+		trace_seq_printf(&seq, "HIST_VALUES");
+		break;
+	case HIST_NEXT_KEY:
+		trace_seq_printf(&seq, "HIST_NEXT_KEY");
+	case HIST_STACK:
+		trace_seq_printf(&seq, "HIST_STACK");
+		break;
+	case HIST_ENTRIES:
+		trace_seq_printf(&seq, "HIST_ENTRIES");
+		break;
+	case HIST_DROPPED:
+		trace_seq_printf(&seq, "HIST_DROPPED");
+		break;
+	case HIST_END:
+		trace_seq_printf(&seq, "HIST_END");
+		break;
+	}
+	trace_seq_printf(&seq, " with token ");
+	tname = name_token(type);
+	if (tname)
+		trace_seq_printf(&seq, "%s", tname);
+	else
+		trace_seq_printf(&seq, "(unknown %d)", type);
+
+	trace_seq_printf(&seq, " last token %s\n", data->text);
+	trace_seq_terminate(&seq);
+	if (seq.buffer)
+		*err = seq.buffer;
+	seq.buffer = NULL;
+	trace_seq_destroy(&seq);
+}
+
+static void update_next(const char **next_buffer, struct hist_data *data)
+{
+	if (!next_buffer)
+		return;
+
+	*next_buffer = find_buffer_line(data->buffer, data->line_no - 1);
+}
+
+/**
+ * tracefs_hist_data_free - free a created hist data descriptor
+ * @hdata: The tracefs_hist_data descriptor to free.
+ *
+ * Frees the data allocated by tracefs_hist_data_parse().
+ */
+void tracefs_hist_data_free(struct tracefs_hist_data *hdata)
+{
+	struct tracefs_hist_bucket *bucket;
+	struct tracefs_hist_bucket_key *key;
+	struct tracefs_hist_bucket_val *val;
+
+	if (!hdata)
+		return;
+
+	tracefs_list_free(hdata->key_names);
+	tracefs_list_free(hdata->value_names);
+
+	while ((bucket = hdata->buckets)) {
+		hdata->buckets = bucket->next;
+		while ((key = bucket->keys)) {
+			bucket->keys = key->next;
+			switch (key->type) {
+			case TRACEFS_BUCKET_KEY_SINGLE:
+				free(key->single.sym);
+				break;
+			default:
+				break;
+			}
+			free(key);
+		}
+		while ((val = bucket->vals)) {
+			bucket->vals = val->next;
+			free(val);
+		}
+		free(bucket);
+	}
+
+	free(hdata);
+}
+
+/* Used for debugging in gdb */
+static void breakpoint(char *text)
+{
+}
+
+/**
+ * tracefs_hist_data_parse - parse a hist file of a trace event
+ * @buffer: The buffer containing the hist file content
+ * @next_buffer: If not NULL will point to the next hist in the buffer
+ * @err: If not NULL, will load the error message on error
+ *
+ * Reads and parses the content of a "hist" file of a trace event.
+ * It will return a descriptor that can be used to read the content and
+ * create a histogram table.
+ *
+ * Because "hist" files may contain more than one histogram, and this
+ * function will only parse one of the histograms, if there are more
+ * than one histogram in the buffer, and @next_buffer is not NULL, then
+ * it will return the location of the next histogram in @next_buffer.
+ *
+ * If there's an error in the parsing, then @err will contain an error
+ * message about what went wrong.
+ *
+ * Returns a desrciptor of a histogram representing the hist file content.
+ * NULL on error.
+ * The descriptor must be freed with tracefs_hist_data_free().
+ */
+struct tracefs_hist_data *
+tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err)
+{
+	struct tracefs_hist_data *hdata;
+	struct hist_data data;
+	enum hist_state state = 0;
+	long long start_range, end_range;
+	bool first = false;
+	unsigned int e;
+	int buffer_size;
+	bool done = false;
+	char *text;
+	enum yytokentype type;
+	int ret;
+
+	if (!buffer)
+		return NULL;
+
+	hdata = calloc(1, sizeof(*hdata));
+	if (!hdata)
+		return NULL;
+
+	hdata->next_bucket = &hdata->buckets;
+
+	memset(&data, 0, sizeof(data));
+
+	buffer_size = strlen(buffer);
+	data.buffer = buffer;
+	data.buffer_size = buffer_size;
+	data.text = malloc(buffer_size);
+	if (!data.text) {
+		free(hdata);
+		perror("text");
+		exit(-1);
+	}
+
+	ret = hist_lex_init_extra(&data, &data.scanner);
+	if (ret < 0) {
+		perror("ylex_init");
+		return NULL;
+	}
+	while (!done) {
+		type = hist_yylex(&data, data.scanner);
+		if (type < 0)
+			break;
+		text = data.text;
+		breakpoint(text);
+		switch (state) {
+		case HIST_START:
+			switch (type) {
+			case COMMENT:
+				first = true;
+				ret = do_comment(hdata, text);
+				if (ret < 0)
+					goto error;
+				break;
+			case KEY_TYPE:
+				goto key_type;
+			case STACKTRACE:
+				goto stacktrace;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_KEYS_START:
+			switch (type) {
+			case KEY_TYPE:
+ key_type:
+				if (first) {
+					ret = do_key_type(hdata, text);
+					if (ret < 0)
+						goto error;
+				}
+				ret = start_new_row(hdata);
+				state = HIST_KEY_VALS;
+				break;
+			case STACKTRACE:
+ stacktrace:
+				if (first) {
+					ret = do_key_type(hdata, "stacktrace");
+					if (ret < 0)
+						goto error;
+				}
+				ret = start_new_row(hdata);
+				state = HIST_STACK;
+				break;
+			case HITS:
+				hdata->hits = strtoll(text, NULL, 0);
+				state = HIST_ENTRIES;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_KEYS:
+			switch (type) {
+			case KEY_TYPE:
+				if (first) {
+					ret = do_key_type(hdata, text);
+					if (ret < 0)
+						goto error;
+				}
+				ret = start_new_key(hdata);
+				state = HIST_KEY_VALS;
+				break;
+			case STACKTRACE:
+				if (first) {
+					ret = do_key_type(hdata, "stacktrace");
+					if (ret < 0)
+						goto error;
+				}
+				ret = start_new_key(hdata);
+				state = HIST_STACK;
+				break;
+			case NEWLINE:
+				break;
+			case COLON:
+				state = HIST_VALUES;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_NEXT_KEY:
+			switch (type) {
+			case COLON:
+				state = HIST_VALUES;
+				break;
+			case COMMA:
+				state = HIST_KEYS;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_KEY_VALS:
+			switch (type) {
+			case NEWLINE:
+				continue;
+			case START_RANGE:
+				start_range = strtoll(text, NULL, 0);
+				state = HIST_RANGE;
+				break;
+			case KEY_VAL:
+				ret = do_key_val(hdata, text);
+				if (ret < 0)
+					goto error;
+				break;
+			case RAW_VAL:
+				ret = do_key_raw(hdata, text);
+				if (ret < 0)
+					goto error;
+				state = HIST_NEXT_KEY;
+				break;
+			case COLON:
+				state = HIST_VALUES;
+				break;
+			case COMMA:
+				state = HIST_KEYS;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_STACK:
+			switch (type) {
+			case NEWLINE:
+				break;
+			case STACK_ITEM:
+				ret = do_key_stack(hdata, text);
+				if (ret < 0)
+					goto error;
+				break;
+			case STACK_MOD:
+				ret = do_key_stack_mod(hdata, text);
+				if (ret < 0)
+					goto error;
+				break;
+			case COLON:
+				state = HIST_VALUES;
+				break;
+			case COMMA:
+				state = HIST_KEYS;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_RANGE:
+			switch (type) {
+			case RANGE_LINEAR:
+				do_key_range(hdata, start_range,
+					     strtoll(text, NULL, 0));
+				break;
+			case RANGE_EXPONENT:
+				end_range = strtoll(text, NULL, 0);
+				e = (unsigned int)start_range;
+				start_range = expo(e, end_range - 1);
+				end_range = expo(e, end_range);
+				do_key_range(hdata, start_range, end_range);
+				break;
+			default:
+				goto error;
+			}
+			state = HIST_KEYS;
+			break;
+		case HIST_VALUES:
+			switch (type) {
+			case VALUE:
+				if (first) {
+					ret = do_value_type(hdata, text);
+					if (ret < 0)
+						goto error;
+				}
+				break;
+			case NUMBER:
+				ret = do_value_num(hdata, strtoll(text, NULL, 0));
+				if (ret < 0)
+					goto error;
+				break;
+			case NEWLINE:
+				state = HIST_KEYS_START;
+				first = false;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_ENTRIES:
+			switch (type) {
+			case ENTRIES:
+				hdata->entries = strtoll(text, NULL, 0);
+				state = HIST_DROPPED;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_DROPPED:
+			switch (type) {
+			case DROPPED:
+				hdata->dropped = strtoll(text, NULL, 0);
+				state = HIST_END;
+				break;
+			default:
+				goto error;
+			}
+			break;
+		case HIST_END:
+			done = true;
+			switch (type) {
+			case COMMENT:
+				update_next(next_buffer, &data);
+				break;
+			case YYEOF:
+				/* Fall through */
+			default:
+				/* Do at end, as next_buffer may point to buffer*/
+				if (next_buffer)
+					*next_buffer = NULL;
+				break;
+			}
+			break;
+		}
+	}
+
+	hist_lex_destroy(data.scanner);
+	free(data.text);
+
+	return hdata;
+ error:
+	print_error(&data, err, state, type);
+	hist_lex_destroy(data.scanner);
+	free(data.text);
+	tracefs_hist_data_free(hdata);
+	return NULL;
+}
-- 
2.30.2

