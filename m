Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FF1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Mar 2022 00:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbiCTAZp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbiCTAZo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Mar 2022 20:25:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A523DDF7
        for <linux-trace-devel@vger.kernel.org>; Sat, 19 Mar 2022 17:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1515B80D35
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Mar 2022 00:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F91C340EC
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Mar 2022 00:24:19 +0000 (UTC)
Date:   Sat, 19 Mar 2022 20:24:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Optimize print format parsing of constants
Message-ID: <20220319202417.6f6608d1@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While debugging another issue, I found that there's no optimization of
operations in the print format for constants. That is, for example, the
sched_switch event has:

(REC->prev_state & ((((0x0000 | 0x0001 | 0x0002 | 0x0004 | 0x0008 | 0x0010 | 0x0020 | 0x0040) + 1) << 1) - 1))

Where it actually calculates the

(0x0000 | 0x0001 | 0x0002 | 0x0004 | 0x0008 | 0x0010 | 0x0020 | 0x0040) + 1) << 1) - 1)

at every event! instead of just testing against 255 (which it is
calculated to).

Add the calculation at the time the event print format is parsed.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 262bad26c976..bcca0af3148f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2144,6 +2144,120 @@ static int set_op_prio(struct tep_print_arg *arg)
 	return arg->op.prio;
 }
 
+static int consolidate_op_arg(struct tep_print_arg *arg)
+{
+	unsigned long long val, left, right;
+	int ret = 0;
+
+	if (arg->type != TEP_PRINT_OP)
+		return 0;
+
+	if (arg->op.left)
+		ret = consolidate_op_arg(arg->op.left);
+	if (ret < 0)
+		return ret;
+
+	if (arg->op.right)
+		ret = consolidate_op_arg(arg->op.right);
+	if (ret < 0)
+		return ret;
+
+	if (!arg->op.left || !arg->op.right)
+		return 0;
+
+	if (arg->op.left->type != TEP_PRINT_ATOM ||
+	    arg->op.right->type != TEP_PRINT_ATOM)
+		return 0;
+
+	/* Two atoms, we can do the operation now. */
+	left = strtoull(arg->op.left->atom.atom, NULL, 0);
+	right = strtoull(arg->op.right->atom.atom, NULL, 0);
+
+	switch (arg->op.op[0]) {
+	case '>':
+		switch (arg->op.op[1]) {
+		case '>':
+			val = left >> right;
+			break;
+		case '=':
+			val = left >= right;
+			break;
+		default:
+			val = left > right;
+			break;
+		}
+		break;
+	case '<':
+		switch (arg->op.op[1]) {
+		case '<':
+			val = left << right;
+			break;
+		case '=':
+			val = left <= right;
+			break;
+		default:
+			val = left < right;
+			break;
+		}
+		break;
+	case '&':
+		switch (arg->op.op[1]) {
+		case '&':
+			val = left && right;
+			break;
+		default:
+			val = left & right;
+			break;
+		}
+		break;
+	case '|':
+		switch (arg->op.op[1]) {
+		case '|':
+			val = left || right;
+			break;
+		default:
+			val = left | right;
+			break;
+		}
+		break;
+	case '-':
+		val = left - right;
+		break;
+	case '+':
+		val = left + right;
+		break;
+	case '*':
+		val = left * right;
+		break;
+	case '^':
+		val = left ^ right;
+		break;
+	case '/':
+		val = left / right;
+		break;
+	case '%':
+		val = left % right;
+		break;
+	case '=':
+		/* Only '==' is called here */
+		val = left == right;
+		break;
+	case '!':
+		/* Only '!=' is called here. */
+		val = left != right;
+		break;
+	default:
+		return 0;
+	}
+
+	free_arg(arg->op.left);
+	free_arg(arg->op.right);
+
+	arg->type = TEP_PRINT_ATOM;
+	free(arg->op.op);
+	return asprintf(&arg->atom.atom, "%lld", val) < 0 ? -1 : 0;
+}
+
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum tep_event_type
 process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
@@ -3506,6 +3620,10 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
 		if (type == TEP_EVENT_OP) {
 			type = process_op(event, arg, &token);
 			free_token(token);
+
+			if (consolidate_op_arg(arg) < 0)
+				type = TEP_EVENT_ERROR;
+
 			if (type == TEP_EVENT_ERROR) {
 				*list = NULL;
 				free_arg(arg);
-- 
2.35.1

