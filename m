Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284E1C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Dec 2022 01:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLKBRW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 20:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiLKBRU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 20:17:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0B413D25
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 17:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58FA460CF5
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 01:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F01C433D2
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 01:17:18 +0000 (UTC)
Date:   Sat, 10 Dec 2022 20:17:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Move follow events test after iterate raw
 events test
Message-ID: <20221210201714.59fa518f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The iterate raw events test tests error paths. On is passing in no
callbacks. But the code was changed where if there are follow events
attached to an instance that it is OK not to have a callback attached.
This means that the test of the follow events must be after the iterate
test, otherwise passing in a NULL callback will succeed, making the test
fail.

Move the follow events test after the iterate test.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a5666e40cac4..629cf2ba8c58 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2342,7 +2342,6 @@ void test_tracefs_lib(void)
 	}
 
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
-	CU_add_test(suite, "Follow events", test_follow_events);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
 	CU_add_test(suite, "trace cpu pipe",
@@ -2359,6 +2358,10 @@ void test_tracefs_lib(void)
 		    test_system_event);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
+
+	/* Follow events test must be after the iterate raw events above */
+	CU_add_test(suite, "Follow events", test_follow_events);
+
 	CU_add_test(suite, "tracefs_tracers API",
 		    test_tracers);
 	CU_add_test(suite, "tracefs_local events API",
-- 
2.35.1

