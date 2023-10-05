Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CCD12B74
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 22:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F603C433C7;
	Thu,  5 Oct 2023 22:13:38 +0000 (UTC)
Date: Thu, 5 Oct 2023 18:14:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add traceeval_stat_max/min_timestamp() API
Message-ID: <20231005181448.176e9563@gandalf.local.home>
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

If a value field is flagged as a TIMESTAMP, and another field is flagged
as a STAT, have the statistics for the STAT field automatically keep track
of when the max and min happened (what the TIMESTAMP field was at those
instances).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |   4 ++
 src/eval-local.h    |   3 ++
 src/histograms.c    | 105 +++++++++++++++++++++++++++++++++++++-------
 3 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index a70a5b09057b..bbf8f6ac7dd1 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -242,6 +242,10 @@ unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_max_timestamp(struct traceeval_stat *stat,
+						unsigned long long *ts);
+unsigned long long traceeval_stat_min_timestamp(struct traceeval_stat *stat,
+						unsigned long long *ts);
 
 struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
 void traceeval_iterator_put(struct traceeval_iterator *iter);
diff --git a/src/eval-local.h b/src/eval-local.h
index 01b1b838e8bf..fabb1a06e7df 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -47,7 +47,9 @@ struct hash_table {
 
 struct traceeval_stat {
 	unsigned long long	max;
+	unsigned long long	max_ts;
 	unsigned long long	min;
+	unsigned long long	min_ts;
 	unsigned long long	total;
 	unsigned long long	std;
 	size_t			count;
@@ -72,6 +74,7 @@ struct traceeval {
 	size_t				nr_elements;
 	size_t				sizeof_type;
 	size_t				sizeof_data;
+	ssize_t				timestamp_idx;
 };
 
 struct traceeval_iterator {
diff --git a/src/histograms.c b/src/histograms.c
index 2be95e6a8d1f..0cf52225a03a 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -222,15 +222,32 @@ static int check_keys(struct traceeval_type *keys, int cnt)
 	return 0;
 }
 
-static int check_vals(struct traceeval_type *vals, int cnt)
+static int check_vals(struct traceeval *teval, struct traceeval_type *vals, int cnt)
 {
+	bool ts_found = false;
+
 	for (int i = 0; i < cnt && vals[i].type != TRACEEVAL_TYPE_NONE; i++) {
 		/* Define this as a value */
 		vals[i].flags |= TRACEEVAL_FL_VALUE;
 		vals[i].flags &= ~TRACEEVAL_FL_KEY;
 
+		if (vals[i].flags & TRACEEVAL_FL_TIMESTAMP) {
+			/* Only one field may be marked as a timestamp */
+			if (ts_found)
+				return -1;
+			/* The type must be numeric */
+			if (vals[i].type > TRACEEVAL_TYPE_NUMBER)
+				return -1;
+			/* TIMESTAMPS can not be STATs themselves */
+			if (vals[i].flags & TRACEEVAL_FL_STAT)
+				return -1;
+			ts_found = true;
+			teval->timestamp_idx = i;
+		}
 		vals[i].index = i;
 	}
+	if (!ts_found)
+		teval->timestamp_idx = -1;
 	return 0;
 }
 
@@ -298,7 +315,7 @@ struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 		goto fail_release;
 
 	if (vals) {
-		ret = check_vals(vals, nr_vals);
+		ret = check_vals(teval, vals, nr_vals);
 		if (ret < 0)
 			goto fail_release;
 	}
@@ -535,7 +552,8 @@ static bool is_stat_type(struct traceeval_type *type)
 static int copy_traceeval_data(struct traceeval_type *type,
 			       struct traceeval_stat *stat,
 			       struct traceeval_data *dst,
-			       const struct traceeval_data *src)
+			       const struct traceeval_data *src,
+			       unsigned long long ts)
 {
 	unsigned long long val;
 
@@ -599,21 +617,31 @@ static int copy_traceeval_data(struct traceeval_type *type,
 	if (!stat->count++) {
 		stat->max = val;
 		stat->min = val;
+		stat->max_ts = ts;
+		stat->min_ts = ts;
 		stat->total = val;
 		return 0;
 	}
 
 	if (type->flags & TRACEEVAL_FL_SIGNED) {
-		if ((long long)stat->max < (long long)val)
+		if ((long long)stat->max < (long long)val) {
 			stat->max = val;
-		if ((long long)stat->min > (long long)val)
+			stat->max_ts = ts;
+		}
+		if ((long long)stat->min > (long long)val) {
 			stat->min = val;
+			stat->min_ts = ts;
+		}
 		stat->total += (long long)val;
 	} else {
-		if (stat->max < val)
+		if (stat->max < val) {
+			stat->max_ts = ts;
 			stat->max = val;
-		if (stat->min > val)
+		}
+		if (stat->min > val) {
 			stat->min = val;
+			stat->min_ts = ts;
+		}
 		stat->total += val;
 	}
 
@@ -654,7 +682,8 @@ static void data_release_and_free(size_t size, struct traceeval_data **data,
 static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 				  struct traceeval_stat *stats,
 				  const struct traceeval_data *orig,
-				  struct traceeval_data **copy)
+				  struct traceeval_data **copy,
+				  unsigned long long ts)
 {
 	size_t i;
 
@@ -668,7 +697,7 @@ static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 
 	for (i = 0; i < size; i++) {
 		if (copy_traceeval_data(type + i, stats ? stats + i : NULL,
-					 (*copy) + i, orig + i))
+					 (*copy) + i, orig + i, ts))
 			goto fail;
 	}
 
@@ -754,6 +783,14 @@ static struct entry *create_hist_entry(struct traceeval *teval,
 	return entry;
 }
 
+static unsigned long long get_timestamp(struct traceeval *teval,
+					const struct traceeval_data *vals)
+{
+	if (teval->timestamp_idx < 0)
+		return 0;
+	return vals[teval->timestamp_idx].number_64;
+}
+
 /*
  * Create a new entry in @teval with respect to @keys and @vals.
  *
@@ -765,6 +802,7 @@ static int create_entry(struct traceeval *teval,
 {
 	struct traceeval_data *new_keys;
 	struct traceeval_data *new_vals;
+	unsigned long long ts;
 	struct entry *entry;
 
 	entry = create_hist_entry(teval, keys);
@@ -775,14 +813,16 @@ static int create_entry(struct traceeval *teval,
 	if (!entry->val_stats)
 		goto fail_entry;
 
+	ts = get_timestamp(teval, vals);
+
 	/* copy keys */
 	if (dup_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				   NULL, keys, &new_keys) == -1)
