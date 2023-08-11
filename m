Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F4EC41513
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjHKFjx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjHKFjs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5769D2D52
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15A24655E0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D6C433A9;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uQF-34;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 11/17] libtraceeval histogram: Add iterator APIs
Date:   Fri, 11 Aug 2023 01:39:34 -0400
Message-Id: <20230811053940.1408424-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Provide an interface for the application to iterate over all the entries
in the traceeval histogram.

 traceeval_iterator_get() - acquire an iterator for the given traceeval
 traceveal_iterator_put() - release the iterator
 traceeval_iterator_sort() - sort the iterator for a given key/value
 traceeval_iterator_next() - return the keys of the next entry in the
                             traceeval

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |   7 ++
 src/eval-local.h         |  11 ++
 src/hash.c               |   4 +
 src/histograms.c         | 255 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 276 insertions(+), 1 deletion(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index d061a4532b06..2fc81a64e324 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -163,4 +163,11 @@ unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
 
+struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
+void traceeval_iterator_put(struct traceeval_iterator *iter);
+int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
+			    int level, bool ascending);
+int traceeval_iterator_next(struct traceeval_iterator *iter,
+			    const union traceeval_data **keys);
+
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/eval-local.h b/src/eval-local.h
index 190b19db14d2..c3ea920ed2e8 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -70,6 +70,17 @@ struct traceeval {
 	size_t				nr_val_types;
 };
 
+struct traceeval_iterator {
+	struct traceeval		*teval;
+	struct entry			**entries;
+	struct traceeval_type		**sort;
+	bool				*direction;
+	size_t				nr_entries;
+	size_t				nr_sort;
+	size_t				next;
+	bool				needs_sort;
+};
+
 extern struct hash_table *hash_alloc(void);
 extern void hash_free(struct hash_table *hash);
 extern void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key);
diff --git a/src/hash.c b/src/hash.c
index e4f2a983d39c..221145efcbb9 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -67,6 +67,7 @@ __hidden struct hash_iter *hash_iter_start(struct hash_table *hash)
 		if (!hash->hash[i])
 			continue;
 		iter->next_item = hash->hash[i];
+		break;
 	}
 	iter->current_bucket = i;
 	return iter;
@@ -81,6 +82,8 @@ __hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
 		return NULL;
 
 	item = iter->next_item;
+	if (!item)
+		return NULL;
 
 	iter->next_item = item->next;
 	if (!iter->next_item) {
@@ -90,6 +93,7 @@ __hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
 			if (!hash->hash[i])
 				continue;
 			iter->next_item = hash->hash[i];
+			break;
 		}
 		iter->current_bucket = i;
 	}
