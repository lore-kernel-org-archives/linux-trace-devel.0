Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8DC1CBEB4
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030355; cv=none; b=HoWWRb4ytgX58eRpLnXU1f+tQBctK/6IIOzCX+Be5O3SGzt6IBGNR37lF5+jfEOhkuEtC/xxv0QxNIqAgHkEf2f0jVIok135V3lk3K5HyS3C/IZcoMfF/G0wJaLs6/5/7tTwlfDo6gIfqus1PlyqGgkBPU2cRmWZFbn8R9NHxZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030355; c=relaxed/simple;
	bh=mtvLdKiLECx7Ks1ssHUEdrh6yinwosiz/NNss0wudOU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BY9Xzhc2Bxs1rN5WRrZpmYdq9LZjfEH62Qg4mtjR/0Q15UerQn9GeVE0AbAacga6SkIT2bqy8vYCk5p14aqNN41PbWst/xdqNeIRnKIHxM/IQY8RWFF7kisvF8FbnvMoM7+TyHah+Xf/wdqjczC81jEfNccata7p+NG8OjNaH5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3A3A1007;
	Tue, 19 Nov 2024 07:33:00 -0800 (PST)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 936303F5A1;
	Tue, 19 Nov 2024 07:32:29 -0800 (PST)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: [PATCH v2] libtracefs: utest: Rename private functions to fix static building
Date: Tue, 19 Nov 2024 15:32:21 +0000
Message-Id: <20241119153221.1668158-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building trace-cmd statically fails because of duplicated symbols for
strstrip() function which is also implemented in trace-cmd. The __hidden
attribute does not resolve these conflicts for static builds due to the
lack of namespacing support in C. Refer to the associated Bugzilla page
for further details.

Although only strstrip() breaks the static build as of now, we should
fix the underlying issue comprehensively across the libtraceevent,
libtracefs, and trace-cmd packages. The recommendation is prepending
"tfs_" to private functions (tagged with __hidden attribute).

Thus:
1. If a private function starts with "trace_", then just change its
   prefix to "tfs_" (e.g., trace_list_pop() to tfs_list_pop()).
2. If prepending "tfs_" prefix to a private function's name clashes with
   an existing one, rename one of the functions per its context (e.g.,
   rename find_tracing_dir() to tfs_find_debug_tracing_dir()).
3. Prepend "tfs_" prefix to all remaining "__hidden" functions as well
   as variables.

Future __hidden functions should follow this prefixing schemed to avoid
new naming conflicts.

Also remove spaces after * in function signatures.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217768
Link: https://lore.kernel.org/linux-trace-devel/20241030204731.69d656d8@rorschach.local.home
Cc: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 include/tracefs-local.h | 110 ++++++++++++++-------------
 include/tracefs.h       |   2 +-
 src/sqlhist-lex.c       |  12 +--
 src/sqlhist-parse.h     |  30 ++++----
 src/sqlhist.l           |  12 +--
 src/sqlhist.tab.c       |  70 ++++++++---------
 src/sqlhist.y           |  70 ++++++++---------
 src/tracefs-dynevents.c |  12 +--
 src/tracefs-eprobes.c   |   2 +-
 src/tracefs-events.c    |  52 +++++++------
 src/tracefs-filter.c    |  69 +++++++++--------
 src/tracefs-hist.c      | 163 ++++++++++++++++++++--------------------
 src/tracefs-instance.c  |  24 +++---
 src/tracefs-kprobes.c   |   2 +-
 src/tracefs-mmap.c      |  12 +--
 src/tracefs-record.c    |  16 ++--
 src/tracefs-sqlhist.c   |  73 +++++++++---------
 src/tracefs-tools.c     |   6 +-
 src/tracefs-uprobes.c   |   2 +-
 src/tracefs-utils.c     |  28 +++----
 utest/tracefs-utest.c   |   6 +-
 21 files changed, 390 insertions(+), 383 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index ffc9d33..056e7ca 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -63,25 +63,25 @@ struct tracefs_buffer_stat {
 	ssize_t				read_events;
 };
 
-extern const struct tep_format_field common_stacktrace;
+extern const struct tep_format_field tfs_common_stacktrace;
 
-extern pthread_mutex_t toplevel_lock;
+extern pthread_mutex_t tfs_toplevel_lock;
 
 static inline pthread_mutex_t *trace_get_lock(struct tracefs_instance *instance)
 {
-	return instance ? &instance->lock : &toplevel_lock;
+	return instance ? &instance->lock : &tfs_toplevel_lock;
 }
 
-void trace_put_instance(struct tracefs_instance *instance);
-int trace_get_instance(struct tracefs_instance *instance);
+void tfs_put_instance(struct tracefs_instance *instance);
+int tfs_get_instance(struct tracefs_instance *instance);
 
 /* Can be overridden */
 void tracefs_warning(const char *fmt, ...);
 
-char *strstrip(char *str);
-int str_read_file(const char *file, char **buffer, bool warn);
-char *trace_append_file(const char *dir, const char *name);
-char *trace_find_tracing_dir(bool debugfs);
+char *tfs_strstrip(char *str);
+int tfs_str_read_file(const char *file, char **buffer, bool warn);
+char *tfs_append_file(const char *dir, const char *name);
+char *tfs_find_tracing_dir(bool debugfs);
 
 #ifndef ACCESSPERMS
 #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
@@ -96,41 +96,43 @@ char *trace_find_tracing_dir(bool debugfs);
 #endif
 
 struct tracefs_options_mask *
-supported_opts_mask(struct tracefs_instance *instance);
+tfs_supported_opts_mask(struct tracefs_instance *instance);
 
 struct tracefs_options_mask *
-enabled_opts_mask(struct tracefs_instance *instance);
-
-char **trace_list_create_empty(void);
-int trace_list_pop(char **list);
-
-char *append_string(char *str, const char *delim, const char *add);
-int trace_test_state(int state);
-bool trace_verify_event_field(struct tep_event *event,
-			      const char *field_name,
-			      const struct tep_format_field **ptr_field);
-int trace_append_filter(char **filter, unsigned int *state,
-			unsigned int *open_parens,
-			struct tep_event *event,
-			enum tracefs_filter type,
-			const char *field_name,
-			enum tracefs_compare compare,
-			 const char *val);
-
-void *trace_mmap(int fd, struct kbuffer *kbuf);
-void trace_unmap(void *mapping);
-int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf);
-int trace_mmap_read(void *mapping, void *buffer);
-
-struct tracefs_synth *synth_init_from(struct tep_handle *tep,
-				      const char *start_system,
-				      const char *start_event);
+tfs_enabled_opts_mask(struct tracefs_instance *instance);
+
+char **tfs_list_create_empty(void);
+int tfs_list_pop(char **list);
+
+char *tfs_append_string(char *str, const char *delim, const char *add);
+int tfs_test_state(int state);
+bool tfs_verify_event_field(struct tep_event *event,
+			    const char *field_name,
+			    const struct tep_format_field **ptr_field);
+int tfs_append_filter(char **filter, unsigned int *state,
+		      unsigned int *open_parens,
+		      struct tep_event *event,
+		      enum tracefs_filter type,
+		      const char *field_name,
+		      enum tracefs_compare compare,
+		      const char *val);
+
+void *tfs_mmap(int fd, struct kbuffer *kbuf);
+void tfs_unmap(void *mapping);
+int tfs_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf);
+int tfs_mmap_read(void *mapping, void *buffer);
+
+struct tracefs_synth *
+tfs_synth_init_from(struct tep_handle *tep,
+		    const char *start_system,
+		    const char *start_event);
 
 #define HIST_COUNTER_TYPE	(TRACEFS_HIST_KEY_MAX + 100)
-int synth_add_start_field(struct tracefs_synth *synth,
-			  const char *start_field,
-			  const char *name,
-			  enum tracefs_hist_key_type type, int cnt);
+int tfs_synth_add_start_field(struct tracefs_synth *synth,
+			      const char *start_field,
+			      const char *name,
+			      enum tracefs_hist_key_type type,
+			      int cnt);
 
 /* Internal interface for ftrace dynamic events */
 
@@ -145,17 +147,21 @@ struct tracefs_dynevent {
 };
 
 struct tracefs_dynevent *
-dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
-	       const char *event, const char *address, const char *format);
-int dynevent_get_count(unsigned int types, const char *system);
-
-int trace_load_events(struct tep_handle *tep,
-		      const char *tracing_dir, const char *system);
-int trace_rescan_events(struct tep_handle *tep,
-			const char *tracing_dir, const char *system);
-struct tep_event *get_tep_event(struct tep_handle *tep,
-				const char *system, const char *name);
-
-unsigned int quick_hash(const char *str);
+tfs_dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
+		   const char *event, const char *address, const char *format);
+int tfs_dynevent_get_count(unsigned int types, const char *system);
+
+int tfs_load_events(struct tep_handle *tep,
+		    const char *tracing_dir,
+		    const char *system);
+int tfs_rescan_events(struct tep_handle *tep,
+		      const char *tracing_dir,
+		      const char *system);
+struct tep_event *
+tfs_get_tep_event(struct tep_handle *tep,
+		  const char *system,
+		  const char *name);
+
+unsigned int tfs_quick_hash(const char *str);
 
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index b6e0f6b..b4e2e30 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -593,7 +593,7 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
-#define TRACEFS_STACKTRACE "common_stacktrace"
+#define TRACEFS_STACKTRACE "tfs_common_stacktrace"
 
 enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_NONE	= 0,
diff --git a/src/sqlhist-lex.c b/src/sqlhist-lex.c
index 5c75280..aaea71c 100644
--- a/src/sqlhist-lex.c
+++ b/src/sqlhist-lex.c
@@ -509,10 +509,10 @@ static const flex_int16_t yy_chk[234] =
 #include <stdarg.h>
 #include "sqlhist-parse.h"
 
-extern int my_yyinput(void *extra, char *buf, int max);
+extern int tfs_my_yyinput(void *extra, char *buf, int max);
 
 #undef YY_INPUT
-#define YY_INPUT(b, r, m) ({r = my_yyinput(yyextra, b, m);})
+#define YY_INPUT(b, r, m) ({r = tfs_my_yyinput(yyextra, b, m);})
 
 #define YY_NO_INPUT
 #define YY_NO_UNPUT
@@ -899,7 +899,7 @@ YY_RULE_SETUP
 #line 43 "sqlhist.l"
 {
 	HANDLE_COLUMN;
-	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
 	return FIELD;
 }
 	YY_BREAK
@@ -909,7 +909,7 @@ YY_RULE_SETUP
 #line 49 "sqlhist.l"
 {
 	HANDLE_COLUMN;
-	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
 	return STRING;
 }
 	YY_BREAK
@@ -920,7 +920,7 @@ YY_RULE_SETUP
 	const char *str = yyg->yytext_r;
 	HANDLE_COLUMN;
 	if (str[0] == '\\') { str++; };
