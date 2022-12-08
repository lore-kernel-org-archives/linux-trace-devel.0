Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8E6C3DA7B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 16:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLHQr0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 11:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLHQrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 11:47:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EE7AFCD2
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 08:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FD6761FE4
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD63C433F0;
        Thu,  8 Dec 2022 16:47:17 +0000 (UTC)
Date:   Thu, 8 Dec 2022 11:47:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH] libtracefs: Add unit test to test mounting of
 tracefs_{tracing,debug}_dir()
Message-ID: <20221208114716.3af0d147@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As there was a regression with the mounting of the tracefs and debugfs
file systems when tracefs_tracing_dir() and tracefs_debug_dir() were
called, add a unit test to make sure they continue to work.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-utils.c   |  3 +-
 utest/tracefs-utest.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index d91ff40eee87..ae249de06a39 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -85,7 +85,8 @@ static int mount_debugfs(void)
 	return ret;
 }
 
-static char *find_tracing_dir(bool debugfs, bool mount)
+/* Exported for testing purpose only */
+__hidden char *find_tracing_dir(bool debugfs, bool mount)
 {
 	char *debug_str = NULL;
 	char fspath[PATH_MAX+1];
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 010ff1d4a8fe..d1789a3d87f9 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -15,6 +15,8 @@
 #include <kbuffer.h>
 #include <pthread.h>
 
+#include <sys/mount.h>
+
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
@@ -47,6 +49,10 @@
 #define SQL_5_SQL	"select end.common_pid as pid, (end.common_timestamp.usecs - start.common_timestamp.usecs) as irq_lat from irq_disable as start join irq_enable as end on start.common_pid = end.common_pid, start.parent_offs == end.parent_offs where start.common_pid != 0"
 #define SQL_5_START	"irq_disable"
 
+#define DEBUGFS_DEFAULT_PATH "/sys/kernel/debug"
+#define TRACEFS_DEFAULT_PATH "/sys/kernel/tracing"
+#define TRACEFS_DEFAULT2_PATH "/sys/kernel/debug/tracing"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -740,6 +746,80 @@ static void test_follow_events(void)
 	test_instance_follow_events(test_instance);
 }
 
+extern char *find_tracing_dir(bool debugfs, bool mount);
+static void test_mounting(void)
+{
+	const char *tracing_dir;
+	const char *debug_dir;
+	char *save_tracing = NULL;
+	char *save_debug = NULL;
+	char *dir;
+	int ret;
+
+	/* First, unmount all instances of debugfs */
+	do {
+		dir = find_tracing_dir(true, false);
+		if (dir) {
+			ret = umount(dir);
+			CU_TEST(ret == 0);
+			if (ret < 0)
+				return;
+			/* Save the first instance that's not /sys/kernel/debug */
+			if (!save_debug && strcmp(dir, DEBUGFS_DEFAULT_PATH) != 0)
+				save_debug = dir;
+			else
+				free(dir);
+		}
+	} while (dir);
+
+	/* Next, unmount all instances of tracefs */
+	do {
+		dir = find_tracing_dir(false, false);
+		if (dir) {
+			ret = umount(dir);
+			CU_TEST(ret == 0);
+			if (ret < 0)
+				return;
+			/* Save the first instance that's not in /sys/kernel/ */
+			if (!save_tracing && strncmp(dir, "/sys/kernel/", 12) != 0)
+				save_tracing = dir;
+			else
+				free(dir);
+		}
+	} while (dir);
+
+	/* Mount first the tracing dir (which should mount at /sys/kernel/tracing */
+	tracing_dir = tracefs_tracing_dir();
+	CU_TEST(tracing_dir != NULL);
+	if (tracing_dir != NULL) {
+		CU_TEST(strcmp(tracing_dir, TRACEFS_DEFAULT_PATH) == 0 ||
+			strcmp(tracing_dir, TRACEFS_DEFAULT2_PATH) == 0);
+		if (strncmp(tracing_dir, "/sys/kernel/", 12) != 0)
+			printf("Tracing directory mounted at '%s'\n",
+			       tracing_dir);
+	}
+
+	/* Now mount debugfs dir, which should mount at /sys/kernel/debug */
+	debug_dir = tracefs_debug_dir();
+	CU_TEST(debug_dir != NULL);
+	if (debug_dir != NULL) {
+		CU_TEST(strcmp(debug_dir, DEBUGFS_DEFAULT_PATH) == 0);
+		if (strcmp(debug_dir, DEBUGFS_DEFAULT_PATH) != 0)
+			printf("debug directory mounted at '%s'\n",
+			       debug_dir);
+	}
+
+	if (save_debug)
+		mount("debugfs", save_debug, "debugfs", 0, NULL);
+
+	if (save_tracing &&
+	    (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
+		mount("tracefs", save_tracing, "tracefs", 0, NULL);
+
+	free(save_debug);
+	free(save_tracing);
+}
+
 static int read_trace_cpu_file(struct test_cpu_data *data)
 {
 	unsigned long long ts;
@@ -2248,6 +2328,10 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
+
+	/* Must be first test */
+	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
+
 	CU_add_test(suite, "Follow events", test_follow_events);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
-- 
2.35.1

