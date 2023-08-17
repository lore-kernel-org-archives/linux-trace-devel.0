Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA196C678DC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355029AbjHQUqA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355003AbjHQUp3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A79435A7
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39FD658E9
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C73C43397;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000Tpd-1A;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 10/20] libtraceeval histograms: Move hash functions into their own file
Date:   Thu, 17 Aug 2023 16:45:18 -0400
Message-Id: <20230817204528.114577-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
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
 src/eval-local.h | 103 +++++++++++++++++++++++++++++++++++++++
 src/hash.c       | 123 +++++++++++++++++++++++++++++++++++++++++++++++
 src/histograms.c | 121 +++++++---------------------------------------
 4 files changed, 244 insertions(+), 104 deletions(-)
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
index 000000000000..007fdb146b96
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
+#define offset_of(type, field) ((size_t)(&(((type *)(NULL))->field)))
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
index 000000000000..82962fbba8d8
--- /dev/null
+++ b/src/hash.c
@@ -0,0 +1,123 @@
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
+		break;
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
+	if (iter->current_bucket >= HASH_SIZE(hash->bits))
+		return NULL;
+
+	item = iter->next_item;
+	if (!item)
+		return NULL;
+
+	iter->next_item = item->next;
+	if (!iter->next_item) {
+		size_t i;
+
+		for (i = iter->current_bucket + 1; i < HASH_SIZE(hash->bits); i++) {
+			if (!hash->hash[i])
+				continue;
+			iter->next_item = hash->hash[i];
+			break;
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
index 54d156791193..b1c6bb4fc990 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -12,56 +12,7 @@
 #include <stdio.h>
 
 #include <traceeval-hist.h>
-
-#define offset_of(type, field) ((size_t)(&(((type *)(NULL))->field)))
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
-/* A hash of key-value entries */
-struct hash_table {
-	struct hash_item	**hash;
-	unsigned		bits;
-	size_t			nr_items;
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
@@ -311,16 +262,11 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
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
 
@@ -384,36 +330,26 @@ static void free_entry(struct traceeval *teval, struct entry *entry)
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
 
@@ -441,18 +377,6 @@ void traceeval_release(struct traceeval *teval)
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
@@ -481,16 +405,10 @@ static unsigned make_hash(struct traceeval *teval, const union traceeval_data *k
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
 
-	return key & HASH_MASK(bits);
+	return key;
 }
 
 /*
@@ -502,7 +420,9 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 		     struct entry **result)
 {
 	struct hash_table *hist = teval->hist;
-	struct entry *entry;
+	struct entry *entry = NULL;
+	struct hash_iter *iter;
+	struct hash_item *item;
 	unsigned key;
 	int check = 0;
 
@@ -511,10 +431,9 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 
 	key = make_hash(teval, keys, hist->bits);
 
-	hist = teval->hist;
-
-	for (struct hash_item *item = hist->hash[key]; item; item = item->next) {
+	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
 		entry = container_of(item, struct entry, hash);
+
 		check = compare_traceeval_data_set(teval, teval->key_types,
 						   entry->keys, keys, teval->nr_key_types);
 		if (check)
@@ -661,7 +580,6 @@ static struct entry *create_hist_entry(struct traceeval *teval,
 				       const union traceeval_data *keys)
 {
 	struct hash_table *hist = teval->hist;
-	struct hash_item *item;
 	unsigned key = make_hash(teval, keys, hist->bits);
 	struct entry *entry;
 
@@ -669,12 +587,7 @@ static struct entry *create_hist_entry(struct traceeval *teval,
 	if (!entry)
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

