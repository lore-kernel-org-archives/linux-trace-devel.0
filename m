Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93037C2FC15
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347552AbjHQBds (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347537AbjHQBdN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0495E1FC3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D07564CA6
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE52C433AB;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N4E-28;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 10/18] libtraceeval histogram: Add updating of stats
Date:   Wed, 16 Aug 2023 21:33:02 -0400
Message-Id: <20230817013310.88582-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Whenever an entry is added that already exists (overwriting the values)
keep track of the stats for the number values (max, min, total, count).

Also move the stat structure out of the public view. We may want to modify
this structure in the future, and so it should not become an API.

Add accessor functions to get to the stat values.

Add traceeval_stat() to acquire a stat handle from a specific key for a
specific value.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  17 ++--
 src/eval-local.h         |   9 ++
 src/histograms.c         | 182 +++++++++++++++++++++++++++++++++++----
 3 files changed, 183 insertions(+), 25 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index f80d039baa61..164d34c0fa81 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -130,13 +130,7 @@ struct traceeval_type {
 };
 
 /* Statistics about a given entry element */
-struct traceeval_stat {
-	unsigned long long	max;
-	unsigned long long	min;
-	unsigned long long	total;
-	unsigned long long	avg;
-	unsigned long long	std;
-};
+struct traceeval_stat;
 
 /* Iterator over aggregated data */
 struct traceeval_iterator;
@@ -160,4 +154,13 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 void traceeval_results_release(struct traceeval *teval,
 			       union traceeval_data *results);
 
+struct traceeval_stat *traceeval_stat(struct traceeval *teval,
+				      const union traceeval_data *keys,
+				      struct traceeval_type *type);
+
+unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
+
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/eval-local.h b/src/eval-local.h
index 007fdb146b96..ed2e8abc9b63 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -45,11 +45,20 @@ struct hash_table {
 	struct hash_iter	iter;
 };
 
+struct traceeval_stat {
+	unsigned long long	max;
+	unsigned long long	min;
+	unsigned long long	total;
+	unsigned long long	std;
+	size_t			count;
+};
+
 /* A key-value pair */
 struct entry {
 	struct hash_item	hash;
 	union traceeval_data	*keys;
 	union traceeval_data	*vals;
+	struct traceeval_stat	*val_stats;
 };
 
 /* Histogram */
diff --git a/src/histograms.c b/src/histograms.c
index 808979915369..e0405ec31542 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -505,21 +505,85 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
  * Return 0 on success, -1 on error.
  */
 static int copy_traceeval_data(struct traceeval_type *type,
-				const union traceeval_data *orig,
-				union traceeval_data *copy)
+			       struct traceeval_stat *stat,
+			       const union traceeval_data *orig,
+			       union traceeval_data *copy)
 {
+	unsigned long long val;
+
 	*copy = *orig;
 
-	if (type->type == TRACEEVAL_TYPE_STRING) {
+	switch(type->type) {
+	case TRACEEVAL_TYPE_NUMBER:
+		if (type->flags & TRACEEVAL_FL_SIGNED)
+			val = (long long)copy->number;
+		else
+			val = (unsigned long long)copy->number;
+		break;
+
+	case TRACEEVAL_TYPE_NUMBER_64:
+		if (type->flags & TRACEEVAL_FL_SIGNED)
+			val = (long long)copy->number_64;
+		else
+			val = (unsigned long long)copy->number_64;
+		break;
+
+	case TRACEEVAL_TYPE_NUMBER_32:
+		if (type->flags & TRACEEVAL_FL_SIGNED)
+			val = (long long)copy->number_32;
+		else
+			val = (unsigned long long)copy->number_32;
+		break;
+
+	case TRACEEVAL_TYPE_NUMBER_16:
+		if (type->flags & TRACEEVAL_FL_SIGNED)
+			val = (long long)copy->number_16;
+		else
+			val = (unsigned long long)copy->number_16;
+		break;
+
+	case TRACEEVAL_TYPE_NUMBER_8:
+		if (type->flags & TRACEEVAL_FL_SIGNED)
+			val = (long long)copy->number_8;
+		else
+			val = (unsigned long long)copy->number_8;
+		break;
+
+	case TRACEEVAL_TYPE_STRING:
 		copy->string = NULL;
 
 		if (orig->string)
 			copy->string = strdup(orig->string);
-		else
-			return 0;
 
 		if (!copy->string)
 			return -1;
+		return 0;
+	default:
+		return 0;
+	}
+
+	if (!stat)
+		return 0;
+
+	if (!stat->count++) {
+		stat->max = val;
+		stat->min = val;
+		stat->total = val;
+		return 0;
+	}
+
+	if (type->flags & TRACEEVAL_FL_SIGNED) {
+		if ((long long)stat->max < (long long)val)
+			stat->max = val;
+		if ((long long)stat->min > (long long)val)
+			stat->min = val;
+		stat->total += (long long)val;
+	} else {
+		if (stat->max < val)
+			stat->max = val;
+		if (stat->min > val)
+			stat->min = val;
+		stat->total += val;
 	}
 
 	return 0;
@@ -548,6 +612,7 @@ static void data_release(size_t size, union traceeval_data **data,
  */
 static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
 				    const union traceeval_data *orig,
+				    struct traceeval_stat *stats,
 				    union traceeval_data **copy)
 {
 	size_t i;
@@ -561,7 +626,8 @@ static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
 		return -1;
 
 	for (i = 0; i < size; i++) {
-		if (copy_traceeval_data(type + i, orig + i, (*copy) + i))
+		if (copy_traceeval_data(type + i, stats ? stats + i : NULL,
+					orig + i, (*copy) + i))
 			goto fail;
 	}
 
@@ -604,7 +670,7 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 		return check;
 
 	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-			entry->vals, results);
+			entry->vals, NULL, results);
 }
 
 /*
@@ -659,18 +725,22 @@ static int create_entry(struct traceeval *teval,
 	union traceeval_data *new_vals;
 	struct entry *entry;
 
+	entry = create_hist_entry(teval, keys);
+	if (!entry)
+		return -1;
+
+	entry->val_stats = calloc(teval->nr_key_types, sizeof(*entry->val_stats));
+	if (!entry->val_stats)
+		goto fail_entry;
+
 	/* copy keys */
 	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				keys, &new_keys) == -1)
