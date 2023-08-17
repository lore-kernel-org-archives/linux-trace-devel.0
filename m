Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F12EC678DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355698AbjHQWY2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355706AbjHQWYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A9530DF
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D357866A03
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A161C433CB;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000Usf-2e;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/9] libtraceeval: Add size checks to insert and query functions
Date:   Thu, 17 Aug 2023 18:24:20 -0400
Message-Id: <20230817222422.118568-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/traceeval-hist.h | 18 +++++++++++++-----
 src/histograms.c         | 10 +++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 38d5dc878d3b..81fe805e691d 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -186,15 +186,23 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 
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
diff --git a/src/histograms.c b/src/histograms.c
index 560046cc8d96..5e2e9200cbf6 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -675,8 +675,8 @@ fail:
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
@@ -928,9 +928,9 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
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

