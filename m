Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F619F505
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 13:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC3FC433C7;
	Tue,  3 Oct 2023 13:41:01 +0000 (UTC)
Date: Tue, 3 Oct 2023 09:42:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@chromium.org>
Subject: [PATCH v2] traceeval: Add way to extract the number of elements
Message-ID: <20231003094206.2e6a5fd6@gandalf.local.home>
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

Add traceeval_count() that will return the number of elements in the
traceeval. This can be useful for allocating an array to store the
elements. By getting the count, the allocation can be done first and
then iterated to load the elements into the array.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230928102434.58e08f78@rorschach.local.home

 - Do not use "update_counter" for count, but create a new nr_elements
   to keep track of the number of elements in the traceeval (Ross Zwisler)

 include/traceeval-hist.h |  2 ++
 src/eval-local.h         |  1 +
 src/histograms.c         | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 0c29977671a3..65a905034773 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -204,6 +204,8 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
 
+size_t traceeval_count(struct traceeval *teval);
+
 #define traceeval_stat(teval, keys, type)				\
 	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
 
diff --git a/src/eval-local.h b/src/eval-local.h
index f0917b6a45e9..805ec25ff1f4 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -69,6 +69,7 @@ struct traceeval {
 	size_t				nr_key_types;
 	size_t				nr_val_types;
 	size_t				update_counter;
+	size_t				nr_elements;
 	size_t				sizeof_type;
 	size_t				sizeof_data;
 };
diff --git a/src/histograms.c b/src/histograms.c
index bfeb162fffe4..483abaf802dc 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -786,6 +786,7 @@ static int create_entry(struct traceeval *teval,
 	entry->vals = new_vals;
 
 	teval->update_counter++;
+	teval->nr_elements++;
 
 	return 0;
 
@@ -1002,11 +1003,26 @@ int traceeval_remove_size(struct traceeval *teval,
 	hash_remove(hist, &entry->hash);
 	free_entry(teval, entry);
 
+	/* update_counter is used to know if there was an update. */
 	teval->update_counter++;
 
+	/* nr_elements keeps track of the number of stored elemnets */
+	teval->nr_elements--;
+
 	return 1;
 }
 
+/**
+ * traceeval_count - Return the number of elements in the traceeval
+ * @teval: The traceeval handle to get the count from
+ *
+ * Returns the number of elements stored by unique keys in the @teval.
+ */
+size_t traceeval_count(struct traceeval *teval)
+{
+	return teval->nr_elements;
+}
+
 /**
  * traceeval_iterator_put - release a given iterator
  * @iter: The iterartor to release
@@ -1457,6 +1473,7 @@ int traceeval_iterator_remove(struct traceeval_iterator *iter)
 	/* The entry no longer exists */
 	iter->entries[iter->next - 1] = NULL;
 	teval->update_counter++;
+	teval->nr_elements--;
 
 	return 1;
 }
-- 
2.40.1

