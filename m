Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158C1C05052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347571AbjHQBfV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347565AbjHQBfR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C32727
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2D82612B2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028DAC433C7;
        Thu, 17 Aug 2023 01:35:13 +0000 (UTC)
Date:   Wed, 16 Aug 2023 21:35:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 00/18] libtraceeval histogram: Updates
Message-ID: <20230816213518.58eafe61@gandalf.local.home>
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Aug 2023 21:32:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Changes since v2: https://lore.kernel.org/all/20230811053940.1408424-1-rostedt@goodmis.org/

The diff between this version and the last version:

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 315b66adb7ee..8e5a6451f399 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -67,11 +67,11 @@ union traceeval_data {
 struct traceeval_type;
 struct traceeval;
 
-/* struct traceeval_dynamic release function signature */
+/* release function callback on traceeval_data */
 typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
 					  union traceeval_data *data);
 
-/* struct traceeval_dynamic compare function signature */
+/* compare function callback to compare traceeval_data */
 typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
 				     const struct traceeval_type *type,
 				     const union traceeval_data *A,
@@ -160,6 +160,9 @@ int traceeval_insert(struct traceeval *teval,
 		     const union traceeval_data *keys,
 		     const union traceeval_data *vals);
 
+int traceeval_remove(struct traceeval *teval,
+		     const union traceeval_data *keys);
+
 int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 		    const union traceeval_data **results);
 
diff --git a/samples/task-eval.c b/samples/task-eval.c
index e0ef2d0bcb30..66d0c40dc0c8 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -215,7 +215,9 @@ static void update_process(struct task_data *tdata, const char *comm,
 		return;
 	case STOP:
 		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
-		if (ret <= 0)
+		if (ret < 0)
+			pdie("Could not query start process");
+		if (ret == 0)
 			return;
 		if (!results[0].number_64)
 			break;
@@ -264,7 +266,9 @@ get_process_data(struct task_data *tdata, const char *comm)
 	int ret;
 
 	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
-	if (ret <= 0)
+	if (ret < 0)
+		pdie("Could not query process data");
+	if (ret == 0)
 		return NULL;
 
 	data = results[0].pointer;
@@ -289,6 +293,8 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
 	if (ret > 0)
 		goto out; /* It already exists ? */
+	if (ret < 0)
+		pdie("Could not query process data");
 
 	new_vals[0].pointer = data;
 	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
@@ -328,13 +334,17 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
 			if (results[0].number_64)
 				break;
 		}
+		if (ret < 0)
+			pdie("Could not query cpu start data");
 		ret = traceeval_insert(teval_pair->start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start CPU");
 		break;
 	case STOP:
 		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret <= 0)
+		if (ret < 0)
+			pdie("Could not query cpu stop data");
+		if (ret == 0)
 			return;
 
 		if (!results[0].number_64)
@@ -400,7 +410,9 @@ static void update_thread(struct process_data *pdata, int tid,
 		return;
 	case STOP:
 		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
-		if (ret <= 0)
+		if (ret < 0)
+			pdie("Could not query thread start");
+		if (ret == 0)
 			return;
 
 		new_vals[0].number_64 = ts - results[0].number_64;
@@ -825,6 +837,8 @@ static void display_processes(struct traceeval *teval,
 		const char *comm = keys[0].cstring;
 
 		ret = traceeval_query(teval_data, keys, &results);
+		if (ret < 0)
+			pdie("Could not query iterator");
 		if (ret < 1)
 			continue; /* ?? */
 
diff --git a/src/eval-local.h b/src/eval-local.h
index c3ea920ed2e8..5c3918f17cc1 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -6,7 +6,7 @@
 
 #define __hidden __attribute__((visibility ("hidden")))
 
-#define offset_of(type, field) (&(((type *)(NULL))->field))
+#define offset_of(type, field) ((size_t)(&(((type *)(NULL))->field)))
 #define container_of(ptr, type, field) \
 	(type *)((void *)(ptr) - (void *)offset_of(type, field))
 
diff --git a/src/hash.c b/src/hash.c
index 221145efcbb9..82962fbba8d8 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -78,7 +78,7 @@ __hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
 	struct hash_table *hash = container_of(iter, struct hash_table, iter);
 	struct hash_item *item;
 
-	if (iter->current_bucket > HASH_SIZE(hash->bits))
+	if (iter->current_bucket >= HASH_SIZE(hash->bits))
 		return NULL;
 
 	item = iter->next_item;
diff --git a/src/histograms.c b/src/histograms.c
index cd68d4c834af..f35d1b2e583d 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -12,7 +12,6 @@
 #include <stdio.h>
 
 #include <traceeval-hist.h>
-
 #include "eval-local.h"
 
 /*
@@ -37,9 +36,9 @@ static void print_err(const char *fmt, ...)
  * -1 for the other way around, and -2 on error.
  */
 static int compare_traceeval_data(struct traceeval *teval,
+				  struct traceeval_type *type,
 				  const union traceeval_data *orig,
-				  const union traceeval_data *copy,
-				  struct traceeval_type *type)
+				  const union traceeval_data *copy)
 {
 	int i;
 
@@ -92,16 +91,16 @@ static int compare_traceeval_data(struct traceeval *teval,
  * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
  */
 static int compare_traceeval_data_set(struct traceeval *teval,
+				      struct traceeval_type *defs,
 				      union traceeval_data *orig,
-				      const union traceeval_data *copy,
-				      struct traceeval_type *defs, size_t size)
+				      const union traceeval_data *copy, size_t size)
 {
 	int check;
 	size_t i;
 
 	/* compare data arrays */
 	for (i = 0; i < size; i++) {
-		if ((check = compare_traceeval_data(teval, orig + i, copy + i, defs + i)))
+		if ((check = compare_traceeval_data(teval, defs + i, orig + i, copy + i)))
 			return check == -2 ? -1 : 0;
 	}
 
@@ -294,12 +293,12 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 
 	ret = check_keys(keys);
 	if (ret < 0)
-		goto fail;
+		goto fail_release;
 
 	if (vals) {
 		ret = check_vals(vals);
 		if (ret < 0)
-			goto fail;
+			goto fail_release;
 	}
 
 	/* alloc key types */
@@ -463,7 +462,7 @@ static unsigned make_hash(struct traceeval *teval, const union traceeval_data *k
 		key += hash_number(val);
 	}
 
-	return key & HASH_MASK(bits);
+	return key;
 }
 
 /*
@@ -489,8 +488,8 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
 		entry = container_of(item, struct entry, hash);
 
-		check = compare_traceeval_data_set(teval, entry->keys, keys,
-						   teval->key_types, teval->nr_key_types);
+		check = compare_traceeval_data_set(teval, teval->key_types,
+						   entry->keys, keys, teval->nr_key_types);
 		if (check)
 			break;
 	}
@@ -596,7 +595,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
 /*
  * Free @data with respect to @size and @type.
  *
- * Does not call release() if a copy() exists.
+ * Does not call the release() callback if a copy() exists.
  */
 static void data_release(size_t size, union traceeval_data *data,
 			 struct traceeval_type *type)
@@ -776,7 +775,7 @@ fail_entry:
  *
  * Frees the old vals field of @entry, unless an error occurs.
  *
- * Return 1 on success, -1 on error.
+ * Return 0 on success, -1 on error.
  */
 static int update_entry(struct traceeval *teval, struct entry *entry,
 			const union traceeval_data *vals)
@@ -789,7 +788,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	size_t i;
 
 	if (!size)
-		return 1;
+		return 0;
 
 	for (i = 0; i < size; i++) {
 		old[i] = copy[i];
@@ -798,11 +797,16 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 					vals + i, copy + i))
 			goto fail;
 	}
