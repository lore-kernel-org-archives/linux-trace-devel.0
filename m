Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB6FC04A95
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 13:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiI1N4v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiI1N4t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 09:56:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8C08FD63
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 06:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7766B820DB
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 13:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37695C433D7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 13:56:43 +0000 (UTC)
Date:   Wed, 28 Sep 2022 09:57:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Use result of fcntl(GETPIPE_SZ)
Message-ID: <20220928095753.54b6621c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

For some reason, I thought the arg to fcntl(fd, F_GETPIPE_SZ, &arg) would
give the pipe size. But the argument is completely ignored (I remember
testing this, and it worked :-/)

The return of the function is the pipe size. Use that if pipe_size is
untouched (which it ought to be) as the pipe size.

Fixes: a64fab23cec2 ("trace-cmd recorder: Use full pipe size in splice_data()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-recorder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index c7ef13c851d2..25c26def3784 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -204,7 +204,9 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		 * back to using page_size for splice(). It could also return
 		 * success, but not modify pipe_size.
 		 */
-		if (ret < 0 || !pipe_size)
+		if (ret > 0 && !pipe_size)
+			pipe_size = ret;
+		else if (ret < 0)
 			pipe_size = recorder->page_size;
 
 		recorder->pipe_size = pipe_size;
-- 
2.35.1

