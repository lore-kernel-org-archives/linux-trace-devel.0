Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA32FC64ED5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355022AbjHQUp6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355007AbjHQUpa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE3B35BC
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 198E865C92
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D31C433BC;
        Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000Tq9-1j;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 18/20] libtraceeval histogram: Have traceeval_query() just give the pointer to results
Date:   Thu, 17 Aug 2023 16:45:26 -0400
Message-Id: <20230817204528.114577-19-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
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
index 490cfd2a51a2..4e0e9c057045 100644
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
index f9c52684b7dc..c008694b41b7 100644
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
 
-	return dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				      NULL, entry->vals, results);
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

