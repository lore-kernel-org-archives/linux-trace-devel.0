Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064D6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Feb 2021 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA29E64E57
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Feb 2021 21:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhBPVA6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Feb 2021 16:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBPVA6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 16:00:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B9C64DFF
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 21:00:17 +0000 (UTC)
Date:   Tue, 16 Feb 2021 16:00:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add check to return of calloc() for tsync
Message-ID: <20210216160015.1bbb488a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The allocation of tsync is missing a check to make sure that the allocation
succeeded.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-tsync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 438c60bb..05a4beb3 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -255,6 +255,8 @@ const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
 #endif
 
 	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
+	if (!tsync)
+		goto error;
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
 	if (clock)
 		tsync->clock_str = strdup(clock);
-- 
2.25.4

