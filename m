Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21A9CCA484
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiFFTaJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiFFT37 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553586545
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2EEAB81B43
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366D5C3411F;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oyy-6Q;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/6] libtracefs: Use unique names for sql field variables
Date:   Mon,  6 Jun 2022 15:29:51 -0400
Message-Id: <20220606192953.334315-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When creating two different synthetic events using tracefs_sql(), if
they share the same label, the second one will fail because
tracefs_sql() will use that label as a variable name. In the kernel,
each variable must be unique, and the second label will cause a conflict
with the variable named after the first label.

Use a unique identifier when creating the variables based on the label,
but still keep the label text in the variable name to let users still
know what label the variable is for.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/tracefs-local.h |   4 ++
 src/sqlhist-parse.h     |   3 +-
 src/tracefs-hist.c      | 105 ++++++++++++++++++++++++++++++++++++----
 src/tracefs-sqlhist.c   |   2 +-
 4 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index d0ed2abfe5e7..678b9870d03e 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -15,6 +15,8 @@
 #define BUILD_BUG_ON(cond)			\
 	do { if (!(1/!(cond))) { } } while (0)
 
+#define HASH_BITS 10
+
 struct tracefs_options_mask {
 	unsigned long long	mask;
 };
@@ -120,4 +122,6 @@ int trace_rescan_events(struct tep_handle *tep,
 struct tep_event *get_tep_event(struct tep_handle *tep,
 				const char *system, const char *name);
 
+unsigned int quick_hash(const char *str);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index d5b86cacd8ce..7bd2a6350ece 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -4,8 +4,9 @@
 #include <stdarg.h>
 #include <tracefs.h>
 
+#include <tracefs-local.h>
+
 struct str_hash;
-#define HASH_BITS 10
 
 struct sql_table;
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 0d113127def9..2f12cc471294 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -654,6 +654,12 @@ struct action {
 	char				*save;
 };
 
+struct name_hash {
+	struct name_hash	*next;
+	char			*name;
+	char			*hash;
+};
+
 /*
  * @name: name of the synthetic event
  * @start_system: system of the starting event
@@ -684,6 +690,7 @@ struct tracefs_synth {
 	struct action		*actions;
 	struct action		**next_action;
 	struct tracefs_dynevent	*dyn_event;
+	struct name_hash	*name_hash[1 << HASH_BITS];
 	char			*start_hist;
 	char			*end_hist;
 	char			*name;
@@ -724,6 +731,21 @@ static void action_free(struct action *action)
 	free(action);
 }
 
+static void free_name_hash(struct name_hash **hash)
+{
+	struct name_hash *item;
+	int i;
+
+	for (i = 0; i < 1 << HASH_BITS; i++) {
+		while ((item = hash[i])) {
+			hash[i] = item->next;
+			free(item->name);
+			free(item->hash);
+			free(item);
+		}
+	}
+}
+
 /**
  * tracefs_synth_free - free the resources alloced to a synth
  * @synth: The tracefs_synth descriptor
@@ -750,6 +772,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 	tracefs_list_free(synth->end_keys);
 	tracefs_list_free(synth->start_vars);
 	tracefs_list_free(synth->end_vars);
+	free_name_hash(synth->name_hash);
 	free(synth->start_filter);
 	free(synth->end_filter);
 	free(synth->start_type);
@@ -1096,7 +1119,7 @@ static int add_synth_fields(struct tracefs_synth *synth,
 		return -1;
 	synth->synthetic_fields = list;
 
-	ret = asprintf(&str, "$%s", name);
+	ret = asprintf(&str, "$%s", var ? : name);
 	if (ret < 0) {
 		trace_list_pop(synth->synthetic_fields);
 		return -1;
@@ -1196,7 +1219,7 @@ static unsigned int make_rand(void)
 	return((unsigned)(seed/65536) % 32768);
 }
 
-static char *new_arg(struct tracefs_synth *synth)
+static char *new_name(struct tracefs_synth *synth, const char *name)
 {
 	int cnt = synth->arg_cnt + 1;
 	char *arg;
@@ -1205,9 +1228,9 @@ static char *new_arg(struct tracefs_synth *synth)
 	/* Create a unique argument name */
 	if (!synth->arg_name[0]) {
 		/* make_rand() returns at most 32768 (total 13 bytes in use) */
-		sprintf(synth->arg_name, "__arg_%u_", make_rand());
+		sprintf(synth->arg_name, "%u", make_rand());
 	}
-	ret = asprintf(&arg, "%s%d", synth->arg_name, cnt);
+	ret = asprintf(&arg, "__%s_%s_%d", name, synth->arg_name, cnt);
 	if (ret < 0)
 		return NULL;
 
@@ -1215,6 +1238,55 @@ static char *new_arg(struct tracefs_synth *synth)
 	return arg;
 }
 
