Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0B0C7EE25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 17:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjFGR1n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjFGR1l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 13:27:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194442109
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 10:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1C8063A0C
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 17:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4527C433D2;
        Wed,  7 Jun 2023 17:27:11 +0000 (UTC)
Date:   Wed, 7 Jun 2023 13:27:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd test: Close handle after opening
Message-ID: <20230607132710.4f642c78@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The unit tests opens a handle via tracecmd_open() but fails to close it
causing the memory leak detector to trigger on it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 69dcb4be..34fed1e1 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -438,6 +438,8 @@ static void test_trace_library_read(void)
 	ret = tracecmd_iterate_events(handle, NULL, 0, read_events, &data);
 	CU_TEST(ret == 0);
 
+	tracecmd_close(handle);
+
 	CU_TEST(data.counter > 0);
 	trace_seq_destroy(&data.seq);
 }
-- 
2.35.1

