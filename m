Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DDBC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 21:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44C264E4E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 21:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhBCVzO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 16:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhBCVzO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 16:55:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DB8564DA3
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Feb 2021 21:54:33 +0000 (UTC)
Date:   Wed, 3 Feb 2021 16:54:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix plist allocation check in trace-msg.c
Message-ID: <20210203165431.792152a4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The plist allocation check in get_trace_req_protos() returns error on a
successful allocation. Fix it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 8d2ed38d..611af2c1 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -981,7 +981,7 @@ static int get_trace_req_protos(char *buf, int length,
 	}
 
 	plist = calloc(1, sizeof(struct tracecmd_tsync_protos));
-	if (plist)
+	if (!plist)
 		goto error;
 	plist->names = calloc(count + 1, sizeof(char *));
 	if (!plist->names)
-- 
2.25.4

