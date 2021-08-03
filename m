Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BB3C19F34
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F9C61155
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhHCEYf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 00:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233725AbhHCEYI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 00:24:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488DC61183;
        Tue,  3 Aug 2021 04:23:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAly8-002qny-7e; Tue, 03 Aug 2021 00:23:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 20/21] libtracefs: Add CAST() syntax to SQL parsing for histogram types
Date:   Tue,  3 Aug 2021 00:23:46 -0400
Message-Id: <20210803042347.679499-21-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803042347.679499-1-rostedt@goodmis.org>
References: <20210803042347.679499-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Use CAST() command of SQL to define the type of a field for a histogram.

For example:

  SELECT common_pid, id FROM sys_enter

Will only create:

  echo 'hist:keys=common_pid,id' > events/raw_syscalls/sys_enter

that produces the uninteresting:

{ common_pid:       1428 } hitcount:          2
{ common_pid:       1427 } hitcount:          2
{ common_pid:      13684 } hitcount:          2
{ common_pid:       1534 } hitcount:          3
{ common_pid:       1715 } hitcount:          3
{ common_pid:       1334 } hitcount:          4

Use CAST to add the conversions:

  SELECT CAST(common_pid AS comm), CAST(id as syscall) FROM sys_enter

That creates:

  echo 'hist:keys=common_pid.execname,id.syscall' > events/raw_syscalls/sys_enter

Which produces the much more informative histogram:

{ common_pid: bash            [     18116], id: sys_setpgid                   [109] } hitcount:          1
{ common_pid: cat             [     18116], id: sys_munmap                    [ 11] } hitcount:          1
{ common_pid: cat             [     18115], id: sys_exit_group                [231] } hitcount:          1
{ common_pid: cat             [     18115], id: sys_fadvise64                 [221] } hitcount:          1
{ common_pid: wpa_supplicant  [      1437], id: sys_select                    [ 23] } hitcount:          1
{ common_pid: gmain           [      1715], id: sys_poll                      [  7] } hitcount:          1
{ common_pid: cat             [     18116], id: sys_fadvise64                 [221] } hitcount:          1
{ common_pid: gmain           [      1534], id: sys_poll                      [  7] } hitcount:          1
{ common_pid: bash            [     18117], id: sys_getpid                    [ 39] } hitcount:          1
{ common_pid: gmain           [     13684], id: sys_poll                      [  7] } hitcount:          1
{ common_pid: bash            [      1768], id: sys_dup2                      [ 33] } hitcount:          1

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt |  50 ++++++++++++++
 include/tracefs-local.h          |   4 ++
 src/sqlhist-parse.h              |   1 +
 src/sqlhist.l                    |   3 +-
 src/sqlhist.y                    |   8 ++-
 src/tracefs-hist.c               |  82 ++++++++++++++++-------
 src/tracefs-sqlhist.c            | 108 ++++++++++++++++++++++++++++++-
 7 files changed, 226 insertions(+), 30 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index e38ed7649432..314f607fa84e 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -189,6 +189,56 @@ Simple SQL statements without the *JOIN* *ON* may also be used, which will creat
 instead. When doing this, the struct tracefs_hist descriptor can be retrieved from the
 returned synthetic event descriptor via the *tracefs_synth_get_start_hist*(3).
 
