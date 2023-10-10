Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC7B321B9
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 19:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD175C433C9;
	Tue, 10 Oct 2023 19:55:34 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqIqe-007VWB-1n;
	Tue, 10 Oct 2023 15:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceeval: Have various errors print warnings
Date: Tue, 10 Oct 2023 15:55:26 -0400
Message-ID: <20231010195655.1789420-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010195655.1789420-1-rostedt@goodmis.org>
References: <20231010195655.1789420-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that there's a way to print out warning messages, use it to print out
most errors that libtraceeval can have.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/delta.c      |  40 ++++++++++---
 src/eval-local.h |   4 ++
 src/histograms.c | 152 +++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 162 insertions(+), 34 deletions(-)

diff --git a/src/delta.c b/src/delta.c
index 99c86122d83f..544998dff412 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -58,12 +58,16 @@ int traceeval_delta_create_data_size(struct traceeval *teval,
 	int i;
 
 	/* Only one can exist */
-	if (teval->tdelta)
+	if (teval->tdelta) {
+		teval_print_err(TEVAL_WARN, "Multiple deltas added to traceeval");
 		return -1;
+	}
 
 	tdelta = calloc(1, sizeof(*tdelta));
-	if (!tdelta)
+	if (!tdelta) {
+		teval_print_err(TEVAL_CRIT, "Failed to allocate delta");
 		return -1;
+	}
 
 	if (vals) {
 		for (i = 0; i < nr_vals && vals[i].type != TRACEEVAL_TYPE_NONE; i++)
@@ -134,8 +138,10 @@ int traceeval_delta_remove_size(struct traceeval *teval,
 				const struct traceeval_data *keys,
 				size_t nr_keys)
 {
-	if (!teval->tdelta)
+	if (!teval->tdelta) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_remove: traceeval does not have delta to remove");
 		return -1;
+	}
 	return traceeval_remove_size(teval->tdelta->teval, keys, nr_keys);
 }
 
@@ -162,8 +168,10 @@ int traceeval_delta_query_size(struct traceeval *teval,
 			       const struct traceeval_data *keys,
 			       size_t nr_keys, const struct traceeval_data **results)
 {
-	if (!teval->tdelta)
+	if (!teval->tdelta) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_query: traceeval does not have delta to query");
 		return -1;
+	}
 	return traceeval_query_size(teval->tdelta->teval, keys,
 				    nr_keys, results);
 }
@@ -177,14 +185,24 @@ static int delta_start(struct traceeval *teval,
 	int ret;
 	int i;
 
-	if (!teval->tdelta)
+	if (!teval->tdelta) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: traceeval does not have delta");
 		return -1;
+	}
 
 	teval = teval->tdelta->teval;
 
-	if (nr_keys != teval->nr_key_types ||
-	    nr_vals != teval->nr_val_types - 1)
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: Received %zd keys but expected %zd",
+				nr_keys, teval->nr_key_types);
+		return -1;
+	}
+
+	if (nr_vals != teval->nr_val_types - 1) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: Received %zd vals but expected %zd",
+				nr_vals, teval->nr_val_types - 1);
 		return -1;
+	}
 
 	ret = _teval_get_entry(teval, keys, &entry);
 	if (ret < 0)
@@ -309,8 +327,10 @@ int traceeval_delta_stop_size(struct traceeval *teval,
 	struct entry *entry;
 	int ret;
 
-	if (!teval->tdelta)
+	if (!teval->tdelta) {
+		teval_print_err(TEVAL_WARN, "traceeval_delta_stop: traceeval does not have delta");
 		return -1;
+	}
 
 	teval = teval->tdelta->teval;
 
@@ -349,8 +369,10 @@ static int create_delta_iter_array(struct traceeval_iterator *iter)
 
 	iter->nr_entries = hash_nr_items(hist);
 	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
-	if (!iter->entries)
+	if (!iter->entries) {
+		teval_print_err(TEVAL_CRIT, "Failed to allocate entries");
 		return -1;
+	}
 
 	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
 		struct entry *entry = container_of(item, struct entry, hash);
diff --git a/src/eval-local.h b/src/eval-local.h
index 252a1c1d2029..ca8195a2f4cb 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -103,6 +103,10 @@ struct traceeval_iterator {
 	bool				no_sort;
 };
 
+extern void teval_print_failed_type(const char *type,
+				    const struct traceeval_type *expect,
+				    const struct traceeval_data *got);
+
 extern int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 			    struct entry **result);
 
