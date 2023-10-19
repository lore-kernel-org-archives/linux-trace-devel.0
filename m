Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412883550A
	for <linux-trace-devel@vger.kernel.org>; Thu, 19 Oct 2023 21:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC8AC433CD;
	Thu, 19 Oct 2023 21:12:36 +0000 (UTC)
Date: Thu, 19 Oct 2023 17:12:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez   
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Replace hash lookup with red-black tree
Message-ID: <20231019171232.65951bac@gandalf.local.home>
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

When starting to write another tool that will look at all of an existing
traceeval during the run, I found that the hash table is not efficient
when needing to iterate events in the fast path. That's because the hash
buckets can be large (1024 buckets in size), and to iterate all elements in
the traceeval will require iterating all the buckets even when there's only
a few items in the traceeval.

One solution could have been just to add a link list of all elements, but
this would require two indices to maintain. Instead, switching to a
red-black tree is what I decided to go with. One, I had just written one
for libtracecmd[1], and two, it will always be a O(log(n)) lookup, where as
a hash, if unlucky, could be O(n).

[1] https://lore.kernel.org/all/20231019165205.371e8092@gandalf.local.home/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/Makefile     |   2 +-
 src/delta.c      |  11 +-
 src/eval-local.h |  94 ++++------
 src/hash.c       | 123 -------------
 src/histograms.c | 179 ++++++-------------
 src/rbtree.c     | 455 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 549 insertions(+), 315 deletions(-)
 delete mode 100644 src/hash.c
 create mode 100644 src/rbtree.c

diff --git a/src/Makefile b/src/Makefile
index a5a36261d662..8c2cdee81f9b 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -5,7 +5,7 @@ include $(src)/scripts/utils.mk
 OBJS =
 OBJS += histograms.o
 OBJS += delta.o
