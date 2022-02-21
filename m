Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E846C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 20:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiBUUor (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 15:44:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiBUUop (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 15:44:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355E237F1
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 12:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF3F610AA
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D0C340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:44:20 +0000 (UTC)
Date:   Mon, 21 Feb 2022 15:44:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Show what the failed expected tokens are
Message-ID: <20220221154418.2449fa19@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of just showing a very cryptic message of what enum type was
expected and failed during parsing, at least include the name of said
type.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 2b346a5..11557b1 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -114,6 +114,22 @@ void breakpoint(void)
 	x++;
 }
 
+static const char *get_event_type(enum tep_event_type type)
+{
+	switch (type) {
+	case TEP_EVENT_ERROR: return "ERROR";
+	case TEP_EVENT_NONE: return "NONE";
+	case TEP_EVENT_SPACE: return "SPACE";
+	case TEP_EVENT_NEWLINE: return "NEWLINE";
+	case TEP_EVENT_OP: return "OP";
+	case TEP_EVENT_DELIM: return "DELIM";
+	case TEP_EVENT_ITEM: return "ITEM";
+	case TEP_EVENT_DQUOTE: return "DQUOTE";
+	case TEP_EVENT_SQUOTE: return "SQUOTE";
+	}
+	return "(UNKNOWN)";
+}
+
 static struct tep_print_arg *alloc_arg(void)
 {
 	return calloc(1, sizeof(struct tep_print_arg));
@@ -1401,8 +1417,9 @@ static enum tep_event_type read_token_item(char **tok)
 static int test_type(enum tep_event_type type, enum tep_event_type expect)
 {
 	if (type != expect) {
-		do_warning("Error: expected type %d but read %d",
-		    expect, type);
+		do_warning("Error: expected type %d (%s) but read %d (%s)",
+			   expect, get_event_type(expect),
+			   type, get_event_type(type));
 		return -1;
 	}
 	return 0;
@@ -1412,8 +1429,9 @@ static int test_type_token(enum tep_event_type type, const char *token,
 		    enum tep_event_type expect, const char *expect_tok)
 {
 	if (type != expect) {
-		do_warning("Error: expected type %d but read %d",
-		    expect, type);
+		do_warning("Error: expected type %d (%s) but read %d (%s)",
+			   expect, get_event_type(expect),
+			   type, get_event_type(type));
 		return -1;
 	}
 
-- 
2.34.1

