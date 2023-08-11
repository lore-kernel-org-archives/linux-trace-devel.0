Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6DEC04E69
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjHKFjx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHKFjs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3F310C7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0098F64ACD
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB856C43391;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uQ3-2r;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 08/17] libtraceeval histograms: Move hash functions into their own file
Date:   Fri, 11 Aug 2023 01:39:31 -0400
Message-Id: <20230811053940.1408424-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Move the hash functions into their own file so that it does not clutter
the histogram.c file. Functionality should be the same, but some code
restructuring was done.

To keep the hash abstract, helper functions were introduced:

  hash_iter_start() - to start iterating over all items in the hash
  hash_iter_next() - to get the next item in the hash

  hash_iter_bucket() - to start iterating over a single bucket in the hash
  hash_iter_bucket_next() - to get the next item in the bucket

  hash_nr_items() - to get the number of items in the hash

Also implemented hash_remove() to remove an item from the hash.

Also created a eval-local.h header file to store the prototypes of the
local functions as well as moved the structures there too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/Makefile     |   1 +
 src/eval-local.h | 103 ++++++++++++++++++++++++++++++++++++++
 src/hash.c       | 119 ++++++++++++++++++++++++++++++++++++++++++++
 src/histograms.c | 126 +++++++----------------------------------------
 4 files changed, 240 insertions(+), 109 deletions(-)
 create mode 100644 src/eval-local.h
 create mode 100644 src/hash.c

diff --git a/src/Makefile b/src/Makefile
index b32a3891333d..4b7b3051a8b2 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -5,6 +5,7 @@ include $(src)/scripts/utils.mk
 OBJS =
 OBJS += trace-analysis.o
 OBJS += histograms.o
