Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5EFC41513
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347566AbjHQBdp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345962AbjHQBdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19794273C
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D77664B65
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195DC433A9;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N4I-2D;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 11/18] libtraceeval histogram: Add iterator APIs
Date:   Wed, 16 Aug 2023 21:33:03 -0400
Message-Id: <20230817013310.88582-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
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
 src/histograms.c         | 258 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 275 insertions(+), 1 deletion(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 164d34c0fa81..e8a7981ac2c0 100644
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
index ed2e8abc9b63..5c3918f17cc1 100644
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
diff --git a/src/histograms.c b/src/histograms.c
index e0405ec31542..8cd1b288a7fc 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -37,7 +37,7 @@ static void print_err(const char *fmt, ...)
  */
 static int compare_traceeval_data(struct traceeval *teval,
 				  struct traceeval_type *type,
-				  union traceeval_data *orig,
+				  const union traceeval_data *orig,
 				  const union traceeval_data *copy)
 {
 	int i;
@@ -903,3 +903,259 @@ int traceeval_insert(struct traceeval *teval,
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
+	free(iter->direction);
+	free(iter->entries);
+	free(iter->sort);
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
+	int num_levels = level + 1;
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
+	if (num_levels > iter->nr_sort) {
+		sort = realloc(sort, sizeof(*sort) * num_levels);
+		if (!sort)
+			return -1;
+
+		iter->sort = sort;
+
+		direction = realloc(direction, sizeof(*direction) * num_levels);
+		if (!direction)
+			return -1;
+
+		iter->direction = direction;
+
+		/* Make sure the newly allocated contain NULL */
+		for (int i = iter->nr_sort; i < num_levels; i++)
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
+		ret = compare_traceeval_data(teval, type, dataA, dataB);
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

