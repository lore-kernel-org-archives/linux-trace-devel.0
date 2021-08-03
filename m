Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3D6C43216
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C9960EB9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbhHCRGW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237472AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B02B361040;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ubb-Lj; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 05/22] libtracefs: Add filtering for start and end events in tracefs_sql()
Date:   Tue,  3 Aug 2021 13:05:49 -0400
Message-Id: <20210803170606.694085-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Allow the start and end events to have filters with the "WHERE" clause.

For example:

  SELECT (end.common_timestamp.usecs - start.common_timestamp.usecs) AS
    lat FROM sched_waking AS start JOIN sched_switch AS end ON
    start.pid = stop.next_pid WHERE start.prio < 100 &&
    end.prev_prio < 100

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/sqlhist-parse.h   |   6 +
 src/sqlhist.l         |   1 +
 src/sqlhist.y         |  70 +++++++++++-
 src/tracefs-sqlhist.c | 260 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 335 insertions(+), 2 deletions(-)

diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index aeb1738d693f..0933bfe9a574 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -57,13 +57,19 @@ int table_start(struct sqlhist_bison *sb);
 
 void *add_field(struct sqlhist_bison *sb, const char *field, const char *label);
 
+void *add_filter(struct sqlhist_bison *sb, void *A, void *B, enum filter_type op);
+
 int add_match(struct sqlhist_bison *sb, void *A, void *B);
 void *add_compare(struct sqlhist_bison *sb, void *A, void *B, enum compare_type type);
+int add_where(struct sqlhist_bison *sb, void *expr);
 
 int add_selection(struct sqlhist_bison *sb, void *item, const char *label);
 int add_from(struct sqlhist_bison *sb, void *item);
 int add_to(struct sqlhist_bison *sb, void *item);
 
+void *add_string(struct sqlhist_bison *sb, const char *str);
+void *add_number(struct sqlhist_bison *sb, long val);
+
 extern void sql_parse_error(struct sqlhist_bison *sb, const char *text,
 			    const char *fmt, va_list ap);
 
diff --git a/src/sqlhist.l b/src/sqlhist.l
index 5dfd17517c6e..5baba0992afc 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -32,6 +32,7 @@ as { HANDLE_COLUMN; return AS; }
 from { HANDLE_COLUMN; return FROM; }
 join { HANDLE_COLUMN; return JOIN; }
 on { HANDLE_COLUMN; return ON; }
+where { HANDLE_COLUMN; return WHERE; }
 
 {qstring} {
 	HANDLE_COLUMN;
diff --git a/src/sqlhist.y b/src/sqlhist.y
index 1ba3bf62ee43..8dcc824bb9f1 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -34,7 +34,7 @@ extern void yyerror(char *fmt, ...);
 	void	*expr;
 }
 
-%token AS SELECT FROM JOIN ON PARSE_ERROR
+%token AS SELECT FROM JOIN ON WHERE PARSE_ERROR
 %token <number> NUMBER
 %token <string> STRING
 %token <string> FIELD
@@ -49,6 +49,9 @@ extern void yyerror(char *fmt, ...);
 
 %type <expr>  selection_expr field item named_field join_clause
 %type <expr>  selection_addition
+%type <expr>  compare compare_list compare_cmds compare_items
+%type <expr>  compare_and_or
+%type <expr>  str_val val
 
 %%
 
@@ -120,8 +123,71 @@ name :
    FIELD
  ;
 