+static struct name_hash *find_name(struct tracefs_synth *synth, const char *name)
+{
+	unsigned int key = quick_hash(name);
+	struct name_hash *hash = synth->name_hash[key];
+
+	for (; hash; hash = hash->next) {
+		if (!strcmp(hash->name, name))
+			return hash;
+	}
+	return NULL;
+}
+
+static const char *hash_name(struct tracefs_synth *synth, const char *name)
+{
+	struct name_hash *hash;
+	int key;
+
+	hash = find_name(synth, name);
+	if (hash)
+		return hash->hash;
+
+	hash = malloc(sizeof(*hash));
+	if (!hash)
+		return name;
+
+	hash->hash = new_name(synth, name);
+	if (!hash->hash) {
+		free(hash);
+		return name;
+	}
+
+	key = quick_hash(name);
+	hash->next = synth->name_hash[key];
+	synth->name_hash[key] = hash;
+
+	hash->name = strdup(name);
+	if (!hash->name) {
+		free(hash->hash);
+		free(hash);
+		return name;
+	}
+	return hash->hash;
+}
+
+static char *new_arg(struct tracefs_synth *synth)
+{
+	return new_name(synth, "arg");
+}
+
 /**
  * tracefs_synth_add_compare_field - add a comparison between start and end
  * @synth: The tracefs_synth descriptor
@@ -1245,6 +1317,7 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 				    const char *name)
 {
 	const struct tep_format_field *start_field;
+	const char *hname;
 	char *start_arg;
 	char *compare;
 	int ret;
@@ -1296,11 +1369,12 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 	if (ret < 0)
 		return -1;
 
-	ret = add_var(&synth->end_vars, name, compare, false);
+	hname = hash_name(synth, name);
+	ret = add_var(&synth->end_vars, hname, compare, false);
 	if (ret < 0)
 		goto out_free;
 
-	ret = add_synth_fields(synth, start_field, name, NULL);
+	ret = add_synth_fields(synth, start_field, name, hname);
 	if (ret < 0)
 		goto out_free;
 
@@ -1316,6 +1390,7 @@ __hidden int synth_add_start_field(struct tracefs_synth *synth,
 				   enum tracefs_hist_key_type type)
 {
 	const struct tep_format_field *field;
+	const char *var;
 	char *start_arg;
 	char **tmp;
 	int *types;
@@ -1330,6 +1405,8 @@ __hidden int synth_add_start_field(struct tracefs_synth *synth,
 	if (!name)
 		name = start_field;
 
+	var = hash_name(synth, name);
+
 	if (!trace_verify_event_field(synth->start_event, start_field, &field))
 		return -1;
 
@@ -1341,11 +1418,11 @@ __hidden int synth_add_start_field(struct tracefs_synth *synth,
 	if (ret)
 		goto out_free;
 
-	ret = add_var(&synth->end_vars, name, start_arg, true);
+	ret = add_var(&synth->end_vars, var, start_arg, true);
 	if (ret)
 		goto out_free;
 
-	ret = add_synth_fields(synth, field, name, NULL);
+	ret = add_synth_fields(synth, field, name, var);
 	if (ret)
 		goto out_free;
 
@@ -1417,6 +1494,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 				const char *name)
 {
 	const struct tep_format_field *field;
+	const char *hname = NULL;
 	char *tmp_var = NULL;
 	int ret;
 
@@ -1425,17 +1503,24 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 		return -1;
 	}
 
+	if (name) {
+		if (strncmp(name, "__arg", 5) != 0)
+			hname = hash_name(synth, name);
+		else
+			hname = name;
+	}
+
 	if (!name)
 		tmp_var = new_arg(synth);
 
 	if (!trace_verify_event_field(synth->end_event, end_field, &field))
 		return -1;
 
-	ret = add_var(&synth->end_vars, name ? : tmp_var, end_field, false);
+	ret = add_var(&synth->end_vars, name ? hname : tmp_var, end_field, false);
 	if (ret)
 		goto out;
 
-	ret = add_synth_fields(synth, field, name, tmp_var);
+	ret = add_synth_fields(synth, field, name, hname ? : tmp_var);
 	free(tmp_var);
  out:
 	return ret;
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index d854f7b54344..22e4b652e48b 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -174,7 +174,7 @@ static void parse_error(struct sqlhist_bison *sb, const char *text,
 	va_end(ap);
 }
 
-static inline unsigned int quick_hash(const char *str)
+__hidden unsigned int quick_hash(const char *str)
 {
 	unsigned int val = 0;
 	int len = strlen(str);
-- 
2.35.1

