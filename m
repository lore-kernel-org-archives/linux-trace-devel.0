Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D0423750
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78404C433C7;
	Wed,  4 Oct 2023 22:04:16 +0000 (UTC)
Date: Wed, 4 Oct 2023 18:05:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2] libtraceeval: Use name for type look up for
 traceeval_stat
Message-ID: <20231004180523.381cca3d@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions that retrieve the traceeval_stat currently requires passing
in the struct traceeval_type. But this is fragile, as it may not be set up
properly. It was originally done that way as a "fast" way to look up
stats, but in reality it will likely just cause more issues with wrong
types passed in. That decision was based more on defining policy which the
library should not do.

Instead, just pass in the string name of the value type to find and
retrieve the traceeval_data value from the traceeval that way.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20231003181237.616cc8db@gandalf.local.home

 - Update traceeval_stat() macro (Ross Zwisler)
 - Update sample task-eval.c code (Ross Zwisler)

 include/traceeval.h |  8 ++++----
 samples/task-eval.c | 12 ++++++------
 src/histograms.c    | 39 ++++++++++++++++++++++++++++++---------
 3 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 48c28dfc2f99..4cc5eb6ef3de 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -213,13 +213,13 @@ void traceeval_results_release(struct traceeval *teval,
 
 size_t traceeval_count(struct traceeval *teval);
 
-#define traceeval_stat(teval, keys, type)				\
-	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
+#define traceeval_stat(teval, keys, val_name)				\
+	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), val_name)
 
 struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 					   const struct traceeval_data *keys,
 					   size_t nr_keys,
-					   struct traceeval_type *type);
+					   const char *val_name);
 
 unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
@@ -239,7 +239,7 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const struct traceeval_data *results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
-					       struct traceeval_type *type);
+					       const char *val_name);
 int traceeval_iterator_remove(struct traceeval_iterator *iter);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 4421bd90ad3c..3808212e2e84 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -631,11 +631,11 @@ static int compare_pdata(struct traceeval *teval_data,
 	}
 
 	/* Get the RUNNING values for both processes */
-	statA = traceeval_stat(teval, keysA, &delta_vals[0]);
+	statA = traceeval_stat(teval, keysA, delta_vals[0].name);
 	if (statA)
 		totalA = traceeval_stat_total(statA);
 
-	statB = traceeval_stat(teval, keysB, &delta_vals[0]);
+	statB = traceeval_stat(teval, keysB, delta_vals[0].name);
 	if (statB)
 		totalB = traceeval_stat_total(statB);
 
@@ -666,7 +666,7 @@ static void display_cpus(struct traceeval *teval)
 		int state = keys[1].number;
 		int cpu = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
 		if (!stat)
 			continue; // die?
 
@@ -733,7 +733,7 @@ static void display_threads(struct traceeval *teval)
 		int state = keys[1].number;
 		int tid = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
 		if (!stat)
 			continue; // die?
 
@@ -771,7 +771,7 @@ static void display_process_stats(struct traceeval *teval,
 		TRACEEVAL_SET_NUMBER(keys[1], i);
 
 		delta = 0;
-		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		stat = traceeval_stat(teval, keys, delta_vals[0].name);
 		if (stat)
 			delta = traceeval_stat_total(stat);
 		display_state_times(i, delta);
@@ -831,7 +831,7 @@ static void display(struct task_data *tdata)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int state = keys[1].number;
 
-		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
 		if (!stat)
 			continue;
 
diff --git a/src/histograms.c b/src/histograms.c
index 3ba7687af9bb..2be95e6a8d1f 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -849,17 +849,36 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	return -1;
 }
 
+static struct traceeval_type *find_val_type(struct traceeval *teval, const char *name)
+{
+	struct traceeval_type *type;
+	int i;
+
+	for (i = 0; i < teval->nr_val_types; i++) {
+		type = &teval->val_types[i];
+
+		if (strcmp(type->name, name) == 0)
+			return type;
+	}
+	return NULL;
+}
+
 struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 					   const struct traceeval_data *keys,
 					   size_t nr_keys,
-					   struct traceeval_type *type)
+					   const char *val_name)
 {
+	struct traceeval_type *type;
 	struct entry *entry;
 	int ret;
 
 	if (teval->nr_key_types != nr_keys)
 		return NULL;
 
+	type = find_val_type(teval, val_name);
+	if (!type)
+		return NULL;
+
 	if (!is_stat_type(type))
 		return NULL;
 
@@ -1116,12 +1135,9 @@ static struct traceeval_type *find_sort_type(struct traceeval *teval,
 	int i;
 
 	/* Check values first, and then keys */
-	for (i = 0; i < teval->nr_val_types; i++) {
-		type = &teval->val_types[i];
-
-		if (strcmp(type->name, name) == 0)
-			return type;
-	}
+	type = find_val_type(teval, name);
+	if (type)
+		return type;
 
 	for (i = 0; i < teval->nr_key_types; i++) {
 		type = &teval->key_types[i];
@@ -1426,16 +1442,21 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 /**
  * traceeval_iterator_stat - return the stats from the last iterator entry
  * @iter: The iterator to retrieve the stats from
- * @type: The value type to get the stat from
+ * @val_name: The name of the value to get the stat from
  *
  * Returns the stats of the @type for the current iterator entry on success,
  * or NULL if not found or an error occurred.
  */
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
-					       struct traceeval_type *type)
+					       const char *val_name)
 {
+	struct traceeval_type *type;
 	struct entry *entry;
 
+	type = find_val_type(iter->teval, val_name);
+	if (!type)
+		return NULL;
+
 	if (!is_stat_type(type))
 		return NULL;
 
-- 
2.40.1