-	yylval->string = store_str(TRACE_SB, str);
+	yylval->string = tfs_store_str(TRACE_SB, str);
 	return FIELD;
 }
 	YY_BREAK
@@ -2198,7 +2198,7 @@ void yyerror(struct sqlhist_bison *sb, char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	sql_parse_error(sb, yytext, fmt, ap);
+	tfs_sql_parse_error(sb, yytext, fmt, ap);
 	va_end(ap);
 }
 
diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index 7bd2a63..5e8d1c8 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -51,27 +51,27 @@ enum compare_type {
 	COMPARE_OR,
 };
 
-char * store_str(struct sqlhist_bison *sb, const char *str);
+char *tfs_store_str(struct sqlhist_bison *sb, const char *str);
 
-int table_start(struct sqlhist_bison *sb);
+int tfs_table_start(struct sqlhist_bison *sb);
 
-void *add_field(struct sqlhist_bison *sb, const char *field, const char *label);
+void *tfs_add_field(struct sqlhist_bison *sb, const char *field, const char *label);
 
-void *add_filter(struct sqlhist_bison *sb, void *A, void *B, enum filter_type op);
+void *tfs_add_filter(struct sqlhist_bison *sb, void *A, void *B, enum filter_type op);
 
-int add_match(struct sqlhist_bison *sb, void *A, void *B);
-void *add_compare(struct sqlhist_bison *sb, void *A, void *B, enum compare_type type);
-int add_where(struct sqlhist_bison *sb, void *expr);
+int tfs_add_match(struct sqlhist_bison *sb, void *A, void *B);
+void *tfs_add_compare(struct sqlhist_bison *sb, void *A, void *B, enum compare_type type);
+int tfs_add_where(struct sqlhist_bison *sb, void *expr);
 
-int add_selection(struct sqlhist_bison *sb, void *item, const char *label);
-int add_from(struct sqlhist_bison *sb, void *item);
-int add_to(struct sqlhist_bison *sb, void *item);
-void *add_cast(struct sqlhist_bison *sb, void *field, const char *type);
+int tfs_add_selection(struct sqlhist_bison *sb, void *item, const char *label);
+int tfs_add_from(struct sqlhist_bison *sb, void *item);
+int tfs_add_to(struct sqlhist_bison *sb, void *item);
+void *tfs_add_cast(struct sqlhist_bison *sb, void *field, const char *type);
 
-void *add_string(struct sqlhist_bison *sb, const char *str);
-void *add_number(struct sqlhist_bison *sb, long val);
+void *tfs_add_string(struct sqlhist_bison *sb, const char *str);
+void *tfs_add_number(struct sqlhist_bison *sb, long val);
 
-extern void sql_parse_error(struct sqlhist_bison *sb, const char *text,
-			    const char *fmt, va_list ap);
+extern void tfs_sql_parse_error(struct sqlhist_bison *sb, const char *text,
+				const char *fmt, va_list ap);
 
 #endif
diff --git a/src/sqlhist.l b/src/sqlhist.l
index 4df475a..86e156e 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -4,10 +4,10 @@
 #include <stdarg.h>
 #include "sqlhist-parse.h"
 
-extern int my_yyinput(void *extra, char *buf, int max);
+extern int tfs_my_yyinput(void *extra, char *buf, int max);
 
 #undef YY_INPUT
-#define YY_INPUT(b, r, m) ({r = my_yyinput(yyextra, b, m);})
+#define YY_INPUT(b, r, m) ({r = tfs_my_yyinput(yyextra, b, m);})
 
 #define YY_NO_INPUT
 #define YY_NO_UNPUT
@@ -42,13 +42,13 @@ cast { HANDLE_COLUMN; return CAST; }
 
 sym-offset {
 	HANDLE_COLUMN;
-	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
 	return FIELD;
 }
 
 {qstring} {
 	HANDLE_COLUMN;
-	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
 	return STRING;
 }
 
@@ -56,7 +56,7 @@ sym-offset {
 	const char *str = yyg->yytext_r;
 	HANDLE_COLUMN;
 	if (str[0] == '\\') { str++; };
-	yylval->string = store_str(TRACE_SB, str);
+	yylval->string = tfs_store_str(TRACE_SB, str);
 	return FIELD;
 }
 
@@ -99,6 +99,6 @@ void yyerror(struct sqlhist_bison *sb, char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	sql_parse_error(sb, yytext, fmt, ap);
+	tfs_sql_parse_error(sb, yytext, fmt, ap);
 	va_end(ap);
 }
diff --git a/src/sqlhist.tab.c b/src/sqlhist.tab.c
index 6393e95..4088519 100644
--- a/src/sqlhist.tab.c
+++ b/src/sqlhist.tab.c
@@ -1323,26 +1323,26 @@ yyreduce:
     {
   case 3:
 #line 78 "sqlhist.y"
-                { CHECK_RETURN_PTR((yyval.string) = store_str(sb, (yyvsp[0].string))); }
+                { CHECK_RETURN_PTR((yyval.string) = tfs_store_str(sb, (yyvsp[0].string))); }
 #line 1328 "sqlhist.tab.c"
     break;
 
   case 4:
 #line 79 "sqlhist.y"
-        { CHECK_RETURN_PTR((yyval.string) = store_str(sb, (yyvsp[0].string))); }
+        { CHECK_RETURN_PTR((yyval.string) = tfs_store_str(sb, (yyvsp[0].string))); }
 #line 1334 "sqlhist.tab.c"
     break;
 
   case 5:
 #line 82 "sqlhist.y"
-                 { table_start(sb); }
+                 { tfs_table_start(sb); }
 #line 1340 "sqlhist.tab.c"
     break;
 
   case 9:
 #line 96 "sqlhist.y"
                                 {
-					CHECK_RETURN_VAL(add_selection(sb, (yyvsp[0].expr), NULL));
+					CHECK_RETURN_VAL(tfs_add_selection(sb, (yyvsp[0].expr), NULL));
 				}
 #line 1348 "sqlhist.tab.c"
     break;
@@ -1350,7 +1350,7 @@ yyreduce:
   case 10:
 #line 100 "sqlhist.y"
                                 {
-					CHECK_RETURN_VAL(add_selection(sb, (yyvsp[-1].expr), (yyvsp[0].string)));
+					CHECK_RETURN_VAL(tfs_add_selection(sb, (yyvsp[-1].expr), (yyvsp[0].string)));
 				}
 #line 1356 "sqlhist.tab.c"
     break;
@@ -1370,7 +1370,7 @@ yyreduce:
   case 15:
 #line 110 "sqlhist.y"
                                 {
-					 (yyval.expr) = add_cast(sb, (yyvsp[-3].expr), (yyvsp[-1].string));
+					 (yyval.expr) = tfs_add_cast(sb, (yyvsp[-3].expr), (yyvsp[-1].string));
 					 CHECK_RETURN_PTR((yyval.expr));
 				}
 #line 1377 "sqlhist.tab.c"
@@ -1379,7 +1379,7 @@ yyreduce:
   case 16:
 #line 118 "sqlhist.y"
                                 {
-					(yyval.expr) = add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_ADD);
+					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_ADD);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
 #line 1386 "sqlhist.tab.c"
@@ -1388,7 +1388,7 @@ yyreduce:
   case 17:
 #line 123 "sqlhist.y"
                                 {
-					(yyval.expr) = add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_SUB);
+					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_SUB);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
 #line 1395 "sqlhist.tab.c"
@@ -1396,163 +1396,163 @@ yyreduce:
 
   case 20:
 #line 135 "sqlhist.y"