+				   NULL, keys, &new_keys, 0) == -1)
 		goto fail_stats;
 
 	/* copy vals */
 	if (dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				   entry->val_stats, vals, &new_vals) == -1)
+				   entry->val_stats, vals, &new_vals, ts) == -1)
 		goto fail;
 
 	entry->keys = new_keys;
@@ -818,12 +858,15 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	struct traceeval_type *types = teval->val_types;
 	struct traceeval_data *copy = entry->vals;
 	struct traceeval_data old[teval->nr_val_types];
+	unsigned long long ts;
 	size_t size = teval->nr_val_types;
 	ssize_t i;
 
 	if (!size)
 		return 0;
 
+	ts = get_timestamp(teval, vals);
+
 	for (i = 0; i < teval->nr_val_types; i++) {
 		if (vals[i].type != teval->val_types[i].type)
 			return -1;
@@ -833,7 +876,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 		old[i] = copy[i];
 
 		if (copy_traceeval_data(types + i, stats + i,
-					copy + i, vals + i))
+					copy + i, vals + i, ts))
 			goto fail;
 	}
 	data_release(size, old, types);
@@ -844,7 +887,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	/* Put back the old values */
 	for (i--; i >= 0; i--) {
 		copy_traceeval_data(types + i, NULL,
-				    copy + i, old + i);
+				    copy + i, old + i, 0);
 	}
 	return -1;
 }
@@ -889,6 +932,38 @@ struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 	return &entry->val_stats[type->index];
 }
 
+/**
+ * traceeval_stat_max_timestamp - return max value of stat and where it happend
+ * @stat: The stat structure that holds the stats
+ * @ts: The return value for the time stamp of where the max happened
+ *
+ * Returns the max value within @stat, and the timestamp of where that max
+ * happened in @ts.
+ */
+unsigned long long traceeval_stat_max_timestamp(struct traceeval_stat *stat,
+						unsigned long long *ts)
+{
+	if (ts)
+		*ts = stat->max_ts;
+	return stat->max;
+}
+
+/**
+ * traceeval_stat_min_timestamp - return min value of stat and where it happend
+ * @stat: The stat structure that holds the stats
+ * @ts: The return value for the time stamp of where the min happened
+ *
+ * Returns the min value within @stat, and the timestamp of where that min
+ * happened in @ts.
+ */
+unsigned long long traceeval_stat_min_timestamp(struct traceeval_stat *stat,
+						unsigned long long *ts)
+{
+	if (ts)
+		*ts = stat->min_ts;
+	return stat->min;
+}
+
 /**
  * traceeval_stat_max - return max value of stat
  * @stat: The stat structure that holds the stats
@@ -897,7 +972,7 @@ struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
  */
 unsigned long long traceeval_stat_max(struct traceeval_stat *stat)
 {
-	return stat->max;
+	return traceeval_stat_max_timestamp(stat, NULL);
 }
 
 /**
@@ -908,7 +983,7 @@ unsigned long long traceeval_stat_max(struct traceeval_stat *stat)
  */
 unsigned long long traceeval_stat_min(struct traceeval_stat *stat)
 {
-	return stat->min;
+	return traceeval_stat_min_timestamp(stat, NULL);
 }
 
 /**
-- 
2.40.1

