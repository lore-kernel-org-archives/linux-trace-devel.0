Return-Path: <SRS0=01Tb=JF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39989 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937149AbeFSNXy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jun 2018 09:23:54 -0400
Received: by mail-wr0-f193.google.com with SMTP id l41-v6so20550003wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Jun 2018 06:23:53 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/2] trace-filter: Change the hashing function used when filtering
Date: Tue, 19 Jun 2018 16:22:59 +0300
Message-Id: <20180619132259.21387-2-y.karadz@gmail.com>
In-Reply-To: <20180619132259.21387-1-y.karadz@gmail.com>
References: <20180619132259.21387-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The hashing function used in trace-filter-hash is changed.
The new hashing functions is based on the Donald E. Knuth's
Multiplicative hashing, suggested in his book "The Art of
Computer Programming". This improves the performance, but
also removes the restrictions resulting  from using the
Paul Hsieh's super fast hash, published under the terms of
the GPL 2.0 license.

Paul Hsieh's hash function, defined in trace-hash-local.h,
is still used in trace-graph.c, trace-plot.c, trace-plot-cpu.c
and trace-plot-task.c. Because trace-hash-local.h is no longer
included in trace-filter-hash.h, it has to be included
explicitly in these four source files.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/include/trace-filter-hash.h | 37 +++++++++++++++++++++++-
 kernel-shark/trace-filter-hash.c         |  6 ++--
 kernel-shark/trace-graph.c               |  1 +
 kernel-shark/trace-plot-cpu.c            |  1 +
 kernel-shark/trace-plot-task.c           |  1 +
 kernel-shark/trace-plot.c                |  1 +
 6 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
index 5cc39dc..98c9ab3 100644
--- a/kernel-shark/include/trace-filter-hash.h
+++ b/kernel-shark/include/trace-filter-hash.h
@@ -20,7 +20,7 @@
 #ifndef _TRACE_FILTER_HASH_H
 #define _TRACE_FILTER_HASH_H
 
-#include "trace-hash-local.h"
+#include <stdint.h>
 
 struct filter_id_item {
 	struct filter_id_item	*next;
@@ -47,4 +47,39 @@ static inline int filter_task_count(struct filter_id *hash)
 	return hash->count;
 }
 
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
 #endif /* _TRACE_FILTER_HASH_H */
diff --git a/kernel-shark/trace-filter-hash.c b/kernel-shark/trace-filter-hash.c
index cf41250..703109c 100644
--- a/kernel-shark/trace-filter-hash.c
+++ b/kernel-shark/trace-filter-hash.c
@@ -30,7 +30,7 @@
 struct filter_id_item *
 filter_id_find(struct filter_id *hash, int id)
 {
-	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	int key = knuth_hash8(id);
 	struct filter_id_item *item = hash->hash[key];
 
 	while (item) {
@@ -44,7 +44,7 @@ filter_id_find(struct filter_id *hash, int id)
 
 void filter_id_add(struct filter_id *hash, int id)
 {
-	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	int key = knuth_hash8(id);
 	struct filter_id_item *item;
 
 	item = calloc(1, sizeof(*item));
@@ -59,7 +59,7 @@ void filter_id_add(struct filter_id *hash, int id)
 
 void filter_id_remove(struct filter_id *hash, int id)
 {
-	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	int key = knuth_hash8(id);
 	struct filter_id_item **next = &hash->hash[key];
 	struct filter_id_item *item;
 
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index b652297..1aba417 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -33,6 +33,7 @@
 #include "trace-graph.h"
 #include "trace-filter-hash.h"
 #include "trace-filter.h"
+#include "trace-hash-local.h"
 #include "trace-gui.h"
 
 #include "event-utils.h"
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index 8374809..d2a0523 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -22,6 +22,7 @@
 
 #include "trace-graph.h"
 #include "trace-local.h"
+#include "trace-hash-local.h"
 #include "cpu.h"
 
 struct cpu_plot_info {
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index 3b7e81f..c846221 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -23,6 +23,7 @@
 #include "trace-graph.h"
 #include "trace-filter.h"
 #include "trace-local.h"
+#include "trace-hash-local.h"
 
 #define RED 0xff
 #define GREEN (0xff<<16)
diff --git a/kernel-shark/trace-plot.c b/kernel-shark/trace-plot.c
index dc5b3af..bf2cec0 100644
--- a/kernel-shark/trace-plot.c
+++ b/kernel-shark/trace-plot.c
@@ -21,6 +21,7 @@
 #include <string.h>
 #include "trace-graph.h"
 #include "trace-local.h"
+#include "trace-hash-local.h"
 
 void trace_graph_plot_free(struct graph_info *ginfo)
 {
-- 
2.17.1
