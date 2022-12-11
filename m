Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB95C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Dec 2022 00:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLKAKm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 19:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKAKl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 19:10:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAEE13F08
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 16:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7003B8094D
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 00:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13103C433D2
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 00:10:35 +0000 (UTC)
Date:   Sat, 10 Dec 2022 19:10:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_tracing_dir() mount test
Message-ID: <20221210191034.26a1b156@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_tracing_dir() test was broken. The pre-test setup already
called tracing_tracing_dir() and cached the value. When the mounting test
ran, it unmounted the tracefs directory, and then called the
tracefs_tracing_dir() again, which just returned the cached value, leaving
the tracefs file system unmounted. This had the test incorrectly pass, but
then broke the tests after that.

Add a check to make sure that the content in both the mounted tracefs
directory and the debugfs directory exists.

Fixes: e6daa60cca ("libtracefs: Add unit test to test mounting of tracefs_{tracing,debug}_dir()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index d1789a3d87f9..a5666e40cac4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -751,8 +751,10 @@ static void test_mounting(void)
 {
 	const char *tracing_dir;
 	const char *debug_dir;
+	struct stat st;
 	char *save_tracing = NULL;
 	char *save_debug = NULL;
+	char *path;
 	char *dir;
 	int ret;
 
@@ -797,6 +799,11 @@ static void test_mounting(void)
 		if (strncmp(tracing_dir, "/sys/kernel/", 12) != 0)
 			printf("Tracing directory mounted at '%s'\n",
 			       tracing_dir);
+
+		/* Make sure the directory has content.*/
+		asprintf(&path, "%s/trace", tracing_dir);
+		CU_TEST(stat(path, &st) == 0);
+		free(path);
 	}
 
 	/* Now mount debugfs dir, which should mount at /sys/kernel/debug */
@@ -807,6 +814,11 @@ static void test_mounting(void)
 		if (strcmp(debug_dir, DEBUGFS_DEFAULT_PATH) != 0)
 			printf("debug directory mounted at '%s'\n",
 			       debug_dir);
+
+		/* Make sure the directory has content.*/
+		asprintf(&path, "%s/tracing", debug_dir);
+		CU_TEST(stat(path, &st) == 0);
+		free(path);
 	}
 
 	if (save_debug)
@@ -2329,9 +2341,7 @@ void test_tracefs_lib(void)
 		return;
 	}
 
-	/* Must be first test */
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
-
 	CU_add_test(suite, "Follow events", test_follow_events);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
-- 
2.35.1

