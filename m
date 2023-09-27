Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C06A18AFA
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D9C433CD;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049TQ-0D;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 01/11] libtraceeval: Add check for updates to know to recreate iter array
Date: Wed, 27 Sep 2023 08:33:04 -0400
Message-Id: <20230927123314.989589-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230927123314.989589-1-rostedt@goodmis.org>
References: <20230927123314.989589-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When an iterator is created, it creates an array of pointers to point to
all the elements in the traceeval. This is used to index through the
entities in an nice order. But if an event is added or removed from the
traceeval, the size and count of this array will be off in the iterator.

Add an "update_counter" that gets incremented every time an item is added
or removed (doesn't need to keep track of updates to existing entries). If
the counter is different from the last time the iterator created the sort
array, it will need to delete and recreate the list again before it can do
a sort.

Note: It is safe to use the iterator to remove items, so a removal (or
even insert) should not affect the traceeval_iterator_next(). But it
should be explained in the man pages (soon to be written) that doing so
must be done with care. And maybe a helper function should be used
instead!

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/eval-local.h |  2 ++
 src/histograms.c | 91 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/src/eval-local.h b/src/eval-local.h
index 5c3918f17cc1..73f52efdf0da 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -68,6 +68,7 @@ struct traceeval {
 	struct hash_table		*hist;
 	size_t				nr_key_types;
 	size_t				nr_val_types;
+	size_t				update_counter;
 };
 
 struct traceeval_iterator {
@@ -75,6 +76,7 @@ struct traceeval_iterator {
 	struct entry			**entries;
 	struct traceeval_type		**sort;
 	bool				*direction;
+	size_t				update_counter;
 	size_t				nr_entries;
 	size_t				nr_sort;
 	size_t				next;
diff --git a/src/histograms.c b/src/histograms.c
index fdc9f0c2fbce..9bf20e4d6d26 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -757,6 +757,8 @@ static int create_entry(struct traceeval *teval,
 	entry->keys = new_keys;
 	entry->vals = new_vals;
 
+	teval->update_counter++;
+
 	return 0;
 
 fail:
@@ -960,6 +962,9 @@ int traceeval_remove(struct traceeval *teval,
 		return check;
 
 	hash_remove(hist, &entry->hash);
+
+	teval->update_counter++;
+
 	return 1;
 }
 
@@ -981,6 +986,37 @@ void traceeval_iterator_put(struct traceeval_iterator *iter)
 	free(iter);
 }
 
+static int create_iter_array(struct traceeval_iterator *iter)
+{
+	struct traceeval *teval = iter->teval;
+	struct hash_table *hist = teval->hist;
+	struct hash_iter *hiter;
+	struct hash_item *item;
+	int i;
+
+	iter->nr_entries = hash_nr_items(hist);
+	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
+	if (!iter->entries)
+		return -1;
+
+	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
+		struct entry *entry = container_of(item, struct entry, hash);
+
+		iter->entries[i] = entry;
+	}
+
+	/* Loop must match entries */
+	if (i != iter->nr_entries) {
+		free(iter->entries);
+		iter->entries = NULL;
+		return -1;
+	}
+
+	iter->update_counter = teval->update_counter;
+
+	return 0;
+}
+
 /**
  * traceeval_iterator_get - get a handle to iterate over a given traceeval
  * @teval: The traceeval handle to iterate over
@@ -997,33 +1033,19 @@ void traceeval_iterator_put(struct traceeval_iterator *iter)
 struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval)
 {
 	struct traceeval_iterator *iter;
-	struct hash_table *hist = teval->hist;
-	struct hash_iter *hiter;
-	struct hash_item *item;
-	int i;
+	int ret;
 
 	iter = calloc(1, sizeof(*iter));
 	if (!iter)
 		return NULL;
 
 	iter->teval = teval;
-	iter->nr_entries = hash_nr_items(hist);
-	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
-	if (!iter->entries) {
-		free(iter);
-		return NULL;
-	}
-
-	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
-		struct entry *entry = container_of(item, struct entry, hash);
 
-		iter->entries[i] = entry;
-	}
+	ret = create_iter_array(iter);
 
-	/* Loop must match entries */
-	if (i != iter->nr_entries) {
-		traceeval_iterator_put(iter);
-		return NULL;
+	if (ret < 0) {
+		free(iter);
+		iter = NULL;
 	}
 
 	return iter;
@@ -1168,6 +1190,31 @@ static int iter_cmp(const void *A, const void *B, void *data)
 	return 0;
 }
 
+static int check_update(struct traceeval_iterator *iter)
+{
+	struct entry **entries;
+	size_t nr_entries;
+	int ret;
+
+	/* Was something added or removed from the teval? */
+	if (iter->teval->update_counter == iter->update_counter)
+		return 0;
+
+	entries = iter->entries;
+	nr_entries = iter->nr_entries;
+
+	/* Something changed, need to recreate the array */
+	ret = create_iter_array(iter);
+	if (ret < 0) {
+		iter->entries = entries;
+		iter->nr_entries = nr_entries;
+		return -1;
+	}
+	free(entries);
+
+	return 0;
+}
+
 static int sort_iter(struct traceeval_iterator *iter)
 {
 	int i;
@@ -1178,6 +1225,9 @@ static int sort_iter(struct traceeval_iterator *iter)
 			return -1;
 	}
 
+	if (check_update(iter) < 0)
+		return -1;
+
 	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
 		iter_cmp, iter);
 
@@ -1214,6 +1264,9 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 		.data = data
 	};
 
+	if (check_update(iter) < 0)
+		return -1;
+
 	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
 		iter_custom_cmp, &cust_data);
 
-- 
2.40.1

