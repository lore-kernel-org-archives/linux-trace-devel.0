Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2111BC7112F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355695AbjHQWY1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355708AbjHQWYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AF30E6
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5259A66D1D
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF8C433CC;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000UsQ-2Q;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/9] libtraceeval: Add traceeval_iterator_remove()
Date:   Thu, 17 Aug 2023 18:24:17 -0400
Message-Id: <20230817222422.118568-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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
 src/histograms.c         | 48 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index d511c9c5f14c..7d67673ce7e5 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -190,5 +190,6 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 			     const union traceeval_data **results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       struct traceeval_type *type);
+int traceeval_iterator_remove(struct traceeval_iterator *iter);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index fddd0f3587e2..0fbd9e0a353e 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1305,10 +1305,13 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
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
@@ -1338,6 +1341,9 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 		return 0;
 
 	entry = iter->entries[iter->next - 1];
+	if (!entry)
+		return 0;
+
 	*results = entry->vals;
 
 	return 1;
@@ -1363,5 +1369,39 @@ struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
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
+ * or -1 on error.
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
+
+	/* The entry no longer exists */
+	iter->entries[iter->next - 1] = NULL;
+	teval->update_counter++;
+
+	return 1;
 }
-- 
2.40.1

