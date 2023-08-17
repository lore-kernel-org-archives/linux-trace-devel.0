Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41B3C64ED4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354994AbjHQUp5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354991AbjHQUp1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA16830E1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E30963F31
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50F7C433CC;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000TpB-0b;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 03/20] libtraceeval: Rename copy_traceeval_data_set() to dup_traceeval_data()
Date:   Thu, 17 Aug 2023 16:45:11 -0400
Message-Id: <20230817204528.114577-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The name "copy_traceveal_data_set()" is misleading. It's actually
duplicating the data. The difference is that it allocates a new data
element and does not "copy" it. This is considered a "dup" and not a copy.
This makes it more in line of "strdup()".

It also removes the association of the order of the parameters, as when
something is being allocated, it usually comes at the end.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 071e30e73768..9b58416ad20c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -602,13 +602,13 @@ static void data_release(size_t size, union traceeval_data **data,
 }
 
 /*
- * Copy @orig to @copy with respect to @size and @type.
+ * Duplicate a traceeval_data @orig into an newly allocated @copy.
  *
  * Returns 1 on success, -1 on error.
  */
-static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
-				    const union traceeval_data *orig,
-				    union traceeval_data **copy)
+static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
+				  const union traceeval_data *orig,
+				  union traceeval_data **copy)
 {
 	size_t i;
 
@@ -662,8 +662,8 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
 	/* find key and copy its corresponding value pair */
 	if ((check = get_entry(teval, keys, &entry)) < 1)
 		return check;
-	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-			entry->vals, results);
+	return dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				      entry->vals, results);
 }
 
 /*
@@ -704,13 +704,13 @@ static int create_entry(struct traceeval *teval,
 	struct hist_table *hist = teval->hist;
 
 	/* copy keys */
-	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				keys, &new_keys) == -1)
+	if (dup_traceeval_data_set(teval->nr_key_types, teval->key_types,
+				   keys, &new_keys) == -1)
 		return -1;
 
 	/* copy vals */
-	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, &new_vals) == -1)
+	if (dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				   vals, &new_vals) == -1)
 		goto fail_vals;
 
 	/* create new entry */
@@ -743,8 +743,8 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 {
 	union traceeval_data *new_vals;
 
-	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, &new_vals) == -1)
+	if (dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				   vals, &new_vals) == -1)
 		return -1;
 
 	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
-- 
2.40.1

