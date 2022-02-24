Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19DAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 03:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiBXDFL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 22:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBXDFK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 22:05:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676612465DD
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 19:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0250B614F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 03:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB9AC340E7
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 03:04:40 +0000 (UTC)
Date:   Wed, 23 Feb 2022 22:04:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Print version of file being read
Message-ID: <20220223220438.0797a6f8@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The print of the version is no longer done by default. This should be, but
was changed when moved to the libtracecmd, which now uses tracecmd_info()
to output it. But since default loglevel is TEP_LOG_CRITICAL it is not
displayed.

Set the default loglevel for tracecmd to TEP_LOG_INFO, as tracecmd is not
as noisy as the other libraries may be.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 lib/trace-cmd/trace-util.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ae3a9bbd01e1..b7f7c58fa90e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4168,7 +4168,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	tracecmd_info("version = %s\n", version);
+	tracecmd_info("version = %s", version);
 	ver = strtol(version, NULL, 10);
 	if (!ver && errno)
 		goto failed_read;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2cf8974ef4ee..91e8a30fb90b 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,7 +30,7 @@
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 static bool debug;
-static int log_level = TEP_LOG_CRITICAL;
+static int log_level = TEP_LOG_INFO;
 static FILE *logfp;
 
 const static struct {
-- 
2.34.1

