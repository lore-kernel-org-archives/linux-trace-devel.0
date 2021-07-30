Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9F4C19F39
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9093610CD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhG3WSu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhG3WSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B428061076;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V1O-Hc; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 07/17] libtracefs: Make sqlhist parser reentrant
Date:   Fri, 30 Jul 2021 18:18:14 -0400
Message-Id: <20210730221824.595597-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Update bison and flex to be reentrant, and not depend on any global
variables.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/sqlhist-parse.h   |  3 +--
 src/sqlhist.l         | 26 ++++++++++++++++----------
 src/sqlhist.y         | 10 ++++++++--
 src/tracefs-sqlhist.c | 41 ++++++++++++++++++++++++-----------------
 4 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index 0933bfe9a574..7c1b97ca65af 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -10,6 +10,7 @@ struct str_hash;
 struct sql_table;
 
 struct sqlhist_bison {
+	void			*scanner;
 	const char		*buffer;
 	size_t			buffer_size;
 	size_t			buffer_idx;
@@ -20,8 +21,6 @@ struct sqlhist_bison {
 	struct str_hash         *str_hash[1 << HASH_BITS];
 };
 
-extern struct sqlhist_bison *sb;
-
 #include "sqlhist.tab.h"
 
 enum filter_type {
diff --git a/src/sqlhist.l b/src/sqlhist.l
index 476f7fd1f1ec..958c46051148 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -4,21 +4,26 @@
 #include <stdarg.h>
 #include "sqlhist-parse.h"
 
-extern int my_yyinput(char *buf, int max);
+extern int my_yyinput(void *extra, char *buf, int max);
 
 #undef YY_INPUT
-#define YY_INPUT(b, r, m) ({r = my_yyinput(b, m);})
+#define YY_INPUT(b, r, m) ({r = my_yyinput(yyextra, b, m);})
 
 #define YY_NO_INPUT
 #define YY_NO_UNPUT
 
 #define YY_EXTRA_TYPE struct sqlhist_bison *
 
-#define HANDLE_COLUMN do { sb->line_idx += strlen(yytext); } while (0)
+#define yytext yyg->yytext_r
+
+#define TRACE_SB	((struct sqlhist_bison *)yyextra)
+#define HANDLE_COLUMN do { TRACE_SB->line_idx += strlen(yytext); } while (0)
 
 %}
 
 %option caseless
+%option reentrant
+%option bison-bridge
 
 field		[a-z_][a-z0-9_\.]*
 qstring		\"[^\"]*\"
@@ -36,25 +41,25 @@ where { HANDLE_COLUMN; return WHERE; }
 
 {qstring} {
 	HANDLE_COLUMN;
-	yylval.string = store_str(sb, yytext);
+	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
 	return STRING;
 }
 
 {field} {
 	HANDLE_COLUMN;
-	yylval.string = store_str(sb, yytext);
+	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
 	return FIELD;
 }
 
 {hexnum} {
 	HANDLE_COLUMN;
-	yylval.number = strtol(yytext, NULL, 0);
+	yylval->number = strtol(yyg->yytext_r, NULL, 0);
 	return NUMBER;
 }
 
 {number} {
 	HANDLE_COLUMN;
-	yylval.number = strtol(yytext, NULL, 0);
+	yylval->number = strtol(yyg->yytext_r, NULL, 0);
 	return NUMBER;
 }
 
@@ -69,18 +74,19 @@ where { HANDLE_COLUMN; return WHERE; }
 [\!()\-\+\*/,=] { HANDLE_COLUMN; return yytext[0]; }
 
 [ \t] { HANDLE_COLUMN; }
-\n { sb->line_idx = 0; sb->line_no++; }
+\n { TRACE_SB->line_idx = 0; TRACE_SB->line_no++; }
 
 . { HANDLE_COLUMN; return PARSE_ERROR; }
 %%
 
-int yywrap(void)
+int yywrap(void *data)
 {
 	return 1;
 }
 
-void yyerror(const char *fmt, ...)
+void yyerror(struct sqlhist_bison *sb, char *fmt, ...)
 {
+	struct yyguts_t * yyg = (struct yyguts_t*)sb->scanner;
 	va_list ap;
 
 	va_start(ap, fmt);
diff --git a/src/sqlhist.y b/src/sqlhist.y
index 8dcc824bb9f1..ce9cb58fb3a9 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -6,8 +6,10 @@
 
 #include "sqlhist-parse.h"
 
-extern int yylex(void);
-extern void yyerror(char *fmt, ...);
+#define scanner sb->scanner
+
+extern int yylex(YYSTYPE *yylval, void *);
+extern void yyerror(struct sqlhist_bison *, char *fmt, ...);
 
 #define CHECK_RETURN_PTR(x)					\
 	do {							\
@@ -27,6 +29,10 @@ extern void yyerror(char *fmt, ...);
 
 %}
 
+%define api.pure
+%lex-param {void *scanner}
+%parse-param {struct sqlhist_bison *sb}
+
 %union {
 	int	s32;
 	char	*string;
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index e47bc57c5add..e8f77d60659f 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -14,8 +14,6 @@
 #include "tracefs-local.h"
 #include "sqlhist-parse.h"
 
-struct sqlhist_bison *sb;
-
 extern int yylex_init(void* ptr_yy_globals);
 extern int yylex_init_extra(struct sqlhist_bison *sb, void* ptr_yy_globals);
 extern int yylex_destroy (void * yyscanner );
@@ -98,8 +96,10 @@ struct sql_table {
 	struct expr		**next_selection;
 };
 
-__hidden int my_yyinput(char *buf, int max)
+__hidden int my_yyinput(void *extra, char *buf, int max)
 {
+	struct sqlhist_bison *sb = extra;
+
 	if (!sb || !sb->buffer)
 		return -1;
 
@@ -284,7 +284,8 @@ static struct expr *find_field(struct sqlhist_bison *sb,
 	return NULL;
 }
 
-static void *create_expr(enum expr_type type, struct expr **expr_p)
+static void *create_expr(struct sqlhist_bison *sb,
+			 enum expr_type type, struct expr **expr_p)
 {
 	struct expr *expr;
 
@@ -313,7 +314,7 @@ static void *create_expr(enum expr_type type, struct expr **expr_p)
 
 #define __create_expr(var, type, ENUM, expr)			\
 	do {							\
-		var = (type *)create_expr(EXPR_##ENUM, expr);	\
+		var = (type *)create_expr(sb, EXPR_##ENUM, expr);	\
 	} while(0)
 
 #define create_field(var, expr)				\
@@ -999,8 +1000,8 @@ static void free_sb(struct sqlhist_bison *sb)
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err)
 {
-	struct sqlhist_bison local_sb;
 	struct tracefs_synth *synth = NULL;
+	struct sqlhist_bison sb;
 	int ret;
 
 	if (!tep || !sql_buffer) {
@@ -1008,27 +1009,33 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 		return NULL;
 	}
 
-	memset(&local_sb, 0, sizeof(local_sb));
+	memset(&sb, 0, sizeof(sb));
+
+	sb.buffer = sql_buffer;
+	sb.buffer_size = strlen(sql_buffer);
+	sb.buffer_idx = 0;
 
-	local_sb.buffer = sql_buffer;
-	local_sb.buffer_size = strlen(sql_buffer);
-	local_sb.buffer_idx = 0;
+	ret = yylex_init_extra(&sb, &sb.scanner);
+	if (ret < 0) {
+		yylex_destroy(sb.scanner);
+		return NULL;
+	}
 
-	sb = &local_sb;
-	ret = yyparse();
+	ret = yyparse(&sb);
+	yylex_destroy(sb.scanner);
 
 	if (ret)
 		goto free;
 
-	synth = build_synth(tep, name, sb->table);
+	synth = build_synth(tep, name, sb.table);
 
  free:
 	if (!synth) {
-		if (sb->parse_error_str && err) {
-			*err = sb->parse_error_str;
-			sb->parse_error_str = NULL;
+		if (sb.parse_error_str && err) {
+			*err = sb.parse_error_str;
+			sb.parse_error_str = NULL;
 		}
 	}
-	free_sb(sb);
+	free_sb(&sb);
 	return synth;
 }
-- 
2.30.2

