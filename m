Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A122C48BDF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jun 2021 02:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB1B661356
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jun 2021 02:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhFPC52 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhFPC52 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 22:57:28 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B050A61246
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jun 2021 02:55:22 +0000 (UTC)
Date:   Tue, 15 Jun 2021 22:55:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Do not print zero length dynamic strings
Message-ID: <20210615225520.517fe891@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a dynamic string happens to not have any length, which means that it
does not even have a null pointer, but the parsing code will still look at
the offset, and read the string at that location. If there's another
dynamic string after it, it will mistakenly report that next string as the
current one. This can be confusing, as the string being printed is not the
string expected.

Discovered this when playing with kprobes and exec arguments.

Fixes: ("tools/events: Add files to create libtraceevent.a")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 1217491..7a75e9b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4392,6 +4392,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		break;
 	case TEP_PRINT_STRING: {
 		int str_offset;
+		int len;
 
 		if (arg->string.offset == -1) {
 			struct tep_format_field *f;
@@ -4400,6 +4401,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			arg->string.offset = f->offset;
 		}
 		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
+		len = (str_offset >> 16) & 0xffff;
+		/* Do not attempt to save zero length dynamic strings */
+		if (!len)
+			break;
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
-- 
2.29.2

