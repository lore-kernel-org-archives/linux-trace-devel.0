Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB069C0015E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 00:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbjHPADD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 20:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240648AbjHPACg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 20:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9051B10C0
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 17:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2508862761
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 00:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D523C433C7;
        Wed, 16 Aug 2023 00:02:34 +0000 (UTC)
Date:   Tue, 15 Aug 2023 20:02:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: [RFC][PATCH] libtraceeval: Add size checks to insert and query
 functions
Message-ID: <20230815200234.32fd17dd@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, there's nothing that checks the size of the keys/values being
passed into traceeval_query() and traceeval_insert(). Make functions that
take the size of those arrays:

   traceeval_query_size()
   traceeval_insert_size()

and convert the traceeval_query() and traceeval_insert() into macros that
calculate the size of the fields to pass in:

  #define traceeval_query(teval, keys, results) \
     traceeval_query_size(teval, sizeof(keys) / sizeof(keys[0]), results)

and this will allow the code to check to make sure the size matches what
is expected (note, that currently is not done, but can be added).

If the keys or vals is not an array, but instead a pointer, if one of the
macros is used, the compiler will complain with:

   warning: division sizeof (const struct traceeval_data *) / sizeof (const struct traceeval_data)
            does not compute the number of array elements [-Wsizeof-pointer-div]
  190 |                              sizeof(keys) / sizeof(keys[0]), results);

Then the user would need to call the "_size()" function directly
(as is done in the sample code, where the keys received by an iterator is
 used for a query)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

  This is an RFC patch. I wonder if we should have this to make the code more
  robust?

 include/traceeval-hist.h | 18 +++++++++++++-----
 samples/task-eval.c      |  2 +-
 src/histograms.c         | 10 +++++-----
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index d0bee7c02aa0..c8c27a51c62b 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -171,15 +171,23 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 
 void traceeval_release(struct traceeval *teval);
 
-int traceeval_insert(struct traceeval *teval,
-		     const struct traceeval_data *keys,
-		     const struct traceeval_data *vals);
+int traceeval_insert_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys,
+			  const struct traceeval_data *vals, size_t nr_vals);
+
+#define traceeval_insert(teval, keys, vals)				\
+	traceeval_insert_size(teval, keys, sizeof(keys) / sizeof(keys[0]), \
+			      vals, sizeof(vals) / sizeof(vals[0]))
 
 int traceeval_remove(struct traceeval *teval,
 		     const struct traceeval_data *keys);
 
-int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
-		    const struct traceeval_data **results);
+int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
+			 size_t nr_keys, const struct traceeval_data **results);
+
+#define traceeval_query(teval, keys, results)				\
+	traceeval_query_size(teval, keys,				\
+			     sizeof(keys) / sizeof(keys[0]), results);
 
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
diff --git a/samples/task-eval.c b/samples/task-eval.c
index c2950b2d64b0..4eaab7ad6e15 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -814,7 +814,7 @@ static void display_processes(struct traceeval *teval,
 		struct process_data *pdata = NULL;
 		const char *comm = keys[0].cstring;
 
-		ret = traceeval_query(teval_data, keys, &results);
+		ret = traceeval_query(teval_data, keys, 2, &results);
 		if (ret < 1)
 			continue; /* ?? */
 
diff --git a/src/histograms.c b/src/histograms.c
index a7d0643cfbbd..f71a2d557e34 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -669,8 +669,8 @@ fail:
  *
  * Returns 1 if found, 0 if not found, and -1 on error.
  */
-int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
-		    const struct traceeval_data **results)
+int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
+			 size_t nr_keys, const struct traceeval_data **results)
 {
 	struct entry *entry;
 	int check;
@@ -909,9 +909,9 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
  *
  * Returns 0 on success, and -1 on error.
  */
-int traceeval_insert(struct traceeval *teval,
-		     const struct traceeval_data *keys,
-		     const struct traceeval_data *vals)
+int traceeval_insert_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys,
+			  const struct traceeval_data *vals, size_t nr_vals)
 {
 	struct entry *entry;
 	int check;
-- 
2.40.1

