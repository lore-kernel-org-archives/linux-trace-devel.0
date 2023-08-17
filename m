Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F70C2FC1A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347535AbjHQBdr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347557AbjHQBdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B2B2727
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB5264C30
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7BBC433B8;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N4c-2b;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 16/18] libtraceeval histogram: Have traceeval_query() just give the pointer to results
Date:   Wed, 16 Aug 2023 21:33:08 -0400
Message-Id: <20230817013310.88582-17-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of wasting allocation to return the results for queries,
especially since the query is likely not to modify the results, just give
a direct pointer to the entry->vals.

Mark it as const so (hopefully) nobody modifies it.

We still require the traceeval_results_release() to be called on it, as we
may in the future add a ref count to it and perhaps do a copy-on-write if
an update happens while something still has a hold on it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  4 ++--
 src/histograms.c         | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index fc1e288a43c6..37147d626fbb 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -161,10 +161,10 @@ int traceeval_insert(struct traceeval *teval,
 		     const union traceeval_data *vals);
 
 int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
-		    union traceeval_data **results);
+		    const union traceeval_data **results);
 
 void traceeval_results_release(struct traceeval *teval,
-			       union traceeval_data *results);
+			       const union traceeval_data *results);
 
 struct traceeval_stat *traceeval_stat(struct traceeval *teval,
 				      const union traceeval_data *keys,
diff --git a/src/histograms.c b/src/histograms.c
index c0f2248cce6f..c16b8866b84a 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -670,7 +670,7 @@ fail:
  * Returns 1 if found, 0 if not found, and -1 on error.
  */
 int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
-		    union traceeval_data **results)
+		    const union traceeval_data **results)
 {
 	struct entry *entry;
 	int check;
@@ -682,8 +682,8 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 	if ((check = get_entry(teval, keys, &entry)) < 1)
 		return check;
 
-	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-			entry->vals, NULL, results);
+	*results = entry->vals;
+	return 1;
 }
 
 /*
@@ -698,15 +698,13 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
  * allow traceeval to clean up its references.
  */
 void traceeval_results_release(struct traceeval *teval,
-			       union traceeval_data *results)
+			       const union traceeval_data *results)
 {
 	if (!teval || !results) {
 		if (!teval)
 			print_err("Results to be freed without accompanied traceeval instance!");
 		return;
 	}
-
-	data_release_and_free(teval->nr_val_types, &results, teval->val_types);
 }
 
 static struct entry *create_hist_entry(struct traceeval *teval,
-- 
2.40.1

