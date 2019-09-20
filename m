Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA11C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F252080F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbfITPU0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388766AbfITPU0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:20:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B9B208C0;
        Fri, 20 Sep 2019 15:20:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iBKhs-0003p4-MP; Fri, 20 Sep 2019 11:20:24 -0400
Message-Id: <20190920152024.567157833@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 20 Sep 2019 11:15:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cmd: Make a global tracecmd_quick_hash() instead of a local
 knuth_hash()
References: <20190920151526.528126066@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As the 32 bit Knuth algorith produces the same results as the small
sizes[1], create a single algorithm that takes in a @bits parameter that
will return a masked result. And replace the local version of knuth_hash()
used by the trace-cmd filter code. This will also be used to remove other
copies of knuth_hash().

[1] https://lore.kernel.org/r/20190829114913.5df4ced9@gandalf.local.home

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-filter-hash.h | 24 ++++++++++++++++++++++++
 lib/trace-cmd/trace-filter-hash.c     | 20 +++++---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-filter-hash.h b/include/trace-cmd/trace-filter-hash.h
index e94bc87d1e1d..4111c41eeb2d 100644
--- a/include/trace-cmd/trace-filter-hash.h
+++ b/include/trace-cmd/trace-filter-hash.h
@@ -19,6 +19,30 @@ struct tracecmd_filter_id {
 	int				count;
 };
 
+/**
+ * tracecmd_quick_hash - A quick (non secured) hash alogirthm
+ * @val: The value to perform the hash on
+ * @bits: The size in bits you need to return
+ *
+ * This is a quick hashing function adapted from Donald E. Knuth's 32
+ * bit multiplicative hash.  See The Art of Computer Programming (TAOCP).
+ * Multiplication by the Prime number, closest to the golden ratio of
+ * 2^32.
+ *
+ * @bits is used to max the result for use cases that require
+ * a power of 2 return value that is less than 32 bits. Any value
+ * of @bits greater than 31 (or zero), will simply return the full hash on @val.
+ */
+static inline uint32_t tracecmd_quick_hash(uint32_t val, unsigned int bits)
+{
+	val *= UINT32_C(2654435761);
+
+	if (!bits || bits > 31)
+		return val;
+
+	return val & ((1 << bits) - 1);
+}
+
 struct tracecmd_filter_id_item *
   tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id);
 void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id);
diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
index 45ca68c2959e..f5f0fb09403b 100644
--- a/lib/trace-cmd/trace-filter-hash.c
+++ b/lib/trace-cmd/trace-filter-hash.c
@@ -12,23 +12,13 @@
 
 #include "trace-filter-hash.h"
 
-#define FILTER_HASH_SIZE	256
-
-static inline uint8_t knuth_hash(uint32_t val)
-{
-	/*
-	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
-	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
-	 * Multiplication by the Prime number, closest to the golden ratio of
-	 * 2^8.
-	 */
-	return UINT8_C(val) * UINT8_C(157);
-}
+#define FILTER_HASH_BITS	8
+#define FILTER_HASH_SIZE	(1 << FILTER_HASH_BITS)
 
 struct tracecmd_filter_id_item *
 tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash(id);
+	int key = tracecmd_quick_hash(id, FILTER_HASH_BITS);
 	struct tracecmd_filter_id_item *item = hash->hash[key];
 
 	while (item) {
@@ -42,7 +32,7 @@ tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 
 void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash(id);
+	int key = tracecmd_quick_hash(id, FILTER_HASH_BITS);
 	struct tracecmd_filter_id_item *item;
 
 	item = calloc(1, sizeof(*item));
@@ -57,7 +47,7 @@ void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
 
 void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash(id);
+	int key = tracecmd_quick_hash(id, FILTER_HASH_BITS);
 	struct tracecmd_filter_id_item **next = &hash->hash[key];
 	struct tracecmd_filter_id_item *item;
 
-- 
2.20.1


