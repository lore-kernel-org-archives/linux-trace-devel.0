Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619A51846
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40404C433C7;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049TT-0I;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 02/11] libtraceeval: Add traceeval_iterator_query()
Date: Wed, 27 Sep 2023 08:33:05 -0400
Message-Id: <20230927123314.989589-3-rostedt@goodmis.org>
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

Add a query to the iterator that will return the values of the last entry
that matches the keys returned by the last call of traceeval_iterator_next().

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  2 ++
 samples/task-eval.c      |  2 +-
 src/histograms.c         | 30 ++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 0cee9bcbeb83..837a74f61a66 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -186,5 +186,7 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 				   traceeval_cmp_fn sort_fn, void *data);
 int traceeval_iterator_next(struct traceeval_iterator *iter,
 			    const union traceeval_data **keys);
+int traceeval_iterator_query(struct traceeval_iterator *iter,
+			     const union traceeval_data **results);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 66d0c40dc0c8..18e07f44e11e 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -836,7 +836,7 @@ static void display_processes(struct traceeval *teval,
 		struct process_data *pdata = NULL;
 		const char *comm = keys[0].cstring;
 
-		ret = traceeval_query(teval_data, keys, &results);
+		ret = traceeval_iterator_query(iter, &results);
 		if (ret < 0)
 			pdie("Could not query iterator");
 		if (ret < 1)
diff --git a/src/histograms.c b/src/histograms.c
index 9bf20e4d6d26..06613a8933ec 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1306,3 +1306,33 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 	*keys = entry->keys;
 	return 1;
 }
+
+/**
+ * traceeval_iterator_query - return the results from the current entry in the iterator
+ * @iter: The iterator to retrieve the entry results from
+ * @results: The returned results of the last entry (if exists)
+ *
+ * This returns the @results of the values from the last instance of
+ * traceeval_iterator_next(). It is equivalent of calling:
+ *
+ * traceeval_query() with the keys returned by traceeval_iterator_next().
+ *
+ * Except that it will always quickly return the current entry, whereas the
+ * traceeval_query() will reset the cached next_entry and do a full
+ * lookup again.
+ *
+ * Returns 1 if another entry is returned, or 0 if not (or negative on error)
+ */
+int traceeval_iterator_query(struct traceeval_iterator *iter,
+			     const union traceeval_data **results)
+{
+	struct entry *entry;
+
+	if (iter->next < 1 || iter->next > iter->nr_entries)
+		return 0;
+
+	entry = iter->entries[iter->next - 1];
+	*results = entry->vals;
+
+	return 1;
+}
-- 
2.40.1

