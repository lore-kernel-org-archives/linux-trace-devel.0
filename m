Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174B1C388F9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 20:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC34D20727
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 20:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKWUeu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgKWUeu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 15:34:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E17420715
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 20:34:49 +0000 (UTC)
Date:   Mon, 23 Nov 2020 15:34:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tracefs utils: Do not free a the buffer on a zero size
 str_read_file()
Message-ID: <20201123153447.2e24c678@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a file has no size (nothing is read), then str_read_file() frees the
buffer and returns zero. The problem is that all callers of str_read_file()
uses the buffer supplied if the value returned is not a negative. This
causes the freed buffer being used by the callers if the file read existed
but had no content.

This is apparent when using a copy of the tracefs directory, where some file
exist, but have no content, then loading the events would cause a segfault.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracefs-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracefs-utils.c b/tracefs-utils.c
index 326b455..690506c 100644
--- a/tracefs-utils.c
+++ b/tracefs-utils.c
@@ -220,7 +220,7 @@ __hidden int str_read_file(const char *file, char **buffer)
 	} while (r > 0);
 
 	close(fd);
-	if (r == 0 && size > 0) {
+	if (r == 0) {
 		buf[size] = '\0';
 		*buffer = buf;
 	} else
-- 
2.25.4

