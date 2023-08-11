Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C5CC0015E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjHKFjs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjHKFjq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EE62D4F
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A28641F4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C4C433CD;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uPr-2c;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 05/17] libtraceeval histograms: Add traceeval struct to compare function
Date:   Fri, 11 Aug 2023 01:39:28 -0400
Message-Id: <20230811053940.1408424-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When looking at how this code would be implemented, I found that I needed
access to the traceeval structure within the compare callbacks. Pass that
in too.

Also, rearrange the parameters a little. The traceeval and type should go
first as they describe the "object", and the data should go last as they are
the values of the function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 13 +++++++------
 src/histograms.c         | 19 ++++++++++---------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 22e9029133d5..412efdbe8681 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -63,16 +63,17 @@ union traceeval_data {
 };
 
 struct traceeval_type;
+struct traceeval;
 
 /* struct traceeval_dynamic release function signature */
-typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
-					  union traceeval_data *);
+typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
+					  union traceeval_data *data);
 
 /* struct traceeval_dynamic compare function signature */
-typedef int (*traceeval_data_cmp_fn)(const union traceeval_data *,
-				     const union traceeval_data *,
-				     struct traceeval_type *);
-
+typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
+				     const struct traceeval_type *type,
+				     const union traceeval_data *A,
+				     const union traceeval_data *B);
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
  * @type: The enum type that describes the traceeval_data
diff --git a/src/histograms.c b/src/histograms.c
index 09cdf57a8f6a..ece1395ac300 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -113,7 +113,8 @@ static int compare_traceeval_type(struct traceeval_type *orig,
  * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
  * -1 for the other way around, and -2 on error.
  */
-static int compare_traceeval_data(union traceeval_data *orig,
+static int compare_traceeval_data(struct traceeval *teval,
+				  union traceeval_data *orig,
 				  const union traceeval_data *copy,
 				  struct traceeval_type *type)
 {
@@ -129,7 +130,7 @@ static int compare_traceeval_data(union traceeval_data *orig,
 		return 1;
 
 	if (type->cmp)
-		return type->cmp(orig, copy, type);
+		return type->cmp(teval, type, orig, copy);
 
 	switch (type->type) {
 	case TRACEEVAL_TYPE_STRING:
@@ -167,7 +168,8 @@ static int compare_traceeval_data(union traceeval_data *orig,
  *
  * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
  */
-static int compare_traceeval_data_set(union traceeval_data *orig,
+static int compare_traceeval_data_set(struct traceeval *teval,
+				      union traceeval_data *orig,
 				      const union traceeval_data *copy,
 				      struct traceeval_type *defs, size_t size)
 {
@@ -176,7 +178,7 @@ static int compare_traceeval_data_set(union traceeval_data *orig,
 
 	/* compare data arrays */
 	for (i = 0; i < size; i++) {
-		if ((check = compare_traceeval_data(orig + i, copy + i, defs + i)))
+		if ((check = compare_traceeval_data(teval, orig + i, copy + i, defs + i)))
 			return check == -2 ? -1 : 0;
 	}
 
@@ -192,13 +194,13 @@ static int compare_entries(struct entry *orig, struct entry *copy,
 	int check;
 
 	/* compare keys */
-	check = compare_traceeval_data_set(orig->keys, copy->keys,
+	check = compare_traceeval_data_set(teval, orig->keys, copy->keys,
 			teval->key_types, teval->nr_key_types);
 	if (check < 1)
 		return check;
 
 	/* compare values */
-	check = compare_traceeval_data_set(orig->vals, copy->vals,
+	check = compare_traceeval_data_set(teval, orig->vals, copy->vals,
 			teval->val_types, teval->nr_val_types);
 	return check;
 }
@@ -546,9 +548,8 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 
 	hist = teval->hist;
 	for (i = 0, entry = hist->map; i < hist->nr_entries; entry = &hist->map[++i]) {
-		check = compare_traceeval_data_set(entry->keys, keys,
-				teval->key_types, teval->nr_key_types);
-
+		check = compare_traceeval_data_set(teval, entry->keys, keys,
+						   teval->key_types, teval->nr_key_types);
 		if (!check)
 			continue;
 		break;
-- 
2.40.1

