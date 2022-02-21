Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70473C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 20:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiBUUS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 15:18:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiBUUSy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 15:18:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADE4E25
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 12:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39E460FF5
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1689C340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:18:29 +0000 (UTC)
Date:   Mon, 21 Feb 2022 15:18:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Account for events with newlines in print fmt
Message-ID: <20220221151828.2fd4d104@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

Some events in the kernel have a newline in the print fmt. Even though
that really is a bug in the kernel, libtraceevent should also be able
to handle it when it does happen.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
diff --git a/src/event-parse.c b/src/event-parse.c
index 2b346a5..7a84789 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1248,7 +1248,7 @@ static enum tep_event_type __read_token(char **tok)
 			if (ch == '\\' && last_ch == '\\')
 				last_ch = 0;
 			/* Break out if the file is corrupted and giving non print chars */
-		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\');
+		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\' || ch == '\n');
 		/* remove the last quote */
 		i--;
 
