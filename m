Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908ABC5320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355000AbjHQUsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355036AbjHQUsL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94E930D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5584B63B1E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3F8C433C8;
        Thu, 17 Aug 2023 20:48:08 +0000 (UTC)
Date:   Thu, 17 Aug 2023 16:48:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v4 00/20] libtraceeval histogram: Updates
Message-ID: <20230817164814.3ec51ab0@gandalf.local.home>
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 16:45:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Changes since v3: https://lore.kernel.org/all/20230817013310.88582-1-rostedt@goodmis.org/

The diff between this version and the last version:

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 8e5a6451f399..0cee9bcbeb83 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -83,8 +83,8 @@ typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
 				      const union traceeval_data *data);
 
 typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
-				      union traceeval_data *copy,
-				      const union traceeval_data *origin);
+				      union traceeval_data *dst,
+				      const union traceeval_data *src);
 
 typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
 				const union traceeval_data *Akeys,
diff --git a/src/histograms.c b/src/histograms.c
index f35d1b2e583d..96f0926f062c 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -500,65 +500,65 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
 }
 
 /*
- * Copy @orig to @copy with respect to @type.
+ * Copy @src to @dst with respect to @type.
  *
  * Return 0 on success, -1 on error.
  */
 static int copy_traceeval_data(struct traceeval_type *type,
 			       struct traceeval_stat *stat,
-			       const union traceeval_data *orig,
-			       union traceeval_data *copy)
+			       union traceeval_data *dst,
+			       const union traceeval_data *src)
 {
 	unsigned long long val;
 
 	if (type->copy)
-		return type->copy(type, copy, orig);
+		return type->copy(type, dst, src);
 
-	*copy = *orig;
+	*dst = *src;
 
 	switch(type->type) {
 	case TRACEEVAL_TYPE_NUMBER:
 		if (type->flags & TRACEEVAL_FL_SIGNED)
-			val = (long long)copy->number;
+			val = (long long)dst->number;
 		else
-			val = (unsigned long long)copy->number;
+			val = (unsigned long long)dst->number;
 		break;
 
 	case TRACEEVAL_TYPE_NUMBER_64:
 		if (type->flags & TRACEEVAL_FL_SIGNED)
-			val = (long long)copy->number_64;
+			val = (long long)dst->number_64;
 		else
-			val = (unsigned long long)copy->number_64;
+			val = (unsigned long long)dst->number_64;
 		break;
 
 	case TRACEEVAL_TYPE_NUMBER_32:
 		if (type->flags & TRACEEVAL_FL_SIGNED)
-			val = (long long)copy->number_32;
+			val = (long long)dst->number_32;
 		else
-			val = (unsigned long long)copy->number_32;
+			val = (unsigned long long)dst->number_32;
 		break;
 
 	case TRACEEVAL_TYPE_NUMBER_16:
 		if (type->flags & TRACEEVAL_FL_SIGNED)
-			val = (long long)copy->number_16;
+			val = (long long)dst->number_16;
 		else
-			val = (unsigned long long)copy->number_16;
+			val = (unsigned long long)dst->number_16;
 		break;
 
 	case TRACEEVAL_TYPE_NUMBER_8:
 		if (type->flags & TRACEEVAL_FL_SIGNED)
-			val = (long long)copy->number_8;
+			val = (long long)dst->number_8;
 		else
-			val = (unsigned long long)copy->number_8;
+			val = (unsigned long long)dst->number_8;
 		break;
 
 	case TRACEEVAL_TYPE_STRING:
-		copy->string = NULL;
+		dst->string = NULL;
 
-		if (orig->string)
-			copy->string = strdup(orig->string);
+		if (src->string)
+			dst->string = strdup(src->string);
 
-		if (!copy->string)
+		if (!dst->string)
 			return -1;
 		return 0;
 	default:
@@ -619,14 +619,14 @@ static void data_release_and_free(size_t size, union traceeval_data **data,
 }
 
 /*
- * Copy @orig to @copy with respect to @size and @type.
+ * Duplicate a traceeval_data @orig into an newly allocated @copy.
  *
  * Returns 1 on success, -1 on error.
  */
-static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
-				    const union traceeval_data *orig,
-				    struct traceeval_stat *stats,
-				    union traceeval_data **copy)
+static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
+				  struct traceeval_stat *stats,
+				  const union traceeval_data *orig,
+				  union traceeval_data **copy)
 {
 	size_t i;
 
@@ -640,7 +640,7 @@ static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
 
 	for (i = 0; i < size; i++) {
 		if (copy_traceeval_data(type + i, stats ? stats + i : NULL,
-					orig + i, (*copy) + i))
+					 (*copy) + i, orig + i))
 			goto fail;
 	}
 
@@ -745,13 +745,13 @@ static int create_entry(struct traceeval *teval,
 		goto fail_entry;
 
 	/* copy keys */
-	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				keys, NULL, &new_keys) == -1)
+	if (dup_traceeval_data_set(teval->nr_key_types, teval->key_types,
+				   NULL, keys, &new_keys) == -1)
 		goto fail_stats;
 
 	/* copy vals */
-	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
-				vals, entry->val_stats, &new_vals) == -1)
+	if (dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
+				   entry->val_stats, vals, &new_vals) == -1)
 		goto fail;
 
 	entry->keys = new_keys;
@@ -794,7 +794,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 		old[i] = copy[i];
 
 		if (copy_traceeval_data(types + i, stats + i,
-					vals + i, copy + i))
+					copy + i, vals + i))
 			goto fail;
 	}
 	data_release(size, old, types);
@@ -936,7 +936,7 @@ int traceeval_insert(struct traceeval *teval,
 
 /**
  * traceeval_remove - remove an item from the traceeval descriptor
- * @teval: The descriptor to insert into
+ * @teval: The descriptor to removed from
  * @keys: The list of keys that defines what is being removed
  *
  * This is the opposite of traceeval_insert(). Instead of inserting


-- Steve
