Return-Path: <SRS0=1RmU=JB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51297 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756434AbeFOVZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jun 2018 17:25:15 -0400
Received: by mail-wm0-f65.google.com with SMTP id r15-v6so5508588wmc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Jun 2018 14:25:14 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] trace-filter: Remove the Gtk dependency in trace-filter-hash.
Date: Sat, 16 Jun 2018 00:21:29 +0300
Message-Id: <20180615212131.28121-3-y.karadz@gmail.com>
In-Reply-To: <20180615212131.28121-1-y.karadz@gmail.com>
References: <20180615212131.28121-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

trace-filter-hash implements a set of hashing tools, used when
filtering the trace data. Removing the Gtk dependency will
simplify the usage of these tools from a user application.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/include/trace-filter-hash.h | 13 ++++---
 kernel-shark/trace-filter-hash.c         | 45 ++++++++++++------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
index e6973b9..ceb4ad9 100644
--- a/kernel-shark/include/trace-filter-hash.h
+++ b/kernel-shark/include/trace-filter-hash.h
@@ -20,23 +20,22 @@
 #ifndef _TRACE_FILTER_HASH_H
 #define _TRACE_FILTER_HASH_H
 
-#include <glib.h>
 #include "trace-hash-local.h"
 
 struct filter_task_item {
 	struct filter_task_item	*next;
-	gint			pid;
+	int			pid;
 };
 
 struct filter_task {
 	struct filter_task_item **hash;
-	gint			count;
+	int			count;
 };
 
 struct filter_task_item *
-filter_task_find_pid(struct filter_task *hash, gint pid);
-void filter_task_add_pid(struct filter_task *hash, gint pid);
-void filter_task_remove_pid(struct filter_task *hash, gint pid);
+filter_task_find_pid(struct filter_task *hash, int pid);
+void filter_task_add_pid(struct filter_task *hash, int pid);
+void filter_task_remove_pid(struct filter_task *hash, int pid);
 void filter_task_clear(struct filter_task *hash);
 struct filter_task *filter_task_hash_alloc(void);
 void filter_task_hash_free(struct filter_task *hash);
@@ -44,7 +43,7 @@ struct filter_task *filter_task_hash_copy(struct filter_task *hash);
 int *filter_task_pids(struct filter_task *hash);
 int filter_task_compare(struct filter_task *hash1, struct filter_task *hash2);
 
-static inline gint filter_task_count(struct filter_task *hash)
+static inline int filter_task_count(struct filter_task *hash)
 {
 	return hash->count;
 }
diff --git a/kernel-shark/trace-filter-hash.c b/kernel-shark/trace-filter-hash.c
index f3d0e16..36a1cdd 100644
--- a/kernel-shark/trace-filter-hash.c
+++ b/kernel-shark/trace-filter-hash.c
@@ -21,15 +21,16 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
+#include <assert.h>
 
 #include "trace-filter-hash.h"
 
 #define FILTER_TASK_HASH_SIZE	256
 
 struct filter_task_item *
-filter_task_find_pid(struct filter_task *hash, gint pid)
+filter_task_find_pid(struct filter_task *hash, int pid)
 {
-	gint key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
+	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
 	struct filter_task_item *task = hash->hash[key];
 
 	while (task) {
@@ -40,13 +41,13 @@ filter_task_find_pid(struct filter_task *hash, gint pid)
 	return task;
 }
 
-void filter_task_add_pid(struct filter_task *hash, gint pid)
+void filter_task_add_pid(struct filter_task *hash, int pid)
 {
-	gint key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
+	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
 	struct filter_task_item *task;
 
-	task = g_new0(typeof(*task), 1);
-	g_assert(task);
+	task = calloc(1, sizeof(*task));
+	assert(task);
 
 	task->pid = pid;
 	task->next = hash->hash[key];
@@ -55,9 +56,9 @@ void filter_task_add_pid(struct filter_task *hash, gint pid)
 	hash->count++;
 }
 
-void filter_task_remove_pid(struct filter_task *hash, gint pid)
+void filter_task_remove_pid(struct filter_task *hash, int pid)
 {
-	gint key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
+	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
 	struct filter_task_item **next = &hash->hash[key];
 	struct filter_task_item *task;
 
@@ -69,20 +70,20 @@ void filter_task_remove_pid(struct filter_task *hash, gint pid)
 	if (!*next)
 		return;
 
-	g_assert(hash->count);
+	assert(hash->count);
 	hash->count--;
 
 	task = *next;
 
 	*next = task->next;
 
-	g_free(task);
+	free(task);
 }
 
 void filter_task_clear(struct filter_task *hash)
 {
 	struct filter_task_item *task, *next;;
-	gint i;
+	int i;
 
 	for (i = 0; i < FILTER_TASK_HASH_SIZE; i++) {
 		next = hash->hash[i];
@@ -93,7 +94,7 @@ void filter_task_clear(struct filter_task *hash)
 		while (next) {
 			task = next;
 			next = task->next;
-			g_free(task);
+			free(task);
 		}
 	}
 
@@ -104,9 +105,10 @@ struct filter_task *filter_task_hash_alloc(void)
 {
 	struct filter_task *hash;
 
-	hash = g_new0(typeof(*hash), 1);
-	g_assert(hash);
-	hash->hash = g_new0(typeof(*hash->hash), FILTER_TASK_HASH_SIZE);
+	hash = calloc(1, sizeof(*hash));
+	assert(hash);
+	hash->hash = calloc(FILTER_TASK_HASH_SIZE, sizeof(*hash->hash));
+	hash->count = 0;
 
 	return hash;
 }
@@ -117,21 +119,21 @@ void filter_task_hash_free(struct filter_task *hash)
 		return;
 
 	filter_task_clear(hash);
-	g_free(hash->hash);
-	g_free(hash);
+	free(hash->hash);
+	free(hash);
 }
 
 struct filter_task *filter_task_hash_copy(struct filter_task *hash)
 {
 	struct filter_task *new_hash;
 	struct filter_task_item *task, **ptask;
-	gint i;
+	int i;
 
 	if (!hash)
 		return NULL;
 
 	new_hash = filter_task_hash_alloc();
-	g_assert(new_hash);
+	assert(new_hash);
 
 	for (i = 0; i < FILTER_TASK_HASH_SIZE; i++) {
 		task = hash->hash[i];
@@ -141,9 +143,8 @@ struct filter_task *filter_task_hash_copy(struct filter_task *hash)
 		ptask = &new_hash->hash[i];
 
 		while (task) {
-
-			*ptask = g_new0(typeof(*task), 1);
-			g_assert(*ptask);
+			*ptask = calloc(1, sizeof(*ptask));
+			assert(*ptask);
 			**ptask = *task;
 
 			ptask = &(*ptask)->next;
-- 
2.17.1