+In order to utilize the histogram types (see xxx) the CAST command of SQL can be used.
+
+That is:
+
+[source,c]
+--
+  select CAST(common_pid AS comm, CAST(id AS syscall) FROM sys_enter
+--
+
+Which produces:
+
+[source,c]
+--
+ # echo 'hist:keys=common_pid.execname,id.syscall' > events/raw_syscalls/sys_enter/trigger
+
+ # cat events/raw_syscalls/sys_enter/hist
+
+{ common_pid: bash            [     18248], id: sys_setpgid                   [109] } hitcount:          1
+{ common_pid: sendmail        [      1812], id: sys_read                      [  0] } hitcount:          1
+{ common_pid: bash            [     18247], id: sys_getpid                    [ 39] } hitcount:          1
+{ common_pid: bash            [     18247], id: sys_dup2                      [ 33] } hitcount:          1
+{ common_pid: gmain           [     13684], id: sys_inotify_add_watch         [254] } hitcount:          1
+{ common_pid: cat             [     18247], id: sys_access                    [ 21] } hitcount:          1
+{ common_pid: bash            [     18248], id: sys_getpid                    [ 39] } hitcount:          1
+{ common_pid: cat             [     18247], id: sys_fadvise64                 [221] } hitcount:          1
+{ common_pid: sendmail        [      1812], id: sys_openat                    [257] } hitcount:          1
+{ common_pid: less            [     18248], id: sys_munmap                    [ 11] } hitcount:          1
+{ common_pid: sendmail        [      1812], id: sys_close                     [  3] } hitcount:          1
+{ common_pid: gmain           [      1534], id: sys_poll                      [  7] } hitcount:          1
+{ common_pid: bash            [     18247], id: sys_execve                    [ 59] } hitcount:          1
+--
+
+Note, string fields may not be cast.
+
+The possible types to cast to are:
+
+*HEX* - convert the value to use hex and not decimal
+
+*SYM* - convert a pointer to symbolic (kallsyms values)
+
+*SYM-OFFSET* - convert a pointer to symbolic and include the offset.
+
+*SYSCALL* - convert the number to the mapped system call name
+
+*EXECNAME* or *COMM* - can only be used with the common_pid field. Will show the task
+name of the process.
+
+*LOG* or *LOG2* - bucket the key values in a log 2 values (1, 2, 3-4, 5-8, 9-16, 17-32, ...)
+
+
 RETURN VALUE
 ------------
 Returns 0 on success and -1 on failure. On failure, if _err_ is defined, it will be
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 09288aeac521..07d40b2fae4f 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -88,4 +88,8 @@ int trace_append_filter(char **filter, unsigned int *state,
 struct tracefs_synth *synth_init_from(struct tep_handle *tep,
 				      const char *start_system,
 				      const char *start_event);
+int synth_add_start_field(struct tracefs_synth *synth,
+			  const char *start_field,
+			  const char *name,
+			  enum tracefs_hist_key_type type);
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index 7c1b97ca65af..d5b86cacd8ce 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -65,6 +65,7 @@ int add_where(struct sqlhist_bison *sb, void *expr);
 int add_selection(struct sqlhist_bison *sb, void *item, const char *label);
 int add_from(struct sqlhist_bison *sb, void *item);
 int add_to(struct sqlhist_bison *sb, void *item);
+void *add_cast(struct sqlhist_bison *sb, void *field, const char *type);
 
 void *add_string(struct sqlhist_bison *sb, const char *str);
 void *add_number(struct sqlhist_bison *sb, long val);
diff --git a/src/sqlhist.l b/src/sqlhist.l
index 897daac7d2a8..db0ae1101a58 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -27,9 +27,9 @@ extern int my_yyinput(void *extra, char *buf, int max);
 
 field		\\?[a-z_][a-z0-9_\.]*
 qstring		\"[^\"]*\"
+
 hexnum		0x[0-9a-f]+
 number		[0-9a-f]+
-
 %%
 
 select { HANDLE_COLUMN; return SELECT; }
@@ -38,6 +38,7 @@ from { HANDLE_COLUMN; return FROM; }
 join { HANDLE_COLUMN; return JOIN; }
 on { HANDLE_COLUMN; return ON; }
 where { HANDLE_COLUMN; return WHERE; }
+cast { HANDLE_COLUMN; return CAST; }
 
 {qstring} {
 	HANDLE_COLUMN;
diff --git a/src/sqlhist.y b/src/sqlhist.y
index d5cbecc7bf92..49dac8370359 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -50,8 +50,8 @@ extern void yyerror(struct sqlhist_bison *, char *fmt, ...);
 	void	*expr;
 }
 
-%token AS SELECT FROM JOIN ON WHERE PARSE_ERROR
-%token <number> NUMBER
+%token AS SELECT FROM JOIN ON WHERE PARSE_ERROR CAST
+%token <number> NUMBER field_type
 %token <string> STRING
 %token <string> FIELD
 %token <string> LE GE EQ NEQ AND OR
@@ -107,6 +107,10 @@ selection_expr :
  | '(' field ')'		{  $$ = $2; }
  | selection_addition
  | '(' selection_addition ')'	{  $$ = $2; }
+ | CAST '(' field AS FIELD ')'	{
+					 $$ = add_cast(sb, $3, $5);
+					 CHECK_RETURN_PTR($$);
+				}
  ;
 
 selection_addition :
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index f6f7149b07d4..d62422399552 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -554,6 +554,7 @@ struct tracefs_synth {
 	unsigned int		start_state;
 	unsigned int		end_parens;
 	unsigned int		end_state;
+	int			*start_type;
 	int			arg_cnt;
 };
 
@@ -1056,28 +1057,16 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 	return ret ? -1 : 0;
 }
 
-/**
- * tracefs_synth_add_start_field - add a start field to save
- * @synth: The tracefs_synth descriptor
- * @start_field: The field of the start event to save
- * @name: The name to show in the synthetic event (if NULL @start_field is used)
- *
- * This adds a field named by @start_field of the start event to
- * record in the synthetic event.
- *
- * Returns 0 on succes and -1 on error.
- * On error, errno is set to:
- * ENOMEM - memory allocation failure.
- * ENIVAL - a parameter is passed as NULL that should not be
- * ENODEV - could not find a field
- */
-int tracefs_synth_add_start_field(struct tracefs_synth *synth,
-				  const char *start_field,
-				  const char *name)
+__hidden int synth_add_start_field(struct tracefs_synth *synth,
+				   const char *start_field,
+				   const char *name,
+				   enum tracefs_hist_key_type type)
 {
 	const struct tep_format_field *field;
 	char *start_arg;
 	char **tmp;
+	int *types;
+	int len;
 	int ret;
 
 	if (!synth || !start_field) {
@@ -1108,15 +1097,53 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 		goto out_free;
 
 	tmp = tracefs_list_add(synth->start_selection, start_field);
-	if (tmp)
-		synth->start_selection = tmp;
-	else
+	if (!tmp) {
+		ret = -1;
+		goto out_free;
+	}
+	synth->start_selection = tmp;
+
+	len = tracefs_list_size(tmp);
+	if (len <= 0) { /* ?? */
+		ret = -1;
+		goto out_free;
+	}
+
+	types = realloc(synth->start_type, sizeof(*types) * len);
+	if (!types) {
 		ret = -1;
+		goto out_free;
+	}
+	synth->start_type = types;
+	synth->start_type[len - 1] = type;
+
  out_free:
 	free(start_arg);
 	return ret;
 }
 
+/**
+ * tracefs_synth_add_start_field - add a start field to save
+ * @synth: The tracefs_synth descriptor
+ * @start_field: The field of the start event to save
+ * @name: The name to show in the synthetic event (if NULL @start_field is used)
+ *
+ * This adds a field named by @start_field of the start event to
+ * record in the synthetic event.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find a field
+ */
+int tracefs_synth_add_start_field(struct tracefs_synth *synth,
+				  const char *start_field,
+				  const char *name)
+{
+	return synth_add_start_field(synth, start_field, name, 0);
+}
+
 /**
  * tracefs_synth_add_end_field - add a end field to save
  * @synth: The tracefs_synth descriptor
@@ -1399,6 +1426,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 	const char *event;
 	const char *key;
 	char **keys;
+	int *types;
 	int ret;
 	int i;
 
@@ -1409,6 +1437,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 
 	system = synth->start_event->system;
 	event = synth->start_event->name;
+	types = synth->start_type;
 	keys = synth->start_keys;
 	tep = synth->tep;
 
@@ -1419,22 +1448,25 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 		return NULL;
 
 	for (i = 0; keys[i]; i++) {
+		int type = types ? types[i] : 0;
+
 		key = keys[i];
 
 		if (i) {
-			ret = tracefs_hist_add_key(hist, key, 0);
+			ret = tracefs_hist_add_key(hist, key, type);
 			if (ret < 0) {
 				tracefs_hist_free(hist);
 				return NULL;
 			}
 		} else {
 			hist = tracefs_hist_alloc(tep, system, event,
-						  key, 0);
-			break;
+						  key, type);
+			if (!hist)
+				break;
 		}
 	}
 
-	if (synth->start_filter) {
+	if (hist && synth->start_filter) {
 		hist->filter = strdup(synth->start_filter);
 		if (!hist->filter) {
 			tracefs_hist_free(hist);
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index c4514409645c..88563e98f298 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -9,6 +9,7 @@
 #include <trace-seq.h>
 #include <stdlib.h>
 #include <stdarg.h>
+#include <ctype.h>
 #include <errno.h>
 
 #include "tracefs.h"
@@ -39,6 +40,7 @@ struct field {
 	const char		*raw;
 	const char		*label;
 	const char		*field;
+	const char		*type;
 };
 
 struct filter {
@@ -232,6 +234,16 @@ __hidden char *store_str(struct sqlhist_bison *sb, const char *str)
 	return *pstr;
 }
 
+__hidden void *add_cast(struct sqlhist_bison *sb,
+			void *data, const char *type)
+{
+	struct expr *expr = data;
+	struct field *field = &expr->field;
+
+	field->type = type;
+	return expr;
+}
+
 __hidden int add_selection(struct sqlhist_bison *sb, void *select,
 			   const char *name)
 {
@@ -1204,6 +1216,93 @@ static void where_no_to_error(struct sqlhist_bison *sb, struct expr *expr,
 		    event, from_event);
 }
 
+static int verify_field_type(struct tep_handle *tep,
+			     struct sqlhist_bison *sb,
+			     struct expr *expr)
+{
+	struct field *field = &expr->field;
+	struct tep_event *event;
+	struct tep_format_field *tfield;
+	char *type;
+	int ret;
+	int i;
+
+	if (!field->type)
+		return 0;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	event = tep_find_event_by_name(tep, field->system, field->event);
+	if (!event) {
+		parse_error(sb, field->raw,
+			    "Event '%s' not found\n",
+			    field->event ? : "(null)");
+		return -1;
+	}
+
+	tfield = tep_find_any_field(event, field->field);
+	if (!tfield) {
+		parse_error(sb, field->raw,
+			    "Field '%s' not part of event '%s'\n",
+			    field->field ? : "(null)", field->event);
+		return -1;
+	}
+
+	type = strdup(field->type);
+	if (!type)
+		return -1;
+
+	for (i = 0; type[i]; i++)
+		type[i] = tolower(type[i]);
+
+	if (!strcmp(type, "hex")) {
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_HEX;
+	} else if (!strcmp(type, "sym")) {
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_SYM;
+	} else if (!strcmp(type, "sym-offset")) {
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_SYM_OFFSET;
+	} else if (!strcmp(type, "syscall")) {
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_SYSCALL;
+	} else if (!strcmp(type, "execname") ||
+		   !strcmp(type, "comm")) {
+		ret = TRACEFS_HIST_KEY_EXECNAME;
+		if (strcmp(field->field, "common_pid")) {
+			parse_error(sb, field->raw,
+				    "'%s' is only allowed for common_pid\n",
+				    type);
+			ret = -1;
+		}
+	} else if (!strcmp(type, "log") ||
+		   !strcmp(type, "log2")) {
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_LOG;
+	} else {
+		parse_error(sb, field->raw,
+			    "Cast of '%s' to unknown type '%s'\n",
+			    field->raw, type);
+		ret = -1;
+	}
+	free(type);
+	return ret;
+ fail_type:
+	parse_error(sb, field->raw,
+		    "Field '%s' cast to '%s' but is of type %s\n",
+		    field->field, type, tfield->flags & TEP_FIELD_IS_STRING ?
+		    "string" : "array");
+	free(type);
+	return -1;
+}
+
 static struct tracefs_synth *build_synth(struct tep_handle *tep,
 					 const char *name,
 					 struct sql_table *table)
@@ -1293,8 +1392,13 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 			field = &expr->field;
 			if (field->system == start_system &&
 			    field->event == start_event) {
-				ret = tracefs_synth_add_start_field(synth,
-						field->field, field->label);
+				int type;
+				type = verify_field_type(tep, table->sb, expr);
+				if (type < 0)
+					goto free;
+				ret = synth_add_start_field(synth,
+						field->field, field->label,
+						type);
 			} else if (table->to) {
 				ret = tracefs_synth_add_end_field(synth,
 						field->field, field->label);
-- 
2.30.2

