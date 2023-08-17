Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F46C2FC1C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347550AbjHQBdO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347553AbjHQBdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E481FC8
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EA8C648CA
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081CDC433CB;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N3w-1t;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 07/18] libtraceeval: Convert hist array into a hash table
Date:   Wed, 16 Aug 2023 21:32:59 -0400
Message-Id: <20230817013310.88582-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The lookups need to be extremely fast. Instead of doing a linear search
across all entries (which could be thousands), do a hash lookup instead.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |   7 ++
 src/histograms.c         | 166 +++++++++++++++++++++++++++++++++------
 2 files changed, 147 insertions(+), 26 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index d7ffe42f3231..1edda56a712f 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -74,6 +74,12 @@ typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
 				     const struct traceeval_type *type,
 				     const union traceeval_data *A,
 				     const union traceeval_data *B);
+
+/* make a unique value */
+typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
+				      const struct traceeval_type *type,
+				      const union traceeval_data *data);
+
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
  * @type: The enum type that describes the traceeval_data
@@ -117,6 +123,7 @@ struct traceeval_type {
 	size_t				id;
 	traceeval_data_release_fn	release;
 	traceeval_data_cmp_fn		cmp;
+	traceeval_data_hash_fn		hash;
 };
 
 /* Statistics about a given entry element */
diff --git a/src/histograms.c b/src/histograms.c
index ccb52d0f1d42..08f6ddf55ae1 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -3,6 +3,7 @@
  * libtraceeval histogram interface implementation.
  *
  * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
  */
 
 #include <stdbool.h>
@@ -12,6 +13,14 @@
 
 #include <traceeval-hist.h>
 
+#define offset_of(type, field) ((size_t)(&(((type *)(NULL))->field)))
+#define container_of(ptr, type, field) \
+	(type *)((void *)(ptr) - (void *)offset_of(type, field))
+
+#define HASH_BITS 10	/* Start with 1K of buckets */
+#define HASH_SIZE(bits)	(1 << (bits))
+#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
+
 /*
  * Compare two integers of variable length.
  *
@@ -25,23 +34,31 @@ do {					\
 	return (a) != (b);		\
 } while (0)				\
 
+
+struct hash_item {
+	struct hash_item	*next;
+	unsigned		key;
+};
+
+/* A hash of key-value entries */
+struct hash_table {
+	struct hash_item	**hash;
+	unsigned		bits;
+	size_t			nr_items;
+};
+
 /* A key-value pair */
 struct entry {
+	struct hash_item	hash;
 	union traceeval_data	*keys;
 	union traceeval_data	*vals;
 };
 
-/* A table of key-value entries */
-struct hist_table {
-	struct entry	*map;
-	size_t		nr_entries;
-};
-
 /* Histogram */
 struct traceeval {
 	struct traceeval_type		*key_types;
 	struct traceeval_type		*val_types;
-	struct hist_table		*hist;
+	struct hash_table		*hist;
 	size_t				nr_key_types;
 	size_t				nr_val_types;
 };
@@ -299,6 +316,11 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
 		err_msg = "Failed to allocate memory for histogram";
 		goto fail_release;
 	}
+	teval->hist->bits = HASH_BITS;
+	teval->hist->hash = calloc(HASH_SIZE(teval->hist->bits),
+				   sizeof(*teval->hist->hash));
+	if (!teval->hist->hash)
+		goto fail_release;
 
 	return teval;
 
