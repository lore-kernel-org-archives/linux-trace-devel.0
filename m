Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDBCC6FD22
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355677AbjHQWY0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355702AbjHQWYT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1C630DA
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C00F064FD0
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2843DC433C9;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000UsK-2H;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/9] libtraceeval: Add traceeval_iterator_query()
Date:   Thu, 17 Aug 2023 18:24:15 -0400
Message-Id: <20230817222422.118568-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a query to the iterator that will return the values of the last entry
that matches the keys returned by the last call of traceeval_iterator_next().

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
index 66bdc1769985..4f603ce36c8c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1306,3 +1306,33 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 	*keys = entry->keys;
 	return 1;
 }
+
+/**
+ * traceeval_iterator_query - return the results of the last entry in the iterator
+ * @iter: The iterator to retrieve the entry results from
+ * @results: The returned results of the last entry (if exists)
+ *
+ * This returns the @results of the values from the last instance of
+ * traceeval_iterator_next(). It is equivalent of calling:
+ *
+ * traceeval_query_size() with the keys returned by traceeval_iterator_next().
+ *
+ * Except that it will always quickly return the last entry, whereas the
+ * traceeval_query_size() will reset the cached next_entry and do a full
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

