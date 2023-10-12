Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5823226288
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04CEC433C8;
	Thu, 12 Oct 2023 18:50:13 +0000 (UTC)
Date: Thu, 12 Oct 2023 14:51:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add timestamp to traceeval_delta_query()
Message-ID: <20231012145139.4b66f9cf@gandalf.local.home>
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

When writing the man pages for traceeval_delta_query(), I realized that it
should also return the timestamp associated to the delta. This may be
useful as well, and it should be added before the API is set.

The timestamp parameter may be NULL if it is to be ignored.

If it is retrieved, it will be the last value of a traceeval_delta_stop()
or traceeval_delta_continue() if that was the last function called on the
give keys. If traceeval_delat_stop() is called last, then the timestamp
will be zero.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |  8 +++++---
 samples/task-eval.c |  2 +-
 src/delta.c         | 33 +++++++++++++++++++++++++++++----
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 9b723f30e1d6..f02ecdd58ffb 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -303,10 +303,12 @@ int traceeval_delta_start_size(struct traceeval *teval,
 
 int traceeval_delta_query_size(struct traceeval *teval,
 			       const struct traceeval_data *keys,
-			       size_t nr_keys, const struct traceeval_data **results);
+			       size_t nr_keys, const struct traceeval_data **results,
+			       unsigned long long *timestamp);
 
-#define traceeval_delta_query(teval, keys, results)			\
-	traceeval_delta_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
+#define traceeval_delta_query(teval, keys, results, timestamp)		\
+	traceeval_delta_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+				   results, timestamp)
 
 int traceeval_delta_continue_size(struct traceeval *teval,
 				  const struct traceeval_data *keys, size_t nr_keys,
diff --git a/samples/task-eval.c b/samples/task-eval.c
index e355d0755b8a..c68ae854e680 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -173,7 +173,7 @@ int cpu_last_state(struct traceeval *teval, int cpu, int *state)
 
 	TRACEEVAL_SET_NUMBER(keys[0], cpu);
 
-	ret = traceeval_delta_query(teval, keys, &results);
+	ret = traceeval_delta_query(teval, keys, &results, NULL);
 	if (ret < 1)
 		return ret;
 
diff --git a/src/delta.c b/src/delta.c
index c802959e9d89..70997db045dc 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -145,6 +145,7 @@ int traceeval_delta_remove_size(struct traceeval *teval,
  * @teval: The traceeval descriptor to search the traceeval_delta from
  * @keys: A list of data to look for
  * @results: A pointer to where to place the results (if found)
+ * @timestamp: A pointer to where to place the starting timestamp (if found)
  *
  * This does a lookup for an instance within the traceeval_delta.
  * The @keys is an array defined by the keys declared in traceeval_delta_init().
@@ -152,7 +153,11 @@ int traceeval_delta_remove_size(struct traceeval *teval,
  * inserted by traceeval_delta_start().
  *
  * The @results will hold the vals passed to the last traceeval_delta_start()
- * for the given @keys if found, or undefined if not.
+ * for the given @keys if found, or undefined if not. The current timestamp
+ * will be stored in @timestamp. Note it will be zero if the last call to
+ * @keys was traceeval_delta_stop().
+ *
+ * Both @results and @timestamp may be NULL if they are to be ignored.
  *
  * Note, when the caller is done with @results, it must call
  * traceeval_results_release() on it.
@@ -161,14 +166,34 @@ int traceeval_delta_remove_size(struct traceeval *teval,
  */
 int traceeval_delta_query_size(struct traceeval *teval,
 			       const struct traceeval_data *keys,
-			       size_t nr_keys, const struct traceeval_data **results)
+			       size_t nr_keys, const struct traceeval_data **results,
+			       unsigned long long *timestamp)
 {
+	const struct traceeval_data *tresults;
+	size_t ts_idx = teval->nr_val_types - 1;
+	int ret;
+
 	if (!teval->tdelta) {
 		teval_print_err(TEVAL_WARN, "traceeval_delta_query: traceeval does not have delta to query");
 		return -1;
 	}
-	return traceeval_query_size(teval->tdelta->teval, keys,
-				    nr_keys, results);
+	ret = traceeval_query_size(teval->tdelta->teval, keys,
+				 nr_keys, &tresults);
+	if (ret < 1)
+		return ret;
+
+	/*
+	 * Note, the timestamp is stored in the results, it's just that
+	 * the caller doesn't know about it.
+	 */
+	if (timestamp)
+		*timestamp = tresults[ts_idx].number_64;
+
+	if (results)
+		*results = tresults;
+	else
+		traceeval_results_release(teval, tresults);
+	return 1;
 }
 
 static int insert_vals(struct traceeval *teval, const struct traceeval_data *keys,
-- 
2.42.0

