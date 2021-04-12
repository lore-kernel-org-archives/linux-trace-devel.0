Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41515C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F304F6103D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbhDLTwV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 15:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238559AbhDLTwV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 15:52:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA21A610CE
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 19:52:02 +0000 (UTC)
Date:   Mon, 12 Apr 2021 15:52:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Clean up tep_parse_printk_formats()
 variables
Message-ID: <20210412155201.16c9f0a2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Just a simply clean up of the tep_parse_printk_formats().

Had done some debugging in this section, but found the bug elsewhere, but in
the mean time, I had rearranged the variables, and removed the unneeded
setting of "next" with NULL.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8d1ac65..732987a 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -931,11 +931,11 @@ void tep_print_printk(struct tep_handle *tep)
 int tep_parse_printk_formats(struct tep_handle *tep, const char *buf)
 {
 	unsigned long long addr;
+	char *addr_str;
 	char *copy;
 	char *printk;
 	char *line;
-	char *next = NULL;
-	char *addr_str;
+	char *next;
 	char *fmt;
 	int ret = -1;
 
-- 
2.29.2

