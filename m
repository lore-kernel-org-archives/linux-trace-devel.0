Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE732C64EDA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355702AbjHQWY1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355698AbjHQWYT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B14B30C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3BAD6644D
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE5DC433C7;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000UsN-2M;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/9] libtraceeval: Add traceeval_iterator_stat()
Date:   Thu, 17 Aug 2023 18:24:16 -0400
Message-Id: <20230817222422.118568-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add traceeval_iterator_stat() that will return a stat of a value of the
current entry from a traceeval_iterator_next() loop.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  2 ++
 samples/task-eval.c      |  6 ++---
 src/histograms.c         | 47 ++++++++++++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 837a74f61a66..d511c9c5f14c 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -188,5 +188,7 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 			    const union traceeval_data **keys);
 int traceeval_iterator_query(struct traceeval_iterator *iter,
 			     const union traceeval_data **results);
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
index 4f603ce36c8c..fddd0f3587e2 100644
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
@@ -1336,3 +1342,26 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
 
 	return 1;
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

