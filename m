Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3ACC7619A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Mar 2023 20:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjCXUBx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjCXUBw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 16:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141931BDA
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 13:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF21B82426
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 20:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D7FC433A0;
        Fri, 24 Mar 2023 20:01:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pfnbe-001Ciz-31;
        Fri, 24 Mar 2023 16:01:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtraceevent: Fix double free in parsing sizeof()
Date:   Fri, 24 Mar 2023 16:01:43 -0400
Message-Id: <20230324200145.287158-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230324200145.287158-1-rostedt@goodmis.org>
References: <20230324200145.287158-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Google's fuzz testing caught a double free in process_sizeof(). If "ok" is
set, it means that token contains the last part of sizeof() (should be the
')'). Otherwise, the token contains the last item in the parenthesis of
sizeof(), and the next token needs to be read.

The problem is, in this case, the token is read into the token holder
"tok" and not to token. That means the next "free_token()" will free the
token that was already freed and what was just read.

Note, the "ok" variable is a horrible name and needs to be changed, but
that's outside the scope of this update.

Fixes: 2d0573af4dfda ("libtraceevent: Be able to handle some sizeof() calls")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index e655087dad60..2584b3605136 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3591,8 +3591,9 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	}
 
 	if (!ok) {
+		/* The token contains the last item before the parenthesis */
 		free_token(token);
-		type = read_token_item(event->tep, tok);
+		type = read_token_item(event->tep, &token);
 	}
 	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
 		goto error;
-- 
2.39.1

