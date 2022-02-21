Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D223AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 23:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiBUXNX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 18:13:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiBUXNW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 18:13:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A57E6566
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 15:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 094D261277
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 23:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0684C340E9;
        Mon, 21 Feb 2022 23:12:53 +0000 (UTC)
Date:   Mon, 21 Feb 2022 18:12:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] trace-cmd: Set the default file version to 7
Message-ID: <20220221181252.668433cf@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

All new trace.dat files should be set to version 7 by default. This will
allow for its use to be more common as we should not expect the user to
set to the latest version.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Note, I'll add this when all the changes are in for compression
and I'm satisfied with my testing.

 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 48f179d6f524..e48898fcf937 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -9,7 +9,7 @@
 #include <byteswap.h>
 #include "trace-cmd-private.h"
 
-#define FILE_VERSION_DEFAULT		6
+#define FILE_VERSION_DEFAULT		7
 
 /* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
-- 
2.34.1

