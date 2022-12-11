Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26348C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Dec 2022 00:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLKALW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 19:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKALV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 19:11:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED7813F05
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 16:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8247B8094D
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 00:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C32C433EF
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 00:11:17 +0000 (UTC)
Date:   Sat, 10 Dec 2022 19:11:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have tracefs_{tracing,debug}_dir() make sure
 it's still mounted
Message-ID: <20221210191112.749f045c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The test to test tracefs_tracing_dir() actually did not mount the
tracing_dir but only returned where it was mounted. This was because the
setup of the tests already called tracefs_tracing_dir() and set the static
variable to it. As the tracefs_tracing_dir() function already found the
mounted tracefs file system, it cached the location. The test unmounted
it, and then called tracefs_tracing_dir(), and since that returned a path,
the test assumed (incorrectly) that it was mounted.

Have tracefs_tracing_dir() and tracefs_debug_dir() check to make sure each
time that the cached directory is still mounted by checking for a
file/directory in it.

For tracefs, it checks to see if "trace" exists.

For debugfs, it checks to see if "tracing" exists.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-utils.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index ae249de06a39..9acf2ad61b16 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -230,6 +230,16 @@ int tracefs_set_tracing_dir(char *tracing_dir)
 	return 0;
 }
 
+/* Used to check if the directory is still mounted */
+static int test_dir(const char *dir, const char *file)
+{
+	char path[strlen(dir) + strlen(file) + 2];
+	struct stat st;
+
+	sprintf(path, "%s/%s", dir, file);
+	return stat(path, &st) < 0 ? 0 : 1;
+}
+
 /**
  * tracefs_tracing_dir - Get tracing directory
  *
@@ -240,10 +250,11 @@ const char *tracefs_tracing_dir(void)
 {
 	static const char *tracing_dir;
 
+	/* Do not check custom_tracing_dir */
 	if (custom_tracing_dir)
 		return custom_tracing_dir;
 
-	if (tracing_dir)
+	if (tracing_dir && test_dir(tracing_dir, "trace"))
 		return tracing_dir;
 
 	tracing_dir = find_tracing_dir(false, true);
@@ -261,7 +272,7 @@ const char *tracefs_debug_dir(void)
 {
 	static const char *debug_dir;
 
-	if (debug_dir)
+	if (debug_dir && test_dir(debug_dir, "tracing"))
 		return debug_dir;
 
 	debug_dir = find_tracing_dir(true, true);
-- 
2.35.1

