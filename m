Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A48EC04A95
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 16:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiI1QIc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 12:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiI1QIc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 12:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE0DCF488
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 09:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B9861F23
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 16:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C79C433B5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 16:08:28 +0000 (UTC)
Date:   Wed, 28 Sep 2022 12:09:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add buckets field to tracefs_sql() function
Message-ID: <20220928120939.564619a5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Keys can be broken up into "buckets" with the "<key>.buckets=<size>"
option. As this type requires a counter, some internal functions needed to
have this counter passed around.

The external function tracefs_hist_add_key() does not suffice for the
buckets, so a new external function was added to do so:

  tracefs_hist_add_key_cnt()

that allows a counter to be passed along with the key type.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216439
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt |  42 +++++++++++--
 include/tracefs-local.h           |   2 +-
 include/tracefs.h                 |  13 ++++
 samples/Makefile                  |   3 +
 src/tracefs-hist.c                | 101 +++++++++++++++++++++++-------
 src/tracefs-sqlhist.c             |  18 +++++-
 6 files changed, 146 insertions(+), 33 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 3ac21cec70a2..1dd5abf1cce7 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_alloc_2d, tracefs_hist_alloc_nd, tracefs_hist_free,
-tracefs_hist_add_key, tracefs_hist_add_value - Create and destroy event histograms
+tracefs_hist_add_key, tracefs_hist_add_key_cnt, tracefs_hist_add_value - Create and destroy event histograms
 
 SYNOPSIS
 --------
@@ -43,6 +43,8 @@ void *tracefs_hist_free*(struct tracefs_hist pass:[*]_hist_);
 
 int *tracefs_hist_add_key*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
 			 enum tracefs_hist_key_type _type_);
+int *tracefs_hist_add_key_cnt*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
+			 enum tracefs_hist_key_type _type_, int _cnt_);
 int *tracefs_hist_add_value*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_value_);
 --
 
@@ -90,6 +92,14 @@ a _tertiary_ key (or three dimensional histogram). The _hist_ parameter is the
 histogram descriptor to add the _key_ to. The _type_ is the type of key to add
 (See KEY TYPES below).
 
+The *tracefs_hist_add_key_cnt*() is the same as *tracefs_hist_add_key*() except
+that it allows to add a counter for the given type. Currently, there's only
+the *buckets* type that requires a counter. When adding a key with the buckets
+type, *tracefs_hist_add_key*() is not sufficient, as the *buckets* type requires
+a counter or bucket size. Use *tracefs_hist_add_key_cnt*() when specifing
+a key that is broken up into  buckets, and pass in the size of those buckets
+into _cnt_.
+
 *tracefs_hist_add_value*() will add a value to record. By default, the value is
 simply the "hitcount" of the number of times a instance of the histogram's
 key was hit. The _hist_ is the histogram descriptor to add the value to.
@@ -140,6 +150,7 @@ EXAMPLE
 [source,c]
 --
 #include <stdlib.h>
+#include <ctype.h>
 #include <unistd.h>
 #include <tracefs.h>
 
@@ -162,14 +173,14 @@ static void parse_system_event(char *group, char **system, char **event)
 	}
 }
 
