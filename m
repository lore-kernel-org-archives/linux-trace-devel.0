Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08D1F607
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491CBC43391;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049TZ-0T;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 04/11] libtraceeval: Add traceeval_iterator_stat()
Date: Wed, 27 Sep 2023 08:33:07 -0400
Message-Id: <20230927123314.989589-5-rostedt@goodmis.org>
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

Add traceeval_iterator_stat() that will return a stat of a value of the
current entry from a traceeval_iterator_next() loop.

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  2 ++
 samples/task-eval.c      |  6 ++---
 src/histograms.c         | 47 ++++++++++++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 80450d7ae7f9..d6c7097a66c8 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -190,5 +190,7 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 			     const union traceeval_data **results);
 void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const union traceeval_data *results);
+struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
+					       struct traceeval_type *type);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 18e07f44e11e..bde167d1219b 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -706,7 +706,7 @@ static void display_cpus(struct traceeval *teval)
 		int state = keys[1].number;
 		int cpu = keys[0].number;
 
-		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
 		if (!stat)
 			continue; // die?
 
@@ -773,7 +773,7 @@ static void display_threads(struct traceeval *teval)
 		int state = keys[1].number;
 		int tid = keys[0].number;
 
-		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
 		if (!stat)
 			continue; // die?
 
@@ -875,7 +875,7 @@ static void display(struct task_data *tdata)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int state = keys[1].number;
 
-		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		stat = traceeval_iterator_stat(iter, &delta_vals[0]);
 		if (!stat)
 			continue;
 
diff --git a/src/histograms.c b/src/histograms.c
index 50dc8b689637..1dd32157f1cb 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -812,16 +812,11 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	return -1;
 }
 
-struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-				      const union traceeval_data *keys,
-				      struct traceeval_type *type)
+static bool is_stat_type(struct traceeval_type *type)
 {
-	struct entry *entry;
-	int ret;
-
 	/* Only value numbers have stats */
 	if (!(type->flags & TRACEEVAL_FL_VALUE))
-		return NULL;
+		return false;
 
 	switch (type->type) {
 	case TRACEEVAL_TYPE_NUMBER:
@@ -829,10 +824,21 @@ struct traceeval_stat *traceeval_stat(struct traceeval *teval,
 	case TRACEEVAL_TYPE_NUMBER_32:
 	case TRACEEVAL_TYPE_NUMBER_16:
 	case TRACEEVAL_TYPE_NUMBER_8:
-		break;
+		return true;
 	default:
-		return NULL;
+		return false;
 	}
+}
+
+struct traceeval_stat *traceeval_stat(struct traceeval *teval,
+				      const union traceeval_data *keys,
+				      struct traceeval_type *type)
+{
+	struct entry *entry;
+	int ret;
+
+	if (!is_stat_type(type))
+		return NULL;
 
 	ret = get_entry(teval, keys, &entry);
 	if (ret <= 0)
@@ -1359,3 +1365,26 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 		return;
 	}
 }
+
+/**
+ * traceeval_iterator_stat - return the stats from the last iterator entry
+ * @iter: The iterator to retrieve the stats from
+ * @type: The value type to get the stat from
+ *
+ * Returns the stats of the @type for the current iterator entry on success,
+ * or NULL if not found or an error occurred.
+ */
+struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
+					       struct traceeval_type *type)
+{
+	struct entry *entry;
+
+	if (!is_stat_type(type))
+		return NULL;
+
+	if (iter->next < 1 || iter->next > iter->nr_entries)
+		return NULL;
+
+	entry = iter->entries[iter->next - 1];
+	return &entry->val_stats[type->index];
+}
-- 
2.40.1

