Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE71846
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4804DC433D9;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049Tg-0Y;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 05/11] libtraceeval: Add traceeval_iterator_remove()
Date: Wed, 27 Sep 2023 08:33:08 -0400
Message-Id: <20230927123314.989589-6-rostedt@goodmis.org>
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

Add an API traceeval_iterator_remove() that is safe to call in the
traceeval_iterator_next() loop. Currently, traceeval_remove() can also be
called "safely", but that may change in the future.

The main difference between traceeval_remove() and traceeval_iterator_remove()
is that that traceeval_iterator_remove() will NULL out the entry in the
sort array, and use this in the other iterator functions. If the entry is
NULL, it will not be returned.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  1 +
 src/histograms.c         | 49 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index d6c7097a66c8..e619d52ea0d0 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -192,5 +192,6 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const union traceeval_data *results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       struct traceeval_type *type);
+int traceeval_iterator_remove(struct traceeval_iterator *iter);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index 1dd32157f1cb..0cc3e0bd732b 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -968,6 +968,7 @@ int traceeval_remove(struct traceeval *teval,
 		return check;
 
 	hash_remove(hist, &entry->hash);
+	free_entry(teval, entry);
 
 	teval->update_counter++;
 
@@ -1305,10 +1306,13 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 		iter->next = 0;
 	}
 
-	if (iter->next >= iter->nr_entries)
-		return 0;
+	do {
+		if (iter->next >= iter->nr_entries)
+			return 0;
+
+		entry = iter->entries[iter->next++];
+	} while (!entry);
 
-	entry = iter->entries[iter->next++];
 	*keys = entry->keys;
 	return 1;
 }
@@ -1338,6 +1342,9 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 		return 0;
 
 	entry = iter->entries[iter->next - 1];
+	if (!entry)
+		return 0;
+
 	*results = entry->vals;
 
 	return 1;
@@ -1386,5 +1393,39 @@ struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 		return NULL;
 
 	entry = iter->entries[iter->next - 1];
-	return &entry->val_stats[type->index];
+	return entry ? &entry->val_stats[type->index] : NULL;
+}
+
+/**
+ * traceeval_iterator_remove - remove the current iterator entry
+ * @iter: The iterator to remove the entry from
+ *
+ * This will remove the current entry from the histogram.
+ * This is useful if the current entry should be removed. It will not
+ * affect the traceeval_iterator_next().
+ *
+ * Returns 1 if it successfully removed the entry, 0 if for some reason
+ * there was no "current entry" (called before traceeval_iterator_next()).
+ */
+int traceeval_iterator_remove(struct traceeval_iterator *iter)
+{
+	struct traceeval *teval = iter->teval;
+	struct hash_table *hist = teval->hist;
+	struct entry *entry;
+
+	if (iter->next < 1 || iter->next > iter->nr_entries)
+		return 0;
+
+	entry = iter->entries[iter->next - 1];
+	if (!entry)
+		return 0;
+
+	hash_remove(hist, &entry->hash);
+	free_entry(teval, entry);
+
+	/* The entry no longer exists */
+	iter->entries[iter->next - 1] = NULL;
+	teval->update_counter++;
+
+	return 1;
 }
-- 
2.40.1

