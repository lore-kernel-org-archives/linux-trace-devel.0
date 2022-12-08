Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B485C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 16:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiLHQHu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 11:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiLHQHt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 11:07:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72275FC5
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 08:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E36A261FB7
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D0DC433CB;
        Thu,  8 Dec 2022 16:07:40 +0000 (UTC)
Date:   Thu, 8 Dec 2022 11:07:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH] libtracefs: Have tracefs_{tracing,debug}_dir() mount
 {tracefs,debugfs} if not mounted
Message-ID: <20221208110739.6b2015df@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

tracefs_tracing_dir() and tracefs_debug_dir() would try to mount the
directories if they were not already mounted. But this broke, fix it.

Link: https://lore.kernel.org/all/20221128132106.291101-1-beanhuo@iokpp.de/

Reported-by: Bean Huo <beanhuo@iokpp.de>
Fixes: 7c2b882ed1 ("libtracefs: Add tracefs_tracing_dir_is_mounted() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 777912e46821..d91ff40eee87 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -245,7 +245,7 @@ const char *tracefs_tracing_dir(void)
 	if (tracing_dir)
 		return tracing_dir;
 
-	tracing_dir = trace_find_tracing_dir(false);
+	tracing_dir = find_tracing_dir(false, true);
 	return tracing_dir;
 }
 
@@ -263,7 +263,7 @@ const char *tracefs_debug_dir(void)
 	if (debug_dir)
 		return debug_dir;
 
-	debug_dir = trace_find_tracing_dir(true);
+	debug_dir = find_tracing_dir(true, true);
 	return debug_dir;
 }
 
-- 
2.35.1