diff --git a/src/histograms.c b/src/histograms.c
index 32ae4f180063..ea44814b7693 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -53,6 +53,42 @@ __hidden void teval_print_err(int level, const char *fmt, ...)
 	va_end(ap);
 }
 
+static const char *get_type_name(enum traceeval_data_type type)
+{
+	switch (type) {
+	case TRACEEVAL_TYPE_NONE:
+		return "NONE";
+	case TRACEEVAL_TYPE_NUMBER_8:
+		return "NUMBER_8";
+	case TRACEEVAL_TYPE_NUMBER_16:
+		return "NUMBER_16";
+	case TRACEEVAL_TYPE_NUMBER_32:
+		return "NUMBER_32";
+	case TRACEEVAL_TYPE_NUMBER_64:
+		return "NUMBER_64";
+	case TRACEEVAL_TYPE_NUMBER:
+		return "NUMBER";
+	case TRACEEVAL_TYPE_POINTER:
+		return "POINTER";
+	case TRACEEVAL_TYPE_STRING:
+		return "STRING";
+	case TRACEEVAL_TYPE_DELTA:
+		return "DELTA";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+__hidden void teval_print_failed_type(const char *type,
+				      const struct traceeval_type *expect,
+				      const struct traceeval_data *got)
+{
+	teval_print_err(TEVAL_WARN, "%s %s has type %s but expects type %s",
+			type, expect->name,
+			get_type_name(got->type),
+			get_type_name(expect->type));
+}
+
 /*
  * Compare traceeval_data instances.
  *
@@ -69,11 +105,15 @@ static int compare_traceeval_data(struct traceeval *teval,
 	if (orig == copy)
 		return 0;
 
-	if (!orig)
+	if (!orig) {
+		teval_print_err(TEVAL_INFO, "No source data passed in to compare");
 		return -1;
+	}
 
-	if (!copy)
-		return 1;
+	if (!copy) {
+		teval_print_err(TEVAL_INFO, "No destination data passed in to compare");
+		return -1;
+	}
 
 	if (type->cmp)
 		return type->cmp(teval, type, orig, copy);
@@ -241,8 +281,11 @@ static int check_keys(struct traceeval_type *keys, int cnt)
 		switch (keys[i].type) {
 		case TRACEEVAL_TYPE_POINTER:
 			/* Key pointer types must have a cmp and hash function */
-			if (!keys[i].cmp || !keys[i].hash)
+			if (!keys[i].cmp || !keys[i].hash) {
+				teval_print_err(TEVAL_WARN, "Key %s must have compare and hansh values",
+						keys[i].name);
 				return -1;
+			}
 			break;
 		default:
 			break;
@@ -262,14 +305,24 @@ static int check_vals(struct traceeval *teval, struct traceeval_type *vals, int
 
 		if (vals[i].flags & TRACEEVAL_FL_TIMESTAMP) {
 			/* Only one field may be marked as a timestamp */
-			if (ts_found)
+			if (ts_found) {
+				teval_print_err(TEVAL_WARN, "Two timestamps found: %s and %s",
+						vals[teval->timestamp_idx].name,
+						vals[i].name);
 				return -1;
+			}
 			/* The type must be numeric */
-			if (vals[i].type > TRACEEVAL_TYPE_NUMBER)
+			if (vals[i].type > TRACEEVAL_TYPE_NUMBER) {
+				teval_print_err(TEVAL_WARN, "Timestamp value %s must be numeric",
+						vals[i].name);
 				return -1;
+			}
 			/* TIMESTAMPS can not be STATs themselves */
-			if (vals[i].flags & TRACEEVAL_FL_STAT)
+			if (vals[i].flags & TRACEEVAL_FL_STAT) {
+				teval_print_err(TEVAL_WARN, "Value %s can not be both a timestamp and a stat value",
+						vals[i].name);
 				return -1;
+			}
 			ts_found = true;
 			teval->timestamp_idx = i;
 		}
@@ -535,12 +588,16 @@ __hidden int _teval_get_entry(struct traceeval *teval, const struct traceeval_da
 	int check = 0;
 	int i;
 
-	if (!teval || !keys)
+	if (!teval || !keys) {
+		teval_print_err(TEVAL_INFO, "No teval or key to get entry");
 		return -1;
+	}
 
 	for (i = 0; i < teval->nr_key_types; i++) {
-		if (keys[i].type != teval->key_types[i].type)
+		if (keys[i].type != teval->key_types[i].type) {
+			teval_print_failed_type("Key", &teval->key_types[i], &keys[i]);
 			return -1;
+		}
 	}
 
 	key = make_hash(teval, keys, hist->bits);
@@ -678,8 +735,10 @@ static int copy_traceeval_data(struct traceeval_type *type,
 		if (src->string)
 			dst->string = strdup(src->string);
 
-		if (!dst->string)
+		if (!dst->string) {
+			teval_print_err(TEVAL_CRIT, "Failed to allocate string");
 			return -1;
+		}
 		return 0;
 
 	case TRACEEVAL_TYPE_DELTA:
@@ -748,8 +807,10 @@ static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 		return 1;
 
 	*copy = calloc(size, sizeof(**copy));
-	if (!*copy)
+	if (!*copy) {
+		teval_print_err(TEVAL_CRIT, "Failed to allocate data");
 		return -1;
+	}
 
 	for (i = 0; i < size; i++) {
 		if (copy_traceeval_data(type + i, stats ? stats + i : NULL,
@@ -760,6 +821,7 @@ static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 	return 1;
 
 fail:
+	teval_print_err(TEVAL_INFO, "Error in copying data");
 	data_release_and_free(i, copy, type);
 	return -1;
 }
@@ -788,11 +850,16 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 	struct entry *entry;
 	int check;
 
-	if (!teval || !keys || !results)
+	if (!teval || !keys || !results) {
+		teval_print_err(TEVAL_INFO, "traceeval_query: No teval keys or results passed in");
 		return -1;
+	}
 
-	if (nr_keys != teval->nr_key_types)
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_err(TEVAL_WARN, "traceeval_query: key array size is %zd but expected %zd",
+				nr_keys, teval->nr_key_types);
 		return -1;
+	}
 
 	/* find key and copy its corresponding value pair */
 	if ((check = _teval_get_entry(teval, keys, &entry)) < 1)
@@ -862,8 +929,10 @@ static int create_entry(struct traceeval *teval,
 	struct entry *entry;
 
 	entry = create_hist_entry(teval, keys);
-	if (!entry)
+	if (!entry) {
+		teval_print_err(TEVAL_CRIT, "Failed to allocate histogram");
 		return -1;
+	}
 
 	entry->val_stats = calloc(teval->nr_val_types, sizeof(*entry->val_stats));
 	if (!entry->val_stats)
@@ -924,8 +993,10 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	ts = get_timestamp(teval, vals);
 
 	for (i = 0; i < teval->nr_val_types; i++) {
-		if (vals[i].type != teval->val_types[i].type)
+		if (vals[i].type != teval->val_types[i].type) {
+			teval_print_failed_type("Value", &teval->val_types[i], &vals[i]);
 			return -1;
+		}
 	}
 
 	for (i = 0; i < size; i++) {
@@ -1076,8 +1147,10 @@ __hidden int _teval_insert(struct traceeval *teval,
 	check = _teval_get_entry(teval, keys, &entry);
 
 	for (i = 0; i < nr_vals; i++) {
-		if (vals[i].type != teval->val_types[i].type)
+		if (vals[i].type != teval->val_types[i].type) {
+			teval_print_failed_type("Value", &teval->val_types[i], &vals[i]);
 			return -1;
+		}
 	}
 
 	if (check == -1)
@@ -1125,8 +1198,17 @@ int traceeval_insert_size(struct traceeval *teval,
 			  const struct traceeval_data *keys, size_t nr_keys,
 			  const struct traceeval_data *vals, size_t nr_vals)
 {
-	if (nr_keys != teval->nr_key_types || nr_vals != teval->nr_val_types)
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_err(TEVAL_WARN, "traceeval_insert: received %zd keys but expected %zd",
+				nr_keys, teval->nr_key_types);
 		return -1;
+	}
+
+	if (nr_vals != teval->nr_val_types) {
+		teval_print_err(TEVAL_WARN, "traceeval_insert: received %zd vals but expected %zd",
+				nr_vals, teval->nr_val_types);
+		return -1;
+	}
 
 	return _teval_insert(teval, keys, nr_keys, vals, nr_vals);
 }
@@ -1151,8 +1233,11 @@ int traceeval_remove_size(struct traceeval *teval,
 	struct entry *entry;
 	int check;
 
-	if (teval->nr_key_types != nr_keys)
+	if (teval->nr_key_types != nr_keys) {
+		teval_print_err(TEVAL_WARN, "traceeval_remove: received %zd keys but expected %zd",
+				nr_keys, teval->nr_key_types);
 		return -1;
+	}
 
 	entry = NULL;
 	check = _teval_get_entry(teval, keys, &entry);
@@ -1211,8 +1296,10 @@ static int create_iter_array(struct traceeval_iterator *iter)
 
 	iter->nr_entries = hash_nr_items(hist);
 	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
-	if (!iter->entries)
+	if (!iter->entries) {
+		teval_print_err(TEVAL_CRIT, "Failed to allocate array");
 		return -1;
+	}
 
 	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
 		struct entry *entry = container_of(item, struct entry, hash);
@@ -1224,6 +1311,7 @@ static int create_iter_array(struct traceeval_iterator *iter)
 	if (i != iter->nr_entries) {
 		free(iter->entries);
 		iter->entries = NULL;
+		teval_print_err(TEVAL_WARN, "Error in hash lookup");
 		return -1;
 	}
 
@@ -1334,14 +1422,20 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 		return -1;
 
 	type = find_sort_type(iter->teval, sort_field);
-	if (!type)
+	if (!type) {
+		teval_print_err(TEVAL_WARN, "traceeval_iterator_sort: Could not find sort field %s",
+				sort_field);
 		return -1;
+	}
 
 	/* pointer types must have a cmp function */
 	switch (type->type) {
 	case TRACEEVAL_TYPE_POINTER:
-		if (!type->cmp)
+		if (!type->cmp) {
+			teval_print_err(TEVAL_WARN, "traceeval_iterator_sort: No compare function for type %s",
+					type->name);
 			return -1;
+		}
 		break;
 	default:
 		break;
@@ -1349,14 +1443,18 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 
 	if (num_levels > iter->nr_sort) {
 		sort = realloc(sort, sizeof(*sort) * num_levels);
-		if (!sort)
+		if (!sort) {
+			teval_print_err(TEVAL_CRIT, "Failed to allocate sort");
 			return -1;
+		}
 
 		iter->sort = sort;
 
 		direction = realloc(direction, sizeof(*direction) * num_levels);
-		if (!direction)
+		if (!direction) {
+			teval_print_err(TEVAL_CRIT, "Failed to allocate direction");
 			return -1;
+		}
 
 		iter->direction = direction;
 
@@ -1436,8 +1534,10 @@ static int sort_iter(struct traceeval_iterator *iter)
 
 	/* Make sure all levels are filled */
 	for (i = 0; i < iter->nr_sort; i++) {
-		if (!iter->sort[i])
+		if (!iter->sort[i]) {
+			teval_print_err(TEVAL_WARN, "Missing sort level");
 			return -1;
+		}
 	}
 
 	if (check_update(iter) < 0)
@@ -1480,8 +1580,10 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 	};
 
 	/* delta iterators are not to be sorted */
-	if (iter->no_sort)
+	if (iter->no_sort) {
+		teval_print_err(TEVAL_WARN, "Can not sort start events in deltas");
 		return -1;
+	}
 
 	if (check_update(iter) < 0)
 		return -1;
-- 
2.42.0

