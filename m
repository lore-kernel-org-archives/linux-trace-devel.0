Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851D0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 03:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiLNDTV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 22:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiLNDTU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 22:19:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E5D1146F
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 19:19:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB34B815C3
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 03:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C4EC433EF
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 03:19:16 +0000 (UTC)
Date:   Tue, 13 Dec 2022 22:19:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Allow function parameters to have operators
Message-ID: <20221213221913.0cc8e17c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

It is perfectly fine if a function parameter has operators. Parse them
properly.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8ec95a2ac069..1aeed953a120 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2570,19 +2570,31 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 
 	type = process_arg(event, field, &token);
 
-	if (test_type_token(type, token, TEP_EVENT_DELIM, next_token)) {
-		errno = EINVAL;
-		ret = -1;
-		free_arg(field);
-		goto out_free_token;
+	/* We do allow operators */
+	if (type == TEP_EVENT_OP) {
+		type = process_op(event, field, &token);
+
+		if (consolidate_op_arg(field) < 0)
+			type = TEP_EVENT_ERROR;
+
+		if (type == TEP_EVENT_ERROR)
+			goto out_error;
 	}
 
+	if (test_type_token(type, token, TEP_EVENT_DELIM, next_token))
+		goto out_error;
+
 	*print_arg = field;
 
 out_free_token:
 	free_token(token);
 
 	return ret;
+out_error:
+	errno = EINVAL;
+	ret = -1;
+	free_arg(field);
+	goto out_free_token;
 }
 
 static char *arg_eval (struct tep_print_arg *arg);
-- 
2.35.1