diff --git a/src/histograms.c b/src/histograms.c
index 9a8ec4d85301..2b823ad5c26d 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -37,7 +37,7 @@ static void print_err(const char *fmt, ...)
  * -1 for the other way around, and -2 on error.
  */
 static int compare_traceeval_data(struct traceeval *teval,
-				  union traceeval_data *orig,
+				  const union traceeval_data *orig,
 				  const union traceeval_data *copy,
 				  struct traceeval_type *type)
 {
@@ -904,3 +904,256 @@ int traceeval_insert(struct traceeval *teval,
 	else
 		return update_entry(teval, entry, vals);
 }
+
+/**
+ * traceeval_iterator_put - release a given iterator
+ * @iter: The iterartor to release
+ *
+ * Frees the resources of an @iter that was created by
+ * traceeval_iterator_get().
+ */
+void traceeval_iterator_put(struct traceeval_iterator *iter)
+{
+	if (!iter)
+		return;
+
+	free(iter->entries);
+	free(iter);
+}
+
+/**
+ * traceeval_iterator_get - get a handle to iterate over a given traceeval
+ * @teval: The traceeval handle to iterate over
+ *
+ * Returns a handle to iterate over the given @teval. Must be freed with
+ * traceeval_iterator_put(). It can be used with traceeval_iterator_next()
+ * to retrieve the keys of the next entry in @teval.
+ *
+ * Use traceeval_iterator_sort() to specify the order of the entries
+ * returned by traceeval_iterator_next().
+ *
+ * Returns an allocated iterator on success, and NULL on failure.
+ */
+struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval)
+{
+	struct traceeval_iterator *iter;
+	struct hash_table *hist = teval->hist;
+	struct hash_iter *hiter;
+	struct hash_item *item;
+	int i;
+
+	iter = calloc(1, sizeof(*iter));
+	if (!iter)
+		return NULL;
+
+	iter->teval = teval;
+	iter->nr_entries = hash_nr_items(hist);
+	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
+	if (!iter->entries) {
+		free(iter);
+		return NULL;
+	}
+
+	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
+		struct entry *entry = container_of(item, struct entry, hash);
+
+		iter->entries[i] = entry;
+	}
+
+	/* Loop must match entries */
+	if (i != iter->nr_entries) {
+		traceeval_iterator_put(iter);
+		return NULL;
+	}
+
+	return iter;
+}
+
+static struct traceeval_type *find_sort_type(struct traceeval *teval,
+					     const char *name)
+{
+	struct traceeval_type *type;
+	int i;
+
+	/* Check values first, and then keys */
+	for (i = 0; i < teval->nr_val_types; i++) {
+		type = &teval->val_types[i];
+
+		if (strcmp(type->name, name) == 0)
+			return type;
+	}
+
+	for (i = 0; i < teval->nr_key_types; i++) {
+		type = &teval->key_types[i];
+
+		if (strcmp(type->name, name) == 0)
+			return type;
+	}
+
+	return NULL;
+}
+
+/**
+ * traceeval_iterator_sort - sort the entries that an iterator will return
+ * @iter: The iterator to specify the sort order of the entries
+ * @sort_field: The name of the key or value to sort with.
+ * @level: The level of sorting (0 for first order, 1 for second, ...)
+ * @ascending: If the sort should go forward or backward.
+ *
+ * The iterator has a list of entries to produce with traceeval_iterator_next().
+ * This function specifies what the order of the output of that function will
+ * be. Note, whenever this function is called, it resets the @iter so that
+ * the traceveal_iterator_next() will start from the beginning again.
+ *
+ * In other words, be very careful to ever call this function in a middle
+ * of a loop that is using traceeval_iterator_next(), otherwise you may end
+ * up in an infinite loop!
+ *
+ * The @level specifies the level of sorting. That is, for @level = 0,
+ * it will decide the main sorting of the @iter. For @level = 1, it will
+ * be the tie breaker for two entries that are equal for the @level = 0
+ * sort. @level = 2, will be the tie breaker for @level = 1, and so on.
+ *
+ * Note, if traceeval_iterator_next() is called, and there's a missing @level,
+ * it will fail. That is, if this function is called once with @level = 0 and
+ * againg with @level = 2, but never with @level = 1, the call to
+ * traceeval_iterator_next() will fail.
+ *
+ * If this function is called multiple times with the same @level, then the
+ * last call will define the what that @level will do.
+ *
+ * The @ascending will determine if "smaller" items go first if true, and
+ * "larger" items go first if false.
+ *
+ * Return 0 on success and -1 on failure.
+ */
+int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
+			    int level, bool ascending)
+{
+	bool *direction = iter->direction;
+	struct traceeval_type **sort = iter->sort;
+	struct traceeval_type *type;
+
+	type = find_sort_type(iter->teval, sort_field);
+	if (!type)
+		return -1;
+
+	/* pointer and dynamic types must have a cmp function */
+	switch (type->type) {
+	case TRACEEVAL_TYPE_POINTER:
+	case TRACEEVAL_TYPE_DYNAMIC:
+		if (!type->cmp)
+			return -1;
+		break;
+	default:
+		break;
+	}
+
+	if ((level + 1) > iter->nr_sort) {
+		sort = realloc(sort, sizeof(*sort) * (level + 1));
+		if (!sort)
+			return -1;
+
+		iter->sort = sort;
+
+		direction = realloc(direction, sizeof(*direction) * (level + 1));
+		if (!direction)
+			return -1;
+
+		iter->direction = direction;
+
+		/* Make sure the newly allocated contain NULL */
+		for (int i = iter->nr_sort; i < (level + 1); i++)
+			sort[i] = NULL;
+
+		iter->nr_sort = level + 1;
+	}
+
+	sort[level] = type;
+	direction[level] = ascending;
+	iter->needs_sort = true;
+	return 0;
+}
+
+static int iter_cmp(const void *A, const void *B, void *data)
+{
+	struct traceeval_iterator *iter = data;
+	struct traceeval *teval = iter->teval;
+	const struct entry *a = *((const struct entry **)A);
+	const struct entry *b = *((const struct entry **)B);
+	int ret;
+
+	for (int i = 0; i < iter->nr_sort; i++) {
+		struct traceeval_type *type;
+		union traceeval_data *dataA;
+		union traceeval_data *dataB;
+
+		type = iter->sort[i];
+
+		if (type->flags & TRACEEVAL_FL_KEY) {
+			dataA = &a->keys[type->index];
+			dataB = &b->keys[type->index];
+		} else {
+			dataA = &a->vals[type->index];
+			dataB = &b->vals[type->index];
+		}
+
+		ret = compare_traceeval_data(teval, dataA, dataB, type);
+
+		if (ret)
+			return iter->direction[i] ? ret : ret * -1;
+	}
+
+	return 0;
+}
+
+static int sort_iter(struct traceeval_iterator *iter)
+{
+	int i;
+
+	/* Make sure all levels are filled */
+	for (i = 0; i < iter->nr_sort; i++) {
+		if (!iter->sort[i])
+			return -1;
+	}
+
+	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
+		iter_cmp, iter);
+
+	iter->needs_sort = false;
+	iter->next = 0;
+
+	return 0;
+}
+
+/**
+ * traceeval_iterator_next - retrieve the next entry from an iterator
+ * @iter: The iterator to retrieve the next entry from
+ * @keys: The returned keys of the next entry (if exists)
+ *
+ * This returns the keys for the next entry in the traceeval being
+ * iterated over by @iter. If there are no more entries, 0 is returned
+ * and @keys are untouched.
+ *
+ * Returns 1 if another entry is returned, or 0 if not (or negative on error)
+ */
+int traceeval_iterator_next(struct traceeval_iterator *iter,
+			    const union traceeval_data **keys)
+{
+	struct entry *entry;
+	int ret;
+
+	if (iter->needs_sort) {
+		ret = sort_iter(iter);
+		if (ret < 0)
+			return ret;
+		iter->next = 0;
+	}
+
+	if (iter->next >= iter->nr_entries)
+		return 0;
+
+	entry = iter->entries[iter->next++];
+	*keys = entry->keys;
+	return 1;
+}
-- 
2.40.1

