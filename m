Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37620C678DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355001AbjHQUqB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355000AbjHQUp3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18BA30F6
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFD8363950
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC2DC433CD;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000TpN-0r;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 06/20] libtraceeval histogram: Have cmp and release functions be generic
Date:   Thu, 17 Aug 2023 16:45:14 -0400
Message-Id: <20230817204528.114577-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Having the ability to override the compare function for a given type can
be very advantageous. There's also no reason that any type could ask for a
release callback to be called when the type is being released. It could be
used for information as well as for freeing.

Rename traceeval_dyn_cmp_fn to traceeval_data_cmp_fn and
 traceeval_dyn_release_fn to traceeval_data_release_fn and have
them take the union traceeval_type instead of struct traceeval_dynamic.

Also this changes the compare to pass a pointer to union traceeval_data
instead of passing in the structure of the dyn_data type.

In the structure, rename dyn_cmp to just cmp, and dyn_release to just
release.

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 50 +++++++++++++++++++++-------------------
 src/histograms.c         | 28 +++++++++++-----------
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index f6c4e8efb2be..4c42c82ea045 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -64,14 +64,14 @@ union traceeval_data {
 
 struct traceeval_type;
 
-/* struct traceeval_dynamic release function signature */
-typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
-					 struct traceeval_dynamic);
+/* release function callback on traceeval_data */
+typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
+					  union traceeval_data *);
 
-/* struct traceeval_dynamic compare function signature */
-typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
-				    struct traceeval_dynamic,
-				    struct traceeval_type *);
+/* compare function callback to compare traceeval_data */
+typedef int (*traceeval_data_cmp_fn)(const union traceeval_data *,
+				     const union traceeval_data *,
+				     struct traceeval_type *);
 
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
@@ -79,8 +79,8 @@ typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
  * @name: The string name of the traceeval_data
  * @flags: flags to describe the traceeval_data
  * @id: User specified identifier
- * @dyn_release: For dynamic types called on release (ignored for other types)
- * @dyn_cmp: A way to compare dynamic types (ignored for other types)
+ * @release: An optional callback for when the data is being released
+ * @cmp: An optional callback to specify a way to compare the type
  *
  * The traceeval_type structure defines expectations for a corresponding
  * traceeval_data instance for a traceeval histogram instance. Used to
@@ -91,29 +91,31 @@ typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
  * which each relate to distinct user defined struct traceeval_dynamic
  * 'sub-types'.
  *
- * For flexibility, @dyn_cmp() and @dyn_release() take a struct
- * traceeval_type instance. This allows the user to distinguish between
- * different sub-types of struct traceeval_dynamic within a single
- * callback function by examining the @id field. This is not a required
- * approach, merely one that is accommodated.
+ * For flexibility, @cmp() and @release() take a struct traceeval_type
+ * instance. This allows the user to handle dyn_data and pointer types.
+ * It may also be used for other types if the default cmp() or release()
+ * need to be overridden. Note for string types, even if the release()
+ * is called, the string freeing is still taken care of by the traceeval
+ * infrastructure.
  *
- * @dyn_cmp() is used to compare two struct traceeval_dynamic instances when a
- * corresponding struct traceeval_type is reached with its type field set to
- * TRACEEVAL_TYPE_DYNAMIC. It should return 0 on equality, 1 if the first
- * argument is greater than the second, -1 for the other way around, and -2 on
- * error.
+ * The @id field is a user specified field that may allow the same callback
+ * to be used by multiple types and not needing to do a strcmp() against the
+ * name (could be used for switch statements).
  *
