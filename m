Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FACC3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 04:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjAFEQu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 23:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAFEQt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 23:16:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A3631D
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 20:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4368061CCC
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 04:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677D9C433D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 04:16:46 +0000 (UTC)
Date:   Thu, 5 Jan 2023 23:16:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Flush pipe data in tracefs_cpu_flush()
Message-ID: <20230105231644.02c58967@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The flushing of the data read in the splice pipe was missing from
tracefs_cpu_flush(). It had a mysterious goto statement that went to the
next line?? Anyway, add the code to read the data still in the pipe.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 428bec0dfe3d..459c346c6017 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -464,10 +464,13 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 	if (tcpu->buffered < 0)
 		tcpu->buffered = 0;
 
-	if (tcpu->buffered)
-		goto do_read;
+	if (tcpu->buffered) {
+		ret = read(tcpu->splice_pipe[0], buffer, tcpu->subbuf_size);
+		if (ret > 0)
+			tcpu->buffered -= ret;
+		return ret;
+	}
 
- do_read:
 	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
 	if (ret > 0 && tcpu->buffered)
 		tcpu->buffered -= ret;
-- 
2.35.1

