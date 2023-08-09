Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F56C001DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjHIDN0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjHIDNU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:13:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0B61FCD
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD25062EF8
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9E6C433C8;
        Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qTZdL-005Rvp-30;
        Tue, 08 Aug 2023 23:13:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/6] libtraceeval histograms: Add traceeval struct to compare function
Date:   Tue,  8 Aug 2023 23:13:11 -0400
Message-Id: <20230809031313.1298605-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809031313.1298605-1-rostedt@goodmis.org>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
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
first as they describe the "object", and the data should last as they are
the values of the function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 13 +++++++------
 src/histograms.c         | 18 ++++++++++--------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 996fcab1b92b..b3427c662d99 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -63,16 +63,17 @@ struct traceeval_dynamic {
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
index f35fccb1d4fe..3cf5c5389700 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -112,7 +112,8 @@ static int compare_traceeval_type(struct traceeval_type *orig,
  * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
  * -1 for the other way around, and -2 on error.
  */
-static int compare_traceeval_data(union traceeval_data *orig,
+static int compare_traceeval_data(struct traceeval *teval,
+				  union traceeval_data *orig,
 				  const union traceeval_data *copy,
 				  struct traceeval_type *type)
 {
@@ -128,7 +129,7 @@ static int compare_traceeval_data(union traceeval_data *orig,
 		return 1;
 
 	if (type->cmp)
-		return type->cmp(orig, copy, type);
+		return type->cmp(teval, type, orig, copy);
 
 	switch (type->type) {
 	case TRACEEVAL_TYPE_STRING:
@@ -166,7 +167,8 @@ static int compare_traceeval_data(union traceeval_data *orig,
  *
  * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
  */
-static int compare_traceeval_data_set(union traceeval_data *orig,
+static int compare_traceeval_data_set(struct traceeval *teval,
+				      union traceeval_data *orig,
 				      const union traceeval_data *copy,
 				      struct traceeval_type *defs, size_t size)
 {
@@ -175,7 +177,7 @@ static int compare_traceeval_data_set(union traceeval_data *orig,
 
 	/* compare data arrays */
 	for (i = 0; i < size; i++) {
-		if ((check = compare_traceeval_data(orig + i, copy + i, defs + i)))
+		if ((check = compare_traceeval_data(teval, orig + i, copy + i, defs + i)))
 			return check == -2 ? -1 : 1;
 	}
 
@@ -191,13 +193,13 @@ static int compare_entries(struct entry *orig, struct entry *copy,
 	int check;
 
 	/* compare keys */
-	check = compare_traceeval_data_set(orig->keys, copy->keys,
+	check = compare_traceeval_data_set(teval, orig->keys, copy->keys,
 			teval->key_types, teval->nr_key_types);
 	if (check)
 		return check;
 
 	/* compare values */
-	check = compare_traceeval_data_set(orig->vals, copy->vals,
+	check = compare_traceeval_data_set(teval, orig->vals, copy->vals,
 			teval->val_types, teval->nr_val_types);
 	return check;
 }
@@ -543,8 +545,8 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 	i = 0;
 	for (struct entry *entry = hist->map; i < hist->nr_entries;
 			entry = &hist->map[++i]) {
-		check = compare_traceeval_data_set(entry->keys, keys,
-				teval->key_types, teval->nr_key_types);
+		check = compare_traceeval_data_set(teval, entry->keys, keys,
+						   teval->key_types, teval->nr_key_types);
 
 		/* return entry if keys match */
 		if (!check) {
-- 
2.40.1