-                { (yyval.expr) = add_field(sb, (yyvsp[0].string), NULL); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_field(sb, (yyvsp[0].string), NULL); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1401 "sqlhist.tab.c"
     break;
 
   case 21:
 #line 139 "sqlhist.y"
-               { (yyval.expr) = add_field(sb, (yyvsp[-1].string), (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
+               { (yyval.expr) = tfs_add_field(sb, (yyvsp[-1].string), (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1407 "sqlhist.tab.c"
     break;
 
   case 23:
 #line 147 "sqlhist.y"
-                { (yyval.expr) = add_string(sb, (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_string(sb, (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1413 "sqlhist.tab.c"
     break;
 
   case 25:
 #line 152 "sqlhist.y"
-                { (yyval.expr) = add_number(sb, (yyvsp[0].number)); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_number(sb, (yyvsp[0].number)); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1419 "sqlhist.tab.c"
     break;
 
   case 26:
 #line 157 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LT); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LT); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1425 "sqlhist.tab.c"
     break;
 
   case 27:
 #line 158 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GT); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GT); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1431 "sqlhist.tab.c"
     break;
 
   case 28:
 #line 159 "sqlhist.y"
-                { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LE); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LE); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1437 "sqlhist.tab.c"
     break;
 
   case 29:
 #line 160 "sqlhist.y"
-                { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GE); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GE); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1443 "sqlhist.tab.c"
     break;
 
   case 30:
 #line 161 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1449 "sqlhist.tab.c"
     break;
 
   case 31:
 #line 162 "sqlhist.y"
-                { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
+                { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1455 "sqlhist.tab.c"
     break;
 
   case 32:
 #line 163 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1461 "sqlhist.tab.c"
     break;
 
   case 33:
 #line 164 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1467 "sqlhist.tab.c"
     break;
 
   case 34:
 #line 165 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_BIN_AND); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_BIN_AND); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1473 "sqlhist.tab.c"
     break;
 
   case 35:
 #line 166 "sqlhist.y"
-                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_STR_CMP); CHECK_RETURN_PTR((yyval.expr)); }
+                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_STR_CMP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1479 "sqlhist.tab.c"
     break;
 
   case 36:
 #line 170 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1485 "sqlhist.tab.c"
     break;
 
   case 37:
 #line 171 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_AND); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_AND); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1491 "sqlhist.tab.c"
     break;
 
   case 38:
 #line 172 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1497 "sqlhist.tab.c"
     break;
 
   case 39:
 #line 173 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1503 "sqlhist.tab.c"
     break;
 
   case 41:
 #line 178 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1509 "sqlhist.tab.c"
     break;
 
   case 42:
 #line 179 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1515 "sqlhist.tab.c"
     break;
 
   case 43:
 #line 180 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1521 "sqlhist.tab.c"
     break;
 
   case 44:
 #line 181 "sqlhist.y"
-                                        { (yyval.expr) = add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
+                                        { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
 #line 1527 "sqlhist.tab.c"
     break;
 
   case 46:
 #line 186 "sqlhist.y"
-                                { CHECK_RETURN_VAL(add_where(sb, (yyvsp[0].expr))); }
+                                { CHECK_RETURN_VAL(tfs_add_where(sb, (yyvsp[0].expr))); }
 #line 1533 "sqlhist.tab.c"
     break;
 
   case 56:
 #line 219 "sqlhist.y"
-                        { CHECK_RETURN_VAL(add_from(sb, (yyvsp[0].expr))); }
+                        { CHECK_RETURN_VAL(tfs_add_from(sb, (yyvsp[0].expr))); }
 #line 1539 "sqlhist.tab.c"
     break;
 
   case 57:
 #line 234 "sqlhist.y"
-                                { add_to(sb, (yyvsp[-2].expr)); }
+                                { tfs_add_to(sb, (yyvsp[-2].expr)); }
 #line 1545 "sqlhist.tab.c"
     break;
 
   case 58:
 #line 238 "sqlhist.y"
-                 { CHECK_RETURN_VAL(add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
+                 { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
 #line 1551 "sqlhist.tab.c"
     break;
 
   case 59:
 #line 239 "sqlhist.y"
-                { CHECK_RETURN_VAL(add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
+                { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
 #line 1557 "sqlhist.tab.c"
     break;
 
diff --git a/src/sqlhist.y b/src/sqlhist.y
index fade9a4..7caa364 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -75,11 +75,11 @@ start :
    select_statement
  ;
 
-label : AS name { CHECK_RETURN_PTR($$ = store_str(sb, $2)); }
- | name { CHECK_RETURN_PTR($$ = store_str(sb, $1)); }
+label : AS name { CHECK_RETURN_PTR($$ = tfs_store_str(sb, $2)); }
+ | name { CHECK_RETURN_PTR($$ = tfs_store_str(sb, $1)); }
  ;
 
-select : SELECT  { table_start(sb); }
+select : SELECT  { tfs_table_start(sb); }
   ;
 
 select_statement :
@@ -94,11 +94,11 @@ selection_list :
 selection :
     selection_expr
 				{
-					CHECK_RETURN_VAL(add_selection(sb, $1, NULL));
+					CHECK_RETURN_VAL(tfs_add_selection(sb, $1, NULL));
 				}
   | selection_expr label
 				{
-					CHECK_RETURN_VAL(add_selection(sb, $1, $2));
+					CHECK_RETURN_VAL(tfs_add_selection(sb, $1, $2));
 				}
   ;
 
@@ -108,7 +108,7 @@ selection_expr :
  | selection_addition
  | '(' selection_addition ')'	{  $$ = $2; }
  | CAST '(' field AS FIELD ')'	{
-					 $$ = add_cast(sb, $3, $5);
+					 $$ = tfs_add_cast(sb, $3, $5);
 					 CHECK_RETURN_PTR($$);
 				}
  ;
@@ -116,12 +116,12 @@ selection_expr :
 selection_addition :
    field '+' field
 				{
-					$$ = add_compare(sb, $1, $3, COMPARE_ADD);
+					$$ = tfs_add_compare(sb, $1, $3, COMPARE_ADD);
 					CHECK_RETURN_PTR($$);
 				}
  | field '-' field
 				{
-					$$ = add_compare(sb, $1, $3, COMPARE_SUB);
+					$$ = tfs_add_compare(sb, $1, $3, COMPARE_SUB);
 					CHECK_RETURN_PTR($$);
 				}
  ;
@@ -132,11 +132,11 @@ item :
  ;
 
 field :
-   FIELD	{ $$ = add_field(sb, $1, NULL); CHECK_RETURN_PTR($$); }
+   FIELD	{ $$ = tfs_add_field(sb, $1, NULL); CHECK_RETURN_PTR($$); }
  ;
 
 named_field :
-   FIELD label { $$ = add_field(sb, $1, $2); CHECK_RETURN_PTR($$); }
+   FIELD label { $$ = tfs_add_field(sb, $1, $2); CHECK_RETURN_PTR($$); }
  ;
 
 name :
@@ -144,46 +144,46 @@ name :
  ;
 
 str_val :
-   STRING	{ $$ = add_string(sb, $1); CHECK_RETURN_PTR($$); }
+   STRING	{ $$ = tfs_add_string(sb, $1); CHECK_RETURN_PTR($$); }
  ;
 
 val :
    str_val
- | NUMBER	{ $$ = add_number(sb, $1); CHECK_RETURN_PTR($$); }
+ | NUMBER	{ $$ = tfs_add_number(sb, $1); CHECK_RETURN_PTR($$); }
  ;
 
 
 compare :
-   field '<' val	{ $$ = add_filter(sb, $1, $3, FILTER_LT); CHECK_RETURN_PTR($$); }
- | field '>' val	{ $$ = add_filter(sb, $1, $3, FILTER_GT); CHECK_RETURN_PTR($$); }
- | field LE val	{ $$ = add_filter(sb, $1, $3, FILTER_LE); CHECK_RETURN_PTR($$); }
- | field GE val	{ $$ = add_filter(sb, $1, $3, FILTER_GE); CHECK_RETURN_PTR($$); }
- | field '=' val	{ $$ = add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
- | field EQ val	{ $$ = add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
- | field NEQ val	{ $$ = add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
- | field "!=" val	{ $$ = add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
- | field '&' val	{ $$ = add_filter(sb, $1, $3, FILTER_BIN_AND); CHECK_RETURN_PTR($$); }
- | field '~' str_val	{ $$ = add_filter(sb, $1, $3, FILTER_STR_CMP); CHECK_RETURN_PTR($$); }
+   field '<' val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_LT); CHECK_RETURN_PTR($$); }
+ | field '>' val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_GT); CHECK_RETURN_PTR($$); }
+ | field LE val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_LE); CHECK_RETURN_PTR($$); }
+ | field GE val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_GE); CHECK_RETURN_PTR($$); }
+ | field '=' val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
+ | field EQ val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_EQ); CHECK_RETURN_PTR($$); }
+ | field NEQ val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
+ | field "!=" val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_NE); CHECK_RETURN_PTR($$); }
+ | field '&' val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_BIN_AND); CHECK_RETURN_PTR($$); }
+ | field '~' str_val	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_STR_CMP); CHECK_RETURN_PTR($$); }
 ;
 
 compare_and_or :
-   compare_and_or OR compare_and_or	{ $$ = add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
- | compare_and_or AND compare_and_or	{ $$ = add_filter(sb, $1, $3, FILTER_AND); CHECK_RETURN_PTR($$); }
- | '!' '(' compare_and_or ')'		{ $$ = add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
- | '!' compare				{ $$ = add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+   compare_and_or OR compare_and_or	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
+ | compare_and_or AND compare_and_or	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_AND); CHECK_RETURN_PTR($$); }
+ | '!' '(' compare_and_or ')'		{ $$ = tfs_add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' compare				{ $$ = tfs_add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
  | compare
  ;
 
 compare_items :
-   compare_items OR compare_items	{ $$ = add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
- | '(' compare_and_or ')'		{ $$ = add_filter(sb, $2, NULL, FILTER_GROUP); CHECK_RETURN_PTR($$); }
- | '!' '(' compare_and_or ')'		{ $$ = add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
- | '!' compare				{ $$ = add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+   compare_items OR compare_items	{ $$ = tfs_add_filter(sb, $1, $3, FILTER_OR); CHECK_RETURN_PTR($$); }
+ | '(' compare_and_or ')'		{ $$ = tfs_add_filter(sb, $2, NULL, FILTER_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' '(' compare_and_or ')'		{ $$ = tfs_add_filter(sb, $3, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
+ | '!' compare				{ $$ = tfs_add_filter(sb, $2, NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR($$); }
  | compare
  ;
 
 compare_cmds :
-   compare_items		{ CHECK_RETURN_VAL(add_where(sb, $1)); }
+   compare_items		{ CHECK_RETURN_VAL(tfs_add_where(sb, $1)); }
  ;
 
 /*
@@ -216,7 +216,7 @@ table_exp :
  ;
 
 from_clause :
-   FROM item		{ CHECK_RETURN_VAL(add_from(sb, $2)); }
+   FROM item		{ CHECK_RETURN_VAL(tfs_add_from(sb, $2)); }
 
 /*
  * Select from a from clause confuses the variable parsing.
@@ -231,12 +231,12 @@ from_clause :
  ;
 
 join_clause :
- JOIN item ON match_clause	{ add_to(sb, $2); }
+ JOIN item ON match_clause	{ tfs_add_to(sb, $2); }
  ;
 
 match :
-   item '=' item { CHECK_RETURN_VAL(add_match(sb, $1, $3)); }
- | item EQ item { CHECK_RETURN_VAL(add_match(sb, $1, $3)); }
+   item '=' item { CHECK_RETURN_VAL(tfs_add_match(sb, $1, $3)); }
+ | item EQ item { CHECK_RETURN_VAL(tfs_add_match(sb, $1, $3)); }
 
  ;
 
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 6df7212..9b61d9d 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -306,7 +306,7 @@ static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
 }
 
 /**
- * dynevent_alloc - Allocate new dynamic event
+ * tfs_dynevent_alloc - Allocate new dynamic event
  * @type: Type of the dynamic event
  * @system: The system name (NULL for the default dynamic)
  * @event: Name of the event
@@ -326,8 +326,8 @@ static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
  * errno will be set to EINVAL if event is NULL.
  */
 __hidden struct tracefs_dynevent *
-dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
-	       const char *event, const char *address, const char *format)
+tfs_dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
+		   const char *event, const char *address, const char *format)
 {
 	struct tracefs_dynevent *devent;
 	struct dyn_events_desc *desc;
@@ -688,7 +688,7 @@ int tracefs_dynevent_destroy_all(unsigned int types, bool force)
 }
 
 /**
- * dynevent_get_count - Count dynamic events of given types and system
+ * tfs_dynevent_get_count - Count dynamic events of given types and system
  * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
  *	   are considered.
  * @system: Count events from that system only. If @system is NULL, events from all systems
@@ -696,7 +696,7 @@ int tracefs_dynevent_destroy_all(unsigned int types, bool force)
  *
  * Return the count of requested dynamic events
  */
-__hidden int dynevent_get_count(unsigned int types, const char *system)
+__hidden int tfs_dynevent_get_count(unsigned int types, const char *system)
 {
 	int count, all = 0;
 	int i;
@@ -787,5 +787,5 @@ tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dyne
 	if (!tep || !dynevent || !dynevent->event)
 		return NULL;
 
-	return get_tep_event(tep, dynevent->system, dynevent->event);
+	return tfs_get_tep_event(tep, dynevent->system, dynevent->event);
 }
diff --git a/src/tracefs-eprobes.c b/src/tracefs-eprobes.c
index cc25f8e..b4b9b8e 100644
--- a/src/tracefs-eprobes.c
+++ b/src/tracefs-eprobes.c
@@ -48,7 +48,7 @@ tracefs_eprobe_alloc(const char *system, const char *event,
 	if (asprintf(&target, "%s.%s", target_system, target_event) < 0)
 		return NULL;
 
-	kp = dynevent_alloc(TRACEFS_DYNEVENT_EPROBE, system, event, target, fetchargs);
+	kp = tfs_dynevent_alloc(TRACEFS_DYNEVENT_EPROBE, system, event, target, fetchargs);
 	free(target);
 
 	return kp;
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 77d1ba8..5515d15 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -603,7 +603,7 @@ static int add_list_string(char ***list, const char *name)
 	return 0;
 }
 
-__hidden char *trace_append_file(const char *dir, const char *name)
+__hidden char *tfs_append_file(const char *dir, const char *name)
 {
 	char *file;
 	int ret;
@@ -819,7 +819,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	events_dir = trace_append_file(tracing_dir, "events");
+	events_dir = tfs_append_file(tracing_dir, "events");
 	if (!events_dir)
 		return NULL;
 
@@ -844,14 +844,14 @@ char **tracefs_event_systems(const char *tracing_dir)
 		    strcmp(name, "..") == 0)
 			continue;
 
-		sys = trace_append_file(events_dir, name);
+		sys = tfs_append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
 			free(sys);
 			continue;
 		}
 
-		enable = trace_append_file(sys, "enable");
+		enable = tfs_append_file(sys, "enable");
 
 		ret = stat(enable, &st);
 		free(enable);
@@ -913,7 +913,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 		    strcmp(name, "..") == 0)
 			continue;
 
-		event = trace_append_file(system_dir, name);
+		event = tfs_append_file(system_dir, name);
 		ret = stat(event, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
 			free(event);
@@ -951,7 +951,7 @@ static char **list_tracers(const char *tracing_dir)
 	if (!tracing_dir)
 		return NULL;
 
-	available_tracers = trace_append_file(tracing_dir, "available_tracers");
+	available_tracers = tfs_append_file(tracing_dir, "available_tracers");
 	if (!available_tracers)
 		return NULL;
 
@@ -959,7 +959,7 @@ static char **list_tracers(const char *tracing_dir)
 	if (ret < 0)
 		goto out_free;
 
-	len = str_read_file(available_tracers, &buf, true);
+	len = tfs_str_read_file(available_tracers, &buf, true);
 	if (len <= 0)
 		goto out_free;
 
@@ -1063,7 +1063,7 @@ static int load_events(struct tep_handle *tep,
 		if (check && tep_find_event_by_name(tep, system, events[i]))
 			goto next_event;
 
-		len = str_read_file(format, &buf, true);
+		len = tfs_str_read_file(format, &buf, true);
 		if (len <= 0)
 			goto next_event;
 
@@ -1079,21 +1079,25 @@ next_event:
 	return failure;
 }
 
-__hidden int trace_rescan_events(struct tep_handle *tep,
-				const char *tracing_dir, const char *system)
+__hidden int tfs_rescan_events(struct tep_handle *tep,
+			       const char *tracing_dir,
+			       const char *system)
 {
 	/* ToDo: add here logic for deleting removed events from tep handle */
 	return load_events(tep, tracing_dir, system, true);
 }
 
-__hidden int trace_load_events(struct tep_handle *tep,
-			       const char *tracing_dir, const char *system)
+__hidden int tfs_load_events(struct tep_handle *tep,
+			     const char *tracing_dir,
+			     const char *system)
 {
 	return load_events(tep, tracing_dir, system, false);
 }
 
-__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
-					 const char *system, const char *name)
+__hidden struct tep_event *
+tfs_get_tep_event(struct tep_handle *tep,
+		  const char *system,
+		  const char *name)
 {
 	struct tep_event *event;
 
@@ -1107,7 +1111,7 @@ __hidden struct tep_event *get_tep_event(struct tep_handle *tep,
 		return event;
 
 	/* Try to load any new events from the given system */
-	if (trace_rescan_events(tep, NULL, system))
+	if (tfs_rescan_events(tep, NULL, system))
 		return NULL;
 
 	return tep_find_event_by_name(tep, system, name);
@@ -1121,13 +1125,13 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 	int len;
 	int ret = -1;
 
-	header = trace_append_file(tracing_dir, "events/header_page");
+	header = tfs_append_file(tracing_dir, "events/header_page");
 
 	ret = stat(header, &st);
 	if (ret < 0)
 		goto out;
 
-	len = str_read_file(header, &buf, true);
+	len = tfs_str_read_file(header, &buf, true);
 	if (len <= 0)
 		goto out;
 
@@ -1155,7 +1159,7 @@ static void load_kallsyms(struct tep_handle *tep)
 {
 	char *buf;
 
-	if (str_read_file("/proc/kallsyms", &buf, false) <= 0)
+	if (tfs_str_read_file("/proc/kallsyms", &buf, false) <= 0)
 		return;
 
 	tep_parse_kallsyms(tep, buf);
@@ -1169,11 +1173,11 @@ static int load_saved_cmdlines(const char *tracing_dir,
 	char *buf;
 	int ret;
 
-	path = trace_append_file(tracing_dir, "saved_cmdlines");
+	path = tfs_append_file(tracing_dir, "saved_cmdlines");
 	if (!path)
 		return -1;
 
-	ret = str_read_file(path, &buf, false);
+	ret = tfs_str_read_file(path, &buf, false);
 	free(path);
 	if (ret <= 0)
 		return -1;
@@ -1191,11 +1195,11 @@ static void load_printk_formats(const char *tracing_dir,
 	char *buf;
 	int ret;
 
-	path = trace_append_file(tracing_dir, "printk_formats");
+	path = tfs_append_file(tracing_dir, "printk_formats");
 	if (!path)
 		return;
 
-	ret = str_read_file(path, &buf, false);
+	ret = tfs_str_read_file(path, &buf, false);
 	free(path);
 	if (ret <= 0)
 		return;
@@ -1289,14 +1293,14 @@ static int fill_local_events_system(const char *tracing_dir,
 	for (i = 0; systems[i]; i++) {
 		if (sys_names && !contains(systems[i], sys_names))
 			continue;
-		ret = trace_load_events(tep, tracing_dir, systems[i]);
+		ret = tfs_load_events(tep, tracing_dir, systems[i]);
 		if (ret && parsing_failures)
 			(*parsing_failures)++;
 	}
 
 	/* Include ftrace, as it is excluded for not having "enable" file */
 	if (!sys_names || contains("ftrace", sys_names))
-		trace_load_events(tep, tracing_dir, "ftrace");
+		tfs_load_events(tep, tracing_dir, "ftrace");
 
 	load_mappings(tracing_dir, tep);
 
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 1b1c60e..f1de372 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -41,7 +41,7 @@ static const struct tep_format_field common_comm = {
 	.size			= 16,
 };
 
-const struct tep_format_field common_stacktrace __hidden = {
+const struct tep_format_field tfs_common_stacktrace __hidden = {
 	.type			= "unsigned long[]",
 	.name			= "stacktrace",
 	.size			= 4,
@@ -52,8 +52,9 @@ const struct tep_format_field common_stacktrace __hidden = {
  * This also must be able to accept fields that are OK via the histograms,
  * such as common_timestamp.
  */
-static const struct tep_format_field *get_event_field(struct tep_event *event,
-					 const char *field_name)
+static const struct tep_format_field *
+get_event_field(struct tep_event *event,
+		const char *field_name)
 {
 	const struct tep_format_field *field;
 
@@ -64,7 +65,7 @@ static const struct tep_format_field *get_event_field(struct tep_event *event,
 		return &common_timestamp_usecs;
 
 	if (!strcmp(field_name, TRACEFS_STACKTRACE))
-		return &common_stacktrace;
+		return &tfs_common_stacktrace;
 
 	field = tep_find_any_field(event, field_name);
 	if (!field && (!strcmp(field_name, "COMM") || !strcmp(field_name, "comm")))
@@ -74,9 +75,9 @@ static const struct tep_format_field *get_event_field(struct tep_event *event,
 }
 
 __hidden bool
-trace_verify_event_field(struct tep_event *event,
-			 const char *field_name,
-			 const struct tep_format_field **ptr_field)
+tfs_verify_event_field(struct tep_event *event,
+		       const char *field_name,
+		       const struct tep_format_field **ptr_field)
 {
 	const struct tep_format_field *field;
 
@@ -92,7 +93,7 @@ trace_verify_event_field(struct tep_event *event,
 	return true;
 }
 
-__hidden int trace_test_state(int state)
+__hidden int tfs_test_state(int state)
 {
 	switch (state) {
 	case S_START:
@@ -146,7 +147,7 @@ static int append_filter(char **filter, unsigned int *state,
 		tmp = strdup(*filter);
 		if (!tmp)
 			return -1;
-		tmp = append_string(tmp, NULL, conj);
+		tmp = tfs_append_string(tmp, NULL, conj);
 		if (!tmp)
 			return -1;
 		free(*filter);
@@ -166,7 +167,7 @@ static int append_filter(char **filter, unsigned int *state,
 		}
 		if (*filter) {
 			tmp = strdup(*filter);
-			tmp = append_string(tmp, NULL, "!");
+			tmp = tfs_append_string(tmp, NULL, "!");
 		} else {
 			tmp = strdup("!");
 		}
@@ -189,7 +190,7 @@ static int append_filter(char **filter, unsigned int *state,
 		}
 		if (*filter) {
 			tmp = strdup(*filter);
-			tmp = append_string(tmp, NULL, "(");
+			tmp = tfs_append_string(tmp, NULL, "(");
 		} else {
 			tmp = strdup("(");
 		}
@@ -215,7 +216,7 @@ static int append_filter(char **filter, unsigned int *state,
 		tmp = strdup(*filter);
 		if (!tmp)
 			return -1;
-		tmp = append_string(tmp, NULL, ")");
+		tmp = tfs_append_string(tmp, NULL, ")");
 		if (!tmp)
 			return -1;
 		free(*filter);
@@ -228,7 +229,7 @@ static int append_filter(char **filter, unsigned int *state,
 	if (!field_name || !val)
 		goto inval;
 
-	if (!trace_verify_event_field(event, field_name, &field))
+	if (!tfs_verify_event_field(event, field_name, &field))
 		return -1;
 
 	is_string = field->flags & TEP_FIELD_IS_STRING;
@@ -240,18 +241,18 @@ static int append_filter(char **filter, unsigned int *state,
 		tmp = strdup(*filter);
 		if (!tmp)
 			return -1;
-		tmp = append_string(tmp, NULL, field_name);
+		tmp = tfs_append_string(tmp, NULL, field_name);
 	} else {
 		tmp = strdup(field_name);
 	}
 
 	switch (compare) {
-	case TRACEFS_COMPARE_EQ: tmp = append_string(tmp, NULL, " == "); break;
-	case TRACEFS_COMPARE_NE: tmp = append_string(tmp, NULL, " != "); break;
+	case TRACEFS_COMPARE_EQ: tmp = tfs_append_string(tmp, NULL, " == "); break;
+	case TRACEFS_COMPARE_NE: tmp = tfs_append_string(tmp, NULL, " != "); break;
 	case TRACEFS_COMPARE_RE:
 		if (!is_string)
 			goto free;
-		tmp = append_string(tmp, NULL, "~");
+		tmp = tfs_append_string(tmp, NULL, "~");
 		break;
 	default:
 		if (is_string)
@@ -259,15 +260,15 @@ static int append_filter(char **filter, unsigned int *state,
 	}
 
 	switch (compare) {
-	case TRACEFS_COMPARE_GT: tmp = append_string(tmp, NULL, " > "); break;
-	case TRACEFS_COMPARE_GE: tmp = append_string(tmp, NULL, " >= "); break;
-	case TRACEFS_COMPARE_LT: tmp = append_string(tmp, NULL, " < "); break;
-	case TRACEFS_COMPARE_LE: tmp = append_string(tmp, NULL, " <= "); break;
-	case TRACEFS_COMPARE_AND: tmp = append_string(tmp, NULL, " & "); break;
+	case TRACEFS_COMPARE_GT: tmp = tfs_append_string(tmp, NULL, " > "); break;
+	case TRACEFS_COMPARE_GE: tmp = tfs_append_string(tmp, NULL, " >= "); break;
+	case TRACEFS_COMPARE_LT: tmp = tfs_append_string(tmp, NULL, " < "); break;
+	case TRACEFS_COMPARE_LE: tmp = tfs_append_string(tmp, NULL, " <= "); break;
+	case TRACEFS_COMPARE_AND: tmp = tfs_append_string(tmp, NULL, " & "); break;
 	default: break;
 	}
 
-	tmp = append_string(tmp, NULL, val);
+	tmp = tfs_append_string(tmp, NULL, val);
 
 	if (!tmp)
 		return -1;
@@ -349,13 +350,15 @@ static int count_parens(char *filter, unsigned int *state)
 	return open;
 }
 
-__hidden int trace_append_filter(char **filter, unsigned int *state,
-			 unsigned int *open_parens,
-			 struct tep_event *event,
-			 enum tracefs_filter type,
-			 const char *field_name,
-			 enum tracefs_compare compare,
-			 const char *val)
+__hidden int
+tfs_append_filter(char **filter,
+		  unsigned int *state,
+		  unsigned int *open_parens,
+		  struct tep_event *event,
+		  enum tracefs_filter type,
+		  const char *field_name,
+		  enum tracefs_compare compare,
+		  const char *val)
 {
 	return append_filter(filter, state, open_parens, event, type,
 			     field_name, compare, val);
@@ -485,9 +488,9 @@ static int error_msg(char **err, char *str,
 	ws[i+1] = '\0';
 
 	errmsg = strdup(filter);
-	errmsg = append_string(errmsg, "\n", ws);
-	errmsg = append_string(errmsg, "\n", msg);
-	errmsg = append_string(errmsg, NULL, "\n");
+	errmsg = tfs_append_string(errmsg, "\n", ws);
+	errmsg = tfs_append_string(errmsg, "\n", msg);
+	errmsg = tfs_append_string(errmsg, NULL, "\n");
 
 	*err = errmsg;
 	return -1;
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 4f4971e..0ea8312 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -703,10 +703,9 @@ int tracefs_hist_append_filter(struct tracefs_hist *hist,
 			       enum tracefs_compare compare,
 			       const char *val)
 {
-	return trace_append_filter(&hist->filter, &hist->filter_state,
-				   &hist->filter_parens,
-				   hist->event,
-				   type, field, compare, val);
+	return tfs_append_filter(&hist->filter, &hist->filter_state,
+				 &hist->filter_parens, hist->event, type,
+				 field, compare, val);
 }
 
 enum action_type {
@@ -870,13 +869,11 @@ static bool verify_event_fields(struct tep_event *start_event,
 	const struct tep_format_field *end_field;
 	int start_flags, end_flags;
 
-	if (!trace_verify_event_field(start_event, start_field_name,
-				      &start_field))
+	if (!tfs_verify_event_field(start_event, start_field_name, &start_field))
 		return false;
 
 	if (end_event) {
-		if (!trace_verify_event_field(end_event, end_field_name,
-					      &end_field))
+		if (!tfs_verify_event_field(end_event, end_field_name, &end_field))
 			return false;
 
 		/* A pointer can still match a long */
@@ -896,7 +893,7 @@ static bool verify_event_fields(struct tep_event *start_event,
 	return true;
 }
 
-__hidden char *append_string(char *str, const char *space, const char *add)
+__hidden char *tfs_append_string(char *str, const char *space, const char *add)
 {
 	char *new;
 	int len;
@@ -934,14 +931,14 @@ static char *add_synth_field(const struct tep_format_field *field,
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		str = strdup(field->type);
 		str = strtok(str, "[");
-		str = append_string(str, " ", name);
-		str = append_string(str, NULL, "[");
+		str = tfs_append_string(str, " ", name);
+		str = tfs_append_string(str, NULL, "[");
 
 		if (!(field->flags & TEP_FIELD_IS_DYNAMIC)) {
 			snprintf(size, 64, "%d", field->size);
-			str = append_string(str, NULL, size);
+			str = tfs_append_string(str, NULL, size);
 		}
-		return append_string(str, NULL, "];");
+		return tfs_append_string(str, NULL, "];");
 	}
 
 	/* Synthetic events understand pid_t, gfp_t and bool */
@@ -949,8 +946,8 @@ static char *add_synth_field(const struct tep_format_field *field,
 	    strcmp(field->type, "gfp_t") == 0 ||
 	    strcmp(field->type, "bool") == 0) {
 		str = strdup(field->type);
-		str = append_string(str, " ", name);
-		return append_string(str, NULL, ";");
+		str = tfs_append_string(str, " ", name);
+		return tfs_append_string(str, NULL, ";");
 	}
 
 	sign = field->flags & TEP_FIELD_IS_SIGNED;
@@ -985,12 +982,12 @@ static char *add_synth_field(const struct tep_format_field *field,
 		return NULL;
 	}
 
-	if (field == &common_stacktrace)
+	if (field == &tfs_common_stacktrace)
 		type = field->type;
 
 	str = strdup(type);
-	str = append_string(str, " ", name);
-	return append_string(str, NULL, ";");
+	str = tfs_append_string(str, " ", name);
+	return tfs_append_string(str, NULL, ";");
 }
 
 static int add_var(char ***list, const char *name, const char *var, bool is_var)
@@ -1017,8 +1014,9 @@ static int add_var(char ***list, const char *name, const char *var, bool is_var)
 }
 
 __hidden struct tracefs_synth *
-synth_init_from(struct tep_handle *tep, const char *start_system,
-		const char *start_event_name)
+tfs_synth_init_from(struct tep_handle *tep,
+		    const char *start_system,
+		    const char *start_event_name)
 {
 	struct tep_event *start_event;
 	struct tracefs_synth *synth;
@@ -1056,11 +1054,11 @@ static int alloc_synthetic_event(struct tracefs_synth *synth)
 
 	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
 		field = synth->synthetic_fields[i];
-		format = append_string(format, i ? " " : NULL, field);
+		format = tfs_append_string(format, i ? " " : NULL, field);
 	}
 
-	synth->dyn_event = dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, SYNTHETIC_GROUP,
-					  synth->name, NULL, format);
+	synth->dyn_event = tfs_dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, SYNTHETIC_GROUP,
+					      synth->name, NULL, format);
 	free(format);
 
 	return synth->dyn_event ? 0 : -1;
@@ -1150,7 +1148,7 @@ struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 		return NULL;
 	}
 
-	synth = synth_init_from(tep, start_system, start_event_name);
+	synth = tfs_synth_init_from(tep, start_system, start_event_name);
 	if (!synth)
 		return NULL;
 
@@ -1201,14 +1199,14 @@ static int add_synth_fields(struct tracefs_synth *synth,
 
 	ret = asprintf(&str, "$%s", var ? : name);
 	if (ret < 0) {
-		trace_list_pop(synth->synthetic_fields);
+		tfs_list_pop(synth->synthetic_fields);
 		return -1;
 	}
 
 	list = tracefs_list_add(synth->synthetic_args, str);
 	free(str);
 	if (!list) {
-		trace_list_pop(synth->synthetic_fields);
+		tfs_list_pop(synth->synthetic_fields);
 		return -1;
 	}
 
@@ -1261,7 +1259,7 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 
 	list = tracefs_list_add(synth->end_keys, end_match_field);
 	if (!list) {
-		trace_list_pop(synth->start_keys);
+		tfs_list_pop(synth->start_keys);
 		return -1;
 	}
 	synth->end_keys = list;
@@ -1281,8 +1279,8 @@ int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 	return 0;
 
  pop_lists:
-	trace_list_pop(synth->start_keys);
-	trace_list_pop(synth->end_keys);
+	tfs_list_pop(synth->start_keys);
+	tfs_list_pop(synth->end_keys);
 	return -1;
 }
 
@@ -1320,7 +1318,7 @@ static char *new_name(struct tracefs_synth *synth, const char *name)
 
 static struct name_hash *find_name(struct tracefs_synth *synth, const char *name)
 {
-	unsigned int key = quick_hash(name);
+	unsigned int key = tfs_quick_hash(name);
 	struct name_hash *hash = synth->name_hash[key];
 
 	for (; hash; hash = hash->next) {
@@ -1349,7 +1347,7 @@ static const char *hash_name(struct tracefs_synth *synth, const char *name)
 		return name;
 	}
 
-	key = quick_hash(name);
+	key = tfs_quick_hash(name);
 	hash->next = synth->name_hash[key];
 	synth->name_hash[key] = hash;
 
@@ -1464,10 +1462,11 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 	return ret ? -1 : 0;
 }
 
-__hidden int synth_add_start_field(struct tracefs_synth *synth,
-				   const char *start_field,
-				   const char *name,
-				   enum tracefs_hist_key_type type, int count)
+__hidden int tfs_synth_add_start_field(struct tracefs_synth *synth,
+				       const char *start_field,
+				       const char *name,
+				       enum tracefs_hist_key_type type,
+				       int count)
 {
 	const struct tep_format_field *field;
 	const char *var;
@@ -1487,7 +1486,7 @@ __hidden int synth_add_start_field(struct tracefs_synth *synth,
 
 	var = hash_name(synth, name);
 
-	if (!trace_verify_event_field(synth->start_event, start_field, &field))
+	if (!tfs_verify_event_field(synth->start_event, start_field, &field))
 		return -1;
 
 	start_arg = new_arg(synth);
@@ -1551,7 +1550,7 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 				  const char *start_field,
 				  const char *name)
 {
-	return synth_add_start_field(synth, start_field, name, 0, 0);
+	return tfs_synth_add_start_field(synth, start_field, name, 0, 0);
 }
 
 /**
@@ -1593,7 +1592,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	if (!name)
 		tmp_var = new_arg(synth);
 
-	if (!trace_verify_event_field(synth->end_event, end_field, &field))
+	if (!tfs_verify_event_field(synth->end_event, end_field, &field))
 		goto out;
 
 	ret = add_var(&synth->end_vars, name ? hname : tmp_var, end_field, false);
@@ -1661,10 +1660,9 @@ int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 				      enum tracefs_compare compare,
 				      const char *val)
 {
-	return trace_append_filter(&synth->start_filter, &synth->start_state,
-				   &synth->start_parens,
-				   synth->start_event,
-				   type, field, compare, val);
+	return tfs_append_filter(&synth->start_filter, &synth->start_state,
+				 &synth->start_parens, synth->start_event,
+				 type, field, compare, val);
 }
 
 /**
@@ -1684,10 +1682,9 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    enum tracefs_compare compare,
 				    const char *val)
 {
-	return trace_append_filter(&synth->end_filter, &synth->end_state,
-				   &synth->end_parens,
-				   synth->end_event,
-				   type, field, compare, val);
+	return tfs_append_filter(&synth->end_filter, &synth->end_state,
+				 &synth->end_parens, synth->end_event,
+				 type, field, compare, val);
 }
 
 static bool var_match(const char *match, const char *var, int match_len, int len)
@@ -1908,11 +1905,11 @@ int tracefs_synth_save(struct tracefs_synth *synth,
 	for (i = 0; fields[i]; i++) {
 		char *delim = i ? "," : NULL;
 
-		if (!trace_verify_event_field(synth->end_event, fields[i], NULL))
+		if (!tfs_verify_event_field(synth->end_event, fields[i], NULL))
 			goto error;
-		save = append_string(save, delim, fields[i]);
+		save = tfs_append_string(save, delim, fields[i]);
 	}
-	save = append_string(save, NULL, ")");
+	save = tfs_append_string(save, NULL, ")");
 	if (!save)
 		goto error;
 
@@ -1954,20 +1951,20 @@ static char *create_hist(char **keys, char **vars)
 	for (i = 0; keys[i]; i++) {
 		name = keys[i];
 		if (i)
-			hist = append_string(hist, NULL, ",");
-		hist = append_string(hist, NULL, name);
+			hist = tfs_append_string(hist, NULL, ",");
+		hist = tfs_append_string(hist, NULL, name);
 	}
 
 	if (!vars)
 		return hist;
 
-	hist = append_string(hist, NULL, ":");
+	hist = tfs_append_string(hist, NULL, ":");
 
 	for (i = 0; vars[i]; i++) {
 		name = vars[i];
 		if (i)
-			hist = append_string(hist, NULL, ",");
-		hist = append_string(hist, NULL, name);
+			hist = tfs_append_string(hist, NULL, ",");
+		hist = tfs_append_string(hist, NULL, name);
 	}
 
 	return hist;
@@ -1975,11 +1972,11 @@ static char *create_hist(char **keys, char **vars)
 
 static char *create_onmatch(char *hist, struct tracefs_synth *synth)
 {
-	hist = append_string(hist, NULL, ":onmatch(");
-	hist = append_string(hist, NULL, synth->start_event->system);
-	hist = append_string(hist, NULL, ".");
-	hist = append_string(hist, NULL, synth->start_event->name);
-	return append_string(hist, NULL, ")");
+	hist = tfs_append_string(hist, NULL, ":onmatch(");
+	hist = tfs_append_string(hist, NULL, synth->start_event->system);
+	hist = tfs_append_string(hist, NULL, ".");
+	hist = tfs_append_string(hist, NULL, synth->start_event->name);
+	return tfs_append_string(hist, NULL, ")");
 }
 
 static char *create_trace(char *hist, struct tracefs_synth *synth)
@@ -1988,38 +1985,38 @@ static char *create_trace(char *hist, struct tracefs_synth *synth)
 	int i;
 
 	if (synth->new_format) {
-		hist = append_string(hist, NULL, ".trace(");
-		hist = append_string(hist, NULL, synth->name);
-		hist = append_string(hist, NULL, ",");
+		hist = tfs_append_string(hist, NULL, ".trace(");
+		hist = tfs_append_string(hist, NULL, synth->name);
+		hist = tfs_append_string(hist, NULL, ",");
 	} else {
-		hist = append_string(hist, NULL, ".");
-		hist = append_string(hist, NULL, synth->name);
-		hist = append_string(hist, NULL, "(");
+		hist = tfs_append_string(hist, NULL, ".");
+		hist = tfs_append_string(hist, NULL, synth->name);
+		hist = tfs_append_string(hist, NULL, "(");
 	}
 
 	for (i = 0; synth->synthetic_args && synth->synthetic_args[i]; i++) {
 		name = synth->synthetic_args[i];
 
 		if (i)
-			hist = append_string(hist, NULL, ",");
-		hist = append_string(hist, NULL, name);
+			hist = tfs_append_string(hist, NULL, ",");
+		hist = tfs_append_string(hist, NULL, name);
 	}
 
-	return append_string(hist, NULL, ")");
+	return tfs_append_string(hist, NULL, ")");
 }
 
 static char *create_max(char *hist, struct tracefs_synth *synth, char *field)
 {
-	hist = append_string(hist, NULL, ":onmax(");
-	hist = append_string(hist, NULL, field);
-	return append_string(hist, NULL, ")");
+	hist = tfs_append_string(hist, NULL, ":onmax(");
+	hist = tfs_append_string(hist, NULL, field);
+	return tfs_append_string(hist, NULL, ")");
 }
 
 static char *create_change(char *hist, struct tracefs_synth *synth, char *field)
 {
-	hist = append_string(hist, NULL, ":onchange(");
-	hist = append_string(hist, NULL, field);
-	return append_string(hist, NULL, ")");
+	hist = tfs_append_string(hist, NULL, ":onchange(");
+	hist = tfs_append_string(hist, NULL, field);
+	return tfs_append_string(hist, NULL, ")");
 }
 
 static char *create_actions(char *hist, struct tracefs_synth *synth)
@@ -2051,10 +2048,10 @@ static char *create_actions(char *hist, struct tracefs_synth *synth)
 			hist = create_trace(hist, synth);
 			break;
 		case ACTION_SNAPSHOT:
-			hist = append_string(hist, NULL, ".snapshot()");
+			hist = tfs_append_string(hist, NULL, ".snapshot()");
 			break;
 		case ACTION_SAVE:
-			hist = append_string(hist, NULL, action->save);
+			hist = tfs_append_string(hist, NULL, action->save);
 			break;
 		default:
 			continue;
@@ -2139,17 +2136,17 @@ static char *append_filter(char *hist, char *filter, unsigned int parens)
 	if (!filter)
 		return hist;
 
-	hist = append_string(hist, NULL, " if ");
-	hist = append_string(hist, NULL, filter);
+	hist = tfs_append_string(hist, NULL, " if ");
+	hist = tfs_append_string(hist, NULL, filter);
 	for (i = 0; i < parens; i++)
-		hist = append_string(hist, NULL, ")");
+		hist = tfs_append_string(hist, NULL, ")");
 	return hist;
 }
 
 static int verify_state(struct tracefs_synth *synth)
 {
-	if (trace_test_state(synth->start_state) < 0 ||
-	    trace_test_state(synth->end_state) < 0)
+	if (tfs_test_state(synth->start_state) < 0 ||
+	    tfs_test_state(synth->end_state) < 0)
 		return -1;
 	return 0;
 }
@@ -2440,7 +2437,7 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 		new_event = true;
 	}
 
-	path = trace_find_tracing_dir(false);
+	path = tfs_find_tracing_dir(false);
 	if (!path)
 		goto out_free;
 
@@ -2499,5 +2496,5 @@ tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth)
 	if (!tep || !synth || !synth->name)
 		return NULL;
 
-	return get_tep_event(tep, SYNTHETIC_GROUP, synth->name);
+	return tfs_get_tep_event(tep, SYNTHETIC_GROUP, synth->name);
 }
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index dd7decd..318fb81 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -31,13 +31,13 @@ struct tracefs_options_mask	toplevel_supported_opts;
 struct tracefs_options_mask	toplevel_enabled_opts;
 
 __hidden inline struct tracefs_options_mask *
-supported_opts_mask(struct tracefs_instance *instance)
+tfs_supported_opts_mask(struct tracefs_instance *instance)
 {
 	return instance ? &instance->supported_opts : &toplevel_supported_opts;
 }
 
 __hidden inline struct tracefs_options_mask *
-enabled_opts_mask(struct tracefs_instance *instance)
+tfs_enabled_opts_mask(struct tracefs_instance *instance)
 {
 	return instance ? &instance->enabled_opts : &toplevel_enabled_opts;
 }
@@ -85,7 +85,7 @@ error:
 }
 
 
-__hidden int trace_get_instance(struct tracefs_instance *instance)
+__hidden int tfs_get_instance(struct tracefs_instance *instance)
 {
 	int ret;
 
@@ -100,7 +100,7 @@ __hidden int trace_get_instance(struct tracefs_instance *instance)
 	return ret;
 }
 
-__hidden void trace_put_instance(struct tracefs_instance *instance)
+__hidden void tfs_put_instance(struct tracefs_instance *instance)
 {
 	pthread_mutex_lock(&instance->lock);
 	if (--instance->ref < 0)
@@ -141,7 +141,7 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 	if (!instance)
 		return;
 
-	trace_put_instance(instance);
+	tfs_put_instance(instance);
 }
 
 static mode_t get_trace_file_permissions(char *name)
@@ -337,7 +337,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 	int ret;
 
 	if (!instance) /* Top instance of default system trace directory */
-		return trace_find_tracing_dir(false);
+		return tfs_find_tracing_dir(false);
 
 	if (!instance->name)
 		return strdup(instance->trace_dir);
@@ -621,7 +621,7 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 	if (!path)
 		return NULL;
 
-	size = str_read_file(path, &buf, true);
+	size = tfs_str_read_file(path, &buf, true);
 
 	tracefs_put_tracing_file(path);
 	if (buf && psize)
@@ -789,7 +789,7 @@ int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
 		if (strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0)
 			continue;
-		instance = trace_append_file(path, dent->d_name);
+		instance = tfs_append_file(path, dent->d_name);
 		ret = stat(instance, &st);
 		free(instance);
 		if (ret < 0 || !S_ISDIR(st.st_mode))
@@ -870,7 +870,7 @@ char **tracefs_instances(const char *regex)
 	} else {
 		/* No matches should produce an empty list */
 		if (!list.list)
-			list.list = trace_list_create_empty();
+			list.list = tfs_list_create_empty();
 	}
 	return list.list;
 }
@@ -1323,7 +1323,7 @@ static int clear_trigger(const char *file)
 	int len;
 	int ret;
 
-	size = str_read_file(file, &buf, true);
+	size = tfs_str_read_file(file, &buf, true);
 	if (size < 1)
 		return 0;
 
@@ -1348,7 +1348,7 @@ static int clear_trigger(const char *file)
 	 * Some triggers have an order in removing them.
 	 * They will not be removed if done in the wrong order.
 	 */
-	size = str_read_file(file, &buf, true);
+	size = tfs_str_read_file(file, &buf, true);
 	if (size < 1)
 		return 0;
 
@@ -1372,7 +1372,7 @@ static void disable_func_stack_trace_instance(struct tracefs_instance *instance)
 	content = tracefs_instance_file_read(instance, "current_tracer", &size);
 	if (!content)
 		return;
-	cond = strstrip(content);
+	cond = tfs_strstrip(content);
 	if (memcmp(cond, "function", size - (cond - content)) != 0)
 		goto out;
 
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 5c50b21..09b09d7 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -45,7 +45,7 @@ kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *ev
 			*tmp = '\0';
 	}
 
-	kp = dynevent_alloc(type, sys, ename, addr, format);
+	kp = tfs_dynevent_alloc(type, sys, ename, addr, format);
 	if (!event)
 		free((char *)ename);
 
diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 44d1597..7530805 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -63,7 +63,7 @@ struct trace_mmap {
 };
 
 /**
- * trace_mmap - try to mmap the ring buffer
+ * tfs_mmap - try to mmap the ring buffer
  * @fd: The file descriptor to the trace_pipe_raw file
  * @kbuf: The kbuffer to load the subbuffer to
  *
@@ -71,7 +71,7 @@ struct trace_mmap {
  * if not, will return NULL, otherwise it returns a descriptor
  * to handle the mapping.
  */
-__hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
+__hidden void *tfs_mmap(int fd, struct kbuffer *kbuf)
 {
 	struct trace_mmap *tmap;
 	int page_size;
@@ -143,7 +143,7 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 	return tmap;
 }
 
-__hidden void trace_unmap(void *mapping)
+__hidden void tfs_unmap(void *mapping)
 {
 	struct trace_mmap *tmap = mapping;
 
@@ -161,7 +161,7 @@ static int get_reader(struct trace_mmap *tmap)
 	return ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER);
 }
 
-__hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
+__hidden int tfs_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 {
 	struct trace_mmap *tmap = mapping;
 	void *data;
@@ -222,7 +222,7 @@ __hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 	return 1;
 }
 
-__hidden int trace_mmap_read(void *mapping, void *buffer)
+__hidden int tfs_mmap_read(void *mapping, void *buffer)
 {
 	struct trace_mmap *tmap = mapping;
 	struct kbuffer *kbuf;
@@ -233,7 +233,7 @@ __hidden int trace_mmap_read(void *mapping, void *buffer)
 
 	kbuf = tmap->kbuf;
 
-	ret = trace_mmap_load_subbuf(mapping, kbuf);
+	ret = tfs_mmap_load_subbuf(mapping, kbuf);
 	/* Return for error or no more events */
 	if (ret <= 0)
 		return ret;
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 932e8b4..a2dcfc2 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -276,7 +276,7 @@ void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu)
 	close_fd(tcpu->splice_pipe[0]);
 	close_fd(tcpu->splice_pipe[1]);
 
-	trace_unmap(tcpu->mapping);
+	tfs_unmap(tcpu->mapping);
 	kbuffer_free(tcpu->kbuf);
 	free(tcpu);
 }
@@ -341,7 +341,7 @@ int tracefs_cpu_map(struct tracefs_cpu *tcpu)
 	if (tcpu->mapping)
 		return 0;
 
-	tcpu->mapping = trace_mmap(tcpu->fd, tcpu->kbuf);
+	tcpu->mapping = tfs_mmap(tcpu->fd, tcpu->kbuf);
 	return tcpu->mapping ? 0 : -1;
 }
 
@@ -350,7 +350,7 @@ void tracefs_cpu_unmap(struct tracefs_cpu *tcpu)
 	if (!tcpu->mapping)
 		return;
 
-	trace_unmap(tcpu->mapping);
+	tfs_unmap(tcpu->mapping);
 }
 
 static void set_nonblock(struct tracefs_cpu *tcpu)
@@ -427,7 +427,7 @@ static int mmap_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 	void *mapping = tcpu->mapping;
 	int ret;
 
-	ret = trace_mmap_read(mapping, buffer);
+	ret = tfs_mmap_read(mapping, buffer);
 	if (ret <= 0) {
 		if (!ret && nonblock)
 			errno = EAGAIN;
@@ -523,7 +523,7 @@ struct kbuffer *tracefs_cpu_read_buf(struct tracefs_cpu *tcpu, bool nonblock)
 		if (ret <= 0)
 			return NULL;
 
-		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		ret = tfs_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
 		return ret > 0 ? tcpu->kbuf : NULL;
 	}
 
@@ -550,7 +550,7 @@ static int init_splice(struct tracefs_cpu *tcpu)
 	if (ret < 0)
 		return ret;
 
-	if (str_read_file("/proc/sys/fs/pipe-max-size", &buf, false)) {
+	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false)) {
 		int size = atoi(buf);
 		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
 		free(buf);
@@ -664,7 +664,7 @@ struct kbuffer *tracefs_cpu_buffered_read_buf(struct tracefs_cpu *tcpu, bool non
 		if (ret <= 0)
 			return NULL;
 
-		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		ret = tfs_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
 		return ret > 0 ? tcpu->kbuf : NULL;
 	}
 
@@ -786,7 +786,7 @@ struct kbuffer *tracefs_cpu_flush_buf(struct tracefs_cpu *tcpu)
 	if (tcpu->mapping) {
 		/* Make sure that reading is now non blocking */
 		set_nonblock(tcpu);
-		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		ret = tfs_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
 		return ret > 0 ? tcpu->kbuf : NULL;
 	}
 
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 08bd0fa..3cad2ff 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -116,7 +116,7 @@ struct sql_table {
 	struct expr		**next_selection;
 };
 
-__hidden int my_yyinput(void *extra, char *buf, int max)
+__hidden int tfs_my_yyinput(void *extra, char *buf, int max)
 {
 	struct sqlhist_bison *sb = extra;
 
@@ -134,8 +134,10 @@ __hidden int my_yyinput(void *extra, char *buf, int max)
 	return max;
 }
 
-__hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
-			      const char *fmt, va_list ap)
+__hidden void tfs_sql_parse_error(struct sqlhist_bison *sb,
+				  const char *text,
+				  const char *fmt,
+				  va_list ap)
 {
 	const char *buffer = sb->buffer;
 	struct trace_seq s;
@@ -177,11 +179,11 @@ static void parse_error(struct sqlhist_bison *sb, const char *text,
 	va_list ap;
 
 	va_start(ap, fmt);
-	sql_parse_error(sb, text, fmt, ap);
+	tfs_sql_parse_error(sb, text, fmt, ap);
 	va_end(ap);
 }
 
-__hidden unsigned int quick_hash(const char *str)
+__hidden unsigned int tfs_quick_hash(const char *str)
 {
 	unsigned int val = 0;
 	int len = strlen(str);
@@ -203,7 +205,7 @@ __hidden unsigned int quick_hash(const char *str)
 
 static struct str_hash *find_string(struct sqlhist_bison *sb, const char *str)
 {
-	unsigned int key = quick_hash(str);
+	unsigned int key = tfs_quick_hash(str);
 	struct str_hash *hash = sb->str_hash[key];
 
 	for (; hash; hash = hash->next) {
@@ -215,7 +217,7 @@ static struct str_hash *find_string(struct sqlhist_bison *sb, const char *str)
 
 /*
  * If @str is found, then return the hash string.
- * This lets store_str() know to free str.
+ * This lets tfs_store_str() know to free str.
  */
 static char **add_hash(struct sqlhist_bison *sb, const char *str)
 {
@@ -229,14 +231,14 @@ static char **add_hash(struct sqlhist_bison *sb, const char *str)
 	hash = malloc(sizeof(*hash));
 	if (!hash)
 		return NULL;
-	key = quick_hash(str);
+	key = tfs_quick_hash(str);
 	hash->next = sb->str_hash[key];
 	sb->str_hash[key] = hash;
 	hash->str = NULL;
 	return &hash->str;
 }
 
-__hidden char *store_str(struct sqlhist_bison *sb, const char *str)
+__hidden char *tfs_store_str(struct sqlhist_bison *sb, const char *str)
 {
 	char **pstr = add_hash(sb, str);
 
@@ -249,8 +251,7 @@ __hidden char *store_str(struct sqlhist_bison *sb, const char *str)
 	return *pstr;
 }
 
-__hidden void *add_cast(struct sqlhist_bison *sb,
-			void *data, const char *type)
+__hidden void *tfs_add_cast(struct sqlhist_bison *sb, void *data, const char *type)
 {
 	struct expr *expr = data;
 	struct field *field = &expr->field;
@@ -259,8 +260,7 @@ __hidden void *add_cast(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_selection(struct sqlhist_bison *sb, void *select,
-			   const char *name)
+__hidden int tfs_add_selection(struct sqlhist_bison *sb, void *select, const char *name)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr = select;
@@ -288,8 +288,7 @@ __hidden int add_selection(struct sqlhist_bison *sb, void *select,
 	return 0;
 }
 
-static struct expr *find_field(struct sqlhist_bison *sb,
-				const char *raw, const char *label)
+static struct expr *find_field(struct sqlhist_bison *sb, const char *raw, const char *label)
 {
 	struct field *field;
 	struct expr *expr;
@@ -375,8 +374,7 @@ static void *create_expr(struct sqlhist_bison *sb,
 #define create_number(var, expr)			\
 	__create_expr(var, long, NUMBER, expr)
 
-__hidden void *add_field(struct sqlhist_bison *sb,
-			 const char *field_name, const char *label)
+__hidden void *tfs_add_field(struct sqlhist_bison *sb, const char *field_name, const char *label)
 {
 	struct sql_table *table = sb->table;
 	struct expr *expr;
@@ -417,7 +415,7 @@ __hidden void *add_field(struct sqlhist_bison *sb,
 			fieldB->raw = field_nameB;
 		}
 
-		return add_compare(sb, exprA, exprB, COMPARE_SUB);
+		return tfs_add_compare(sb, exprA, exprB, COMPARE_SUB);
 	}
 
 	expr = find_field(sb, field_name, label);
@@ -435,8 +433,7 @@ __hidden void *add_field(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden void *add_filter(struct sqlhist_bison *sb,
-			  void *A, void *B, enum filter_type op)
+__hidden void *tfs_add_filter(struct sqlhist_bison *sb, void *A, void *B, enum filter_type op)
 {
 	struct filter *filter;
 	struct expr *expr;
@@ -451,7 +448,7 @@ __hidden void *add_filter(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
+__hidden int tfs_add_match(struct sqlhist_bison *sb, void *A, void *B)
 {
 	struct sql_table *table = sb->table;
 	struct match *match;
@@ -468,8 +465,8 @@ __hidden int add_match(struct sqlhist_bison *sb, void *A, void *B)
 
 	return 0;
 }
-__hidden void *add_compare(struct sqlhist_bison *sb,
-			   void *A, void *B, enum compare_type type)
+
+__hidden void *tfs_add_compare(struct sqlhist_bison *sb, void *A, void *B, enum compare_type type)
 {
 	struct compare *compare;
 	struct expr *expr;
@@ -484,7 +481,7 @@ __hidden void *add_compare(struct sqlhist_bison *sb,
 	return expr;
 }
 
-__hidden int add_where(struct sqlhist_bison *sb, void *item)
+__hidden int tfs_add_where(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 	struct sql_table *table = sb->table;
@@ -501,7 +498,7 @@ __hidden int add_where(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden int add_from(struct sqlhist_bison *sb, void *item)
+__hidden int tfs_add_from(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -513,7 +510,7 @@ __hidden int add_from(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden int add_to(struct sqlhist_bison *sb, void *item)
+__hidden int tfs_add_to(struct sqlhist_bison *sb, void *item)
 {
 	struct expr *expr = item;
 
@@ -525,7 +522,7 @@ __hidden int add_to(struct sqlhist_bison *sb, void *item)
 	return 0;
 }
 
-__hidden void *add_string(struct sqlhist_bison *sb, const char *str)
+__hidden void *tfs_add_string(struct sqlhist_bison *sb, const char *str)
 {
 	struct expr *expr;
 	const char **str_p;
@@ -535,7 +532,7 @@ __hidden void *add_string(struct sqlhist_bison *sb, const char *str)
 	return expr;
 }
 
-__hidden void *add_number(struct sqlhist_bison *sb, long val)
+__hidden void *tfs_add_number(struct sqlhist_bison *sb, long val)
 {
 	struct expr *expr;
 	long *num;
@@ -545,7 +542,7 @@ __hidden void *add_number(struct sqlhist_bison *sb, long val)
 	return expr;
 }
 
-__hidden int table_start(struct sqlhist_bison *sb)
+__hidden int tfs_table_start(struct sqlhist_bison *sb)
 {
 	struct sql_table *table;
 
@@ -669,7 +666,7 @@ static int update_vars(struct tep_handle *tep,
 		str = strndup(raw, p - raw);
 		if (!str)
 			return -1;
-		event_field->system = store_str(sb, str);
+		event_field->system = tfs_store_str(sb, str);
 		free(str);
 		if (!event_field->system)
 			return -1;
@@ -678,7 +675,7 @@ static int update_vars(struct tep_handle *tep,
 		p = raw;
 	}
 
-	event_field->event_name = store_str(sb, p);
+	event_field->event_name = tfs_store_str(sb, p);
 	if (!event_field->event_name)
 		return -1;
 
@@ -686,7 +683,7 @@ static int update_vars(struct tep_handle *tep,
 		return -1;
 
 	if (!event_field->system)
-		event_field->system = store_str(sb, event->system);
+		event_field->system = tfs_store_str(sb, event->system);
 
 	if (!event_field->system)
 		return -1;
@@ -753,11 +750,11 @@ static int update_vars(struct tep_handle *tep,
 		field->ftype = ftype;
 
 		if (!strcmp(field->field, "TIMESTAMP"))
-			field->field = store_str(sb, TRACEFS_TIMESTAMP);
+			field->field = tfs_store_str(sb, TRACEFS_TIMESTAMP);
 		if (!strcmp(field->field, "TIMESTAMP_USECS"))
-			field->field = store_str(sb, TRACEFS_TIMESTAMP_USECS);
+			field->field = tfs_store_str(sb, TRACEFS_TIMESTAMP_USECS);
 		if (!strcmp(field->field, "STACKTRACE"))
-			field->field = store_str(sb, TRACEFS_STACKTRACE);
+			field->field = tfs_store_str(sb, TRACEFS_STACKTRACE);
 		if (test_field_exists(tep, sb, expr))
 			return -1;
 	}
@@ -809,7 +806,7 @@ static int update_fields(struct tep_handle *tep,
 			p = strndup(field_name, len);
 			if (!p)
 				return -1;
-			field_name = store_str(sb, p);
+			field_name = tfs_store_str(sb, p);
 			free((char *)p);
 			if (!field_name)
 				return -1;
@@ -1485,7 +1482,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		start_system = table->from->field.system;
 		start_event = table->from->field.event_name;
 
-		synth = synth_init_from(tep, start_system, start_event);
+		synth = tfs_synth_init_from(tep, start_system, start_event);
 		if (!synth)
 			return synth_init_error(tep, table);
 		goto hist_only;
@@ -1556,7 +1553,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 					goto free;
 				if (type != HIST_COUNTER_TYPE)
 					non_val = true;
-				ret = synth_add_start_field(synth,
+				ret = tfs_synth_add_start_field(synth,
 						field->field, field->label,
 						type, cnt);
 			} else if (table->to) {
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 74cfe91..a8eb90e 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -21,7 +21,7 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
-__hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
+__hidden pthread_mutex_t tfs_toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
 
 #define TRACE_CTRL		"tracing_on"
 #define TRACE_FILTER		"set_ftrace_filter"
@@ -248,8 +248,8 @@ trace_get_options(struct tracefs_instance *instance, bool enabled)
 	char *path;
 	int ret;
 
-	bitmask = enabled ? enabled_opts_mask(instance) :
-			   supported_opts_mask(instance);
+	bitmask = enabled ? tfs_enabled_opts_mask(instance) :
+			    tfs_supported_opts_mask(instance);
 
 	for (id = 1; id < TRACEFS_OPTION_MAX; id++) {
 		snprintf(file, PATH_MAX, "options/%s", options_map[id]);
diff --git a/src/tracefs-uprobes.c b/src/tracefs-uprobes.c
index aa39b75..b3a34e0 100644
--- a/src/tracefs-uprobes.c
+++ b/src/tracefs-uprobes.c
@@ -29,7 +29,7 @@ uprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *ev
 	if (asprintf(&target, "%s:0x%0*llx", file, (int)(sizeof(void *) * 2), offset) < 0)
 		return NULL;
 
-	kp = dynevent_alloc(type, system, event, target, fetchargs);
+	kp = tfs_dynevent_alloc(type, system, event, target, fetchargs);
 	free(target);
 
 	return kp;
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 50a7c74..d1aced0 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -86,7 +86,7 @@ static int mount_debugfs(void)
 }
 
 /* Exported for testing purpose only */
-__hidden char *find_tracing_dir(bool debugfs, bool mount)
+__hidden char *tfs_find_debug_tracing_dir(bool debugfs, bool mount)
 {
 	char *debug_str = NULL;
 	char fspath[PATH_MAX+1];
@@ -175,7 +175,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 {
 	const char *dir;
 
-	dir = find_tracing_dir(false, false);
+	dir = tfs_find_debug_tracing_dir(false, false);
 	if (dir) {
 		if (path)
 			*path = dir;
@@ -184,7 +184,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 	if (!mount)
 		return 0;
 
-	dir = find_tracing_dir(false, mount);
+	dir = tfs_find_debug_tracing_dir(false, mount);
 	if (!dir)
 		return -1;
 	if (path)
@@ -193,15 +193,15 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 }
 
 /**
- * trace_find_tracing_dir - Find tracing directory
+ * tfs_find_tracing_dir - Find tracing directory
  * @debugfs: Boolean to just return the debugfs directory
  *
  * Returns string containing the full path to the system's tracing directory.
  * The string must be freed by free()
  */
-__hidden char *trace_find_tracing_dir(bool debugfs)
+__hidden char *tfs_find_tracing_dir(bool debugfs)
 {
-	return find_tracing_dir(debugfs, false);
+	return tfs_find_debug_tracing_dir(debugfs, false);
 }
 
 /**
@@ -258,7 +258,7 @@ const char *tracefs_tracing_dir(void)
 		return tracing_dir;
 
 	free(tracing_dir);
-	tracing_dir = find_tracing_dir(false, true);
+	tracing_dir = tfs_find_debug_tracing_dir(false, true);
 	return tracing_dir;
 }
 
@@ -276,7 +276,7 @@ const char *tracefs_debug_dir(void)
 	if (debug_dir && test_dir(debug_dir, "tracing"))
 		return debug_dir;
 
-	debug_dir = find_tracing_dir(true, true);
+	debug_dir = tfs_find_debug_tracing_dir(true, true);
 	return debug_dir;
 }
 
@@ -321,7 +321,7 @@ void tracefs_put_tracing_file(char *name)
 }
 
 /* The function is copied from trace-cmd */
-__hidden char *strstrip(char *str)
+__hidden char *tfs_strstrip(char *str)
 {
 	char *s;
 
@@ -340,7 +340,7 @@ __hidden char *strstrip(char *str)
 	return s;
 }
 
-__hidden int str_read_file(const char *file, char **buffer, bool warn)
+__hidden int tfs_str_read_file(const char *file, char **buffer, bool warn)
 {
 	char stbuf[BUFSIZ];
 	char *buf = NULL;
@@ -401,7 +401,7 @@ char *tracefs_error_all(struct tracefs_instance *instance)
 	path = tracefs_instance_get_file(instance, ERROR_LOG);
 	if (!path)
 		return NULL;
-	size = str_read_file(path, &content, false);
+	size = tfs_str_read_file(path, &content, false);
 	tracefs_put_tracing_file(path);
 
 	if (size <= 0)
@@ -514,7 +514,7 @@ void tracefs_list_free(char **list)
 }
 
 
-__hidden char ** trace_list_create_empty(void)
+__hidden char **tfs_list_create_empty(void)
 {
 	char **list;
 
@@ -575,13 +575,13 @@ char **tracefs_list_add(char **list, const char *string)
 }
 
 /*
- * trace_list_pop - Removes the last string added
+ * tfs_list_pop - Removes the last string added
  * @list: The list to remove the last event from
  *
  * Returns 0 on success, -1 on error.
  * Returns 1 if the list is empty or NULL.
  */
-__hidden int trace_list_pop(char **list)
+__hidden int tfs_list_pop(char **list)
 {
 	unsigned long size;
 
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5bfd665..c52fe04 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1770,7 +1770,7 @@ static void test_follow_events_clear(void)
 	test_instance_follow_events_clear(test_instance);
 }
 
-extern char *find_tracing_dir(bool debugfs, bool mount);
+extern char *tfs_find_debug_tracing_dir(bool debugfs, bool mount);
 static void test_mounting(void)
 {
 	const char *tracing_dir;
@@ -1784,7 +1784,7 @@ static void test_mounting(void)
 
 	/* First, unmount all instances of debugfs */
 	do {
-		dir = find_tracing_dir(true, false);
+		dir = tfs_find_debug_tracing_dir(true, false);
 		if (dir) {
 			ret = umount(dir);
 			CU_TEST(ret == 0);
@@ -1800,7 +1800,7 @@ static void test_mounting(void)
 
 	/* Next, unmount all instances of tracefs */
 	do {
-		dir = find_tracing_dir(false, false);
+		dir = tfs_find_debug_tracing_dir(false, false);
 		if (dir) {
 			ret = umount(dir);
 			CU_TEST(ret == 0);

base-commit: 78d8d2e277af222a97647ace0846e28d0cae6a70
-- 
2.34.1

