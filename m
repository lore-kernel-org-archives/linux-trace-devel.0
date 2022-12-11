Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10172C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Dec 2022 01:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiLKBxd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 20:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKBxc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 20:53:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E99EA197
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 17:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD46A60C99
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 01:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08832C433D2
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 01:53:29 +0000 (UTC)
Date:   Sat, 10 Dec 2022 20:53:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix reading stats of read max test
Message-ID: <20221210205328.1f1f03ce@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The read max test checks the stats by running trace-cmd report --stat on
the file. The problem is that it left out the output file that was
created, and if the default file trace.dat does not exist, it fails to
read it. Unfortunately, if it does exist, it may give a false pass or
fail.

Fixes: 1f75010a2 ("trace-cmd: Add test for max size option of record")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index c72684ad53fc..69dcb4beb421 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -374,7 +374,7 @@ static void test_trace_record_max(void)
 			"sleep", "10", NULL);
 	CU_TEST(ret == 0);
 
-	ret = read_stats(TRACECMD_FILE, ".*bytes in size.*", "report", "--stat", NULL);
+	ret = read_stats(TRACECMD_FILE, ".*bytes in size.*", "report", TRACECMD_IN, "--stat", NULL);
 	CU_TEST(ret == 0);
 }
 
-- 
2.35.1

