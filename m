Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE2249EB
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B145C433C8;
	Wed, 11 Oct 2023 22:27:27 +0000 (UTC)
Date: Wed, 11 Oct 2023 18:28:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add traceeval_hitcount() API
Message-ID: <20231011182848.35a006d6@gandalf.local.home>
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

Add a new function traceeval_hitcount() that returns the number of times
the entry represented by the given keys was updated.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-init.txt | 37 ++++-------------------------
 include/traceeval.h                 |  6 +++++
 src/eval-local.h                    |  1 +
 src/histograms.c                    | 36 ++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/Documentation/libtraceeval-init.txt b/Documentation/libtraceeval-init.txt
index ed505d11713c..71251f2cc8ff 100644
--- a/Documentation/libtraceeval-init.txt
+++ b/Documentation/libtraceeval-init.txt
@@ -204,30 +204,18 @@ struct traceeval_type sched_keys[] = {
 	},
 };
 
-
-struct traceeval_type sched_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER_64,
-		.name = "Hitcount",
-	},
-};
-
 static int sched_callback(struct tep_event *event, struct tep_record *record,
 			  int cpu, void *data)
 {
 	static struct tep_format_field *pid_field;
 	static struct tep_format_field *comm_field;
 	static struct tep_format_field *state_field;
-	const struct traceeval_data *results;
 	struct traceeval_data keys[3];
-	struct traceeval_data vals[1];
 	struct traceeval *teval = data;
-	unsigned long long hits = 0;
 	unsigned long long val;
 	char *comm;
 	int state;
 	int pid;
-	int ret;
 
 	if (!pid_field) {
 		pid_field = tep_find_field(event, "prev_pid");
@@ -250,20 +238,7 @@ static int sched_callback(struct tep_event *event, struct tep_record *record,
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 	TRACEEVAL_SET_NUMBER(keys[2], state);
 
-	ret = traceeval_query(teval, keys, &results);
-	if (ret < 0)
-		pdie("Failed to query keys");
-
-	if (ret) {
-		hits = results[0].number_64;
-		traceeval_results_release(teval, results);
-	}
-
-	hits++;
-
-	TRACEEVAL_SET_NUMBER_64(vals[0], hits);
-
-	traceeval_insert(teval, keys, vals);
+	traceeval_insert(teval, keys, NULL);
 
 	return 0;
 }
@@ -284,7 +259,6 @@ static char *get_state(int state)
 static void display_teval(struct traceeval *teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
-	const struct traceeval_data *results;
 	const struct traceeval_data *keys;
 
 	/* Sort comms first. */
@@ -295,11 +269,10 @@ static void display_teval(struct traceeval *teval)
 	traceeval_iterator_sort(iter, sched_keys[2].name, 2, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		traceeval_iterator_query(iter, &results);
+		ssize_t hits = traceeval_hitcount_size(teval, keys, TRACEEVAL_ARRAY_SIZE(sched_keys));
 
-		printf("%s [%ld] %s: %lld\n",
-		       keys[0].string, keys[1].number, get_state(keys[2].number),
-		       results[0].number_64);
+		printf("%s [%ld] %s: %zd\n",
+		       keys[0].string, keys[1].number, get_state(keys[2].number), hits);
 	}
 	traceeval_iterator_put(iter);
 }
@@ -318,7 +291,7 @@ int main (int argc, char **argv)
 	bool finished = false;
 	int ret;
 
-	teval = traceeval_init(sched_keys, sched_vals);
+	teval = traceeval_init(sched_keys, NULL);
 	if (!teval)
 		pdie("Creating traceeval");
 
diff --git a/include/traceeval.h b/include/traceeval.h
index 69c7c45a7bea..58c220c0f81c 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -274,6 +274,12 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
 
+#define traceeval_hitcount(teval, keys)					\
+	traceeval_hitcount_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
+
+ssize_t traceeval_hitcount_size(struct traceeval *teval,
+				const struct traceeval_data *keys, size_t nr_keys);
+
 size_t traceeval_count(struct traceeval *teval);
 
 #define traceeval_delta_create(teval, keys, vals)			\
diff --git a/src/eval-local.h b/src/eval-local.h
index 6ae61cf41922..9f387e500efa 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -67,6 +67,7 @@ struct entry {
 	struct traceeval_data	*keys;
 	struct traceeval_data	*vals;
 	struct traceeval_stat	*val_stats;
+	size_t			hitcount;
 };
 
 enum {
diff --git a/src/histograms.c b/src/histograms.c
index f77afc3a86a1..f6bbc4444361 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -974,6 +974,7 @@ static int create_entry(struct traceeval *teval,
 
 	entry->keys = new_keys;
 	entry->vals = new_vals;
+	entry->hitcount = 1;
 
 	teval->update_counter++;
 	teval->nr_elements++;
@@ -1009,6 +1010,8 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	size_t size = teval->nr_val_types;
 	ssize_t i;
 
+	entry->hitcount++;
+
 	if (!size)
 		return 0;
 
@@ -1055,6 +1058,39 @@ static struct traceeval_type *find_val_type(struct traceeval *teval, const char
 	return NULL;
 }
 
+/**
+ * traceeval_hitcount - return the number of times a entry was updated
+ * @teval: The traceeval descriptor
+ * @keys: The keys to find how many times it was hit
+ * @nr_keys: The size of @keys
+ *
+ * This looks for the entry represested by @keys in @teval and returns
+ * the number of times it was updated. If no entry is found, it will
+ * return 0 and if @nr_keys does not match what is expected it will return
+ * -1.
+ *
+ * Returns number of hits @keys had on success, 0 if not found, and -1 on error.
+ */
+ssize_t traceeval_hitcount_size(struct traceeval *teval,
+				const struct traceeval_data *keys,
+				size_t nr_keys)
+{
+	struct entry *entry;
+	int ret;
+
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_failed_count("traceeval_hitcount", "key",
+					 nr_keys, teval->nr_key_types);
+		return -1;
+	}
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret <= 0)
+		return 0;
+
+	return entry->hitcount;
+}
+
 struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 					   const struct traceeval_data *keys,
 					   size_t nr_keys,
-- 
2.42.0

