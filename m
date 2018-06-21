Return-Path: <SRS0=aTL9=JH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933287AbeFUPrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jun 2018 11:47:23 -0400
Message-Id: <20180621154722.184300500@goodmis.org>
Date: Thu, 21 Jun 2018 11:43:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 3/5] trace-cmd: Move the Knuth functions out of trace-filter-hash.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-trace-cmd-Move-the-Knuth-functions-out-of-trace-filt.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that trace-filter-hash is part of the libtracecmd.a set, we can only
export functions that are of the "tracecmd_" prefix. We need to remove the
Knuth hash function helpers out of the include file. Since they are only
used by trace-filter-hash.c, move them there.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-filter-hash.h | 35 ---------------------------
 lib/trace-cmd/trace-filter-hash.c     | 35 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/trace-cmd/trace-filter-hash.h b/include/trace-cmd/trace-filter-hash.h
index e5b940750a00..cfc9115c15ce 100644
--- a/include/trace-cmd/trace-filter-hash.h
+++ b/include/trace-cmd/trace-filter-hash.h
@@ -48,39 +48,4 @@ static inline int filter_task_count(struct filter_id *hash)
 	return hash->count;
 }
 
-/*
- * Hashing functions, based on Donald E. Knuth's Multiplicative hashing.
- * See The Art of Computer Programming (TAOCP).
- */
-
-static inline uint8_t knuth_hash8(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^8.
-	 */
-	return UINT8_C(val) * UINT8_C(157);
-}
-
-static inline uint16_t knuth_hash16(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^16.
-	 */
-	return UINT16_C(val) * UINT16_C(40507);
-}
-
-static inline uint32_t knuth_hash(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^32.
-	 */
-	return val * UINT32_C(2654435761);
-}
-
 #endif /* _TRACE_FILTER_HASH_H */
diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
index 57029ae91c7b..8e75eb9cdd4d 100644
--- a/lib/trace-cmd/trace-filter-hash.c
+++ b/lib/trace-cmd/trace-filter-hash.c
@@ -28,6 +28,41 @@
 
 #define FILTER_HASH_SIZE	256
 
+/*
+ * Hashing functions, based on Donald E. Knuth's Multiplicative hashing.
+ * See The Art of Computer Programming (TAOCP).
+ */
+
+static inline uint8_t knuth_hash8(uint32_t val)
+{
+	/*
+	 * Multiplicative hashing function.
+	 * Multiplication by the Prime number, closest to the golden
+	 * ratio of 2^8.
+	 */
+	return UINT8_C(val) * UINT8_C(157);
+}
+
+static inline uint16_t knuth_hash16(uint32_t val)
+{
+	/*
+	 * Multiplicative hashing function.
+	 * Multiplication by the Prime number, closest to the golden
+	 * ratio of 2^16.
+	 */
+	return UINT16_C(val) * UINT16_C(40507);
+}
+
+static inline uint32_t knuth_hash(uint32_t val)
+{
+	/*
+	 * Multiplicative hashing function.
+	 * Multiplication by the Prime number, closest to the golden
+	 * ratio of 2^32.
+	 */
+	return val * UINT32_C(2654435761);
+}
+
 struct filter_id_item *
 filter_id_find(struct filter_id *hash, int id)
 {
-- 
2.17.1