@@ -350,7 +372,7 @@ static void clean_data_set(union traceeval_data *data, struct traceeval_type *de
 /*
  * Free all possible data stored within the entry.
  */
-static void clean_entry(struct entry *entry, struct traceeval *teval)
+static void free_entry(struct traceeval *teval, struct entry *entry)
 {
 	if (!entry)
 		return;
@@ -358,6 +380,19 @@ static void clean_entry(struct entry *entry, struct traceeval *teval)
 	/* free dynamic traceeval_data */
 	clean_data_set(entry->keys, teval->key_types, teval->nr_key_types);
 	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
+
+	free(entry);
+}
+
+static void free_entries(struct traceeval *teval, struct hash_item *item)
+{
+	struct entry *entry;
+
+	while (item) {
+		entry = container_of(item, struct entry, hash);
+		item = item->next;
+		free_entry(teval, entry);
+	}
 }
 
 /*
@@ -365,16 +400,19 @@ static void clean_entry(struct entry *entry, struct traceeval *teval)
  */
 static void hist_table_release(struct traceeval *teval)
 {
-	struct hist_table *hist = teval->hist;
+	struct hash_table *hist = teval->hist;
 
 	if (!hist)
 		return;
 
-	for (size_t i = 0; i < hist->nr_entries; i++) {
-		clean_entry(hist->map + i, teval);
+	for (size_t i = 0; i < HASH_SIZE(hist->bits); i++) {
+		if (!hist->hash[i])
+			continue;
+
+		free_entries(teval, hist->hash[i]);
 	}
 
-	free(hist->map);
+	free(hist->hash);
 	free(hist);
 	teval->hist = NULL;
 }
@@ -403,6 +441,58 @@ void traceeval_release(struct traceeval *teval)
 	free(teval);
 }
 
+static unsigned long long hash_string(const char *str)
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
+static unsigned make_hash(struct traceeval *teval, const union traceeval_data *keys,
+			  int bits)
+{
+	const struct traceeval_type *types = teval->key_types;
+	unsigned long long val;
+	unsigned key = 0;
+	int nr = teval->nr_key_types;
+
+	for (int i = 0; i < nr; i++) {
+		if (types[i].hash) {
+			key += types[i].hash(teval, &types[i], &keys[i]);
+			continue;
+		}
+
+		switch (types[i].type) {
+		case TRACEEVAL_TYPE_NUMBER_8:
+		case TRACEEVAL_TYPE_NUMBER_16:
+		case TRACEEVAL_TYPE_NUMBER_32:
+		case TRACEEVAL_TYPE_NUMBER_64:
+		case TRACEEVAL_TYPE_NUMBER:
+			val = keys[i].number_64;
+			break;
+		case TRACEEVAL_TYPE_STRING:
+			val = hash_string(keys[i].cstring);
+			break;
+		default:
+			val = 0;
+		}
+ /*
+ * This is a quick hashing function adapted from Donald E. Knuth's 32
+ * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
+ * Multiplication by the Prime number, closest to the golden ratio of
+ * 2^32.
+ */
+		key += val * 2654435761;
+	}
+
+	return key & HASH_MASK(bits);
+}
+
 /*
  * Find the entry that @keys corresponds to within @teval.
  *
@@ -411,21 +501,24 @@ void traceeval_release(struct traceeval *teval)
 static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 		     struct entry **result)
 {
-	struct hist_table *hist;
+	struct hash_table *hist = teval->hist;
 	struct entry *entry;
+	unsigned key;
 	int check = 0;
-	int i;
 
 	if (!teval || !keys)
 		return -1;
 
+	key = make_hash(teval, keys, hist->bits);
+
 	hist = teval->hist;
-	for (i = 0, entry = hist->map; i < hist->nr_entries; entry = &hist->map[++i]) {
+
+	for (struct hash_item *item = hist->hash[key]; item; item = item->next) {
+		entry = container_of(item, struct entry, hash);
 		check = compare_traceeval_data_set(teval, teval->key_types,
 						   entry->keys, keys, teval->nr_key_types);
-		if (!check)
-			continue;
-		break;
+		if (check)
+			break;
 	}
 
 	if (check > 0)
@@ -536,6 +629,7 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 	/* find key and copy its corresponding value pair */
 	if ((check = get_entry(teval, keys, &entry)) < 1)
 		return check;
+
 	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
 			entry->vals, results);
 }
@@ -563,6 +657,28 @@ void traceeval_results_release(struct traceeval *teval,
 	data_release(teval->nr_val_types, &results, teval->val_types);
 }
 
+static struct entry *create_hist_entry(struct traceeval *teval,
+				       const union traceeval_data *keys)
+{
+	struct hash_table *hist = teval->hist;
+	struct hash_item *item;
+	unsigned key = make_hash(teval, keys, hist->bits);
+	struct entry *entry;
+
+	entry = calloc(1, sizeof(*entry));
+	if (!entry)
+		return NULL;
+
+	item = &entry->hash;
+	item->next = hist->hash[key];
+	hist->hash[key] = item;
+	item->key = key;
+
+	hist->nr_items++;
+
+	return entry;
+}
+
 /*
  * Create a new entry in @teval with respect to @keys and @vals.
  *
@@ -574,8 +690,7 @@ static int create_entry(struct traceeval *teval,
 {
 	union traceeval_data *new_keys;
 	union traceeval_data *new_vals;
-	struct entry *tmp_map;
-	struct hist_table *hist = teval->hist;
+	struct entry *entry;
 
 	/* copy keys */
 	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
@@ -587,13 +702,12 @@ static int create_entry(struct traceeval *teval,
 				vals, &new_vals) == -1)
 		goto fail_vals;
 
-	/* create new entry */
-	tmp_map = realloc(hist->map, ++hist->nr_entries * sizeof(*tmp_map));
-	if (!tmp_map)
+	entry = create_hist_entry(teval, keys);
+	if (!entry)
 		goto fail;
-	tmp_map->keys = new_keys;
-	tmp_map->vals = new_vals;
-	hist->map = tmp_map;
+
+	entry->keys = new_keys;
+	entry->vals = new_vals;
 
 	return 0;
 
-- 
2.40.1

