Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE90C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5951E6108D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhFHV0J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234293AbhFHV0G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 17:26:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC3960FD8;
        Tue,  8 Jun 2021 21:24:13 +0000 (UTC)
Date:   Tue, 8 Jun 2021 17:24:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] libtraceevent: Handle parsing of "(REC)->" case
Message-ID: <20210608172411.318503bb@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a trace event wraps the special __entry variable to dereference it with
parenthesis, it shows up in the trace event format file wrapping the
"(REC)" as well. For example, the "func_repeats" event passed the __entry
into a helper macro in the TP_printk() portion, and the macro correctly
wrapped its parameter in parenthesis. This caused the output to show:

 "(((u64)(REC)->top_delta_ts << 32) | (REC)->bottom_delta_ts)"

The parser then failed to parse the "(REC)->" portion, as it expected the
"->" to appear directly after the "REC". This is not a requirement, and
the parser should be able to handle such cases.

Fixes: 6582b0a ("tools/events: Add files to create libtraceevent.a")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 97c1a97..1217491 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2311,8 +2311,19 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	char *field;
 	char *token;
 
-	if (read_expected(TEP_EVENT_OP, "->") < 0)
-		goto out_err;
+	type = read_token_item(&token);
+	/*
+	 * Check if REC happens to be surrounded by parenthesis, and
+	 * return if that's the case, as "(REC)->" is valid.
+	 * but return TEP_EVENT_ITEM.
+	 */
+	if (type == TEP_EVENT_DELIM && strcmp(token, ")") == 0) {
+		*tok = token;
+		return TEP_EVENT_ITEM;
+	}
+
+	if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
+		goto out_free;
 
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
@@ -2338,7 +2349,6 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 
  out_free:
 	free_token(token);
- out_err:
 	*tok = NULL;
 	return TEP_EVENT_ERROR;
 }
@@ -3033,6 +3043,17 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	if (type == TEP_EVENT_ERROR)
 		goto out_free;
 
+	/*
+	 * If REC is surrounded by parenthesis, the process_arg()
+	 * will return TEP_EVENT_ITEM with token == ")". In
+	 * this case, we need to continue processing the item
+	 * and return.
+	 */
+	if (type == TEP_EVENT_ITEM && strcmp(token, ")") == 0) {
+		free_token(token);
+		return process_entry(event, arg, tok);
+	}
+
 	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
 		goto out_free;
 
-- 
2.29.2