-OBJS += hash.o
+OBJS += rbtree.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
diff --git a/src/delta.c b/src/delta.c
index c83aa9a39756..b00f7cf4ee7a 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -358,22 +358,19 @@ int traceeval_delta_stop_size(struct traceeval *teval,
 static int create_delta_iter_array(struct traceeval_iterator *iter)
 {
 	struct traceeval *teval = iter->teval;
-	struct hash_table *hist = teval->hist;
-	struct hash_iter *hiter;
-	struct hash_item *item;
+	struct teval_rbtree_node *node = NULL;
 	size_t ts_idx = teval->nr_val_types - 1;
 	size_t idx = 0;
-	int i;
 
-	iter->nr_entries = hash_nr_items(hist);
+	iter->nr_entries = teval->tree.nr_nodes;
 	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
 	if (!iter->entries) {
 		teval_print_err(TEVAL_CRIT, "Failed to allocate entries");
 		return -1;
 	}
 
-	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
-		struct entry *entry = container_of(item, struct entry, hash);
+	while ((node = teval_rbtree_next(teval, node))) {
+		struct entry *entry = container_of(node, struct entry, node);
 
 		/* Only add entries where the timestamp is non zero */
 		if (!entry->vals[ts_idx].number_64)
diff --git a/src/eval-local.h b/src/eval-local.h
index 4f5f702434f1..c34a67c4de23 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -2,6 +2,7 @@
 #ifndef __EVAL_LOCAL_H
 #define __EVAL_LOCAL_H
 
+#include <traceeval.h>
 #include <string.h>
 
 /* For possible future use */
@@ -15,11 +16,6 @@
 #define container_of(ptr, type, field) \
 	(type *)((void *)(ptr) - (void *)offset_of(type, field))
 
-#define HASH_BITS 10	/* Start with 1K of buckets */
-#define HASH_SIZE(bits)	(1 << (bits))
-#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
-
-
 extern void __attribute__ ((format (printf, 2, 3)))
  teval_print_err(int level, const char *fmt, ...);
 
@@ -36,22 +32,25 @@ do {					\
 	return (a) != (b);		\
 } while (0)				\
 
-struct hash_item {
-	struct hash_item	*next;
-	unsigned		key;
+struct teval_rbtree_node {
+	struct teval_rbtree_node	*parent;
+	struct teval_rbtree_node	*left;
+	struct teval_rbtree_node	*right;
+	int				color;
 };
 
-struct hash_iter {
-	struct hash_item	*next_item;
-	size_t			current_bucket;
-};
+typedef int (*teval_rbtree_cmp_fn)(struct traceeval *teval,
+				   const struct teval_rbtree_node *A, const struct teval_rbtree_node *B);
 
-/* A table of key-value entries */
-struct hash_table {
-	struct hash_item	**hash;
-	unsigned		bits;
-	size_t			nr_items;
-	struct hash_iter	iter;
+typedef int (*teval_rbtree_search_fn)(struct traceeval *teval,
+				      const struct teval_rbtree_node *n,
+				      const struct traceeval_data *keys);
+
+struct teval_rbtree {
+	struct teval_rbtree_node	*node;
+	teval_rbtree_search_fn		search;
+	teval_rbtree_cmp_fn		cmp;
+	size_t				nr_nodes;
 };
 
 struct traceeval_stat {
@@ -67,11 +66,11 @@ struct traceeval_stat {
 
 /* A key-value pair */
 struct entry {
-	struct hash_item	hash;
-	struct traceeval_data	*keys;
-	struct traceeval_data	*vals;
-	struct traceeval_stat	*val_stats;
-	size_t			hitcount;
+	struct teval_rbtree_node	node;
+	struct traceeval_data		*keys;
+	struct traceeval_data		*vals;
+	struct traceeval_stat		*val_stats;
+	size_t				hitcount;
 };
 
 enum {
@@ -84,8 +83,8 @@ struct traceeval_delta;
 struct traceeval {
 	struct traceeval_type		*key_types;
 	struct traceeval_type		*val_types;
-	struct hash_table		*hist;
 	struct traceeval_delta		*tdelta;
+	struct teval_rbtree		tree;
 	unsigned int			flags;
 	ssize_t				nr_key_types;
 	ssize_t				nr_val_types;
@@ -122,49 +121,20 @@ extern int _teval_get_entry(struct traceeval *teval, const struct traceeval_data
 extern void _teval_update_stat(struct traceeval_type *type, struct traceeval_stat *stat,
 			       unsigned long long val, unsigned long long ts);
 
-extern struct hash_table *hash_alloc(void);
-extern void hash_free(struct hash_table *hash);
-extern void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key);
-extern int hash_remove(struct hash_table *hash, struct hash_item *item);
-
-extern struct hash_iter *hash_iter_start(struct hash_table *hash);
-extern struct hash_item *hash_iter_next(struct hash_iter *iter);
-
-extern struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key);
-extern struct hash_item *hash_iter_bucket_next(struct hash_iter *iter);
-
 extern void __delta_release(struct traceeval_delta *tdelta);
 
-static inline size_t hash_nr_items(struct hash_table *hash)
-{
-	return hash->nr_items;
-}
-
-static inline unsigned long long hash_string(const char *str)
-{
-	unsigned long long key = 0;
-	int len = strlen(str);
-	int i;
-
-	for (i = 0; i < len; i++)
-		key += (unsigned long long)str[i] << ((i & 7) * 8);
-
-	return key;
-}
-
 int _teval_insert(struct traceeval *teval,
 		  const struct traceeval_data *keys, size_t nr_keys,
 		  const struct traceeval_data *vals, size_t nr_vals);
 
- /*
- * This is a quick hashing function adapted from Donald E. Knuth's 32
- * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
- * Multiplication by the Prime number, closest to the golden ratio of
- * 2^32.
- */
-static inline unsigned long long hash_number(unsigned long long val)
-{
-		return val * 2654435761ULL;
-}
+void teval_rbtree_init(struct traceeval *teval, teval_rbtree_cmp_fn cmp_fn,
+		       teval_rbtree_search_fn search_fn);
+struct teval_rbtree_node *teval_rbtree_find(struct traceeval *teval,
+					    const struct traceeval_data *keys);
+void teval_rbtree_delete(struct traceeval *teval, struct teval_rbtree_node *node);
+int teval_rbtree_insert(struct traceeval *teval, struct teval_rbtree_node *node);
+struct teval_rbtree_node *teval_rbtree_next(struct traceeval *teval,
+					    struct teval_rbtree_node *node);
+struct teval_rbtree_node *teval_rbtree_pop_nobalance(struct traceeval *teval);
 
 #endif
diff --git a/src/hash.c b/src/hash.c
deleted file mode 100644
index eceebe29d766..000000000000
--- a/src/hash.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * libtraceeval hashtable interface implementation.
- *
- * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
- */
-
-#include <traceeval.h>
-
-#include "eval-local.h"
-
-__hidden struct hash_table *hash_alloc(void)
-{
-	struct hash_table *hash;
-
-	hash = calloc(1, sizeof(*hash));
-	if (!hash)
-		return NULL;
-
-	hash->bits = HASH_BITS;
-	hash->hash = calloc(HASH_SIZE(hash->bits), sizeof(*hash->hash));
-	if (!hash->hash) {
-		free(hash);
-		hash = NULL;
-	}
-
-	return hash;
-}
-
-__hidden void hash_free(struct hash_table *hash)
-{
-	free(hash->hash);
-	free(hash);
-}
-
-__hidden void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key)
-{
-	key &= HASH_MASK(hash->bits);
-
-	item->next = hash->hash[key];
-	hash->hash[key] = item;
-	item->key = key;
-
-	hash->nr_items++;
-}
-
-__hidden int hash_remove(struct hash_table *hash, struct hash_item *item)
-{
-	struct hash_item **parent;
-
-	for (parent = &hash->hash[item->key]; *parent; parent = &(*parent)->next) {
-		if (*parent == item) {
-			*parent = item->next;
-			hash->nr_items--;
-			return 1;
-		}
-	}
-	return 0;
-}
-
-__hidden struct hash_iter *hash_iter_start(struct hash_table *hash)
-{
-	struct hash_iter *iter = &hash->iter;
-	size_t i;
-
-	for (i = 0; i < HASH_SIZE(hash->bits); i++) {
-		if (!hash->hash[i])
-			continue;
-		iter->next_item = hash->hash[i];
-		break;
-	}
-	iter->current_bucket = i;
-	return iter;
-}
-
-__hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
-{
-	struct hash_table *hash = container_of(iter, struct hash_table, iter);
-	struct hash_item *item;
-
-	if (iter->current_bucket >= HASH_SIZE(hash->bits))
-		return NULL;
-
-	item = iter->next_item;
-	if (!item)
-		return NULL;
-
-	iter->next_item = item->next;
-	if (!iter->next_item) {
-		size_t i;
-
-		for (i = iter->current_bucket + 1; i < HASH_SIZE(hash->bits); i++) {
-			if (!hash->hash[i])
-				continue;
-			iter->next_item = hash->hash[i];
-			break;
-		}
-		iter->current_bucket = i;
-	}
-	return item;
-}
-
-__hidden struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key)
-{
-	struct hash_iter *iter = &hash->iter;
-
-	key &= HASH_MASK(hash->bits);
-
-	iter->current_bucket = key;
-	iter->next_item = hash->hash[key];
-
-	return iter;
-}
-
-__hidden struct hash_item *hash_iter_bucket_next(struct hash_iter *iter)
-{
-	struct hash_item *item = iter->next_item;
-
-	if (item)
-		iter->next_item = item->next;
-
-	return item;
-}
diff --git a/src/histograms.c b/src/histograms.c
index f6bbc4444361..8069722fc1ea 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -115,12 +115,12 @@ static int compare_traceeval_data(struct traceeval *teval,
 
 	if (!orig) {
 		teval_print_err(TEVAL_INFO, "No source data passed in to compare");
-		return -1;
+		return -2;
 	}
 
 	if (!copy) {
 		teval_print_err(TEVAL_INFO, "No destination data passed in to compare");
-		return -1;
+		return -2;
 	}
 
 	if (type->cmp)
@@ -157,28 +157,6 @@ static int compare_traceeval_data(struct traceeval *teval,
 	}
 }
 
-/*
- * Compare arrays of struct traceeval_data's with respect to @def.
- *
- * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
- */
-static int compare_traceeval_data_set(struct traceeval *teval,
-				      struct traceeval_type *defs,
-				      struct traceeval_data *orig,
-				      const struct traceeval_data *copy, size_t size)
-{
-	int check;
-	size_t i;
-
-	/* compare data arrays */
-	for (i = 0; i < size; i++) {
-		if ((check = compare_traceeval_data(teval, defs + i, orig + i, copy + i)))
-			return check == -2 ? -1 : 0;
-	}
-
-	return 1;
-}
-
 /*
  * type_release - free a struct traceeval_type array
  * @defs: The array to release
@@ -341,6 +319,11 @@ static int check_vals(struct traceeval *teval, struct traceeval_type *vals, int
 	return 0;
 }
 
+static int key_cmp(struct traceeval *teval,
+		   const struct teval_rbtree_node *A, const struct teval_rbtree_node *B);
+static int key_search(struct traceeval *teval, const struct teval_rbtree_node *n,
+		      const struct traceeval_data *keys);
+
 /*
  * traceeval_init_data_size - create a traceeval descriptor
  * @keys: Defines the keys to differentiate traceeval entries
@@ -426,12 +409,7 @@ struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 		goto fail_release;
 	}
 
-	/* alloc hist */
-	teval->hist = hash_alloc();
-	if (!teval->hist) {
-		err_msg = "Failed to allocate memory for histogram";
-		goto fail_release;
-	}
+	teval_rbtree_init(teval, key_cmp, key_search);
 
 	teval->sizeof_type = sizeof_type;
 	teval->sizeof_data = sizeof_data;
@@ -499,26 +477,17 @@ static void free_entry(struct traceeval *teval, struct entry *entry)
 }
 
 /*
- * Free the hist_table allocated to a traceeval instance.
+ * Free all the instances in the tree.
  */
-static void hist_table_release(struct traceeval *teval)
+static void tree_release(struct traceeval *teval)
 {
-	struct hash_table *hist = teval->hist;
-	struct hash_iter *iter;
-	struct hash_item *item;
-
-	if (!hist)
-		return;
+	struct teval_rbtree_node *node;
 
-	for (iter = hash_iter_start(hist); (item = hash_iter_next(iter)); ) {
-		struct entry *entry = container_of(item, struct entry, hash);
+	while ((node = teval_rbtree_pop_nobalance(teval))) {
+		struct entry *entry = container_of(node, struct entry, node);
 
-		hash_remove(hist, &entry->hash);
 		free_entry(teval, entry);
 	}
-
-	hash_free(hist);
-	teval->hist = NULL;
 }
 
 /*
@@ -537,7 +506,7 @@ void traceeval_release(struct traceeval *teval)
 		return;
 
 	__delta_release(teval->tdelta);
-	hist_table_release(teval);
+	tree_release(teval);
 	type_release(teval->key_types, teval->nr_key_types);
 	type_release(teval->val_types, teval->nr_val_types);
 	teval->key_types = NULL;
@@ -545,41 +514,35 @@ void traceeval_release(struct traceeval *teval)
 	free(teval);
 }
 
-static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *keys,
-			  int bits)
+static int compare_keys(struct traceeval *teval, const struct traceeval_data *A,
+			const struct traceeval_data *B)
 {
-	const struct traceeval_type *types = teval->key_types;
-	unsigned long long val;
-	unsigned key = 0;
-	int nr = teval->nr_key_types;
-
-	for (int i = 0; i < nr; i++) {
-		if (types[i].hash) {
-			key += types[i].hash(teval, &types[i], &keys[i]);
-			continue;
-		}
+	int ret;
 
-		switch (types[i].type) {
-		case TRACEEVAL_TYPE_NUMBER_8:
-		case TRACEEVAL_TYPE_NUMBER_16:
-		case TRACEEVAL_TYPE_NUMBER_32:
-		case TRACEEVAL_TYPE_NUMBER_64:
-		case TRACEEVAL_TYPE_NUMBER:
-			val = keys[i].number_64;
-			break;
-		case TRACEEVAL_TYPE_DELTA:
-			val = keys[i].delta.delta;
-			break;
-		case TRACEEVAL_TYPE_STRING:
-			val = hash_string(keys[i].cstring);
-			break;
-		default:
-			val = 0;
-		}
-		key += hash_number(val);
+	for (size_t i = 0; i < teval->nr_key_types; i++) {
+		ret = compare_traceeval_data(teval, &teval->key_types[i],
+					     &A[i], &B[i]);
+		if (ret)
+			return ret;
 	}
+	return 0;
+}
 
-	return key;
+static int key_search(struct traceeval *teval, const struct teval_rbtree_node *n,
+		      const struct traceeval_data *keys)
+{
+	const struct entry *entry = container_of(n, struct entry, node);
+
+	return compare_keys(teval, entry->keys, keys);
+}
+
+static int key_cmp(struct traceeval *teval,
+		   const struct teval_rbtree_node *A, const struct teval_rbtree_node *B)
+{
+	const struct entry *a = container_of(A, struct entry, node);
+	const struct entry *b = container_of(B, struct entry, node);
+
+	return compare_keys(teval, a->keys, b->keys);
 }
 
 /*
@@ -590,12 +553,7 @@ static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *
 __hidden int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 			      struct entry **result)
 {
-	struct hash_table *hist = teval->hist;
-	struct entry *entry = NULL;
-	struct hash_iter *iter;
-	struct hash_item *item;
-	unsigned key;
-	int check = 0;
+	struct teval_rbtree_node *node;
 	int i;
 
 	if (!teval || !keys) {
@@ -610,20 +568,13 @@ __hidden int _teval_get_entry(struct traceeval *teval, const struct traceeval_da
 		}
 	}
 
-	key = make_hash(teval, keys, hist->bits);
-
-	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
-		entry = container_of(item, struct entry, hash);
+	node = teval_rbtree_find(teval, keys);
+	if (!node)
+		return 0;
 
-		check = compare_traceeval_data_set(teval, teval->key_types,
-						   entry->keys, keys, teval->nr_key_types);
-		if (check)
-			break;
-	}
+	*result = container_of(node, struct entry, node);
 
-	if (check > 0)
-		*result = entry;
-	return check;
+	return 1;
 }
 
 __hidden void _teval_update_stat(struct traceeval_type *type,
@@ -912,22 +863,6 @@ void traceeval_results_release(struct traceeval *teval,
 	}
 }
 
-static struct entry *create_hist_entry(struct traceeval *teval,
-				       const struct traceeval_data *keys)
-{
-	struct hash_table *hist = teval->hist;
-	unsigned key = make_hash(teval, keys, hist->bits);
-	struct entry *entry;
-
-	entry = calloc(1, sizeof(*entry));
-	if (!entry)
-		return NULL;
-
-	hash_add(hist, &entry->hash, key);
-
-	return entry;
-}
-
 static unsigned long long get_timestamp(struct traceeval *teval,
 					const struct traceeval_data *vals)
 {
@@ -950,7 +885,7 @@ static int create_entry(struct traceeval *teval,
 	unsigned long long ts;
 	struct entry *entry;
 
-	entry = create_hist_entry(teval, keys);
+	entry = calloc(1, sizeof(*entry));
 	if (!entry) {
 		teval_print_err(TEVAL_CRIT, "Failed to allocate histogram");
 		return -1;
@@ -976,6 +911,8 @@ static int create_entry(struct traceeval *teval,
 	entry->vals = new_vals;
 	entry->hitcount = 1;
 
+	teval_rbtree_insert(teval, &entry->node);
+
 	teval->update_counter++;
 	teval->nr_elements++;
 
@@ -1324,7 +1261,6 @@ int traceeval_insert_size(struct traceeval *teval,
 int traceeval_remove_size(struct traceeval *teval,
 			  const struct traceeval_data *keys, size_t nr_keys)
 {
-	struct hash_table *hist = teval->hist;
 	struct entry *entry;
 	int check;
 
@@ -1340,7 +1276,7 @@ int traceeval_remove_size(struct traceeval *teval,
 	if (check < 1)
 		return check;
 
-	hash_remove(hist, &entry->hash);
+	teval_rbtree_delete(teval, &entry->node);
 	free_entry(teval, entry);
 
 	/* update_counter is used to know if there was an update. */
@@ -1384,22 +1320,22 @@ void traceeval_iterator_put(struct traceeval_iterator *iter)
 static int create_iter_array(struct traceeval_iterator *iter)
 {
 	struct traceeval *teval = iter->teval;
-	struct hash_table *hist = teval->hist;
-	struct hash_iter *hiter;
-	struct hash_item *item;
+	struct teval_rbtree_node *node = NULL;
 	int i;
 
-	iter->nr_entries = hash_nr_items(hist);
+	iter->nr_entries = teval->nr_elements;
 	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
 	if (!iter->entries) {
 		teval_print_err(TEVAL_CRIT, "Failed to allocate array");
 		return -1;
 	}
 
-	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
-		struct entry *entry = container_of(item, struct entry, hash);
+	while ((node = teval_rbtree_next(teval, node))) {
+		struct entry *entry = container_of(node, struct entry, node);
 
-		iter->entries[i] = entry;
+		if (i < iter->nr_entries)
+			iter->entries[i] = entry;
+		i++;
 	}
 
 	/* Loop must match entries */
@@ -1824,7 +1760,6 @@ struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 int traceeval_iterator_remove(struct traceeval_iterator *iter)
 {
 	struct traceeval *teval = iter->teval;
-	struct hash_table *hist = teval->hist;
 	struct entry *entry;
 
 	if (iter->next < 1 || iter->next > iter->nr_entries)
@@ -1834,7 +1769,7 @@ int traceeval_iterator_remove(struct traceeval_iterator *iter)
 	if (!entry)
 		return 0;
 
-	hash_remove(hist, &entry->hash);
+	teval_rbtree_delete(teval, &entry->node);
 	free_entry(teval, entry);
 
 	/* The entry no longer exists */
diff --git a/src/rbtree.c b/src/rbtree.c
new file mode 100644
index 000000000000..aad28723d63c
--- /dev/null
+++ b/src/rbtree.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright (C) 2023 Google, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include "eval-local.h"
+
+enum {
+	RED,
+	BLACK,
+};
+
+void __hidden teval_rbtree_init(struct traceeval *teval, teval_rbtree_cmp_fn cmp_fn,
+				teval_rbtree_search_fn search_fn)
+{
+	struct teval_rbtree *tree = &teval->tree;
+
+	memset(tree, 0, sizeof(*tree));
+	tree->search = search_fn;
+	tree->cmp = cmp_fn;
+}
+
+static bool is_left(struct teval_rbtree_node *node)
+{
+	return node == node->parent->left;
+}
+
+static struct teval_rbtree_node **get_parent_ptr(struct teval_rbtree *tree,
+						 struct teval_rbtree_node *node)
+{
+	if (!node->parent)
+		return &tree->node;
+	else if (is_left(node))
+		return &node->parent->left;
+	else
+		return &node->parent->right;
+}
+
+static void rotate_left(struct teval_rbtree *tree,
+			struct teval_rbtree_node *node)
+{
+	struct teval_rbtree_node **parent_ptr = get_parent_ptr(tree, node);
+	struct teval_rbtree_node *parent = node->parent;
+	struct teval_rbtree_node *old_right = node->right;
+
+	*parent_ptr = old_right;
+	node->right = old_right->left;
+	old_right->left = node;
+
+	if (node->right)
+		node->right->parent = node;
+	node->parent = old_right;
+	old_right->parent = parent;
+}
+
+static void rotate_right(struct teval_rbtree *tree,
+			 struct teval_rbtree_node *node)
+{
+	struct teval_rbtree_node **parent_ptr = get_parent_ptr(tree, node);
+	struct teval_rbtree_node *parent = node->parent;
+	struct teval_rbtree_node *old_left = node->left;
+
+	if (*parent_ptr != node)
+		breakpoint();
+	*parent_ptr = old_left;
+	node->left = old_left->right;
+	old_left->right = node;
+
+	if (node->left)
+		node->left->parent = node;
+	node->parent = old_left;
+	old_left->parent = parent;
+}
+
+static void insert_tree(struct traceeval *teval,
+			struct teval_rbtree_node *node)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	struct teval_rbtree_node *next = tree->node;
+	struct teval_rbtree_node *last_next = NULL;
+	bool went_left = false;
+
+	while (next) {
+		last_next = next;
+		if (tree->cmp(teval, next, node) > 0) {
+			next = next->right;
+			went_left = false;
+		} else {
+			next = next->left;
+			went_left = true;
+		}
+	}
+
+	if (!last_next) {
+		tree->node = node;
+		return;
+	}
+
+	if (went_left)
+		last_next->left = node;
+	else
+		last_next->right = node;
+
+	node->parent = last_next;
+}
+
+static int check_node(struct teval_rbtree *tree, struct teval_rbtree_node *node)
+{
+	if (!node->parent) {
+		if (tree->node != node)
+			goto fail;
+	} else {
+		if (!is_left(node)) {
+			if (node->parent->right != node)
+				goto fail;
+		}
+	}
+	return 0;
+fail:
+	printf("FAILED ON NODE!");
+	breakpoint();
+	return -1;
+}
+
+static void check_tree(struct teval_rbtree *tree)
+{
+	struct teval_rbtree_node *node = tree->node;
+
+	if (node) {
+		if (check_node(tree, node))
+			return;
+		while (node->left) {
+			node = node->left;
+			if (check_node(tree, node))
+				return;
+		}
+	}
+
+	while (node) {
+		if (check_node(tree, node))
+			return;
+		if (node->right) {
+			node = node->right;
+			if (check_node(tree, node))
+				return;
+			while (node->left) {
+				node = node->left;
+				if (check_node(tree, node))
+				    return;
+			}
+			continue;
+		}
+		while (node->parent) {
+			if (is_left(node))
+				break;
+			node = node->parent;
+			if (check_node(tree, node))
+				return;
+		}
+		node = node->parent;
+	}
+}
+
+int __hidden teval_rbtree_insert(struct traceeval *teval,
+				 struct teval_rbtree_node *node)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	struct teval_rbtree_node *uncle;
+
+	memset(node, 0, sizeof(*node));
+
+	insert_tree(teval, node);
+	node->color = RED;
+	while (node && node->parent && node->parent->color == RED) {
+		if (is_left(node->parent)) {
+			uncle = node->parent->parent->right;
+			if (uncle && uncle->color == RED) {
+				node->parent->color = BLACK;
+				uncle->color = BLACK;
+				node->parent->parent->color = RED;
+				node = node->parent->parent;
+			} else {
+				struct teval_rbtree_node old_pp = *node->parent->parent;
+				struct teval_rbtree_node old_p = *node->parent;
+				struct teval_rbtree_node old_node = *node;
+				if (!is_left(node)) {
+					node = node->parent;
+					rotate_left(tree, node);
+					check_tree(tree);
+				}
+				node->parent->color = BLACK;
+				node->parent->parent->color = RED;
+				rotate_right(tree, node->parent->parent);
+				if (old_node.parent == node->parent ||
+				    old_p.parent == node ||
+				    old_pp.parent == node)
+					check_tree(tree);
+			}
+		} else {
+			uncle = node->parent->parent->left;
+			if (uncle && uncle->color == RED) {
+				node->parent->color = BLACK;
+				uncle->color = BLACK;
+				node->parent->parent->color = RED;
+				node = node->parent->parent;
+			} else {
+				if (is_left(node)) {
+					node = node->parent;
+					rotate_right(tree, node);
+					check_tree(tree);
+				}
+				node->parent->color = BLACK;
+				node->parent->parent->color = RED;
+				rotate_left(tree, node->parent->parent);
+				check_tree(tree);
+			}
+		}
+	}
+	check_tree(tree);
+	tree->node->color = BLACK;
+	tree->nr_nodes++;
+	return 0;
+}
+
+__hidden struct teval_rbtree_node *
+teval_rbtree_find(struct traceeval *teval, const struct traceeval_data *keys)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	struct teval_rbtree_node *node = tree->node;
+	int ret;
+
+	while (node) {
+		ret = tree->search(teval, node, keys);
+		if (!ret)
+			return node;
+		if (ret > 0)
+			node = node->right;
+		else
+			node = node->left;
+	}
+	return NULL;
+}
+
+static struct teval_rbtree_node *next_node(struct teval_rbtree_node *node)
+{
+	if (node->right) {
+		node = node->right;
+		while (node->left)
+			node = node->left;
+		return node;
+	}
+
+	while (node->parent && !is_left(node))
+		node = node->parent;
+
+	return node->parent;
+}
+
+static void tree_fixup(struct teval_rbtree *tree, struct teval_rbtree_node *node)
+{
+	while (node->parent && node->color == BLACK) {
+		if (is_left(node)) {
+			struct teval_rbtree_node *old_right = node->parent->right;
+
+			if (old_right->color == RED) {
+				old_right->color = BLACK;
+				node->parent->color = RED;
+				rotate_left(tree, node->parent);
+				old_right = node->parent->right;
+			}
+			if (old_right->left->color == BLACK &&
+			    old_right->right->color == BLACK) {
+				old_right->color = RED;
+				node = node->parent;
+			} else {
+				if (old_right->right->color == BLACK) {
+					old_right->left->color = BLACK;
+					old_right->color = RED;
+					rotate_right(tree, old_right);
+					old_right = node->parent->right;
+				}
+				old_right->color = node->parent->color;
+				node->parent->color = BLACK;
+				old_right->right->color = BLACK;
+				rotate_left(tree, node->parent);
+				node = tree->node;
+			}
+		} else {
+			struct teval_rbtree_node *old_left = node->parent->left;
+
+			if (old_left->color == RED) {
+				old_left->color = BLACK;
+				node->parent->color = RED;
+				rotate_right(tree, node->parent);
+				old_left = node->parent->left;
+			}
+			if (old_left->right->color == BLACK &&
+			    old_left->left->color == BLACK) {
+				old_left->color = RED;
+				node = node->parent;
+			} else {
+				if (old_left->left->color == BLACK) {
+					old_left->right->color = BLACK;
+					old_left->color = RED;
+					rotate_left(tree, old_left);
+					old_left = node->parent->left;
+				}
+				old_left->color = node->parent->color;
+				node->parent->color = BLACK;
+				old_left->left->color = BLACK;
+				rotate_right(tree, node->parent);
+				node = tree->node;
+			}
+		}
+	}
+	node->color = BLACK;
+}
+
+__hidden void teval_rbtree_delete(struct traceeval *teval,
+				  struct teval_rbtree_node *node)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	struct teval_rbtree_node *x, *y;
+	bool do_fixup = false;
+
+	if (!node->left && !node->right) {
+		tree->node = NULL;
+		goto out;
+	}
+
+	if (!node->left || !node->right)
+		y = node;
+	else
+		y = next_node(node);
+
+	if (y->left)
+		x = y->left;
+	else
+		x = y->right;
+
+	x->parent = y->parent;
+
+	if (!x->parent) {
+		tree->node = x;
+	} else {
+		if (is_left(y))
+			y->parent->left = x;
+		else
+			y->parent->right = x;
+	}
+
+	do_fixup = y->color == BLACK;
+
+	if (y != node) {
+		y->color = node->color;
+		y->parent = node->parent;
+		y->left = node->left;
+		y->right = node->right;
+		if (y->left)
+			y->left->parent = y;
+		if (y->right)
+			y->right->parent = y;
+		if (!y->parent) {
+			tree->node = y;
+		} else {
+			if (is_left(node))
+				y->parent->left = y;
+			else
+				y->parent->right = y;
+		}
+	}
+
+	if (do_fixup)
+		tree_fixup(tree, x);
+
+ out:
+	node->parent = node->left = node->right = NULL;
+	tree->nr_nodes--;
+}
+
+__hidden struct teval_rbtree_node *teval_rbtree_next(struct traceeval *teval,
+						     struct teval_rbtree_node *node)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	check_tree(tree);
+	/*
+	 * When either starting or the previous iteration returned a
+	 * node with a right branch, then go to the first node (if starting)
+	 * or the right node, and then return the left most node.
+	 */
+	if (!node || node->right) {
+		if (!node)
+			node = tree->node;
+		else
+			node = node->right;
+		while (node->left)
+			node = node->left;
+		return node;
+	}
+
+	/*
+	 * If we are here, then the previous iteration returned the
+	 * left most node of the tree or the right branch. If this
+	 * is a left node, then simply return the parent. If this
+	 * is a right node, then keep going up until its a left node,
+	 * or we finished the iteration.
+	 *
+	 * If we are here and are the top node, then there is no right
+	 * node, and this is finished (return NULL).
+	 */
+	if (!node->parent || is_left(node))
+		return node->parent;
+
+	do {
+		node = node->parent;
+	} while (node->parent && !is_left(node));
+
+	return node->parent;
+}
+
+/*
+ * Used for freeing a tree, just quickly pop off the children in
+ * no particular order. This will corrupt the tree! That is,
+ * do not do any inserting or deleting of this tree after calling
+ * this function.
+ */
+__hidden struct teval_rbtree_node *
+teval_rbtree_pop_nobalance(struct traceeval *teval)
+{
+	struct teval_rbtree *tree = &teval->tree;
+	struct teval_rbtree_node *node = tree->node;
+
+	if (!node)
+		return NULL;
+
+	while (node->left)
+		node = node->left;
+
+	while (node->right)
+		node = node->right;
+
+	if (node->parent) {
+		if (is_left(node))
+			node->parent->left = NULL;
+		else
+			node->parent->right = NULL;
+	} else {
+		tree->node = NULL;
+	}
+
+	return node;
+}
-- 
2.42.0

