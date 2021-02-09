Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EE9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 00:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A07B64E9C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 00:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBIAgr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 19:36:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhBIAgp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 19:36:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6CA64EAA
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 00:36:03 +0000 (UTC)
Date:   Mon, 8 Feb 2021 19:36:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix create_recorder() path assignment
Message-ID: <20210208193601.13d2772a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The assignment of path was suppose to copy the dir variable that is returned
from tracefs_tracing_dir(), but instead the path copied itself.

This broke the communication between host and guest as well as networking.

Fixes: b8498696e0 ("trace-cmd: Use tracefs_tracing_dir() instead of tracefs_find_tracing_dir()")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a1c4e919..b05eef35 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3341,7 +3341,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			const char *dir = tracefs_tracing_dir();
 
 			if (dir)
-				path = strdup(path);
+				path = strdup(dir);
 		}
 		if (!path)
 			die("can't get the tracing directory");
-- 
2.25.4

