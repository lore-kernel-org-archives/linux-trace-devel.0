Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCCAC6FD1C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Mar 2023 20:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCXUBv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjCXUBu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 16:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC071BDA
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 13:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848D562AD3
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 20:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED235C433D2;
        Fri, 24 Mar 2023 20:01:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pfnbe-001Cj2-35;
        Fri, 24 Mar 2023 16:01:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtraceevent: No need for testing ok in else if (!ok) in process_sizeof()
Date:   Fri, 24 Mar 2023 16:01:44 -0400
Message-Id: <20230324200145.287158-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230324200145.287158-1-rostedt@goodmis.org>
References: <20230324200145.287158-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The if/else if logic in process_sizeof() has:

	if (ok || strcmp(token, "int") == 0) {
		[..]
	} else if (strcmp(token, "long") == 0) {
		[..]
	} else if (strcmp(token, "REC") == 0) {
		[..]
	} else if (!ok) {
		goto error;
	}

By the time we get to } else if (!ok) {, ok will always be false as if it
were true, it would enter the first if block.

Just make it end with:
	} else {
		goto error;
	}

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 2584b3605136..4a8b81c33a45 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3586,7 +3586,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		if (ret < 0)
 			goto error;
 
-	} else if (!ok) {
+	} else {
 		goto error;
 	}
 
-- 
2.39.1

