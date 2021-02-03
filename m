Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0D5C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E658964DF0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhBCWLI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 17:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232949AbhBCWLB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 17:11:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AD160234
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Feb 2021 22:10:20 +0000 (UTC)
Date:   Wed, 3 Feb 2021 17:10:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix SEGFAULT when no tsync_protos are supplied
Message-ID: <20210203171018.5b82a0a7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The make_trace_resp() function takes in a tsync_proto string to add to the
message being sent. But if NULL is passed in, the call to strncpy() will
crash.

Just set it to a empty string, and pass that instead.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-msg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 611af2c1..79c1b8a1 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -1248,6 +1248,9 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 {
 	int data_size;
 
+	if (!tsync_proto)
+		tsync_proto = "";
+
 	data_size = write_uints(NULL, 0, ports, nr_cpus);
 	msg->buf = malloc(data_size);
 	if (!msg->buf)
-- 
2.25.4

