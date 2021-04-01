Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAD6C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B838261008
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDARsM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236461AbhDARpC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:45:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C70936137F
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Apr 2021 16:23:30 +0000 (UTC)
Date:   Thu, 1 Apr 2021 12:23:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Hide all non API global functions
Message-ID: <20210401122327.5b39df93@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's several internal functions that are global to the library that
should not be visible as an API. Define the annotation "__hidden" to be
the visibility attribute to hide functions from the API. Also move the
defines of both "__hidden" and "__packed__" to trace-cmd-private.h as that
file is included in more places that trace-cmd-local.h.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  3 +++
 lib/trace-cmd/include/trace-cmd-local.h           |  2 --
 lib/trace-cmd/trace-hash.c                        | 11 ++++++-----
 lib/trace-cmd/trace-perf.c                        |  6 +++---
 lib/trace-cmd/trace-timesync.c                    |  4 ++--
 lib/trace-cmd/trace-util.c                        |  6 +++---
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fdca7494..3a6ca3f7 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -11,6 +11,9 @@
 #include "traceevent/event-parse.h"
 #include "trace-cmd/trace-cmd.h"
 
+#define __packed __attribute__((packed))
+#define __hidden __attribute__((visibility ("hidden")))
+
 #define TRACECMD_MAGIC { 23, 8, 68 }
 
 #define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index d265e4c8..0cd27441 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -12,8 +12,6 @@
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
-#define __packed __attribute__((packed))
-
 /* trace.dat file format version */
 #define FILE_VERSION 6
 
diff --git a/lib/trace-cmd/trace-hash.c b/lib/trace-cmd/trace-hash.c
index 47703153..bed97323 100644
--- a/lib/trace-cmd/trace-hash.c
+++ b/lib/trace-cmd/trace-hash.c
@@ -9,9 +9,10 @@
 #include <stdarg.h>
 #include <errno.h>
 
+#include "trace-cmd-private.h"
 #include "trace-hash.h"
 
-int trace_hash_init(struct trace_hash *hash, int buckets)
+int __hidden trace_hash_init(struct trace_hash *hash, int buckets)
 {
 	memset(hash, 0, sizeof(*hash));
 
@@ -27,12 +28,12 @@ int trace_hash_init(struct trace_hash *hash, int buckets)
 	return 0;
 }
 
-void trace_hash_free(struct trace_hash *hash)
+void __hidden trace_hash_free(struct trace_hash *hash)
 {
 	free(hash->buckets);
 }
 
-int trace_hash_empty(struct trace_hash *hash)
+int __hidden trace_hash_empty(struct trace_hash *hash)
 {
 	struct trace_hash_item **bucket;
 
@@ -42,7 +43,7 @@ int trace_hash_empty(struct trace_hash *hash)
 	return 1;
 }
 
-int trace_hash_add(struct trace_hash *hash, struct trace_hash_item *item)
+int __hidden trace_hash_add(struct trace_hash *hash, struct trace_hash_item *item)
 {
 	struct trace_hash_item *next;
 	int bucket = hash->power ? item->key & hash->power :
@@ -62,7 +63,7 @@ int trace_hash_add(struct trace_hash *hash, struct trace_hash_item *item)
 	return 1;
 }
 
-struct trace_hash_item *
+ __hidden struct trace_hash_item *
 trace_hash_find(struct trace_hash *hash, unsigned long long key,
 		trace_hash_func match, void *data)
 {
diff --git a/lib/trace-cmd/trace-perf.c b/lib/trace-cmd/trace-perf.c
index 2a24a244..a10da55d 100644
--- a/lib/trace-cmd/trace-perf.c
+++ b/lib/trace-cmd/trace-perf.c
@@ -44,7 +44,7 @@ static void default_perf_init_pe(struct perf_event_attr *pe)
  * Returns 0 on success, or -1 in case of an error.
  *
  */
-int trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
+int __hidden trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
 {
 	if (!perf)
 		return -1;
@@ -66,7 +66,7 @@ int trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
  *	  with trace_perf_open()
  *
  */
-void trace_perf_close(struct trace_perf *perf)
+void __hidden trace_perf_close(struct trace_perf *perf)
 {
 	if (perf->fd >= 0)
 		close(perf->fd);
@@ -85,7 +85,7 @@ void trace_perf_close(struct trace_perf *perf)
  * Returns 0 on success, or -1 in case of an error. In case of success, the
  * session must be closed with trace_perf_close()
  */
-int trace_perf_open(struct trace_perf *perf)
+int __hidden trace_perf_open(struct trace_perf *perf)
 {
 	perf->fd = syscall(__NR_perf_event_open, &perf->pe, perf->pid, perf->cpu, -1, 0);
 	if (perf->fd < 0)
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index ba877f70..a0b07f40 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -103,7 +103,7 @@ int tracecmd_tsync_proto_unregister(char *proto_name)
 	return -1;
 }
 
-bool tsync_proto_is_supported(const char *proto_name)
+bool __hidden tsync_proto_is_supported(const char *proto_name)
 {
 	if (tsync_proto_find(proto_name))
 		return true;
@@ -364,7 +364,7 @@ static int vsock_make(void)
 	return sd;
 }
 
-int vsock_get_port(int sd, unsigned int *port)
+int __hidden vsock_get_port(int sd, unsigned int *port)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 538adbc2..9e37b371 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -277,7 +277,7 @@ static void add_plugin_file(struct tep_handle *pevent, const char *path,
  *
  * Use trace_util_free_plugin_files() to free the result.
  */
-char **trace_util_find_plugin_files(const char *suffix)
+__hidden char **trace_util_find_plugin_files(const char *suffix)
 {
 	struct add_plugin_data pdata;
 
@@ -297,7 +297,7 @@ char **trace_util_find_plugin_files(const char *suffix)
  *
  * Frees the contents that were allocated by trace_util_find_plugin_files().
  */
-void trace_util_free_plugin_files(char **files)
+void __hidden trace_util_free_plugin_files(char **files)
 {
 	int i;
 
@@ -332,7 +332,7 @@ static char *get_source_plugins_dir(void)
 	return strdup(path);
 }
 
-struct tep_plugin_list*
+__hidden struct tep_plugin_list *
 trace_load_plugins(struct tep_handle *tep, int flags)
 {
 	struct tep_plugin_list *list;
-- 
2.29.2

