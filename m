Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2DFC04A94
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjHKFjz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjHKFjs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15E32D69
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B843659F9
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001B7C433AB;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsC-005uQR-04;
        Fri, 11 Aug 2023 01:39:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 14/17] libtraceeval histogram: Use stack for old copy in update
Date:   Fri, 11 Aug 2023 01:39:37 -0400
Message-Id: <20230811053940.1408424-15-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In the update, instead of using the heap, use the stack to save the old
values. This should save time where it does not need to allocate and then
free the value list to do an update.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 8c73d8cd9f45..643a550422f6 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -598,17 +598,23 @@ static int copy_traceeval_data(struct traceeval_type *type,
  *
  * Does not call release() if a copy() exists.
  */
-static void data_release(size_t size, union traceeval_data **data,
-				struct traceeval_type *type)
+static void data_release(size_t size, union traceeval_data *data,
+			 struct traceeval_type *type)
 {
 	for (size_t i = 0; i < size; i++) {
 		/* A copy should handle releases */
 		if (type[i].release && !type[i].copy)
-			type[i].release(&type[i], &(*data)[i]);
+			type[i].release(&type[i], &data[i]);
 
 		if (type[i].type == TRACEEVAL_TYPE_STRING)
-			free((*data)[i].string);
+			free(data[i].string);
 	}
+}
+
+static void data_release_and_free(size_t size, union traceeval_data **data,
+				struct traceeval_type *type)
+{
+	data_release(size, *data, type);
 	free(*data);
 	*data = NULL;
 }
@@ -642,7 +648,7 @@ static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
 	return 1;
 
 fail:
-	data_release(i, copy, type);
+	data_release_and_free(i, copy, type);
 	return -1;
 }
 
@@ -701,7 +707,7 @@ void traceeval_results_release(struct traceeval *teval,
 		return;
 	}
 
-	data_release(teval->nr_val_types, &results, teval->val_types);
+	data_release_and_free(teval->nr_val_types, &results, teval->val_types);
 }
 
 static struct entry *create_hist_entry(struct traceeval *teval,
@@ -757,7 +763,7 @@ static int create_entry(struct traceeval *teval,
 	return 0;
 
 fail:
-	data_release(teval->nr_key_types, &new_keys, teval->key_types);
+	data_release_and_free(teval->nr_key_types, &new_keys, teval->key_types);
 
 fail_stats:
 	free(entry->val_stats);
@@ -772,20 +778,34 @@ fail_entry:
  *
  * Frees the old vals field of @entry, unless an error occurs.
  *
- * Return 0 on success, -1 on error.
+ * Return 1 on success, -1 on error.
  */
 static int update_entry(struct traceeval *teval, struct entry *entry,
 			const union traceeval_data *vals)
 {
-	union traceeval_data *new_vals;
+	struct traceeval_stat *stats = entry->val_stats;
+	struct traceeval_type *types = teval->val_types;
+	union traceeval_data *copy = entry->vals;
+	union traceeval_data old[teval->nr_val_types];
+	size_t size = teval->nr_val_types;
+	size_t i;
 
-	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, entry->val_stats, &new_vals) == -1)
-		return -1;
+	if (!size)
+		return 1;
+
+	for (i = 0; i < size; i++) {
+		old[i] = copy[i];
+
+		if (copy_traceeval_data(types + i, stats + i,
+					vals + i, copy + i))
+			goto fail;
+	}
 
-	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
-	entry->vals = new_vals;
 	return 0;
+
+fail:
+	data_release(i, old, types);
+	return -1;
 }
 
 struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-- 
2.40.1

