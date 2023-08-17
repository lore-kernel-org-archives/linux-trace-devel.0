Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE7AC64E96
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355015AbjHQUpz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354995AbjHQUp2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E73B30F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C53653B7
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD9AC43395;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000TpR-0v;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 07/20] libtraceeval histograms: Add traceeval struct to compare function
Date:   Thu, 17 Aug 2023 16:45:15 -0400
Message-Id: <20230817204528.114577-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
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

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 13 +++++++------
 src/histograms.c         | 31 ++++++++++++++++---------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 4c42c82ea045..d7ffe42f3231 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -63,16 +63,17 @@ union traceeval_data {
 };
 
 struct traceeval_type;
+struct traceeval;
 
 /* release function callback on traceeval_data */
-typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
-					  union traceeval_data *);
+typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
+					  union traceeval_data *data);
 
 /* compare function callback to compare traceeval_data */
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
index 030e417105d4..1ed677ac0e14 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -113,9 +113,10 @@ static int compare_traceeval_type(struct traceeval_type *orig,
  * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
  * -1 for the other way around, and -2 on error.
  */
-static int compare_traceeval_data(union traceeval_data *orig,
-				  const union traceeval_data *copy,
-				  struct traceeval_type *type)
+static int compare_traceeval_data(struct traceeval *teval,
+				  struct traceeval_type *type,
+				  union traceeval_data *orig,
+				  const union traceeval_data *copy)
 {
 	int i;
 
@@ -129,7 +130,7 @@ static int compare_traceeval_data(union traceeval_data *orig,
 		return 1;
 
 	if (type->cmp)
-		return type->cmp(orig, copy, type);
+		return type->cmp(teval, type, orig, copy);
 
 	switch (type->type) {
 	case TRACEEVAL_TYPE_STRING:
@@ -167,16 +168,17 @@ static int compare_traceeval_data(union traceeval_data *orig,
  *
  * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
  */
-static int compare_traceeval_data_set(union traceeval_data *orig,
-				      const union traceeval_data *copy,
-				      struct traceeval_type *defs, size_t size)
+static int compare_traceeval_data_set(struct traceeval *teval,
+				      struct traceeval_type *defs,
+				      union traceeval_data *orig,
+				      const union traceeval_data *copy, size_t size)
 {
 	int check;
 	size_t i;
 
 	/* compare data arrays */
 	for (i = 0; i < size; i++) {
-		if ((check = compare_traceeval_data(orig + i, copy + i, defs + i)))
+		if ((check = compare_traceeval_data(teval, defs + i, orig + i, copy + i)))
 			return check == -2 ? -1 : 0;
 	}
 
@@ -192,14 +194,14 @@ static int compare_entries(struct entry *orig, struct entry *copy,
 	int check;
 
 	/* compare keys */
-	check = compare_traceeval_data_set(orig->keys, copy->keys,
-			teval->key_types, teval->nr_key_types);
+	check = compare_traceeval_data_set(teval, teval->key_types,
+					   orig->keys, copy->keys, teval->nr_key_types);
 	if (check < 1)
 		return check;
 
 	/* compare values */
-	check = compare_traceeval_data_set(orig->vals, copy->vals,
-			teval->val_types, teval->nr_val_types);
+	check = compare_traceeval_data_set(teval, teval->val_types,
+					   orig->vals, copy->vals, teval->nr_val_types);
 	return check;
 }
 
@@ -546,9 +548,8 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 
 	hist = teval->hist;
 	for (i = 0, entry = hist->map; i < hist->nr_entries; entry = &hist->map[++i]) {
-		check = compare_traceeval_data_set(entry->keys, keys,
-				teval->key_types, teval->nr_key_types);
-
+		check = compare_traceeval_data_set(teval, teval->key_types,
+						   entry->keys, keys, teval->nr_key_types);
 		if (!check)
 			continue;
 		break;
-- 
2.40.1

