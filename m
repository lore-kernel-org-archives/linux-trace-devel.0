Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44374C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D416113E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhFQTpt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 15:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhFQTpt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 15:45:49 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD0CC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 12:43:41 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id l15-20020a5e820f0000b02904bd1794d00eso2611520iom.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 12:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9LDbOaEM/a3Zk5QAnW9wytp6LFTh5fwBPEta0qyfK50=;
        b=djnP/IjMfGuifSAuqxZUXuEIKHzP3vVsAuPN5V/ufDlDj0CM86Ev4SUbyUVEshgf3m
         5hfV7jcnJTXNJd8eadsvKvKz3nYe6DGsjgyD6KywQ7uba+NDSy8AF1imMvuug1GHjXWg
         A8ZmeIU9lmj+oz8meCImEWuG2/c93w5y39pJyw7LeuCMjB4GK/mWICeSbJfqngtwoT/P
         nqeGn4r/YfMiBf14PeELvs7+ftkMalwNS7Kh3A4Sd4VYnxChUzBVg6/0BQWuqHFnSgFh
         WUcDz/kQvQS3FjxEivrStMLG6WaMuWk+pToph3UoLy5fIWYMKkbhXmtSwXE8LpgRlsh4
         5Jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9LDbOaEM/a3Zk5QAnW9wytp6LFTh5fwBPEta0qyfK50=;
        b=lyJIr2SmC9KrsZpz/PO/dfEjb0CcVAFgB/QDuRYUjDexmj1AjMuoN8hWAZBal47GPU
         D40MSVaItWD6y5KjsgkcR593QYr9WvJj5nObwCcJnt1X+QiHSrNSTze9df7KxSwCcqxA
         QJJXqj261htsyJau5GXj46UQdIEee8zwoQ41OPFz9GecTGC/tscCl6zVj4Vpv7aCOobO
         v1jxMrcCkJ1S0NqU8caCxv/jyRD0EJqV4f8K89CYe9CkRFuxfvVLq+A+K+e+/1EnqYek
         UjHs1FrYATs+ydXWLSvu4Gm0yR3Mq0gxvoaHewKpiQV2XfsmqAHyr14+1ftpaMsVi1uA
         wgBg==
X-Gm-Message-State: AOAM533QNL4x+RRjr57ViMeeJI8ZteIJLKQQyJZvCnrlySmVPiGmguSi
        IJyyXhb0pnNfpxZFKd0ztEFkadf1OJM=
X-Google-Smtp-Source: ABdhPJxvrWPoICOGYxorzH4NDpCEGJHaF7uhQz2VyB6IpqenRteYu+jFiACdnjFUJxbCJCff/To12bORbNM=
X-Received: from cjense.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:6d0])
 (user=cjense job=sendgmr) by 2002:a05:6638:140c:: with SMTP id
 k12mr6380617jad.126.1623959020777; Thu, 17 Jun 2021 12:43:40 -0700 (PDT)
Date:   Thu, 17 Jun 2021 19:43:25 +0000
Message-Id: <20210617194326.2107129-1-cjense@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 1/2] libtraceevent: Add eof checks.
From:   Claire Jensen <cjense@google.com>
To:     eranian@google.com, irogers@google.com, tz.stoyanov@gmail.com,
        linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     Claire Jensen <cjense@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added checking for __read_char and peek_char to make sure value is not at end
of file.

This issue was found while fuzz testing. One of the test cases created an infinite loop because __read_token had reached end of file. Checking was added to all cases where this may occur.

