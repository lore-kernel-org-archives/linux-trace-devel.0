Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E991DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 17:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiAXRhw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbiAXRhw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 12:37:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5661C06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 09:37:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642756134A
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 17:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD42C340E5;
        Mon, 24 Jan 2022 17:37:50 +0000 (UTC)
Date:   Mon, 24 Jan 2022 12:37:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, vt@altlinux.org
Subject: [PATCH] libtraceevent: Fix backward compatibility with
 tep_print_arg_string
Message-ID: <20220124123749.40a0c18b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

It appears that trace-cmd 2.9.6 referenced the tep_print_arg_string to
get to the offset, which was removed by libtraceevent commit 512d7be1
("libtraceevent: Add __rel_loc relative location attribute support").
Add the offset back to both tep_print_arg_string and to
tep_print_arg_bitmask (yeah, it adds a hole in the structure), for
backward compatibility.

Reported-by: Vitaly Chikunov <vt@altlinux.org>
Fixes: 512d7be1 ("libtraceevent: Add __rel_loc relative location attribute support")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215521
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h |  2 ++
 src/event-parse.c                | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 27cba06f55cb..68b2f4383b42 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -154,11 +154,13 @@ struct tep_print_arg_atom {
 
 struct tep_print_arg_string {
 	char			*string;
+	int			offset;		// for backward compatibility
 	struct tep_format_field	*field;
 };
 
 struct tep_print_arg_bitmask {
 	char			*bitmask;
+	int			offset;		// for backward compatibility
 	struct tep_format_field	*field;
 };
 
diff --git a/src/event-parse.c b/src/event-parse.c
index d3e43e5c11f8..2b346a5de16e 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3135,6 +3135,7 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 
 	arg->type = TEP_PRINT_STRING;
 	arg->string.string = token;
+	arg->string.offset = -1;
 	arg->string.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
@@ -3164,6 +3165,7 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 
 	arg->type = TEP_PRINT_BITMASK;
 	arg->bitmask.bitmask = token;
+	arg->bitmask.offset = -1;
 	arg->bitmask.field = NULL;
 
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
@@ -4444,8 +4446,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_TYPE:
 		break;
 	case TEP_PRINT_STRING: {
-		if (!arg->string.field)
+		if (!arg->string.field) {
 			arg->string.field = tep_find_any_field(event, arg->string.string);
+			arg->string.offset = arg->string.field->offset;
+		}
 		if (!arg->string.field)
 			break;
 		dynamic_offset_field(tep, arg->string.field, data, size, &offset, &len);
@@ -4459,8 +4463,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
 	case TEP_PRINT_BITMASK: {
-		if (!arg->bitmask.field)
+		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
+			arg->bitmask.offset = arg->bitmask.field->offset;
+		}
 		if (!arg->bitmask.field)
 			break;
 		dynamic_offset_field(tep, arg->bitmask.field, data, size, &offset, &len);
-- 
2.33.0

