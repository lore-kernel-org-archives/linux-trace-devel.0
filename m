Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486D2C48BC2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 02:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB9B613C7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 02:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFXCtv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFXCtv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 22:49:51 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95004613C7
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Jun 2021 02:47:32 +0000 (UTC)
Date:   Wed, 23 Jun 2021 22:47:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Free "->" token in process_entry()
Message-ID: <20210623224730.6af93f6c@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Fixing an issue with parsing "(REC)->" when it expected "REC->", changed
the test of "->" to read into a "token" variable instead of just
"expecting" it. This was needed to test for the ")" case. But since it is
now read into a token, that token needs to be freed. But that was missed.

Free the token.

This was found by the libtracefs "make test_mem" tests.

Fixes: 62823da1 ("libtraceevent: Handle parsing of "(REC)->" case")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 94e2b90..de28b3b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2325,6 +2325,8 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
 		goto out_free;
 
+	free_token(token);
+
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 	field = token;
-- 
2.29.2