Signed-off-by: Claire Jensen <cjense@google.com>
---
 src/event-parse.c | 62 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 97c1a97..f454e23 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1155,17 +1155,16 @@ static enum tep_event_type force_token(const char *str, char **tok);
 static enum tep_event_type __read_token(char **tok)
 {
 	char buf[BUFSIZ];
-	int ch, last_ch, quote_ch, next_ch;
+	int ch, last_ch, quote_ch, next_ch, read_ch, peek_ch;
 	int i = 0;
 	int tok_size = 0;
 	enum tep_event_type type;
 
 	*tok = NULL;
 
-
-	ch = __read_char();
+        ch = __read_char();
 	if (ch < 0)
-		return TEP_EVENT_NONE;
+		goto out_eof_error;
 
 	type = get_type(ch);
 	if (type == TEP_EVENT_NONE)
@@ -1184,9 +1183,15 @@ static enum tep_event_type __read_token(char **tok)
 	case TEP_EVENT_OP:
 		switch (ch) {
 		case '-':
-			next_ch = peek_char();
+			peek_ch = peek_char();
+			if (peek_ch < 0)
+				goto out_eof_error;
+			next_ch = peek_ch;
 			if (next_ch == '>') {
-				buf[i++] = __read_char();
+				read_ch = __read_char();
+				if (read_ch < 0)
+					goto out_eof_error;
+				buf[i++] = read_ch;
 				break;
 			}
 			/* fall through */
@@ -1197,9 +1202,14 @@ static enum tep_event_type __read_token(char **tok)
 		case '<':
 			last_ch = ch;
 			ch = peek_char();
+			if (ch < 0)
+				goto out_eof_error;
 			if (ch != last_ch)
 				goto test_equal;
-			buf[i++] = __read_char();
+			read_ch = __read_char();
+			if (read_ch < 0)
+				goto out_eof_error;
+			buf[i++] = read_ch;
 			switch (last_ch) {
 			case '>':
 			case '<':
@@ -1219,10 +1229,17 @@ static enum tep_event_type __read_token(char **tok)
 		return type;
 
  test_equal:
-		ch = peek_char();
-		if (ch == '=')
-			buf[i++] = __read_char();
-		goto out;
+		peek_ch = peek_char();
+		if (peek_ch < 0)
+			goto out_eof_error;
+		ch = peek_ch;
+		if (ch == '=') {
+			read_ch = __read_char();
+			if (read_ch < 0)
+				goto out_eof_error;
+			buf[i++] = read_ch;
+			goto out;
+		}
 
 	case TEP_EVENT_DQUOTE:
 	case TEP_EVENT_SQUOTE:
@@ -1242,6 +1259,8 @@ static enum tep_event_type __read_token(char **tok)
 			}
 			last_ch = ch;
 			ch = __read_char();
+			if(ch < 0)
+				goto out_eof_error;
 			buf[i++] = ch;
 			/* the '\' '\' will cancel itself */
 			if (ch == '\\' && last_ch == '\\')
@@ -1259,6 +1278,8 @@ static enum tep_event_type __read_token(char **tok)
 
 			do {
 				ch = __read_char();
+				if(ch < 0)
+					return TEP_EVENT_NONE;
 			} while (isspace(ch));
 			if (ch == '"')
 				goto concat;
@@ -1273,7 +1294,13 @@ static enum tep_event_type __read_token(char **tok)
 		break;
 	}
 
-	while (get_type(peek_char()) == type) {
+	while (1) {
+		peek_ch = peek_char();
+		if (peek_ch < 0)
+			goto out_eof_error;
+		if (get_type(peek_ch) != type)
+			break;
+
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
 			tok_size += BUFSIZ;
@@ -1282,8 +1309,10 @@ static enum tep_event_type __read_token(char **tok)
 				return TEP_EVENT_NONE;
 			i = 0;
 		}
-		ch = __read_char();
-		buf[i++] = ch;
+		read_ch = __read_char();
+		if (read_ch < 0)
+			goto out_eof_error;
+		buf[i++] = read_ch;
 	}
 
  out:
@@ -1316,6 +1345,11 @@ static enum tep_event_type __read_token(char **tok)
 	}
 
 	return type;
+
+out_eof_error:
+	free(*tok);
+	*tok = NULL;
+	return TEP_EVENT_NONE;
 }
 
 static enum tep_event_type force_token(const char *str, char **tok)
-- 
2.32.0.288.g62a8d224e6-goog

