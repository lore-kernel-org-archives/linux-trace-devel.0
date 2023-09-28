Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F438DC5
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Sep 2023 14:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5BDC433C7;
	Thu, 28 Sep 2023 14:24:37 +0000 (UTC)
Date: Thu, 28 Sep 2023 10:24:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@chromium.org>
Subject: [PATCH] traceeval: Add way to extract the number of elements
Message-ID: <20230928102434.58e08f78@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
 include/traceeval-hist.h |  2 ++
 src/histograms.c         | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index eefa48d..44d071f 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -204,6 +204,8 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
 
+size_t traceeval_count(struct traceeval *teval);
+
 #define traceeval_stat(teval, keys, type)				\
 	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
 
diff --git a/src/histograms.c b/src/histograms.c
index 2456342..ac3f7f7 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1006,6 +1006,17 @@ int traceeval_remove_size(struct traceeval *teval,
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
+	return teval->update_counter;
+}
+
 /**
  * traceeval_iterator_put - release a given iterator
  * @iter: The iterartor to release
-- 
2.40.1

