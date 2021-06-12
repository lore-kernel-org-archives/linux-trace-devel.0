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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35BEC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1310613AA
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFLBsW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 21:48:22 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:47825 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhFLBsV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 21:48:21 -0400
Received: by mail-qv1-f74.google.com with SMTP id k12-20020a0cfd6c0000b029020df9543019so21207775qvs.14
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 18:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rrlxkzMGYbwZAawadCfXs+exPN694DZ/BrWu5hxPo+E=;
        b=QGVA4Zk0WCXJM+Tqngkn38btUfClYB8VHMVeYBms75BTjLNgo5Y7vN/dzNyYB7fWxl
         bbW+XlD1V+QQRxqtoMnZLkdPvT8M38MJ9g72sx571wMpcKtROZz0DWTKtun+1K9K+S8r
         Q48tb9kfyZxXQRrBNbG1w5O2r210+eiA8dpIWr/3V6QIwR3XxPgEo4NxhUvx2oKXPrxT
         9wExMLBDCyTQ8WdbXyClYbutBaCAAhebhc/MbSNjwnd1nJ7Wgb94T9Wl2yzfmOtwE6ft
         N9IMIUvdAhFk8rRYOVjPBPinUyrXsHqpx783+oQAKqiRrBGuRr2Ps6krJ4ET/0JmJCva
         w7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rrlxkzMGYbwZAawadCfXs+exPN694DZ/BrWu5hxPo+E=;
        b=NxUtlCbu4ZIeTa8HaoEOhBtq2RMnVPXByRqDQ58KrwAYra5NkZ1Y9NfhoEfGUiwNi/
         IT1rpXc+eYU9lKrQQ9bsL4MOXRPfSRqlFY+zuOXK66O+7+T0/MZxmSpBX1sf4wWgR6T+
         6yp2LtVriuraCVE3m2Z1qwgy20sabcgD2FiMNZA6DFOW/LZUpXTMKusqjoIqdE1+umoO
         VyXNrABxZiu6B6n2YscXsIe4RuTrb7txUbYNEEW+aiYxbpxz0NHy3N2WsX3ZqJprzdrI
         adIoPvfhH1MDMvL9Gj/1YjRavpZoUelQgH8lYAkXtaV9DZN3g45QCM6egEeF/gnNkQ0E
         DUeQ==
X-Gm-Message-State: AOAM530vCXXf/lXvlL+jJzxJGgd+U5gWKvyag6V0X+xfbR2ISo4ksXbh
        4StVMGAxgSA7/p6h6kcXJnhK1gGWAFVbY0VY+KFq2YkP2Kg103SYHmUoJZOgbSigNGYwgZdIVQ4
        ShOKIK/kG0JPCvnGJl/pJQN9lzJUvYJA6iZbGlEppCBFmPspND5Yftrjudoxm/SppU4pC1KiIcm
        NDSZM=
X-Google-Smtp-Source: ABdhPJyJeKGuAM+f+oC1mJwpEscGRjrSpA3wdi9MJJxOcozkLO6CN/X2NS+s/eRaLZ6WWILONg+O51Dk4KwQ
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:27c2:28ad:b3af:418a])
 (user=irogers job=sendgmr) by 2002:a05:6214:485:: with SMTP id
 ay5mr7805347qvb.6.1623462307598; Fri, 11 Jun 2021 18:45:07 -0700 (PDT)
Date:   Fri, 11 Jun 2021 18:45:00 -0700
In-Reply-To: <20210612014501.890593-1-irogers@google.com>
Message-Id: <20210612014501.890593-2-irogers@google.com>
Mime-Version: 1.0
References: <20210612014501.890593-1-irogers@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 1/2] libtraceevent: Add eof checks.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Claire Jensen <cjense@google.com>

Added checking for __read_char and peek_char to make sure value is not at end
of file.

Signed-off-by: Claire Jensen <cjense@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 62 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9915cb4..ac11887 100644
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
2.32.0.272.g935e593368-goog