+OBJS += hash.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
diff --git a/src/eval-local.h b/src/eval-local.h
new file mode 100644
index 000000000000..820d7ad096e8
--- /dev/null
+++ b/src/eval-local.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef __EVAL_LOCAL_H
+#define __EVAL_LOCAL_H
+
+#include <string.h>
+
+#define __hidden __attribute__((visibility ("hidden")))
+
+#define offset_of(type, field) (&(((type *)(NULL))->field))
+#define container_of(ptr, type, field) \
+	(type *)((void *)(ptr) - (void *)offset_of(type, field))
+
+#define HASH_BITS 10	/* Start with 1K of buckets */
+#define HASH_SIZE(bits)	(1 << (bits))
+#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
+
+/*
+ * Compare two integers of variable length.
+ *
+ * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
+ * if @b is greater than @a.
+ */
+#define compare_numbers_return(a, b)	\
+do {					\
+	if ((a) < (b))			\
+		return -1;		\
+	return (a) != (b);		\
+} while (0)				\
+
+struct hash_item {
+	struct hash_item	*next;
+	unsigned		key;
+};
+
+struct hash_iter {
+	struct hash_item	*next_item;
+	size_t			current_bucket;
+};
+
+/* A table of key-value entries */
+struct hash_table {
+	struct hash_item	**hash;
+	unsigned		bits;
+	size_t			nr_items;
+	struct hash_iter	iter;
+};
+
+/* A key-value pair */
+struct entry {
+	struct hash_item	hash;
+	union traceeval_data	*keys;
+	union traceeval_data	*vals;
+};
+
+/* Histogram */
+struct traceeval {
+	struct traceeval_type		*key_types;
+	struct traceeval_type		*val_types;
+	struct hash_table		*hist;
+	size_t				nr_key_types;
+	size_t				nr_val_types;
+};
+
+extern struct hash_table *hash_alloc(void);
+extern void hash_free(struct hash_table *hash);
+extern void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key);
+extern int hash_remove(struct hash_table *hash, struct hash_item *item);
+
+extern struct hash_iter *hash_iter_start(struct hash_table *hash);
+extern struct hash_item *hash_iter_next(struct hash_iter *iter);
+
+extern struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key);
+extern struct hash_item *hash_iter_bucket_next(struct hash_iter *iter);
+
+static inline size_t hash_nr_items(struct hash_table *hash)
+{
+	return hash->nr_items;
+}
+
+static inline unsigned long long hash_string(const char *str)
+{
+	unsigned long long key = 0;
+	int len = strlen(str);
+	int i;
+
+	for (i = 0; i < len; i++)
+		key += (unsigned long long)str[i] << ((i & 7) * 8);
+
+	return key;
+}
+
+ /*
+ * This is a quick hashing function adapted from Donald E. Knuth's 32
+ * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
+ * Multiplication by the Prime number, closest to the golden ratio of
+ * 2^32.
+ */
+static inline unsigned long long hash_number(unsigned long long val)
+{
+		return val * 2654435761ULL;
+}
+
+#endif
diff --git a/src/hash.c b/src/hash.c
new file mode 100644
index 000000000000..e4f2a983d39c
--- /dev/null
+++ b/src/hash.c
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval hashtable interface implementation.
+ *
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+
+#include <traceeval-hist.h>
+
+#include "eval-local.h"
+
+__hidden struct hash_table *hash_alloc(void)
+{
+	struct hash_table *hash;
+
+	hash = calloc(1, sizeof(*hash));
+	if (!hash)
+		return NULL;
+
+	hash->bits = HASH_BITS;
+	hash->hash = calloc(HASH_SIZE(hash->bits), sizeof(*hash->hash));
+	if (!hash->hash) {
+		free(hash);
+		hash = NULL;
+	}
+
+	return hash;
+}
+
+__hidden void hash_free(struct hash_table *hash)
+{
+	free(hash->hash);
+	free(hash);
+}
+
+__hidden void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key)
+{
+	key &= HASH_MASK(hash->bits);
+
+	item->next = hash->hash[key];
+	hash->hash[key] = item;
+	item->key = key;
+
+	hash->nr_items++;
+}
+
+__hidden int hash_remove(struct hash_table *hash, struct hash_item *item)
+{
+	struct hash_item **parent;
+
+	for (parent = &hash->hash[item->key]; *parent; parent = &(*parent)->next) {
+		if (*parent == item) {
+			*parent = item->next;
+			hash->nr_items--;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+__hidden struct hash_iter *hash_iter_start(struct hash_table *hash)
+{
+	struct hash_iter *iter = &hash->iter;
+	size_t i;
+
+	for (i = 0; i < HASH_SIZE(hash->bits); i++) {
+		if (!hash->hash[i])
+			continue;
+		iter->next_item = hash->hash[i];
+	}
+	iter->current_bucket = i;
+	return iter;
+}
+
+__hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
+{
+	struct hash_table *hash = container_of(iter, struct hash_table, iter);
+	struct hash_item *item;
+
+	if (iter->current_bucket > HASH_SIZE(hash->bits))
+		return NULL;
+
+	item = iter->next_item;
+
+	iter->next_item = item->next;
+	if (!iter->next_item) {
+		size_t i;
+
+		for (i = iter->current_bucket + 1; i < HASH_SIZE(hash->bits); i++) {
+			if (!hash->hash[i])
+				continue;
+			iter->next_item = hash->hash[i];
+		}
+		iter->current_bucket = i;
+	}
+	return item;
+}
+
+__hidden struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key)
+{
+	struct hash_iter *iter = &hash->iter;
+
+	key &= HASH_MASK(hash->bits);
+
+	iter->current_bucket = key;
+	iter->next_item = hash->hash[key];
+
+	return iter;
+}
+
+__hidden struct hash_item *hash_iter_bucket_next(struct hash_iter *iter)
+{
+	struct hash_item *item = iter->next_item;
+
+	if (item)
+		iter->next_item = item->next;
+
+	return item;
+}
diff --git a/src/histograms.c b/src/histograms.c
index e6995192881e..574bb115ffc0 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -13,61 +13,7 @@
 
 #include <traceeval-hist.h>
 
-#define offset_of(type, field) (&(((type *)(NULL))->field))
-#define container_of(ptr, type, field) \
-	(type *)((void *)(ptr) - (void *)offset_of(type, field))
-
-#define HASH_BITS 10	/* Start with 1K of buckets */
-#define HASH_SIZE(bits)	(1 << (bits))
-#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
-
-/*
- * Compare two integers of variable length.
- *
- * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
- * if @b is greater than @a.
- */
-#define compare_numbers_return(a, b)	\
-do {					\
-	if ((a) < (b))			\
-		return -1;		\
-	return (a) != (b);		\
-} while (0)				\
-
-
-struct hash_item {
-	struct hash_item	*next;
-	unsigned		key;
-};
-
-struct hash_iter {
-	struct hash_item	*next_item;
-	size_t			current_bucket;
-};
-
-/* A hash of key-value entries */
-struct hash_table {
-	struct hash_item	**hash;
-	unsigned		bits;
-	size_t			nr_items;
-	struct hash_iter	iter;
-};
-
-/* A key-value pair */
-struct entry {
-	struct hash_item	hash;
-	union traceeval_data	*keys;
-	union traceeval_data	*vals;
-};
-
-/* Histogram */
-struct traceeval {
-	struct traceeval_type		*key_types;
-	struct traceeval_type		*val_types;
-	struct hash_table		*hist;
-	size_t				nr_key_types;
-	size_t				nr_val_types;
-};
+#include "eval-local.h"
 
 /*
  * print_err - print an error message
@@ -317,16 +263,11 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
 	}
 
 	/* alloc hist */
-	teval->hist = calloc(1, sizeof(*teval->hist));
+	teval->hist = hash_alloc();
 	if (!teval->hist) {
 		err_msg = "Failed to allocate memory for histogram";
 		goto fail_release;
 	}
-	teval->hist->bits = HASH_BITS;
-	teval->hist->hash = calloc(HASH_SIZE(teval->hist->bits),
-				   sizeof(*teval->hist->hash));
-	if (!teval->hist->hash)
-		goto fail_release;
 
 	return teval;
 
@@ -390,36 +331,26 @@ static void free_entry(struct traceeval *teval, struct entry *entry)
 	free(entry);
 }
 
-static void free_entries(struct traceeval *teval, struct hash_item *item)
-{
-	struct entry *entry;
-
-	while (item) {
-		entry = container_of(item, struct entry, hash);
-		item = item->next;
-		free_entry(teval, entry);
-	}
-}
-
 /*
  * Free the hist_table allocated to a traceeval instance.
  */
 static void hist_table_release(struct traceeval *teval)
 {
 	struct hash_table *hist = teval->hist;
+	struct hash_iter *iter;
+	struct hash_item *item;
 
 	if (!hist)
 		return;
 
-	for (size_t i = 0; i < HASH_SIZE(hist->bits); i++) {
-		if (!hist->hash[i])
-			continue;
+	for (iter = hash_iter_start(hist); (item = hash_iter_next(iter)); ) {
+		struct entry *entry = container_of(item, struct entry, hash);
 
-		free_entries(teval, hist->hash[i]);
+		hash_remove(hist, &entry->hash);
+		free_entry(teval, entry);
 	}
 
-	free(hist->hash);
-	free(hist);
+	hash_free(hist);
 	teval->hist = NULL;
 }
 
@@ -447,18 +378,6 @@ void traceeval_release(struct traceeval *teval)
 	free(teval);
 }
 
-static unsigned long long hash_string(const char *str)
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
 static unsigned make_hash(struct traceeval *teval, const union traceeval_data *keys,
 			  int bits)
 {
@@ -487,13 +406,7 @@ static unsigned make_hash(struct traceeval *teval, const union traceeval_data *k
 		default:
 			val = 0;
 		}
- /*
- * This is a quick hashing function adapted from Donald E. Knuth's 32
- * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
- * Multiplication by the Prime number, closest to the golden ratio of
- * 2^32.
- */
-		key += val * 2654435761;
+		key += hash_number(val);
 	}
 
 	return key & HASH_MASK(bits);
@@ -508,7 +421,9 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 		     struct entry **result)
 {
 	struct hash_table *hist = teval->hist;
-	struct entry *entry;
+	struct entry *entry = NULL;
+	struct hash_iter *iter;
+	struct hash_item *item;
 	unsigned key;
 	int check = 0;
 
@@ -517,10 +432,9 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 
 	key = make_hash(teval, keys, hist->bits);
 
-	hist = teval->hist;
-
-	for (struct hash_item *item = hist->hash[key]; item; item = item->next) {
+	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
 		entry = container_of(item, struct entry, hash);
+
 		check = compare_traceeval_data_set(teval, entry->keys, keys,
 						   teval->key_types, teval->nr_key_types);
 		if (check)
@@ -667,20 +581,14 @@ static struct entry *create_hist_entry(struct traceeval *teval,
 				       const union traceeval_data *keys)
 {
 	struct hash_table *hist = teval->hist;
-	struct hash_item *item;
 	unsigned key = make_hash(teval, keys, hist->bits);
 	struct entry *entry;
 
 	entry = calloc(1, sizeof(*entry));
-	if (entry)
+	if (!entry)
 		return NULL;
 
-	item = &entry->hash;
-	item->next = hist->hash[key];
-	hist->hash[key] = item;
-	item->key = key;
-
-	hist->nr_items++;
+	hash_add(hist, &entry->hash, key);
 
 	return entry;
 }
-- 
2.40.1