- * dyn_release() is used during traceeval_release() to release a union
- * traceeval_data's struct traceeval_dynamic field when the corresponding
- * traceeval_type type is set to TRACEEVAL_TYPE_DYNAMIC.
+ * @cmp() is used to override the default compare of a type. This is
+ * required to compare dyn_data and pointer types. It should return 0
+ * on equality, 1 if the first argument is greater than the second,
+ * -1 for the other way around, and -2 on error.
+ *
+ * @release() is called when a data element is being released (or freed).
  */
 struct traceeval_type {
 	char				*name;
 	enum traceeval_data_type	type;
 	size_t				flags;
 	size_t				id;
-	traceeval_dyn_release_fn	dyn_release;
-	traceeval_dyn_cmp_fn		dyn_cmp;
+	traceeval_data_release_fn	release;
+	traceeval_data_cmp_fn		cmp;
 };
 
 /* Statistics about a given entry element */
diff --git a/src/histograms.c b/src/histograms.c
index 9b58416ad20c..030e417105d4 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -90,9 +90,9 @@ static int compare_traceeval_type(struct traceeval_type *orig,
 			return 0;
 		if (orig[i].id != copy[i].id)
 			return 0;
-		if (orig[i].dyn_release != copy[i].dyn_release)
+		if (orig[i].release != copy[i].release)
 			return 0;
-		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
+		if (orig[i].cmp != copy[i].cmp)
 			return 0;
 
 		// make sure both names are same type
@@ -128,6 +128,9 @@ static int compare_traceeval_data(union traceeval_data *orig,
 	if (!copy)
 		return 1;
 
+	if (type->cmp)
+		return type->cmp(orig, copy, type);
+
 	switch (type->type) {
 	case TRACEEVAL_TYPE_STRING:
 		i = strcmp(orig->string, copy->string);
@@ -149,8 +152,7 @@ static int compare_traceeval_data(union traceeval_data *orig,
 		compare_numbers_return(orig->number_8, copy->number_8);
 
 	case TRACEEVAL_TYPE_DYNAMIC:
-		if (type->dyn_cmp)
-			return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
+		/* If it didn't specify a cmp function, then punt */
 		return 0;
 
 	default:
@@ -236,8 +238,8 @@ static int compare_hist(struct traceeval *orig, struct traceeval *copy)
  *
  * This compares the values of the key definitions, value definitions, and
  * inserted data between @orig and @copy in order. It does not compare
- * by memory address, except for struct traceeval_type's dyn_release() and
- * dyn_cmp() fields.
+ * by memory address, except for struct traceeval_type's release() and
+ * cmp() fields.
  *
  * Returns 1 if @orig and @copy are the same, 0 if not, and -1 on error.
  */
@@ -438,14 +440,13 @@ fail:
  */
 static void clean_data(union traceeval_data *data, struct traceeval_type *type)
 {
+		if (type->release)
+			type->release(type, data);
+
 		switch (type->type) {
 		case TRACEEVAL_TYPE_STRING:
 			free(data->string);
 			break;
-		case TRACEEVAL_TYPE_DYNAMIC:
-			if (type->dyn_release)
-				type->dyn_release(type, data->dyn_data);
-			break;
 		default:
 			break;
 		}
@@ -465,9 +466,8 @@ static void clean_data_set(union traceeval_data *data, struct traceeval_type *de
 		return;
 	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; i++)
 		clean_data(data + i, defs + i);
-	}
 
 	free(data);
 }
@@ -512,7 +512,7 @@ static void hist_table_release(struct traceeval *teval)
  * it must call traceeval_release().
  *
  * This frees all internally allocated data of @teval and will call the
- * corresponding dyn_release() functions registered for keys and values of
+ * corresponding release() functions registered for keys and values of
  * type TRACEEVAL_TYPE_DYNAMIC.
  */
 void traceeval_release(struct traceeval *teval)
@@ -588,7 +588,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
 /*
  * Free @data with respect to @size and @type.
  *
- * Does not call dyn_release on type TRACEEVAL_TYPE_DYNAMIC.
+ * Does not call the release callback on the data.
  */
 static void data_release(size_t size, union traceeval_data **data,
 				struct traceeval_type *type)
-- 
2.40.1