-
+	data_release(size, old, types);
 	return 0;
-
-fail:
-	data_release(i, old, types);
+ fail:
+	/* Free the new values that were added */
+	data_release(i, copy, types);
+	/* Put back the old values */
+	for (i--; i >= 0; i--) {
+		copy_traceeval_data(types + i, NULL,
+				    copy + i, old + i);
+	}
 	return -1;
 }
 
@@ -930,6 +934,35 @@ int traceeval_insert(struct traceeval *teval,
 		return update_entry(teval, entry, vals);
 }
 
+/**
+ * traceeval_remove - remove an item from the traceeval descriptor
+ * @teval: The descriptor to insert into
+ * @keys: The list of keys that defines what is being removed
+ *
+ * This is the opposite of traceeval_insert(). Instead of inserting
+ * an item into the traceeval historgram, it removes it.
+ *
+ * Returns 1 if it found and removed an item,
+ *         0 if it did not find an time matching @keys
+ *        -1 if there was an error.
+ */
+int traceeval_remove(struct traceeval *teval,
+		     const union traceeval_data *keys)
+{
+	struct hash_table *hist = teval->hist;
+	struct entry *entry;
+	int check;
+
+	entry = NULL;
+	check = get_entry(teval, keys, &entry);
+
+	if (check < 1)
+		return check;
+
+	hash_remove(hist, &entry->hash);
+	return 1;
+}
+
 /**
  * traceeval_iterator_put - release a given iterator
  * @iter: The iterartor to release
@@ -942,7 +975,9 @@ void traceeval_iterator_put(struct traceeval_iterator *iter)
 	if (!iter)
 		return;
 
+	free(iter->direction);
 	free(iter->entries);
+	free(iter->sort);
 	free(iter);
 }
 
@@ -1058,6 +1093,7 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 	bool *direction = iter->direction;
 	struct traceeval_type **sort = iter->sort;
 	struct traceeval_type *type;
+	int num_levels = level + 1;
 
 	type = find_sort_type(iter->teval, sort_field);
 	if (!type)
@@ -1074,21 +1110,21 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 		break;
 	}
 
-	if ((level + 1) > iter->nr_sort) {
-		sort = realloc(sort, sizeof(*sort) * (level + 1));
+	if (num_levels > iter->nr_sort) {
+		sort = realloc(sort, sizeof(*sort) * num_levels);
 		if (!sort)
 			return -1;
 
 		iter->sort = sort;
 
-		direction = realloc(direction, sizeof(*direction) * (level + 1));
+		direction = realloc(direction, sizeof(*direction) * num_levels);
 		if (!direction)
 			return -1;
 
 		iter->direction = direction;
 
 		/* Make sure the newly allocated contain NULL */
-		for (int i = iter->nr_sort; i < (level + 1); i++)
+		for (int i = iter->nr_sort; i < num_levels; i++)
 			sort[i] = NULL;
 
 		iter->nr_sort = level + 1;
@@ -1123,7 +1159,7 @@ static int iter_cmp(const void *A, const void *B, void *data)
 			dataB = &b->vals[type->index];
 		}
 
-		ret = compare_traceeval_data(teval, dataA, dataB, type);
+		ret = compare_traceeval_data(teval, type, dataA, dataB);
 
 		if (ret)
 			return iter->direction[i] ? ret : ret * -1;
@@ -1182,6 +1218,7 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 		iter_custom_cmp, &cust_data);
 
 	iter->needs_sort = false;
+	iter->next = 0;
 	return 0;
 }
 

-- Steve
