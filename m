Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7CCC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 03:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiLNDWs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 22:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiLNDWq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 22:22:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED5126EC
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 19:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73ECB80A1F
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 03:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602B6C433D2
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 03:22:40 +0000 (UTC)
Date:   Tue, 13 Dec 2022 22:22:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Be able to handle some sizeof() calls
Message-ID: <20221213222238.65a9c539@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Parse sizeof() for known types as well as fields.

 sizeof(int) is 4
 sizeof(unsigned int) is 4
 sizeof(long) is tep->long_size
 sizeof(unsigned long) is tep->long_size
 sizeof(long long) is 8
 sizeof(unsigned long long) is 8
 sizeof(REC->foo) is the field "foo" size value.

This will now parse the sample events of trace_events in the kernel.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 1aeed953a120..a85a720c203b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3509,6 +3509,85 @@ out_free:
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
+{
+	struct tep_format_field *field;
+	enum tep_event_type type;
+	char *token = NULL;
+	bool ok = false;
+	int ret;
+
+	type = read_token_item(&token);
+
+	arg->type = TEP_PRINT_ATOM;
+
+	/* We handle some sizeof types */
+	if (strcmp(token, "unsigned") == 0) {
+		free_token(token);
+		type = read_token_item(&token);
+
+		if (type == TEP_EVENT_ERROR)
+			goto error;
+
+		if (type != TEP_EVENT_ITEM)
+			ok = true;
+	}
+
+	if (ok || strcmp(token, "int") == 0) {
+		arg->atom.atom = strdup("4");
+
+	} else if (strcmp(token, "long") == 0) {
+		free_token(token);
+		type = read_token_item(&token);
+
+		if (token && strcmp(token, "long")) {
+			arg->atom.atom = strdup("8");
+		} else {
+			if (event->tep->long_size == 4)
+				arg->atom.atom = strdup("4");
+			else
+				arg->atom.atom = strdup("8");
+			/* The token is the next token */
+			ok = true;
+		}
+	} else if (strcmp(token, "REC") == 0) {
+
+		if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
+			goto error;
+		free_token(token);
+
+		if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+			goto error;
+
+		field = tep_find_any_field(event, token);
+		/* Can't handle arrays (yet) */
+		if (!field || field->flags & TEP_FIELD_IS_ARRAY)
+			goto error;
+
+		ret = asprintf(&arg->atom.atom, "%d", field->size);
+		if (ret < 0)
+			goto error;
+
+	} else if (!ok) {
+		goto error;
+	}
+
+	if (!ok) {
+		free_token(token);
+		type = read_token_item(tok);
+	}
+	if (test_type_token(type, token,  TEP_EVENT_DELIM, ")"))
+		goto error;
+
+	free_token(token);
+	return read_token_item(tok);
+error:
+	free_token(token);
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static enum tep_event_type
 process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
@@ -3568,6 +3647,10 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_builtin_expect(event, arg, tok);
 	}
+	if (strcmp(token, "sizeof") == 0) {
+		free_token(token);
+		return process_sizeof(event, arg, tok);
+	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-- 
2.35.1