-		return -1;
+				keys, NULL, &new_keys) == -1)
+		goto fail_stats;
 
 	/* copy vals */
 	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, &new_vals) == -1)
-		goto fail_vals;
-
-	entry = create_hist_entry(teval, keys);
-	if (!entry)
+				vals, entry->val_stats, &new_vals) == -1)
 		goto fail;
 
 	entry->keys = new_keys;
@@ -679,10 +749,13 @@ static int create_entry(struct traceeval *teval,
 	return 0;
 
 fail:
-	data_release(teval->nr_val_types, &new_vals, teval->val_types);
-
-fail_vals:
 	data_release(teval->nr_key_types, &new_keys, teval->key_types);
+
+fail_stats:
+	free(entry->val_stats);
+
+fail_entry:
+	free(entry);
 	return -1;
 }
 
@@ -699,7 +772,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	union traceeval_data *new_vals;
 
 	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, &new_vals) == -1)
+				vals, entry->val_stats, &new_vals) == -1)
 		return -1;
 
 	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
@@ -707,6 +780,79 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	return 0;
 }
 
+struct traceeval_stat *traceeval_stat(struct traceeval *teval,
+				      const union traceeval_data *keys,
+				      struct traceeval_type *type)
+{
+	struct entry *entry;
+	int ret;
+
+	/* Only value numbers have stats */
+	if (!(type->flags & TRACEEVAL_FL_VALUE))
+		return NULL;
+
+	switch (type->type) {
+	case TRACEEVAL_TYPE_NUMBER:
+	case TRACEEVAL_TYPE_NUMBER_64:
+	case TRACEEVAL_TYPE_NUMBER_32:
+	case TRACEEVAL_TYPE_NUMBER_16:
+	case TRACEEVAL_TYPE_NUMBER_8:
+		break;
+	default:
+		return NULL;
+	}
+
+	ret = get_entry(teval, keys, &entry);
+	if (ret <= 0)
+		return NULL;
+
+	return &entry->val_stats[type->index];
+}
+
+/**
+ * traceeval_stat_max - return max value of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the max value within @stat.
+ */
+unsigned long long traceeval_stat_max(struct traceeval_stat *stat)
+{
+	return stat->max;
+}
+
+/**
+ * traceeval_stat_min - return min value of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the min value within @stat.
+ */
+unsigned long long traceeval_stat_min(struct traceeval_stat *stat)
+{
+	return stat->min;
+}
+
+/**
+ * traceeval_stat_total - return total value of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the total value within @stat.
+ */
+unsigned long long traceeval_stat_total(struct traceeval_stat *stat)
+{
+	return stat->total;
+}
+
+/**
+ * traceeval_stat_count - return count value of stat
+ * @stat: The stat structure that holds the stats
+ *
+ * Returns the count value within @stat.
+ */
+unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
+{
+	return stat->count;
+}
+
 /*
  * traceeval_insert - insert an item into the traceeval descriptor
  * @teval: The descriptor to insert into
-- 
2.40.1