+str_val :
+   STRING	{ $$ = add_string(sb, $1); CHECK_RETURN_PTR($$); }
+ ;
+
+val :
+   str_val
+ | NUMBER	{ $$ = add_number(sb, $1); CHECK_RETURN_PTR($$); }
+ ;
+
+
+compare :
+   field '<' val	{ $$ = add_filter(sb, $1, $3, FILTER_LT); CHECK_RETURN_PTR($$); }
+ | field '>' val	{ $$ = add_filter(sb, $1, $3, FILTER_GT); CHECK_RETURN_PTR($$); }
+ | field LE val	{ $$ = add_filter(sb, $1, $3, FILTER_LE); CHECK_RETURN_PTR($$); }
+ | field GE val	{ $$ = add_filter(sb, $1, $3, FILTER_GE); CHECK_RETURN_PTR($$); }
+ | field '=' val	{ $$ = add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
+ | field EQ val	{ $$ = add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
+ | field NEQ val	{ $$ = add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
+ | field "!=" val	{ $$ = add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
+ | field '&' val	{ $$ = add_filter(sb, $1, $3, FILTER_BIN_AND); CHECK_RETURN_PTR($$); }
+ | field '~' str_val	{ $$ = add_filter(sb, $1, $3, FILTER_STR_CMP); CHECK_RETURN_PTR($$); }
+;
+
+compare_and_or :
+   compare_and_or OR compare_and_or	{ $$ = add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
+ | compare_and_or AND compare_and_or	{ $$ = add_filter(sb, $1, $3, FILTER_AND); CHECK_RETURN_PTR($$); }
+ | '!' '(' compare_and_or ')'		{ $$ = add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' compare				{ $$ = add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | compare
+ ;
+
+compare_items :
+   compare_items OR compare_items	{ $$ = add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
+ | '(' compare_and_or ')'		{ $$ = add_filter(sb, $2, NULL, FILTER_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' '(' compare_and_or ')'		{ $$ = add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' compare				{ $$ = add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | compare
+ ;
+
+compare_cmds :
+   compare_items		{ CHECK_RETURN_VAL(add_where(sb, $1)); }
+ ;
+
+/*
+ * Top level AND is equal to ',' but the compare_cmds in them must
+ * all be of for the same event (start or end exclusive).
+ * That is, OR is not to be used between start and end events.
+ */
+compare_list :
+   compare_cmds
+ | compare_cmds ',' compare_list
+ | compare_cmds AND compare_list
+ ;
+
+where_clause :
+   WHERE compare_list
+ ;
+
+opt_where_clause :
+   /* empty */
+ | where_clause
+;
+
 table_exp :
-   from_clause join_clause
+   from_clause join_clause opt_where_clause
  ;
 
 from_clause :
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 01c04211499a..e17da39e1860 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -91,6 +91,8 @@ struct sql_table {
 	struct expr		*fields;
 	struct expr		*from;
 	struct expr		*to;
+	struct expr		*where;
+	struct expr		**next_where;
 	struct match		*matches;
 	struct match		**next_match;
 	struct expr		*selections;
@@ -318,9 +320,18 @@ static void *create_expr(enum expr_type type, struct expr **expr_p)
 #define create_field(var, expr)				\
 	__create_expr(var, struct field, FIELD, expr)
 
+#define create_filter(var, expr)			\
+	__create_expr(var, struct filter, FILTER, expr)
+
 #define create_compare(var, expr)				\
 	__create_expr(var, struct compare, COMPARE, expr)
 
+#define create_string(var, expr)			\
+	__create_expr(var, const char *, STRING, expr)
+
+#define create_number(var, expr)			\
+	__create_expr(var, long, NUMBER, expr)
+
 __hidden void *add_field(struct sqlhist_bison *sb,
 			 const char *field_name, const char *label)
 {
@@ -343,6 +354,22 @@ __hidden void *add_field(struct sqlhist_bison *sb,
 	return expr;
 }
 
+__hidden void *add_filter(struct sqlhist_bison *sb,
+			  void *A, void *B, enum filter_type op)
+{
+	struct filter *filter;
+	struct expr *expr;
+
+	create_filter(filter, &expr);
+
+	filter->lval = A;
+	filter->rval = B;
+
+	filter->type = op;
+
+	return expr;
+}
+
 __hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
 {
 	struct sql_table *table = sb->table;
@@ -376,6 +403,23 @@ __hidden void *add_compare(struct sqlhist_bison *sb,
 	return expr;
 }
 
+__hidden int add_where(struct sqlhist_bison *sb, void *item)
+{
+	struct expr *expr = item;
+	struct sql_table *table = sb->table;
+
+	if (expr->type != EXPR_FILTER)
+		return -1;
+
+	*table->next_where = expr;
+	table->next_where = &expr->next;
+
+	if (expr->next)
+		return -1;
+
+	return 0;
+}
+
 __hidden int add_from(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
@@ -400,6 +444,34 @@ __hidden int add_to(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
+__hidden void *add_string(struct sqlhist_bison *sb, const char *str)
+{
+	struct expr *expr;
+	const char **str_p;
+
+	create_string(str_p, &expr);
+	*str_p = str;
+	return expr;
+}
+
+__hidden void *add_number(struct sqlhist_bison *sb, long val)
+{
+	struct expr *expr;
+	long *num;
+
+	create_number(num, &expr);
+	*num = val;
+	return expr;
+
+	expr = calloc(1, sizeof(expr));
+	if (!expr)
+		return NULL;
+
+	expr->type = EXPR_NUMBER;
+	expr->number = val;
+	return expr;
+}
+
 __hidden int table_start(struct sqlhist_bison *sb)
 {
 	struct sql_table *table;
@@ -411,6 +483,7 @@ __hidden int table_start(struct sqlhist_bison *sb)
 	table->sb = sb;
 	sb->table = table;
 
+	table->next_where = &table->where;
 	table->next_match = &table->matches;
 	table->next_selection = &table->selections;
 
@@ -663,6 +736,167 @@ static int build_compare(struct tracefs_synth *synth,
 	return ret;
 }
 
+static int do_verify_filter(struct filter *filter,
+			    const char **system, const char **event)
+{
+	int ret;
+
+	if (filter->type == FILTER_OR ||
+	    filter->type == FILTER_AND) {
+		ret = do_verify_filter(&filter->lval->filter, system, event);
+		if (ret)
+			return ret;
+		return do_verify_filter(&filter->rval->filter, system, event);
+	}
+	if (filter->type == FILTER_GROUP ||
+	    filter->type == FILTER_NOT_GROUP) {
+		return do_verify_filter(&filter->lval->filter, system, event);
+	}
+
+	/*
+	 * system and event will be NULL until we find the left most
+	 * node. Then assign it, and compare on the way back up.
+	 */
+	if (!*system && !*event) {
+		*system = filter->lval->field.system;
+		*event = filter->lval->field.event_name;
+		return 0;
+	}
+
+	if (filter->lval->field.system != *system ||
+	    filter->lval->field.event_name != *event)
+		return -1;
+
+	return 0;
+}
+
+static int verify_filter(struct filter *filter,
+			 const char **system, const char **event)
+{
+	int ret;
+
+	switch (filter->type) {
+	case FILTER_OR:
+	case FILTER_AND:
+	case FILTER_GROUP:
+	case FILTER_NOT_GROUP:
+		break;
+	default:
+		return do_verify_filter(filter, system, event);
+	}
+
+	ret = do_verify_filter(&filter->lval->filter, system, event);
+	if (ret)
+		return ret;
+
+	switch (filter->type) {
+	case FILTER_OR:
+	case FILTER_AND:
+		return do_verify_filter(&filter->rval->filter, system, event);
+	default:
+		return 0;
+	}
+}
+
+static int build_filter(struct tracefs_synth *synth,
+			bool start, struct filter *filter, bool *started)
+{
+	int (*append_filter)(struct tracefs_synth *synth,
+			     enum tracefs_filter type,
+			     const char *field,
+			     enum tracefs_compare compare,
+			     const char *val);
+	enum tracefs_compare cmp;
+	const char *val;
+	int and_or = TRACEFS_FILTER_AND;
+	char num[64];
+	int ret;
+
+	if (start)
+		append_filter = tracefs_synth_append_start_filter;
+	else
+		append_filter = tracefs_synth_append_end_filter;
+
+	if (started && *started) {
+		ret = append_filter(synth, and_or, NULL, 0, NULL);
+		ret = append_filter(synth, TRACEFS_FILTER_OPEN_PAREN,
+				    NULL, 0, NULL);
+	}
+
+	switch (filter->type) {
+	case FILTER_NOT_GROUP:
+		ret = append_filter(synth, TRACEFS_FILTER_NOT,
+				    NULL, 0, NULL);
+		if (ret < 0)
+			goto out;
+		/* Fall through */
+	case FILTER_GROUP:
+		ret = append_filter(synth, TRACEFS_FILTER_OPEN_PAREN,
+				    NULL, 0, NULL);
+		if (ret < 0)
+			goto out;
+		ret = build_filter(synth, start, &filter->lval->filter, NULL);
+		if (ret < 0)
+			goto out;
+		ret = append_filter(synth, TRACEFS_FILTER_CLOSE_PAREN,
+				    NULL, 0, NULL);
+		goto out;
+
+	case FILTER_OR:
+		and_or = TRACEFS_FILTER_OR;
+		/* Fall through */
+	case FILTER_AND:
+		ret = build_filter(synth, start, &filter->lval->filter, NULL);
+		if (ret < 0)
+			goto out;
+		ret = append_filter(synth, and_or, NULL, 0, NULL);
+
+		if (ret)
+			goto out;
+		ret = build_filter(synth, start, &filter->rval->filter, NULL);
+		goto out;
+	default:
+		break;
+	}
+
+	switch (filter->rval->type) {
+	case EXPR_NUMBER:
+		sprintf(num, "%ld", filter->rval->number);
+		val = num;
+		break;
+	case EXPR_STRING:
+		val = filter->rval->string;
+		break;
+	default:
+		break;
+	}
+
+	switch (filter->type) {
+	case FILTER_EQ:		cmp = TRACEFS_COMPARE_EQ; break;
+	case FILTER_NE:		cmp = TRACEFS_COMPARE_NE; break;
+	case FILTER_LE:		cmp = TRACEFS_COMPARE_LE; break;
+	case FILTER_LT:		cmp = TRACEFS_COMPARE_LT; break;
+	case FILTER_GE:		cmp = TRACEFS_COMPARE_GE; break;
+	case FILTER_GT:		cmp = TRACEFS_COMPARE_GT; break;
+	case FILTER_BIN_AND:	cmp = TRACEFS_COMPARE_AND; break;
+	case FILTER_STR_CMP:	cmp = TRACEFS_COMPARE_RE; break;
+	default:
+		break;
+	}
+
+	ret = append_filter(synth, TRACEFS_FILTER_COMPARE,
+			    filter->lval->field.field, cmp, val);
+
+ out:
+	if (!ret && started) {
+		if (*started)
+			ret = append_filter(synth, TRACEFS_FILTER_CLOSE_PAREN,
+					    NULL, 0, NULL);
+		*started = true;
+	}
+	return ret;
+}
+
 static struct tracefs_synth *build_synth(struct tep_handle *tep,
 					 const char *name,
 					 struct sql_table *table)
@@ -677,6 +911,8 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 	const char *end_event;
 	const char *start_match;
 	const char *end_match;
+	bool started_start = false;
+	bool started_end = false;
 	int ret;
 
 	if (!table->to || !table->from)
@@ -753,6 +989,30 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 			goto free;
 	}
 
+	for (expr = table->where; expr; expr = expr->next) {
+		const char *filter_system = NULL;
+		const char *filter_event = NULL;
+		bool *started;
+		bool start;
+
+		ret = verify_filter(&expr->filter, &filter_system,
+				    &filter_event);
+		if (ret < 0)
+			goto free;
+
+		start = filter_system == start_system &&
+			filter_event == start_event;
+
+		if (start)
+			started = &started_start;
+		else
+			started = &started_end;
+
+		ret = build_filter(synth, start, &expr->filter, started);
+		if (ret < 0)
+			goto free;
+	}
+
 	return synth;
  free:
 	tracefs_synth_free(synth);
-- 
2.30.2

