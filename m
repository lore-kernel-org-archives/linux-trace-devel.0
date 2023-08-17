Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21908C678DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355026AbjHQUp7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355005AbjHQUpa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62035B3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D94D56562F
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B89C4339A;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000Tph-1E;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 11/20] libtraceeval histogram: Label and check keys and values
Date:   Thu, 17 Aug 2023 16:45:19 -0400
Message-Id: <20230817204528.114577-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When initializing the traceeval descriptor, mark each key and value as
their type via the flags (keys get TRACEEVAL_FL_KEY and values get
TRACEEVAL_FL_VALUE) as well as adding the index of that key/value type of
the key/value data it represents. This will be used by the iterators for
sorting. The iterator will point to the key/value type and use that
information to know which key/value data to sort with.

The keys and values passed in will also be updated to have their flags
match the proper key/value type as well as the index. This will be useful
for traceeval_stat() that will take the type as a parameter, and use it to
figure out fast where the data is that is to be looked up.

All pointer and dynamic types in keys must have both a cmp and hash
function defined, otherwise they cannot be indexed or hashed. Add a check
to make sure all key types of pointer and dynamic have those functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 11 +++++---
 src/histograms.c         | 60 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 1edda56a712f..f80d039baa61 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -32,8 +32,10 @@ enum traceeval_data_type {
 
 /* Statistics specification flags */
 enum traceeval_flags {
-	TRACEEVAL_FL_SIGNED		= (1 << 0),
-	TRACEEVAL_FL_TIMESTAMP		= (1 << 1),
+	TRACEEVAL_FL_KEY		= (1 << 0),
+	TRACEEVAL_FL_VALUE		= (1 << 1),
+	TRACEEVAL_FL_SIGNED		= (1 << 2),
+	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
 };
 
 /*
@@ -120,6 +122,7 @@ struct traceeval_type {
 	char				*name;
 	enum traceeval_data_type	type;
 	size_t				flags;
+	size_t				index;
 	size_t				id;
 	traceeval_data_release_fn	release;
 	traceeval_data_cmp_fn		cmp;
@@ -142,8 +145,8 @@ struct traceeval;
 
 /* Histogram interfaces */
 
-struct traceeval *traceeval_init(const struct traceeval_type *keys,
-				 const struct traceeval_type *vals);
+struct traceeval *traceeval_init(struct traceeval_type *keys,
+				 struct traceeval_type *vals);
 
 void traceeval_release(struct traceeval *teval);
 
diff --git a/src/histograms.c b/src/histograms.c
index b1c6bb4fc990..4b4b559964d1 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -202,6 +202,44 @@ fail:
 	return -1;
 }
 
+static int check_keys(struct traceeval_type *keys)
+{
+	for (int i = 0; keys[i].type != TRACEEVAL_TYPE_NONE; i++) {
+		/* Define this as a key */
+		keys[i].flags |= TRACEEVAL_FL_KEY;
+		keys[i].flags &= ~TRACEEVAL_FL_VALUE;
+
+		keys[i].index = i;
+
+		switch (keys[i].type) {
+		case TRACEEVAL_TYPE_POINTER:
+		case TRACEEVAL_TYPE_DYNAMIC:
+			/*
+			 * Key pointers and dynamic types must have a
+			 * cmp and hash function
+			 */
+			if (!keys[i].cmp || !keys[i].hash)
+				return -1;
+			break;
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
+static int check_vals(struct traceeval_type *vals)
+{
+	for (int i = 0; vals[i].type != TRACEEVAL_TYPE_NONE; i++) {
+		/* Define this as a value */
+		vals[i].flags |= TRACEEVAL_FL_VALUE;
+		vals[i].flags &= ~TRACEEVAL_FL_KEY;
+
+		vals[i].index = i;
+	}
+	return 0;
+}
+
 /*
  * traceeval_init - create a traceeval descriptor
  * @keys: Defines the keys to differentiate traceeval entries
@@ -212,7 +250,12 @@ fail:
  * the "histogram". Note, both the @keys and @vals array must end with:
  * { .type = TRACEEVAL_TYPE_NONE }.
  *
- * The @keys and @vals passed in are copied for internal use.
+ * The @keys and @vals passed in are copied for internal use, but they are
+ * still modified to add the flags to denote their type (key or value) as
+ * well as the index into the keys or vals array respectively. This is
+ * to help speed up other operations that may need to know the index of
+ * the given type, and remove the burden from the user to make sure they
+ * are added.
  *
  * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
  * the name field must be a null-terminated string. Members of type
@@ -226,11 +269,12 @@ fail:
  *
  * Returns the descriptor on success, or NULL on error.
  */
-struct traceeval *traceeval_init(const struct traceeval_type *keys,
-				 const struct traceeval_type *vals)
+struct traceeval *traceeval_init(struct traceeval_type *keys,
+				 struct traceeval_type *vals)
 {
 	struct traceeval *teval;
 	char *err_msg;
+	int ret;
 
 	if (!keys)
 		return NULL;
@@ -247,6 +291,16 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
 		goto fail;
 	}
 
+	ret = check_keys(keys);
+	if (ret < 0)
+		goto fail_release;
+
+	if (vals) {
+		ret = check_vals(vals);
+		if (ret < 0)
+			goto fail_release;
+	}
+
 	/* alloc key types */
 	teval->nr_key_types = type_alloc(keys, &teval->key_types);
 	if (teval->nr_key_types <= 0) {
-- 
2.40.1

