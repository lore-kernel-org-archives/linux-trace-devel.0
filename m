Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40A9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 03:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLTD0f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLTD0e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 22:26:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE9D103D
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Dec 2022 19:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC7EC60DD1
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 03:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AC8C433EF;
        Tue, 20 Dec 2022 03:26:31 +0000 (UTC)
Date:   Mon, 19 Dec 2022 22:26:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceevent: Fix string parsing
Message-ID: <20221219222630.54fc5bc5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The string parsing of tokens can be confused if the string has a backslash
at the end of the string. That is "\\\0" or \<nul>. The backslash will
skip the next character. If the next character is the end of the string,
it will read past the end of the string.

Check for end of buffer (less than or equal to 0), and if the next
character is the end of buffer, exit the loop regardless if the previous
character was a backslash.

Also fail the parsing of the event if the string is not terminated by the
quote that started it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index b37d81a89bf8..8167777fccd7 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1303,10 +1303,15 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 			if (ch == '\\' && last_ch == '\\')
 				last_ch = 0;
 			/* Break out if the file is corrupted and giving non print chars */
+			if (ch <= 0)
+				break;
 		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\' || ch == '\n');
 		/* remove the last quote */
 		i--;
 
+		if (ch <= 0)
+			type = TEP_EVENT_NONE;
+
 		/*
 		 * For strings (double quotes) check the next token.
 		 * If it is another string, concatinate the two.
-- 
2.35.1

