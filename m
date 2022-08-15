Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720B2C19F2C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Aug 2022 05:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiHPFM3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Aug 2022 01:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiHPFMJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Aug 2022 01:12:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B0F1CF5A4
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 14:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED0660F9F
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF657C433D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:19:40 +0000 (UTC)
Date:   Mon, 15 Aug 2022 17:19:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Close socket descriptor on failed connection
Message-ID: <20220815171947.57e919df@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In trace_vsock_open(), if the connection fails, the sd file descriptor
still needs to be closed.

Fixes: 76aaeb474 ("trace-cmd: Add VM kernel tracing over vsockets transport")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vsock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index 3bad9efad39a..baa310f7586b 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -19,8 +19,10 @@ int __hidden trace_vsock_open(unsigned int cid, unsigned int port)
 	if (sd < 0)
 		return -errno;
 
-	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr))) {
+		close(sd);
 		return -errno;
+	}
 
 	return sd;
 }
-- 
2.35.1

