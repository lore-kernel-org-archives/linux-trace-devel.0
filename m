Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C02D1865C
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC2EC433CA;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049TW-0N;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 03/11] libtraceeval: Add traceeval_iterator_results_release()
Date: Wed, 27 Sep 2023 08:33:06 -0400
Message-Id: <20230927123314.989589-4-rostedt@goodmis.org>
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

Add the function that can release the results from the
traceeval_iterator_qeury() function.

Currently, the user must use traceeval_results_release() for the results
returned by traceeval_iterator_query(), but that requires the caller to
also have access to the traceeval where the iterator came from. There
could be many iterators and many traceevals, the user should not need to
worry about which one goes with which.

This new traceeval_iterator_results_release() will take care of that for
them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  2 ++
 src/histograms.c         | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 837a74f61a66..80450d7ae7f9 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -188,5 +188,7 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 			    const union traceeval_data **keys);
 int traceeval_iterator_query(struct traceeval_iterator *iter,
 			     const union traceeval_data **results);
+void traceeval_iterator_results_release(struct traceeval_iterator *iter,
+					const union traceeval_data *results);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index 06613a8933ec..50dc8b689637 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1336,3 +1336,26 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 
 	return 1;
 }
+
+/*
+ * traceeval_iterator_results_release - release the results return by traceeval_iterator_query()
+ * @iter: The iterator descriptor used in traceeval_iterator_query()
+ * @results: The results returned by traceeval_iterator_query()
+ *
+ * The @results returned by traceeval_iterator_query() is owned by @teval,
+ * that is attached to the iterator and how it manages it is implementation
+ * specific. The caller should not worry about it. When the caller of
+ * traceeval_iterator_query() is done with the @results, it must call
+ * traceeval_iterator_results_release() (or traceeval_results_release() if it
+ * has the handle of the teval used to get the iterator) on it to allow traceeval
+ * to clean up its references.
+ */
+void traceeval_iterator_results_release(struct traceeval_iterator *iter,
+					const union traceeval_data *results)
+{
+	if (!iter || !results) {
+		if (!iter)
+			print_err("Results to be freed without accompanied iterator!");
+		return;
+	}
+}
-- 
2.40.1

