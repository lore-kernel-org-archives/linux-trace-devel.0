Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448A5C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3C8610A7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhG3WSr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233072AbhG3WSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F6660FED;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V16-CI; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 01/17] libtracefs: Added new API tracefs_sql()
Date:   Fri, 30 Jul 2021 18:18:08 -0400
Message-Id: <20210730221824.595597-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This adds the API tracefs_sql() that takes a tep_handle handler, a name,
and a SQL string and parses it to produce a tracefs_synth synthetic event
handler.

Currently it only supports simple SQL of the type:

  SELECT start.common_pid AS pid, end.common_timestamp.usecs AS usecs
    FROM sched_waking AS start on sched_switch AS end
    ON start.pid = end.next_pid

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |   3 +
 src/Makefile          |  11 +
 src/sqlhist-parse.h   |  69 +++++
 src/sqlhist.l         |  88 ++++++
 src/sqlhist.y         | 143 +++++++++
 src/tracefs-sqlhist.c | 691 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1005 insertions(+)
 create mode 100644 src/sqlhist-parse.h
 create mode 100644 src/sqlhist.l
 create mode 100644 src/sqlhist.y
 create mode 100644 src/tracefs-sqlhist.c

diff --git a/include/tracefs.h b/include/tracefs.h
index 246647f6496d..3d83604031b1 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -385,4 +385,7 @@ void tracefs_synth_free(struct tracefs_synth *synth);
 int tracefs_synth_show(struct trace_seq *seq, struct tracefs_instance *instance,
 		       struct tracefs_synth *synth);
 
+struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
+				  const char *sql_buffer, char **err);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/Makefile b/src/Makefile
index 767af49034ee..eac404a1a147 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,6 +12,11 @@ OBJS += tracefs-kprobes.o
 OBJS += tracefs-hist.o
 OBJS += tracefs-filter.o
 
+# Order matters for the the three below
+OBJS += sqlhist-lex.o
+OBJS += sqlhist.tab.o
+OBJS += tracefs-sqlhist.o
+
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
@@ -32,6 +37,12 @@ $(LIBTRACEFS_SHARED_SO): $(LIBTRACEFS_SHARED_VERSION)
 
 libtracefs.so: $(LIBTRACEFS_SHARED_SO)
 