-static int parse_keys(char *keys, struct tracefs_hist_axis **axes)
+static int parse_keys(char *keys, struct tracefs_hist_axis_cnt **axes)
 {
 	char *sav = NULL;
 	char *key;
 	int cnt = 0;
 
 	for (key = strtok_r(keys, ",", &sav); key; key = strtok_r(NULL, ",", &sav)) {
-		struct tracefs_hist_axis *ax;
+		struct tracefs_hist_axis_cnt *ax;
 		char *att;
 
 		ax = realloc(*axes, sizeof(*ax) * (cnt + 2));
@@ -201,7 +212,14 @@ static int parse_keys(char *keys, struct tracefs_hist_axis **axes)
 				ax[cnt].type = TRACEFS_HIST_KEY_LOG;
 			else if (strcmp(att, "usecs") == 0)
 				ax[cnt].type = TRACEFS_HIST_KEY_USECS;
-			else {
+			else if (strncmp(att, "buckets", 7) == 0) {
+				if (att[7] != '=' && !isdigit(att[8])) {
+					fprintf(stderr, "'buckets' key type requires '=<size>'\n");
+					exit(-1);
+				}
+				ax[cnt].type = TRACEFS_HIST_KEY_BUCKETS;
+				ax[cnt].cnt = atoi(&att[8]);
+			} else {
 				fprintf(stderr, "Undefined attribute '%s'\n", att);
 				fprintf(stderr,"  Acceptable attributes:\n");
 				fprintf(stderr,"    hex, sym, sym_offset, syscall, exe, log, usecs\n");
@@ -220,7 +238,7 @@ static void process_hist(enum commands cmd, const char *instance_name,
 	struct tracefs_instance *instance = NULL;
 	struct tracefs_hist *hist;
 	struct tep_handle *tep;
-	struct tracefs_hist_axis *axes = NULL;
+	struct tracefs_hist_axis_cnt *axes = NULL;
 	char *system;
 	char *event;
 	char *sav;
@@ -268,6 +286,17 @@ static void process_hist(enum commands cmd, const char *instance_name,
 		exit(-1);
 	}
 
+	/* buckets require the nd_cnt function */
+	switch (cnt) {
+	case 2:
+		if (axes[1].type == TRACEFS_HIST_KEY_BUCKETS)
+			cnt = -1;
+		/* fall through */
+	case 1:
+		if (axes[0].type == TRACEFS_HIST_KEY_BUCKETS)
+			cnt = -1;
+	}
+
 	/* Show examples of hist1d and hist2d */
 	switch (cnt) {
 	case 1:
@@ -281,7 +310,7 @@ static void process_hist(enum commands cmd, const char *instance_name,
 		break;
 	default:
 		/* Really, 1 and 2 could use this too */
-		hist = tracefs_hist_alloc_nd(tep, system, event, axes);
+		hist = tracefs_hist_alloc_nd_cnt(tep, system, event, axes);
 	}
 	if (!hist) {
 		fprintf(stderr, "Failed hist create\n");
@@ -445,6 +474,7 @@ int main (int argc, char **argv, char **env)
 	}
 	process_hist(cmd, instance, event, keys, vals, sort, ascend, desc);
 }
+
 --
 
 FILES
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index f51a4b81e5cb..1286cbf800a2 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -98,7 +98,7 @@ struct tracefs_synth *synth_init_from(struct tep_handle *tep,
 int synth_add_start_field(struct tracefs_synth *synth,
 			  const char *start_field,
 			  const char *name,
-			  enum tracefs_hist_key_type type);
+			  enum tracefs_hist_key_type type, int cnt);
 
 /* Internal interface for ftrace dynamic events */
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 31f5a280f595..42ecd71f1e29 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -310,6 +310,7 @@ enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_EXECNAME,
 	TRACEFS_HIST_KEY_LOG,
 	TRACEFS_HIST_KEY_USECS,
+	TRACEFS_HIST_KEY_BUCKETS,
 	TRACEFS_HIST_KEY_MAX
 };
 
@@ -372,15 +373,27 @@ struct tracefs_hist_axis {
 	enum tracefs_hist_key_type type;
 };
 
+struct tracefs_hist_axis_cnt {
+	const char *key;
+	enum tracefs_hist_key_type type;
+	int cnt;
+};
+
 struct tracefs_hist *
 tracefs_hist_alloc_nd(struct tep_handle *tep,
 		      const char *system, const char *event_name,
 		      struct tracefs_hist_axis *axes);
+struct tracefs_hist *
+tracefs_hist_alloc_nd_cnt(struct tep_handle *tep,
+			  const char *system, const char *event_name,
+			  struct tracefs_hist_axis_cnt *axes);
 const char *tracefs_hist_get_name(struct tracefs_hist *hist);
 const char *tracefs_hist_get_event(struct tracefs_hist *hist);
 const char *tracefs_hist_get_system(struct tracefs_hist *hist);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
+int tracefs_hist_add_key_cnt(struct tracefs_hist *hist, const char *key,
+			 enum tracefs_hist_key_type type, int cnt);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
 int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
 			      const char *sort_key);
diff --git a/samples/Makefile b/samples/Makefile
index 6628679e6227..7bc7ff4f00e1 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -65,6 +65,9 @@ $(EXAMPLES): $(patsubst %,$(sdir)/%,$(TARGETS))
 $(bdir)/%.o: $(bdir)/%.c
 	$(call do_sample_obj,$@,$^)
 
+$(bdir)/XX.o: $(bdir)/hist.c
+	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+
 clean:
 	$(Q)$(call do_clean,$(sdir)/* $(bdir)/sqlhist.c $(bdir)/sqlhist.o)
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 14988d8dc185..fb6231e4009f 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -280,25 +280,11 @@ tracefs_hist_alloc_2d(struct tep_handle *tep,
 	return tracefs_hist_alloc_nd(tep, system, event_name, axis);
 }
 
-/**
- * tracefs_hist_alloc_nd - Initialize N-dimensional histogram
- * @tep: The tep handle that has the @system and @event.
- * @system: The system the histogram event is in
- * @event: The event that the histogram will be attached to
- * @axes: An array of histogram axes, terminated by a {NULL, 0} entry
- *
- * Will initialize a histogram descriptor that will be attached to
- * the @system/@event. This only initializes the descriptor with the given
- * @axes keys as primaries. This only initializes the descriptor, it does
- * not start the histogram in the kernel.
- *
- * Returns an initialized histogram on success.
- * NULL on failure.
- */
-struct tracefs_hist *
-tracefs_hist_alloc_nd(struct tep_handle *tep,
-		      const char *system, const char *event_name,
-		      struct tracefs_hist_axis *axes)
+static struct tracefs_hist *
+hist_alloc_nd(struct tep_handle *tep,
+	      const char *system, const char *event_name,
+	      struct tracefs_hist_axis *axes,
+	      struct tracefs_hist_axis_cnt *axes_cnt)
 {
 	struct tep_event *event;
 	struct tracefs_hist *hist;
@@ -326,25 +312,75 @@ tracefs_hist_alloc_nd(struct tep_handle *tep,
 		if (tracefs_hist_add_key(hist, axes->key, axes->type) < 0)
 			goto fail;
 
+	for (; axes_cnt && axes_cnt->key; axes_cnt++)
+		if (tracefs_hist_add_key_cnt(hist, axes_cnt->key, axes_cnt->type, axes_cnt->cnt) < 0)
+			goto fail;
+
 	return hist;
 
  fail:
 	tracefs_hist_free(hist);
 	return NULL;
 }
+/**
+ * tracefs_hist_alloc_nd - Initialize N-dimensional histogram
+ * @tep: The tep handle that has the @system and @event.
+ * @system: The system the histogram event is in
+ * @event: The event that the histogram will be attached to
+ * @axes: An array of histogram axes, terminated by a {NULL, 0} entry
+ *
+ * Will initialize a histogram descriptor that will be attached to
+ * the @system/@event. This only initializes the descriptor with the given
+ * @axes keys as primaries. This only initializes the descriptor, it does
+ * not start the histogram in the kernel.
+ *
+ * Returns an initialized histogram on success.
+ * NULL on failure.
+ */
+struct tracefs_hist *
+tracefs_hist_alloc_nd(struct tep_handle *tep,
+		      const char *system, const char *event_name,
+		      struct tracefs_hist_axis *axes)
+{
+	return hist_alloc_nd(tep, system, event_name, axes, NULL);
+}
+
+/**
+ * tracefs_hist_alloc_nd_cnt - Initialize N-dimensional histogram
+ * @tep: The tep handle that has the @system and @event.
+ * @system: The system the histogram event is in
+ * @event: The event that the histogram will be attached to
+ * @axes: An array of histogram axes, terminated by a {NULL, 0} entry
+ *
+ * Will initialize a histogram descriptor that will be attached to
+ * the @system/@event. This only initializes the descriptor with the given
+ * @axes keys as primaries. This only initializes the descriptor, it does
+ * not start the histogram in the kernel.
+ *
+ * Returns an initialized histogram on success.
+ * NULL on failure.
+ */
+struct tracefs_hist *
+tracefs_hist_alloc_nd_cnt(struct tep_handle *tep,
+			  const char *system, const char *event_name,
+			  struct tracefs_hist_axis_cnt *axes)
+{
+	return hist_alloc_nd(tep, system, event_name, NULL, axes);
+}
 
 /**
  * tracefs_hist_add_key - add to a key to a histogram
  * @hist: The histogram to add the key to.
  * @key: The name of the key field.
  * @type: The type of the key format.
+ * @cnt: Some types require a counter, for those, this is used
  *
  * This adds a secondary or tertiary key to the histogram.
  *
  * Returns 0 on success, -1 on error.
  */
-int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
-			 enum tracefs_hist_key_type type)
+int tracefs_hist_add_key_cnt(struct tracefs_hist *hist, const char *key,
+			     enum tracefs_hist_key_type type, int cnt)
 {
 	bool use_key = false;
 	char *key_type = NULL;
@@ -377,6 +413,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 	case TRACEFS_HIST_KEY_USECS:
 		ret = asprintf(&key_type, "%s.usecs", key);
 		break;
+	case TRACEFS_HIST_KEY_BUCKETS:
+		ret = asprintf(&key_type, "%s.buckets=%d", key, cnt);
+		break;
 	case TRACEFS_HIST_KEY_MAX:
 		/* error */
 		break;
@@ -395,6 +434,22 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 	return 0;
 }
 
+/**
+ * tracefs_hist_add_key - add to a key to a histogram
+ * @hist: The histogram to add the key to.
+ * @key: The name of the key field.
+ * @type: The type of the key format.
+ *
+ * This adds a secondary or tertiary key to the histogram.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
+			 enum tracefs_hist_key_type type)
+{
+	return tracefs_hist_add_key_cnt(hist, key, type, 0);
+}
+
 /**
  * tracefs_hist_add_value - add to a value to a histogram
  * @hist: The histogram to add the value to.
@@ -1391,7 +1446,7 @@ int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
 __hidden int synth_add_start_field(struct tracefs_synth *synth,
 				   const char *start_field,
 				   const char *name,
-				   enum tracefs_hist_key_type type)
+				   enum tracefs_hist_key_type type, int count)
 {
 	const struct tep_format_field *field;
 	const char *var;
@@ -1475,7 +1530,7 @@ int tracefs_synth_add_start_field(struct tracefs_synth *synth,
 				  const char *start_field,
 				  const char *name)
 {
-	return synth_add_start_field(synth, start_field, name, 0);
+	return synth_add_start_field(synth, start_field, name, 0, 0);
 }
 
 /**
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 5205356356a5..fd0a4b390855 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1280,7 +1280,7 @@ static void where_no_to_error(struct sqlhist_bison *sb, struct expr *expr,
 
 static int verify_field_type(struct tep_handle *tep,
 			     struct sqlhist_bison *sb,
-			     struct expr *expr)
+			     struct expr *expr, int *cnt)
 {
 	struct field *field = &expr->field;
 	struct tep_event *event;
@@ -1359,6 +1359,17 @@ static int verify_field_type(struct tep_handle *tep,
 		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
 			goto fail_type;
 		ret = TRACEFS_HIST_KEY_LOG;
+	} else if (!strncmp(type, "buckets", 7)) {
+		if (type[7] != '=' || !isdigit(type[8])) {
+			parse_error(sb, field->raw,
+				    "buckets type must have '=[number]' after it\n");
+			ret = -1;
+			goto out;
+		}
+		*cnt = atoi(&type[8]);
+		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_BUCKETS;
 	} else {
 		parse_error(sb, field->raw,
 			    "Cast of '%s' to unknown type '%s'\n",
@@ -1473,14 +1484,15 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 			    field->system == start_system &&
 			    field->event_name == start_event) {
 				int type;
-				type = verify_field_type(tep, table->sb, expr);
+				int cnt = 0;
+				type = verify_field_type(tep, table->sb, expr, &cnt);
 				if (type < 0)
 					goto free;
 				if (type != HIST_COUNTER_TYPE)
 					non_val = true;
 				ret = synth_add_start_field(synth,
 						field->field, field->label,
-						type);
+						type, cnt);
 			} else if (table->to) {
 				ret = tracefs_synth_add_end_field(synth,
 						field->field, field->label);
-- 
2.35.1

