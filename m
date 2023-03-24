Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9665C76195
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Mar 2023 20:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCXUJa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCXUJ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 16:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A307158A0
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 13:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C2562C8B
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 20:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B6C433A0;
        Fri, 24 Mar 2023 20:09:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pfnj3-001CqI-1L;
        Fri, 24 Mar 2023 16:09:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 3/3] libtraceevent: Rename "ok" to "token_has_paren" in process_sizeof()
Date:   Fri, 24 Mar 2023 16:09:24 -0400
Message-Id: <20230324200924.287521-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230324200924.287521-1-rostedt@goodmis.org>
References: <20230324200924.287521-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The "ok" variable is set to true if at the end of the if/else blocks the
token contains the last element of "sizeof(..)", which would be that ")"
parenthesis. Calling it "ok" is meaningless and confusing.

Call the variable what it is for "token_has_paren". That will make the
logic much easier to understand.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 4a8b81c33a45..acf7fde4ead9 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3522,7 +3522,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 	struct tep_format_field *field;
 	enum tep_event_type type;
 	char *token = NULL;
-	bool ok = false;
+	bool token_has_paren = false;
 	int ret;
 
 	type = read_token_item(event->tep, &token);
@@ -3537,11 +3537,12 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		if (type == TEP_EVENT_ERROR)
 			goto error;
 
+		/* If it's not an item (like "long") then do not process more */
 		if (type != TEP_EVENT_ITEM)
-			ok = true;
+			token_has_paren = true;
 	}
 
-	if (ok || strcmp(token, "int") == 0) {
+	if (token_has_paren || strcmp(token, "int") == 0) {
 		arg->atom.atom = strdup("4");
 
 	} else if (strcmp(token, "long") == 0) {
@@ -3563,7 +3564,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 				goto error;
 			}
 			/* The token is the next token */
-			ok = true;
+			token_has_paren = true;
 		}
 	} else if (strcmp(token, "REC") == 0) {
 
@@ -3590,7 +3591,7 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		goto error;
 	}
 
-	if (!ok) {
+	if (!token_has_paren) {
 		/* The token contains the last item before the parenthesis */
 		free_token(token);
 		type = read_token_item(event->tep, &token);
-- 
2.39.1