+sqlhist.tab.c: sqlhist.y
+	bison --debug -v --report-file=bison.report -d -o $@ $^
+
+sqlhist-lex.c: sqlhist.l sqlhist.tab.c
+	flex -o $@ $<
+
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
new file mode 100644
index 000000000000..aa5232eea451
--- /dev/null
+++ b/src/sqlhist-parse.h
@@ -0,0 +1,69 @@
+#ifndef __SQLHIST_PARSE_H
+#define __SQLHIST_PARSE_H
+
+#include <stdarg.h>
+#include <tracefs.h>
+
+struct str_hash;
+#define HASH_BITS 10
+
+struct sql_table;
+
+struct sqlhist_bison {
+	const char		*buffer;
+	size_t			buffer_size;
+	size_t			buffer_idx;
+	int			line_no;
+	int			line_idx;
+	struct sql_table	*table;
+	char			*parse_error_str;
+	struct str_hash         *str_hash[1 << HASH_BITS];
+};
+
+extern struct sqlhist_bison *sb;
+
+#include "sqlhist.tab.h"
+
+enum filter_type {
+	FILTER_GROUP,
+	FILTER_NOT_GROUP,
+	FILTER_EQ,
+	FILTER_NE,
+	FILTER_LE,
+	FILTER_LT,
+	FILTER_GE,
+	FILTER_GT,
+	FILTER_BIN_AND,
+	FILTER_STR_CMP,
+	FILTER_AND,
+	FILTER_OR,
+};
+
+enum compare_type {
+	COMPARE_GROUP,
+	COMPARE_ADD,
+	COMPARE_SUB,
+	COMPARE_MUL,
+	COMPARE_DIV,
+	COMPARE_BIN_AND,
+	COMPARE_BIN_OR,
+	COMPARE_AND,
+	COMPARE_OR,
+};
+
+char * store_str(struct sqlhist_bison *sb, const char *str);
+
+int table_start(struct sqlhist_bison *sb);
+
+void *add_field(struct sqlhist_bison *sb, const char *field, const char *label);
+
+int add_match(struct sqlhist_bison *sb, void *A, void *B);
+
+int add_selection(struct sqlhist_bison *sb, void *item, const char *label);
+int add_from(struct sqlhist_bison *sb, void *item);
+int add_to(struct sqlhist_bison *sb, void *item);
+
+extern void sql_parse_error(struct sqlhist_bison *sb, const char *text,
+			    const char *fmt, va_list ap);
+
+#endif
diff --git a/src/sqlhist.l b/src/sqlhist.l
new file mode 100644
index 000000000000..3f394f37b738
--- /dev/null
+++ b/src/sqlhist.l
@@ -0,0 +1,88 @@
+%{
+/* code here */
+
+#include <stdarg.h>
+#include "sqlhist-parse.h"
+
+extern int my_yyinput(char *buf, int max);
+
+#undef YY_INPUT
+#define YY_INPUT(b, r, m) ({r = my_yyinput(b, m);})
+
+#define YY_NO_INPUT
+#define YY_NO_UNPUT
+
+#define YY_EXTRA_TYPE struct sqlhist_bison *
+
+#define HANDLE_COLUMN do { sb->line_idx += strlen(yytext); } while (0)
+
+%}
+
+%option caseless
+
+field		[a-z_][a-z0-9_\.]*
+qstring		\"[^\"]*\"
+hexnum		0x[0-9a-z]+
+number		[0-9a-z]+
+
+%%
+
+select { HANDLE_COLUMN; return SELECT; }
+as { HANDLE_COLUMN; return AS; }
+from { HANDLE_COLUMN; return FROM; }
+join { HANDLE_COLUMN; return JOIN; }
+on { HANDLE_COLUMN; return ON; }
+
+{qstring} {
+	HANDLE_COLUMN;
+	yylval.string = store_str(sb, yytext);
+	return STRING;
+}
+
+{field} {
+	HANDLE_COLUMN;
+	yylval.string = store_str(sb, yytext);
+	return FIELD;
+}
+
+{hexnum} {
+	HANDLE_COLUMN;
+	yylval.number = strtol(yytext, NULL, 0);
+	return NUMBER;
+}
+
+{number} {
+	HANDLE_COLUMN;
+	yylval.number = strtol(yytext, NULL, 0);
+	return NUMBER;
+}
+
+\!= { HANDLE_COLUMN; return NEQ; }
+\<= { HANDLE_COLUMN; return LE; }
+\>= { HANDLE_COLUMN; return GE; }
+== { HANDLE_COLUMN; return EQ; }
+&& { HANDLE_COLUMN; return AND; }
+"||" { HANDLE_COLUMN; return OR; }
+[<>&~] { HANDLE_COLUMN; return yytext[0]; }
+
+[\!()\-\+\*/,=] { HANDLE_COLUMN; return yytext[0]; }
+
+[ \t] { HANDLE_COLUMN; }
+\n { sb->line_idx = 0; sb->line_no++; }
+
+. { HANDLE_COLUMN; return PARSE_ERROR; }
+%%
+
+int yywrap(void)
+{
+	return 1;
+}
+
+void yyerror(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	sql_parse_error(sb, yytext, fmt, ap);
+	va_end(ap);
+}
diff --git a/src/sqlhist.y b/src/sqlhist.y
new file mode 100644
index 000000000000..ecb0a0ed44b3
--- /dev/null
+++ b/src/sqlhist.y
@@ -0,0 +1,143 @@
+%{
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+#include "sqlhist-parse.h"
+
+extern int yylex(void);
+extern void yyerror(char *fmt, ...);
+
+#define CHECK_RETURN_PTR(x)					\
+	do {							\
+		if (!(x)) {					\
+			printf("FAILED MEMORY: %s\n", #x);	\
+			return -ENOMEM;				\
+		}						\
+	} while (0)
+
+#define CHECK_RETURN_VAL(x)					\
+	do {							\
+		if ((x) < 0) {					\
+			printf("FAILED MEMORY: %s\n", #x);	\
+			return -ENOMEM;				\
+		}						\
+	} while (0)
+
+%}
+
+%union {
+	int	s32;
+	char	*string;
+	long	number;
+	void	*expr;
+}
+
+%token AS SELECT FROM JOIN ON PARSE_ERROR
+%token <number> NUMBER
+%token <string> STRING
+%token <string> FIELD
+%token <string> LE GE EQ NEQ AND OR
+
+%left '+' '-'
+%left '*' '/'
+%left '<' '>'
+%left AND OR
+
+%type <string> name label
+
+%type <expr>  selection_expr field item named_field join_clause
+
+%%
+
+start :
+   select_statement
+ ;
+
+label : AS name { CHECK_RETURN_PTR($$ = store_str(sb, $2)); }
+ | name { CHECK_RETURN_PTR($$ = store_str(sb, $1)); }
+ ;
+
+select : SELECT  { table_start(sb); }
+  ;
+
+select_statement :
+    select selection_list table_exp
+  ;
+
+selection_list :
+   selection
+ | selection ',' selection_list
+ ;
+
+selection :
+    selection_expr
+				{
+					CHECK_RETURN_VAL(add_selection(sb, $1, NULL));
+				}
+  | selection_expr label
+				{
+					CHECK_RETURN_VAL(add_selection(sb, $1, $2));
+				}
+  ;
+
+selection_expr :
+   field
+ | '(' field ')'		{  $$ = $2; }
+ ;
+
+item :
+   named_field
+ | field
+ ;
+
+field :
+   FIELD	{ $$ = add_field(sb, $1, NULL); CHECK_RETURN_PTR($$); }
+ ;
+
+named_field :
+   FIELD label { $$ = add_field(sb, $1, $2); CHECK_RETURN_PTR($$); }
+ ;
+
+name :
+   FIELD
+ ;
+
+table_exp :
+   from_clause join_clause
+ ;
+
+from_clause :
+   FROM item		{ CHECK_RETURN_VAL(add_from(sb, $2)); }
+
+/*
+ * Select from a from clause confuses the variable parsing.
+ * disable it for now.
+
+   | FROM '(' select_statement ')' label
+				{
+					from_table_end($5);
+					$$ = store_printf("FROM (%s) AS %s", $3, $5);
+				}
+*/
+ ;
+
+join_clause :
+  JOIN item ON match_clause	{ add_to(sb, $2); }
+ ;
+
+match :
+   item '=' item { CHECK_RETURN_VAL(add_match(sb, $1, $3)); }
+ | item EQ item { CHECK_RETURN_VAL(add_match(sb, $1, $3)); }
+
+ ;
+
+match_clause :
+   match
+ | match ',' match_clause
+ ;
+
+%%
+
+
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
new file mode 100644
index 000000000000..7ec0c11b902e
--- /dev/null
+++ b/src/tracefs-sqlhist.c
@@ -0,0 +1,691 @@
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
+#include <errno.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+#include "sqlhist-parse.h"
+
+struct sqlhist_bison *sb;
+
+extern int yylex_init(void* ptr_yy_globals);
+extern int yylex_init_extra(struct sqlhist_bison *sb, void* ptr_yy_globals);
+extern int yylex_destroy (void * yyscanner );
+
+struct str_hash {
+	struct str_hash		*next;
+	char			*str;
+};
+
+enum alias_type {
+	ALIAS_EVENT,
+	ALIAS_FIELD,
+};
+
+#define for_each_field(expr, field, table) \
+	for (expr = (table)->fields; expr; expr = (field)->next)
+
+struct field {
+	struct expr		*next;	/* private link list */
+	const char		*system;
+	const char		*event;
+	const char		*raw;
+	const char		*label;
+	const char		*field;
+};
+
+struct match {
+	struct match		*next;
+	struct expr		*lval;
+	struct expr		*rval;
+};
+
+enum expr_type
+{
+	EXPR_NUMBER,
+	EXPR_STRING,
+	EXPR_FIELD,
+};
+
+struct expr {
+	struct expr		*free_list;
+	struct expr		*next;
+	enum expr_type		type;
+	union {
+		struct field	field;
+		const char	*string;
+		long		number;
+	};
+};
+
+struct sql_table {
+	struct sqlhist_bison	*sb;
+	const char		*name;
+	struct expr		*exprs;
+	struct expr		*fields;
+	struct expr		*from;
+	struct expr		*to;
+	struct match		*matches;
+	struct match		**next_match;
+	struct expr		*selections;
+	struct expr		**next_selection;
+};
+
+__hidden int my_yyinput(char *buf, int max)
+{
+	if (!sb || !sb->buffer)
+		return -1;
+
+	if (sb->buffer_idx + max > sb->buffer_size)
+		max = sb->buffer_size - sb->buffer_idx;
+
+	if (max)
+		memcpy(buf, sb->buffer + sb->buffer_idx, max);
+
+	sb->buffer_idx += max;
+
+	return max;
+}
+
+__hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
+			      const char *fmt, va_list ap)
+{
+	const char *buffer = sb->buffer;
+	struct trace_seq s;
+	int line = sb->line_no;
+	int idx = sb->line_idx - strlen(text);
+	int i;
+
+	if (!buffer)
+		return;
+
+	trace_seq_init(&s);
+	if (!s.buffer) {
+		fprintf(stderr, "Error allocating internal buffer\n");
+		return;
+	}
+
+	for (i = 0; line && buffer[i]; i++) {
+		if (buffer[i] == '\n')
+			line--;
+	}
+	for (; buffer[i] && buffer[i] != '\n'; i++)
+		trace_seq_putc(&s, buffer[i]);
+	trace_seq_putc(&s, '\n');
+	for (i = idx; i > 0; i--)
+		trace_seq_putc(&s, ' ');
+	trace_seq_puts(&s, "^\n");
+	trace_seq_printf(&s, "ERROR: '%s'\n", text);
+	trace_seq_vprintf(&s, fmt, ap);
+
+	trace_seq_terminate(&s);
+
+	sb->parse_error_str = strdup(s.buffer);
+	trace_seq_destroy(&s);
+}
+
+static inline unsigned int quick_hash(const char *str)
+{
+	unsigned int val = 0;
+	int len = strlen(str);
+
+	for (; len >= 4; str += 4, len -= 4) {
+		val += str[0];
+		val += str[1] << 8;
+		val += str[2] << 16;
+		val += str[3] << 24;
+	}
+	for (; len > 0; str++, len--)
+		val += str[0] << (len * 8);
+
+        val *= 2654435761;
+
+        return val & ((1 << HASH_BITS) - 1);
+}
+
+
+static struct str_hash *find_string(struct sqlhist_bison *sb, const char *str)
+{
+	unsigned int key = quick_hash(str);
+	struct str_hash *hash = sb->str_hash[key];
+
+	for (; hash; hash = hash->next) {
+		if (!strcmp(hash->str, str))
+			return hash;
+	}
+	return NULL;
+}
+
+/*
+ * If @str is found, then return the hash string.
+ * This lets store_str() know to free str.
+ */
+static char **add_hash(struct sqlhist_bison *sb, const char *str)
+{
+	struct str_hash *hash;
+	unsigned int key;
+
+	if ((hash = find_string(sb, str))) {
+		return &hash->str;
+	}
+
+	hash = malloc(sizeof(*hash));
+	if (!hash)
+		return NULL;
+	key = quick_hash(str);
+	hash->next = sb->str_hash[key];
+	sb->str_hash[key] = hash;
+	hash->str = NULL;
+	return &hash->str;
+}
+
+__hidden char *store_str(struct sqlhist_bison *sb, const char *str)
+{
+	char **pstr = add_hash(sb, str);
+
+	if (!pstr)
+		return NULL;
+
+	if (!(*pstr))
+		*pstr = strdup(str);
+
+	return *pstr;
+}
+
+__hidden int add_selection(struct sqlhist_bison *sb, void *select,
+			   const char *name)
+{
+	struct sql_table *table = sb->table;
+	struct expr *expr = select;
+
+	switch (expr->type) {
+	case EXPR_FIELD:
+		break;
+	case EXPR_NUMBER:
+	case EXPR_STRING:
+	default:
+		return -1;
+	}
+
+	if (expr->next)
+		return -1;
+
+	*table->next_selection = expr;
+	table->next_selection = &expr->next;
+
+	return 0;
+}
+
+static struct expr *find_field(struct sqlhist_bison *sb,
+				const char *raw, const char *label)
+{
+	struct field *field;
+	struct expr *expr;
+
+	for_each_field(expr, field, sb->table) {
+		field = &expr->field;
+
+		if (!strcmp(field->raw, raw)) {
+			if (label && !field->label)
+				field->label = label;
+			return expr;
+		}
+
+		if (label && !strcmp(field->raw, label)) {
+			if (!field->label) {
+				field->label = label;
+				field->raw = raw;
+			}
+			return expr;
+		}
+
+		if (!field->label)
+			continue;
+
+		if (!strcmp(field->label, raw))
+			return expr;
+
+		if (label && !strcmp(field->label, label))
+			return expr;
+	}
+	return NULL;
+}
+
+static void *create_expr(enum expr_type type, struct expr **expr_p)
+{
+	struct expr *expr;
+
+	expr = calloc(1, sizeof(*expr));
+	if (!expr)
+		return NULL;
+
+	if (expr_p)
+		*expr_p = expr;
+
+	expr->free_list = sb->table->exprs;
+	sb->table->exprs = expr;
+
+	expr->type = type;
+
+	switch (type) {
+	case EXPR_FIELD:	return &expr->field;
+	case EXPR_NUMBER:	return &expr->number;
+	case EXPR_STRING:	return &expr->string;
+	}
+
+	return NULL;
+}
+
+#define __create_expr(var, type, ENUM, expr)			\
+	do {							\
+		var = (type *)create_expr(EXPR_##ENUM, expr);	\
+	} while(0)
+
+#define create_field(var, expr)				\
+	__create_expr(var, struct field, FIELD, expr)
+
+__hidden void *add_field(struct sqlhist_bison *sb,
+			 const char *field_name, const char *label)
+{
+	struct sql_table *table = sb->table;
+	struct expr *expr;
+	struct field *field;
+
+	expr = find_field(sb, field_name, label);
+	if (expr)
+		return expr;
+
+	create_field(field, &expr);
+
+	field->next = table->fields;
+	table->fields = expr;
+
+	field->raw = field_name;
+	field->label = label;
+
+	return expr;
+}
+
+__hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
+{
+	struct sql_table *table = sb->table;
+	struct match *match;
+
+	match = calloc(1, sizeof(*match));
+	if (!match)
+		return -1;
+
+	match->lval = A;
+	match->rval = B;
+
+	*table->next_match = match;
+	table->next_match = &match->next;
+
+	return 0;
+}
+
+__hidden int add_from(struct sqlhist_bison *sb, void *item)
+{
+	struct expr *expr = item;
+
+	if (expr->type != EXPR_FIELD)
+		return -1;
+
+	sb->table->from = expr;
+
+	return 0;
+}
+
+__hidden int add_to(struct sqlhist_bison *sb, void *item)
+{
+	struct expr *expr = item;
+
+	if (expr->type != EXPR_FIELD)
+		return -1;
+
+	sb->table->to = expr;
+
+	return 0;
+}
+
+__hidden int table_start(struct sqlhist_bison *sb)
+{
+	struct sql_table *table;
+
+	table = calloc(1, sizeof(*table));
+	if (!table)
+		return -ENOMEM;
+
+	table->sb = sb;
+	sb->table = table;
+
+	table->next_match = &table->matches;
+	table->next_selection = &table->selections;
+
+	return 0;
+}
+
+static int update_vars(struct sql_table *table, struct field *event)
+{
+	struct sqlhist_bison *sb = table->sb;
+	struct expr *expr;
+	struct field *field;
+	const char *label;
+	const char *p, *r;
+	char *system;
+	int len;
+
+	p = strchr(event->raw, '.');
+	if (p) {
+		system = strndup(event->raw, p - event->raw);
+		if (!system)
+			return -1;
+		event->system = store_str(sb, system);
+		free(system);
+		if (!event->system)
+			return -1;
+		p++;
+	} else {
+		p = event->raw;
+	}
+
+	event->event = store_str(sb, p);
+	if (!event->event)
+		return -1;
+
+	if (!event->label)
+		event->label = event->event;
+
+	label = event->label;
+	len = strlen(label);
+
+	for_each_field(expr, field, table) {
+		field = &expr->field;
+
+		if (field->event)
+			continue;
+
+		p = strchr(field->raw, '.');
+		if (p) {
+			/* Does this field have a system */
+			r = strchr(p + 1, '.');
+			if (r) {
+				/* This has a system, and is not a alias */
+				system = strndup(field->raw, p - field->raw);
+				if (!system)
+					return -1;
+				field->system = store_str(sb, system);
+				free(system);
+				if (!field->system)
+					return -1;
+
+				/* save the event as well */
+				p++;
+				system = strndup(p, r - p);
+				if (!system)
+					return -1;
+				field->event = store_str(sb, system);
+				free(system);
+				if (!field->event)
+					return -1;
+				r++;
+				field->field = store_str(sb, r);
+				goto check_timestamps;
+			}
+		}
+
+		if (strncmp(field->raw, label, len))
+			continue;
+
+		if (field->raw[len] != '.')
+			continue;
+
+		field->system = event->system;
+		field->event = event->event;
+		field->field = field->raw + len + 1;
+ check_timestamps:
+		if (!strcmp(field->field, "TIMESTAMP"))
+			field->field = store_str(sb, TRACEFS_TIMESTAMP);
+		else if (!strcmp(field->field, "TIMESTAMP_USECS"))
+			field->field = store_str(sb, TRACEFS_TIMESTAMP_USECS);
+	}
+
+	return 0;
+}
+
+static int test_match(struct sql_table *table, struct match *match)
+{
+	struct field *lval, *rval;
+	struct field *to, *from;
+
+	if (!match->lval || !match->rval)
+		return -1;
+
+	if (match->lval->type != EXPR_FIELD || match->rval->type != EXPR_FIELD)
+		return -1;
+
+	to = &table->to->field;
+	from = &table->from->field;
+
+	lval = &match->lval->field;
+	rval = &match->rval->field;
+
+	/*
+	 * Note, strings are stored in the string store, so all
+	 * duplicate strings are the same value, and we can use
+	 * normal "==" and "!=" instead of strcmp().
+	 *
+	 * Either lval == to and rval == from
+	 * or lval == from and rval == to.
+	 */
+	if ((lval->system != to->system) ||
+	    (lval->event != to->event)) {
+		if ((rval->system != to->system) ||
+		    (rval->event != to->event) ||
+		    (lval->system != from->system) ||
+		    (lval->event != from->event))
+			return -1;
+	} else {
+		if ((rval->system != from->system) ||
+		    (rval->event != from->event) ||
+		    (lval->system != to->system) ||
+		    (lval->event != to->event))
+			return -1;
+	}
+	return 0;
+}
+
+static void assign_match(const char *system, const char *event,
+			 struct match *match,
+			 const char **start_match, const char **end_match)
+{
+	struct field *lval, *rval;
+
+	lval = &match->lval->field;
+	rval = &match->rval->field;
+
+	if (lval->system == system &&
+	    lval->event == event) {
+		*start_match = lval->field;
+		*end_match = rval->field;
+	} else {
+		*start_match = rval->field;
+		*end_match = lval->field;
+	}
+}
+
+static struct tracefs_synth *build_synth(struct tep_handle *tep,
+					 const char *name,
+					 struct sql_table *table)
+{
+	struct tracefs_synth *synth;
+	struct field *field;
+	struct match *match;
+	struct expr *expr;
+	const char *start_system;
+	const char *start_event;
+	const char *end_system;
+	const char *end_event;
+	const char *start_match;
+	const char *end_match;
+	int ret;
+
+	if (!table->to || !table->from)
+		return NULL;
+
+	ret = update_vars(table, &table->to->field);
+	if (ret < 0)
+		return NULL;
+
+	ret = update_vars(table, &table->from->field);
+	if (ret < 0)
+		return NULL;
+
+	match = table->matches;
+	if (!match)
+		return NULL;
+
+	ret = test_match(table, match);
+	if (ret < 0)
+		return NULL;
+
+	start_system = table->from->field.system;
+	start_event = table->from->field.event;
+
+	end_system = table->to->field.system;
+	end_event = table->to->field.event;
+
+	assign_match(start_system, start_event, match,
+		     &start_match, &end_match);
+
+	synth = tracefs_synth_init(tep, name, start_system,
+				   start_event, end_system, end_event,
+				   start_match, end_match, NULL);
+	if (!synth)
+		return NULL;
+
+	for (match = match->next; match; match = match->next) {
+		ret = test_match(table, match);
+		if (ret < 0)
+			goto free;
+
+		assign_match(start_system, start_event, match,
+			     &start_match, &end_match);
+
+		ret = tracefs_synth_add_match_field(synth,
+						    start_match,
+						    end_match, NULL);
+		if (ret < 0)
+			goto free;
+	}
+
+	for (expr = table->selections; expr; expr = expr->next) {
+		if (expr->type == EXPR_FIELD) {
+			field = &expr->field;
+			if (field->system == start_system &&
+			    field->event == start_event) {
+				ret = tracefs_synth_add_start_field(synth,
+						field->field, field->label);
+			} else {
+				ret = tracefs_synth_add_end_field(synth,
+						field->field, field->label);
+			}
+			if (ret < 0)
+				goto free;
+			continue;
+		}
+		goto free;
+	}
+
+	return synth;
+ free:
+	tracefs_synth_free(synth);
+	return NULL;
+}
+
+static void free_sql_table(struct sql_table *table)
+{
+	struct match *match;
+	struct expr *expr;
+
+	if (!table)
+		return;
+
+	while ((expr = table->exprs)) {
+		table->exprs = expr->next;
+		free(expr);
+	}
+
+	while ((match = table->matches)) {
+		table->matches = match->next;
+		free(match);
+	}
+
+	free(table);
+}
+
+static void free_str_hash(struct str_hash **hash)
+{
+	struct str_hash *item;
+	int i;
+
+	for (i = 0; i < 1 << HASH_BITS; i++) {
+		while ((item = hash[i])) {
+			hash[i] = item->next;
+			free(item->str);
+			free(item);
+		}
+	}
+}
+
+static void free_sb(struct sqlhist_bison *sb)
+{
+	free_sql_table(sb->table);
+	free_str_hash(sb->str_hash);
+	free(sb->parse_error_str);
+}
+
+struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
+				  const char *sql_buffer, char **err)
+{
+	struct sqlhist_bison local_sb;
+	struct tracefs_synth *synth = NULL;
+	int ret;
+
+	if (!tep || !sql_buffer) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	memset(&local_sb, 0, sizeof(local_sb));
+
+	local_sb.buffer = sql_buffer;
+	local_sb.buffer_size = strlen(sql_buffer);
+	local_sb.buffer_idx = 0;
+
+	sb = &local_sb;
+	ret = yyparse();
+
+	if (ret)
+		goto free;
+
+	synth = build_synth(tep, name, sb->table);
+
+ free:
+	if (!synth) {
+		if (sb->parse_error_str && err) {
+			*err = sb->parse_error_str;
+			sb->parse_error_str = NULL;
+		}
+	}
+	free_sb(sb);
+	return synth;
+}
-- 
2.30.2

