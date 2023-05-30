Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FCEC77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 04:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjE3EXU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 00:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjE3EXS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 00:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E557BE4
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 21:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A9A061161
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5341AC433EF
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 04:23:16 +0000 (UTC)
Date:   Tue, 30 May 2023 00:23:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Do not segfault in tests if synthetic events
 are not configured
Message-ID: <20230530002313.4094ef33@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If synthetic events are not configured in the kernel, the unit tests will
segfault and crash. Check if synthetic events exist and fail out nicely. The
tests will still fail if synthetic events are not configured, but they at least
will not crash.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 17fcac722fbc..9cfafdbd039c 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -994,7 +994,9 @@ static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent
 		stype = tracefs_dynevent_info(devents[i], NULL,
 					      &event, NULL, NULL, &format);
 		CU_TEST(stype == TRACEFS_DYNEVENT_SYNTH);
-		CU_TEST(strcmp(event, synth[i].name) == 0);
+		if (stype != TRACEFS_DYNEVENT_SYNTH)
+			continue;
+		CU_TEST(event && synth[i].name && strcmp(event, synth[i].name) == 0);
 		if (synth[i].match_name) {
 			CU_TEST(strstr(format, synth[i].match_name) != NULL);
 		}
-- 
2.39.2

